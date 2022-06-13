/*Role Membership*/
SELECT
user_name(member_principal_id) AS RoleMember ,user_name(role_principal_id) AS RoleName
FROM sys.database_role_members
WHERE user_name(member_principal_id) LIKE 'TestLogin%'
ORDER BY RoleMember
/*Schema Owners*/
SELECT
user_name(principal_id) AS SchemaOwner ,name AS SchemaName
FROM sys.schemas
WHERE name = 'dev'
/*Object Permissions*/
SELECT
U.name AS UserName, O.name AS TableName, C.name AS ColumnName
,permission_name AS PermissionName, state_desc AS StatusName, DB_Name() AS DatabaseName
FROM sys.database_permissions DP
LEFT JOIN sys.columns C ON dp.major_id = C.object_id AND DP.minor_id = C.column_id
LEFT JOIN sys.objects O ON dp.major_id = O.object_id
LEFT JOIN sys.sysusers U ON U.uid = DP.grantee_principal_id
WHERE U.name LIKE 'TestLogin%' OR U.name = 'Read and Update'
ORDER BY UserName