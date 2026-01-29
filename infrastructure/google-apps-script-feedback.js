// English ABCs - Feedback Form Handler
// This script receives feedback submissions and stores them in Google Sheets

// ========== CONFIGURATION ==========
// Set your email address here to receive notifications
var NOTIFICATION_EMAIL = 'your-email@example.com'; // CHANGE THIS!
var SEND_NOTIFICATIONS = true; // Set to false to disable email notifications
// ===================================

function doPost(e) {
  try {
    // Parse incoming data
    var data = JSON.parse(e.postData.contents);

    // Validate required fields
    if (!data.overall_rating || !data.ease_of_use || !data.child_engagement ||
        !data.learning_value || !data.recommend) {
      return createResponse({
        status: 'error',
        message: 'Missing required fields'
      }, 400);
    }

    // Get or create the sheet
    var sheet = getOrCreateSheet();

    // Prepare row data with proper timezone handling
    var timestamp = data.timestamp ? new Date(data.timestamp) : new Date();
    var row = [
      Utilities.formatDate(timestamp, Session.getScriptTimeZone(), 'yyyy-MM-dd HH:mm:ss'),
      sanitize(data.language || ''),
      sanitize(data.overall_rating || ''),
      sanitize(data.ease_of_use || ''),
      sanitize(data.child_engagement || ''),
      sanitize(data.learning_value || ''),
      sanitize(data.child_enjoyed || ''),
      Array.isArray(data.issues) ? data.issues.map(sanitize).join(', ') : '',
      sanitize(data.issue_details || ''),
      sanitize(data.suggestions || ''),
      sanitize(data.recommend || ''),
      sanitize(data.other_comments || '')
    ];

    // Append the row
    sheet.appendRow(row);

    // Log success
    Logger.log('Feedback submitted successfully at ' + timestamp);

    // Send email notification
    if (SEND_NOTIFICATIONS) {
      try {
        sendEmailNotification(data, timestamp);
      } catch (emailError) {
        // Log email error but don't fail the submission
        Logger.log('Email notification failed: ' + emailError.toString());
      }
    }

    // Return success response with CORS headers
    return createResponse({
      status: 'success',
      message: 'Thank you for your feedback!'
    }, 200);

  } catch (error) {
    // Log error for debugging
    Logger.log('Error: ' + error.toString());

    // Return error response with CORS headers
    return createResponse({
      status: 'error',
      message: 'An error occurred. Please try again.'
    }, 500);
  }
}

function doGet(e) {
  return createResponse({
    status: 'ok',
    message: 'English ABCs Feedback API is running.'
  }, 200);
}

// Helper function to get or create the feedback sheet
function getOrCreateSheet() {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheetName = 'Feedback Responses';
  var sheet = ss.getSheetByName(sheetName);

  // Create sheet if it doesn't exist
  if (!sheet) {
    sheet = ss.insertSheet(sheetName);

    // Add headers
    var headers = [
      'Timestamp',
      'Language',
      'Overall Rating',
      'Ease of Use',
      'Child Engagement',
      'Learning Value',
      'Child Enjoyed Most',
      'Issues Encountered',
      'Issue Details',
      'Suggestions',
      'Would Recommend',
      'Other Comments'
    ];

    sheet.appendRow(headers);

    // Format header row
    var headerRange = sheet.getRange(1, 1, 1, headers.length);
    headerRange.setFontWeight('bold');
    headerRange.setBackground('#4CAF50');
    headerRange.setFontColor('#FFFFFF');

    // Freeze header row
    sheet.setFrozenRows(1);

    // Auto-resize columns
    for (var i = 1; i <= headers.length; i++) {
      sheet.autoResizeColumn(i);
    }
  }

  // Check if headers exist (in case sheet was manually cleared)
  if (sheet.getLastRow() === 0) {
    var headers = [
      'Timestamp',
      'Language',
      'Overall Rating',
      'Ease of Use',
      'Child Engagement',
      'Learning Value',
      'Child Enjoyed Most',
      'Issues Encountered',
      'Issue Details',
      'Suggestions',
      'Would Recommend',
      'Other Comments'
    ];
    sheet.appendRow(headers);
  }

  return sheet;
}

