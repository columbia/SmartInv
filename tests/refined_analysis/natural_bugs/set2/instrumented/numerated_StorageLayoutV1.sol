1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity =0.7.6;
3 pragma abicoder v2;
4 
5 import "./Types.sol";
6 
7 /**
8  * @notice Storage layout for the system. Do not change this file once deployed, future storage
9  * layouts must inherit this and increment the version number.
10  */
11 contract StorageLayoutV1 {
12     // The current maximum currency id
13     uint16 internal maxCurrencyId;
14     // Sets the state of liquidations being enabled during a paused state. Each of the four lower
15     // bits can be turned on to represent one of the liquidation types being enabled.
16     bytes1 internal liquidationEnabledState;
17     // Set to true once the system has been initialized
18     bool internal hasInitialized;
19 
20     /* Authentication Mappings */
21     // This is set to the timelock contract to execute governance functions
22     address public owner;
23     // This is set to an address of a router that can only call governance actions
24     address public pauseRouter;
25     // This is set to an address of a router that can only call governance actions
26     address public pauseGuardian;
27     // On upgrades this is set in the case that the pause router is used to pass the rollback check
28     address internal rollbackRouterImplementation;
29 
30     // A blanket allowance for a spender to transfer any of an account's nTokens. This would allow a user
31     // to set an allowance on all nTokens for a particular integrating contract system.
32     // owner => spender => transferAllowance
33     mapping(address => mapping(address => uint256)) internal nTokenWhitelist;
34     // Individual transfer allowances for nTokens used for ERC20
35     // owner => spender => currencyId => transferAllowance
36     mapping(address => mapping(address => mapping(uint16 => uint256))) internal nTokenAllowance;
37 
38     // Transfer operators
39     // Mapping from a global ERC1155 transfer operator contract to an approval value for it
40     mapping(address => bool) internal globalTransferOperator;
41     // Mapping from an account => operator => approval status for that operator. This is a specific
42     // approval between two addresses for ERC1155 transfers.
43     mapping(address => mapping(address => bool)) internal accountAuthorizedTransferOperator;
44     // Approval for a specific contract to use the `batchBalanceAndTradeActionWithCallback` method in
45     // BatchAction.sol, can only be set by governance
46     mapping(address => bool) internal authorizedCallbackContract;
47 
48     // Reverse mapping from token addresses to currency ids, only used for referencing in views
49     // and checking for duplicate token listings.
50     mapping(address => uint16) internal tokenAddressToCurrencyId;
51 
52     // Reentrancy guard
53     uint256 internal reentrancyStatus;
54 }
