-- Create the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create the tickets table
CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assignee VARCHAR(100),
    priority VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Open',
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_time TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    embedding vector(384) -- Embedding column for semantic search
);

-- Create trigger function to update updated_time
CREATE OR REPLACE FUNCTION update_updated_time_tickets()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_time = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger
CREATE TRIGGER update_tickets_updated_time
BEFORE UPDATE ON tickets
FOR EACH ROW
EXECUTE PROCEDURE update_updated_time_tickets();

-- Insert sample data
INSERT INTO tickets (title, description, assignee, priority, status) VALUES
('Login Page Freezes After Multiple Failed Attempts', 'Users are reporting that after 3 failed login attempts, the login page becomes unresponsive and requires a refresh. No specific error message is displayed.', 'samuel.green@example.com', 'P0 - Critical', 'Open'),
('Dashboard Sales Widget Intermittent Data Loading Failure', 'The "Sales Overview" widget on the main dashboard intermittently shows a loading spinner but no data. Primarily affects Chrome browser users.', 'maria.rodriguez@example.com', 'P1 - High', 'In Progress'),
('Broken Link in Footer - Privacy Policy', 'The "Privacy Policy" hyperlink located in the website footer leads to a 404 "Page Not Found" error.', 'maria.rodriguez@example.com', 'P3 - Low', 'Resolved'),
('UI Misalignment on Mobile Landscape View (iOS)', 'On specific iOS devices (e.g., iPhone 14 models), the top navigation bar shifts downwards when the device is viewed in landscape orientation, obscuring content.', 'maria.rodriguez@example.com', 'P2 - Medium', 'In Progress'),
('Critical XZ Utils Backdoor Detected in Core Dependency (CVE-2024-3094)', 'Urgent: A sophisticated supply chain compromise (CVE-2024-3094) has been identified in XZ Utils versions 5.6.0 and 5.6.1. This malicious code potentially allows unauthorized remote SSH access by modifying liblzma. Immediate investigation and action required for affected Linux/Unix systems and services relying on XZ Utils.', 'frank.white@example.com', 'P0 - Critical', 'Open'),
('Database Connection Timeouts During Peak Usage', 'The application is experiencing frequent database connection timeouts, particularly during peak hours (10 AM - 12 PM EDT), affecting all users and causing service interruptions.', 'frank.white@example.com', 'P1 - High', 'Open'),
('Export to PDF Truncates Long Text Fields in Reports', 'When generating PDF exports of reports containing extensive text fields, the text is abruptly cut off at the end of the page instead of wrapping or continuing to the next page.', 'samuel.green@example.com', 'P1 - High', 'Open'),
('Search Filter "Date Range" Not Applying Correctly', 'The "Date Range" filter on the search results page does not filter records accurately; results outside the specified date range are still displayed.', 'samuel.green@example.com', 'P2 - Medium', 'Resolved'),
('Typo in Error Message: "Unathorized Access"', 'The error message displayed when a user attempts an unauthorized action reads "Unathorized Access" instead of "Unauthorized Access."', 'maria.rodriguez@example.com', 'P3 - Low', 'Resolved'),
('Intermittent File Upload Failures for Large Files', 'Users are intermittently reporting that file uploads fail without a clear error message or explanation, especially for files exceeding 10MB in size.', 'frank.white@example.com', 'P1 - High', 'Open');

-- Insert 200 new ticket records
-- This script adds diverse software bug tickets with realistic scenarios

