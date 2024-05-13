1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../libraries/EnumerableMapping.sol";
5 import "../../interfaces/IVaultReserve.sol";
6 import "../../interfaces/IStrategy.sol";
7 
8 contract VaultStorage {
9     uint256 public currentAllocated;
10     uint256 public waitingForRemovalAllocated;
11     address public pool;
12 
13     uint256 public totalDebt;
14     bool public strategyActive;
15 
16     EnumerableMapping.AddressToUintMap internal _strategiesWaitingForRemoval;
17 }
18 
19 contract VaultStorageV1 is VaultStorage {
20     /**
21      * @dev This is to avoid breaking contracts inheriting from `VaultStorage`
22      * such as `Erc20Vault`, especially if they have storage variables
23      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
24      * for more details
25      *
26      * A new field can be added using a new contract such as
27      *
28      * ```solidity
29      * contract VaultStorageV2 is VaultStorage {
30      *   uint256 someNewField;
31      *   uint256[49] private __gap;
32      * }
33      */
34     uint256[50] private __gap;
35 }
