1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 import "./CCapableErc20Delegate.sol";
5 import "../EIP20Interface.sol";
6 
7 // Ref: https://etherscan.io/address/0xc2edad668740f1aa35e4d8f227fb8e17dca888cd#code
8 interface IMasterChef {
9     struct PoolInfo {
10         address lpToken;
11     }
12 
13     struct UserInfo {
14         uint256 amount;
15     }
16 
17     function deposit(uint256, uint256) external;
18 
19     function withdraw(uint256, uint256) external;
20 
21     function sushi() external view returns (address);
22 
23     function poolInfo(uint256) external view returns (PoolInfo memory);
24 
25     function userInfo(uint256, address) external view returns (UserInfo memory);
26 
27     function pendingSushi(uint256, address) external view returns (uint256);
28 }
29 
30 // Ref: https://etherscan.io/address/0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272#code
31 interface ISushiBar {
32     function enter(uint256 _amount) external;
33 
34     function leave(uint256 _share) external;
35 }
36 
37 /**
38  * @title Cream's CSushiLP's Contract
39  * @notice CToken which wraps Sushi's LP token
40  * @author Cream
41  */
42 contract CSLPDelegate is CCapableErc20Delegate {
43     /**
44      * @notice MasterChef address
45      */
46     address public masterChef;
47 
48     /**
49      * @notice SushiBar address
50      */
51     address public sushiBar;
52 
53     /**
54      * @notice Sushi token address
55      */
56     address public sushi;
57 
58     /**
59      * @notice Pool ID of this LP in MasterChef
60      */
61     uint256 public pid;
62 
63     /**
64      * @notice Container for sushi rewards state
65      * @member balance The balance of xSushi
66      * @member index The last updated index
67      */
68     struct SushiRewardState {
69         uint256 balance;
70         uint256 index;
71     }
72 
73     /**
74      * @notice The state of SLP supply
75      */
76     SushiRewardState public slpSupplyState;
77 
78     /**
79      * @notice The index of every SLP supplier
80      */
81     mapping(address => uint256) public slpSupplierIndex;
82 
83     /**
84      * @notice The xSushi amount of every user
85      */
86     mapping(address => uint256) public xSushiUserAccrued;
87 
88     /**
89      * @notice Delegate interface to become the implementation
90      * @param data The encoded arguments for becoming
91      */
92     function _becomeImplementation(bytes memory data) public {
93         super._becomeImplementation(data);
94 
95         (address masterChefAddress_, address sushiBarAddress_, uint256 pid_) = abi.decode(
96             data,
97             (address, address, uint256)
98         );
99         masterChef = masterChefAddress_;
100         sushiBar = sushiBarAddress_;
101         sushi = IMasterChef(masterChef).sushi();
102 
103         IMasterChef.PoolInfo memory poolInfo = IMasterChef(masterChef).poolInfo(pid_);
104         require(poolInfo.lpToken == underlying, "mismatch underlying token");
105         pid = pid_;
106 
107         // Approve moving our SLP into the master chef contract.
108         EIP20Interface(underlying).approve(masterChefAddress_, uint256(-1));
109 
110         // Approve moving sushi rewards into the sushi bar contract.
111         EIP20Interface(sushi).approve(sushiBarAddress_, uint256(-1));
112     }
113 
114     /**
115      * @notice Manually claim sushi rewards by user
116      * @return The amount of sushi rewards user claims
117      */
118     function claimSushi(address account) public returns (uint256) {
119         claimAndStakeSushi();
120 
121         updateSLPSupplyIndex();
122         updateSupplierIndex(account);
123 
124         // Get user's xSushi accrued.
125         uint256 xSushiBalance = xSushiUserAccrued[account];
126         if (xSushiBalance > 0) {
127             // Withdraw user xSushi balance and subtract the amount in slpSupplyState
128             ISushiBar(sushiBar).leave(xSushiBalance);
129             slpSupplyState.balance = sub_(slpSupplyState.balance, xSushiBalance);
130 
131             uint256 balance = sushiBalance();
132             EIP20Interface(sushi).transfer(account, balance);
133 
134             // Clear user's xSushi accrued.
135             xSushiUserAccrued[account] = 0;
136 
137             return balance;
138         }
139         return 0;
140     }
141 
142     /*** CToken Overrides ***/
143 
144     /**
145      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
146      * @param spender The address of the account performing the transfer
147      * @param src The address of the source account
148      * @param dst The address of the destination account
149      * @param tokens The number of tokens to transfer
150      * @return Whether or not the transfer succeeded
151      */
152     function transferTokens(
153         address spender,
154         address src,
155         address dst,
156         uint256 tokens
157     ) internal returns (uint256) {
158         claimAndStakeSushi();
159 
160         updateSLPSupplyIndex();
161         updateSupplierIndex(src);
162         updateSupplierIndex(dst);
163 
164         return super.transferTokens(spender, src, dst, tokens);
165     }
166 
167     /*** Safe Token ***/
168 
169     /**
170      * @notice Gets balance of this contract in terms of the underlying
171      * @return The quantity of underlying tokens owned by this contract
172      */
173     function getCashPrior() internal view returns (uint256) {
174         IMasterChef.UserInfo memory userInfo = IMasterChef(masterChef).userInfo(pid, address(this));
175         return userInfo.amount;
176     }
177 
178     /**
179      * @notice Transfer the underlying to this contract and sweep into master chef
180      * @param from Address to transfer funds from
181      * @param amount Amount of underlying to transfer
182      * @param isNative The amount is in native or not
183      * @return The actual amount that is transferred
184      */
185     function doTransferIn(
186         address from,
187         uint256 amount,
188         bool isNative
189     ) internal returns (uint256) {
190         isNative; // unused
191 
192         // Perform the EIP-20 transfer in
193         EIP20Interface token = EIP20Interface(underlying);
194         require(token.transferFrom(from, address(this), amount), "unexpected EIP-20 transfer in return");
195 
196         // Deposit to masterChef.
197         IMasterChef(masterChef).deposit(pid, amount);
198 
199         if (sushiBalance() > 0) {
200             // Send sushi rewards to SushiBar.
201             ISushiBar(sushiBar).enter(sushiBalance());
202         }
203 
204         updateSLPSupplyIndex();
205         updateSupplierIndex(from);
206 
207         return amount;
208     }
209 
210     /**
211      * @notice Transfer the underlying from this contract, after sweeping out of master chef
212      * @param to Address to transfer funds to
213      * @param amount Amount of underlying to transfer
214      * @param isNative The amount is in native or not
215      */
216     function doTransferOut(
217         address payable to,
218         uint256 amount,
219         bool isNative
220     ) internal {
221         isNative; // unused
222 
223         // Withdraw the underlying tokens from masterChef.
224         IMasterChef(masterChef).withdraw(pid, amount);
225 
226         if (sushiBalance() > 0) {
227             // Send sushi rewards to SushiBar.
228             ISushiBar(sushiBar).enter(sushiBalance());
229         }
230 
231         updateSLPSupplyIndex();
232         updateSupplierIndex(to);
233 
234         EIP20Interface token = EIP20Interface(underlying);
235         require(token.transfer(to, amount), "unexpected EIP-20 transfer out return");
236     }
237 
238     /*** Internal functions ***/
239 
240     function claimAndStakeSushi() internal {
241         // Deposit 0 SLP into MasterChef to claim sushi rewards.
242         IMasterChef(masterChef).deposit(pid, 0);
243 
244         if (sushiBalance() > 0) {
245             // Send sushi rewards to SushiBar.
246             ISushiBar(sushiBar).enter(sushiBalance());
247         }
248     }
249 
250     function updateSLPSupplyIndex() internal {
251         uint256 xSushiBalance = xSushiBalance();
252         uint256 xSushiAccrued = sub_(xSushiBalance, slpSupplyState.balance);
253         uint256 supplyTokens = CToken(address(this)).totalSupply();
254         Double memory ratio = supplyTokens > 0 ? fraction(xSushiAccrued, supplyTokens) : Double({mantissa: 0});
255         Double memory index = add_(Double({mantissa: slpSupplyState.index}), ratio);
256 
257         // Update slpSupplyState.
258         slpSupplyState.index = index.mantissa;
259         slpSupplyState.balance = xSushiBalance;
260     }
261 
262     function updateSupplierIndex(address supplier) internal {
263         Double memory supplyIndex = Double({mantissa: slpSupplyState.index});
264         Double memory supplierIndex = Double({mantissa: slpSupplierIndex[supplier]});
265         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
266         if (deltaIndex.mantissa > 0) {
267             uint256 supplierTokens = CToken(address(this)).balanceOf(supplier);
268             uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
269             xSushiUserAccrued[supplier] = add_(xSushiUserAccrued[supplier], supplierDelta);
270             slpSupplierIndex[supplier] = supplyIndex.mantissa;
271         }
272     }
273 
274     function sushiBalance() internal view returns (uint256) {
275         return EIP20Interface(sushi).balanceOf(address(this));
276     }
277 
278     function xSushiBalance() internal view returns (uint256) {
279         return EIP20Interface(sushiBar).balanceOf(address(this));
280     }
281 }