INSERT INTO tickets (title, description, assignee, priority, status) VALUES
('Coffee Machine API Returns 500 Error on Brew Request', 'When sending POST request to /api/v1/brew endpoint, server returns 500 internal server error. Stack trace shows NullPointerException in BrewController.java line 47.', 'api.team@quantumroast.com', 'P0 - Critical', 'Open'),
('Espresso Temperature Sensor Malfunction', 'Temperature readings from espresso machine sensors are inconsistent. Readings fluctuate between 85°C and 95°C when should be stable at 90°C.', 'hardware.team@quantumroast.com', 'P1 - High', 'Open'),
('Mobile App Crashes on Order History Page', 'iOS app crashes when users try to access order history. Occurs on iOS 17+ devices. Crash log shows memory leak in OrderHistoryViewController.', 'mobile.dev@quantumroast.com', 'P0 - Critical', 'In Progress'),
('Coffee Bean Inventory Count Incorrect', 'Inventory system shows negative values for Colombian beans. Database query returns -150 when physical count is 2000kg.', 'inventory.team@quantumroast.com', 'P1 - High', 'Open'),
('Grind Size Setting Not Persisting', 'Custom grind size settings reset to default after machine restart. User preferences stored in volatile memory instead of EEPROM.', 'firmware.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Payment Gateway Timeout on Large Orders', 'Orders over $500 timeout during payment processing. Gateway returns timeout error after 30 seconds instead of configured 60 seconds.', 'payments.team@quantumroast.com', 'P1 - High', 'Open'),
('Milk Frother Motor Overheating', 'Frother motor temperature exceeds 85°C after 10 minutes of continuous use. Thermal protection circuit activating prematurely.', 'hardware.team@quantumroast.com', 'P1 - High', 'Open'),
('Dashboard Chart Rendering Performance Issue', 'Sales dashboard takes 15+ seconds to load charts with data from last 6 months. Need to optimize database queries and implement caching.', 'frontend.team@quantumroast.com', 'P2 - Medium', 'In Progress'),
('Bluetooth Connectivity Drops Randomly', 'Coffee machine loses Bluetooth connection to mobile app every 5-10 minutes. Requires manual reconnection by user.', 'iot.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Subscription Renewal Email Not Sent', 'Automated emails for coffee subscription renewals are not being sent. Email service logs show successful delivery but customers not receiving.', 'notifications.team@quantumroast.com', 'P1 - High', 'Open'),

('Water Filter Replacement Alert Missing', 'System not triggering water filter replacement notifications. Filter usage counter stuck at 89% for past month.', 'maintenance.team@quantumroast.com', 'P2 - Medium', 'Open'),
('QR Code Scanner Not Working in Low Light', 'Mobile app QR code scanner fails to read coffee bag QR codes in dim lighting conditions. Works fine in bright light.', 'mobile.dev@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Support Chat Widget Offline', 'Live chat widget on website shows "All agents offline" even when support team is available. WebSocket connection failing.', 'support.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Recipe Sharing Feature Returns 404', 'Users cannot share custom coffee recipes. Share button returns 404 error when attempting to generate shareable links.', 'social.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Cleaning Cycle Incomplete', 'Automated cleaning cycle stops at 60% completion. Cleaning solution pump appears to malfunction during rinse phase.', 'hardware.team@quantumroast.com', 'P1 - High', 'Open'),

('User Profile Image Upload Fails', 'Profile image uploads fail for files larger than 2MB. Error message shows "File too large" but max size should be 5MB.', 'backend.team@quantumroast.com', 'P3 - Low', 'Open'),
('Coffee Strength Calibration Drift', 'Coffee strength setting gradually drifts from user preference. Medium strength produces weak coffee after 2 weeks of use.', 'calibration.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Order Tracking Page Shows Wrong Status', 'Order tracking page shows "Processing" status for delivered orders. Database update triggers not firing correctly.', 'order.team@quantumroast.com', 'P2 - Medium', 'Open'),
('WiFi Setup Wizard Hangs on Password Entry', 'Machine setup wizard freezes when entering WiFi password with special characters. Works with alphanumeric passwords only.', 'networking.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Loyalty Points Calculation Error', 'Loyalty points calculated incorrectly for bulk orders. System applies single item multiplier instead of bulk order bonus.', 'loyalty.team@quantumroast.com', 'P1 - High', 'Open'),

