CREATE ROLE Administrator NOLOGIN;
GRANT SELECT, INSERT, UPDATE ON Insurance_plans TO Administrator;
GRANT SELECT, INSERT, UPDATE ON Provider TO Administrator;
GRANT SELECT ON Claims TO Administrator;
GRANT SELECT, INSERT ON Payments TO Administrator;
GRANT SELECT, INSERT, UPDATE ON Employee TO Administrator;

CREATE ROLE Claims_processor NOLOGIN;
GRANT SELECT ON Members TO Claims_processor;
GRANT SELECT ON Insurance_Plans TO Claims_processor;
GRANT SELECT ON Member_Policies TO Claims_processor;
GRANT SELECT ON Provider TO Claims_processor;
GRANT SELECT ON Claims TO Claims_processor;
GRANT UPDATE(status) ON Claims TO Claims_processor;
GRANT SELECT ON Payments TO Claims_processor;

CREATE ROLE Representative NOLOGIN;
GRANT SELECT(member_ID, name, address, member_phone_no, member_email) ON Members TO Representative;
GRANT SELECT ON Insurance_Plans TO Representative;
GRANT SELECT ON Member_Policies TO Representative;
GRANT UPDATE(effective_date, expiration_date) ON Member_Policies TO Representative;
GRANT SELECT ON Provider TO Representative;
GRANT INSERT ON Claims TO Representative;

CREATE ROLE Auditor NOLOGIN;
GRANT SELECT ON Claims TO Auditor;
GRANT SELECT ON Payments TO Auditor;
GRANT SELECT ON Audit_Logs TO Auditor;