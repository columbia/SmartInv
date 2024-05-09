1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
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
15     function _msgSender() internal view virtual returns(address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns(bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns(address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 
96 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
97 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
98 
99 /* pragma solidity ^0.8.0; */
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns(uint256);
109 
110     /**
111     * @dev Returns the amount of tokens owned by `account`.
112     */
113     function balanceOf(address account) external view returns(uint256);
114 
115     /**
116     * @dev Moves `amount` tokens from the caller's account to `recipient`.
117     *
118     * Returns a boolean value indicating whether the operation succeeded.
119     *
120     * Emits a {Transfer} event.
121     */
122     function transfer(address recipient, uint256 amount) external returns(bool);
123 
124     /**
125     * @dev Returns the remaining number of tokens that `spender` will be
126     * allowed to spend on behalf of `owner` through {transferFrom}. This is
127     * zero by default.
128     *
129     * This value changes when {approve} or {transferFrom} are called.
130     */
131     function allowance(address owner, address spender) external view returns(uint256);
132 
133     /**
134     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135     *
136     * Returns a boolean value indicating whether the operation succeeded.
137     *
138     * IMPORTANT: Beware that changing an allowance with this method brings the risk
139     * that someone may use both the old and the new allowance by unfortunate
140     * transaction ordering. One possible solution to mitigate this race
141     * condition is to first reduce the spender's allowance to 0 and set the
142     * desired value afterwards:
143     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144     *
145     * Emits an {Approval} event.
146     */
147     function approve(address spender, uint256 amount) external returns(bool);
148 
149     /**
150     * @dev Moves `amount` tokens from `sender` to `recipient` using the
151     * allowance mechanism. `amount` is then deducted from the caller's
152     * allowance.
153     *
154     * Returns a boolean value indicating whether the operation succeeded.
155     *
156     * Emits a {Transfer} event.
157     */
158     function transferFrom(
159         address sender,
160         address recipient,
161         uint256 amount
162     ) external returns(bool);
163 
164     /**
165      * @dev Emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * Note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 abstract contract ReentrancyGuard {
180     // Booleans are more expensive than uint256 or any type that takes up a full
181     // word because each write operation emits an extra SLOAD to first read the
182     // slot's contents, replace the bits taken up by the boolean, and then write
183     // back. This is the compiler's defense against contract upgrades and
184     // pointer aliasing, and it cannot be disabled.
185 
186     // The values being non-zero value makes deployment a bit more expensive,
187     // but in exchange the refund on every call to nonReentrant will be lower in
188     // amount. Since refunds are capped to a percentage of the total
189     // transaction's gas, it is best to keep them low in cases like this one, to
190     // increase the likelihood of the full refund coming into effect.
191     uint256 private constant _NOT_ENTERED = 1;
192     uint256 private constant _ENTERED = 2;
193 
194     uint256 private _status;
195 
196     /**
197      * @dev Unauthorized reentrant call.
198      */
199     error ReentrancyGuardReentrantCall();
200 
201     constructor() {
202         _status = _NOT_ENTERED;
203     }
204 
205     /**
206      * @dev Prevents a contract from calling itself, directly or indirectly.
207      * Calling a `nonReentrant` function from another `nonReentrant`
208      * function is not supported. It is possible to prevent this from happening
209      * by making the `nonReentrant` function external, and making it call a
210      * `private` function that does the actual work.
211      */
212     modifier nonReentrant() {
213         _nonReentrantBefore();
214         _;
215         _nonReentrantAfter();
216     }
217 
218     function _nonReentrantBefore() private {
219         // On the first call to nonReentrant, _status will be _NOT_ENTERED
220         if (_status == _ENTERED) {
221             revert ReentrancyGuardReentrantCall();
222         }
223 
224         // Any calls to nonReentrant after this point will fail
225         _status = _ENTERED;
226     }
227 
228     function _nonReentrantAfter() private {
229         // By storing the original value once again, a refund is triggered (see
230         // https://eips.ethereum.org/EIPS/eip-2200)
231         _status = _NOT_ENTERED;
232     }
233 
234     /**
235      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
236      * `nonReentrant` function in the call stack.
237      */
238     function _reentrancyGuardEntered() internal view returns (bool) {
239         return _status == _ENTERED;
240     }
241 }
242 
243 contract DuplicateMigrationClaim is Ownable, ReentrancyGuard {
244     IERC20 tokenV1;
245     IERC20 tokenV2;
246 
247     uint phaseNumber = 0;
248 
249     constructor() {
250         tokenV1 = IERC20(address(0x4eCfC56672C7630B84dAc9C1f7407579715DE155)); // Duplicate V1
251         tokenV2 = IERC20(address(0x13BAdD2Eb51cdDC8F109dcC227a00DA07911030e)); // Duplicate V2
252     }
253 
254     receive() external payable {}
255 
256     // @dev Phase 1 - holders deposit DuplicateV1 to claim DuplicateV2
257     function phaseOneClaim(uint duplicateV1Amt) external nonReentrant {
258         require(phaseNumber != 0, "Claiming has not begun.");
259         require(phaseNumber == 1, "Initial claim phase has ended.");
260 
261         uint userBalance = tokenV1.balanceOf(msg.sender);
262         require(
263             userBalance >= duplicateV1Amt,
264             "User insufficient DuplicateV1 balance"
265         );
266 
267         uint contractDuplicateV2Balance = tokenV2.balanceOf(address(this));
268         require(
269             contractDuplicateV2Balance >= duplicateV1Amt,
270             "Insufficient DuplicateV2 balance in contract."
271         );
272 
273         tokenV1.transferFrom(msg.sender, address(this), duplicateV1Amt);
274         tokenV2.transfer(msg.sender, duplicateV1Amt);
275     }
276 
277     // @dev Set to non-'1' value to end initial claiming phase
278     function setTokenAddresses(
279         address tknV1,
280         address tknV2
281     ) external onlyOwner {
282         tokenV1 = IERC20(tknV1);
283         tokenV2 = IERC20(tknV2);
284     }
285 
286     // @dev Set to non-'1' value to end initial claiming phase
287     function setPhaseNumber(uint _phaseNumber) external onlyOwner {
288         phaseNumber = _phaseNumber;
289     }
290 
291     function withdrawToken(address _token, address _to) external onlyOwner {
292         require(_token != address(0), "_token address cannot be 0");
293         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
294         IERC20(_token).transfer(_to, _contractBalance);
295     }
296 
297     function withdrawStuckEth(address toAddr) external onlyOwner {
298         (bool success, ) = toAddr.call{value: address(this).balance}("");
299         require(success);
300     }
301 }