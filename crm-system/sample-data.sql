INSERT IGNORE INTO users (username, password, email, phone, role, temp_password, is_active) VALUES

('admin', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'admin@crm.com', '+1-555-0001', 'admin', FALSE, TRUE),
('superadmin', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'superadmin@crm.com', '+1-555-0002', 'admin', FALSE, TRUE),


('emp1', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'employee1@crm.com', '+1-555-0101', 'employee', FALSE, TRUE),
('emp2', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'employee2@crm.com', '+1-555-0102', 'employee', FALSE, TRUE),
('emp3', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'employee3@crm.com', '+1-555-0103', 'employee', FALSE, TRUE),
('emp4', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'employee4@crm.com', '+1-555-0104', 'employee', FALSE, TRUE),


('user1', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'customer1@crm.com', '+1-555-0201', 'customer', FALSE, TRUE),
('user2', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'customer2@crm.com', '+1-555-0202', 'customer', FALSE, TRUE),
('user3', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'customer3@crm.com', '+1-555-0203', 'customer', FALSE, TRUE),
('user4', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'customer4@crm.com', '+1-555-0204', 'customer', FALSE, TRUE),
('user5', '$2a$10$Gs4pj058kOZUBnrnJuRu/ebm1iWnk7Xe/InMTdOcjubCZ4S9vNnh2', 'customer5@crm.com', '+1-555-0205', 'customer', FALSE, TRUE);


INSERT IGNORE INTO employees (user_id, first_name, last_name, phone, department, position, status) VALUES
(3, 'John', 'Smith', '+1-555-0101', 'Technical Support', 'Support Specialist', 'ACTIVE'),
(4, 'Sarah', 'Johnson', '+1-555-0102', 'Sales', 'Sales Representative', 'ACTIVE'),
(5, 'Michael', 'Brown', '+1-555-0103', 'Technical Support', 'Senior Support Engineer', 'ACTIVE'),
(6, 'Emily', 'Davis', '+1-555-0104', 'Quality Assurance', 'QA Specialist', 'ACTIVE');


INSERT IGNORE INTO customers (user_id, first_name, last_name, email, phone, address, company) VALUES
(7, 'Alice', 'Johnson', 'customer1@crm.com', '+1-555-0201', '123 Main St, New York, NY 10001', 'Tech Solutions Inc.'),
(8, 'Bob', 'Williams', 'customer2@crm.com', '+1-555-0202', '456 Oak Ave, Los Angeles, CA 90210', 'Marketing Pro LLC'),
(9, 'Carol', 'Miller', 'customer3@crm.com', '+1-555-0203', '789 Pine St, Chicago, IL 60601', 'Global Enterprises'),
(10, 'David', 'Wilson', 'customer4@crm.com', '+1-555-0204', '321 Elm St, Houston, TX 77001', 'Wilson & Sons Corp'),
(11, 'Eva', 'Garcia', 'customer5@crm.com', '+1-555-0205', '654 Maple Dr, Phoenix, AZ 85001', 'Sunrise Technologies');


INSERT IGNORE INTO products (name, description, price, category, stock_quantity, is_active) VALUES
('CRM Software Pro', 'Complete customer relationship management solution with advanced features', 299.99, 'Software', 100, TRUE),
('Business Analytics Suite', 'Advanced analytics and reporting tools for data-driven decisions', 499.99, 'Software', 50, TRUE),
('Customer Support Package', '24/7 customer support and maintenance services', 199.99, 'Service', 999, TRUE),
('Mobile CRM App', 'Mobile application for on-the-go access to CRM features', 149.99, 'Software', 200, TRUE),
('Enterprise CRM', 'Scalable CRM solution for large organizations', 899.99, 'Software', 25, TRUE),
('Basic CRM Starter', 'Entry-level CRM for small businesses', 99.99, 'Software', 150, TRUE),
('Marketing Automation', 'Automated marketing campaigns and lead management', 349.99, 'Software', 75, TRUE),
('Custom Integration', 'Custom API integration services', 599.99, 'Service', 999, TRUE);


