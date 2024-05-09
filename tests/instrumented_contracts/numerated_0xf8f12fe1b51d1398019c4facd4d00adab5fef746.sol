1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/access/Ownable.sol
27 
28 pragma solidity ^0.6.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor () internal {
51         address msgSender = _msgSender();
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(newOwner != address(0), "Ownable: new owner is the zero address");
89         emit OwnershipTransferred(_owner, newOwner);
90         _owner = newOwner;
91     }
92 }
93 
94 // File: contracts/teleport/ethereum/TeleportAdmin.sol
95 
96 pragma solidity 0.6.12;
97 
98 
99 /**
100  * @dev Contract module which provides a basic access control mechanism, where
101  * there are multiple accounts (admins) that can be granted exclusive access to
102  * specific functions.
103  *
104  * This module is used through inheritance. It will make available the modifier
105  * `consumeAuthorization`, which can be applied to your functions to restrict
106  * their use to the admins.
107  */
108 contract TeleportAdmin is Ownable {
109   // Marks that the contract is frozen or unfrozen (safety kill-switch)
110   bool private _isFrozen;
111 
112   mapping(address => uint256) private _allowedAmount;
113 
114   event AdminUpdated(address indexed account, uint256 allowedAmount);
115 
116   // Modifiers
117 
118   /**
119     * @dev Throw if contract is currently frozen.
120     */
121   modifier notFrozen() {
122     require(
123       !_isFrozen,
124       "TeleportAdmin: contract is frozen by owner"
125     );
126 
127     _;
128   }
129 
130   /**
131     * @dev Throw if caller does not have sufficient authorized amount.
132     */
133   modifier consumeAuthorization(uint256 amount) {
134     address sender = _msgSender();
135     require(
136       allowedAmount(sender) >= amount,
137       "TeleportAdmin: caller does not have sufficient authorization"
138     );
139 
140     _;
141 
142     // reduce authorization amount. Underflow cannot occur because we have
143     // already checked that admin has sufficient allowed amount.
144     _allowedAmount[sender] -= amount;
145     emit AdminUpdated(sender, _allowedAmount[sender]);
146   }
147 
148   /**
149     * @dev Checks the authorized amount of an admin account.
150     */
151   function allowedAmount(address account)
152     public
153     view
154     returns (uint256)
155   {
156     return _allowedAmount[account];
157   }
158 
159   /**
160     * @dev Returns if the contract is currently frozen.
161     */
162   function isFrozen()
163     public
164     view
165     returns (bool)
166   {
167     return _isFrozen;
168   }
169 
170   /**
171     * @dev Owner freezes the contract.
172     */
173   function freeze()
174     public
175     onlyOwner
176   {
177     _isFrozen = true;
178   }
179 
180   /**
181     * @dev Owner unfreezes the contract.
182     */
183   function unfreeze()
184     public
185     onlyOwner
186   {
187     _isFrozen = false;
188   }
189 
190   /**
191     * @dev Updates the admin status of an account.
192     * Can only be called by the current owner.
193     */
194   function updateAdmin(address account, uint256 newAllowedAmount)
195     public
196     virtual
197     onlyOwner
198   {
199     emit AdminUpdated(account, newAllowedAmount);
200     _allowedAmount[account] = newAllowedAmount;
201   }
202 
203   /**
204     * @dev Overrides the inherited method from Ownable.
205     * Disable ownership resounce.
206     */
207   function renounceOwnership()
208     public
209     override
210     onlyOwner
211   {
212     revert("TeleportAdmin: ownership cannot be renounced");
213   }
214 }
215 
216 // File: contracts/teleport/ethereum/TetherToken.sol
217 
218 pragma solidity 0.6.12;
219 
220 /**
221  * @dev Method signature contract for Tether (USDT) because it's not a standard
222  * ERC-20 contract and have different method signatures.
223  */
224 interface TetherToken {
225   function transfer(address _to, uint _value) external;
226   function transferFrom(address _from, address _to, uint _value) external;
227 }
228 
229 // File: contracts/teleport/ethereum/TeleportCustody.sol
230 
231 // SPDX-License-Identifier: MIT
232 
233 pragma solidity 0.6.12;
234 
235 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
236 
237 /**
238  * @dev Implementation of the TeleportCustody contract.
239  *
240  * There are two priviledged roles for the contract: "owner" and "admin".
241  *
242  * Owner: Has the ultimate control of the contract and the funds stored inside the
243  *        contract. Including:
244  *     1) "freeze" and "unfreeze" the contract: when the TeleportCustody is frozen,
245  *        all deposits and withdrawals with the TeleportCustody is disabled. This 
246  *        should only happen when a major security risk is spotted or if admin access
247  *        is comprimised.
248  *     2) assign "admins": owner has the authority to grant "unlock" permission to
249  *        "admins" and set proper "unlock limit" for each "admin".
250  *
251  * Admin: Has the authority to "unlock" specific amount to tokens to receivers.
252  */
253 contract TeleportCustody is TeleportAdmin {
254   // USDC
255   // ERC20 internal _tokenContract = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
256   
257   // USDT
258   TetherToken internal _tokenContract = TetherToken(0xdAC17F958D2ee523a2206206994597C13D831ec7);
259 
260   // Records that an unlock transaction has been executed
261   mapping(bytes32 => bool) internal _unlocked;
262   
263   // Emmitted when user locks token and initiates teleport
264   event Locked(uint256 amount, bytes8 indexed flowAddress, address indexed ethereumAddress);
265 
266   // Emmitted when teleport completes and token gets unlocked
267   event Unlocked(uint256 amount, address indexed ethereumAddress, bytes32 indexed flowHash);
268 
269   /**
270     * @dev User locks token and initiates teleport request.
271     */
272   function lock(uint256 amount, bytes8 flowAddress)
273     public
274     notFrozen
275   {
276     address sender = _msgSender();
277 
278     // NOTE: Return value should be checked. However, Tether does not have return value.
279     _tokenContract.transferFrom(sender, address(this), amount);
280 
281     emit Locked(amount, flowAddress, sender);
282   }
283 
284   // Admin methods
285 
286   /**
287     * @dev TeleportAdmin unlocks token upon receiving teleport request from Flow.
288     */
289   function unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
290     public
291     notFrozen
292     consumeAuthorization(amount)
293   {
294     _unlock(amount, ethereumAddress, flowHash);
295   }
296 
297   // Owner methods
298 
299   /**
300     * @dev Owner unlocks token upon receiving teleport request from Flow.
301     * There is no unlock limit for owner.
302     */
303   function unlockByOwner(uint256 amount, address ethereumAddress, bytes32 flowHash)
304     public
305     notFrozen
306     onlyOwner
307   {
308     _unlock(amount, ethereumAddress, flowHash);
309   }
310 
311   // Internal methods
312 
313   /**
314     * @dev Internal function for processing unlock requests.
315     * 
316     * There is no way TeleportCustody can check the validity of the target address
317     * beforehand so user and admin should always make sure the provided information
318     * is correct.
319     */
320   function _unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
321     internal
322   {
323     require(ethereumAddress != address(0), "TeleportCustody: ethereumAddress is the zero address");
324     require(!_unlocked[flowHash], "TeleportCustody: same unlock hash has been executed");
325 
326     _unlocked[flowHash] = true;
327 
328     // NOTE: Return value should be checked. However, Tether does not have return value.
329     _tokenContract.transfer(ethereumAddress, amount);
330 
331     emit Unlocked(amount, ethereumAddress, flowHash);
332   }
333 }