('CSV Export Missing Recent Orders', 'Order export CSV files missing orders from last 48 hours. Export query using incorrect date filter.', 'reports.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Status LED Stuck on Red', 'Status LED remains red even after resolving all error conditions. LED driver circuit may need reset sequence.', 'hardware.team@quantumroast.com', 'P3 - Low', 'Open'),
('Push Notifications Not Delivered on Android', 'Android users not receiving push notifications for order updates. FCM token registration failing silently.', 'mobile.dev@quantumroast.com', 'P2 - Medium', 'Open'),
('Inventory Low Stock Alerts Delayed', 'Low stock alerts arrive 2-3 days after inventory drops below threshold. Alert service polling frequency too low.', 'inventory.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Custom Blend Creation UI Broken', 'Custom coffee blend creation interface not responding to user input. JavaScript errors in browser console.', 'frontend.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Barcode Scanner Misreads Coffee Bags', 'Handheld barcode scanner occasionally misreads coffee bag barcodes. Error rate approximately 5% causing inventory discrepancies.', 'warehouse.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Firmware Update Fails', 'Over-the-air firmware updates failing for machines in field. Update process times out during verification phase.', 'firmware.team@quantumroast.com', 'P1 - High', 'Open'),
('Customer Feedback Form Submission Error', 'Feedback form submissions return 500 error after user clicks submit. Form data appears to be valid.', 'feedback.team@quantumroast.com', 'P3 - Low', 'Open'),
('Temperature Probe Readings Inconsistent', 'Brew temperature probe shows fluctuating readings ±3°C from actual temperature. Calibration may be required.', 'sensors.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Mobile App Login Session Expires Too Soon', 'User sessions expire after 15 minutes of inactivity instead of configured 60 minutes. JWT token expiration incorrect.', 'auth.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Bean Origin Tracking Inaccurate', 'Bean origin information shows incorrect farm locations. Database contains outdated supplier mapping data.', 'sourcing.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Descaling Reminder Too Frequent', 'Descaling reminders appear every 2 weeks instead of recommended 4-6 weeks. Calculation algorithm needs adjustment.', 'maintenance.team@quantumroast.com', 'P3 - Low', 'Open'),
('Order Confirmation Email HTML Broken', 'Order confirmation emails display broken HTML formatting. Email template missing CSS styling.', 'email.team@quantumroast.com', 'P3 - Low', 'Open'),
('WiFi Signal Strength Indicator Wrong', 'Machine displays full WiFi signal strength when actually weak. Signal measurement calibration issue.', 'networking.team@quantumroast.com', 'P3 - Low', 'Open'),
('Subscription Pause Feature Not Working', 'Users cannot pause coffee subscriptions from account settings. Pause button appears but no action taken.', 'subscription.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Cup Size Detection Fails', 'Optical sensor fails to detect small espresso cups. Sensor positioning may need adjustment for better detection angle.', 'sensors.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Admin Dashboard Login Loop', 'Admin users stuck in redirect loop after successful login. Session management issue in admin portal.', 'admin.team@quantumroast.com', 'P1 - High', 'Open'),
('Machine Serial Number Display Truncated', 'LCD display shows only first 8 characters of 12-character serial number. Display buffer size insufficient.', 'display.team@quantumroast.com', 'P3 - Low', 'Open'),
('Coffee Grounds Waste Sensor Malfunction', 'Waste drawer full sensor triggers prematurely when drawer is only 60% full. Sensor mounting position issue.', 'hardware.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Recipe Import Feature Crashes App', 'Importing coffee recipes from JSON file causes mobile app to crash. Large file parsing causing memory overflow.', 'mobile.dev@quantumroast.com', 'P2 - Medium', 'Open'),