INSERT IGNORE INTO complaints (user_id, product_id, title, description, status, priority, assigned_to, created_at) VALUES
(7, 1, 'Login issues after update', 'Unable to login to the CRM system since the latest update. Getting authentication error consistently.', 'PENDING', 'HIGH', 1, '2025-10-01 09:15:00'),
(8, 2, 'Report generation very slow', 'The analytics reports are taking over 10 minutes to generate, making it impossible to work efficiently.', 'IN_PROGRESS', 'MEDIUM', 3, '2025-10-02 11:30:00'),
(9, 3, 'Support response time', 'Haven''t received response from support team for over 48 hours on a critical issue.', 'PENDING', 'URGENT', NULL, '2025-10-03 14:45:00'),
(10, 1, 'Data synchronization problem', 'Customer data is not syncing properly between web and mobile versions of the CRM.', 'IN_PROGRESS', 'HIGH', 1, '2025-10-04 16:20:00'),
(11, 4, 'Mobile app crashing', 'The mobile app crashes immediately after login on iOS devices.', 'RESOLVED', 'HIGH', 3, '2025-10-05 10:10:00'),
(7, 2, 'Incorrect billing amount', 'Charged $599.99 instead of $499.99 for Business Analytics Suite subscription.', 'PENDING', 'MEDIUM', 4, '2025-10-06 13:25:00'),
(8, 5, 'Feature request - export options', 'Requesting additional export formats (CSV, Excel) for customer reports.', 'PENDING', 'LOW', NULL, '2025-10-07 15:40:00'),
(9, 3, 'Training materials outdated', 'The user manual and training videos reference old features that no longer exist.', 'IN_PROGRESS', 'MEDIUM', 2, '2025-10-08 08:55:00');


INSERT IGNORE INTO inquiries (user_id, subject, message, response, status, created_at) VALUES
(7, 'Pricing information for enterprise', 'I would like to know more about your enterprise pricing plans and features included. Also, are there any discounts for annual billing?', 'Our enterprise plan starts at $899.99/month and includes all features plus dedicated support. We offer 15% discount for annual billing.', 'CLOSED', '2025-10-01 10:00:00'),
(8, 'Customization options available', 'Are there options to customize the CRM according to our specific business processes and workflows?', 'Yes, we offer extensive customization options including custom fields, workflows, and API integrations. Our team can discuss your specific requirements.', 'CLOSED', '2025-10-02 11:30:00'),
(9, 'Integration with third-party tools', 'Do you have pre-built integrations with popular tools like Salesforce, Slack, and QuickBooks?', 'We have pre-built integrations with over 50 popular business tools including the ones you mentioned. You can check our integration marketplace.', 'OPEN', '2025-10-03 14:15:00'),
(10, 'Training and onboarding process', 'What kind of training and onboarding support do you provide for new teams?', 'We provide comprehensive onboarding including setup assistance, training sessions, and documentation. Enterprise plans include dedicated onboarding specialist.', 'IN_PROGRESS', '2025-10-04 16:45:00'),
(11, 'Data migration services', 'We are switching from another CRM. Do you offer data migration services and what is the process?', 'Yes, we offer professional data migration services. Our team will work with you to map and transfer your data securely.', 'OPEN', '2025-10-05 09:20:00'),
(7, 'Security and compliance certifications', 'What security certifications does your platform have? We need SOC 2 and GDPR compliance.', 'We are SOC 2 Type II certified and fully GDPR compliant. We also undergo regular security audits and penetration testing.', 'CLOSED', '2025-10-06 13:10:00');


