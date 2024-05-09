1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.16;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function decimals() external view returns (uint8);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function apPROve(address spender, uint256 amount) external returns (bool);
16 
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event ApPROval(address indexed owner, address indexed spender, uint256 value);
22 }
23 interface StakeV2{
24     function getPending1(address staker) external view returns(uint256 _pendingReward);
25     function getPending2(address staker) external view returns(uint256 _pendingReward);
26     function getPending3(address staker) external view returns(uint256 _pendingReward);
27     function isStakeholder(address _address) external view returns(bool);
28     function userStakedFEG(address user) external view returns(uint256 StakedFEG);
29 }
30 
31 library TransferHelper {
32     function safeApprove(address token, address to, uint value) internal {
33         // bytes4(keccak256(bytes('approve(address,uint256)')));
34         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
35         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
36     }
37 
38     function safeTransfer(address token, address to, uint value) internal {
39         // bytes4(keccak256(bytes('transfer(address,uint256)')));
40         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
41         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
42     }
43 
44     function safeTransferFrom(address token, address from, address to, uint value) internal {
45         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
46         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
47         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
48     }
49 
50     function safeTransferETH(address to, uint value) internal {
51         (bool success,) = to.call{value:value}(new bytes(0));
52         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
53     }
54 }
55 
56 interface StakeV1{
57      function yourStakedFEG(address staker) external view returns(uint256 stakedFEG);
58 }
59 
60 interface ProPair{
61     function userBalanceInternal(address _addr) external view returns(uint256, uint256);
62 }
63 
64 contract ReEntrancyGuard {
65     bool internal locked;
66 
67     modifier noReentrant() {
68         require(!locked, "No re-entrancy");
69         locked = true;
70         _;
71         locked = false;
72     }
73 }
74 contract ReEntrancyGuard2 {
75     mapping(address=>uint256) internal lastBlock;
76 
77     modifier lock(){
78         require(lastBlock[msg.sender] < block.number,"No re-entrancy V2");
79         lastBlock[msg.sender] = block.number;
80         _;
81 
82     }
83 }
84 
85                                                                                                                     
86 contract Migrator is ReEntrancyGuard,ReEntrancyGuard2{
87     address public constant V_2         = 0x4a9D6b95459eb9532B7E4d82Ca214a3b20fa2358;
88     address public constant V_1         = 0x5bCF1f407c0fc922074283B4e11DaaF539f6644D;
89     address public constant FEG         = 0x389999216860AB8E0175387A0c90E5c52522C945;
90     address public constant PRO         = 0xf2bda964ec2D2fcB1610c886eD4831bf58f64948;
91     address public constant NEW_PAIR    = 0xBA993532E7b66029077b794383eB0Cb75CcDD72D; 
92     address public constant dev         = 0x765Cf9485CD66960608a0B8Dd79d39FCBC847904; 
93     address public constant DEAD        = 0x000000000000000000000000000000000000dEaD; 
94 
95     uint256  public constant  RATIO = 1_000;
96 
97     mapping(address=>bool) public v1Claimed;
98     mapping(address=>uint256) public amtClaimed;
99     
100 
101 
102     function balanceEligable(address holder) public view returns(uint256){
103             return IERC20(FEG).balanceOf(holder)*RATIO;
104     }
105 
106 
107 
108 
109     function lPEligable(address holder) public view  returns(uint256){
110         return ((IERC20(PRO).balanceOf(holder)*117/100)/10**9)*RATIO;
111     }
112 
113     function stakingV2Eligable(address holder) public view returns(uint256){
114         return StakeV2(V_2).userStakedFEG(holder) * RATIO;
115     }
116 
117     function stakingV1Eligable(address holder) public view returns(uint256){
118         if (v1Claimed[holder]) return 0;
119         return StakeV1(V_1).yourStakedFEG(holder) * RATIO;
120     }
121 
122     function totalEligable(address holder) external view returns(uint256){
123         return  lPEligable(holder) + balanceEligable(holder) +  stakingV2Eligable(holder) + stakingV1Eligable(holder);
124     }
125 
126     
127 
128     function saveLostTokens(address toSave) external { //added function to save any lost tokens
129         require(FEG != toSave,"Can't extract FEG");
130         require(msg.sender == dev, "You do not have permission");
131         uint256 toSend = IERC20(toSave).balanceOf(address(this));
132         require(IERC20(toSave).transfer(dev,toSend),"Extraction Transfer failed");
133     }
134   
135     function singleStepMigrationBalance() external noReentrant lock{
136         require(msg.sender == tx.origin, "no contract allowed");
137         address user = msg.sender;
138         uint256 toSend =balanceEligable(user);
139         TransferHelper.safeTransferFrom(FEG,user,address(this),IERC20(FEG).balanceOf(user));
140         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
141         amtClaimed[user] += toSend;
142     }
143 
144     function singleStepMigrationLP() external noReentrant lock{
145         require(msg.sender == tx.origin, "no contract allowed");
146         address user = msg.sender;
147         uint256 toSend = ((IERC20(PRO).balanceOf(user)*117/100)/10**9)*RATIO;
148         TransferHelper.safeTransferFrom(PRO,user,address(this),IERC20(PRO).balanceOf(user));
149         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
150         amtClaimed[user] += toSend;
151     }
152 
153     function singleStepMigrationStakingV1() external noReentrant lock{
154         require(msg.sender == tx.origin, "no contract allowed");
155         address user = msg.sender;
156         require(!v1Claimed[user],"You already claimed V_1");
157         uint256 toSend = StakeV1(V_1).yourStakedFEG(user) * RATIO;
158         v1Claimed[user] = true;
159         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
160         amtClaimed[user] += toSend;
161     }
162 
163     function singleStepMigrationStakingV2() external noReentrant lock{
164         require(msg.sender == tx.origin, "no contract allowed");
165         address user = msg.sender;
166         require(StakeV2(V_2).isStakeholder(user),"You are not a stakeholder");
167         require( StakeV2(V_2).getPending1(user) == 0 && StakeV2(V_2).getPending2(user) == 0 && StakeV2(V_2).getPending3(user) == 0, "Please claim your Staking rewards" );
168         uint256 toSend = StakeV2(V_2).userStakedFEG(user) * RATIO;
169         TransferHelper.safeTransferFrom(V_2,user,address(this),IERC20(V_2).balanceOf(user));
170         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
171         amtClaimed[user] += toSend;
172     }
173 
174     function singleStepMigrationStakingV2WithoutRewardsClaim() external noReentrant lock{
175         require(msg.sender == tx.origin, "no contract allowed");
176         address user = msg.sender;
177         uint256 toSend = StakeV2(V_2).userStakedFEG(user) * RATIO;
178         TransferHelper.safeTransferFrom(V_2,user,address(this),IERC20(V_2).balanceOf(user));
179         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
180         amtClaimed[user] += toSend;
181     }
182 
183 
184     function migrate() external noReentrant lock{
185         require(msg.sender == tx.origin, "no contract allowed");
186         address user = msg.sender;
187         uint256 toSend = 0;
188         //balance
189         if(IERC20(FEG).balanceOf(user) > 0){
190             require( IERC20(FEG).allowance(user,address(this)) >= IERC20(FEG).balanceOf(user),"Please apPROve your FEG balance");
191             toSend += balanceEligable(user);
192             TransferHelper.safeTransferFrom(FEG,user,address(this),IERC20(FEG).balanceOf(user));
193         }
194         //Staking V_2
195         if(IERC20(V_2).balanceOf(user) > 0){
196             //V_2 logic
197             toSend += StakeV2(V_2).userStakedFEG(user) * RATIO;
198             TransferHelper.safeTransferFrom(V_2,user,address(this),IERC20(V_2).balanceOf(user));
199         }
200         //Staking V_1
201         if(!v1Claimed[user]){
202             toSend += StakeV1(V_1).yourStakedFEG(user) * RATIO;
203             v1Claimed[user] = true;
204         }
205         //liquidity in PROpair
206         if(IERC20(PRO).balanceOf(user)>0){
207             toSend += ((IERC20(PRO).balanceOf(user)*117/100)/10**9)*RATIO;
208             TransferHelper.safeTransferFrom(PRO,user,address(this),IERC20(PRO).balanceOf(user));
209         }
210         //checks if the person get's anything
211         require(toSend > 0,"Nothing to migrate");
212         require(IERC20(NEW_PAIR).transfer(user,toSend),"New token Transfer failed");
213     }
214 
215 function migrateView(address user) external view returns(uint toSend){
216         //balance
217         if(IERC20(FEG).balanceOf(user) > 0){
218             toSend += balanceEligable(user);
219         }
220         //Staking V_2
221         if(IERC20(V_2).balanceOf(address(this)) > 0){
222             //V_2 logic
223             toSend += StakeV2(V_2).userStakedFEG(user) * RATIO;
224         }
225         //Staking V_1
226         if(!v1Claimed[user]){
227             toSend += StakeV1(V_1).yourStakedFEG(user) * RATIO;
228         }
229         //liquidity in PROpair
230         if(IERC20(PRO).balanceOf(user)>0){
231             toSend += ((IERC20(PRO).balanceOf(user)*117/100)/10**9)*RATIO;
232         }
233 
234         //checks if the person get's anything
235     }
236 
237 
238 }