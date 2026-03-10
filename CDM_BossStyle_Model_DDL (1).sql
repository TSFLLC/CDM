/* ============================================================================
   CDM Boss-Style Provider Model - SQL Server DDL
   Source workbook: CDM_BossStyle_Model.xlsx
   Generated from the normalized subject-area model tabs in the workbook.

   Notes
   - This script creates the provider-centric model in the same style as the
     workbook you approved.
   - Non-model tabs were intentionally excluded:
       README, CDM_Row_Mapping, Model_Summary, Open_Items
   - For single-column BIGINT surrogate keys ending in _ID, IDENTITY(1,1) is used.
   - Review reference/code domains and business rules before PROD deployment.
============================================================================ */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO


/* -------------------- Provider -------------------- */
CREATE TABLE dbo.[Provider] (
    [Provider_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Source_Provider_ID] VARCHAR(50) NOT NULL,
    [Provider_Name] VARCHAR(200) NOT NULL,
    [Alias] VARCHAR(200) NULL,
    [Title] VARCHAR(100) NULL,
    [Abbreviation] VARCHAR(100) NULL,
    [Provider_Type] VARCHAR(50) NOT NULL,
    [Person_NonPerson_Type] VARCHAR(20) NULL,
    [NPI] VARCHAR(10) NULL,
    [Status] VARCHAR(20) NOT NULL,
    [Verified_Flag] BIT NULL,
    [Effective_Date] DATE NULL,
    [Start_Date] DATE NULL,
    [Departure_Date] DATE NULL,
    [Sex] VARCHAR(20) NULL,
    [Language] VARCHAR(100) NULL,
    [Degree] VARCHAR(100) NULL,
    [Resident_Flag] BIT NULL,
    [Supervisor_Provider_ID] BIGINT NULL,
    [Created_On_The_Fly_Flag] BIT NULL,
    [Created_By] VARCHAR(100) NULL,
    [Last_Update_DTTM] DATETIME2 NULL,
    CONSTRAINT [PK_Provider] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Supervisor_Provider_ID_Provider] FOREIGN KEY ([Supervisor_Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Department -------------------- */
CREATE TABLE dbo.[Department] (
    [Department_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Department_Name] VARCHAR(200) NOT NULL,
    [Bill_Area] VARCHAR(100) NULL,
    [Bill_Area_Name] VARCHAR(200) NULL,
    [Place_Of_Service] VARCHAR(100) NULL,
    [Location_Name] VARCHAR(200) NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY ([Department_ID])
);
GO


/* -------------------- Specialty -------------------- */
CREATE TABLE dbo.[Specialty] (
    [Specialty_Code] VARCHAR(50) NOT NULL,
    [Specialty_Name] VARCHAR(150) NOT NULL,
    [Specialty_Type] VARCHAR(50) NULL,
    [Description] VARCHAR(500) NULL,
    CONSTRAINT [PK_Specialty] PRIMARY KEY ([Specialty_Code])
);
GO


/* -------------------- Taxonomy -------------------- */
CREATE TABLE dbo.[Taxonomy] (
    [Taxonomy_Code] VARCHAR(20) NOT NULL,
    [Description] VARCHAR(200) NOT NULL,
    [Source_System] VARCHAR(50) NULL,
    CONSTRAINT [PK_Taxonomy] PRIMARY KEY ([Taxonomy_Code])
);
GO


/* -------------------- Privilege -------------------- */
CREATE TABLE dbo.[Privilege] (
    [Privilege_Code] VARCHAR(50) NOT NULL,
    [Privilege_Name] VARCHAR(200) NOT NULL,
    [Privilege_Category] VARCHAR(50) NOT NULL,
    [Description] VARCHAR(500) NULL,
    CONSTRAINT [PK_Privilege] PRIMARY KEY ([Privilege_Code])
);
GO


/* -------------------- Network -------------------- */
CREATE TABLE dbo.[Network] (
    [Network_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Network_Name] VARCHAR(200) NOT NULL,
    [Network_Level] VARCHAR(50) NULL,
    [Indemnity_Flag] BIT NULL,
    [MIPS_TIN] VARCHAR(15) NULL,
    CONSTRAINT [PK_Network] PRIMARY KEY ([Network_ID])
);
GO


/* -------------------- Provider_Department -------------------- */
CREATE TABLE dbo.[Provider_Department] (
    [Provider_ID] BIGINT NOT NULL,
    [Department_ID] BIGINT NOT NULL,
    [Affiliation_Type] VARCHAR(30) NOT NULL,
    [Primary_Flag] BIT NULL,
    [Scheduling_Inactive_Flag] BIT NULL,
    [Taking_New_Patients_Flag] BIT NULL,
    [Searchable_Provider_Finder_Flag] BIT NULL,
    [Eff_Start] DATE NOT NULL,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Department] PRIMARY KEY ([Provider_ID], [Department_ID], [Eff_Start]),
    CONSTRAINT [FK_Provider_Department_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Department_Department_ID_Department] FOREIGN KEY ([Department_ID]) REFERENCES dbo.[Department]([Department_ID])
);
GO


/* -------------------- Address -------------------- */
CREATE TABLE dbo.[Address] (
    [Address_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [Address_Type] VARCHAR(20) NOT NULL,
    [Address_Line1] VARCHAR(200) NULL,
    [Address_Line2] VARCHAR(200) NULL,
    [Address_Line3] VARCHAR(200) NULL,
    [City] VARCHAR(100) NULL,
    [State] CHAR(2) NULL,
    [Zip_Code] VARCHAR(15) NULL,
    [County] VARCHAR(100) NULL,
    [Country] CHAR(2) NULL,
    [House_Number] VARCHAR(20) NULL,
    [District] VARCHAR(100) NULL,
    [Primary_Flag] BIT NULL,
    [Active_Flag] BIT NULL,
    [Shared_Flag] BIT NULL,
    [Internal_Flag] BIT NULL,
    [External_Address_ID] VARCHAR(50) NULL,
    [Address_Location] VARCHAR(200) NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY ([Address_ID]),
    CONSTRAINT [FK_Address_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Contact -------------------- */
CREATE TABLE dbo.[Contact] (
    [Contact_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [Contact_Type] VARCHAR(30) NOT NULL,
    [Phone_Number] VARCHAR(25) NULL,
    [Fax_Number] VARCHAR(25) NULL,
    [Email_Address] VARCHAR(200) NULL,
    [Printer_Name] VARCHAR(100) NULL,
    [Preferred_Communication] VARCHAR(50) NULL,
    [Contract_Method] VARCHAR(50) NULL,
    [Results_Recipient_Type] VARCHAR(50) NULL,
    [Address_Fax_Register_Date] DATE NULL,
    CONSTRAINT [PK_Contact] PRIMARY KEY ([Contact_ID]),
    CONSTRAINT [FK_Contact_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- License -------------------- */
CREATE TABLE dbo.[License] (
    [License_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [License_Category] VARCHAR(50) NULL,
    [License_Type] VARCHAR(50) NULL,
    [License_Number] VARCHAR(40) NULL,
    [License_State] CHAR(2) NULL,
    [Expiration_Date] DATE NULL,
    [UPIN] VARCHAR(20) NULL,
    [Medicaid_Number] VARCHAR(30) NULL,
    [Board_Certification] VARCHAR(200) NULL,
    CONSTRAINT [PK_License] PRIMARY KEY ([License_ID]),
    CONSTRAINT [FK_License_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Specialty -------------------- */
CREATE TABLE dbo.[Provider_Specialty] (
    [Provider_ID] BIGINT NOT NULL,
    [Specialty_Code] VARCHAR(50) NOT NULL,
    [Role_Type] VARCHAR(30) NULL,
    [Eff_Start] DATE NOT NULL,
    [Eff_End] DATE NULL,
    [Source_CDE] VARCHAR(150) NULL,
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
    [Eff_Start] DATE NOT NULL,
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
    [Admitting_Privileges_Flag] BIT NULL,
    [Admitting_Suspend_Flag] BIT NULL,
    [Admitting_Location] VARCHAR(200) NULL,
    [Attending_Privileges_Flag] BIT NULL,
    [Attending_Suspend_Flag] BIT NULL,
    [Attending_Location] VARCHAR(200) NULL,
    [Surgical_Record_Type] VARCHAR(100) NULL,
    [Surgical_Staff_Type] VARCHAR(100) NULL,
    [Anesthesia_Staff_Type] VARCHAR(100) NULL,
    [Authorized_Locations_Text] VARCHAR(1000) NULL,
    [Authorized_Surgical_Service_Category] VARCHAR(200) NULL,
    [Surgical_Service] VARCHAR(200) NULL,
    [Authorized_Location_Of_Surgical_Procedure] VARCHAR(200) NULL,
    [Authorized_Services_Text] VARCHAR(1000) NULL,
    [Allow_All_Services_Flag] BIT NULL,
    [Allow_All_Procedures_Flag] BIT NULL,
    [Authorize_All_Locations_Flag] BIT NULL,
    [Revoked_Flag] BIT NULL,
    [Eff_Start] DATE NOT NULL,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Privilege] PRIMARY KEY ([Provider_ID], [Privilege_Code], [Eff_Start]),
    CONSTRAINT [FK_Provider_Privilege_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID]),
    CONSTRAINT [FK_Provider_Privilege_Privilege_Code_Privilege] FOREIGN KEY ([Privilege_Code]) REFERENCES dbo.[Privilege]([Privilege_Code])
);
GO


/* -------------------- Provider_Network -------------------- */
CREATE TABLE dbo.[Provider_Network] (
    [Network_ID] BIGINT NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [Provider_Network_Level] VARCHAR(50) NULL,
    [Default_Network_Level] VARCHAR(50) NULL,
    [Status] VARCHAR(20) NULL,
    [Eff_Start] DATE NOT NULL,
    [Eff_End] DATE NULL,
    CONSTRAINT [PK_Provider_Network] PRIMARY KEY ([Network_ID], [Provider_ID], [Eff_Start]),
    CONSTRAINT [FK_Provider_Network_Network_ID_Network] FOREIGN KEY ([Network_ID]) REFERENCES dbo.[Network]([Network_ID]),
    CONSTRAINT [FK_Provider_Network_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Referral_Profile -------------------- */
CREATE TABLE dbo.[Provider_Referral_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Referral_Source_Type] VARCHAR(100) NULL,
    [Referral_Source_Class] VARCHAR(30) NULL,
    [Referred_Geographic_Areas] VARCHAR(500) NULL,
    [Allow_Refer_To_Provider_Flag] BIT NULL,
    [Default_Treatment_Team_Relationship] VARCHAR(100) NULL,
    CONSTRAINT [PK_Provider_Referral_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Referral_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Access_Profile -------------------- */
CREATE TABLE dbo.[Provider_Access_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [EMR_Access_Flag] BIT NULL,
    [Encounter_Provider_Flag] BIT NULL,
    [Supervising_Provider_Flag] BIT NULL,
    [Supervision_Required_Flag] BIT NULL,
    [Deficiency_Provider_Flag] BIT NULL,
    [HIM_Status] VARCHAR(50) NULL,
    [HIM_Deficiency_Letter_Pref] VARCHAR(100) NULL,
    [Chart_Completion_Station] VARCHAR(100) NULL,
    [Pool_Record_Flag] BIT NULL,
    [Meds_Authorizing_Provider_Flag] BIT NULL,
    [Pharmacist_Flag] BIT NULL,
    [Orders_Authorizing_Provider_Flag] BIT NULL,
    [Treatment_Plan_Provider_Flag] BIT NULL,
    [Allowed_Episode_Types] VARCHAR(500) NULL,
    [Medical_Authorization_Flag] BIT NULL,
    [ERX_Pool] VARCHAR(100) NULL,
    [EPrescribing_Provider_Flag] BIT NULL,
    [EPrescription_Service_Level] VARCHAR(100) NULL,
    [EPrescription_Flag] BIT NULL,
    [DEA_State] CHAR(2) NULL,
    [EPrescribing_Signoff_I] VARCHAR(100) NULL,
    [EPrescribing_Signoff_II] VARCHAR(100) NULL,
    [Surescripts_SPI] VARCHAR(50) NULL,
    [Taking_New_Patients_Flag] BIT NULL,
    [Receive_Patient_Messages_Flag] BIT NULL,
    [EVisit_Flag] BIT NULL,
    [Receive_Clinical_Update_Direct_Flag] BIT NULL,
    [Unviewed_Test_Result_Notification_Flag] BIT NULL,
    [Default_Provider_Pool_Clin_Update] VARCHAR(200) NULL,
    [Provider_Pool_Unviewed_Result] VARCHAR(200) NULL,
    [Direct_Scheduling_Flag] BIT NULL,
    [Open_Access_Scheduling_Flag] BIT NULL,
    [Ticket_Scheduling_Flag] BIT NULL,
    [Telemedicine_Scheduling_Flag] BIT NULL,
    [Medical_Advice_Requests_Flag] BIT NULL,
    [Appointment_Request_Flag] BIT NULL,
    [MyChart_Message_Type] VARCHAR(100) NULL,
    [MyChart_Destination] VARCHAR(100) NULL,
    [MyChart_Provider_Pool] VARCHAR(200) NULL,
    [Default_Clinical_Pt_Message_Pool] VARCHAR(200) NULL,
    [Telehealth_Visits_Flag] BIT NULL,
    [Telehealth_State] CHAR(2) NULL,
    [Collect_RSM_Flag] BIT NULL,
    [Allow_Scheduling_Outside_Department_Flag] BIT NULL,
    CONSTRAINT [PK_Provider_Access_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Access_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Operational_Profile -------------------- */
CREATE TABLE dbo.[Provider_Operational_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [RPT_Group_Six_PB_Provider_Flag] BIT NULL,
    [RPT_Group_Nine_Referring_Grouper] VARCHAR(100) NULL,
    [RPT_Group_Twelve_Market_Area] VARCHAR(100) NULL,
    [Patient_Age_From] INT NULL,
    [Patient_Age_To] INT NULL,
    CONSTRAINT [PK_Provider_Operational_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Operational_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Quality_Compliance -------------------- */
CREATE TABLE dbo.[Provider_Quality_Compliance] (
    [Provider_ID] BIGINT NOT NULL,
    [Quality_Measure] VARCHAR(200) NULL,
    [Quality_Reporting_Option] VARCHAR(100) NULL,
    [Quality_Report_Year] INT NULL,
    [Quality_Override_System_Measures_Flag] BIT NULL,
    [MU_Eligible_Professional_Flag] BIT NULL,
    [MU_Submission_Year] INT NULL,
    [MU_Stage] VARCHAR(50) NULL,
    [MU_Year_In_Stage] INT NULL,
    [MU_Submission_Date] DATE NULL,
    [MU_Program] VARCHAR(100) NULL,
    [MU_Objective] VARCHAR(200) NULL,
    [MU_Attestation_Year] INT NULL,
    [MU_Status] VARCHAR(50) NULL,
    [MU_Effective_Date] DATE NULL,
    [MU_Attestation_End_Date] DATE NULL,
    [MU_Exclude_System_Settings_Flag] BIT NULL,
    [Enrollment_Status_With_Payers] VARCHAR(200) NULL,
    [Recredentialing_Due_Date] DATE NULL,
    [Continuing_Education_Status] VARCHAR(100) NULL,
    [Sanctions_Disciplinary_Actions] VARCHAR(500) NULL,
    [HIPAA_Training_Completion] VARCHAR(100) NULL,
    [Background_Check_Status] VARCHAR(100) NULL,
    CONSTRAINT [PK_Provider_Quality_Compliance] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Quality_Compliance_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Employment -------------------- */
CREATE TABLE dbo.[Employment] (
    [Employment_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Provider_ID] BIGINT NOT NULL,
    [EE_Number] VARCHAR(50) NULL,
    [Employee_Name] VARCHAR(200) NULL,
    [Employment_Status] VARCHAR(50) NULL,
    [Position_Title] VARCHAR(100) NULL,
    [Job_Code] VARCHAR(50) NULL,
    [Job_Code_Title] VARCHAR(100) NULL,
    [Department_Name] VARCHAR(200) NULL,
    [Work_Email_Address] VARCHAR(200) NULL,
    [Employment_Type] VARCHAR(50) NULL,
    [FTE] DECIMAL(5,2) NULL,
    [Home_Address] VARCHAR(200) NULL,
    [Tax_Identification_Number] VARCHAR(15) NULL,
    [Tax_ID_Eff_From] DATE NULL,
    [Tax_ID_Eff_To] DATE NULL,
    [LexisNexis_ID] VARCHAR(50) NULL,
    CONSTRAINT [PK_Employment] PRIMARY KEY ([Employment_ID]),
    CONSTRAINT [FK_Employment_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Web_Profile -------------------- */
CREATE TABLE dbo.[Provider_Web_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Photo_URL] VARCHAR(500) NULL,
    [Website_URL] VARCHAR(500) NULL,
    [Profile_URL] VARCHAR(500) NULL,
    [Appointment_URL] VARCHAR(500) NULL,
    [Virtual_Care_URL] VARCHAR(500) NULL,
    [Biography] VARCHAR(4000) NULL,
    [Certifications] VARCHAR(1000) NULL,
    [Honors_Awards] VARCHAR(1000) NULL,
    [Affiliations_Text] VARCHAR(1000) NULL,
    [Publication_Links] VARCHAR(1000) NULL,
    [Video_Links] VARCHAR(1000) NULL,
    [Facebook_URL] VARCHAR(500) NULL,
    [Twitter_URL] VARCHAR(500) NULL,
    [LinkedIn_URL] VARCHAR(500) NULL,
    [YouTube_URL] VARCHAR(500) NULL,
    [Doximity_URL] VARCHAR(500) NULL,
    CONSTRAINT [PK_Provider_Web_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Web_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO


/* -------------------- Provider_Credentialing_Profile -------------------- */
CREATE TABLE dbo.[Provider_Credentialing_Profile] (
    [Provider_ID] BIGINT NOT NULL,
    [Doctor_Credentials] VARCHAR(500) NULL,
    [Reading_Specialty] VARCHAR(150) NULL,
    [IP_Default_Relationship] VARCHAR(100) NULL,
    [IP_Provider_Licensure] VARCHAR(100) NULL,
    [IP_Provider_Discipline] VARCHAR(100) NULL,
    [Hospitalist_Flag] BIT NULL,
    [Inpatient_Ordering_Provider_Flag] BIT NULL,
    [Outpatient_Ordering_Provider_Flag] BIT NULL,
    [Default_ED_Provider_Flag] BIT NULL,
    [ED_Can_Supervise_Flag] BIT NULL,
    [ED_Needs_Supervision_Flag] BIT NULL,
    [Modality_Type] VARCHAR(100) NULL,
    [Imaging_Study_IB_Preference] VARCHAR(100) NULL,
    [Education_Training_History] VARCHAR(2000) NULL,
    [Malpractice_Insurance_Details] VARCHAR(1000) NULL,
    CONSTRAINT [PK_Provider_Credentialing_Profile] PRIMARY KEY ([Provider_ID]),
    CONSTRAINT [FK_Provider_Credentialing_Profile_Provider_ID_Provider] FOREIGN KEY ([Provider_ID]) REFERENCES dbo.[Provider]([Provider_ID])
);
GO

/* -------------------- Recommended Indexes -------------------- */
CREATE UNIQUE INDEX [UX_Provider_Source_Provider_ID]
    ON dbo.[Provider]([Source_Provider_ID]);
GO

CREATE INDEX [IX_Address_Provider_ID] ON dbo.[Address]([Provider_ID]);
CREATE INDEX [IX_Contact_Provider_ID] ON dbo.[Contact]([Provider_ID]);
CREATE INDEX [IX_License_Provider_ID] ON dbo.[License]([Provider_ID]);
CREATE INDEX [IX_Employment_Provider_ID] ON dbo.[Employment]([Provider_ID]);
GO
