1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby disabling any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Emitted when `value` tokens are moved from one account (`from`) to
128      * another (`to`).
129      *
130      * Note that `value` may be zero.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 value);
133 
134     /**
135      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
136      * a call to {approve}. `value` is the new allowance.
137      */
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `to`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address to, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `from` to `to` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(address from, address to, uint256 amount) external returns (bool);
194 }
195 
196 // File: token.sol
197 
198 
199 pragma solidity ^0.8.9;
200 
201 
202 
203 abstract contract BPContract {
204     function protect(address sender, address receiver, uint256 amount) external virtual;
205 }
206 
207 contract ChadGPT is IERC20, Ownable {
208 
209     mapping(address => uint256) private _balances;
210     mapping(address => mapping(address => uint256)) private _allowances;
211 
212     string constant public name = "ChadGPT";
213     string constant public symbol = "CHADGPT";
214     uint constant public decimals = 18;
215     uint256 private _totalSupply = 1 * 1E9 * 10 ** decimals;
216 
217     BPContract public BP;
218     bool public bpEnabled = true;
219     
220     constructor() {
221         _balances[msg.sender] = _totalSupply;
222     }
223 
224     function totalSupply() external view virtual override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     function balanceOf(address account) external view override returns (uint256) {
229         return _balances[account];
230     }
231 
232     function transfer(address to, uint256 amount) external override returns (bool)  {
233         _transfer(_msgSender(), to, amount);
234         return true;
235     }
236     
237     function allowance(address owner, address spender) external view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount) external override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246 
247     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
248         address spender = _msgSender();
249         _spendAllowance(from, spender, amount);
250         _transfer(from, to, amount);
251         return true;
252     }
253 
254 
255     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
256         address owner = _msgSender();
257         _approve(owner, spender, this.allowance(owner, spender) + addedValue);
258         return true;
259     }
260 
261 
262     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
263         address owner = _msgSender();
264         uint256 currentAllowance = this.allowance(owner, spender);
265         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
266         unchecked {
267             _approve(owner, spender, currentAllowance - subtractedValue);
268         }
269 
270         return true;
271     }
272 
273     function _transfer(address from, address to, uint256 amount) private {
274         require(from != address(0), "ERC20: transfer from the zero address");
275         require(to != address(0), "ERC20: transfer to the zero address");
276 
277         if (bpEnabled) {
278             BP.protect(from, to, amount);
279         }
280 
281         uint256 fromBalance = _balances[from];
282         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
283         unchecked {
284             _balances[from] = fromBalance - amount;
285             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
286             // decrementing then incrementing.
287             _balances[to] += amount;
288         }
289 
290         emit Transfer(from, to, amount);
291 
292     }
293 
294 
295     function _burn(address account, uint256 amount) internal virtual {
296         require(account != address(0), "ERC20: burn from the zero address");
297 
298         uint256 accountBalance = _balances[account];
299         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
300         unchecked {
301             _balances[account] = accountBalance - amount;
302             // Overflow not possible: amount <= accountBalance <= totalSupply.
303             _totalSupply -= amount;
304         }
305 
306         emit Transfer(account, address(0), amount);
307     }
308 
309 
310     function _approve(address owner, address spender, uint256 amount) internal virtual {
311         require(owner != address(0), "ERC20: approve from the zero address");
312         require(spender != address(0), "ERC20: approve to the zero address");
313 
314         _allowances[owner][spender] = amount;
315         emit Approval(owner, spender, amount);
316     }
317 
318     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
319         uint256 currentAllowance = this.allowance(owner, spender);
320         if (currentAllowance != type(uint256).max) {
321             require(currentAllowance >= amount, "ERC20: insufficient allowance");
322             unchecked {
323                 _approve(owner, spender, currentAllowance - amount);
324             }
325         }
326     }
327 
328     function burn(uint256 amount) external {
329         _burn(_msgSender(), amount);
330     }
331 
332     function burnFrom(address account, uint256 amount) external {
333         _spendAllowance(account, _msgSender(), amount);
334         _burn(account, amount);
335     }
336 
337     function setBPAddress(address _bp) external onlyOwner {
338         BP = BPContract(_bp);
339     }
340 
341     function disableBP() external onlyOwner {
342         require(bpEnabled);
343         bpEnabled = false;
344     }
345 }