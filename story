Story Title:
Add Ambience Attribute to Provider Data Model (Address-Level, Lookup-Based)

Story Type:
Data Modeling / Enhancement

Description:
As part of ongoing data model enhancements, we need to introduce a new attribute “Ambience” to capture characteristics of the provider’s physical location.

Based on data modeling best practices and domain alignment, Ambience will be implemented at the Address (location) level rather than the Provider entity. To ensure consistency and scalability, the attribute will be normalized using a lookup table.

This change supports improved data standardization, governance, and future extensibility of provider location attributes.

Business Value:

Enables capture of facility/environment characteristics
Improves data consistency through controlled values
Supports analytics and reporting on provider location experience
Aligns with data governance and normalization standards

Acceptance Criteria:

Ambience attribute exists in Address table as Ambience_Type_ID
Ambience attribute exists in Address_History for tracking changes
Lookup table Ambience_Type is created and populated (initial values TBD)
Foreign key relationship is established
CDM_Row_Mapping updated with Ambience definition
Model documentation updated

Dependencies:

Business confirmation of Ambience values (lookup list)
Source system identification for Ambience data

+++++++++++++++++++++++++++++++///++++++++++++++++++++++++++++++++++++++++

Summary:
Enhance the Provider data model by introducing a new “Ambience” attribute to capture characteristics of the provider’s physical location.

Details:
Based on business request, the Ambience attribute has been added to the data model at the Address (location) level, as it represents environmental characteristics of the facility rather than the provider entity itself.

To ensure consistency and scalability, the attribute is implemented using a normalized lookup structure.

Changes Implemented:

Created new lookup table: Ambience_Type
Columns: Ambience_Type_ID, Ambience_Name, Is_Active
Added foreign key column Ambience_Type_ID to:
Address
Address_History
Updated CDM_Row_Mapping to include Ambience mapping
Updated model documentation and summary tabs

Design Considerations:

Ambience is modeled at the location level (Address) instead of Provider
Lookup table ensures controlled and standardized values
History tracking supported via Address_History

Dependencies / Open Items:

Confirm source system for Ambience values
Confirm standardized list of Ambience types (e.g., Calm, Busy, Premium, etc.)

Acceptance Criteria:

Ambience attribute is available in Address and Address_History tables
Lookup table is created and referenced via foreign key
CDM mapping reflects the new attribute
Model aligns with governance and normalization standards

