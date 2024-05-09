1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address from,
193         address to,
194         uint256 amount
195     ) external returns (bool);
196 }
197 
198 // File: ShiwaMigrator.sol
199 
200 /*   
201 
202    _____ __    _                   __  ____                  __            
203 
204   / ___// /_  (_)      ______ _   /  |/  (_)___ __________ _/ /_____  _____
205 
206   \__ \/ __ \/ / | /| / / __ `/  / /|_/ / / __ `/ ___/ __ `/ __/ __ \/ ___/
207 
208  ___/ / / / / /| |/ |/ / /_/ /  / /  / / / /_/ / /  / /_/ / /_/ /_/ / /    
209 
210 /____/_/ /_/_/ |__/|__/\__,_/  /_/  /_/_/\__, /_/   \__,_/\__/\____/_/     
211 
212                                         /____/                               
213 
214     Migrator Contract to migrate Shiwa Version 1 to Shiwa Version 2
215 
216 Supercharged version of SHIWA now with dynamic rewards for all holders
217 
218 
219 
220 -Website: https://shiwa.finance
221 
222 -Telegram: https://t.me/shiwaportal
223 
224 -Telegram announcements: https://t.me/shiwaAnnouncements
225 
226 -Twitter: https://twitter.com/shiwa_finance
227 
228 -Facebook: https://www.facebook.com/OFFICIALSHIWA/
229 
230 -Github: https://github.com/Shiwa-Finance
231 
232 -OpenSea: https://opensea.io/ShiwaOfficial
233 
234 
235 
236 SHIWA is a true decentralized utility meme token. Our mission is to empower the community via the Dao Governance,
237 
238 We are a constantly evolving decentralised ecosystem that puts its destiny in the hands of its holders. 
239 
240 SHIWA is a token that combines the power of a Wolf meme with real utility in the blockchain, including NFT Collections,
241 
242 Web3 Marketplace & DAO Governance utility. Our goal is a honourable one, we want to improve transparency, honour,
243 
244 trust & success in the cryptocurrency industry thus making SHIWA a safe haven for all our investors!
245 
246 
247 
248 Shiwa Version II go live at 19/01/22 12:00 UTC
249 
250 Visit our website to migrate from Shiwa version 1 to Shiwa version 2.
251 
252 
253 
254 The King of the both Ethereums is back, renewed and more KING than ever!
255 
256 Shiwa V2 is the first contract on the entire blockchain to deliver dynamic rewards to all holders that
257 
258 will be voted in our DAO. The token of the moment will be in your wallet just for holding Shiwa!
259 
260 
261 
262 */                             
263 
264                                         
265 
266 //SPDX-License-Identifier: MIT
267 
268 pragma solidity ^0.8.9;
269 
270 
271 
272 
273 
274 contract ShiwaMigrator is Ownable {
275 
276     IERC20 public ShiwaTokenV1;
277 
278     IERC20 public ShiwaTokenV2;
279 
280     address public targetDest;
281 
282 
283 
284     constructor(
285 
286         address _tokenV1, 
287 
288         address _tokenV2, 
289 
290         address _target
291 
292     ) {
293 
294         ShiwaTokenV1 = IERC20(_tokenV1);
295 
296         ShiwaTokenV2 = IERC20(_tokenV2);
297 
298         targetDest = _target;
299 
300     }
301 
302 
303 
304     function migrateV2(uint256 _amount) public returns (bool) {
305 
306         ShiwaTokenV1.transferFrom(_msgSender(), targetDest, _amount);
307 
308         uint256 _decAmount = precisionConverter(_amount);
309 
310         ShiwaTokenV2.transfer(_msgSender(), _decAmount);
311 
312         return true;
313 
314     }
315 
316 
317 
318     function migrateV2Nav(uint256 _amount, address _to) public returns (bool) {
319 
320         ShiwaTokenV1.transferFrom(_msgSender(), targetDest, _amount);
321 
322         uint256 _decAmount = precisionConverter(_amount);
323 
324         ShiwaTokenV2.transfer(_to, _decAmount);
325 
326         return true;
327 
328     }
329 
330 
331 
332     function migrateV2EmergencyWithdraw() public onlyOwner returns (bool) {
333 
334         ShiwaTokenV2.transfer(_msgSender(), ShiwaTokenV2.balanceOf(_msgSender()));
335 
336         return true;
337 
338     }
339 
340 
341 
342     function precisionConverter(uint256 _amount) public pure returns (uint256) {
343 
344         return _amount * 10 ** (18-9);
345 
346     }
347 
348 
349 
350     function recoverERC20(address _token, uint256 _amount) public onlyOwner returns (bool) {
351 
352         IERC20(_token).transfer(_msgSender(), _amount);
353 
354         return true;
355 
356     }
357 
358 }