('Water Level Sensor Reads Empty When Full', 'Water reservoir sensor shows empty reading when reservoir is full. Sensor may be damaged or miscalibrated.', 'sensors.team@quantumroast.com', 'P1 - High', 'Open'),
('Customer Rating System Not Updating', 'Product ratings from customers not updating average rating display. Database trigger not executing properly.', 'ratings.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Sound Volume Cannot Be Adjusted', 'Volume control in machine settings has no effect on operational sounds. Audio driver configuration issue.', 'audio.team@quantumroast.com', 'P3 - Low', 'Open'),
('Order History Export Missing Data', 'CSV export of order history missing customer email addresses. Export query JOIN clause incorrect.', 'reports.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Clock Drifts After Power Outage', 'Real-time clock loses accuracy after power interruption. Battery backup may be failing.', 'hardware.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Bean Freshness Date Wrong', 'Freshness date calculation showing past dates for newly roasted beans. Date calculation logic reversed.', 'inventory.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Mobile App Camera Permission Denied', 'App cannot access camera for QR code scanning on some Android devices. Permission request handling needs improvement.', 'mobile.dev@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Brew Button Unresponsive', 'Physical brew button occasionally does not respond to press. Button contact may be worn or dirty.', 'hardware.team@quantumroast.com', 'P1 - High', 'Open'),
('Customer Search Function Too Slow', 'Customer search in admin portal takes 10+ seconds for common queries. Database indexing needs optimization.', 'database.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Error Code Display Unclear', 'Error codes shown on machine display are cryptic. Need user-friendly error messages instead of hex codes.', 'ux.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Subscription Billing Wrong Amount', 'Some customers billed incorrect amount for monthly subscription. Pricing calculation includes expired promotions.', 'billing.team@quantumroast.com', 'P1 - High', 'Open'),
('Machine Cleaning Solution Level Low Alert Missing', 'No notification when cleaning solution reservoir is low. Sensor present but alert system not configured.', 'maintenance.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Search Returns Irrelevant Results', 'Product search returns coffee makers when searching for coffee beans. Search algorithm relevance scoring poor.', 'search.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine USB Port Not Recognizing Devices', 'USB port for firmware updates not recognizing connected devices. Port driver or hardware issue.', 'hardware.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Order Cancellation Window Too Short', 'Customers only have 5 minutes to cancel orders instead of promised 30 minutes. Cancellation logic needs update.', 'order.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Machine Leak Detection Fails', 'Water leak sensor not detecting small leaks in brew chamber. Sensor sensitivity threshold too high.', 'safety.team@quantumroast.com', 'P1 - High', 'Open'),
('Mobile App Offline Mode Broken', 'App cannot function without internet connection despite claiming offline support. Local storage not implemented.', 'mobile.dev@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Touch Screen Calibration Drift', 'Touch screen accuracy decreases over time, requiring frequent recalibration. Calibration matrix not persistent.', 'display.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Inventory Reorder Alerts Not Sent', 'Automatic reorder alerts for low inventory not being sent to suppliers. Email service integration broken.', 'procurement.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Login Attempt Limit Too Strict', 'Account locked after 3 failed login attempts instead of industry standard 5. Security policy too restrictive.', 'security.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Recipe Video Playback Fails', 'Recipe tutorial videos not playing in mobile app. Video streaming service returning 403 errors.', 'media.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Pressure Gauge Reads Zero', 'Brew pressure gauge shows 0 bar during operation when should show 9 bar. Pressure sensor or gauge connection issue.', 'sensors.team@quantumroast.com', 'P1 - High', 'Open'),
('Website Contact Form Spam Filter Too Aggressive', 'Legitimate customer inquiries blocked by spam filter. Filter rules need refinement to reduce false positives.', 'web.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Grinder Motor Noise Excessive', 'Coffee grinder motor produces louder noise than specification. Motor bearings may need lubrication or replacement.', 'hardware.team@quantumroast.com', 'P3 - Low', 'Open'),
('Order Tracking SMS Not Delivered', 'SMS notifications for order tracking not reaching customers. SMS gateway API returning success but messages not sent.', 'sms.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Bean Rating Filter Not Working', 'Website filter by coffee bean rating (4+ stars) returns no results despite having highly rated beans. Filter query incorrect.', 'web.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Water Filter Bypass Mode Stuck', 'Water filter bypass mode cannot be disabled after maintenance. Bypass valve actuator not responding to commands.', 'plumbing.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Referral Bonus Not Applied', 'Referral bonuses not being credited to customer accounts. Referral tracking system not triggering reward calculation.', 'referral.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Startup Sequence Takes Too Long', 'Machine takes 5 minutes to complete startup instead of specified 2 minutes. Self-test routines running sequentially instead of parallel.', 'firmware.team@quantumroast.com', 'P3 - Low', 'Open'),
('Mobile App Push Notification Sound Missing', 'Push notifications arrive silently without notification sound. Sound file missing from app bundle.', 'mobile.dev@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Subscription Gift Option Broken', 'Gift subscription feature not processing payments correctly. Gift recipient receives confirmation but payment fails.', 'gifts.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Energy Saving Mode Too Aggressive', 'Machine enters sleep mode during active brewing cycle. Power management algorithm not checking brew status.', 'power.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Product Images Not Loading', 'Product images on coffee bean detail pages returning 404 errors. Image CDN configuration issue.', 'cdn.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Milk Temperature Inconsistent', 'Steamed milk temperature varies between 55°C and 75°C for same setting. Temperature control PID loop needs tuning.', 'thermal.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Support Ticket Auto-Assignment Fails', 'Support tickets not being automatically assigned to available agents. Load balancing algorithm not functioning.', 'support.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Bean Discount Code Stacking Issue', 'Multiple discount codes can be applied to single order when should be mutually exclusive. Validation logic missing.', 'promotions.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Display Brightness Auto-Adjust Broken', 'Screen brightness does not adjust based on ambient light. Light sensor readings not being processed.', 'display.team@quantumroast.com', 'P3 - Low', 'Open'),
('Order Pickup Notification Timing Wrong', 'In-store pickup notifications sent when order placed instead of when ready. Notification trigger event incorrect.', 'pickup.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Safety Interlock Bypassed', 'Safety door interlock can be bypassed by pressing door firmly. Magnetic switch not detecting door closure properly.', 'safety.team@quantumroast.com', 'P0 - Critical', 'Open'),
('Customer Account Deletion Not Complete', 'Account deletion process leaves orphaned data in database. Cascading delete constraints not properly configured.', 'privacy.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Recipe Nutrition Info Inaccurate', 'Nutritional information for coffee recipes shows incorrect calorie counts. Calculation not including added milk/sugar.', 'nutrition.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Firmware Version Display Wrong', 'Machine shows firmware version 1.2.3 when actually running 1.2.4. Version string not updated in display code.', 'firmware.team@quantumroast.com', 'P3 - Low', 'Open'),
('Website Shopping Cart Items Disappear', 'Items randomly disappear from shopping cart during checkout process. Session timeout causing cart data loss.', 'cart.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Bean Hopper Capacity Sensor Wrong', 'Bean hopper shows full when only 50% capacity. Ultrasonic level sensor giving incorrect readings.', 'sensors.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Loyalty Tier Calculation Error', 'Some customers stuck in lower loyalty tier despite meeting next tier requirements. Point accumulation logic incorrect.', 'loyalty.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Machine Remote Monitoring Offline', 'Remote monitoring dashboard shows machines as offline when they are online and functioning. Telemetry data not reaching servers.', 'telemetry.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Mobile App Background Sync Drains Battery', 'App consumes excessive battery when running in background. Background sync frequency too high.', 'mobile.dev@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Cleaning Cycle Skips Rinse Phase', 'Automated cleaning occasionally skips final rinse cycle. State machine logic has race condition.', 'cleaning.team@quantumroast.com', 'P1 - High', 'Open'),
('Website Product Recommendations Irrelevant', 'Product recommendation engine suggesting espresso accessories to customers who only buy filter coffee. Machine learning model needs retraining.', 'ml.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Grind Setting Memory Lost', 'Custom grind settings lost after firmware update. Settings not properly backed up before update process.', 'settings.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Subscription Delivery Date Wrong', 'Subscription deliveries arriving 2-3 days later than scheduled. Delivery date calculation not accounting for weekends.', 'delivery.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Error Log Storage Full', 'Machine stops logging errors when log storage reaches capacity. No log rotation mechanism implemented.', 'logging.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Review Moderation Queue Stuck', 'Product reviews stuck in moderation queue for weeks. Moderation workflow automation broken.', 'moderation.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Steam Wand Auto-Purge Not Working', 'Steam wand purge cycle not running after milk steaming. Purge valve control signal not being sent.', 'steam.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website SSL Certificate Expiring Soon', 'SSL certificate expires in 15 days but auto-renewal process failed. Manual renewal required to prevent outage.', 'security.team@quantumroast.com', 'P1 - High', 'Open'),

