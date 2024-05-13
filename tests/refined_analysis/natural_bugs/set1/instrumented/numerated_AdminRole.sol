1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "../OZ/AccessControlUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
7 
8 /**
9  * @title Defines a role for Foundation admin accounts.
10  * @dev Wraps the default admin role from OpenZeppelin's AccessControl for easy integration.
11  */
12 abstract contract AdminRole is Initializable, AccessControlUpgradeable {
13   function _initializeAdminRole(address admin) internal onlyInitializing {
14     AccessControlUpgradeable.__AccessControl_init();
15     // Grant the role to a specified account
16     _setupRole(DEFAULT_ADMIN_ROLE, admin);
17   }
18 
19   modifier onlyAdmin() {
20     require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "AdminRole: caller does not have the Admin role");
21     _;
22   }
23 
24   /**
25    * @notice Adds the account to the list of approved admins.
26    * @dev Only callable by admins as enforced by `grantRole`.
27    * @param account The address to be approved.
28    */
29   function grantAdmin(address account) external {
30     grantRole(DEFAULT_ADMIN_ROLE, account);
31   }
32 
33   /**
34    * @notice Removes the account from the list of approved admins.
35    * @dev Only callable by admins as enforced by `grantRole`.
36    * @param account The address to be removed from the approved list.
37    */
38   function revokeAdmin(address account) external {
39     revokeRole(DEFAULT_ADMIN_ROLE, account);
40   }
41 
42   /**
43    * @notice Returns one of the admins by index.
44    * @param index The index of the admin to return from 0 to getAdminMemberCount() - 1.
45    * @return account The address of the admin.
46    */
47   function getAdminMember(uint256 index) external view returns (address account) {
48     return getRoleMember(DEFAULT_ADMIN_ROLE, index);
49   }
50 
51   /**
52    * @notice Checks how many accounts have been granted admin access.
53    * @return count The number of accounts with admin access.
54    */
55   function getAdminMemberCount() external view returns (uint256 count) {
56     return getRoleMemberCount(DEFAULT_ADMIN_ROLE);
57   }
58 
59   /**
60    * @notice Checks if the account provided is an admin.
61    * @param account The address to check.
62    * @return approved True if the account is an admin.
63    * @dev This call is used by the royalty registry contract.
64    */
65   function isAdmin(address account) external view returns (bool approved) {
66     return hasRole(DEFAULT_ADMIN_ROLE, account);
67   }
68 
69   /**
70    * @notice This empty reserved space is put in place to allow future versions to add new
71    * variables without shifting down storage in the inheritance chain.
72    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
73    */
74   uint256[1000] private __gap;
75 }
