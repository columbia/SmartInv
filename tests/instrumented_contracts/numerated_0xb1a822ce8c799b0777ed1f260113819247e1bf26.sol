1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6 
7 I’m going to F T X your life up.
8 
9 Telegram: https://t.me/HairyPlotterFTXPortal
10 Website:  https://www.hairyplotterftx.com/
11 Twitter:  https://x.com/HairyPlotterFTX           
12 
13 ███████╗████████╗██╗  ██╗
14 ██╔════╝╚══██╔══╝╚██╗██╔╝
15 █████╗     ██║    ╚███╔╝ 
16 ██╔══╝     ██║    ██╔██╗ 
17 ██║        ██║   ██╔╝ ██╗
18 ╚═╝        ╚═╝   ╚═╝  ╚═╝
19 
20 **/
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/access/Ownable.sol
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 interface IERC20 {
110     function totalSupply() external view returns (uint256);
111     function decimals() external view returns (uint8);
112     function symbol() external view returns (string memory);
113     function name() external view returns (string memory);
114     function balanceOf(address account) external view returns (uint256);
115     function transfer(address recipient, uint256 amount) external returns (bool);
116     function allowance(address _owner, address spender) external view returns (uint256);
117     function approve(address spender, uint256 amount) external returns (bool);
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119     event Transfer(address indexed from, address indexed to, uint256 value);
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract FTX is IERC20, Ownable {
124 
125     mapping (address => uint256) private _balances;
126 
127     mapping (address => mapping (address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130     uint256 private _maxAddressAmt;
131 
132     string private _name;
133     string private _symbol;
134     uint8 private _decimals;
135 
136     mapping (address => bool) private _maxAddressAmtExcluded;
137 
138     constructor() {
139 
140         _name = "HairyPlotterFTX";
141         _symbol = "FTX";
142 
143         _decimals = 18;
144         _totalSupply = 10000000000e18;
145 
146         _maxAddressAmt = (_totalSupply*2)/100;
147 
148         setMaxAddressAmtExcluded(_msgSender(), true);
149         setMaxAddressAmtExcluded(address(0xF93e5983D5A60a09fcdb8C2c4c4174da55d5D777), true);
150 
151         _balances[_msgSender()] = _totalSupply;
152         emit Transfer(address(0), _msgSender(), _totalSupply);
153     }
154 
155     function setMaxAddressAmtExcluded(address a, bool excluded) public onlyOwner {
156         require(a != address(0), "Address must not be zero address");
157         _maxAddressAmtExcluded[a] = excluded;
158     }
159 
160     function removeMaxAddressAmt() public onlyOwner{
161         _maxAddressAmt = _totalSupply;
162     }
163 
164     function burn(uint256 amount) external {
165         _burn(_msgSender(), amount);
166     }
167 
168     /**
169      * @dev Destroys `amount` tokens from `account`, reducing the
170      * total supply.
171      *
172      * Emits a {Transfer} event with `to` set to the zero address.
173      *
174      * Requirements:
175      *
176      * - `account` cannot be the zero address.
177      * - `account` must have at least `amount` tokens.
178      */
179     function _burn(address account, uint256 amount) internal virtual {
180         require(account != address(0), "ERC20: burn from the zero address");
181 
182         _beforeTokenTransfer(account, address(0), amount);
183 
184         uint256 accountBalance = _balances[account];
185         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
186         unchecked {
187             _balances[account] = accountBalance - amount;
188             // Overflow not possible: amount <= accountBalance <= totalSupply.
189             _totalSupply -= amount;
190         }
191 
192         emit Transfer(account, address(0), amount);
193 
194         _afterTokenTransfer(account, address(0), amount);
195     }
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
199      *
200      * This internal function is equivalent to `approve`, and can be used to
201      * e.g. set automatic allowances for certain subsystems, etc.
202      *
203      * Emits an {Approval} event.
204      *
205      * Requirements:
206      *
207      * - `owner` cannot be the zero address.
208      * - `spender` cannot be the zero address.
209      */
210     function _approve(address owner, address spender, uint256 amount) internal virtual {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213 
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _beforeTokenTransfer(address sender, address recipient, uint256 amount) internal virtual {}
219 
220     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {
221         if (!_maxAddressAmtExcluded[to]) {
222             require(balanceOf(to) <= _maxAddressAmt, "Cannot exceed max amount per address");
223         }
224     }
225 	
226     /**
227      * @dev Moves `amount` of tokens from `from` to `to`.
228      *
229      * This internal function is equivalent to {transfer}, and can be used to
230      * e.g. implement automatic token fees, slashing mechanisms, etc.
231      *
232      * Emits a {Transfer} event.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `from` must have a balance of at least `amount`.
239      */
240     function _transfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {
245         require(from != address(0), "ERC20: transfer from the zero address");
246         require(to != address(0), "ERC20: transfer to the zero address");
247 
248         _beforeTokenTransfer(from, to, amount);
249 
250         uint256 fromBalance = _balances[from];
251         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
252         unchecked {
253             _balances[from] = fromBalance - amount;
254             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
255             // decrementing then incrementing.
256             _balances[to] += amount;
257         }
258 
259         emit Transfer(from, to, amount);
260 
261         _afterTokenTransfer(from, to, amount);
262     }
263 
264     function name() public view override returns (string memory) {
265         return _name;
266     }
267 
268     function symbol() public view override returns (string memory) {
269         return _symbol;
270     }
271 
272     function decimals() public view override returns (uint8) {
273         return _decimals;
274     }
275 
276     function totalSupply() public view override returns (uint256) {
277         return _totalSupply;
278     }
279 
280     function balanceOf(address account) public view override returns (uint256) {
281         return _balances[account];
282     }
283 
284     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
285         _transfer(_msgSender(), recipient, amount);
286         return true;
287     }
288 
289     function allowance(address owner, address spender) public view virtual override returns (uint256) {
290         return _allowances[owner][spender];
291     }
292 
293     function approve(address spender, uint256 amount) public virtual override returns (bool) {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297 
298     /**
299      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
300      *
301      * Does not update the allowance amount in case of infinite allowance.
302      * Revert if not enough allowance is available.
303      *
304      * Might emit an {Approval} event.
305      */
306     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
307         uint256 currentAllowance = allowance(owner, spender);
308         if (currentAllowance != type(uint256).max) {
309             require(currentAllowance >= amount, "ERC20: insufficient allowance");
310             unchecked {
311                 _approve(owner, spender, currentAllowance - amount);
312             }
313         }
314     }
315     
316 /**
317      * @dev See {IERC20-transferFrom}.
318      *
319      * Emits an {Approval} event indicating the updated allowance. This is not
320      * required by the EIP. See the note at the beginning of {ERC20}.
321      *
322      * NOTE: Does not update the allowance if the current allowance
323      * is the maximum `uint256`.
324      *
325      * Requirements:
326      *
327      * - `from` and `to` cannot be the zero address.
328      * - `from` must have a balance of at least `amount`.
329      * - the caller must have allowance for ``from``'s tokens of at least
330      * `amount`.
331      */
332     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
333         address spender = _msgSender();
334         _spendAllowance(from, spender, amount);
335         _transfer(from, to, amount);
336         return true;
337     }
338 
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
352         address owner = _msgSender();
353         _approve(owner, spender, allowance(owner, spender) + addedValue);
354         return true;
355     }
356 
357     /**
358      * @dev Atomically decreases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      * - `spender` must have allowance for the caller of at least
369      * `subtractedValue`.
370      */
371     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
372         address owner = _msgSender();
373         uint256 currentAllowance = allowance(owner, spender);
374         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
375         unchecked {
376             _approve(owner, spender, currentAllowance - subtractedValue);
377         }
378 
379         return true;
380     }
381 
382 }