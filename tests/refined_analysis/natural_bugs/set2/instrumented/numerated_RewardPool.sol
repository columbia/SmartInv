1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
6 import {TransferHelper} from "@uniswap/lib/contracts/libraries/TransferHelper.sol";
7 
8 import {Powered} from "./Powered.sol";
9 
10 interface IRewardPool {
11     function sendERC20(
12         address token,
13         address to,
14         uint256 value
15     ) external;
16 
17     function rescueERC20(address[] calldata tokens, address recipient) external;
18 }
19 
20 /// @title Reward Pool
21 /// @notice Vault for isolated storage of reward tokens
22 contract RewardPool is IRewardPool, Powered, Ownable {
23     /* initializer */
24 
25     constructor(address powerSwitch) {
26         Powered._setPowerSwitch(powerSwitch);
27     }
28 
29     /* user functions */
30 
31     /// @notice Send an ERC20 token
32     /// access control: only owner
33     /// state machine:
34     ///   - can be called multiple times
35     ///   - only online
36     /// state scope: none
37     /// token transfer: transfer tokens from self to recipient
38     /// @param token address The token to send
39     /// @param to address The recipient to send to
40     /// @param value uint256 Amount of tokens to send
41     function sendERC20(
42         address token,
43         address to,
44         uint256 value
45     ) external override onlyOwner onlyOnline {
46         TransferHelper.safeTransfer(token, to, value);
47     }
48 
49     /* emergency functions */
50 
51     /// @notice Rescue multiple ERC20 tokens
52     /// access control: only power controller
53     /// state machine:
54     ///   - can be called multiple times
55     ///   - only shutdown
56     /// state scope: none
57     /// token transfer: transfer tokens from self to recipient
58     /// @param tokens address[] The tokens to rescue
59     /// @param recipient address The recipient to rescue to
60     function rescueERC20(address[] calldata tokens, address recipient)
61         external
62         override
63         onlyShutdown
64     {
65         // only callable by controller
66         require(
67             msg.sender == Powered.getPowerController(),
68             "RewardPool: only controller can withdraw after shutdown"
69         );
70 
71         // assert recipient is defined
72         require(recipient != address(0), "RewardPool: recipient not defined");
73 
74         // transfer tokens
75         for (uint256 index = 0; index < tokens.length; index++) {
76             // get token
77             address token = tokens[index];
78             // get balance
79             uint256 balance = IERC20(token).balanceOf(address(this));
80             // transfer token
81             TransferHelper.safeTransfer(token, recipient, balance);
82         }
83     }
84 }
