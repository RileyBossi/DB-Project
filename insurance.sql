-- Member table
CREATE TABLE Members(
    member_ID INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR,
    member_phone_no VARCHAR(10) NOT NULL,
    member_email VARCHAR(50),
    CONSTRAINT pk_member PRIMARY KEY (member_ID)
);

-- Insurance Plan Table
CREATE TABLE Insurance_Plans (
    plan_ID INTEGER NOT NULL,
    plan_name VARCHAR(30) NOT NULL,
    deductible DECIMAL(10,2) NOT NULL,
    coverage_details VARCHAR(100) NOT NULL,
    CONSTRAINT pk_insurance_plans PRIMARY KEY (plan_ID),
    CONSTRAINT chk_insurance_deductible
        CHECK  (deductible BETWEEN 0 AND 10000) 
);

-- Member Policies Table
CREATE TABLE Member_Policies(
    policy_ID INTEGER NOT NULL,
    member_ID INTEGER NOT NULL,
    plan_ID INTEGER NOT NULL,
    effective_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    CONSTRAINT pk_member_policies PRIMARY KEY (policy_ID),
    CONSTRAINT fk_member_policies_members FOREIGN KEY (member_ID)
        REFERENCES Members (member_ID),
    CONSTRAINT fk_member_policies_insurance_plans FOREIGN KEY (plan_ID)
        REFERENCES Insurance_Plans (plan_ID),
    CONSTRAINT uq_member_policy_pair
        UNIQUE (policy_ID, member_ID),
    CONSTRAINT chk_member_policies_dates
        CHECK (expiration_date > effective_date)
);

-- Provider Table
CREATE TABLE Provider (
    provider_ID INTEGER NOT NULL,
    provider_name VARCHAR(30) NOT NULL,
    speciality VARCHAR(50),
    provider_phone VARCHAR(10) NOT NULL,
    provider_email VARCHAR(50) NOT NULL,
    CONSTRAINT pk_provider PRIMARY KEY (provider_ID)
);

-- Employee table
CREATE TABLE Employee (
    employee_ID INTEGER NOT NULL,
    role VARCHAR(20) NOT NULL,
    name VARCHAR(30) NOT NULL, 
    login VARCHAR(50) NOT NULL,
    CONSTRAINT pk_employee PRIMARY KEY (employee_ID),
    CONSTRAINT uq_employee_login UNIQUE (login),
    CONSTRAINT chk_employee_role
        CHECK (role IN ('Administrator', 'Claims Processor', 'Representative', 'Auditor'))
);

-- Claims table
CREATE TABLE Claims (
    claim_ID INTEGER NOT NULL,
    provider_ID INTEGER NOT NULL,
    member_ID INTEGER NOT NULL,
    policy_ID INTEGER NOT NULL,
    employee_ID INTEGER NOT NULL,
    claim_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_claims PRIMARY KEY (claim_ID),
    CONSTRAINT fk_claims_provider FOREIGN KEY (provider_ID)
        REFERENCES Provider (provider_ID),
    CONSTRAINT fk_claims_members FOREIGN KEY (member_ID)
        REFERENCES Members (member_ID),
    CONSTRAINT fk_claims_policy FOREIGN KEY (policy_ID, member_ID)
        REFERENCES Member_Policies (policy_id, member_ID),
    CONSTRAINT fk_claims_employee FOREIGN KEY (employee_ID)
        REFERENCES Employee (employee_ID),
    CONSTRAINT chk_claims_amount 
        CHECK (amount >= 0),
    CONSTRAINT chk_claims_status
        CHECK (status IN ('Pending', 'Approved', 'Denied'))
);

-- Payments table
CREATE TABLE Payments (
    payment_ID INTEGER NOT NULL,
    claim_ID INTEGER NOT NULL,
    approved_amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_ID),
    CONSTRAINT fk_payments_claims FOREIGN KEY (claim_ID)
        REFERENCES Claims (claim_ID),
    CONSTRAINT chk_payments_amount
        CHECK (approved_amount >= 0)
);

-- Audit logs table
CREATE TABLE Audit_Logs (
    log_ID INTEGER NOT NULL,
    employee_ID INTEGER,
    action VARCHAR(50) NOT NULL,
    affected_record VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    CONSTRAINT pk_audit_logs PRIMARY KEY (log_ID),
    CONSTRAINT fk_audit_logs_employee FOREIGN KEY (employee_ID)
        REFERENCES Employee (employee_ID)
);