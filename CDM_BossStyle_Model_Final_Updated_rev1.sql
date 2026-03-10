/* ============================================================================
   CDM Boss-Style Model - Final Updated SQL Server DDL
   Generated from: CDM_BossStyle_Model_Final_Updated.xlsx

   Purpose
   - Provider-centric normalized subject-area model
   - Includes new lookup/reference tables added in the final update
   - Uses bridge tables for many-to-many relationships
   - Uses profile tables for operational/provider extension attributes

   Notes
   - Single-column BIGINT surrogate primary keys use IDENTITY(1,1)
   - Foreign keys are created inline in dependency order
   - Review code-set/lookup content before PROD deployment
============================================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO


/* -------------------- Provider_Status -------------------- */
CREATE TABLE dbo.[Provider_Status] (
    [Provider_Status_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key,
    [Provider_Status_Name] VARCHAR(50) NOT NULL -- Controlled provider status,
    [Is_Active] BIT NOT NULL -- Active indicator,
    CONSTRAINT [PK_Provider_Status] PRIMARY KEY ([Provider_Status_ID])
);
GO


/* -------------------- Department -------------------- */
CREATE TABLE dbo.[Department] (
    [Department_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key for provider departments / service locations,
    [Department_Name] VARCHAR(200) NOT NULL -- CDM: Department / Department Name,
    [Bill_Area] VARCHAR(100) NULL -- CDM: Bill Area,
    [Bill_Area_Name] VARCHAR(200) NULL -- CDM: Bill Area Name,
    [Place_Of_Service] VARCHAR(100) NULL -- CDM: Place of Service / POS Code Title,
    [Location_Name] VARCHAR(200) NULL -- CDM: Location,
    CONSTRAINT [PK_Department] PRIMARY KEY ([Department_ID])
);
GO


/* -------------------- Address_Type -------------------- */
CREATE TABLE dbo.[Address_Type] (
    [Address_Type_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key,
    [Address_Type_Name] VARCHAR(50) NOT NULL -- Controlled address type,
    [Is_Active] BIT NOT NULL -- Active indicator,
    CONSTRAINT [PK_Address_Type] PRIMARY KEY ([Address_Type_ID])
);
GO


/* -------------------- Contact_Type -------------------- */
CREATE TABLE dbo.[Contact_Type] (
    [Contact_Type_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key,
    [Contact_Type_Name] VARCHAR(50) NOT NULL -- Controlled contact type,
    [Is_Active] BIT NOT NULL -- Active indicator,
    CONSTRAINT [PK_Contact_Type] PRIMARY KEY ([Contact_Type_ID])
);
GO


/* -------------------- License_Type -------------------- */
CREATE TABLE dbo.[License_Type] (
    [License_Type_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key,
    [License_Type_Name] VARCHAR(100) NOT NULL -- Controlled license type,
    [Is_Active] BIT NOT NULL -- Active indicator,
    CONSTRAINT [PK_License_Type] PRIMARY KEY ([License_Type_ID])
);
GO


/* -------------------- License_Category -------------------- */
CREATE TABLE dbo.[License_Category] (
    [License_Category_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key,
    [License_Category_Name] VARCHAR(100) NOT NULL -- Controlled license category,
    [Is_Active] BIT NOT NULL -- Active indicator,
    CONSTRAINT [PK_License_Category] PRIMARY KEY ([License_Category_ID])
);
GO


/* -------------------- Specialty -------------------- */
CREATE TABLE dbo.[Specialty] (
    [Specialty_Code] VARCHAR(50) NOT NULL -- Master specialty code,
    [Specialty_Name] VARCHAR(150) NOT NULL -- CDM: Specialty / Reading Specialty / MGMA Specialty,
    [Specialty_Type] VARCHAR(50) NULL -- Clinical | Reading | MGMA | Surgical | Anesthesia,
    [Description] VARCHAR(500) NULL,
    CONSTRAINT [PK_Specialty] PRIMARY KEY ([Specialty_Code])
);
GO


/* -------------------- Taxonomy -------------------- */
CREATE TABLE dbo.[Taxonomy] (
    [Taxonomy_Code] VARCHAR(20) NOT NULL -- Master provider taxonomy code,
    [Description] VARCHAR(200) NOT NULL -- CDM: Taxonomy,
    [Source_System] VARCHAR(50) NULL -- Originating source if maintained externally,
    CONSTRAINT [PK_Taxonomy] PRIMARY KEY ([Taxonomy_Code])
);
GO


/* -------------------- Privilege -------------------- */
CREATE TABLE dbo.[Privilege] (
    [Privilege_Code] VARCHAR(50) NOT NULL -- Master privilege / authorization code,
    [Privilege_Name] VARCHAR(200) NOT NULL -- Admitting privilege, surgical service, ordering authority, etc.,
    [Privilege_Category] VARCHAR(50) NOT NULL -- Admitting | Attending | Surgical | Ordering | ED | Inpatient,
    [Description] VARCHAR(500) NULL,
    CONSTRAINT [PK_Privilege] PRIMARY KEY ([Privilege_Code])
);
GO


/* -------------------- Network -------------------- */
CREATE TABLE dbo.[Network] (
    [Network_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Network_Name] VARCHAR(200) NOT NULL -- CDM: Network (SER 19700),
    [Network_Level] VARCHAR(50) NULL -- CDM: Network Level / Default Network Level,
    [Indemnity_Flag] BIT NULL -- CDM: Indemnity Network YN,
    [MIPS_TIN] VARCHAR(15) NULL -- CDM: MIPS TIN / Tax Identification Number (TIN),
    CONSTRAINT [PK_Network] PRIMARY KEY ([Network_ID])
);
GO


/* -------------------- Provider -------------------- */
CREATE TABLE dbo.[Provider] (
    [Provider_ID] BIGINT IDENTITY(1,1) NOT NULL -- Surrogate key / MDM ID,
    [Source_Provider_ID] VARCHAR(50) NOT NULL -- CDM: EPIC ID / Epic Number; source-system identifier,
    [Provider_Name] VARCHAR(200) NOT NULL -- CDM: Name,
    [Alias] VARCHAR(200) NULL -- CDM: Alias,
    [Title] VARCHAR(100) NULL -- CDM: Title,
    [Abbreviation] VARCHAR(100) NULL -- CDM: Abbreviation,
    [Provider_Type] VARCHAR(50) NOT NULL -- CDM: Type of Staff/Resource,
    [Person_NonPerson_Type] VARCHAR(20) NULL -- CDM: Type of Staff/Resources [Person vs. Non-Person],
    [NPI] VARCHAR(10) NULL -- CDM: NPI,
    [Provider_Status_ID] BIGINT NOT NULL -- Normalized provider status lookup replacing free-text Status,
    [Verified_Flag] BIT NULL -- CDM: Verified,
    [Effective_Date] DATE NULL -- CDM: Effective Date / Eff Date (SER 19720),
    [Start_Date] DATE NULL -- CDM: Start Date,
    [Departure_Date] DATE NULL -- CDM: Departure Date (SER 8116) / Term Date,
    [Sex] VARCHAR(20) NULL -- CDM: Sex,
    [Language] VARCHAR(100) NULL -- CDM: Language,
    [Degree] VARCHAR(100) NULL -- CDM: Degree,
    [Resident_Flag] BIT NULL -- CDM: Provider Is A Resident YN,
    [Supervisor_Provider_ID] BIGINT NULL -- CDM: Supervisor; self-reference to Provider,
    [Created_On_The_Fly_Flag] BIT NULL -- CDM: Created on The Fly,
    [Created_By] VARCHAR(100) NULL -- CDM: Creating User (SER 9606),
    [Last_Update_DTTM] DATETIME2 NULL -- CDM: Instant of Update DTTM (SER 9080),
    CONSTRAINT [PK_Provider] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Provider_Status_ID_Provider_Status] FOREIGN KEY ([Provider_Status_ID]) REFERENCES dbo.[Provider_Status]([Provider_Status_ID]),
    CONSTRAINT [FK_Provider_Supervisor_Provider_ID_Provider] FOREIGN KEY ([Supervisor_Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Department -------------------- */
CREATE TABLE dbo.[Provider_Department] (
    [Provider_ID] BIGINT NOT NULL,
    [Department_ID] BIGINT NOT NULL,
    [Affiliation_Type] VARCHAR(30) NOT NULL -- Primary | Additional | Scheduling | Clinical,
    [Primary_Flag] BIT NULL -- CDM: Primary Department / Is Primary Office,
    [Scheduling_Inactive_Flag] BIT NULL -- CDM: Scheduling - Inactive Cadence YN,
    [Taking_New_Patients_Flag] BIT NULL -- CDM: Taking New Patients In Department,
    [Searchable_Provider_Finder_Flag] BIT NULL -- CDM: Searchable in Provider Finder,
    [Eff_Start] DATE NOT NULL -- Effective start; part of composite PK,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Department] PRIMARY KEY ([Provider_ID], [Department_ID], [Eff_Start]),
    CONSTRAINT [FK_Provider_Department_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Department_Department_ID_Department] FOREIGN KEY ([Department_ID]) REFERENCES dbo.[Department]([Department_ID])
);
GO


/* -------------------- Address -------------------- */
CREATE TABLE dbo.[Address] (
    [Address_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL -- Provider-scoped address from CDM office/home address fields,
    [Address_Type_ID] BIGINT NOT NULL -- Normalized address type lookup replacing free-text Address_Type,
    [Address_Line1] VARCHAR(200) NULL -- CDM: Office Address / Home Address,
    [Address_Line2] VARCHAR(200) NULL -- CDM: Address Line 2,
    [Address_Line3] VARCHAR(200) NULL -- CDM: Address Line 3,
    [City] VARCHAR(100) NULL -- CDM: Office City,
    [State] CHAR(2) NULL -- CDM: Office State,
    [Zip_Code] VARCHAR(15) NULL -- CDM: Office Zip Code,
    [County] VARCHAR(100) NULL -- CDM: Office County,
    [Country] CHAR(2) NULL -- CDM: Office Country,
    [House_Number] VARCHAR(20) NULL -- CDM: Addr house number (SER 21085),
    [District] VARCHAR(100) NULL -- CDM: Addr district (SER 21086),
    [Primary_Flag] BIT NULL -- CDM: Primary Address / Is Primary Office,
    [Active_Flag] BIT NULL -- CDM: Address Active,
    [Shared_Flag] BIT NULL -- CDM: Shared Address,
    [Internal_Flag] BIT NULL -- CDM: Internal Address,
    [External_Address_ID] VARCHAR(50) NULL -- CDM: Addr unique ID / Address External ID,
    [Address_Location] VARCHAR(200) NULL -- CDM: Address Location / Secondary Address- Practice Name,
    CONSTRAINT [PK_Address] PRIMARY KEY ([Address_ID]),
    CONSTRAINT [FK_Address_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Address_Address_Type_ID_Address_Type] FOREIGN KEY ([Address_Type_ID]) REFERENCES dbo.[Address_Type]([Address_Type_ID])
);
GO


/* -------------------- Contact -------------------- */
CREATE TABLE dbo.[Contact] (
    [Contact_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [Contact_Type_ID] BIGINT NOT NULL -- Normalized contact type lookup replacing free-text Contact_Type,
    [Phone_Number] VARCHAR(25) NULL -- CDM: Phone Number,
    [Fax_Number] VARCHAR(25) NULL -- CDM: Fax Number / Fax Number for Lab's Paper Reports,
    [Email_Address] VARCHAR(200) NULL -- CDM: Email Address (SER 21130) / Email Address,
    [Printer_Name] VARCHAR(100) NULL -- CDM: Printer / Printer for Lab's Paper Reports,
    [Preferred_Communication] VARCHAR(50) NULL -- CDM: Preferred Communication,
    [Contract_Method] VARCHAR(50) NULL -- CDM: Contract Method (SER 21150),
    [Results_Recipient_Type] VARCHAR(50) NULL -- CDM: Results Recipient Type (SER 8114),
    [Address_Fax_Register_Date] DATE NULL -- CDM: Address Fax Register Date (SER 21111),
    [Is_Primary] BIT NULL -- Marks preferred/default contact for the provider,
    CONSTRAINT [PK_Contact] PRIMARY KEY ([Contact_ID]),
    CONSTRAINT [FK_Contact_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Contact_Contact_Type_ID_Contact_Type] FOREIGN KEY ([Contact_Type_ID]) REFERENCES dbo.[Contact_Type]([Contact_Type_ID])
);
GO


/* -------------------- License -------------------- */
CREATE TABLE dbo.[License] (
    [License_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [License_Category_ID] BIGINT NULL -- Normalized license category lookup replacing free-text License_Category,
    [License_Type_ID] BIGINT NULL -- Normalized license type lookup replacing free-text License_Type,
    [License_Number] VARCHAR(40) NULL -- CDM: License Number / DEA Number,
    [License_State] CHAR(2) NULL -- CDM: License State / DEA State,
    [Expiration_Date] DATE NULL -- CDM: License Expiration Date,
    [UPIN] VARCHAR(20) NULL -- CDM: UPIN,
    [Medicaid_Number] VARCHAR(30) NULL -- CDM: Medicaid Number,
    [Board_Certification] VARCHAR(200) NULL -- CDM: Board Certification,
    CONSTRAINT [PK_License] PRIMARY KEY ([License_ID]),
    CONSTRAINT [FK_License_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_License_License_Category_ID_License_Category] FOREIGN KEY ([License_Category_ID]) REFERENCES dbo.[License_Category]([License_Category_ID]),
    CONSTRAINT [FK_License_License_Type_ID_License_Type] FOREIGN KEY ([License_Type_ID]) REFERENCES dbo.[License_Type]([License_Type_ID])
);
GO


/* -------------------- Provider_Specialty -------------------- */
CREATE TABLE dbo.[Provider_Specialty] (
    [Provider_ID] BIGINT NOT NULL,
    [Specialty_Code] VARCHAR(50) NOT NULL,
    [Role_Type] VARCHAR(30) NULL -- Primary | Secondary | Reading | MGMA,
    [Eff_Start] DATE NOT NULL -- Effective start; part of composite PK,
    [Eff_End] DATE NULL,
    [Source_CDE] VARCHAR(150) NULL -- Tracks originating CDM attribute,
    CONSTRAINT [PK_Provider_Specialty] PRIMARY KEY ([Provider_ID], [Specialty_Code], [Eff_Start]),
    CONSTRAINT [FK_Provider_Specialty_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Specialty_Specialty_Code_Specialty] FOREIGN KEY ([Specialty_Code]) REFERENCES dbo.[Specialty]([Specialty_Code])
);
GO


/* -------------------- Provider_Taxonomy -------------------- */
CREATE TABLE dbo.[Provider_Taxonomy] (
    [Provider_ID] BIGINT NOT NULL,
    [Taxonomy_Code] VARCHAR(20) NOT NULL,
    [Primary_Flag] BIT NULL,
    [Eff_Start] DATE NOT NULL -- Composite PK part,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Taxonomy] PRIMARY KEY ([Provider_ID], [Taxonomy_Code], [Eff_Start]),
    CONSTRAINT [FK_Provider_Taxonomy_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Taxonomy_Taxonomy_Code_Taxonomy] FOREIGN KEY ([Taxonomy_Code]) REFERENCES dbo.[Taxonomy]([Taxonomy_Code])
);
GO


/* -------------------- Provider_Privilege -------------------- */
CREATE TABLE dbo.[Provider_Privilege] (
    [Provider_ID] BIGINT NOT NULL,
    [Privilege_Code] VARCHAR(50) NOT NULL,
    [Admitting_Privileges_Flag] BIT NULL -- CDM: Admitting Privileges YN,
    [Admitting_Suspend_Flag] BIT NULL -- CDM: Admitting Privileges Table Suspend YN,
    [Admitting_Location] VARCHAR(200) NULL -- CDM: Admitting Privileges Table Location,
    [Attending_Privileges_Flag] BIT NULL -- CDM: Attending Privilieges YN,
    [Attending_Suspend_Flag] BIT NULL -- CDM: Attending Privileges Table Suspend YN,
    [Attending_Location] VARCHAR(200) NULL -- CDM: Attending Privileges Table Location,
    [Surgical_Record_Type] VARCHAR(100) NULL -- CDM: Surgical Record Type,
    [Surgical_Staff_Type] VARCHAR(100) NULL -- CDM: Surgical Staff Type,
    [Anesthesia_Staff_Type] VARCHAR(100) NULL -- CDM: Anesthesia Staff Type,
    [Authorized_Locations_Text] VARCHAR(1000) NULL -- CDM: Authorized Locations / Authorized Location,
    [Authorized_Surgical_Service_Category] VARCHAR(200) NULL -- CDM: Authorized Surgical Service Category Number,
    [Surgical_Service] VARCHAR(200) NULL -- CDM: Surgical Service,
    [Authorized_Location_Of_Surgical_Procedure] VARCHAR(200) NULL -- CDM: Authorized Location of Surgical Procedure,
    [Authorized_Services_Text] VARCHAR(1000) NULL -- CDM: Authorized Services,
    [Allow_All_Services_Flag] BIT NULL -- CDM: Allow All Services YN,
    [Allow_All_Procedures_Flag] BIT NULL -- CDM: Allow All Procedures for a Service YN,
    [Authorize_All_Locations_Flag] BIT NULL -- CDM: Authorize All Locations YN,
    [Revoked_Flag] BIT NULL -- CDM: Privileges Revoked YN,
    [Eff_Start] DATE NOT NULL -- Composite PK part,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Privilege] PRIMARY KEY ([Provider_ID], [Privilege_Code], [Eff_Start]),
    CONSTRAINT [FK_Provider_Privilege_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Privilege_Privilege_Code_Privilege] FOREIGN KEY ([Privilege_Code]) REFERENCES dbo.[Privilege]([Privilege_Code])
);
GO


/* -------------------- Provider_Network -------------------- */
CREATE TABLE dbo.[Provider_Network] (
    [Network_ID] BIGINT NOT NULL -- Composite PK part,
    [Provider_ID] BIGINT NOT NULL -- Composite PK part,
    [Provider_Network_Level] VARCHAR(50) NULL -- CDM: Provider Network Level,
    [Default_Network_Level] VARCHAR(50) NULL -- CDM: Default Network Level,
    [Status] VARCHAR(20) NULL -- CDM: Status (SER 19710),
    [Eff_Start] DATE NOT NULL -- CDM: Provider Network Level Effective Date / Eff Date (SER 19720),
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Network] PRIMARY KEY ([Network_ID], [Provider_ID], [Eff_Start]),
    CONSTRAINT [FK_Provider_Network_Network_ID_Network] FOREIGN KEY ([Network_ID]) REFERENCES dbo.[Network]([Network_ID]),
    CONSTRAINT [FK_Provider_Network_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Referral_Profile -------------------- */
CREATE TABLE dbo.[Provider_Referral_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Referral_Source_Type] VARCHAR(100) NULL -- CDM: Referral Source Type,
    [Referral_Source_Class] VARCHAR(30) NULL -- CDM: Referral Source Type [Internal or External],
    [Referred_Geographic_Areas] VARCHAR(500) NULL -- CDM: Referred to Geographic Areas (SER 6500),
    [Allow_Refer_To_Provider_Flag] BIT NULL -- CDM: Allow Refer To Provider (SER 6550),
    [Default_Treatment_Team_Relationship] VARCHAR(100) NULL -- CDM: Default treatment team relationship,
    CONSTRAINT [PK_Provider_Referral_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Referral_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Access_Profile -------------------- */
CREATE TABLE dbo.[Provider_Access_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [EMR_Access_Flag] BIT NULL -- CDM: EMR Access,
    [Encounter_Provider_Flag] BIT NULL -- CDM: Encounter Provider YN,
    [Supervising_Provider_Flag] BIT NULL -- CDM: Supervising Provider YN,
    [Supervision_Required_Flag] BIT NULL -- CDM: Supervision Required,
    [Deficiency_Provider_Flag] BIT NULL -- CDM: Deficiency Provider YN,
    [HIM_Status] VARCHAR(50) NULL -- CDM: HIM Status,
    [HIM_Deficiency_Letter_Pref] VARCHAR(100) NULL -- CDM: HIM Deficiency Letter Preference,
    [Chart_Completion_Station] VARCHAR(100) NULL -- CDM: Chart Completion Station,
    [Pool_Record_Flag] BIT NULL -- CDM: Pool Record YN,
    [Meds_Authorizing_Provider_Flag] BIT NULL -- CDM: Meds Authorizing Provider,
    [Pharmacist_Flag] BIT NULL -- CDM: Is Pharmacist YN (SER 8215),
    [Orders_Authorizing_Provider_Flag] BIT NULL -- CDM: Orders Authorizing Prov YN (SER 8220),
    [Treatment_Plan_Provider_Flag] BIT NULL -- CDM: Treatment Plan Provider (SER 8225),
    [Allowed_Episode_Types] VARCHAR(500) NULL -- CDM: Allowed Episode Types (SER 8226),
    [Medical_Authorization_Flag] BIT NULL -- CDM: Medical Authorization YN (SER 8250),
    [ERX_Pool] VARCHAR(100) NULL -- CDM: eRX Pool,
    [EPrescribing_Provider_Flag] BIT NULL -- CDM: E-Prescribing Provider YN,
    [EPrescription_Service_Level] VARCHAR(100) NULL -- CDM: E-Prescription Service Level,
    [EPrescription_Flag] BIT NULL -- CDM: E-Prescription,
    [DEA_State] CHAR(2) NULL -- CDM: DEA State,
    [EPrescribing_Signoff_I] VARCHAR(100) NULL -- CDM: E-Prescribing Sign Off I,
    [EPrescribing_Signoff_II] VARCHAR(100) NULL -- CDM: E-Prescribing Sign Off II,
    [Surescripts_SPI] VARCHAR(50) NULL -- CDM: SPI Sure Scripts,
    [Taking_New_Patients_Flag] BIT NULL -- CDM: Taking New Patients YN (SER 26000),
    [Receive_Patient_Messages_Flag] BIT NULL -- CDM: Receive Patient Messages,
    [EVisit_Flag] BIT NULL -- CDM: E-Visit YN (SER 32015),
    [Receive_Clinical_Update_Direct_Flag] BIT NULL -- CDM: Receive Clinical Update Msg Directly,
    [Unviewed_Test_Result_Notification_Flag] BIT NULL -- CDM: Recieve Unviewed Test Result Notification,
    [Default_Provider_Pool_Clin_Update] VARCHAR(200) NULL -- CDM: Default Provider Pool For Clin Upd Notifications,
    [Provider_Pool_Unviewed_Result] VARCHAR(200) NULL -- CDM: Provider Pool For Unveiwed Test Result Notification,
    [Direct_Scheduling_Flag] BIT NULL -- CDM: Direct Scheduling,
    [Open_Access_Scheduling_Flag] BIT NULL -- CDM: Open Access Scheduling,
    [Ticket_Scheduling_Flag] BIT NULL -- CDM: Ticket Scheduling,
    [Telemedicine_Scheduling_Flag] BIT NULL -- CDM: Telemedicine Scheduling,
    [Medical_Advice_Requests_Flag] BIT NULL -- CDM: Medical Advice Requests,
    [Appointment_Request_Flag] BIT NULL -- CDM: Appointment Request,
    [MyChart_Message_Type] VARCHAR(100) NULL -- CDM: MyChart Message Type,
    [MyChart_Destination] VARCHAR(100) NULL -- CDM: MyChart Destination,
    [MyChart_Provider_Pool] VARCHAR(200) NULL -- CDM: MyChart Provider Pool,
    [Default_Clinical_Pt_Message_Pool] VARCHAR(200) NULL -- CDM: Default Clinical Pt Message Pool (SER 32495),
    [Telehealth_Visits_Flag] BIT NULL -- CDM: Telehealth Visits,
    [Telehealth_State] CHAR(2) NULL -- CDM: Telehealth State,
    [Collect_RSM_Flag] BIT NULL -- CDM: Collect RSM YN,
    [Allow_Scheduling_Outside_Department_Flag] BIT NULL -- CDM: Allow Scheduling Outside Department YN,
    CONSTRAINT [PK_Provider_Access_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Access_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Operational_Profile -------------------- */
CREATE TABLE dbo.[Provider_Operational_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [RPT_Group_Six_PB_Provider_Flag] BIT NULL -- CDM: RPT GRP SIX ID / PB Provider YN,
    [RPT_Group_Nine_Referring_Grouper] VARCHAR(100) NULL -- CDM: RPT GRP NINE ID / Referring Provider Grouper,
    [RPT_Group_Twelve_Market_Area] VARCHAR(100) NULL -- CDM: RPT GRP TWELVE ID / Market Area,
    [Patient_Age_From] INT NULL -- CDM: Patient Age From,
    [Patient_Age_To] INT NULL -- CDM: Patient Age To,
    CONSTRAINT [PK_Provider_Operational_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Operational_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Quality_Compliance -------------------- */
CREATE TABLE dbo.[Provider_Quality_Compliance] (
    [Provider_ID] BIGINT NOT NULL,
    [Quality_Measure] VARCHAR(200) NULL -- CDM: Quality Measure (SER 12000),
    [Quality_Reporting_Option] VARCHAR(100) NULL -- CDM: Quality Measure reporting Option,
    [Quality_Report_Year] INT NULL -- CDM: Quality Measure Report Year,
    [Quality_Override_System_Measures_Flag] BIT NULL -- CDM: Quality Measure Override System Measures YN,
    [MU_Eligible_Professional_Flag] BIT NULL -- CDM: Meaningful Use Eligible Professional YN,
    [MU_Submission_Year] INT NULL -- CDM: Meaningful Use Submission Year,
    [MU_Stage] VARCHAR(50) NULL -- CDM: Meaningful Use Stage,
    [MU_Year_In_Stage] INT NULL -- CDM: Meaningful Use Year In Stage,
    [MU_Submission_Date] DATE NULL -- CDM: Meaningful Use Submission Date,
    [MU_Program] VARCHAR(100) NULL -- CDM: Meaningful Use Program,
    [MU_Objective] VARCHAR(200) NULL -- CDM: Meaningful Use Objective,
    [MU_Attestation_Year] INT NULL -- CDM: Meaningful Use Eligible Provider Attestation Year,
    [MU_Status] VARCHAR(50) NULL -- CDM: Meaningful Use Status,
    [MU_Effective_Date] DATE NULL -- CDM: Meaningful Use Effective Date,
    [MU_Attestation_End_Date] DATE NULL -- CDM: Meaningful Use Eligible Provider Attestation End Date,
    [MU_Exclude_System_Settings_Flag] BIT NULL -- CDM: Meaningful Use Exclude System Settings,
    [Enrollment_Status_With_Payers] VARCHAR(200) NULL -- CDM: Enrollment Status with Payers,
    [Recredentialing_Due_Date] DATE NULL -- CDM: Recredentialing Due Date,
    [Continuing_Education_Status] VARCHAR(100) NULL -- CDM: Continuing Education Status,
    [Sanctions_Disciplinary_Actions] VARCHAR(500) NULL -- CDM: Sanctions / Disciplinary Actions,
    [HIPAA_Training_Completion] VARCHAR(100) NULL -- CDM: HIPAA Training Completion,
    [Background_Check_Status] VARCHAR(100) NULL -- CDM: Background Check Status,
    CONSTRAINT [PK_Provider_Quality_Compliance] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Quality_Compliance_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Employment -------------------- */
CREATE TABLE dbo.[Employment] (
    [Employment_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [EE_Number] VARCHAR(50) NULL -- CDM: EE Number,
    [Employee_Name] VARCHAR(200) NULL -- CDM: Employee Name,
    [Employment_Status] VARCHAR(50) NULL -- CDM: Employment Status,
    [Position_Title] VARCHAR(100) NULL -- CDM: Position,
    [Job_Code] VARCHAR(50) NULL -- CDM: Job Code,
    [Job_Code_Title] VARCHAR(100) NULL -- CDM: Job Code Title,
    [Department_ID] BIGINT NULL -- Normalized department foreign key replacing free-text Department_Name,
    [Work_Email_Address] VARCHAR(200) NULL -- CDM: Email Address,
    [Employment_Type] VARCHAR(50) NULL -- CDM: Employed/PSA,
    [FTE] DECIMAL(5,2) NULL -- CDM: FTE,
    [Home_Address] VARCHAR(200) NULL -- CDM: Home Address,
    [Tax_Identification_Number] VARCHAR(15) NULL -- CDM: IRS # / Tax Identification Number (TIN),
    [Tax_ID_Eff_From] DATE NULL -- CDM: IRS # Effective From,
    [Tax_ID_Eff_To] DATE NULL -- CDM: IRS # Effective To,
    [LexisNexis_ID] VARCHAR(50) NULL -- CDM: LexisNexisID,
    CONSTRAINT [PK_Employment] PRIMARY KEY ([Employment_ID]),
    CONSTRAINT [FK_Employment_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Employment_Department_ID_Department] FOREIGN KEY ([Department_ID]) REFERENCES dbo.[Department]([Department_ID])
);
GO


/* -------------------- Provider_Web_Profile -------------------- */
CREATE TABLE dbo.[Provider_Web_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Photo_URL] VARCHAR(500) NULL -- CDM: Photo / Photograph URL,
    [Website_URL] VARCHAR(500) NULL -- CDM: Website URL,
    [Profile_URL] VARCHAR(500) NULL -- CDM: Profile URL,
    [Appointment_URL] VARCHAR(500) NULL -- CDM: Appointment URL,
    [Virtual_Care_URL] VARCHAR(500) NULL -- CDM: Virtual Care URL,
    [Biography] VARCHAR(4000) NULL -- CDM: Biography,
    [Certifications] VARCHAR(1000) NULL -- CDM: Certifications,
    [Honors_Awards] VARCHAR(1000) NULL -- CDM: Honors and Awards,
    [Affiliations_Text] VARCHAR(1000) NULL -- CDM: Affiliations,
    [Publication_Links] VARCHAR(1000) NULL -- CDM: Publication Links,
    [Video_Links] VARCHAR(1000) NULL -- CDM: Video Links,
    [Facebook_URL] VARCHAR(500) NULL -- CDM: Facebook URL,
    [Twitter_URL] VARCHAR(500) NULL -- CDM: Twitter URL,
    [LinkedIn_URL] VARCHAR(500) NULL -- CDM: LinkedIn URL,
    [YouTube_URL] VARCHAR(500) NULL -- CDM: Youtube URL,
    [Doximity_URL] VARCHAR(500) NULL -- CDM: Doximity URL,
    CONSTRAINT [PK_Provider_Web_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Web_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Credentialing_Profile -------------------- */
CREATE TABLE dbo.[Provider_Credentialing_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Doctor_Credentials] VARCHAR(500) NULL -- CDM: Doctor Credentials,
    [Reading_Specialty] VARCHAR(150) NULL -- CDM: Reading Specialty (SER 52003),
    [IP_Default_Relationship] VARCHAR(100) NULL -- CDM: IP Default Relationship,
    [IP_Provider_Licensure] VARCHAR(100) NULL -- CDM: IP Provider Licensure (SER 34851),
    [IP_Provider_Discipline] VARCHAR(100) NULL -- CDM: IP Provider Discipline (SER 34901),
    [Hospitalist_Flag] BIT NULL -- CDM: Hospitalist YN (SER 34910),
    [Inpatient_Ordering_Provider_Flag] BIT NULL -- CDM: Inpatient Ordering Provider (SER 34920),
    [Outpatient_Ordering_Provider_Flag] BIT NULL -- CDM: Outpatient Ordering Provider (SER 32921),
    [Default_ED_Provider_Flag] BIT NULL -- CDM: Default ED Provider YN (SER 49000),
    [ED_Can_Supervise_Flag] BIT NULL -- CDM: ED - Can Supervise YN,
    [ED_Needs_Supervision_Flag] BIT NULL -- CDM: ED - Needs Supervision YN,
    [Modality_Type] VARCHAR(100) NULL -- CDM: Modality Type (SER 52000),
    [Imaging_Study_IB_Preference] VARCHAR(100) NULL -- CDM: Imaging Study IB Preference (52100),
    [Education_Training_History] VARCHAR(2000) NULL -- CDM: Education & Training History,
    [Malpractice_Insurance_Details] VARCHAR(1000) NULL -- CDM: Malpractice Insurance Details,
    CONSTRAINT [PK_Provider_Credentialing_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Credentialing_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO

/* -------------------- Recommended Indexes -------------------- */
CREATE UNIQUE INDEX [UX_Provider_Source_Provider_ID]
    ON dbo.[Provider]([Source_Provider_ID]);
GO

CREATE INDEX [IX_Address_Provider_ID]
    ON dbo.[Address]([Provider_ID]);
GO

CREATE INDEX [IX_Contact_Provider_ID]
    ON dbo.[Contact]([Provider_ID]);
GO

CREATE INDEX [IX_License_Provider_ID]
    ON dbo.[License]([Provider_ID]);
GO

CREATE INDEX [IX_Employment_Provider_ID]
    ON dbo.[Employment]([Provider_ID]);
GO

CREATE INDEX [IX_Provider_Department_Department_ID]
    ON dbo.[Provider_Department]([Department_ID]);
GO

CREATE INDEX [IX_Provider_Specialty_Specialty_ID]
    ON dbo.[Provider_Specialty]([Specialty_ID]);
GO

CREATE INDEX [IX_Provider_Taxonomy_Taxonomy_ID]
    ON dbo.[Provider_Taxonomy]([Taxonomy_ID]);
GO

CREATE INDEX [IX_Provider_Privilege_Privilege_ID]
    ON dbo.[Provider_Privilege]([Privilege_ID]);
GO

CREATE INDEX [IX_Provider_Network_Network_ID]
    ON dbo.[Provider_Network]([Network_ID]);
GO