INSERT IGNORE INTO resolutions (complaint_id, resolved_by, resolution_text, resolved_at) VALUES
(5, 3, 'Identified and fixed memory leak in iOS mobile app. Released patch update (v2.1.3) that resolves the crashing issue. Users should update to the latest version from App Store.', '2025-10-07 11:30:00'),
(2, 3, 'Optimized database queries and added caching for report generation. Report generation time reduced from 10+ minutes to under 30 seconds for most reports.', '2025-10-08 14:20:00'),
(4, 1, 'Fixed synchronization API endpoint that was causing data inconsistencies. Implemented retry mechanism for failed sync operations. All customer data now syncing correctly.', '2025-10-09 16:45:00');


INSERT IGNORE INTO faq (question, answer, category, created_by, is_active) VALUES
('How do I reset my password?', 'You can reset your password by clicking on the "Forgot Password" link on the login page and following the instructions sent to your email. The reset link is valid for 24 hours.', 'General', 1, TRUE),
('How can I submit a complaint?', 'Navigate to the Complaints section in your dashboard and click on "New Complaint". Fill out the form with details about your issue including title, description, and priority level.', 'Complaints', 1, TRUE),
('What are the business hours for support?', 'Our support team is available Monday to Friday, 9 AM to 6 PM EST. Emergency support is available 24/7 for critical issues affecting system availability.', 'Support', 1, TRUE),
('How do I update my profile information?', 'Go to your profile page from the dashboard and click "Edit Profile". You can update your personal information, contact details, and notification preferences.', 'Profile', 1, TRUE),
('Can I export my data from the system?', 'Yes, you can export your data in CSV or Excel format. Go to Reports section and select the data you want to export. Some exports may require admin approval.', 'Data Management', 1, TRUE),
('How do I assign a complaint to a team member?', 'Admins and team leads can assign complaints from the complaint details page. Click on "Assign To" and select the appropriate team member from the dropdown.', 'Complaints', 1, TRUE),
('What payment methods do you accept?', 'We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and bank transfers for enterprise customers.', 'Billing', 1, TRUE),
('Is there a mobile app available?', 'Yes, we have mobile apps for both iOS and Android devices. You can download them from the App Store or Google Play Store.', 'Mobile', 1, TRUE),
('How do I add new users to my account?', 'Account admins can add new users from the User Management section. Click "Add User" and fill in the required details. New users will receive email invitations.', 'User Management', 1, TRUE),
('What is your data backup policy?', 'We perform automatic daily backups of all customer data. Backups are stored encrypted in multiple geographic locations for redundancy and disaster recovery.', 'Security', 1, TRUE);


INSERT IGNORE INTO audit_logs (user_id, action, description, ip_address, timestamp) VALUES
(1, 'LOGIN', 'User logged in successfully', '192.168.1.100', '2025-10-11 08:30:00'),
(7, 'COMPLAINT_CREATE', 'Created new complaint: Login issues after update', '203.0.113.45', '2025-10-01 09:15:00'),
(3, 'COMPLAINT_UPDATE', 'Updated complaint status to IN_PROGRESS', '192.168.1.50', '2025-10-02 12:00:00'),
(8, 'INQUIRY_CREATE', 'Submitted new inquiry about customization options', '198.51.100.23', '2025-10-02 11:30:00'),
(1, 'USER_CREATE', 'Created new employee account: emp4', '192.168.1.100', '2025-10-03 10:15:00'),
(9, 'PASSWORD_RESET', 'User requested password reset', '203.0.113.67', '2025-10-04 14:20:00');


SELECT 'Users: ' AS 'Table', COUNT(*) AS 'Count' FROM users
UNION ALL SELECT 'Employees: ', COUNT(*) FROM employees
UNION ALL SELECT 'Customers: ', COUNT(*) FROM customers
UNION ALL SELECT 'Products: ', COUNT(*) FROM products
UNION ALL SELECT 'Complaints: ', COUNT(*) FROM complaints
UNION ALL SELECT 'Inquiries: ', COUNT(*) FROM inquiries
UNION ALL SELECT 'FAQs: ', COUNT(*) FROM faq
UNION ALL SELECT 'Resolutions: ', COUNT(*) FROM resolutions
UNION ALL SELECT 'Audit Logs: ', COUNT(*) FROM audit_logs;