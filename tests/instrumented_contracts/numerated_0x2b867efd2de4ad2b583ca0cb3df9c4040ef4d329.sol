1 pragma solidity ^0.8.9;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Emitted when `value` tokens are moved from one account (`from`) to
18      * another (`to`).
19      *
20      * Note that `value` may be zero.
21      */
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /**
25      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
26      * a call to {approve}. `value` is the new allowance.
27      */
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `to`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address to, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address from,
85         address to,
86         uint256 amount
87     ) external returns (bool);
88 }
89 
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 abstract contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     /**
113      * @dev Initializes the contract setting the deployer as the initial owner.
114      */
115     constructor() {
116         _transferOwnership(_msgSender());
117     }
118 
119     /**
120      * @dev Returns the address of the current owner.
121      */
122     function owner() public view virtual returns (address) {
123         return _owner;
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133 
134     /**
135      * @dev Leaves the contract without owner. It will not be possible to call
136      * `onlyOwner` functions anymore. Can only be called by the current owner.
137      *
138      * NOTE: Renouncing ownership will leave the contract without an owner,
139      * thereby removing any functionality that is only available to the owner.
140      */
141     function renounceOwnership() public virtual onlyOwner {
142         _transferOwnership(address(0));
143     }
144 
145     /**
146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
147      * Can only be called by the current owner.
148      */
149     function transferOwnership(address newOwner) public virtual onlyOwner {
150         require(newOwner != address(0), "Ownable: new owner is the zero address");
151         _transferOwnership(newOwner);
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Internal function without access restriction.
157      */
158     function _transferOwnership(address newOwner) internal virtual {
159         address oldOwner = _owner;
160         _owner = newOwner;
161         emit OwnershipTransferred(oldOwner, newOwner);
162     }
163 }
164 
165 contract LuckyBlockToken is Context, IERC20, IERC20Metadata, Ownable {
166     mapping(address => uint256) private _balances;
167     mapping(address => mapping(address => uint256)) private _allowances;
168     uint256 private _totalSupply;
169     string private _name;
170     string private _symbol;
171     address public minter;
172     bool public isMinting;
173     uint256 public constant HARD_CAP = 100000000000000000000; // 100 billion(BSC Total supply)
174 
175     /**
176      * @param name_ Name of the token
177      * @param symbol_ Symbol of the token
178      * @param isMinting_ Minting status of the token
179      */
180     constructor(
181         string memory name_,
182         string memory symbol_,
183         bool isMinting_
184     ) Ownable() {
185         _name = name_;
186         _symbol = symbol_;
187         isMinting = isMinting_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
209      */
210     function decimals() public view virtual override returns (uint8) {
211         return 9;
212     }
213 
214     /**
215      * @dev Returns total supply of the token
216      */
217     function totalSupply() public view virtual override returns (uint256) {
218         return _totalSupply;
219     }
220 
221     modifier onlyMinter() {
222         require(msg.sender == minter, "Not the minter");
223         _;
224     }
225 
226     modifier minting() {
227         require(isMinting, "Minting is disabled");
228         _;
229     }
230 
231     /**
232      * @dev Allows the owner to change the current minter
233      * @param _newMinter new minter of the contract
234      */
235     function changeMinter(address _newMinter) external onlyOwner {
236         require(_newMinter != address(0), "Zero Minting address");
237         minter = _newMinter;
238     }
239 
240     /**
241      * @dev Allows the owner to change the minting status
242      * @param isMinting_ minting status
243      */
244     function changeMintingStatus(bool isMinting_) external onlyOwner {
245         isMinting = isMinting_;
246     }
247 
248     /**
249      * @dev See `IERC20.balanceOf`.
250      * @return balance of the user.
251      */
252     function balanceOf(address account)
253         public
254         view
255         virtual
256         override
257         returns (uint256)
258     {
259         return _balances[account];
260     }
261 
262     /**
263      * @param recipient cannot be the zero address.
264      * - the caller must have a balance of at least amount.
265      */
266     function transfer(address recipient, uint256 amount)
267         public
268         virtual
269         override
270         returns (bool)
271     {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     function allowance(address _owner, address _spender)
277         public
278         view
279         virtual
280         override
281         returns (uint256)
282     {
283         return _allowances[_owner][_spender];
284     }
285 
286     /**
287      *
288      * @param spender cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount)
291         public
292         virtual
293         override
294         returns (bool)
295     {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     /**
301      * - `sender` and `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `value`.
303      * - the caller must have allowance for `sender`'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         _transfer(sender, recipient, amount);
312 
313         uint256 currentAllowance = _allowances[sender][_msgSender()];
314         require(
315             currentAllowance >= amount,
316             "ERC20: transfer amount exceeds allowance"
317         );
318         unchecked {
319             _approve(sender, _msgSender(), currentAllowance - amount);
320         }
321 
322         return true;
323     }
324 
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to `approve` that can be used as a mitigation for
329      * problems described in `IERC20.approve`.
330      *
331      * Emits an `Approval` event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue)
338         public
339         virtual
340         returns (bool)
341     {
342         _approve(
343             _msgSender(),
344             spender,
345             _allowances[_msgSender()][spender] + addedValue
346         );
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to `approve` that can be used as a mitigation for
354      * problems described in `IERC20.approve`.
355      *
356      * Emits an `Approval` event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue)
365         public
366         virtual
367         returns (bool)
368     {
369         uint256 currentAllowance = _allowances[_msgSender()][spender];
370         require(
371             currentAllowance >= subtractedValue,
372             "ERC20: decreased allowance below zero"
373         );
374         unchecked {
375             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
376         }
377 
378         return true;
379     }
380 
381     /**
382      * @dev Moves tokens `amount` from `sender` to `recipient`.
383      *
384      * This is internal function is equivalent to `transfer`, and can be used to
385      * e.g. implement automatic token fees, slashing mechanisms, etc.
386      *
387      * Emits a `Transfer` event.
388      *
389      * Requirements:
390      *
391      * - `sender` cannot be the zero address.
392      * - `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      */
395     function _transfer(
396         address sender,
397         address recipient,
398         uint256 amount
399     ) internal virtual {
400         require(sender != address(0), "ERC20: transfer from the zero address");
401         require(recipient != address(0), "ERC20: transfer to the zero address");
402         uint256 senderBalance = _balances[sender];
403         require(
404             senderBalance >= amount,
405             "ERC20: transfer amount exceeds balance"
406         );
407         unchecked {
408             _balances[sender] -= amount;
409         }
410         _balances[recipient] += amount;
411 
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a `Transfer` event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply += amount;
428         _balances[account] += amount;
429         emit Transfer(address(0), account, amount);
430     }
431 
432     function mint(address user, uint256 amount)
433         external
434         onlyMinter
435         minting
436         returns (bool)
437     {
438         require(_totalSupply + amount <= HARD_CAP, "Hard cap exceeded!");
439         _mint(user, amount);
440         return true;
441     }
442 
443     /**
444      * @dev Destroys `amount` tokens from `account`, reducing the
445      * total supply.
446      *
447      * Emits a `Transfer` event with `to` set to the zero address.
448      *
449      * Requirements
450      *
451      * - `account` cannot be the zero address.
452      * - `account` must have at least `amount` tokens.
453      */
454     function _burn(address account, uint256 amount) internal virtual {
455         require(account != address(0), "ERC20: burn from the zero address");
456 
457         uint256 accountBalance = _balances[account];
458         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
459         unchecked {
460             _balances[account] = accountBalance - amount;
461         }
462         _totalSupply -= amount;
463 
464         emit Transfer(account, address(0), amount);
465     }
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
469      *
470      * This is internal function is equivalent to `approve`, and can be used to
471      * e.g. set automatic allowances for certain subsystems, etc.
472      *
473      * Emits an `Approval` event.
474      *
475      * Requirements:
476      *
477      * - `owner` cannot be the zero address.
478      * - `spender` cannot be the zero address.
479      */
480     function _approve(
481         address _owner,
482         address _spender,
483         uint256 _amount
484     ) internal virtual {
485         require(_owner != address(0), "ERC20: approve from the zero address");
486         require(_spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[_owner][_spender] = _amount;
489         emit Approval(_owner, _spender, _amount);
490     }
491 }