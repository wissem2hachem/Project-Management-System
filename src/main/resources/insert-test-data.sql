USE project_management;

-- Insert test users (passwords are plaintext for testing - not for production!)
INSERT INTO users (name, email, password, role) VALUES
                                                    ('Admin User', 'admin@example.com', 'admin123', 'ADMIN'),
                                                    ('Project Manager', 'pm@example.com', 'pm123', 'MANAGER'),
                                                    ('Developer One', 'dev1@example.com', 'dev123', 'DEVELOPER'),
                                                    ('Developer Two', 'dev2@example.com', 'dev123', 'DEVELOPER'),
                                                    ('Designer One', 'designer@example.com', 'designer123', 'DESIGNER'),
                                                    ('Tester One', 'tester@example.com', 'tester123', 'TESTER')
    ON DUPLICATE KEY UPDATE name=VALUES(name), role=VALUES(role);

-- Insert test projects
INSERT INTO projects (name, description, owner_id, due_date, status) VALUES
                                                                         ('Website Redesign', 'Complete redesign of company website with modern UI/UX', 1, DATE_ADD(NOW(), INTERVAL 30 DAY), 'IN_PROGRESS'),
                                                                         ('Mobile App Development', 'Development of new mobile application for iOS and Android', 2, DATE_ADD(NOW(), INTERVAL 60 DAY), 'PLANNING'),
                                                                         ('Marketing Campaign Q4', 'Quarterly marketing campaign planning and execution', 2, DATE_ADD(NOW(), INTERVAL 45 DAY), 'IN_PROGRESS'),
                                                                         ('Internal Tools Upgrade', 'Upgrade internal tools and systems for better productivity', 1, DATE_ADD(NOW(), INTERVAL 90 DAY), 'PLANNING')
    ON DUPLICATE KEY UPDATE description=VALUES(description), status=VALUES(status);

-- Insert project members
INSERT IGNORE INTO project_members (project_id, user_id, role) VALUES
(1, 1, 'MANAGER'),
(1, 3, 'DEVELOPER'),
(1, 5, 'DESIGNER'),
(2, 2, 'MANAGER'),
(2, 3, 'DEVELOPER'),
(2, 4, 'DEVELOPER'),
(3, 2, 'MANAGER'),
(3, 6, 'TESTER'),
(4, 1, 'MANAGER'),
(4, 3, 'DEVELOPER'),
(4, 4, 'DEVELOPER'),
(4, 6, 'TESTER');

-- Insert test tasks
INSERT INTO tasks (project_id, title, description, status, priority, assignee_id, due_date) VALUES
                                                                                                (1, 'Design Homepage', 'Create new homepage design with modern layout', 'TODO', 'HIGH', 5, DATE_ADD(NOW(), INTERVAL 5 DAY)),
                                                                                                (1, 'Implement Header', 'Code the website header with responsive design', 'IN_PROGRESS', 'MEDIUM', 3, DATE_ADD(NOW(), INTERVAL 7 DAY)),
                                                                                                (1, 'Footer Implementation', 'Create and implement website footer', 'TODO', 'LOW', 4, DATE_ADD(NOW(), INTERVAL 10 DAY)),
                                                                                                (2, 'App Architecture', 'Design mobile app architecture and components', 'DONE', 'HIGH', 3, DATE_ADD(NOW(), INTERVAL -2 DAY)),
                                                                                                (2, 'UI Design', 'Design mobile app user interface', 'IN_PROGRESS', 'HIGH', 5, DATE_ADD(NOW(), INTERVAL 15 DAY)),
                                                                                                (3, 'Campaign Strategy', 'Develop marketing campaign strategy', 'TODO', 'HIGH', 2, DATE_ADD(NOW(), INTERVAL 5 DAY)),
                                                                                                (3, 'Content Creation', 'Create marketing content and materials', 'IN_PROGRESS', 'MEDIUM', 6, DATE_ADD(NOW(), INTERVAL 10 DAY)),
                                                                                                (4, 'Requirements Gathering', 'Gather requirements for tools upgrade', 'DONE', 'MEDIUM', 1, DATE_ADD(NOW(), INTERVAL -5 DAY))
    ON DUPLICATE KEY UPDATE status=VALUES(status), priority=VALUES(priority);