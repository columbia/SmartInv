1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
102 
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 
127 
128 
129 /**
130  * @dev Contract module which provides a basic access control mechanism, where
131  * there is an account (an owner) that can be granted exclusive access to
132  * specific functions.
133  *
134  * By default, the owner account will be the one that deploys the contract. This
135  * can later be changed with {transferOwnership}.
136  *
137  * This module is used through inheritance. It will make available the modifier
138  * `onlyOwner`, which can be applied to your functions to restrict their use to
139  * the owner.
140  */
141 abstract contract Ownable is Context {
142     address private _owner;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     /**
147      * @dev Initializes the contract setting the deployer as the initial owner.
148      */
149     constructor () {
150         address msgSender = _msgSender();
151         _owner = msgSender;
152         emit OwnershipTransferred(address(0), msgSender);
153     }
154 
155     /**
156      * @dev Returns the address of the current owner.
157      */
158     function owner() public view virtual returns (address) {
159         return _owner;
160     }
161 
162     /**
163      * @dev Throws if called by any account other than the owner.
164      */
165     modifier onlyOwner() {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169 
170     /**
171      * @dev Leaves the contract without owner. It will not be possible to call
172      * `onlyOwner` functions anymore. Can only be called by the current owner.
173      *
174      * NOTE: Renouncing ownership will leave the contract without an owner,
175      * thereby removing any functionality that is only available to the owner.
176      */
177     function renounceOwnership() public virtual onlyOwner {
178         emit OwnershipTransferred(_owner, address(0));
179         _owner = address(0);
180     }
181 
182     /**
183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
184      * Can only be called by the current owner.
185      */
186     function transferOwnership(address newOwner) public virtual onlyOwner {
187         require(newOwner != address(0), "Ownable: new owner is the zero address");
188         emit OwnershipTransferred(_owner, newOwner);
189         _owner = newOwner;
190     }
191 }
192 
193 
194 /**
195  * @dev Implementation of the {IERC20} interface.
196  * 
197  */
198 contract ERC20 is Context, IERC20, IERC20Metadata {
199     mapping (address => uint256) private _balances;
200 
201     mapping (address => mapping (address => uint256)) private _allowances;
202 
203     uint256 private _totalSupply;
204 
205     string private _name;
206     string private _symbol;
207 
208     /**
209      * @dev Sets the values for {name} and {symbol}.
210      *
211      * The defaut value of {decimals} is 18. To select a different value for
212      * {decimals} you should overload it.
213      *
214      * All two of these values are immutable: they can only be set once during
215      * construction.
216      */
217     constructor (string memory name_, string memory symbol_) {
218         _name = name_;
219         _symbol = symbol_;
220     }
221 
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() public view virtual override returns (string memory) {
226         return _name;
227     }
228 
229     /**
230      * @dev Returns the symbol of the token, usually a shorter version of the
231      * name.
232      */
233     function symbol() public view virtual override returns (string memory) {
234         return _symbol;
235     }
236 
237     /**
238      * @dev Returns the number of decimals used to get its user representation.
239      * For example, if `decimals` equals `2`, a balance of `505` tokens should
240      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
241      *
242      * Tokens usually opt for a value of 18, imitating the relationship between
243      * Ether and Wei. This is the value {ERC20} uses, unless this function is
244      * overridden;
245      *
246      * NOTE: This information is only used for _display_ purposes: it in
247      * no way affects any of the arithmetic of the contract, including
248      * {IERC20-balanceOf} and {IERC20-transfer}.
249      */
250     function decimals() public view virtual override returns (uint8) {
251         return 18;
252     }
253 
254     /**
255      * @dev See {IERC20-totalSupply}.
256      */
257     function totalSupply() public view virtual override returns (uint256) {
258         return _totalSupply;
259     }
260 
261     /**
262      * @dev See {IERC20-balanceOf}.
263      */
264     function balanceOf(address account) public view virtual override returns (uint256) {
265         return _balances[account];
266     }
267 
268     /**
269      * @dev See {IERC20-transfer}.
270      *
271      * Requirements:
272      *
273      * - `recipient` cannot be the zero address.
274      * - the caller must have a balance of at least `amount`.
275      */
276     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-allowance}.
283      */
284     function allowance(address owner, address spender) public view virtual override returns (uint256) {
285         return _allowances[owner][spender];
286     }
287 
288     /**
289      * @dev See {IERC20-approve}.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function approve(address spender, uint256 amount) public virtual override returns (bool) {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See {IERC20-transferFrom}.
302      *
303      * Emits an {Approval} event indicating the updated allowance. This is not
304      * required by the EIP. See the note at the beginning of {ERC20}.
305      *
306      * Requirements:
307      *
308      * - `sender` and `recipient` cannot be the zero address.
309      * - `sender` must have a balance of at least `amount`.
310      * - the caller must have allowance for ``sender``'s tokens of at least
311      * `amount`.
312      */
313     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
314         _transfer(sender, recipient, amount);
315 
316         uint256 currentAllowance = _allowances[sender][_msgSender()];
317         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
318         _approve(sender, _msgSender(), currentAllowance - amount);
319 
320         return true;
321     }
322 
323     /**
324      * @dev Atomically increases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
336         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
337         return true;
338     }
339 
340     /**
341      * @dev Atomically decreases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to {approve} that can be used as a mitigation for
344      * problems described in {IERC20-approve}.
345      *
346      * Emits an {Approval} event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      * - `spender` must have allowance for the caller of at least
352      * `subtractedValue`.
353      */
354     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
355         uint256 currentAllowance = _allowances[_msgSender()][spender];
356         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
357         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
358 
359         return true;
360     }
361 
362     /**
363      * @dev Moves tokens `amount` from `sender` to `recipient`.
364      *
365      * This is internal function is equivalent to {transfer}, and can be used to
366      * e.g. implement automatic token fees, slashing mechanisms, etc.
367      *
368      * Emits a {Transfer} event.
369      *
370      * Requirements:
371      *
372      * - `sender` cannot be the zero address.
373      * - `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      */
376     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
377         require(sender != address(0), "ERC20: transfer from the zero address");
378         require(recipient != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(sender, recipient, amount);
381 
382         uint256 senderBalance = _balances[sender];
383         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
384         _balances[sender] = senderBalance - amount;
385         _balances[recipient] += amount;
386 
387         emit Transfer(sender, recipient, amount);
388     }
389 
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `to` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401 
402         _beforeTokenTransfer(address(0), account, amount);
403 
404         _totalSupply += amount;
405         _balances[account] += amount;
406         emit Transfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         _balances[account] = accountBalance - amount;
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431     }
432 
433 
434     function _approve(address owner, address spender, uint256 amount) internal virtual {
435         require(owner != address(0), "ERC20: approve from the zero address");
436         require(spender != address(0), "ERC20: approve to the zero address");
437 
438         _allowances[owner][spender] = amount;
439         emit Approval(owner, spender, amount);
440     }
441 
442 
443     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
444 }
445 
446  /**
447 * @dev mightygojiras get balance in wallets
448 */
449 interface Imightygojiras {
450     function balanceGenesis(address owner) external view returns(uint256);
451 }
452 
453 /**
454  * @dev GOJ roken reward
455 */
456      
457 contract GOJTOKEN is ERC20, Ownable {
458 
459     uint256 constant public BASE_RATE = 10 ether;  //10 GOJ a day
460     uint256 public START;
461     bool rewardPaused = false;
462 
463     mapping(address => uint256) public rewards;
464     mapping(address => uint256) public lastUpdate;
465 
466     mapping(address => bool) public allowedAddresses;
467     address public  mightygojirasAddress;
468     address public  cityAddress;
469     
470     constructor() ERC20("GOJ", "GOJ") {
471         START = block.timestamp;
472     }
473 
474     function setStartTimeStamp(uint256 timestamp) public onlyOwner {
475         START = timestamp;
476    }
477 
478    function setmightygojirasContractAddress(address contractAddress) public onlyOwner {
479         mightygojirasAddress = contractAddress;
480    }
481     
482       /**
483      * @dev  burn BOJ to claim CITY
484      */
485   function setCityContractAddress(address contractAddress) public onlyOwner {
486         cityAddress = contractAddress;
487    }
488     
489     function updateReward(address from, address to) external {
490         require(msg.sender == mightygojirasAddress);
491         if(from != address(0)){
492             rewards[from] += getPendingReward(from);
493             lastUpdate[from] = block.timestamp;
494         }
495         if(to != address(0)){
496             rewards[to] += getPendingReward(to);
497             lastUpdate[to] = block.timestamp;
498         }
499     }
500 
501     function claimReward() external {
502         require(!rewardPaused, "Claim paused"); 
503         _mint(msg.sender, rewards[msg.sender] + getPendingReward(msg.sender));
504         rewards[msg.sender] = 0;
505         lastUpdate[msg.sender] = block.timestamp;
506     }
507 
508     
509     function claimTestRewards(address _address, uint256 _amount) external {
510         require(!rewardPaused,                "Claim paused"); 
511         require(allowedAddresses[msg.sender], "Address needs to aprpove burn first");
512         _mint(_address, _amount);
513     }
514 
515     function burn(address user, uint256 amount) external {
516         require(allowedAddresses[msg.sender] || msg.sender == mightygojirasAddress || msg.sender == cityAddress, "Address needs to aprpove burn first");
517         _burn(user, amount);
518     }
519 
520     function getTotalClaimable(address user) external view returns(uint256) {
521         return rewards[user] + getPendingReward(user);
522     }
523 
524     function getPendingReward(address user) internal view returns(uint256) {
525         Imightygojiras mightygojiras = Imightygojiras(mightygojirasAddress);
526         return mightygojiras.balanceGenesis(user) * BASE_RATE * (block.timestamp - (lastUpdate[user] >= START ? lastUpdate[user] : START)) / 86400;
527     }
528 
529     function setAllowedAddresses(address _address, bool _access) public onlyOwner {
530         allowedAddresses[_address] = _access;
531     }
532 
533     function toggleReward() public onlyOwner {
534         rewardPaused = !rewardPaused;
535     }
536 }