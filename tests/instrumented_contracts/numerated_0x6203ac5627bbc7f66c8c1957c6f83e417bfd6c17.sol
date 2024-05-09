1 //SPDX-License-Identifier: UNLICENSED
2 
3 /**
4 ---------------------------------------------------------------------------------------------------
5  Telegram: https://t.me/MoneyTokenERCPortal
6  Twitter: https://twitter.com/moneyerc
7  
8  Contract Developed by Anoop [Developed over 350+ contracts]: https://t.me/AnoopSafuDeveloper
9  [DM for any Smart Contract/DApp development]
10 ---------------------------------------------------------------------------------------------------
11 */
12 
13 pragma solidity ^0.8.17;
14 
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
26 interface IBEP20 {
27     function totalSupply() external view returns (uint256);
28 
29     function balanceOf(address account) external view returns (uint256);
30 
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 interface IBEP20Metadata is IBEP20 {
49     /**
50      * @dev Returns the name of the token.
51      */
52     function name() external view returns (string memory);
53 
54     /**
55      * @dev Returns the symbol of the token.
56      */
57     function symbol() external view returns (string memory);
58 
59     /**
60      * @dev Returns the decimals places of the token.
61      */
62     function decimals() external view returns (uint8);
63 }
64 
65 contract BEP20 is Context, IBEP20, IBEP20Metadata {
66     mapping(address => uint256) internal _balances;
67 
68     mapping(address => mapping(address => uint256)) internal _allowances;
69 
70     uint256 private _totalSupply;
71 
72     string private _name;
73     string private _symbol;
74 
75     /**
76      * @dev Sets the values for {name} and {symbol}.
77      *
78      * The defaut value of {decimals} is 18. To select a different value for
79      * {decimals} you should overload it.
80      *
81      * All two of these values are immutable: they can only be set once during
82      * construction.
83      */
84     constructor(string memory name_, string memory symbol_) {
85         _name = name_;
86         _symbol = symbol_;
87     }
88 
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() public view virtual override returns (string memory) {
93         return _name;
94     }
95 
96     /**
97      * @dev Returns the symbol of the token, usually a shorter version of the
98      * name.
99      */
100     function symbol() public view virtual override returns (string memory) {
101         return _symbol;
102     }
103 
104     /**
105      * @dev Returns the number of decimals used to get its user representation.
106      * For example, if `decimals` equals `2`, a balance of `505` tokens should
107      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
108      *
109      * Tokens usually opt for a value of 18, imitating the relationship between
110      * Ether and Wei. This is the value {BEP20} uses, unless this function is
111      * overridden;
112      *
113      * NOTE: This information is only used for _display_ purposes: it in
114      * no way affects any of the arithmetic of the contract, including
115      * {IBEP20-balanceOf} and {IBEP20-transfer}.
116      */
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121     /**
122      * @dev See {IBEP20-totalSupply}.
123      */
124     function totalSupply() public view virtual override returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129      * @dev See {IBEP20-balanceOf}.
130      */
131     function balanceOf(address account) public view virtual override returns (uint256) {
132         return _balances[account];
133     }
134 
135     /**
136      * @dev See {IBEP20-transfer}.
137      *
138      * Requirements:
139      *
140      * - `recipient` cannot be the zero address.
141      * - the caller must have a balance of at least `amount`.
142      */
143     function transfer(address recipient, uint256 amount)
144         public
145         virtual
146         override
147         returns (bool)
148     {
149         _transfer(_msgSender(), recipient, amount);
150         return true;
151     }
152 
153     /**
154      * @dev See {IBEP20-allowance}.
155      */
156     function allowance(address owner, address spender)
157         public
158         view
159         virtual
160         override
161         returns (uint256)
162     {
163         return _allowances[owner][spender];
164     }
165 
166     /**
167      * @dev See {IBEP20-approve}.
168      *
169      * Requirements:
170      *
171      * - `spender` cannot be the zero address.
172      */
173     function approve(address spender, uint256 amount) public virtual override returns (bool) {
174         _approve(_msgSender(), spender, amount);
175         return true;
176     }
177 
178     /**
179      * @dev See {IBEP20-transferFrom}.
180      *
181      * Emits an {Approval} event indicating the updated allowance. This is not
182      * required by the EIP. See the note at the beginning of {BEP20}.
183      *
184      * Requirements:
185      *
186      * - `sender` and `recipient` cannot be the zero address.
187      * - `sender` must have a balance of at least `amount`.
188      * - the caller must have allowance for ``sender``'s tokens of at least
189      * `amount`.
190      */
191     function transferFrom(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) public virtual override returns (bool) {
196         _transfer(sender, recipient, amount);
197 
198         uint256 currentAllowance = _allowances[sender][_msgSender()];
199         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
200         _approve(sender, _msgSender(), currentAllowance - amount);
201 
202         return true;
203     }
204 
205     /**
206      * @dev Atomically increases the allowance granted to `spender` by the caller.
207      *
208      * This is an alternative to {approve} that can be used as a mitigation for
209      * problems described in {IBEP20-approve}.
210      *
211      * Emits an {Approval} event indicating the updated allowance.
212      *
213      * Requirements:
214      *
215      * - `spender` cannot be the zero address.
216      */
217     function increaseAllowance(address spender, uint256 addedValue)
218         public
219         virtual
220         returns (bool)
221     {
222         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
223         return true;
224     }
225 
226     /**
227      * @dev Atomically decreases the allowance granted to `spender` by the caller.
228      *
229      * This is an alternative to {approve} that can be used as a mitigation for
230      * problems described in {IBEP20-approve}.
231      *
232      * Emits an {Approval} event indicating the updated allowance.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      * - `spender` must have allowance for the caller of at least
238      * `subtractedValue`.
239      */
240     function decreaseAllowance(address spender, uint256 subtractedValue)
241         public
242         virtual
243         returns (bool)
244     {
245         uint256 currentAllowance = _allowances[_msgSender()][spender];
246         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
247         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
248 
249         return true;
250     }
251 
252     /**
253      * @dev Moves tokens `amount` from `sender` to `recipient`.
254      *
255      * This is internal function is equivalent to {transfer}, and can be used to
256      * e.g. implement automatic token fees, slashing mechanisms, etc.
257      *
258      * Emits a {Transfer} event.
259      *
260      * Requirements:
261      *
262      * - `sender` cannot be the zero address.
263      * - `recipient` cannot be the zero address.
264      * - `sender` must have a balance of at least `amount`.
265      */
266     function _transfer(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) internal virtual {
271         require(sender != address(0), "BEP20: transfer from the zero address");
272         require(recipient != address(0), "BEP20: transfer to the zero address");
273 
274         uint256 senderBalance = _balances[sender];
275         require(senderBalance >= amount, "BEP20: transfer amount exceeds balance");
276         _balances[sender] = senderBalance - amount;
277         _balances[recipient] += amount;
278 
279         emit Transfer(sender, recipient, amount);
280     }
281 
282     /** This function will be used to generate the total supply
283     * while deploying the contract
284     *
285     * This function can never be called again after deploying contract
286     */
287     function _tokengeneration(address account, uint256 amount) internal virtual {
288         _totalSupply = amount;
289         _balances[account] = amount;
290         emit Transfer(address(0), account, amount);
291     }
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
295      *
296      * This internal function is equivalent to `approve`, and can be used to
297      * e.g. set automatic allowances for certain subsystems, etc.
298      *
299      * Emits an {Approval} event.
300      *
301      * Requirements:
302      *
303      * - `owner` cannot be the zero address.
304      * - `spender` cannot be the zero address.
305      */
306     function _approve(
307         address owner,
308         address spender,
309         uint256 amount
310     ) internal virtual {
311         require(owner != address(0), "BEP20: approve from the zero address");
312         require(spender != address(0), "BEP20: approve to the zero address");
313 
314         _allowances[owner][spender] = amount;
315         emit Approval(owner, spender, amount);
316     }
317 }
318 
319 library Address {
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 }
327 
328 abstract contract Ownable is Context {
329     address private _owner;
330 
331     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
332 
333     constructor() {
334         _setOwner(_msgSender());
335     }
336 
337     function owner() public view virtual returns (address) {
338         return _owner;
339     }
340 
341     modifier onlyOwner() {
342         require(owner() == _msgSender(), "Ownable: caller is not the owner");
343         _;
344     }
345 
346     function renounceOwnership() public virtual onlyOwner {
347         _setOwner(address(0));
348     }
349 
350     function transferOwnership(address newOwner) public virtual onlyOwner {
351         require(newOwner != address(0), "Ownable: new owner is the zero address");
352         _setOwner(newOwner);
353     }
354 
355     function _setOwner(address newOwner) private {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 interface IFactory {
363     function createPair(address tokenA, address tokenB) external returns (address pair);
364 }
365 
366 interface IRouter {
367     function factory() external pure returns (address);
368     function WETH() external pure returns (address);
369 }
370 
371 contract MONEY is BEP20, Ownable {
372     using Address for address payable;
373 
374     IRouter public router;
375     address public pair;
376 
377     bool public tradingEnabled = false;
378 
379     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
380 
381     mapping(address => bool) public whitelist;
382 
383     constructor() BEP20("MONEY", "$MONEY") {
384         _tokengeneration(msg.sender, 69e6 * 10**decimals());
385         whitelist[msg.sender] = true;
386 
387         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
388         // Create a pancake pair for this new token
389         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
390 
391         router = _router;
392         pair = _pair;
393         whitelist[address(this)] = true;
394         whitelist[deadWallet] = true;
395         whitelist[0x71B5759d73262FBb223956913ecF4ecC51057641] = true;
396         whitelist[0xD152f549545093347A162Dce210e7293f1452150] = true;
397 
398     }
399 
400     function approve(address spender, uint256 amount) public override returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) public override returns (bool) {
410         _transfer(sender, recipient, amount);
411 
412         uint256 currentAllowance = _allowances[sender][_msgSender()];
413         require(currentAllowance >= amount, "BEP20: transfer amount exceeds allowance");
414         _approve(sender, _msgSender(), currentAllowance - amount);
415 
416         return true;
417     }
418 
419     function increaseAllowance(address spender, uint256 addedValue)
420         public
421         override
422         returns (bool)
423     {
424         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
425         return true;
426     }
427 
428     function decreaseAllowance(address spender, uint256 subtractedValue)
429         public
430         override
431         returns (bool)
432     {
433         uint256 currentAllowance = _allowances[_msgSender()][spender];
434         require(currentAllowance >= subtractedValue, "BEP20: decreased allowance below zero");
435         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
436 
437         return true;
438     }
439 
440     function transfer(address recipient, uint256 amount) public override returns (bool) {
441         _transfer(msg.sender, recipient, amount);
442         return true;
443     }
444 
445     function _transfer(
446         address sender,
447         address recipient,
448         uint256 amount
449     ) internal override {
450         require(amount > 0, "Transfer amount must be greater than zero");
451 
452         if (!whitelist[sender] && !whitelist[recipient]) {
453             require(tradingEnabled, "Trading not enabled");
454         }
455 
456         //rest to recipient
457         super._transfer(sender, recipient, amount);
458     }
459 
460     function EnableTrading() external onlyOwner {
461         require(!tradingEnabled, "Cannot re-enable trading");
462         tradingEnabled = true;
463     }
464 
465     function updateWhitelist(address _address, bool state) external onlyOwner {
466         whitelist[_address] = state;
467     }
468 
469     function bulkWhitelist(address[] memory accounts, bool state) external onlyOwner {
470         for (uint256 i = 0; i < accounts.length; i++) {
471             whitelist[accounts[i]] = state;
472         }
473     }
474 
475     function rescueETH(uint256 weiAmount) external onlyOwner {
476         payable(owner()).transfer(weiAmount);
477     }
478 
479     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
480         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
481         IBEP20(tokenAdd).transfer(owner(), amount);
482     }
483 
484     function burnERC20(address tokenAdd, uint256 amount) external onlyOwner {
485         IBEP20(tokenAdd).transfer(deadWallet, amount);
486     }
487 
488     // fallbacks
489     receive() external payable {}
490 }