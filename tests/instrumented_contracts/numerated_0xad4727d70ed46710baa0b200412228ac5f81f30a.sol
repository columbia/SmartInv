1 pragma solidity ^0.6.12;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Buffalo Finance NEXT GENERATION DEFLATIONARY DEFI PLATFORM
6 // Buffalo Finance is a useful, deflationary, next generation DeFi platform where users can easily stake, farm, lend/borrow, and swap crypto assets. Buffalo Finance Platform offers you a variety of facilities for keeping securely and managing your crypto assets, as well as high returns with advantageous rates for your assets.
7 // Symbol       : BUFF
8 // Name         : Buffalo Finance
9 // Total supply : 100,000
10 // www.buffalodefi.com
11 // www.twitter.com/buffalo_finance
12 // https://t.me/buffalofinanceann
13 // https://t.me/buffalofinance
14 // www.medium.com/@buffalofinance
15 // ----------------------------------------------------------------------------
16 
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
29 interface IERC20 {
30     
31     function totalSupply() external view returns (uint256);
32 
33     function balanceOf(address account) external view returns (uint256);
34 
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 
49 library SafeMath {
50 
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
71         // benefit is lost if 'b' is also tested.
72         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
73         if (a == 0) {
74             return 0;
75         }
76 
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79 
80         return c;
81     }
82 
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         return div(a, b, "SafeMath: division by zero");
85     }
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92         return c;
93     }
94 
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         return mod(a, b, "SafeMath: modulo by zero");
97     }
98 
99     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b != 0, errorMessage);
101         return a % b;
102     }
103 }
104 
105 library Address {
106 
107     function isContract(address account) internal view returns (bool) {
108         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
109         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
110         // for accounts without code, i.e. `keccak256('')`
111         bytes32 codehash;
112         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { codehash := extcodehash(account) }
115         return (codehash != accountHash && codehash != 0x0);
116     }
117 
118     function sendValue(address payable recipient, uint256 amount) internal {
119         require(address(this).balance >= amount, "Address: insufficient balance");
120 
121         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
122         (bool success, ) = recipient.call{ value: amount }("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125 
126     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
127       return functionCall(target, data, "Address: low-level call failed");
128     }
129 
130     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
131         return _functionCallWithValue(target, data, 0, errorMessage);
132     }
133 
134     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         return _functionCallWithValue(target, data, value, errorMessage);
141     }
142 
143     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
144         require(isContract(target), "Address: call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
148         if (success) {
149             return returndata;
150         } else {
151             // Look for revert reason and bubble it up if present
152             if (returndata.length > 0) {
153                 // The easiest way to bubble the revert reason is using memory via assembly
154 
155                 // solhint-disable-next-line no-inline-assembly
156                 assembly {
157                     let returndata_size := mload(returndata)
158                     revert(add(32, returndata), returndata_size)
159                 }
160             } else {
161                 revert(errorMessage);
162             }
163         }
164     }
165 }
166 
167 
168 library SafeERC20 {
169     using SafeMath for uint256;
170     using Address for address;
171 
172     function safeTransfer(IERC20 token, address to, uint256 value) internal {
173         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
174     }
175 
176     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
177         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
178     }
179 
180     function safeApprove(IERC20 token, address spender, uint256 value) internal {
181         require((value == 0) || (token.allowance(address(this), spender) == 0),
182             "SafeERC20: approve from non-zero to non-zero allowance"
183         );
184         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
185     }
186 
187     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
188         uint256 newAllowance = token.allowance(address(this), spender).add(value);
189         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
190     }
191 
192     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
193         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
194         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
195     }
196 
197     function _callOptionalReturn(IERC20 token, bytes memory data) private {
198         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
199         if (returndata.length > 0) { // Return data is optional
200             // solhint-disable-next-line max-line-length
201             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
202         }
203     }
204 }
205 
206 contract Ownable is Context {
207     address private _owner;
208 
209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211     /**
212      * @dev Initializes the contract setting the deployer as the initial owner.
213      */
214     constructor () internal {
215         address msgSender = _msgSender();
216         _owner = msgSender;
217         emit OwnershipTransferred(address(0), msgSender);
218     }
219 
220     /**
221      * @dev Returns the address of the current owner.
222      */
223     function owner() public view returns (address) {
224         return _owner;
225     }
226 
227     /**
228      * @dev Throws if called by any account other than the owner.
229      */
230     modifier onlyOwner() {
231         require(_owner == _msgSender(), "Ownable: caller is not the owner");
232         _;
233     }
234 
235     /**
236      * @dev Leaves the contract without owner. It will not be possible to call
237      * `onlyOwner` functions anymore. Can only be called by the current owner.
238      *
239      * NOTE: Renouncing ownership will leave the contract without an owner,
240      * thereby removing any functionality that is only available to the owner.
241      */
242     function renounceOwnership() public virtual onlyOwner {
243         emit OwnershipTransferred(_owner, address(0));
244         _owner = address(0);
245     }
246 
247     /**
248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
249      * Can only be called by the current owner.
250      */
251     function transferOwnership(address newOwner) public virtual onlyOwner {
252         require(newOwner != address(0), "Ownable: new owner is the zero address");
253         emit OwnershipTransferred(_owner, newOwner);
254         _owner = newOwner;
255     }
256 }
257 
258 contract Whitelist is Ownable {
259     mapping(address => bool) whitelist;
260     event AddedToWhitelist(address indexed account);
261     event RemovedFromWhitelist(address indexed account);
262 
263     modifier onlyWhitelisted() {
264         require(isWhitelisted(msg.sender));
265         _;
266     }
267 
268     function addToWhitelist(address _address) public onlyOwner {
269         whitelist[_address] = true;
270         emit AddedToWhitelist(_address);
271     }
272 
273     function removeFromWhitelist(address _address) public onlyOwner {
274         whitelist[_address] = false;
275         emit RemovedFromWhitelist(_address);
276     }
277 
278     function isWhitelisted(address _address) public view returns(bool) {
279         return whitelist[_address];
280     }
281 }
282 
283 
284 contract ERC20 is IERC20, Whitelist {
285     using SafeMath for uint256;
286     using Address for address;
287 
288     mapping (address => uint256) _balances;
289 
290     mapping (address => mapping (address => uint256)) _allowances;
291 
292     uint256 _totalSupply;
293     uint256 INITIAL_SUPPLY = 100000e18; //available supply
294     uint256 BURN_RATE = 1; //burn every per txn
295 	uint256 SUPPLY_FLOOR = 50; // % of supply
296 	uint256 DEFLATION_START_TIME = now + 30 days;
297 
298     string  _name;
299     string  _symbol;
300     uint8 _decimals;
301 
302 
303     function name() public view returns (string memory) {
304         return _name;
305     }
306 
307     function symbol() public view returns (string memory) {
308         return _symbol;
309     }
310 
311 
312     function decimals() public view returns (uint8) {
313         return _decimals;
314     }
315 
316 
317     function totalSupply() public view override returns (uint256) {
318         return _totalSupply;
319     }
320 
321 
322     function balanceOf(address account) public view override returns (uint256) {
323         return _balances[account];
324     }
325 
326 
327     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }
331 
332     function allowance(address owner, address spender) public view virtual override returns (uint256) {
333         return _allowances[owner][spender];
334     }
335 
336     function approve(address spender, uint256 amount) public virtual override returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341 
342     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
345         return true;
346     }
347 
348 
349     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
351         return true;
352     }
353 
354 
355     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
356         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
357         return true;
358     }
359 
360     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(sender, recipient, amount);
365         
366 		_balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
367 		
368 		if(now >= DEFLATION_START_TIME){
369 		    uint256 _burnedAmount = amount * BURN_RATE / 100;
370     		if (_totalSupply - _burnedAmount < INITIAL_SUPPLY * SUPPLY_FLOOR / 100 || isWhitelisted(sender)) {
371     			_burnedAmount = 0;
372     		}
373     		if (_burnedAmount > 0) {
374     			_totalSupply = _totalSupply.sub(_burnedAmount);
375     		}
376     		amount = amount.sub(_burnedAmount);
377 		}
378 		
379 		_balances[recipient] = _balances[recipient].add(amount);
380 		
381         emit Transfer(sender, recipient, amount);
382     }
383 
384   
385     function _approve(address owner, address spender, uint256 amount) internal virtual {
386         require(owner != address(0), "ERC20: approve from the zero address");
387         require(spender != address(0), "ERC20: approve to the zero address");
388 
389         _allowances[owner][spender] = amount;
390         emit Approval(owner, spender, amount);
391     }
392 
393     
394     function _setupDecimals(uint8 decimals_) internal {
395         _decimals = decimals_;
396     }
397 
398     
399     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
400 }
401 
402 
403 contract Token is ERC20{
404 
405 // ----------------------------------------------------------------------------
406 // Buffalo Finance NEXT GENERATION DEFLATIONARY DEFI PLATFORM
407 // Buffalo Finance is a useful, deflationary, next generation DeFi platform where users can easily stake, farm, lend/borrow, and swap crypto assets. Buffalo Finance Platform offers you a variety of facilities for keeping securely and managing your crypto assets, as well as high returns with advantageous rates for your assets.
408 // Symbol       : BUFF
409 // Name         : Buffalo Finance
410 // Total supply : 100,000
411 // www.buffalodefi.com
412 // www.twitter.com/buffalo_finance
413 // https://t.me/buffalofinanceann
414 // https://t.me/buffalofinance
415 // www.medium.com/@buffalofinance
416 // ----------------------------------------------------------------------------
417 
418 	constructor (string memory name, string memory symbol) public {
419         _name = "Buffalo Finance";
420         _symbol = "BUFF";
421         _decimals = 18;
422         _totalSupply = INITIAL_SUPPLY;
423         _balances[msg.sender] = _balances[msg.sender].add(INITIAL_SUPPLY);
424     }
425 
426 	
427 }