('Coffee Bean Allergen Information Missing', 'Product pages missing allergen information required by food safety regulations. Database schema needs allergen fields.', 'compliance.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Diagnostic Mode Access Restricted', 'Service technicians cannot access diagnostic mode with standard service key. Access control logic too restrictive.', 'service.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Order Confirmation Call Feature Broken', 'Automated order confirmation calls not being placed. VoIP service integration returning authentication errors.', 'voice.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Water Hardness Compensation Wrong', 'Water hardness compensation algorithm over-compensating for soft water areas. Brewing parameters too aggressive.', 'water.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Password Reset Email Delayed', 'Password reset emails taking 10-15 minutes to arrive instead of immediate delivery. Email queue processing bottleneck.', 'email.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Recipe Share Link Expires Too Soon', 'Shared recipe links expire after 24 hours instead of promised 30 days. Link expiration timestamp incorrect.', 'sharing.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Maintenance Alert Threshold Wrong', 'Maintenance alerts triggered after 5000 cycles instead of specified 10000. Counter threshold hardcoded incorrectly.', 'maintenance.team@quantumroast.com', 'P3 - Low', 'Open'),
('Website Checkout Process Hangs on Payment', 'Checkout hangs at payment step for orders with promotional codes. Payment gateway integration not handling discounts properly.', 'checkout.team@quantumroast.com', 'P1 - High', 'Open'),
('Machine Cup Warmer Plate Temperature Low', 'Cup warmer plate only reaches 45°C instead of target 60°C. Heating element power insufficient or thermostat faulty.', 'heating.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Feedback Survey Response Rate Low', 'Post-purchase survey emails have 2% response rate. Email subject line and timing need optimization.', 'surveys.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Machine Status API Rate Limited', 'Mobile app exceeds rate limit when polling machine status frequently. Need to implement exponential backoff.', 'api.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Drip Tray Full Sensor False Positive', 'Drip tray sensor triggers "full" alert when tray is only half full. Sensor mounting angle causing premature detection.', 'sensors.team@quantumroast.com', 'P3 - Low', 'Open'),
('Website Product Filter Combination Bug', 'Applying multiple product filters (origin + roast level) returns empty results when matches exist. Filter logic using AND instead of OR.', 'filters.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Bluetooth Range Too Short', 'Bluetooth connection drops when phone is more than 2 meters away. Antenna design or positioning issue.', 'bluetooth.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Account Merge Process Fails', 'Account merging process for customers with duplicate accounts fails silently. Data integrity constraints preventing merge.', 'accounts.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Bean Origin Map Not Loading', 'Interactive map showing coffee bean origins not loading on product pages. Map service API key expired.', 'maps.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Pressure Relief Valve Timing Off', 'Pressure relief valve opens 2 seconds too early in brew cycle. Valve control timing needs calibration.', 'pressure.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Order History Search Function Broken', 'Customer cannot search order history by product name. Search index not including product details.', 'search.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Firmware Rollback Feature Missing', 'No way to rollback firmware if update causes issues. Rollback mechanism not implemented in bootloader.', 'firmware.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Live Chat Typing Indicator Stuck', 'Chat typing indicator shows "Agent is typing..." for hours without message. WebSocket connection state management issue.', 'chat.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Subscription Pause Duration Ignored', 'Subscription pause duration setting ignored, subscription resumes after 1 week regardless of selected duration.', 'subscription.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Bean Grinder Burr Wear Detection Wrong', 'Burr wear sensor indicates replacement needed after only 100kg when rated for 500kg. Sensor calibration incorrect.', 'grinding.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Wishlist Sync Across Devices Broken', 'Wishlist items added on mobile not appearing on desktop website. Cross-device synchronization not working.', 'sync.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Water Pump Pressure Fluctuation', 'Water pump pressure fluctuates during brewing causing inconsistent extraction. Pump controller PID parameters need tuning.', 'pump.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Product Availability Status Wrong', 'Products show as "In Stock" when actually out of stock. Inventory sync between warehouse and website delayed.', 'inventory.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Recipe Export Format Corrupted', 'Exported recipe files cannot be imported back into app. JSON export formatting includes invalid characters.', 'export.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Safety Shutoff Temperature Wrong', 'Safety temperature shutoff triggers at 95°C instead of specified 105°C. Safety margin too conservative.', 'safety.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Order Tracking Page Mobile Layout Broken', 'Order tracking page layout broken on mobile devices. CSS media queries not handling small screens properly.', 'mobile.web@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Milk Line Cleaning Alert Missing', 'No reminder alerts for milk line cleaning despite daily cleaning requirement. Alert scheduling not configured.', 'hygiene.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Support Escalation Rules Wrong', 'Support tickets not escalating to senior agents after 24 hours as configured. Escalation timer not running.', 'escalation.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Bean Roast Date Format Inconsistent', 'Roast dates displayed in different formats across website (MM/DD/YYYY vs DD/MM/YYYY). Localization configuration missing.', 'localization.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Display Backlight Dimming Broken', 'Display backlight does not dim after inactivity timeout. Power management for display not functioning.', 'display.team@quantumroast.com', 'P3 - Low', 'Open'),
('Website Search Autocomplete Suggestions Wrong', 'Search autocomplete suggests discontinued products. Suggestion database not updated with current product catalog.', 'autocomplete.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Pre-infusion Time Setting Ignored', 'Custom pre-infusion time settings ignored during brewing. Firmware using hardcoded values instead of user settings.', 'brewing.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Email Preference Changes Not Saved', 'Email preference updates from account settings page not being saved. Database update transaction rolling back.', 'preferences.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Machine Remote Diagnostics Timeout', 'Remote diagnostic connections timeout after 30 seconds instead of configured 5 minutes. Connection timeout value hardcoded.', 'diagnostics.team@quantumroast.com', 'P3 - Low', 'Open'),
('Mobile App Offline Recipe Storage Limited', 'App can only store 10 recipes offline despite having storage space for 100+. Storage allocation logic conservative.', 'storage.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Water Level Low Alert Delay', 'Water level low alert appears 2 minutes after reservoir empty. Alert threshold too low causing delayed warning.', 'alerts.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Product Comparison Tool Missing Data', 'Product comparison page missing key specifications for newer coffee machines. Product data ingestion incomplete.', 'comparison.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Thermal Block Heating Slow', 'Thermal block takes 8 minutes to reach brewing temperature instead of specified 3 minutes. Heating element power output reduced.', 'thermal.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Bean Freshness Indicator Wrong Color', 'Freshness indicator shows green for beans roasted 45 days ago when should show red after 30 days. Color threshold logic incorrect.', 'freshness.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Account Security Questions Broken', 'Security question verification failing for valid answers. Answer comparison case-sensitive when should be case-insensitive.', 'security.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Service Mode Exit Requires Reboot', 'Cannot exit service mode without power cycling machine. Service mode exit command not implemented in firmware.', 'service.team@quantumroast.com', 'P3 - Low', 'Open'),
('Website Coffee Blog Comments Not Posting', 'Blog post comments fail to post with "Please try again" error message. Comment moderation queue at capacity.', 'blog.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Brew Group Position Sensor Drift', 'Brew group position sensor readings drift over time causing positioning errors. Sensor calibration not maintained.', 'positioning.team@quantumroast.com', 'P2 - Medium', 'Open'),

