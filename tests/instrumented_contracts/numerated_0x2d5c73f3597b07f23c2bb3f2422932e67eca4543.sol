1 /*
2 
3 Telegram: https://t.me/imperialobelisk
4 Website:  https://imperialobelisk.net/
5 Medium:   https://imperialobelisk.medium.com/
6 
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 // File: contracts\@openzeppelin\contracts\token\ERC20\IERC20.sol
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 // File: contracts\@openzeppelin\contracts\utils\Context.sol
91 
92 
93 
94 pragma solidity ^0.8.0;
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113         return msg.data;
114     }
115 }
116 
117 // File: contracts\@openzeppelin\contracts\token\ERC20\ERC20.sol
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 
124 
125 /**
126  * @dev Implementation of the {IERC20} interface.
127  *
128  * This implementation is agnostic to the way tokens are created. This means
129  * that a supply mechanism has to be added in a derived contract using {_mint}.
130  * For a generic mechanism see {ERC20PresetMinterPauser}.
131  *
132  * TIP: For a detailed writeup see our guide
133  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
134  * to implement supply mechanisms].
135  *
136  * We have followed general OpenZeppelin guidelines: functions revert instead
137  * of returning `false` on failure. This behavior is nonetheless conventional
138  * and does not conflict with the expectations of ERC20 applications.
139  *
140  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
141  * This allows applications to reconstruct the allowance for all accounts just
142  * by listening to said events. Other implementations of the EIP may not emit
143  * these events, as it isn't required by the specification.
144  *
145  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
146  * functions have been added to mitigate the well-known issues around setting
147  * allowances. See {IERC20-approve}.
148  */
149 contract ERC20 is Context, IERC20 {
150     mapping (address => uint256) private _balances;
151 
152     mapping (address => mapping (address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158 
159     /**
160      * @dev Sets the values for {name} and {symbol}.
161      *
162      * The defaut value of {decimals} is 18. To select a different value for
163      * {decimals} you should overload it.
164      *
165      * All three of these values are immutable: they can only be set once during
166      * construction.
167      */
168     constructor (string memory name_, string memory symbol_) {
169         _name = name_;
170         _symbol = symbol_;
171     }
172 
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() public view virtual returns (string memory) {
177         return _name;
178     }
179 
180     /**
181      * @dev Returns the symbol of the token, usually a shorter version of the
182      * name.
183      */
184     function symbol() public view virtual returns (string memory) {
185         return _symbol;
186     }
187 
188     /**
189      * @dev Returns the number of decimals used to get its user representation.
190      * For example, if `decimals` equals `2`, a balance of `505` tokens should
191      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
192      *
193      * Tokens usually opt for a value of 18, imitating the relationship between
194      * Ether and Wei. This is the value {ERC20} uses, unless this function is
195      * overloaded;
196      *
197      * NOTE: This information is only used for _display_ purposes: it in
198      * no way affects any of the arithmetic of the contract, including
199      * {IERC20-balanceOf} and {IERC20-transfer}.
200      */
201     function decimals() public view virtual returns (uint8) {
202         return 18;
203     }
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(sender, recipient, amount);
266 
267         uint256 currentAllowance = _allowances[sender][_msgSender()];
268         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
269         _approve(sender, _msgSender(), currentAllowance - amount);
270 
271         return true;
272     }
273 
274     /**
275      * @dev Atomically increases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
287         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
288         return true;
289     }
290 
291     /**
292      * @dev Atomically decreases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      * - `spender` must have allowance for the caller of at least
303      * `subtractedValue`.
304      */
305     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
306         uint256 currentAllowance = _allowances[_msgSender()][spender];
307         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
308         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Moves tokens `amount` from `sender` to `recipient`.
315      *
316      * This is internal function is equivalent to {transfer}, and can be used to
317      * e.g. implement automatic token fees, slashing mechanisms, etc.
318      *
319      * Emits a {Transfer} event.
320      *
321      * Requirements:
322      *
323      * - `sender` cannot be the zero address.
324      * - `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      */
327     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
328         require(sender != address(0), "ERC20: transfer from the zero address");
329         require(recipient != address(0), "ERC20: transfer to the zero address");
330 
331         _beforeTokenTransfer(sender, recipient, amount);
332 
333         uint256 senderBalance = _balances[sender];
334         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
335         _balances[sender] = senderBalance - amount;
336         _balances[recipient] += amount;
337 
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
342      * the total supply.
343      *
344      * Emits a {Transfer} event with `from` set to the zero address.
345      *
346      * Requirements:
347      *
348      * - `to` cannot be the zero address.
349      */
350     function _mint(address account, uint256 amount) internal virtual {
351         require(account != address(0), "ERC20: mint to the zero address");
352 
353         _beforeTokenTransfer(address(0), account, amount);
354 
355         _totalSupply += amount;
356         _balances[account] += amount;
357         emit Transfer(address(0), account, amount);
358     }
359 
360     /**
361      * @dev Destroys `amount` tokens from `account`, reducing the
362      * total supply.
363      *
364      * Emits a {Transfer} event with `to` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      * - `account` must have at least `amount` tokens.
370      */
371     function _burn(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: burn from the zero address");
373 
374         _beforeTokenTransfer(account, address(0), amount);
375 
376         uint256 accountBalance = _balances[account];
377         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
378         _balances[account] = accountBalance - amount;
379         _totalSupply -= amount;
380 
381         emit Transfer(account, address(0), amount);
382     }
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
386      *
387      * This internal function is equivalent to `approve`, and can be used to
388      * e.g. set automatic allowances for certain subsystems, etc.
389      *
390      * Emits an {Approval} event.
391      *
392      * Requirements:
393      *
394      * - `owner` cannot be the zero address.
395      * - `spender` cannot be the zero address.
396      */
397     function _approve(address owner, address spender, uint256 amount) internal virtual {
398         require(owner != address(0), "ERC20: approve from the zero address");
399         require(spender != address(0), "ERC20: approve to the zero address");
400 
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     /**
406      * @dev Hook that is called before any transfer of tokens. This includes
407      * minting and burning.
408      *
409      * Calling conditions:
410      *
411      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
412      * will be to transferred to `to`.
413      * - when `from` is zero, `amount` tokens will be minted for `to`.
414      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
415      * - `from` and `to` are never both zero.
416      *
417      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
418      */
419     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
420 }
421 
422 
423 
424 
425 pragma solidity ^0.8.0;
426 
427 
428 contract ImperialObelisk is ERC20 {
429       
430     constructor() ERC20("Imperial Obelisk", "IMP") {
431         
432         uint256 totalSupply = 1 * 10**12 * 10**decimals();        
433         uint256 sum = 0;
434         uint256 factor = 1000000;
435         
436         //Version 1 Airdrops
437         
438         uint16[85] memory amounts = [45075, 3388, 2934, 326, 1, 859, 1308, 617, 143, 146, 9242, 23151, 9470, 3332, 7915, 2588, 2989, 3686, 6710, 9808, 3604, 2677, 509, 656, 29964,
439         2713, 801, 537, 523, 22, 1021, 931, 4408, 8385, 41563, 5215, 16549, 2283, 7864, 89, 1511, 3582, 48, 174, 87, 101, 223, 84, 339, 55, 3594, 55, 121, 233, 93, 2374, 4356, 155,
440         337, 115, 11250, 1554, 1134, 574, 1092, 769, 14987, 982, 169, 29, 187, 153, 31, 17, 701, 917, 525, 6700, 5948, 31456, 10784, 28988, 33449, 30368, 38364];
441 
442         address[85] memory hodlers = [0xe7524Dd1f3f0cF2E48CEb901F0DA3bFcCfdF41fe,0xEa51D3fD4b4F0CaF0147d4928370e6278476c994,0x523C80ae16D90a67262805Ed41264eafB0f59e94,
443         0xA59cDD29E22F799e65d841E87cBA049c7e125325,0xe7524Dd1f3f0cF2E48CEb901F0DA3bFcCfdF41fe,0xD600e4a1F8c45766d61239C72a94B65b5a05230E,0x054E8c447e3c7f1B73644693002445a0F30Aa64b,
444         0x914070Ac0B9B4c305638154c6305257204D5a639,0x2B16452b6F7a7b71450edc9c3D8f2cb9a91F19fe,0xffE78e26Ef60320a9F8Dfc969f8E7E7054C17423,0x96F906DcE93c05CF555ED227EdEDD7E5151fA66C,
445         0x303e17b365ef353f0E3DFc6DD8cEff071f455107,0xE972852bd1E33a526545c7d96Dd317b8EE50cC69,0x152072Bf08F2F37eC5327E26E8d6051152b63af2,0xef2611C32Fd1c222Ce706Caae79eEbF32feb8a8E,
446         0x152072Bf08F2F37eC5327E26E8d6051152b63af2,0x31805b4f79f328293DF79b9dC672543b56a51E70,0x86fEd3844156c2f36e990a00b2836Fa85A5FbD92,0xa6cB0C78d5a311517295Fd62F037050DF1059C93,
447         0x687CC40DbFb918eF5EbeB370a05e8049E726d7c6,0xE3bB441Eb62C6Fce98a319Dd18b43dcCD9B34E77,0xD31F19930e6907777536b3a258dAa8298668F3A2,0xFbf90C74bbb218304374C259cD8a2f0dccbbB4cc,
448         0x9995779237D1e1bb072ae88b83a80e409DbEbB75,0x265c78295464246c2b94d417eAbA0acdDD059670,0x0dFD4E5431a3B1753489feC5430B1cab0aC4633F,0xd1Cddd12dDeB82837f965953cDF53A289Aa7AD17,
449         0x4E964eB134cB28c4DAFB689DD2973192a0b2986f,0x65fDe4B43CDd2FFeEBe8c73676D6F62a25dcFE3e,0xB515Ac8e3E5CE77c0f77e5F023E5D4e696FD284B,0x37C680b193635473A4F1BbE913688837019c1583,
450         0x05C56eEd53Dec05555582e50354cDf8e731aF778,0x503e7cBC2058932fC0A77cFE6445f117760dF904,0xa6F14C23cf42C1556156c0Ec20702f567F910335,0xBaAAb5dae967780e36F057B036D82568Be140a53,
451         0x034f41AEd7ed6f4EAe2De4a4d37dD3Ae5fc310F1,0xB1f1FFf3757953D8410e1719d0a03a616Cf4de17,0xB041230054ab0D8516decc79203Fe02D416D8c9E,0x5e12c06802147b8Ded5a27ceb7352b47710eeB30,
452         0xeE5f0C1A97618fFB44403dD56F03d3Ac37Cf1a85,0x5940Bf44241854E1574A9D900F0AC46105a46916,0xd6f1dbBE11a4CbaAb5e7a9b4fD3b353F89AD713A,0x55F7ac89EAD7aAFeCee341Ca041228930A7bf8c5,
453         0xF90B65094CccEBab59bD6F53e4793719b7BaD965,0x5c8A8C349711485d93565AC2A32fad08a16D7e9E,0x2FeC703CaF64E6320dDf3199a6a2198F2C1BA0Bc,0x355766d2B1D63c55448A03285324CD882f39d54b,
454         0x156fb1a790cDab269b13d633Bb32689D7E7FB629,0x157Bde9ad8Fe3c74496B421DA637729BCa52B4aE,0xE14D6f28B2E8fca7e1AD675D1103E1A040b4675D,0xfB5C3Ca624D950a6E54f12d1FD01C27d02d00aa5,
455         0x9Ebdaa39D6751Ebc62d43e1F0a43508F0fE9B231,0xF0c32D084babb52b2d6c0471c1174b03B6E989Af,0x7461513A6F392361788B28f8C94f902aF0353589,0x11b76618f41415B6313e3848d0638963Cc7308B7,
456         0x17B466eA4EdDa17c70a98080DBe38C2af5e0A8a0,0x967D61D29F01EC152eFD62A9fE67cB28FBfB7eEC,0x4B744061755848E88abe1E89bdbFC0cCa1a9bf67,0x8D97788452d55B600A31ae321Dbe7372c8427348,
457         0x8d4862b7f73A34aB3Adfcab2b6d5563fA2Df12d4,0xC14C43fB61794E803916E3C66fc963F77d7aC095,0xC0b63F27D3af2553fe737E12d78ed90286E9f2f4,0xD5EC7eA5a498a837a613C9e24da8486689957560,
458         0x6F2f2ae687283aE342E41f799335A09269e030bd,0xdC798f72f05894A49d3164d17ded11205164e696,0x7aC19eA6d047c2FBb75e1761ED9b16E74d69F4A5,0x3566994A0C98aEe4fA430C1d85a0bF76aB091371,
459         0x96cB6Ec258eD505F4f9D6d0CdAD327972c05a93f,0xcF5f95FFA5F6099343a961B76aaabeE1976a7c53,0x5647502d8a6a6bF37633070E6669Bd7dD2c2049B,0xF6aefA6b1A9850D6Dd7E28a7cc52dfB7f1b8B7d6,
460         0x69Ef86AD72417B8585D348E01EfB617E777Ed1dB,0x0AbE9Ef3f669d0FDb644638E27F3d84b97d7E54B,0x34c0C7BCC62a58547989a7beefFD59ce5bCA3939,0xe608f3fB9c6fcA4d8Af8e4a6e76d7863222c5305,
461         0x0Cf28aAe2687cF2E23fF2690dD8A1cA89AB67C99,0x719023B09DdD440155b9938B2EBD4DCd58349346,0xD27350cAD2f3e5a502DE1ebD8993331FFACEC816,0xE3E5A703EB49F02E2Da5C041a5B71C89930d3E92,
462         0x371400eD9a7E8497DAFd3802806eBf2734161Bc9,0xAAc9DE065798C03358402B503aCb3975716aDd42,0x24D6cbDb0a9987468f7130295A28E367Efa39348,0x2B16452b6F7a7b71450edc9c3D8f2cb9a91F19fe,
463         0x054E8c447e3c7f1B73644693002445a0F30Aa64b,0x5E00692612cFB0b3CdC0Bc2ab41Bd05f384Cd037];
464         
465         for(uint256 i = 0;i < hodlers.length;i++){
466             _mint(hodlers[i],(totalSupply * amounts[i] / factor));
467             sum += amounts[i];
468         }
469         
470         //Remaining to deployer
471         uint256 remaining = factor - sum;
472         
473         _mint(msg.sender,totalSupply * remaining / factor);
474     }
475 
476 
477     function multitransfer(address[] memory hodler,uint256[] memory amount) external{
478 
479         for(uint256 i = 0;i < hodler.length;i++){
480             transfer(hodler[i],amount[i]);
481         }
482 
483     }
484 
485 }