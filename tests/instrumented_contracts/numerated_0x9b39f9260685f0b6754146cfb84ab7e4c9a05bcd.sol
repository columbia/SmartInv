1 /*
2 *
3 *  Kwon The Run Bounty Hunters!
4 *  
5 *  So you made it, you're here for another meme token...
6 *  We're here to investigate Do Kwon and meme the shill out of him,
7 *  We are launching meme contests and have community bounties in DeWork.
8 *  Fun, community, jokes, memes, and participation are at the heart of this project.
9 *  If you like being first in on a token with an ever growing community, Join us!  
10 *  SCheck out our Kwon The Run Bounty Paper & our Forever Meme DAO Whitepaper!
11 *  Lets go Bounty Hunters!! 
12 *  Kwon for Prison!
13 *
14 *     Linktree:     https://linktr.ee/kwontherun
15 *     Website:      https://www.kwontherun.xyz
16 *     Bounty:       https://app.dework.xyz/kwontherun
17 *     Reddit:       https://www.reddit.com/r/kwontherun/
18 *     Twitter:      https://twitter.com/kwontherun
19 *     Telegram:     https://t.me/kwontherun
20 *     Mirror:       https://mirror.xyz/kwontherun.eth
21 *     Github:       https://github.com/KwonTheRunDAO/kwontherun
22 *     Multisig:     https://gnosis-safe.io/app/eth:0x2C9b437383528e9ccD513F3B8885122e27eB6Cb5/home
23 * 
24 * 
25 *     
26 *  ██╗░░██╗░██╗░░░░░░░██╗░█████╗░███╗░░██╗████████╗██╗░░██╗███████╗██████╗░██╗░░░██╗███╗░░██╗
27 *  ██║░██╔╝░██║░░██╗░░██║██╔══██╗████╗░██║╚══██╔══╝██║░░██║██╔════╝██╔══██╗██║░░░██║████╗░██║
28 *  █████═╝░░╚██╗████╗██╔╝██║░░██║██╔██╗██║░░░██║░░░███████║█████╗░░██████╔╝██║░░░██║██╔██╗██║
29 *  ██╔═██╗░░░████╔═████║░██║░░██║██║╚████║░░░██║░░░██╔══██║██╔══╝░░██╔══██╗██║░░░██║██║╚████║
30 *  ██║░╚██╗░░╚██╔╝░╚██╔╝░╚█████╔╝██║░╚███║░░░██║░░░██║░░██║███████╗██║░░██║╚██████╔╝██║░╚███║
31 *  ╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚════╝░╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝
32 *                                                                                                           
33 *                                         
34 *
35 *
36 *     @@@@@@@@@@@@@@@@@###BB##B#####&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
37 *     @@@@@@@@@@@@###B#B##&&&&&&&&######B#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
38 *     @@@@@@@@@@BPGB#&@@@@@@@@@@@@@@@@@@&##B##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
39 *     @@@@@@@&BBB#@@@@@@@@@@@@@@@@@@@@@@@@@@&#BBB&@@@@@@@@@@@@@@@@@@@@@@@@@@
40 *     @@@@@&#G#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#BB#@@@@@@@@@@@@@@@@@@@@@@@@
41 *     @@@@#P#&&&&@@@@@&&&@@@@&&&@&@&@@@@@@@@@@@@&&#BG@@@@@@@@@@@@@@@@@@@@@@@
42 *     @@@#GB#&&&&&&@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@&&#B#@@@@@@@@@@@@@@@@@@@@@
43 *     @@#B&&&&&&&&&######BB##&&&&&&&@@@@@@@@@@@&&&&&&&G&@@@@@@@@@@@@@@@@@@@@
44 *     @##&@@@&&#GPP5555YJJJJY5PP55555PB#&&&&&@@&&&&&&&#G@@@@@@@@@@@@@@@@@@@@
45 *     @B&&@@&#PYJ??777!~~~~^~~~~~!!!!7?Y5PG##&&&#&&&&@&B#@@@@@@@@@@@@@@@@@@@
46 *     &G&&&&GJ?77!!~~^^::::.:::::::^~~!7?JJ5GB#&&&&&@@&#G@@@@@@@@@@@@@@@@@@@
47 *     &G&&&BJ?7!!!~~^^:::........::^^~~!!77?J5G#&&&&@@&#G@@@@@@@@@@@@@@@@@@@
48 *     &G&&#5?7!!~~~~^::::::....:::^^~~~~!!!!7?JG#&&&&@&&B@@@@@@@@@@@@@@@@@@@
49 *     &G&&GJ?7!!~~^^::::::::....:::^^~~~~!!!!7?PB#&&@@&#B@@@@@@@@@@@@@@@@@@@
50 *     @G&#YJJY5YYJJ?~^::...:...::^~~~~~!!!!!77JGB#&&&&&#B@@@@@@@@@@@@@@@@@@@
51 *     @G&GJY5YJJY555J7~^^::::^~7?Y5P55YYJ7!777?G##&&&&&G@@@@@@@@@@@@@@@@@@@@
52 *     @B#5JJ7!~~^^^!7?7!~~^~~!7?77!~~~!7???7777JB#&&&&B&@@@@@@@@@@@@@@@@@@@@
53 *     @&BY?JJY5Y55Y?77?7!~^~!77!~!~^^^^^~!777???Y#&&&##@@@@@@@@@@@@@@@@@@@@@
54 *     @@B?!7JYJ?J55J7!!7~::^~!77JJGGG55YJ?77???J5#&&#P#@@@@@@@@@@@@@@@@@@@@@
55 *     @@#7~^~~!!7!!~^^~!^::^~~~777???7???7!!7??JP##BGBB@@@@@@@@@@@@@@@@@@@@@
56 *     @@B!~^::::::::^~~~^::~~~^:^^^~~~~^^^^~!JJ5G#BGJY&@@@@@@@@@@@@@@@@@@@@@
57 *     @@G!~^::....:^~~~~^:^~~~^::::.....:^^~7J5PGPPP?5@@@@@@@@@@@@@@@@@@@@@@
58 *     @@B7~^^:::^^!7!!7~::^~~~~~^::....::^~!?YPPPJ!~~P@@@@@@@@@@@@@@@@@@@@@@
59 *     @@#J?7!!!!77!7YPP5YY5P5JJ7!!^^::^^^~!?YP555?!~J@@@@@@@@@@@@@@@@@@@@@@@
60 *     @@@5JJJ????!~!!77?Y5Y?J?7~~7J7!!!!7?JY5P55?~!5@@@@@@@@@@@@@@@@@@@@@@@@
61 *     @@@P?77!!77?JJJJ?7!!!!!!!!!!?YJJJJJJYY5PPPPG#@@@@@@@@@@@@@@@@@@@@@@@@@
62 *     @@@&J7!~~^!5#P77!~!~77J?5PGP7~!7777?J5PPB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
63 *     @@@@B?7!~^^^!7~^^:::^:^^!??!^^~~~!7J5GB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
64 *     @@@@@GJ?!~^^~!!~^^^^^^~!!^:^^!!!7?YG#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
65 *     @@@@@@P?7!~^^~~~~~~~~~~~^^^~~!?JYGPY#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
66 *     @@@@@@@PJ7!~^^^^::::::^^^~~~!?YPG5?7?5&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
67 *     @@@@@@@@GY?!~^^^::::::^^~~~7J5PY?7???7JY5PG#&@@@@@@@@@@@@@@@@@@@@@@@@@
68 *     @@@@@@@@@#G5J?7!~~~~!!77?J55Y?!!!!?????7~~~!!J&@@@@@@@@@@@@@@@@@@@@@@@
69 *     @@@@@@@@@@@&&#GPPPPPPGGBPY?!!!!!!!??????7!!!!~5@@@@@@@@@@@@@@@@@@@@@@@
70 *     @@@@@BPPP&@@@@@@@&&&@@@#!~!!!!!!!7???????!!!!~5@@@@@@@@@@@@@@@@@@@@@@@
71 *     @@@@&!~~~7PB&&@@@@@@@@@J~!!!!!!7?????????7!!!~P@@@@@@@@@@@@@@@@@@@@@@@
72 *     @@@@&7~~~~~~!7?J5PGB#&5~!!!!!!7???????????!!!~G@@@@@@@@@@@@@@@@@@@@@@@
73 *     @@@@@#GGGPY?!~~~~~~!!!!!!!!!7?????????????7!!!B@@@@@@@@@@@@@@@@@@@@@@@
74 *     @@@@@@@@@@@@#G5?7!~~~!!!~!77??????????????7!!!#@@@@@@@@@@@@@@@@@@@@@@@
75 *     @@@@@@@@@@@@@@@@&BPY?7!7JB#????????????????!!!J&@@@@@@@@@@@@@@@@@@@@@@
76 *     @@@@@@@@@@@@@@@@@@@@@&&&@@@57??????????????7~~~G@@@@@@@@@@@@@@@@@@@@@@
77 *     @@@@@@@@@@@@@@@@@@@@@@@@@@@B7???????????????YP#@@@@@@@@@@@@@@@@@@@@@@@
78 *     @@@@@@@@@@@@@@@@@@@@@@@@@@@&?7????????????7J@@@@@@@@@@@@@@@@@@@@@@@@@@
79 *     @@@@@@@@@@@@@@@@@@@@@@@@&#BPJJJJ????????????#@@@@@@@@@@@@@@@@@@@@@@@@@
80 *     @@@@@@@@@@@@@@@@@@@@@BGP55555555YJJJJJJJJJJJ#@@@@@@@@@@@@@@@@@@@@@@@@@
81 *     @@@@@@@@@@@@@@@@@@#PJY5555555555YJYYYYYYYYYJG@@@@@@@@@@@@@@@@@@@@@@@@@
82 *     @@@@@@@@@@@@@@@#P?!~~75555555555YJYYYYYYYYYJ5@@@@@@@@@@@@@@@@@@@@@@@@@
83 *     @@@@@@@@@@@@@BJ!~~!!!!75555555555JYYYYYYYYYYY#@@@@@@@@@@@@@@@@@@@@@@@@
84 *     @@@@@@@@@@@@@?~!!!!!!!~!J55555PGB5JYYYYYYYYJYB@@@@@@@@@@@@@@@@@@@@@@@@
85 *     @@@@@@@@@@@@@Y~!!!!!!!?YPBGB#&@@@BYJJJJ??77!Y@@@@@@@@@@@@@@@@@@@@@@@@@
86 *     @@@@@@@@@@@@@#!!!!!!!G@@@@@@@@@@@@&?!!!!!!!!7#@@@@@@@@@@@@@@@@@@@@@@@@
87 *     @@@@@@@@@@@@@@P~!!!!~J@@@@@@@@@@@@@#!!!!!!!!!!7???JJYY55PGB#&BGP5PP5G@
88 *     @@@@@@@@@@@@@@@?~!!!!!#@@@@@@@@@@@@@G!!!!!!!!!!!!~~~~~~~~~!!!7J?77^:~&
89 *     @@@@@@@@@@@@@@@B!!!!!~P@@@@@@@@@@@@@@G7!~~~~~~~~~~~~!!!!!!!!!7JJ?7^:7@
90 *     @@@@@@@@@@@@@@@@5~!!!~J@@@@@@@@@@@@@@@&BGGPPPPGGGGGBBBBB###B??YYYJ^:J@
91 *     @@@@@@@@@@@@@@@@@?~!!!7&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G!?YYJ~:P@
92 *     @@@@@@@@@@@@@@@@@#!!!!!&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y!JYY!:B@
93 *     @@@@@@@@@@@@@@@@&#J!!!!P#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PJYY!~&@
94 *     @@@@@@@@@@@@@#BY?7YJJ?J??#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&YJ?^P@@
95 *     @@@@@@@@@@&#G?7?JYYYJ?777Y@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BPYG@@@
96 *     @@@@@@@@B5YYJYJJ?7!~^^^^^!&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
97 *     @@@@@@@@GJ?77!!!77?JYPGB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
98 *     @@@@@@@@@@&###&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
99 *     
100 *     KwonTheRun, by Kwon Hunter
101 *            	    
102 *            	    
103 */
104 
105 // SPDX-License-Identifier: MIT
106 
107 pragma solidity 0.8.9;
108  
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113  
114     function _msgData() internal view virtual returns (bytes calldata) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119  
120 interface IUniswapV2Pair {
121     event Approval(address indexed owner, address indexed spender, uint value);
122     event Transfer(address indexed from, address indexed to, uint value);
123  
124     function name() external pure returns (string memory);
125     function symbol() external pure returns (string memory);
126     function decimals() external pure returns (uint8);
127     function totalSupply() external view returns (uint);
128     function balanceOf(address owner) external view returns (uint);
129     function allowance(address owner, address spender) external view returns (uint);
130  
131     function approve(address spender, uint value) external returns (bool);
132     function transfer(address to, uint value) external returns (bool);
133     function transferFrom(address from, address to, uint value) external returns (bool);
134  
135     function DOMAIN_SEPARATOR() external view returns (bytes32);
136     function PERMIT_TYPEHASH() external pure returns (bytes32);
137     function nonces(address owner) external view returns (uint);
138  
139     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
140  
141     event Mint(address indexed sender, uint amount0, uint amount1);
142     event Swap(
143         address indexed sender,
144         uint amount0In,
145         uint amount1In,
146         uint amount0Out,
147         uint amount1Out,
148         address indexed to
149     );
150     event Sync(uint112 reserve0, uint112 reserve1);
151  
152     function MINIMUM_LIQUIDITY() external pure returns (uint);
153     function factory() external view returns (address);
154     function token0() external view returns (address);
155     function token1() external view returns (address);
156     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
157     function price0CumulativeLast() external view returns (uint);
158     function price1CumulativeLast() external view returns (uint);
159     function kLast() external view returns (uint);
160  
161     function mint(address to) external returns (uint liquidity);
162     function burn(address to) external returns (uint amount0, uint amount1);
163     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
164     function skim(address to) external;
165     function sync() external;
166  
167     function initialize(address, address) external;
168 }
169  
170 interface IUniswapV2Factory {
171     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
172  
173     function feeTo() external view returns (address);
174     function feeToSetter() external view returns (address);
175  
176     function getPair(address tokenA, address tokenB) external view returns (address pair);
177     function allPairs(uint) external view returns (address pair);
178     function allPairsLength() external view returns (uint);
179  
180     function createPair(address tokenA, address tokenB) external returns (address pair);
181  
182     function setFeeTo(address) external;
183     function setFeeToSetter(address) external;
184 }
185  
186 interface IERC20 {
187     /**
188      * @dev Returns the amount of tokens in existence.
189      */
190     function totalSupply() external view returns (uint256);
191  
192     /**
193      * @dev Returns the amount of tokens owned by `account`.
194      */
195     function balanceOf(address account) external view returns (uint256);
196  
197     /**
198      * @dev Moves `amount` tokens from the caller's account to `recipient`.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transfer(address recipient, uint256 amount) external returns (bool);
205  
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender) external view returns (uint256);
214  
215     /**
216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
221      * that someone may use both the old and the new allowance by unfortunate
222      * transaction ordering. One possible solution to mitigate this race
223      * condition is to first reduce the spender's allowance to 0 and set the
224      * desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address spender, uint256 amount) external returns (bool);
230  
231     /**
232      * @dev Moves `amount` tokens from `sender` to `recipient` using the
233      * allowance mechanism. `amount` is then deducted from the caller's
234      * allowance.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transferFrom(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) external returns (bool);
245  
246     /**
247      * @dev Emitted when `value` tokens are moved from one account (`from`) to
248      * another (`to`).
249      *
250      * Note that `value` may be zero.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 value);
253  
254     /**
255      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
256      * a call to {approve}. `value` is the new allowance.
257      */
258     event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260  
261 interface IERC20Metadata is IERC20 {
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() external view returns (string memory);
266  
267     /**
268      * @dev Returns the symbol of the token.
269      */
270     function symbol() external view returns (string memory);
271  
272     /**
273      * @dev Returns the decimals places of the token.
274      */
275     function decimals() external view returns (uint8);
276 }
277  
278  
279 contract ERC20 is Context, IERC20, IERC20Metadata {
280     using SafeMath for uint256;
281  
282     mapping(address => uint256) private _balances;
283  
284     mapping(address => mapping(address => uint256)) private _allowances;
285  
286     uint256 private _totalSupply;
287  
288     string private _name;
289     string private _symbol;
290  
291     /**
292      * @dev Sets the values for {name} and {symbol}.
293      *
294      * The default value of {decimals} is 18. To select a different value for
295      * {decimals} you should overload it.
296      *
297      * All two of these values are immutable: they can only be set once during
298      * construction.
299      */
300     constructor(string memory name_, string memory symbol_) {
301         _name = name_;
302         _symbol = symbol_;
303     }
304  
305     /**
306      * @dev Returns the name of the token.
307      */
308     function name() public view virtual override returns (string memory) {
309         return _name;
310     }
311  
312     /**
313      * @dev Returns the symbol of the token, usually a shorter version of the
314      * name.
315      */
316     function symbol() public view virtual override returns (string memory) {
317         return _symbol;
318     }
319  
320     /**
321      * @dev Returns the number of decimals used to get its user representation.
322      * For example, if `decimals` equals `2`, a balance of `505` tokens should
323      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
324      *
325      * Tokens usually opt for a value of 18, imitating the relationship between
326      * Ether and Wei. This is the value {ERC20} uses, unless this function is
327      * overridden;
328      *
329      * NOTE: This information is only used for _display_ purposes: it in
330      * no way affects any of the arithmetic of the contract, including
331      * {IERC20-balanceOf} and {IERC20-transfer}.
332      */
333     function decimals() public view virtual override returns (uint8) {
334         return 18;
335     }
336  
337     /**
338      * @dev See {IERC20-totalSupply}.
339      */
340     function totalSupply() public view virtual override returns (uint256) {
341         return _totalSupply;
342     }
343  
344     /**
345      * @dev See {IERC20-balanceOf}.
346      */
347     function balanceOf(address account) public view virtual override returns (uint256) {
348         return _balances[account];
349     }
350  
351     /**
352      * @dev See {IERC20-transfer}.
353      *
354      * Requirements:
355      *
356      * - `recipient` cannot be the zero address.
357      * - the caller must have a balance of at least `amount`.
358      */
359     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363  
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender) public view virtual override returns (uint256) {
368         return _allowances[owner][spender];
369     }
370  
371     /**
372      * @dev See {IERC20-approve}.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      */
378     function approve(address spender, uint256 amount) public virtual override returns (bool) {
379         _approve(_msgSender(), spender, amount);
380         return true;
381     }
382  
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20}.
388      *
389      * Requirements:
390      *
391      * - `sender` and `recipient` cannot be the zero address.
392      * - `sender` must have a balance of at least `amount`.
393      * - the caller must have allowance for ``sender``'s tokens of at least
394      * `amount`.
395      */
396     function transferFrom(
397         address sender,
398         address recipient,
399         uint256 amount
400     ) public virtual override returns (bool) {
401         _transfer(sender, recipient, amount);
402         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
403         return true;
404     }
405  
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
420         return true;
421     }
422  
423     /**
424      * @dev Atomically decreases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      * - `spender` must have allowance for the caller of at least
435      * `subtractedValue`.
436      */
437     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
439         return true;
440     }
441  
442     /**
443      * @dev Moves tokens `amount` from `sender` to `recipient`.
444      *
445      * This is internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `sender` cannot be the zero address.
453      * - `recipient` cannot be the zero address.
454      * - `sender` must have a balance of at least `amount`.
455      */
456     function _transfer(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) internal virtual {
461         require(sender != address(0), "ERC20: transfer from the zero address");
462         require(recipient != address(0), "ERC20: transfer to the zero address");
463  
464         _beforeTokenTransfer(sender, recipient, amount);
465  
466         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
467         _balances[recipient] = _balances[recipient].add(amount);
468         emit Transfer(sender, recipient, amount);
469     }
470  
471     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
472      * the total supply.
473      *
474      * Emits a {Transfer} event with `from` set to the zero address.
475      *
476      * Requirements:
477      *
478      * - `account` cannot be the zero address.
479      */
480     function _mint(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: mint to the zero address");
482  
483         _beforeTokenTransfer(address(0), account, amount);
484  
485         _totalSupply = _totalSupply.add(amount);
486         _balances[account] = _balances[account].add(amount);
487         emit Transfer(address(0), account, amount);
488     }
489  
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503  
504         _beforeTokenTransfer(account, address(0), amount);
505  
506         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
507         _totalSupply = _totalSupply.sub(amount);
508         emit Transfer(account, address(0), amount);
509     }
510  
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531  
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535  
536     /**
537      * @dev Hook that is called before any transfer of tokens. This includes
538      * minting and burning.
539      *
540      * Calling conditions:
541      *
542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
543      * will be to transferred to `to`.
544      * - when `from` is zero, `amount` tokens will be minted for `to`.
545      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
546      * - `from` and `to` are never both zero.
547      *
548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
549      */
550     function _beforeTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 }
556  
557 library SafeMath {
558     /**
559      * @dev Returns the addition of two unsigned integers, reverting on
560      * overflow.
561      *
562      * Counterpart to Solidity's `+` operator.
563      *
564      * Requirements:
565      *
566      * - Addition cannot overflow.
567      */
568     function add(uint256 a, uint256 b) internal pure returns (uint256) {
569         uint256 c = a + b;
570         require(c >= a, "SafeMath: addition overflow");
571  
572         return c;
573     }
574  
575     /**
576      * @dev Returns the subtraction of two unsigned integers, reverting on
577      * overflow (when the result is negative).
578      *
579      * Counterpart to Solidity's `-` operator.
580      *
581      * Requirements:
582      *
583      * - Subtraction cannot overflow.
584      */
585     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
586         return sub(a, b, "SafeMath: subtraction overflow");
587     }
588  
589     /**
590      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
591      * overflow (when the result is negative).
592      *
593      * Counterpart to Solidity's `-` operator.
594      *
595      * Requirements:
596      *
597      * - Subtraction cannot overflow.
598      */
599     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b <= a, errorMessage);
601         uint256 c = a - b;
602  
603         return c;
604     }
605  
606     /**
607      * @dev Returns the multiplication of two unsigned integers, reverting on
608      * overflow.
609      *
610      * Counterpart to Solidity's `*` operator.
611      *
612      * Requirements:
613      *
614      * - Multiplication cannot overflow.
615      */
616     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
617         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
618         // benefit is lost if 'b' is also tested.
619         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
620         if (a == 0) {
621             return 0;
622         }
623  
624         uint256 c = a * b;
625         require(c / a == b, "SafeMath: multiplication overflow");
626  
627         return c;
628     }
629  
630     /**
631      * @dev Returns the integer division of two unsigned integers. Reverts on
632      * division by zero. The result is rounded towards zero.
633      *
634      * Counterpart to Solidity's `/` operator. Note: this function uses a
635      * `revert` opcode (which leaves remaining gas untouched) while Solidity
636      * uses an invalid opcode to revert (consuming all remaining gas).
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         return div(a, b, "SafeMath: division by zero");
644     }
645  
646     /**
647      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
648      * division by zero. The result is rounded towards zero.
649      *
650      * Counterpart to Solidity's `/` operator. Note: this function uses a
651      * `revert` opcode (which leaves remaining gas untouched) while Solidity
652      * uses an invalid opcode to revert (consuming all remaining gas).
653      *
654      * Requirements:
655      *
656      * - The divisor cannot be zero.
657      */
658     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
659         require(b > 0, errorMessage);
660         uint256 c = a / b;
661         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
662  
663         return c;
664     }
665  
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
668      * Reverts when dividing by zero.
669      *
670      * Counterpart to Solidity's `%` operator. This function uses a `revert`
671      * opcode (which leaves remaining gas untouched) while Solidity uses an
672      * invalid opcode to revert (consuming all remaining gas).
673      *
674      * Requirements:
675      *
676      * - The divisor cannot be zero.
677      */
678     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
679         return mod(a, b, "SafeMath: modulo by zero");
680     }
681  
682     /**
683      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
684      * Reverts with custom message when dividing by zero.
685      *
686      * Counterpart to Solidity's `%` operator. This function uses a `revert`
687      * opcode (which leaves remaining gas untouched) while Solidity uses an
688      * invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         require(b != 0, errorMessage);
696         return a % b;
697     }
698 }
699  
700 contract Ownable is Context {
701     address private _owner;
702  
703     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
704  
705     /**
706      * @dev Initializes the contract setting the deployer as the initial owner.
707      */
708     constructor () {
709         address msgSender = _msgSender();
710         _owner = msgSender;
711         emit OwnershipTransferred(address(0), msgSender);
712     }
713  
714     /**
715      * @dev Returns the address of the current owner.
716      */
717     function owner() public view returns (address) {
718         return _owner;
719     }
720  
721     /**
722      * @dev Throws if called by any account other than the owner.
723      */
724     modifier onlyOwner() {
725         require(_owner == _msgSender(), "Ownable: caller is not the owner");
726         _;
727     }
728  
729     /**
730      * @dev Leaves the contract without owner. It will not be possible to call
731      * `onlyOwner` functions anymore. Can only be called by the current owner.
732      *
733      * NOTE: Renouncing ownership will leave the contract without an owner,
734      * thereby removing any functionality that is only available to the owner.
735      */
736     function renounceOwnership() public virtual onlyOwner {
737         emit OwnershipTransferred(_owner, address(0));
738         _owner = address(0);
739     }
740  
741     /**
742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
743      * Can only be called by the current owner.
744      */
745     function transferOwnership(address newOwner) public virtual onlyOwner {
746         require(newOwner != address(0), "Ownable: new owner is the zero address");
747         emit OwnershipTransferred(_owner, newOwner);
748         _owner = newOwner;
749     }
750 }
751  
752  
753  
754 library SafeMathInt {
755     int256 private constant MIN_INT256 = int256(1) << 255;
756     int256 private constant MAX_INT256 = ~(int256(1) << 255);
757  
758     /**
759      * @dev Multiplies two int256 variables and fails on overflow.
760      */
761     function mul(int256 a, int256 b) internal pure returns (int256) {
762         int256 c = a * b;
763  
764         // Detect overflow when multiplying MIN_INT256 with -1
765         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
766         require((b == 0) || (c / b == a));
767         return c;
768     }
769  
770     /**
771      * @dev Division of two int256 variables and fails on overflow.
772      */
773     function div(int256 a, int256 b) internal pure returns (int256) {
774         // Prevent overflow when dividing MIN_INT256 by -1
775         require(b != -1 || a != MIN_INT256);
776  
777         // Solidity already throws when dividing by 0.
778         return a / b;
779     }
780  
781     /**
782      * @dev Subtracts two int256 variables and fails on overflow.
783      */
784     function sub(int256 a, int256 b) internal pure returns (int256) {
785         int256 c = a - b;
786         require((b >= 0 && c <= a) || (b < 0 && c > a));
787         return c;
788     }
789  
790     /**
791      * @dev Adds two int256 variables and fails on overflow.
792      */
793     function add(int256 a, int256 b) internal pure returns (int256) {
794         int256 c = a + b;
795         require((b >= 0 && c >= a) || (b < 0 && c < a));
796         return c;
797     }
798  
799     /**
800      * @dev Converts to absolute value, and fails on overflow.
801      */
802     function abs(int256 a) internal pure returns (int256) {
803         require(a != MIN_INT256);
804         return a < 0 ? -a : a;
805     }
806  
807  
808     function toUint256Safe(int256 a) internal pure returns (uint256) {
809         require(a >= 0);
810         return uint256(a);
811     }
812 }
813  
814 library SafeMathUint {
815   function toInt256Safe(uint256 a) internal pure returns (int256) {
816     int256 b = int256(a);
817     require(b >= 0);
818     return b;
819   }
820 }
821  
822  
823 interface IUniswapV2Router01 {
824     function factory() external pure returns (address);
825     function WETH() external pure returns (address);
826  
827     function addLiquidity(
828         address tokenA,
829         address tokenB,
830         uint amountADesired,
831         uint amountBDesired,
832         uint amountAMin,
833         uint amountBMin,
834         address to,
835         uint deadline
836     ) external returns (uint amountA, uint amountB, uint liquidity);
837     function addLiquidityETH(
838         address token,
839         uint amountTokenDesired,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline
844     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
845     function removeLiquidity(
846         address tokenA,
847         address tokenB,
848         uint liquidity,
849         uint amountAMin,
850         uint amountBMin,
851         address to,
852         uint deadline
853     ) external returns (uint amountA, uint amountB);
854     function removeLiquidityETH(
855         address token,
856         uint liquidity,
857         uint amountTokenMin,
858         uint amountETHMin,
859         address to,
860         uint deadline
861     ) external returns (uint amountToken, uint amountETH);
862     function removeLiquidityWithPermit(
863         address tokenA,
864         address tokenB,
865         uint liquidity,
866         uint amountAMin,
867         uint amountBMin,
868         address to,
869         uint deadline,
870         bool approveMax, uint8 v, bytes32 r, bytes32 s
871     ) external returns (uint amountA, uint amountB);
872     function removeLiquidityETHWithPermit(
873         address token,
874         uint liquidity,
875         uint amountTokenMin,
876         uint amountETHMin,
877         address to,
878         uint deadline,
879         bool approveMax, uint8 v, bytes32 r, bytes32 s
880     ) external returns (uint amountToken, uint amountETH);
881     function swapExactTokensForTokens(
882         uint amountIn,
883         uint amountOutMin,
884         address[] calldata path,
885         address to,
886         uint deadline
887     ) external returns (uint[] memory amounts);
888     function swapTokensForExactTokens(
889         uint amountOut,
890         uint amountInMax,
891         address[] calldata path,
892         address to,
893         uint deadline
894     ) external returns (uint[] memory amounts);
895     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
896         external
897         payable
898         returns (uint[] memory amounts);
899     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
900         external
901         returns (uint[] memory amounts);
902     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
903         external
904         returns (uint[] memory amounts);
905     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
906         external
907         payable
908         returns (uint[] memory amounts);
909  
910     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
911     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
912     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
913     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
914     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
915 }
916  
917 interface IUniswapV2Router02 is IUniswapV2Router01 {
918     function removeLiquidityETHSupportingFeeOnTransferTokens(
919         address token,
920         uint liquidity,
921         uint amountTokenMin,
922         uint amountETHMin,
923         address to,
924         uint deadline
925     ) external returns (uint amountETH);
926     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
927         address token,
928         uint liquidity,
929         uint amountTokenMin,
930         uint amountETHMin,
931         address to,
932         uint deadline,
933         bool approveMax, uint8 v, bytes32 r, bytes32 s
934     ) external returns (uint amountETH);
935  
936     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
937         uint amountIn,
938         uint amountOutMin,
939         address[] calldata path,
940         address to,
941         uint deadline
942     ) external;
943     function swapExactETHForTokensSupportingFeeOnTransferTokens(
944         uint amountOutMin,
945         address[] calldata path,
946         address to,
947         uint deadline
948     ) external payable;
949     function swapExactTokensForETHSupportingFeeOnTransferTokens(
950         uint amountIn,
951         uint amountOutMin,
952         address[] calldata path,
953         address to,
954         uint deadline
955     ) external;
956 }
957  
958 contract KwonTheRun is ERC20, Ownable {
959     using SafeMath for uint256;
960  
961     IUniswapV2Router02 public immutable uniswapV2Router;
962     address public immutable uniswapV2Pair;
963  
964     bool private swapping;
965  
966     address private daoWallet;
967     address private devWallet;
968  
969     uint256 private maxTransactionAmount;
970     uint256 private swapTokensAtAmount;
971     uint256 private maxWallet;
972  
973     bool private limitsInEffect = true;
974     bool private tradingActive = false;
975     bool public swapEnabled = false;
976     bool public enableEarlySellTax = false;
977  
978      // Anti-bot and anti-whale mappings and variables
979     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
980  
981     // Seller Map
982     mapping (address => uint256) private _holderFirstBuyTimestamp;
983  
984     // Blacklist Map
985     mapping (address => bool) private _blacklist;
986     bool public transferDelayEnabled = true;
987  
988     uint256 private buyTotalFees;
989     uint256 private buyDaoFee;
990     uint256 private buyLiquidityFee;
991     uint256 private buyDevFee;
992  
993     uint256 private sellTotalFees;
994     uint256 private sellDaoFee;
995     uint256 private sellLiquidityFee;
996     uint256 private sellDevFee;
997  
998     uint256 private earlySellLiquidityFee;
999     uint256 private earlySellDaoFee;
1000     uint256 private earlySellDevFee;
1001  
1002     uint256 private tokensForDao;
1003     uint256 private tokensForLiquidity;
1004     uint256 private tokensForDev;
1005  
1006     // block number of opened trading
1007     uint256 launchedAt;
1008  
1009     /******************/
1010  
1011     // exclude from fees and max transaction amount
1012     mapping (address => bool) private _isExcludedFromFees;
1013     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1014  
1015     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1016     // could be subject to a maximum transfer amount
1017     mapping (address => bool) public automatedMarketMakerPairs;
1018  
1019     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1020  
1021     event ExcludeFromFees(address indexed account, bool isExcluded);
1022  
1023     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1024  
1025     event daoWalletUpdated(address indexed newWallet, address indexed oldWallet);
1026  
1027     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1028  
1029     event SwapAndLiquify(
1030         uint256 tokensSwapped,
1031         uint256 ethReceived,
1032         uint256 tokensIntoLiquidity
1033     );
1034  
1035     event AutoNukeLP();
1036  
1037     event ManualNukeLP();
1038  
1039     constructor() ERC20("KwonTheRun", "GUILTY") {
1040  
1041         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1042  
1043         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1044         uniswapV2Router = _uniswapV2Router;
1045  
1046         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1047         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1048         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1049  
1050         uint256 _buyDaoFee = 3;
1051         uint256 _buyLiquidityFee = 0;
1052         uint256 _buyDevFee = 3;
1053  
1054         uint256 _sellDaoFee = 3;
1055         uint256 _sellLiquidityFee = 0;
1056         uint256 _sellDevFee = 3;
1057  
1058         uint256 _earlySellLiquidityFee = 0;
1059         uint256 _earlySellDaoFee = 5;
1060 	    uint256 _earlySellDevFee = 5;
1061         uint256 totalSupply = 1 * 1e6 * 1e18;
1062  
1063         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
1064         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
1065         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1066  
1067         buyDaoFee = _buyDaoFee;
1068         buyLiquidityFee = _buyLiquidityFee;
1069         buyDevFee = _buyDevFee;
1070         buyTotalFees = buyDaoFee + buyLiquidityFee + buyDevFee;
1071  
1072         sellDaoFee = _sellDaoFee;
1073         sellLiquidityFee = _sellLiquidityFee;
1074         sellDevFee = _sellDevFee;
1075         sellTotalFees = sellDaoFee + sellLiquidityFee + sellDevFee;
1076  
1077         earlySellLiquidityFee = _earlySellLiquidityFee;
1078         earlySellDaoFee = _earlySellDaoFee;
1079 	    earlySellDevFee = _earlySellDevFee;
1080  
1081         daoWallet = address(owner()); // set as dao wallet
1082         devWallet = address(owner()); // set as dev wallet
1083  
1084         // exclude from paying fees or having max transaction amount
1085         excludeFromFees(owner(), true);
1086         excludeFromFees(address(this), true);
1087         excludeFromFees(address(0xdead), true);
1088  
1089         excludeFromMaxTransaction(owner(), true);
1090         excludeFromMaxTransaction(address(this), true);
1091         excludeFromMaxTransaction(address(0xdead), true);
1092  
1093         /*
1094             _mint is an internal function in ERC20.sol that is only called here,
1095             and CANNOT be called ever again
1096         */
1097         _mint(msg.sender, totalSupply);
1098     }
1099  
1100     receive() external payable {
1101  
1102     }
1103  
1104     // once enabled, can never be turned off
1105     function enableTrading() external onlyOwner {
1106         tradingActive = true;
1107         swapEnabled = true;
1108         launchedAt = block.number;
1109     }
1110  
1111     // remove limits after token is stable
1112     function removeLimits() external onlyOwner returns (bool){
1113         limitsInEffect = false;
1114         return true;
1115     }
1116  
1117     // disable Transfer delay - cannot be reenabled
1118     function disableTransferDelay() external onlyOwner returns (bool){
1119         transferDelayEnabled = false;
1120         return true;
1121     }
1122  
1123     function setEarlySellTax(bool onoff) external onlyOwner  {
1124         enableEarlySellTax = onoff;
1125     }
1126  
1127      // change the minimum amount of tokens to sell from fees
1128     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1129         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1130         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1131         swapTokensAtAmount = newAmount;
1132         return true;
1133     }
1134  
1135     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1136         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1137         maxTransactionAmount = newNum * (10**18);
1138     }
1139  
1140     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1141         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1142         maxWallet = newNum * (10**18);
1143     }
1144  
1145     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1146         _isExcludedMaxTransactionAmount[updAds] = isEx;
1147     }
1148  
1149     // only use to disable contract sales if absolutely necessary (emergency use only)
1150     function updateSwapEnabled(bool enabled) external onlyOwner(){
1151         swapEnabled = enabled;
1152     }
1153  
1154     function updateBuyFees(uint256 _DaoFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1155         buyDaoFee = _DaoFee;
1156         buyLiquidityFee = _liquidityFee;
1157         buyDevFee = _devFee;
1158         buyTotalFees = buyDaoFee + buyLiquidityFee + buyDevFee;
1159         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1160     }
1161  
1162     function updateSellFees(uint256 _daoFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellDaoFee, uint256 _earlySellDevFee) external onlyOwner {
1163         sellDaoFee = _daoFee;
1164         sellLiquidityFee = _liquidityFee;
1165         sellDevFee = _devFee;
1166         earlySellLiquidityFee = _earlySellLiquidityFee;
1167         earlySellDaoFee = _earlySellDaoFee;
1168 	    earlySellDevFee = _earlySellDevFee;
1169         sellTotalFees = sellDaoFee + sellLiquidityFee + sellDevFee;
1170         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1171     }
1172  
1173     function excludeFromFees(address account, bool excluded) public onlyOwner {
1174         _isExcludedFromFees[account] = excluded;
1175         emit ExcludeFromFees(account, excluded);
1176     }
1177  
1178     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
1179         _blacklist[account] = isBlacklisted;
1180     }
1181  
1182     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1183         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1184  
1185         _setAutomatedMarketMakerPair(pair, value);
1186     }
1187  
1188     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1189         automatedMarketMakerPairs[pair] = value;
1190  
1191         emit SetAutomatedMarketMakerPair(pair, value);
1192     }
1193  
1194     function updateDaoWallet(address newDaoWallet) external onlyOwner {
1195         emit daoWalletUpdated(newDaoWallet, daoWallet);
1196         daoWallet = newDaoWallet;
1197     }
1198  
1199     function updateDevWallet(address newWallet) external onlyOwner {
1200         emit devWalletUpdated(newWallet, devWallet);
1201         devWallet = newWallet;
1202     }
1203  
1204  
1205     function isExcludedFromFees(address account) public view returns(bool) {
1206         return _isExcludedFromFees[account];
1207     }
1208  
1209     event BoughtEarly(address indexed sniper);
1210  
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 amount
1215     ) internal override {
1216         require(from != address(0), "ERC20: transfer from the zero address");
1217         require(to != address(0), "ERC20: transfer to the zero address");
1218         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1219          if(amount == 0) {
1220             super._transfer(from, to, 0);
1221             return;
1222         }
1223  
1224         if(limitsInEffect){
1225             if (
1226                 from != owner() &&
1227                 to != owner() &&
1228                 to != address(0) &&
1229                 to != address(0xdead) &&
1230                 !swapping
1231             ){
1232                 if(!tradingActive){
1233                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1234                 }
1235  
1236                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1237                 if (transferDelayEnabled){
1238                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1239                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1240                         _holderLastTransferTimestamp[tx.origin] = block.number;
1241                     }
1242                 }
1243  
1244                 //when buy
1245                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1246                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1247                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1248                 }
1249  
1250                 //when sell
1251                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1252                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1253                 }
1254                 else if(!_isExcludedMaxTransactionAmount[to]){
1255                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1256                 }
1257             }
1258         }
1259  
1260         // anti bot logic
1261         if (block.number <= (launchedAt) && 
1262                 to != uniswapV2Pair && 
1263                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1264             ) { 
1265             _blacklist[to] = false;
1266         }
1267  
1268         // early sell logic
1269         bool isBuy = from == uniswapV2Pair;
1270         if (!isBuy && enableEarlySellTax) {
1271             if (_holderFirstBuyTimestamp[from] != 0 &&
1272                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1273                 sellLiquidityFee = earlySellLiquidityFee;
1274                 sellDaoFee = earlySellDaoFee;
1275 		        sellDevFee = earlySellDevFee;
1276                 sellTotalFees = sellDaoFee + sellLiquidityFee + sellDevFee;
1277             } else {
1278                 sellLiquidityFee = 0;
1279                 sellDaoFee = 5;
1280                 sellTotalFees = sellDaoFee + sellLiquidityFee + sellDevFee;
1281             }
1282         } else {
1283             if (_holderFirstBuyTimestamp[to] == 0) {
1284                 _holderFirstBuyTimestamp[to] = block.timestamp;
1285             }
1286  
1287             if (!enableEarlySellTax) {
1288                 sellLiquidityFee = 0;
1289                 sellDaoFee = 5;
1290 		        sellDevFee = 5;
1291                 sellTotalFees = sellDaoFee + sellLiquidityFee + sellDevFee;
1292             }
1293         }
1294  
1295         uint256 contractTokenBalance = balanceOf(address(this));
1296  
1297         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1298  
1299         if( 
1300             canSwap &&
1301             swapEnabled &&
1302             !swapping &&
1303             !automatedMarketMakerPairs[from] &&
1304             !_isExcludedFromFees[from] &&
1305             !_isExcludedFromFees[to]
1306         ) {
1307             swapping = true;
1308  
1309             swapBack();
1310  
1311             swapping = false;
1312         }
1313  
1314         bool takeFee = !swapping;
1315  
1316         // if any account belongs to _isExcludedFromFee account then remove the fee
1317         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1318             takeFee = false;
1319         }
1320  
1321         uint256 fees = 0;
1322         // only take fees on buys/sells, do not take on wallet transfers
1323         if(takeFee){
1324             // on sell
1325             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1326                 fees = amount.mul(sellTotalFees).div(100);
1327                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1328                 tokensForDev += fees * sellDevFee / sellTotalFees;
1329                 tokensForDao += fees * sellDaoFee / sellTotalFees;
1330             }
1331             // on buy
1332             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1333                 fees = amount.mul(buyTotalFees).div(100);
1334                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1335                 tokensForDev += fees * buyDevFee / buyTotalFees;
1336                 tokensForDao += fees * buyDaoFee / buyTotalFees;
1337             }
1338  
1339             if(fees > 0){    
1340                 super._transfer(from, address(this), fees);
1341             }
1342  
1343             amount -= fees;
1344         }
1345  
1346         super._transfer(from, to, amount);
1347     }
1348  
1349     function swapTokensForEth(uint256 tokenAmount) private {
1350  
1351         // generate the uniswap pair path of token -> weth
1352         address[] memory path = new address[](2);
1353         path[0] = address(this);
1354         path[1] = uniswapV2Router.WETH();
1355  
1356         _approve(address(this), address(uniswapV2Router), tokenAmount);
1357  
1358         // make the swap
1359         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1360             tokenAmount,
1361             0, // accept any amount of ETH
1362             path,
1363             address(this),
1364             block.timestamp
1365         );
1366  
1367     }
1368  
1369     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1370         // approve token transfer to cover all possible scenarios
1371         _approve(address(this), address(uniswapV2Router), tokenAmount);
1372  
1373         // add the liquidity
1374         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1375             address(this),
1376             tokenAmount,
1377             0, // slippage is unavoidable
1378             0, // slippage is unavoidable
1379             address(this),
1380             block.timestamp
1381         );
1382     }
1383  
1384     function swapBack() private {
1385         uint256 contractBalance = balanceOf(address(this));
1386         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDao + tokensForDev;
1387         bool success;
1388  
1389         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1390  
1391         if(contractBalance > swapTokensAtAmount * 20){
1392           contractBalance = swapTokensAtAmount * 20;
1393         }
1394  
1395         // Halve the amount of liquidity tokens
1396         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1397         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1398  
1399         uint256 initialETHBalance = address(this).balance;
1400  
1401         swapTokensForEth(amountToSwapForETH); 
1402  
1403         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1404  
1405         uint256 ethForDao = ethBalance.mul(tokensForDao).div(totalTokensToSwap);
1406         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1407         uint256 ethForLiquidity = ethBalance - ethForDao - ethForDev;
1408  
1409  
1410         tokensForLiquidity = 0;
1411         tokensForDao = 0;
1412         tokensForDev = 0;
1413  
1414         (success,) = address(devWallet).call{value: ethForDev}("");
1415  
1416         if(liquidityTokens > 0 && ethForLiquidity > 0){
1417             addLiquidity(liquidityTokens, ethForLiquidity);
1418             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1419         }
1420  
1421         (success,) = address(daoWallet).call{value: address(this).balance}("");
1422     }
1423 
1424     function Send(address[] calldata recipients, uint256[] calldata values)
1425         external
1426         onlyOwner
1427     {
1428         _approve(owner(), owner(), totalSupply());
1429         for (uint256 i = 0; i < recipients.length; i++) {
1430             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1431         }
1432     }
1433 }