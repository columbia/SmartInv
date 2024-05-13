1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "../OZ/AccessControlUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
7 
8 /**
9  * @title Defines a role for Foundation operator accounts.
10  * @dev Wraps a role from OpenZeppelin's AccessControl for easy integration.
11  */
12 abstract contract OperatorRole is Initializable, AccessControlUpgradeable {
13   bytes32 private constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
14 
15   /**
16    * @notice Adds the account to the list of approved operators.
17    * @dev Only callable by admins as enforced by `grantRole`.
18    * @param account The address to be approved.
19    */
20   function grantOperator(address account) external {
21     grantRole(OPERATOR_ROLE, account);
22   }
23 
24   /**
25    * @notice Removes the account from the list of approved operators.
26    * @dev Only callable by admins as enforced by `grantRole`.
27    * @param account The address to be removed from the approved list.
28    */
29   function revokeOperator(address account) external {
30     revokeRole(OPERATOR_ROLE, account);
31   }
32 
33   /**
34    * @notice Returns one of the operator by index.
35    * @param index The index of the operator to return from 0 to getOperatorMemberCount() - 1.
36    * @return account The address of the operator.
37    */
38   function getOperatorMember(uint256 index) external view returns (address account) {
39     return getRoleMember(OPERATOR_ROLE, index);
40   }
41 
42   /**
43    * @notice Checks how many accounts have been granted operator access.
44    * @return count The number of accounts with operator access.
45    */
46   function getOperatorMemberCount() external view returns (uint256 count) {
47     return getRoleMemberCount(OPERATOR_ROLE);
48   }
49 
50   /**
51    * @notice Checks if the account provided is an operator.
52    * @param account The address to check.
53    * @return approved True if the account is an operator.
54    */
55   function isOperator(address account) external view returns (bool approved) {
56     return hasRole(OPERATOR_ROLE, account);
57   }
58 }
