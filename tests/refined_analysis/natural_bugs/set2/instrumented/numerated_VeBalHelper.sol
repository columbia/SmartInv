1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {BalancerGaugeStakerV2} from "./BalancerGaugeStakerV2.sol";
5 import {VeBalDelegatorPCVDeposit} from "./VeBalDelegatorPCVDeposit.sol";
6 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
7 import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 import {TransparentUpgradeableProxy, ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
9 
10 /// @title Helper contract for veBAL OTC
11 /// @author eswak
12 contract VeBalHelper is Ownable {
13     using SafeERC20 for IERC20;
14 
15     VeBalDelegatorPCVDeposit public immutable pcvDeposit;
16     BalancerGaugeStakerV2 public immutable balancerStaker;
17 
18     constructor(
19         address _owner,
20         address _pcvDeposit,
21         address _boostManager
22     ) Ownable() {
23         _transferOwnership(_owner);
24         pcvDeposit = VeBalDelegatorPCVDeposit(_pcvDeposit);
25         balancerStaker = BalancerGaugeStakerV2(_boostManager);
26     }
27 
28     // ----------------------------------------------------------------------------------
29     // Delegation Management
30     // ----------------------------------------------------------------------------------
31 
32     /// @notice sets the snapshot id
33     function setSpaceId(bytes32 snapshotId) external onlyOwner {
34         pcvDeposit.setSpaceId(snapshotId);
35     }
36 
37     /// @notice sets the snapshot delegate
38     function setDelegate(address newDelegate) external onlyOwner {
39         pcvDeposit.setDelegate(newDelegate);
40     }
41 
42     /// @notice clear the snapshot delegate in gnosis registry, and set the
43     /// delegate() state variable to address(this).
44     /// @dev this contract also has a delegate() state variable, and we
45     /// cannot setDelegate(0), so we set the delegate state variable to
46     /// address(this), but the gnosis registry properly does not have any
47     /// delegate.
48     function clearDelegate() external onlyOwner {
49         pcvDeposit.setDelegate(address(this));
50         pcvDeposit.clearDelegate();
51     }
52 
53     // ----------------------------------------------------------------------------------
54     // Vote-lock Management
55     // ----------------------------------------------------------------------------------
56 
57     /// @notice Set the amount of time tokens will be vote-escrowed for in lock() calls
58     function setLockDuration(uint256 newLockDuration) external onlyOwner {
59         pcvDeposit.setLockDuration(newLockDuration);
60     }
61 
62     /// @notice Deposit tokens to get veTokens. Set lock duration to lockDuration.
63     function lock() external onlyOwner {
64         pcvDeposit.lock();
65     }
66 
67     /// @notice Exit the veToken lock.
68     function exitLock() external onlyOwner {
69         pcvDeposit.exitLock();
70     }
71 
72     // ----------------------------------------------------------------------------------
73     // Gauge Management
74     // ----------------------------------------------------------------------------------
75 
76     /// @notice Set the gauge controller used for gauge weight voting
77     function setGaugeController(address gaugeController) external onlyOwner {
78         pcvDeposit.setGaugeController(gaugeController);
79     }
80 
81     /// @notice Vote for a gauge's weight
82     function voteForGaugeWeight(
83         address token,
84         address gaugeAddress,
85         uint256 gaugeWeight
86     ) external onlyOwner {
87         pcvDeposit.setTokenToGauge(token, gaugeAddress);
88         pcvDeposit.voteForGaugeWeight(token, gaugeWeight);
89     }
90 
91     /// @notice Stake tokens in a gauge
92     function stakeInGauge(address token, uint256 amount) external onlyOwner {
93         balancerStaker.stakeInGauge(token, amount);
94     }
95 
96     /// @notice Stake all tokens held in a gauge
97     function stakeAllInGauge(address token) external onlyOwner {
98         balancerStaker.stakeAllInGauge(token);
99     }
100 
101     /// @notice Unstake tokens from a gauge
102     function unstakeFromGauge(address token, uint256 amount) external onlyOwner {
103         balancerStaker.unstakeFromGauge(token, amount);
104     }
105 
106     /// @notice Set the balancer minter used to mint BAL
107     function setBalancerMinter(address newMinter) external onlyOwner {
108         balancerStaker.setBalancerMinter(newMinter);
109     }
110 
111     // ----------------------------------------------------------------------------------
112     // Boost Management
113     // ----------------------------------------------------------------------------------
114 
115     /// @notice probably not needed, but if this function is called, the VeBalHelper
116     /// contract will not be admin of the balancerStaker anymore (transfer ownership).
117     /// This will make all the following functions (setVotingEscrowDelegation, create_boost,
118     /// extend_boost, cancel_boost, and burn) revert, but the new owner will be able to
119     /// manage boost directly.
120     function transferBalancerStakerOwnership(address newbalancerStakerOwner) external onlyOwner {
121         balancerStaker.transferOwnership(newbalancerStakerOwner);
122     }
123 
124     /// @notice Set the contract used to manage boost delegation
125     /// @dev the call is gated to the same role as the role to manage veTokens
126     function setVotingEscrowDelegation(address newVotingEscrowDelegation) public onlyOwner {
127         balancerStaker.setVotingEscrowDelegation(newVotingEscrowDelegation);
128     }
129 
130     /// @notice Create a boost and delegate it to another account.
131     function create_boost(
132         address _delegator,
133         address _receiver,
134         int256 _percentage,
135         uint256 _cancel_time,
136         uint256 _expire_time,
137         uint256 _id
138     ) external onlyOwner {
139         balancerStaker.create_boost(_delegator, _receiver, _percentage, _cancel_time, _expire_time, _id);
140     }
141 
142     /// @notice Extend the boost of an existing boost or expired boost
143     function extend_boost(
144         uint256 _token_id,
145         int256 _percentage,
146         uint256 _expire_time,
147         uint256 _cancel_time
148     ) external onlyOwner {
149         balancerStaker.extend_boost(_token_id, _percentage, _expire_time, _cancel_time);
150     }
151 
152     /// @notice Cancel an outstanding boost
153     function cancel_boost(uint256 _token_id) external onlyOwner {
154         balancerStaker.cancel_boost(_token_id);
155     }
156 
157     /// @notice Destroy a token
158     function burn(uint256 _token_id) external onlyOwner {
159         balancerStaker.burn(_token_id);
160     }
161 
162     // ----------------------------------------------------------------------------------
163     // Assets Management
164     // ----------------------------------------------------------------------------------
165 
166     /// @notice Withdraw ERC20 tokens that are on the pcvDeposit
167     /// @dev this will be needed to withdraw B-80BAL-20WETH after exitLock(),
168     /// but also to withdraw BAL and bb-a-usd earned from protocol fees
169     function withdrawERC20(
170         address token,
171         address to,
172         uint256 amount
173     ) external onlyOwner {
174         pcvDeposit.withdrawERC20(token, to, amount);
175     }
176 
177     /// @notice Withdraw ETH from the PCV deposit
178     function withdrawETH(address to, uint256 amount) external onlyOwner {
179         pcvDeposit.withdrawETH(payable(to), amount);
180     }
181 
182     /// @notice Withdraw ERC20 tokens that are on the balancerGaugeStaker
183     function withdrawERC20fromStaker(
184         address token,
185         address to,
186         uint256 amount
187     ) external onlyOwner {
188         balancerStaker.withdrawERC20(token, to, amount);
189     }
190 
191     /// @notice Withdraw ETH from balancer staker
192     function withdrawETHfromStaker(address to, uint256 amount) external onlyOwner {
193         balancerStaker.withdrawETH(payable(to), amount);
194     }
195 }