('Coffee Subscription Billing Cycle Date Wrong', 'Subscription billing date changes after customer updates shipping address. Billing cycle recalculation logic incorrect.', 'billing.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Error Recovery Procedure Unclear', 'Error recovery instructions on display too vague for users to follow. Need step-by-step troubleshooting guide.', 'documentation.team@quantumroast.com', 'P3 - Low', 'Open'),
('Order Fulfillment Priority Logic Wrong', 'Orders not prioritized by shipping method as configured. Express orders processed after standard orders.', 'fulfillment.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Machine Network Configuration Reset Issue', 'Network settings reset to factory defaults after power outage. Configuration not stored in non-volatile memory.', 'network.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Customer Referral Link Tracking Broken', 'Referral links not tracking conversions properly. URL parameter parsing incorrect in analytics code.', 'analytics.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Bean Package Weight Verification Fails', 'Package weight sensor reports incorrect weights for 5lb bags. Sensor calibration drifted due to temperature changes.', 'packaging.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Milk Steam Temperature Overshoot', 'Milk steaming overshoots target temperature by 10°C before stabilizing. Temperature control response too aggressive.', 'control.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Product Video Player Controls Missing', 'Product demonstration videos play but lack standard controls (pause, volume, progress bar). Video player configuration incomplete.', 'video.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Automatic Rinse Cycle Water Amount Wrong', 'Rinse cycle uses 500ml instead of specified 200ml water. Water volume calculation multiplied instead of divided.', 'rinse.team@quantumroast.com', 'P3 - Low', 'Open'),
('Customer Support Chat History Not Saving', 'Chat conversation history not saved when customer closes browser. Session persistence not implemented for chat system.', 'chat.team@quantumroast.com', 'P3 - Low', 'Open'),

