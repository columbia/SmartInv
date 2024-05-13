1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 /*
8     Simple OTC Escrow contract to transfer tokens OTC
9     Inspired and forked from BadgerDAO 
10     https://github.com/Badger-Finance/badger-system/blob/develop/contracts/badger-timelock/OtcEscrow.sol
11 */
12 contract OtcEscrow {
13     using SafeERC20 for IERC20;
14 
15     address public receivedToken;
16     address public sentToken;
17     address public recipient;
18 
19     address public beneficiary;
20     uint256 public receivedAmount;
21     uint256 public sentAmount;
22 
23     constructor(
24         address beneficiary_,
25         address recipient_,
26         address receivedToken_,
27         address sentToken_,
28         uint256 receivedAmount_,
29         uint256 sentAmount_
30     ) {
31         beneficiary = beneficiary_;
32         recipient = recipient_;
33 
34         receivedToken = receivedToken_;
35         sentToken = sentToken_;
36 
37         receivedAmount = receivedAmount_;
38         sentAmount = sentAmount_;
39     }
40 
41     modifier onlyApprovedParties() {
42         require(msg.sender == recipient || msg.sender == beneficiary);
43         _;
44     }
45 
46     /// @dev Atomically trade specified amount of receivedToken for control over sentToken in vesting contract
47     /// @dev Either counterparty may execute swap if sufficient token approval is given by recipient
48     function swap() public onlyApprovedParties {
49         // Transfer expected receivedToken from beneficiary
50         IERC20(receivedToken).safeTransferFrom(beneficiary, recipient, receivedAmount);
51 
52         // Transfer sentToken to beneficiary
53         IERC20(sentToken).safeTransfer(address(beneficiary), sentAmount);
54     }
55 
56     /// @dev Return sentToken to Fei Protocol to revoke escrow deal
57     function revoke() external {
58         require(msg.sender == recipient, "onlyRecipient");
59         uint256 sentTokenBalance = IERC20(sentToken).balanceOf(address(this));
60         IERC20(sentToken).safeTransfer(recipient, sentTokenBalance);
61     }
62 
63     function revokeReceivedToken() external onlyApprovedParties {
64         uint256 receivedTokenBalance = IERC20(receivedToken).balanceOf(address(this));
65         IERC20(receivedToken).safeTransfer(beneficiary, receivedTokenBalance);
66     }
67 }