// Helper function to create response with CORS headers
function createResponse(data, statusCode) {
  var output = ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);

  // Add CORS headers to allow requests from your website
  return output;
}

// Helper function to sanitize input (prevent injection attacks)
function sanitize(input) {
  if (typeof input !== 'string') {
    return String(input);
  }

  // Remove any potential formula injection attempts
  if (input.charAt(0) === '=' || input.charAt(0) === '+' ||
      input.charAt(0) === '-' || input.charAt(0) === '@') {
    return "'" + input; // Prefix with single quote to make it text
  }

  // Limit length to prevent abuse
  return input.substring(0, 10000);
}

// Helper function to send email notification
function sendEmailNotification(data, timestamp) {
  if (!NOTIFICATION_EMAIL || NOTIFICATION_EMAIL === 'your-email@example.com') {
    Logger.log('Email notification skipped: No valid email configured');
    return;
  }

  // Create readable labels for ratings
  var overallStars = '⭐'.repeat(parseInt(data.overall_rating) || 0);
  var engagementEmojis = ['😞', '😕', '😐', '😊', '😍'];
  var engagementDisplay = engagementEmojis[parseInt(data.child_engagement) - 1] || data.child_engagement;

  // Format issues array
  var issuesText = 'None reported';
  if (Array.isArray(data.issues) && data.issues.length > 0) {
    if (data.issues.includes('no_issues')) {
      issuesText = '✓ No issues';
    } else {
      issuesText = data.issues.join(', ');
    }
  }

  // Determine language for subject line
  var langLabel = data.language === 'en' ? 'English' : '中文';

  // Build email subject
  var subject = '📝 New Feedback: English ABCs (' + overallStars + ' - ' + langLabel + ')';

  // Build email body
  var body = 'New feedback received for English ABCs closed testing!\n\n';
  body += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
  body += '⏰ SUBMITTED: ' + Utilities.formatDate(timestamp, Session.getScriptTimeZone(), 'yyyy-MM-dd HH:mm:ss') + '\n';
  body += '🌐 LANGUAGE: ' + langLabel + '\n';
  body += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n';

  body += '📊 RATINGS:\n';
  body += '  • Overall Experience: ' + overallStars + ' (' + data.overall_rating + '/5)\n';
  body += '  • Ease of Use: ' + (data.ease_of_use || 'N/A') + '\n';
  body += '  • Child Engagement: ' + engagementDisplay + ' (' + data.child_engagement + '/5)\n';
  body += '  • Learning Value: ' + (data.learning_value || 'N/A') + '\n';
  body += '  • Would Recommend: ' + (data.recommend || 'N/A') + '\n\n';

  body += '🐛 TECHNICAL ISSUES:\n';
  body += '  ' + issuesText + '\n';
  if (data.issue_details && data.issue_details.trim()) {
    body += '  Details: ' + data.issue_details.trim() + '\n';
  }
  body += '\n';

  body += '💬 FEEDBACK:\n';
  if (data.child_enjoyed && data.child_enjoyed.trim()) {
    body += '  What child enjoyed:\n  ' + data.child_enjoyed.trim() + '\n\n';
  }
  if (data.suggestions && data.suggestions.trim()) {
    body += '  Suggestions for improvement:\n  ' + data.suggestions.trim() + '\n\n';
  }
  if (data.other_comments && data.other_comments.trim()) {
    body += '  Other comments:\n  ' + data.other_comments.trim() + '\n\n';
  }

  body += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n';
  body += '📊 View all responses:\n';
  body += SpreadsheetApp.getActiveSpreadsheet().getUrl() + '\n';
  body += '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n';
  body += 'English ABCs - Feedback Handler\n';
  body += '李之茗外師 | www.englishteacher.com.tw\n';

  // Send the email
  MailApp.sendEmail({
    to: NOTIFICATION_EMAIL,
    subject: subject,
    body: body
  });

  Logger.log('Email notification sent to: ' + NOTIFICATION_EMAIL);
}
