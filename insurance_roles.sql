/*Create Administrator role and assign permissions*/
CREATE ROLE Administrator NOLOGIN;
GRANT SELECT, INSERT, UPDATE ON Insurance_plans TO Administrator;
GRANT SELECT, INSERT, UPDATE ON Provider TO Administrator;
GRANT SELECT ON Claims TO Administrator;
GRANT SELECT, INSERT ON Payments TO Administrator;
GRANT SELECT, INSERT, UPDATE ON Employee TO Administrator;

/*Create Claims_processor role and assign permissions*/
CREATE ROLE Claims_processor NOLOGIN;
GRANT SELECT ON Members TO Claims_processor;
GRANT SELECT ON Insurance_Plans TO Claims_processor;
GRANT SELECT ON Member_Policies TO Claims_processor;
GRANT SELECT ON Provider TO Claims_processor;
GRANT SELECT ON Claims TO Claims_processor;
GRANT UPDATE(status) ON Claims TO Claims_processor;
GRANT SELECT ON Payments TO Claims_processor;

/*Create Representative role and assign permissions*/
CREATE ROLE Representative NOLOGIN;
GRANT SELECT(member_ID, name, address, member_phone_no, member_email) ON Members TO Representative;
GRANT SELECT ON Insurance_Plans TO Representative;
GRANT SELECT ON Member_Policies TO Representative;
GRANT UPDATE(effective_date, expiration_date) ON Member_Policies TO Representative;
GRANT SELECT ON Provider TO Representative;
GRANT INSERT ON Claims TO Representative;

/*Create Auditor role and assign permissions*/
CREATE ROLE Auditor NOLOGIN;
GRANT SELECT ON Claims TO Auditor;
GRANT SELECT ON Payments TO Auditor;
GRANT SELECT ON Audit_Logs TO Auditor;

/*Enable RLS*/
ALTER TABLE Members ENABLE ROW LEVEL SECURITY;
ALTER TABLE Member_Policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE Claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE Payments ENABLE ROW LEVEL SECURITY;

/*Administrator*/
/*Claims*/
CREATE POLICY administrator_claims_select ON Claims
FOR SELECT TO Administrator
USING (true);

/*Payments*/
CREATE POLICY adminstrator_payments_select ON Payments
FOR SELECT TO Administrator
USING (true);

CREATE POLICY adminstrator_payments_insert ON Payments
FOR SELECT TO Administrator
WITH CHECK (EXISTS (
  SELECT 1
  FROM Claims
  WHERE CLAIMS.claim_ID = Payments.claim_ID
  AND Claims.status = 'Approved'
));

/*Claims Processor*/
CREATE POLICY claims_processor_members_select ON Members
FOR SELECT TO Claims_Processor
/*Representative*/
/*Auditor*/

