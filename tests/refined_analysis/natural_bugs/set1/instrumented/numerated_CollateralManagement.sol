1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 
7 import "../mixins/roles/AdminRole.sol";
8 
9 /**
10  * @title Enables deposits and withdrawals.
11  */
12 abstract contract CollateralManagement is AdminRole {
13   using AddressUpgradeable for address payable;
14 
15   event FundsWithdrawn(address indexed to, uint256 amount);
16 
17   /**
18    * @notice Accept native currency payments (i.e. fees)
19    */
20   // solhint-disable-next-line no-empty-blocks
21   receive() external payable {}
22 
23   /**
24    * @notice Allows an admin to withdraw funds.
25    * @dev    In normal operation only ETH is required, but this allows access to any
26    *         ERC-20 funds sent to the contract as well.
27    *
28    * @param to        Address to receive the withdrawn funds
29    * @param amount    Amount to withdrawal or 0 to withdraw all available funds
30    */
31   function withdrawFunds(address payable to, uint256 amount) external onlyAdmin {
32     if (amount == 0) {
33       amount = address(this).balance;
34     }
35     to.sendValue(amount);
36 
37     emit FundsWithdrawn(to, amount);
38   }
39 
40   /**
41    * @notice This empty reserved space is put in place to allow future versions to add new
42    * variables without shifting down storage in the inheritance chain.
43    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
44    */
45   uint256[1000] private __gap;
46 }
