// English ABCs - Feedback Form Handler
// This script receives feedback submissions and stores them in Google Sheets

// ========== CONFIGURATION ==========
// Set your email address here to receive daily digest
var NOTIFICATION_EMAIL = 'rich.dipp@gmail.com';
var SEND_DAILY_DIGEST = true; // Set to false to disable daily digest emails
var DIGEST_TIME_HOUR = 20; // Hour to send digest (0-23, in your timezone). 20 = 8:00 PM
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

    // Note: Email notifications are sent as daily digest
    // No immediate email sent to avoid inbox flooding

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
      'Other Comments',
      'Emailed'
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
      'Other Comments',
      'Emailed'
    ];
    sheet.appendRow(headers);
  }

  return sheet;
}

// Function to send daily digest email
// This should be triggered once per day via a time-based trigger
function sendDailyDigest() {
  if (!SEND_DAILY_DIGEST) {
    Logger.log('Daily digest disabled in configuration');
    return;
  }

  if (!NOTIFICATION_EMAIL || NOTIFICATION_EMAIL === 'your-email@example.com') {
    Logger.log('Daily digest skipped: No valid email configured');
    return;
  }

  var sheet = getOrCreateSheet();
  var lastRow = sheet.getLastRow();

  if (lastRow <= 1) {
    Logger.log('No feedback submissions to send');
    return;
  }

  // Get all data
  var data = sheet.getDataRange().getValues();
  var headers = data[0];

  // Find the "Emailed" column index
  var emailedColIndex = headers.indexOf('Emailed');
  if (emailedColIndex === -1) {
    Logger.log('Error: Emailed column not found');
    return;
  }

  // Find new submissions (where Emailed column is empty)
  var newSubmissions = [];
  for (var i = 1; i < data.length; i++) {
    if (!data[i][emailedColIndex]) {
      newSubmissions.push({
        rowIndex: i + 1, // +1 because sheet rows are 1-indexed
        data: data[i]
      });
    }
  }

  if (newSubmissions.length === 0) {
    Logger.log('No new feedback since last digest');
    return;
  }

  // Build digest email
  var subject = '📊 Daily Feedback Digest: English ABCs (' + newSubmissions.length + ' new)';
  var body = buildDigestEmail(newSubmissions, headers);

  // Send email
  try {
    MailApp.sendEmail({
      to: NOTIFICATION_EMAIL,
      subject: subject,
      body: body
    });

    // Mark submissions as emailed
    for (var i = 0; i < newSubmissions.length; i++) {
      sheet.getRange(newSubmissions[i].rowIndex, emailedColIndex + 1)
        .setValue(new Date());
    }

    Logger.log('Daily digest sent: ' + newSubmissions.length + ' submissions to ' + NOTIFICATION_EMAIL);
  } catch (error) {
    Logger.log('Failed to send daily digest: ' + error.toString());
  }
}

