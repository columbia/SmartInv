1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Contract module that helps prevent reentrant calls to a function.
104  *
105  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
106  * available, which can be applied to functions to make sure there are no nested
107  * (reentrant) calls to them.
108  *
109  * Note that because there is a single `nonReentrant` guard, functions marked as
110  * `nonReentrant` may not call one another. This can be worked around by making
111  * those functions `private`, and then adding `external` `nonReentrant` entry
112  * points to them.
113  *
114  * TIP: If you would like to learn more about reentrancy and alternative ways
115  * to protect against it, check out our blog post
116  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
117  */
118 abstract contract ReentrancyGuard {
119     // Booleans are more expensive than uint256 or any type that takes up a full
120     // word because each write operation emits an extra SLOAD to first read the
121     // slot's contents, replace the bits taken up by the boolean, and then write
122     // back. This is the compiler's defense against contract upgrades and
123     // pointer aliasing, and it cannot be disabled.
124 
125     // The values being non-zero value makes deployment a bit more expensive,
126     // but in exchange the refund on every call to nonReentrant will be lower in
127     // amount. Since refunds are capped to a percentage of the total
128     // transaction's gas, it is best to keep them low in cases like this one, to
129     // increase the likelihood of the full refund coming into effect.
130     uint256 private constant _NOT_ENTERED = 1;
131     uint256 private constant _ENTERED = 2;
132 
133     uint256 private _status;
134 
135     constructor() {
136         _status = _NOT_ENTERED;
137     }
138 
139     /**
140      * @dev Prevents a contract from calling itself, directly or indirectly.
141      * Calling a `nonReentrant` function from another `nonReentrant`
142      * function is not supported. It is possible to prevent this from happening
143      * by making the `nonReentrant` function external, and making it call a
144      * `private` function that does the actual work.
145      */
146     modifier nonReentrant() {
147         // On the first call to nonReentrant, _notEntered will be true
148         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
149 
150         // Any calls to nonReentrant after this point will fail
151         _status = _ENTERED;
152 
153         _;
154 
155         // By storing the original value once again, a refund is triggered (see
156         // https://eips.ethereum.org/EIPS/eip-2200)
157         _status = _NOT_ENTERED;
158     }
159 }
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Returns the address of the current owner.
187      */
188     function owner() public view virtual returns (address) {
189         return _owner;
190     }
191 
192     /**
193      * @dev Throws if called by any account other than the owner.
194      */
195     modifier onlyOwner() {
196         require(owner() == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Internal function without access restriction.
212      */
213     function _transferOwnership(address newOwner) internal virtual {
214         address oldOwner = _owner;
215         _owner = newOwner;
216         emit OwnershipTransferred(oldOwner, newOwner);
217     }
218 }
219 
220 contract DriptoMigration is ReentrancyGuard, Ownable {
221 
222     IERC20 driptoToken;
223 
224     mapping (address => uint256) public totalTokensOwned;
225     mapping (address => uint256) public totalTokensClaimed;
226 
227     bool public claimEnabled = false;
228     uint256 public totalDrypToBeClaimed = 0;
229 
230     event TokenClaim(address user, uint256 tokens);
231 
232     constructor () {
233         claimEnabled = false;
234     }
235 
236     receive() external payable {}
237 
238     function setToken(IERC20 token) public onlyOwner {
239         driptoToken = token;
240     }
241 
242     function withdrawFunds() external onlyOwner {
243         payable((msg.sender)).transfer(address(this).balance);
244     }
245 
246     function withdrawUnclaimedTokens() external onlyOwner {
247         driptoToken.transfer(msg.sender, driptoToken.balanceOf(address(this)));
248     }
249 
250     function enableDisableClaim(bool enabled) external onlyOwner {
251         claimEnabled = enabled;
252     }
253 
254     function getDriptoTokensLeft() external view returns (uint256) {
255         return driptoToken.balanceOf(address(this));
256     }
257 
258     function getWalletInfo(address holderAddress) public view returns (uint256, uint256, uint256) {
259         return (totalTokensOwned[holderAddress], 
260                 totalTokensClaimed[holderAddress],
261                 totalTokensOwned[holderAddress] - totalTokensClaimed[holderAddress]);
262     }
263 
264     function claimTokens() external nonReentrant {
265         require (claimEnabled == true, "Claiming tokens not yet enabled.");
266         require (totalTokensOwned[msg.sender] > 0, "User should own some Dripto tokens");
267         require (totalTokensClaimed[msg.sender] < totalTokensOwned[msg.sender], "All tokens claimed already");
268 
269         uint256 tokensReadyToClaim = totalTokensOwned[msg.sender] - totalTokensClaimed[msg.sender];
270 
271         require (tokensReadyToClaim > 0, "User should have some Dripto tokens ready to claim");
272         require (driptoToken.balanceOf(address(this)) >= tokensReadyToClaim, "There are not enough Dripto tokens to transfer");
273 
274         totalTokensClaimed[msg.sender] = totalTokensClaimed[msg.sender] + tokensReadyToClaim;
275         totalDrypToBeClaimed = totalDrypToBeClaimed - tokensReadyToClaim;
276 
277         driptoToken.transfer(msg.sender, tokensReadyToClaim);
278         emit TokenClaim(msg.sender, tokensReadyToClaim);
279     }
280 
281     function addTokenHolders(address[] calldata holderAddresses, uint256[] calldata tokenAmounts) external onlyOwner {
282 
283 		require(holderAddresses.length == tokenAmounts.length);
284 		require(holderAddresses.length <= 255);
285         
286 		for (uint8 i = 0; i < holderAddresses.length; i++) {
287             address buyer = holderAddresses[i];
288             uint256 tokens = tokenAmounts[i] * 1e18;
289 
290             totalTokensOwned[buyer] = tokens;
291             totalDrypToBeClaimed = totalDrypToBeClaimed + tokens;
292 		}
293 	}
294 
295 }