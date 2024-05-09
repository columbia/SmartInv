1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity 0.7.6;
80 pragma abicoder v2;
81 
82 
83 interface IHyperLiquidrium {
84 
85     /* user functions */
86 
87     function rebalance(
88         int24 _baseLower,
89         int24 _baseUpper,
90         int24 _limitLower,
91         int24 _limitUpper,
92         address _feeRecipient,
93         int256 swapQuantity
94     ) external;
95 
96     function setMaxTotalSupply(uint256 _maxTotalSupply) external;
97 
98     function setDepositMax(uint256 _deposit0Max, uint256 _deposit1Max) external;
99 
100     function appendList(address[] memory listed) external;
101 
102     function toggleWhitelist() external;
103 
104     function emergencyWithdraw(IERC20 token, uint256 amount) external;
105 
106     function emergencyBurn(
107         int24 tickLower,
108         int24 tickUpper,
109         uint128 liquidity
110     ) external;
111 
112     function transferOwnership(address newOwner) external;
113 }
114 
115 
116 /**
117  * @dev Contract module that helps prevent reentrant calls to a function.
118  *
119  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
120  * available, which can be applied to functions to make sure there are no nested
121  * (reentrant) calls to them.
122  *
123  * Note that because there is a single `nonReentrant` guard, functions marked as
124  * `nonReentrant` may not call one another. This can be worked around by making
125  * those functions `private`, and then adding `external` `nonReentrant` entry
126  * points to them.
127  *
128  * TIP: If you would like to learn more about reentrancy and alternative ways
129  * to protect against it, check out our blog post
130  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
131  */
132 abstract contract ReentrancyGuard {
133     // Booleans are more expensive than uint256 or any type that takes up a full
134     // word because each write operation emits an extra SLOAD to first read the
135     // slot's contents, replace the bits taken up by the boolean, and then write
136     // back. This is the compiler's defense against contract upgrades and
137     // pointer aliasing, and it cannot be disabled.
138 
139     // The values being non-zero value makes deployment a bit more expensive,
140     // but in exchange the refund on every call to nonReentrant will be lower in
141     // amount. Since refunds are capped to a percentage of the total
142     // transaction's gas, it is best to keep them low in cases like this one, to
143     // increase the likelihood of the full refund coming into effect.
144     uint256 private constant _NOT_ENTERED = 1;
145     uint256 private constant _ENTERED = 2;
146 
147     uint256 private _status;
148 
149     constructor() {
150         _status = _NOT_ENTERED;
151     }
152 
153     /**
154      * @dev Prevents a contract from calling itself, directly or indirectly.
155      * Calling a `nonReentrant` function from another `nonReentrant`
156      * function is not supported. It is possible to prevent this from happening
157      * by making the `nonReentrant` function external, and making it call a
158      * `private` function that does the actual work.
159      */
160     modifier nonReentrant() {
161         // On the first call to nonReentrant, _notEntered will be true
162         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
163 
164         // Any calls to nonReentrant after this point will fail
165         _status = _ENTERED;
166 
167         _;
168 
169         // By storing the original value once again, a refund is triggered (see
170         // https://eips.ethereum.org/EIPS/eip-2200)
171         _status = _NOT_ENTERED;
172     }
173 }
174 
175 
176 pragma solidity 0.7.6;
177 
178 contract Admin is ReentrancyGuard{
179     
180     event OwnerTransferPrepared(address hypervisor, address newOwner, address admin, uint256 timestamp);
181     event OwnerTransferFullfilled(address hypervisor, address newOwner, address admin, uint256 timestamp);
182     event AdminTransfer(address newAdmin, uint256 timestamp);
183     event AdvisorTransfer(address newAdmin, uint256 timestamp);
184     event RescueTokens(IERC20 token, address recipient, uint256 value);
185 
186     address public admin;
187     address public advisor;
188     
189     
190     struct OwnershipData {
191         address newOwner;
192         uint256 lastUpdatedTime;
193     }
194 
195     mapping(address => OwnershipData) hypervisorOwner;
196 
197     modifier onlyAdvisor {
198         require(msg.sender == advisor, "only advisor");
199         _;
200     }
201 
202     modifier onlyAdmin {
203         require(msg.sender == admin, "only admin");
204         _;
205     }
206 
207     constructor(address _admin, address _advisor) public {
208         admin = _admin;
209         advisor = _advisor;
210     }
211 
212     function rebalance(
213         address _hypervisor,
214         int24 _baseLower,
215         int24 _baseUpper,
216         int24 _limitLower,
217         int24 _limitUpper,
218         address _feeRecipient,
219         int256 swapQuantity
220     ) external onlyAdvisor {
221         IHyperLiquidrium(_hypervisor).rebalance(_baseLower, _baseUpper, _limitLower, _limitUpper, _feeRecipient, swapQuantity);
222     }
223 
224     function emergencyWithdraw(
225         address _hypervisor,
226         IERC20 token,
227         uint256 amount
228     ) external onlyAdmin {
229         IHyperLiquidrium(_hypervisor).emergencyWithdraw(token, amount);
230     }
231 
232     function emergencyBurn(
233         address _hypervisor,
234         int24 tickLower,
235         int24 tickUpper,
236         uint128 liquidity
237     ) external onlyAdmin {
238         IHyperLiquidrium(_hypervisor).emergencyBurn(tickLower, tickUpper, liquidity);
239     }
240 
241     function setDepositMax(address _hypervisor, uint256 _deposit0Max, uint256 _deposit1Max) external onlyAdmin {
242         IHyperLiquidrium(_hypervisor).setDepositMax(_deposit0Max, _deposit1Max);
243     }
244 
245     function setMaxTotalSupply(address _hypervisor, uint256 _maxTotalSupply) external onlyAdmin {
246         IHyperLiquidrium(_hypervisor).setMaxTotalSupply(_maxTotalSupply);
247     }
248 
249     function toggleWhitelist(address _hypervisor) external onlyAdmin {
250         IHyperLiquidrium(_hypervisor).toggleWhitelist();
251     }
252 
253     function appendList(address _hypervisor, address[] memory listed) external onlyAdmin {
254         IHyperLiquidrium(_hypervisor).appendList(listed);
255     }
256 
257     function transferAdmin(address newAdmin) external onlyAdmin {
258         admin = newAdmin;
259         emit AdminTransfer(newAdmin, block.timestamp);
260     }
261 
262     function transferAdvisor(address newAdvisor) external onlyAdmin {
263         advisor = newAdvisor;
264         emit AdvisorTransfer(newAdvisor, block.timestamp);
265     }
266 
267     function prepareHVOwnertransfer(address _hypervisor, address newOwner) external onlyAdmin {
268         require(newOwner != address(0), "newOwner must not be zero");
269         hypervisorOwner[_hypervisor] = OwnershipData(newOwner, block.timestamp + 86400);
270         emit OwnerTransferPrepared(_hypervisor, newOwner, admin, block.timestamp);
271     }
272 
273     function fullfillHVOwnertransfer(address _hypervisor, address newOwner) external onlyAdmin {
274         OwnershipData storage data = hypervisorOwner[_hypervisor];
275         require(data.newOwner == newOwner && data.lastUpdatedTime != 0 && data.lastUpdatedTime < block.timestamp, "owner or update time wrong");
276         IHyperLiquidrium(_hypervisor).transferOwnership(newOwner);
277         delete hypervisorOwner[_hypervisor];
278         emit OwnerTransferFullfilled(_hypervisor, newOwner, admin, block.timestamp);
279     }
280 
281     function rescueERC20(IERC20 token, address recipient) external nonReentrant onlyAdmin {
282         require(token.transfer(recipient, token.balanceOf(address(this))), "transfer failed");
283         emit RescueTokens(token,recipient,token.balanceOf(address(this)));
284     }
285 
286 }