// Helper function to build digest email body
function buildDigestEmail(submissions, headers) {
  var now = new Date();
  var dateStr = Utilities.formatDate(now, Session.getScriptTimeZone(), 'EEEE, MMMM d, yyyy');

  var body = 'English ABCs - Feedback Digest\n';
  body += dateStr + '\n';
  body += '═══════════════════════════════════════════════\n\n';
  body += '📝 You received ' + submissions.length + ' new feedback submission(s)\n\n';

  // Summary statistics
  var stats = calculateStats(submissions, headers);
  body += '📊 SUMMARY:\n';
  body += '  • Average Overall Rating: ' + stats.avgOverall + '/5 ' + stats.avgOverallStars + '\n';
  body += '  • Average Child Engagement: ' + stats.avgEngagement + '/5 ' + stats.avgEngagementEmoji + '\n';
  body += '  • Would Recommend: ' + stats.recommendPercent + '% (Definitely/Probably)\n';
  body += '  • Technical Issues Reported: ' + stats.issuesCount + '\n';
  body += '\n';

  // Individual submissions
  body += '═══════════════════════════════════════════════\n\n';

  for (var i = 0; i < submissions.length; i++) {
    var sub = submissions[i].data;
    var submissionNum = i + 1;

    body += '━━━ FEEDBACK #' + submissionNum + ' ━━━\n\n';

    // Extract data by column name
    var timestamp = sub[headers.indexOf('Timestamp')];
    var language = sub[headers.indexOf('Language')];
    var overallRating = sub[headers.indexOf('Overall Rating')];
    var easeOfUse = sub[headers.indexOf('Ease of Use')];
    var childEngagement = sub[headers.indexOf('Child Engagement')];
    var learningValue = sub[headers.indexOf('Learning Value')];
    var childEnjoyed = sub[headers.indexOf('Child Enjoyed Most')];
    var issues = sub[headers.indexOf('Issues Encountered')];
    var issueDetails = sub[headers.indexOf('Issue Details')];
    var suggestions = sub[headers.indexOf('Suggestions')];
    var recommend = sub[headers.indexOf('Would Recommend')];
    var otherComments = sub[headers.indexOf('Other Comments')];

    // Format ratings
    var overallStars = '⭐'.repeat(parseInt(overallRating) || 0);
    var engagementEmojis = ['😞', '😕', '😐', '😊', '😍'];
    var engagementDisplay = engagementEmojis[parseInt(childEngagement) - 1] || childEngagement;
    var langLabel = language === 'en' ? 'English' : '中文';

    body += '⏰ ' + timestamp + ' (' + langLabel + ')\n\n';

    body += '📊 Ratings:\n';
    body += '  Overall: ' + overallStars + ' (' + overallRating + '/5)\n';
    body += '  Ease of Use: ' + easeOfUse + '\n';
    body += '  Child Engagement: ' + engagementDisplay + ' (' + childEngagement + '/5)\n';
    body += '  Learning Value: ' + learningValue + '\n';
    body += '  Would Recommend: ' + recommend + '\n\n';

    if (issues && issues.trim()) {
      body += '🐛 Issues: ' + issues + '\n';
      if (issueDetails && issueDetails.trim()) {
        body += '   Details: ' + issueDetails.trim() + '\n';
      }
      body += '\n';
    }

    if (childEnjoyed && childEnjoyed.trim()) {
      body += '💚 Child Enjoyed:\n   ' + childEnjoyed.trim() + '\n\n';
    }

    if (suggestions && suggestions.trim()) {
      body += '💡 Suggestions:\n   ' + suggestions.trim() + '\n\n';
    }

    if (otherComments && otherComments.trim()) {
      body += '💬 Other Comments:\n   ' + otherComments.trim() + '\n\n';
    }

    if (i < submissions.length - 1) {
      body += '\n';
    }
  }

  body += '═══════════════════════════════════════════════\n';
  body += '📊 View full spreadsheet:\n';
  body += SpreadsheetApp.getActiveSpreadsheet().getUrl() + '\n';
  body += '═══════════════════════════════════════════════\n\n';
  body += 'English ABCs - Feedback Handler\n';
  body += '李之茗外師 | www.englishteacher.com.tw\n';

  return body;
}

// Helper function to calculate statistics
function calculateStats(submissions, headers) {
  var totalOverall = 0;
  var totalEngagement = 0;
  var recommendCount = 0;
  var issuesCount = 0;
  var count = submissions.length;

  for (var i = 0; i < submissions.length; i++) {
    var sub = submissions[i].data;

    var overallRating = parseInt(sub[headers.indexOf('Overall Rating')]) || 0;
    var childEngagement = parseInt(sub[headers.indexOf('Child Engagement')]) || 0;
    var recommend = sub[headers.indexOf('Would Recommend')];
    var issues = sub[headers.indexOf('Issues Encountered')];

    totalOverall += overallRating;
    totalEngagement += childEngagement;

    if (recommend === 'Definitely' || recommend === 'Probably' ||
        recommend === 'definitely' || recommend === 'probably') {
      recommendCount++;
    }

    if (issues && issues.toLowerCase().indexOf('no issues') === -1 && issues.trim()) {
      issuesCount++;
    }
  }

  var avgOverall = (totalOverall / count).toFixed(1);
  var avgEngagement = (totalEngagement / count).toFixed(1);
  var recommendPercent = Math.round((recommendCount / count) * 100);

  var avgOverallStars = '⭐'.repeat(Math.round(avgOverall));
  var engagementEmojis = ['😞', '😕', '😐', '😊', '😍'];
  var avgEngagementEmoji = engagementEmojis[Math.round(avgEngagement) - 1] || '';

  return {
    avgOverall: avgOverall,
    avgOverallStars: avgOverallStars,
    avgEngagement: avgEngagement,
    avgEngagementEmoji: avgEngagementEmoji,
    recommendPercent: recommendPercent,
    issuesCount: issuesCount
  };
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

// Function to set up the daily trigger automatically
// Run this once manually after deploying the script
function setupDailyTrigger() {
  // Delete existing triggers to avoid duplicates
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'sendDailyDigest') {
      ScriptApp.deleteTrigger(triggers[i]);
    }
  }

  // Create new daily trigger
  ScriptApp.newTrigger('sendDailyDigest')
    .timeBased()
    .atHour(DIGEST_TIME_HOUR)
    .everyDays(1)
    .create();

  Logger.log('Daily digest trigger created for ' + DIGEST_TIME_HOUR + ':00');
  return 'Daily digest trigger set up successfully for ' + DIGEST_TIME_HOUR + ':00';
}
