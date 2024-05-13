1 // SPDX-License-Identifier: MIXED
2 pragma solidity 0.8.10;
3 
4 import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
5 import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
6 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
7 
8 // Audit on 5-Jan-2021 by Keno and BoringCrypto
9 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
10 // Edited by BoringCrypto
11 
12 contract BoringOwnableData {
13     address public owner;
14     address public pendingOwner;
15 }
16 
17 contract BoringOwnable is BoringOwnableData {
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /// @notice `owner` defaults to msg.sender on construction.
21     constructor() {
22         owner = msg.sender;
23         emit OwnershipTransferred(address(0), msg.sender);
24     }
25 
26     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
27     /// Can only be invoked by the current `owner`.
28     /// @param newOwner Address of the new owner.
29     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
30     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
31     function transferOwnership(
32         address newOwner,
33         bool direct,
34         bool renounce
35     ) public onlyOwner {
36         if (direct) {
37             // Checks
38             require(newOwner != address(0) || renounce, "Ownable: zero address");
39 
40             // Effects
41             emit OwnershipTransferred(owner, newOwner);
42             owner = newOwner;
43             pendingOwner = address(0);
44         } else {
45             // Effects
46             pendingOwner = newOwner;
47         }
48     }
49 
50     /// @notice Needs to be called by `pendingOwner` to claim ownership.
51     function claimOwnership() public {
52         address _pendingOwner = pendingOwner;
53 
54         // Checks
55         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
56 
57         // Effects
58         emit OwnershipTransferred(owner, _pendingOwner);
59         owner = _pendingOwner;
60         pendingOwner = address(0);
61     }
62 
63     /// @notice Only allows the `owner` to execute the function.
64     modifier onlyOwner() {
65         require(msg.sender == owner, "Ownable: caller is not the owner");
66         _;
67     }
68 }
69 
70 interface IERC20 {
71     function transferFrom(
72         address from,
73         address to,
74         uint256 amount
75     ) external returns (bool);
76 
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     function balanceOf(address account) external view returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 }
83 
84 interface IBentoBoxV1 {
85     function balanceOf(IERC20 token, address user) external view returns (uint256 share);
86 
87     function deposit(
88         IERC20 token_,
89         address from,
90         address to,
91         uint256 amount,
92         uint256 share
93     ) external payable returns (uint256 amountOut, uint256 shareOut);
94 
95     function toAmount(
96         IERC20 token,
97         uint256 share,
98         bool roundUp
99     ) external view returns (uint256 amount);
100 
101     function toShare(
102         IERC20 token,
103         uint256 amount,
104         bool roundUp
105     ) external view returns (uint256 share);
106 
107     function transfer(
108         IERC20 token,
109         address from,
110         address to,
111         uint256 share
112     ) external;
113 
114     function withdraw(
115         IERC20 token_,
116         address from,
117         address to,
118         uint256 amount,
119         uint256 share
120     ) external returns (uint256 amountOut, uint256 shareOut);
121 }
122 
123 // License-Identifier: MIT
124 
125 interface Cauldron {
126     function accrue() external;
127 
128     function withdrawFees() external;
129 
130     function accrueInfo()
131         external
132         view
133         returns (
134             uint64,
135             uint128,
136             uint64
137         );
138 
139     function bentoBox() external returns (address);
140 
141     function setFeeTo(address newFeeTo) external;
142 
143     function feeTo() external returns (address);
144 
145     function masterContract() external returns (CauldronV1);
146 }
147 
148 interface CauldronV1 {
149     function accrue() external;
150 
151     function withdrawFees() external;
152 
153     function accrueInfo() external view returns (uint64, uint128);
154 
155     function setFeeTo(address newFeeTo) external;
156 
157     function feeTo() external returns (address);
158 
159     function masterContract() external returns (CauldronV1);
160 }
161 
162 interface AnyswapRouter {
163     function anySwapOut(
164         address token,
165         address to,
166         uint256 amount,
167         uint256 toChainID
168     ) external;
169 }
170 
171 contract MultichainWithdrawer is BoringOwnable {
172     event MimWithdrawn(uint256 amount);
173 
174     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
175 
176     IBentoBoxV1 public immutable bentoBox;
177     IBentoBoxV1 public immutable degenBox;
178     IERC20 public immutable MIM;
179 
180     AnyswapRouter public immutable anyswapRouter;
181 
182     address public immutable mimProvider;
183     address public immutable ethereumRecipient;
184 
185     CauldronV1[] public bentoBoxCauldronsV1;
186     Cauldron[] public bentoBoxCauldronsV2;
187     Cauldron[] public degenBoxCauldrons;
188 
189     constructor(
190         IBentoBoxV1 bentoBox_,
191         IBentoBoxV1 degenBox_,
192         IERC20 mim,
193         AnyswapRouter anyswapRouter_,
194         address mimProvider_,
195         address ethereumRecipient_,
196         Cauldron[] memory bentoBoxCauldronsV2_,
197         CauldronV1[] memory bentoBoxCauldronsV1_,
198         Cauldron[] memory degenBoxCauldrons_
199     ) {
200         bentoBox = bentoBox_;
201         degenBox = degenBox_;
202         MIM = mim;
203         anyswapRouter = anyswapRouter_;
204         mimProvider = mimProvider_;
205         ethereumRecipient = ethereumRecipient_;
206 
207         bentoBoxCauldronsV2 = bentoBoxCauldronsV2_;
208         bentoBoxCauldronsV1 = bentoBoxCauldronsV1_;
209         degenBoxCauldrons = degenBoxCauldrons_;
210 
211         MIM.approve(address(anyswapRouter), type(uint256).max);
212     }
213 
214     function withdraw() public {
215         uint256 length = bentoBoxCauldronsV2.length;
216         for (uint256 i = 0; i < length; i++) {
217             require(bentoBoxCauldronsV2[i].masterContract().feeTo() == address(this), "wrong feeTo");
218 
219             bentoBoxCauldronsV2[i].accrue();
220             (, uint256 feesEarned, ) = bentoBoxCauldronsV2[i].accrueInfo();
221             if (feesEarned > (bentoBox.toAmount(MIM, bentoBox.balanceOf(MIM, address(bentoBoxCauldronsV2[i])), false))) {
222                 MIM.transferFrom(mimProvider, address(bentoBox), feesEarned);
223                 bentoBox.deposit(MIM, address(bentoBox), address(bentoBoxCauldronsV2[i]), feesEarned, 0);
224             }
225 
226             bentoBoxCauldronsV2[i].withdrawFees();
227         }
228 
229         length = bentoBoxCauldronsV1.length;
230         for (uint256 i = 0; i < length; i++) {
231             require(bentoBoxCauldronsV1[i].masterContract().feeTo() == address(this), "wrong feeTo");
232 
233             bentoBoxCauldronsV1[i].accrue();
234             (, uint256 feesEarned) = bentoBoxCauldronsV1[i].accrueInfo();
235             if (feesEarned > (bentoBox.toAmount(MIM, bentoBox.balanceOf(MIM, address(bentoBoxCauldronsV1[i])), false))) {
236                 MIM.transferFrom(mimProvider, address(bentoBox), feesEarned);
237                 bentoBox.deposit(MIM, address(bentoBox), address(bentoBoxCauldronsV1[i]), feesEarned, 0);
238             }
239             bentoBoxCauldronsV1[i].withdrawFees();
240         }
241 
242         length = degenBoxCauldrons.length;
243         for (uint256 i = 0; i < length; i++) {
244             require(degenBoxCauldrons[i].masterContract().feeTo() == address(this), "wrong feeTo");
245 
246             degenBoxCauldrons[i].accrue();
247             (, uint256 feesEarned, ) = degenBoxCauldrons[i].accrueInfo();
248             if (feesEarned > (degenBox.toAmount(MIM, degenBox.balanceOf(MIM, address(degenBoxCauldrons[i])), false))) {
249                 MIM.transferFrom(mimProvider, address(degenBox), feesEarned);
250                 degenBox.deposit(MIM, address(degenBox), address(degenBoxCauldrons[i]), feesEarned, 0);
251             }
252             degenBoxCauldrons[i].withdrawFees();
253         }
254 
255         uint256 mimFromBentoBoxShare = address(bentoBox) != address(0) ? bentoBox.balanceOf(MIM, address(this)) : 0;
256         uint256 mimFromDegenBoxShare = address(degenBox) != address(0) ? degenBox.balanceOf(MIM, address(this)) : 0;
257 
258         withdrawFromBentoBoxes(mimFromBentoBoxShare, mimFromDegenBoxShare);
259 
260         uint256 amountWithdrawn = MIM.balanceOf(address(this));
261         bridgeMimToEthereum(amountWithdrawn);
262 
263         emit MimWithdrawn(amountWithdrawn);
264     }
265 
266     function withdrawFromBentoBoxes(uint256 amountBentoboxShare, uint256 amountDegenBoxShare) public {
267         if (amountBentoboxShare > 0) {
268             bentoBox.withdraw(MIM, address(this), address(this), 0, amountBentoboxShare);
269         }
270         if (amountDegenBoxShare > 0) {
271             degenBox.withdraw(MIM, address(this), address(this), 0, amountDegenBoxShare);
272         }
273     }
274 
275     function bridgeMimToEthereum(uint256 amount) public {
276         // bridge all MIM to Ethereum, chainId 1
277         anyswapRouter.anySwapOut(address(MIM), ethereumRecipient, amount, 1);
278     }
279 
280     function rescueTokens(
281         IERC20 token,
282         address to,
283         uint256 amount
284     ) external onlyOwner {
285         _safeTransfer(token, to, amount);
286     }
287 
288     function addPool(Cauldron pool) external onlyOwner {
289         _addPool(pool);
290     }
291 
292     function addPoolV1(CauldronV1 pool) external onlyOwner {
293         bentoBoxCauldronsV1.push(pool);
294     }
295 
296     function addPools(Cauldron[] memory pools) external onlyOwner {
297         for (uint256 i = 0; i < pools.length; i++) {
298             _addPool(pools[i]);
299         }
300     }
301 
302     function _addPool(Cauldron pool) internal onlyOwner {
303         require(address(pool) != address(0), "invalid cauldron");
304 
305         if (pool.bentoBox() == address(bentoBox)) {
306             //do not allow doubles
307             for (uint256 i = 0; i < bentoBoxCauldronsV2.length; i++) {
308                 require(bentoBoxCauldronsV2[i] != pool, "already added");
309             }
310             bentoBoxCauldronsV2.push(pool);
311         } else if (pool.bentoBox() == address(degenBox)) {
312             for (uint256 i = 0; i < degenBoxCauldrons.length; i++) {
313                 require(degenBoxCauldrons[i] != pool, "already added");
314             }
315             degenBoxCauldrons.push(pool);
316         }
317     }
318 
319     function _safeTransfer(
320         IERC20 token,
321         address to,
322         uint256 amount
323     ) internal {
324         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
325         require(success && (data.length == 0 || abi.decode(data, (bool))), "transfer failed");
326     }
327 }
