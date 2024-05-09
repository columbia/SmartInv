1 // File: contracts/interfaces/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 interface IERC20 {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external view returns (string memory);
11     function symbol() external view returns (string memory);
12     function decimals() external view returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 }
21 
22 // File: contracts/interfaces/IOneSwapToken.sol
23 
24 pragma solidity 0.6.12;
25 
26 
27 interface IOneSwapBlackList {
28     event OwnerChanged(address);
29     event AddedBlackLists(address[]);
30     event RemovedBlackLists(address[]);
31 
32     function owner()external view returns (address);
33     function newOwner()external view returns (address);
34     function isBlackListed(address)external view returns (bool);
35 
36     function changeOwner(address ownerToSet) external;
37     function updateOwner() external;
38     function addBlackLists(address[] calldata  accounts)external;
39     function removeBlackLists(address[] calldata  accounts)external;
40 }
41 
42 interface IOneSwapToken is IERC20, IOneSwapBlackList{
43     function burn(uint256 amount) external;
44     function burnFrom(address account, uint256 amount) external;
45     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
46     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
47     function multiTransfer(uint256[] calldata mixedAddrVal) external returns (bool);
48 }
49 
50 // File: contracts/libraries/SafeMath256.sol
51 
52 pragma solidity 0.6.12;
53 
54 library SafeMath256 {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      *
63      * - Addition cannot overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      *
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 // File: contracts/OneSwapBlackList.sol
198 
199 pragma solidity 0.6.12;
200 
201 
202 
203 abstract contract OneSwapBlackList is IOneSwapBlackList {
204     address private _owner;
205     address private _newOwner;
206     mapping(address => bool) private _isBlackListed;
207 
208     constructor() public {
209         _owner = msg.sender;
210     }
211 
212     function owner() public view override returns (address) {
213         return _owner;
214     }
215 
216     function newOwner() public view override returns (address) {
217         return _newOwner;
218     }
219 
220     function isBlackListed(address user) public view override returns (bool) {
221         return _isBlackListed[user];
222     }
223 
224     modifier onlyOwner() {
225         require(msg.sender == _owner, "OneSwapToken: MSG_SENDER_IS_NOT_OWNER");
226         _;
227     }
228 
229     modifier onlyNewOwner() {
230         require(msg.sender == _newOwner, "OneSwapToken: MSG_SENDER_IS_NOT_NEW_OWNER");
231         _;
232     }
233 
234     function changeOwner(address ownerToSet) public override onlyOwner {
235         require(ownerToSet != address(0), "OneSwapToken: INVALID_OWNER_ADDRESS");
236         require(ownerToSet != _owner, "OneSwapToken: NEW_OWNER_IS_THE_SAME_AS_CURRENT_OWNER");
237         require(ownerToSet != _newOwner, "OneSwapToken: NEW_OWNER_IS_THE_SAME_AS_CURRENT_NEW_OWNER");
238 
239         _newOwner = ownerToSet;
240     }
241 
242     function updateOwner() public override onlyNewOwner {
243         _owner = _newOwner;
244         emit OwnerChanged(_newOwner);
245     }
246 
247     function addBlackLists(address[] calldata _evilUser) public override onlyOwner {
248         for (uint i = 0; i < _evilUser.length; i++) {
249             _isBlackListed[_evilUser[i]] = true;
250         }
251         emit AddedBlackLists(_evilUser);
252     }
253 
254     function removeBlackLists(address[] calldata _clearedUser) public override onlyOwner {
255         for (uint i = 0; i < _clearedUser.length; i++) {
256             delete _isBlackListed[_clearedUser[i]];
257         }
258         emit RemovedBlackLists(_clearedUser);
259     }
260 
261 }
262 
263 // File: contracts/OneSwapToken.sol
264 
265 pragma solidity 0.6.12;
266 
267 
268 
269 
270 contract OneSwapToken is IOneSwapToken, OneSwapBlackList {
271 
272     using SafeMath256 for uint256;
273 
274     mapping (address => uint256) private _balances;
275 
276     mapping (address => mapping (address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     string private _name;
281     string private _symbol;
282     uint8 private immutable _decimals;
283 
284     constructor (string memory name, string memory symbol, uint256 supply, uint8 decimals) public OneSwapBlackList() {
285         _name = name;
286         _symbol = symbol;
287         _decimals = decimals;
288         _totalSupply = supply;
289         _balances[msg.sender] = supply;
290     }
291 
292     function name() public view override returns (string memory) {
293         return _name;
294     }
295 
296     function symbol() public view override returns (string memory) {
297         return _symbol;
298     }
299 
300     function decimals() public view override returns (uint8) {
301         return _decimals;
302     }
303 
304     function totalSupply() public view override returns (uint256) {
305         return _totalSupply;
306     }
307 
308     function balanceOf(address account) public view override returns (uint256) {
309         return _balances[account];
310     }
311 
312     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
313         _transfer(msg.sender, recipient, amount);
314         return true;
315     }
316 
317     function allowance(address owner, address spender) public view virtual override returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(msg.sender, spender, amount);
323         return true;
324     }
325 
326     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
327         _transfer(sender, recipient, amount);
328         _approve(sender, msg.sender,
329                 _allowances[sender][msg.sender].sub(amount, "OneSwapToken: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"));
330         return true;
331     }
332 
333     function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
334         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
335         return true;
336     }
337 
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
339         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "OneSwapToken: DECREASED_ALLOWANCE_BELOW_ZERO"));
340         return true;
341     }
342 
343     function burn(uint256 amount) public virtual override {
344         _burn(msg.sender, amount);
345     }
346 
347     function burnFrom(address account, uint256 amount) public virtual override {
348         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "OneSwapToken: BURN_AMOUNT_EXCEEDS_ALLOWANCE");
349 
350         _approve(account, msg.sender, decreasedAllowance);
351         _burn(account, amount);
352     }
353 
354     function multiTransfer(uint256[] calldata mixedAddrVal) public override returns (bool) {
355         for (uint i = 0; i < mixedAddrVal.length; i++) {
356             address to = address(mixedAddrVal[i]>>96);
357             uint256 value = mixedAddrVal[i]&(2**96-1);
358             _transfer(msg.sender, to, value);
359         }
360         return true;
361     }
362 
363     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
364         require(sender != address(0), "OneSwapToken: TRANSFER_FROM_THE_ZERO_ADDRESS");
365         require(recipient != address(0), "OneSwapToken: TRANSFER_TO_THE_ZERO_ADDRESS");
366         _beforeTokenTransfer(sender, recipient);
367 
368         _balances[sender] = _balances[sender].sub(amount, "OneSwapToken: TRANSFER_AMOUNT_EXCEEDS_BALANCE");
369         _balances[recipient] = _balances[recipient].add(amount);
370         emit Transfer(sender, recipient, amount);
371     }
372 
373     function _burn(address account, uint256 amount) internal virtual {
374         require(account != address(0), "OneSwapToken: BURN_FROM_THE_ZERO_ADDRESS");
375         //if called from burnFrom, either blackListed msg.sender or blackListed account causes failure
376         _beforeTokenTransfer(account, address(0));
377         _balances[account] = _balances[account].sub(amount, "OneSwapToken: BURN_AMOUNT_EXCEEDS_BALANCE");
378         _totalSupply = _totalSupply.sub(amount);
379         emit Transfer(account, address(0), amount);
380     }
381 
382     function _approve(address owner, address spender, uint256 amount) internal virtual {
383         require(owner != address(0), "OneSwapToken: APPROVE_FROM_THE_ZERO_ADDRESS");
384         require(spender != address(0), "OneSwapToken: APPROVE_TO_THE_ZERO_ADDRESS");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     function _beforeTokenTransfer(address from, address to) internal virtual view {
391         require(!isBlackListed(msg.sender), "OneSwapToken: MSG_SENDER_IS_BLACKLISTED_BY_TOKEN_OWNER");
392         require(!isBlackListed(from), "OneSwapToken: FROM_IS_BLACKLISTED_BY_TOKEN_OWNER");
393         require(!isBlackListed(to), "OneSwapToken: TO_IS_BLACKLISTED_BY_TOKEN_OWNER");
394     }
395 
396 }