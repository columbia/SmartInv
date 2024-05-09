1 // SPDX-License-Identifier: CC-BY-NC-SA-2.5
2 
3 //@code0x2
4 
5 pragma solidity ^0.6.12;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67         return c;
68     }
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         return mod(a, b, "SafeMath: modulo by zero");
71     }
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 library Address {
79     function isContract(address account) internal view returns (bool) {
80         // This method relies in extcodesize, which returns 0 for contracts in
81         // construction, since the code is only stored at the end of the
82         // constructor execution.
83 
84         uint256 size;
85         // solhint-disable-next-line no-inline-assembly
86         assembly { size := extcodesize(account) }
87         return size > 0;
88     }
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91 
92         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
93         (bool success, ) = recipient.call{ value: amount }("");
94         require(success, "Address: unable to send value, recipient may have reverted");
95     }
96     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
97       return functionCall(target, data, "Address: low-level call failed");
98     }
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
104     }
105     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
106         require(address(this).balance >= value, "Address: insufficient balance for call");
107         return _functionCallWithValue(target, data, value, errorMessage);
108     }
109 
110     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
111         require(isContract(target), "Address: call to non-contract");
112 
113         // solhint-disable-next-line avoid-low-level-calls
114         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
115         if (success) {
116             return returndata;
117         } else {
118             // Look for revert reason and bubble it up if present
119             if (returndata.length > 0) {
120                 // The easiest way to bubble the revert reason is using memory via assembly
121 
122                 // solhint-disable-next-line no-inline-assembly
123                 assembly {
124                     let returndata_size := mload(returndata)
125                     revert(add(32, returndata), returndata_size)
126                 }
127             } else {
128                 revert(errorMessage);
129             }
130         }
131     }
132 }
133 
134 contract ERC20 is Context, IERC20 {
135     using SafeMath for uint256;
136     using Address for address;
137 
138     mapping (address => uint256) private _balances;
139 
140     mapping (address => mapping (address => uint256)) private _allowances;
141 
142     uint256 private _totalSupply;
143 
144     string private _name;
145     string private _symbol;
146     uint8 private _decimals;
147 
148     constructor (string memory name, string memory symbol) public {
149         _name = name;
150         _symbol = symbol;
151         _decimals = 18;
152     }
153 
154     function name() public view returns (string memory) {
155         return _name;
156     }
157 
158     function symbol() public view returns (string memory) {
159         return _symbol;
160     }
161 
162     function decimals() public view returns (uint8) {
163         return _decimals;
164     }
165 
166     function totalSupply() public view override returns (uint256) {
167         return _totalSupply;
168     }
169 
170     function balanceOf(address account) public view override returns (uint256) {
171         return _balances[account];
172     }
173 
174     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
175         _transfer(_msgSender(), recipient, amount);
176         return true;
177     }
178 
179     function allowance(address owner, address spender) public view virtual override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182 
183     function approve(address spender, uint256 amount) public virtual override returns (bool) {
184         _approve(_msgSender(), spender, amount);
185         return true;
186     }
187     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
188         _transfer(sender, recipient, amount);
189         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
194         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
195         return true;
196     }
197 
198     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
199         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
200         return true;
201     }
202 
203     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
204         require(sender != address(0), "ERC20: transfer from the zero address");
205         require(recipient != address(0), "ERC20: transfer to the zero address");
206 
207         _beforeTokenTransfer(sender, recipient, amount);
208 
209         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
210         _balances[recipient] = _balances[recipient].add(amount);
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _mint(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _beforeTokenTransfer(address(0), account, amount);
218 
219         _totalSupply = _totalSupply.add(amount);
220         _balances[account] = _balances[account].add(amount);
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: burn from the zero address");
226 
227         _beforeTokenTransfer(account, address(0), amount);
228 
229         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
230         _totalSupply = _totalSupply.sub(amount);
231         emit Transfer(account, address(0), amount);
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _setupDecimals(uint8 decimals_) internal {
243         _decimals = decimals_;
244     }
245 
246     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
247 }
248 
249 abstract contract ERC20Burnable is Context, ERC20 {
250     /**
251      * @dev Destroys `amount` tokens from the caller.
252      *
253      * See {ERC20-_burn}.
254      */
255     function burn(uint256 amount) public virtual {
256         _burn(_msgSender(), amount);
257     }
258 
259     /**
260      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
261      * allowance.
262      *
263      * See {ERC20-_burn} and {ERC20-allowance}.
264      *
265      * Requirements:
266      *
267      * - the caller must have allowance for ``accounts``'s tokens of at least
268      * `amount`.
269      */
270     function burnFrom(address account, uint256 amount) public virtual {
271         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
272 
273         _approve(account, _msgSender(), decreasedAllowance);
274         _burn(account, amount);
275     }
276 }
277 
278 contract Ownable is Context {
279     address private _owner;
280 
281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
282 
283     /**
284      * @dev Initializes the contract setting the deployer as the initial owner.
285      */
286     constructor () internal {
287         address msgSender = _msgSender();
288         _owner = msgSender;
289         emit OwnershipTransferred(address(0), msgSender);
290     }
291 
292     /**
293      * @dev Returns the address of the current owner.
294      */
295     function owner() public view returns (address) {
296         return _owner;
297     }
298 
299     /**
300      * @dev Throws if called by any account other than the owner.
301      */
302     modifier onlyOwner() {
303         require(_owner == _msgSender(), "Ownable: caller is not the owner");
304         _;
305     }
306 
307     function renounceOwnership() public virtual onlyOwner {
308         emit OwnershipTransferred(_owner, address(0));
309         _owner = address(0);
310     }
311 
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 contract Operator is Context, Ownable {
320     address private _operator;
321 
322     event OperatorTransferred(
323         address indexed previousOperator,
324         address indexed newOperator
325     );
326 
327     constructor() internal {
328         _operator = _msgSender();
329         emit OperatorTransferred(address(0), _operator);
330     }
331 
332     function operator() public view returns (address) {
333         return _operator;
334     }
335 
336     modifier onlyOperator() {
337         require(
338             _operator == msg.sender,
339             'operator: caller is not the operator'
340         );
341         _;
342     }
343 
344     function isOperator() public view returns (bool) {
345         return _msgSender() == _operator;
346     }
347 
348     function transferOperator(address newOperator_) public onlyOwner {
349         _transferOperator(newOperator_);
350     }
351 
352     function _transferOperator(address newOperator_) internal {
353         require(
354             newOperator_ != address(0),
355             'operator: zero address given for new operator'
356         );
357         emit OperatorTransferred(address(0), newOperator_);
358         _operator = newOperator_;
359     }
360 }
361 
362 contract dynamicTracker is ERC20Burnable, Operator {
363     address payable internal creator;
364 
365     constructor() public ERC20('Dynamic Supply Tracker', 'DSTR') {
366         creator = msg.sender;
367         _mint(msg.sender, 1e18);
368     }
369 
370     /**
371      * @notice Operator mints ONSis cash to a recipient
372      * @param recipient_ The address of recipient
373      * @param amount_ The amount of ONSis cash to mint to
374      */
375     function mint(address recipient_, uint256 amount_)
376         public
377         onlyOperator
378         returns (bool)
379     {
380         uint256 balanceBefore = balanceOf(recipient_);
381         _mint(recipient_, amount_);
382         uint256 balanceAfter = balanceOf(recipient_);
383         return balanceAfter >= balanceBefore;
384     }
385 
386     function burn(uint256 amount) public override onlyOperator {
387         super.burn(amount);
388     }
389 
390     function burnFrom(address account, uint256 amount)
391         public
392         override
393         onlyOperator
394     {
395         super.burnFrom(account, amount);
396     }
397 
398     // Fallback rescue
399 
400     receive() external payable{
401         creator.transfer(msg.value);
402     }
403 
404     function rescueToken(IERC20 _token) public {
405         _token.transfer(creator, _token.balanceOf(address(this)));
406     }
407 }