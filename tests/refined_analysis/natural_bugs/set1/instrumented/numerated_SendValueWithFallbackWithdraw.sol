1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
6 import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
7 
8 error SendValueWithFallbackWithdraw_No_Funds_Available();
9 
10 /**
11  * @title A mixin for sending ETH with a fallback withdraw mechanism.
12  * @notice Attempt to send ETH and if the transfer fails or runs out of gas, store the balance
13  * for future withdrawal instead.
14  */
15 abstract contract SendValueWithFallbackWithdraw is ReentrancyGuardUpgradeable {
16   using AddressUpgradeable for address payable;
17 
18   /// @dev Tracks the amount of ETH that is stored in escrow for future withdrawal.
19   mapping(address => uint256) private pendingWithdrawals;
20 
21   /**
22    * @notice Emitted when an attempt to send ETH fails or runs out of gas and the value is stored in escrow instead.
23    * @param user The account which has escrowed ETH to withdraw.
24    * @param amount The amount of ETH which has been added to the user's escrow balance.
25    */
26   event WithdrawPending(address indexed user, uint256 amount);
27   /**
28    * @notice Emitted when escrowed funds are withdrawn.
29    * @param user The account which has withdrawn ETH.
30    * @param amount The amount of ETH which has been withdrawn.
31    */
32   event Withdrawal(address indexed user, uint256 amount);
33 
34   /**
35    * @notice Allows a user to manually withdraw funds which originally failed to transfer to themselves.
36    */
37   function withdraw() external {
38     withdrawFor(payable(msg.sender));
39   }
40 
41   /**
42    * @notice Allows anyone to manually trigger a withdrawal of funds which originally failed to transfer for a user.
43    * @param user The account which has escrowed ETH to withdraw.
44    */
45   function withdrawFor(address payable user) public nonReentrant {
46     uint256 amount = pendingWithdrawals[user];
47     if (amount == 0) {
48       revert SendValueWithFallbackWithdraw_No_Funds_Available();
49     }
50     pendingWithdrawals[user] = 0;
51     user.sendValue(amount);
52     emit Withdrawal(user, amount);
53   }
54 
55   /**
56    * @dev Attempt to send a user or contract ETH and if it fails store the amount owned for later withdrawal.
57    */
58   function _sendValueWithFallbackWithdraw(
59     address payable user,
60     uint256 amount,
61     uint256 gasLimit
62   ) internal {
63     if (amount == 0) {
64       return;
65     }
66     // Cap the gas to prevent consuming all available gas to block a tx from completing successfully
67     // solhint-disable-next-line avoid-low-level-calls
68     (bool success, ) = user.call{ value: amount, gas: gasLimit }("");
69     if (!success) {
70       // Record failed sends for a withdrawal later
71       // Transfers could fail if sent to a multisig with non-trivial receiver logic
72       unchecked {
73         pendingWithdrawals[user] += amount;
74       }
75       emit WithdrawPending(user, amount);
76     }
77   }
78 
79   /**
80    * @notice Returns how much funds are available for manual withdraw due to failed transfers.
81    * @param user The account to check the escrowed balance of.
82    * @return balance The amount of funds which are available for withdrawal for the given user.
83    */
84   function getPendingWithdrawal(address user) external view returns (uint256 balance) {
85     return pendingWithdrawals[user];
86   }
87 
88   /**
89    * @notice This empty reserved space is put in place to allow future versions to add new
90    * variables without shifting down storage in the inheritance chain.
91    * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
92    */
93   uint256[499] private __gap;
94 }