('Coffee Machine Warranty Registration Portal Down', 'Warranty registration website returning 503 errors for past 6 hours. Database connection pool exhausted.', 'warranty.team@quantumroast.com', 'P1 - High', 'Open'),
('Mobile App Recipe Rating System Broken', 'Users cannot rate coffee recipes, star rating component not responding to touch. Touch event handlers not properly bound.', 'ratings.team@quantumroast.com', 'P3 - Low', 'Open'),
('Machine Cleaning Solution Detection Sensor Failed', 'Sensor not detecting presence of cleaning solution in reservoir. Conductivity sensor may be corroded or disconnected.', 'detection.team@quantumroast.com', 'P2 - Medium', 'Open'),
('Website Checkout Tax Calculation for International Orders Wrong', 'International orders showing domestic tax rates instead of destination country rates. Tax service API integration missing country parameter.', 'tax.team@quantumroast.com', 'P1 - High', 'Open'),
('Machine Bean Hopper Lid Lock Mechanism Stuck', 'Bean hopper lid cannot be opened, lock mechanism appears jammed. Lock actuator motor may be seized.', 'mechanical.team@quantumroast.com', 'P2 - Medium', 'Open');


-- Create vector index for efficient similarity search (will be populated by migration script)
CREATE INDEX IF NOT EXISTS tickets_embedding_cosine_idx 
ON tickets USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 100);

-- Display success message
SELECT 'Database initialized successfully!' as message;
SELECT 'Total tickets created: ' || COUNT(*) as summary FROM tickets;
