1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
7 
8 import "../interfaces/IAdminRole.sol";
9 import "../interfaces/IOperatorRole.sol";
10 
11 error FoundationTreasuryNode_Address_Is_Not_A_Contract();
12 error FoundationTreasuryNode_Caller_Not_Admin();
13 error FoundationTreasuryNode_Caller_Not_Operator();
14 
15 /**
16  * @title A mixin that stores a reference to the Foundation treasury contract.
17  * @notice The treasury collects fees and defines admin/operator roles.
18  */
19 abstract contract FoundationTreasuryNode is Initializable {
20   using AddressUpgradeable for address payable;
21 
22   /// @dev This value was replaced with an immutable version.
23   address payable private __gap_was_treasury;
24 
25   /// @notice The address of the treasury contract.
26   address payable private immutable treasury;
27 
28   /// @notice Requires the caller is a Foundation admin.
29   modifier onlyFoundationAdmin() {
30     if (!IAdminRole(treasury).isAdmin(msg.sender)) {
31       revert FoundationTreasuryNode_Caller_Not_Admin();
32     }
33     _;
34   }
35 
36   /// @notice Requires the caller is a Foundation operator.
37   modifier onlyFoundationOperator() {
38     if (!IOperatorRole(treasury).isOperator(msg.sender)) {
39       revert FoundationTreasuryNode_Caller_Not_Operator();
40     }
41     _;
42   }
43 
44   /**
45    * @notice Set immutable variables for the implementation contract.
46    * @dev Assigns the treasury contract address.
47    */
48   constructor(address payable _treasury) {
49     if (!_treasury.isContract()) {
50       revert FoundationTreasuryNode_Address_Is_Not_A_Contract();
51     }
52     treasury = _treasury;
53   }
54 
55   /**
56    * @notice Gets the Foundation treasury contract.
57    * @return treasuryAddress The address of the Foundation treasury contract.
58    * @dev This call is used in the royalty registry contract.
59    */
60   function getFoundationTreasury() public view returns (address payable treasuryAddress) {
61     return treasury;
62   }
63 
64   /**
65    * @notice This empty reserved space is put in place to allow future versions to add new
66    * variables without shifting down storage in the inheritance chain.
67    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
68    */
69   uint256[2000] private __gap;
70 }
