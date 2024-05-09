1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41 
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45 
46 
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55 
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59 
60 
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b != 0, errorMessage);
63         return a % b;
64     }
65 }
66 
67 
68 library Address {
69 
70     function isContract(address account) internal view returns (bool) {
71         bytes32 codehash;
72         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
73         // solhint-disable-next-line no-inline-assembly
74         assembly { codehash := extcodehash(account) }
75         return (codehash != accountHash && codehash != 0x0);
76     }
77 
78 
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87 
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89       return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92 
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97 
98     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
99         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
100     }
101 
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
104         require(address(this).balance >= value, "Address: insufficient balance for call");
105         return _functionCallWithValue(target, data, value, errorMessage);
106     }
107 
108     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
109         require(isContract(target), "Address: call to non-contract");
110 
111         // solhint-disable-next-line avoid-low-level-calls
112         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
113         if (success) {
114             return returndata;
115         } else {
116             // Look for revert reason and bubble it up if present
117             if (returndata.length > 0) {
118                 // The easiest way to bubble the revert reason is using memory via assembly
119 
120                 // solhint-disable-next-line no-inline-assembly
121                 assembly {
122                     let returndata_size := mload(returndata)
123                     revert(add(32, returndata), returndata_size)
124                 }
125             } else {
126                 revert(errorMessage);
127             }
128         }
129     }
130 }
131 
132 library SafeERC20 {
133     using SafeMath for uint256;
134     using Address for address;
135 
136     function safeTransfer(IERC20 token, address to, uint256 value) internal {
137         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
138     }
139 
140     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
141         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
142     }
143 
144 
145     function safeApprove(IERC20 token, address spender, uint256 value) internal {
146         // safeApprove should only be called when setting an initial allowance,
147         // or when resetting it to zero. To increase and decrease it, use
148         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
149         // solhint-disable-next-line max-line-length
150         require((value == 0) || (token.allowance(address(this), spender) == 0),
151             "SafeERC20: approve from non-zero to non-zero allowance"
152         );
153         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
154     }
155 
156     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
157         uint256 newAllowance = token.allowance(address(this), spender).add(value);
158         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
159     }
160 
161     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
162         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
163         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
164     }
165 
166 
167     function _callOptionalReturn(IERC20 token, bytes memory data) private {
168         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
169         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
170         // the target address contains contract code and also asserts for success in the low-level call.
171 
172         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
173         if (returndata.length > 0) { // Return data is optional
174             // solhint-disable-next-line max-line-length
175             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
176         }
177     }
178 }
179 
180 
181 interface IERC20 {
182 
183     function totalSupply() external view returns (uint256);
184 
185     function balanceOf(address account) external view returns (uint256);
186 
187     function transfer(address recipient, uint256 amount) external returns (bool);
188 
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
194 
195     function decimals() external view returns (uint8);
196 
197     event Transfer(address indexed from, address indexed to, uint256 value);
198 
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 
203 
204 contract Ownable {
205     address private _owner;
206 
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209     constructor () internal {
210         _owner = msg.sender;
211         emit OwnershipTransferred(address(0), _owner);
212     }
213 
214     function owner() public view returns (address) {
215         return _owner;
216     }
217 
218 
219     modifier onlyOwner() {
220         require(_owner == msg.sender, "Ownable: caller is not the owner");
221         _;
222     }
223 
224 
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         emit OwnershipTransferred(_owner, newOwner);
228         _owner = newOwner;
229     }
230 }
231 
232 
233 contract FIXToken is IERC20, Ownable {
234     using SafeMath for uint256;
235     using SafeERC20 for IERC20;
236     using Address for address;
237 
238     mapping (address => uint256) private _balances;
239 
240     mapping (address => mapping (address => uint256)) private _allowances;
241 
242     mapping (address => bool) private _isFirstSale;
243 
244     uint256 public constant SECONDS_PER_WEEK = 604800;
245 
246     uint256 private constant PERCENTAGE_MULTIPLICATOR = 1e4;
247 
248     uint8 private constant DEFAULT_DECIMALS = 6;
249 
250     uint256 private _totalSupply;
251 
252     string private _name;
253     string private _symbol;
254     uint8 private _decimals;
255 
256     uint256 private _firstUpdate;
257     uint256 private _lastUpdate;
258 
259     uint256 private _growthRate;
260     uint256 private _growthRate_after;
261 
262     uint256 private _price;
263 
264     uint256 private _presaleStart;
265     uint256 private _presaleEnd;
266 
267     bool private _isStarted;
268 
269     uint256 [] _zeros;
270 
271     event TokensPurchased(address indexed purchaser, uint256 value, uint256 amount, uint256 price);
272     event TokensSold(address indexed seller, uint256 amount, uint256 USDT, uint256 price);
273     event PriceUpdated(uint price);
274 
275 
276     constructor (uint256 _ownerSupply) public {
277         _decimals = 18;
278         _totalSupply = 500000000 * uint(10) ** _decimals;
279         require (_ownerSupply < _totalSupply, "Owner supply must be lower than total supply");
280         _name = "ProFIXone Token";
281         _symbol = "FIX";
282         _price = 1000000;
283         _growthRate = 100;
284         _balances[address(this)] = _totalSupply.sub(_ownerSupply);
285         _balances[owner()] = _ownerSupply;
286         emit Transfer(address(0), address(this), _totalSupply.sub(_ownerSupply));
287         emit Transfer(address(0), owner(), _ownerSupply);
288     }
289 
290 
291     function name() public view returns (string memory) {
292         return _name;
293     }
294 
295 
296     function symbol() public view returns (string memory) {
297         return _symbol;
298     }
299 
300 
301     function decimals() public view override returns (uint8) {
302         return _decimals;
303     }
304 
305 
306     function totalSupply() public view override returns (uint256) {
307         return _totalSupply;
308     }
309 
310 
311     function balanceOf(address account) public view override returns (uint256) {
312         return _balances[account];
313     }
314 
315 
316     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(msg.sender, recipient, amount);
318         return true;
319     }
320 
321 
322     function allowance(address owner, address spender) public view virtual override returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326 
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(msg.sender, spender, amount);
329         return true;
330     }
331 
332 
333     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
334         _transfer(sender, recipient, amount);
335         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
336         return true;
337     }
338 
339 
340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
341         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
342         return true;
343     }
344 
345 
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
348         return true;
349     }
350 
351 
352     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355         if (msg.sender != owner()) {
356             require(recipient == owner(), "Tokens can be sent only to owner address.");
357         }
358         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
359         _balances[recipient] = _balances[recipient].add(amount);
360         emit Transfer(sender, recipient, amount);
361     }
362 
363 
364     function _approve(address owner, address spender, uint256 amount) internal virtual {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = amount;
369         emit Approval(owner, spender, amount);
370     }
371 
372 
373     function calculatePrice() public view returns (uint256) {
374         if (_isStarted == false || _firstUpdate > now) {
375             return _price;
376         }
377         uint256 i;
378         uint256 newPrice = _price;
379         if (now > _lastUpdate) {
380             i = uint256((_lastUpdate.sub(_firstUpdate)).div(SECONDS_PER_WEEK).add(uint256(1)).sub(_zeros.length));
381             for (uint256 x = 0; x < i; x++) {
382                 newPrice = newPrice.mul(PERCENTAGE_MULTIPLICATOR.add(_growthRate)).div(PERCENTAGE_MULTIPLICATOR);
383             }
384             if (_growthRate_after > 0) {
385                 i = uint256((now.sub(_lastUpdate)).div(SECONDS_PER_WEEK));
386                 for (uint256 x = 0; x < i; x++) {
387                     newPrice = newPrice.mul(PERCENTAGE_MULTIPLICATOR.add(_growthRate_after)).div(PERCENTAGE_MULTIPLICATOR);
388                 }
389             }
390         } else {
391             i = uint256((now.sub(_firstUpdate)).div(SECONDS_PER_WEEK)).add(uint256(1));
392             for (uint8 x = 0; x < _zeros.length; x++) {
393                 if (_zeros[x] >= _firstUpdate && _zeros[x] <= now) {
394                     i = i.sub(uint256(1));
395                 }
396             }
397             for (uint256 x = 0; x < i; x++) {
398                 newPrice = newPrice.mul(PERCENTAGE_MULTIPLICATOR.add(_growthRate)).div(PERCENTAGE_MULTIPLICATOR);
399             }
400 
401         }
402 
403         return newPrice;
404     }
405 
406 
407     function currentPrice() public view returns (uint256) {
408         return calculatePrice();
409     }
410 
411     function growthRate() public view returns (uint256) {
412         return _growthRate_after;
413     }
414 
415 
416     function isStarted() public view returns (bool) {
417         return _isStarted;
418     }
419 
420     function presaleStart() public view returns (uint256) {
421         return _presaleStart;
422     }
423 
424     function presaleEnd() public view returns (uint256) {
425         return _presaleEnd;
426     }
427 
428 
429     function startContract(uint256 firstUpdate, uint256 lastUpdate, uint256 [] memory zeros) external onlyOwner {
430         require (_isStarted == false, "Contract is already started.");
431         require (firstUpdate >= now, "First price update time must be later than today");
432         require (lastUpdate >= now, "Last price update time must be later than today");
433         require (lastUpdate > firstUpdate, "Last price update time must be later than first update");
434         _firstUpdate = firstUpdate;
435         _lastUpdate = lastUpdate;
436         _isStarted = true;
437         for (uint8 x = 0; x < zeros.length; x++) {
438             _zeros.push(zeros[x]);
439         }
440 
441     }
442 
443     function setPresaleStart(uint256 new_date) external onlyOwner {
444         require (_isStarted == true, "Contract is not started.");
445         require(new_date >= now, "Start time must be later, than now");
446         require(new_date > _presaleStart, "New start time must be higher then previous.");
447         _presaleStart = new_date;
448     }
449 
450     function setPresaleEnd(uint256 new_date) external onlyOwner {
451         require (_isStarted == true, "Contract is not started.");
452         require(new_date >= now, "End time must be later, than now");
453         require(new_date > _presaleEnd, "New end time must be higher then previous.");
454         require(new_date > _presaleStart, "New end time must be higher then start date.");
455         _presaleEnd = new_date;
456     }
457 
458 
459     function setGrowthRate(uint256 _newGrowthRate) external onlyOwner {
460         require (_isStarted == true, "Contract is not started.");
461         require(now > _lastUpdate, "Growth rate cannot be changed within 60 months");
462         _growthRate_after =_newGrowthRate;
463     }
464 
465 
466     function calculateTokens(uint256 amount, uint8 coin_decimals, uint256 updatedPrice) public view returns(uint256) {
467         uint256 result;
468         if (coin_decimals >= DEFAULT_DECIMALS) {
469             result = amount.mul(10 ** uint256(_decimals)).div(updatedPrice.mul(10 ** uint256(coin_decimals-DEFAULT_DECIMALS)));
470         } else {
471             result = amount.mul(10 ** uint256(_decimals)).div(updatedPrice.div(10 ** uint256(DEFAULT_DECIMALS-coin_decimals)));
472 
473         }
474         if (now >= _presaleStart && now <= _presaleEnd) {
475             if (amount >= uint256(1000).mul(10 ** uint256(coin_decimals))) {
476                 result.add(100 * uint(10) ** _decimals);
477             }
478         }
479 
480         return result;
481     }
482 
483 
484     function sendTokens(address recepient, uint256 amount, uint8 coinDecimals) external onlyOwner {
485         require (_isStarted == true, "Contract is not started.");
486         require (_presaleStart > 0, "Presale start not set");
487         require (_presaleEnd > 0, "Presale end not set");
488         require (coinDecimals > 0, "Stablecoin decimals must be grater than 0");
489         require (amount > 0, "Stablecoin value cannot be zero.");
490         require(recepient != address(0), "ERC20: transfer to the zero address");
491         uint256 lastPrice = calculatePrice();
492         uint FIXAmount = calculateTokens(amount.mul(99).div(100), coinDecimals, lastPrice);
493         require(_balances[address(this)] >= FIXAmount, "Insufficinet FIX amount left on contract");
494         _balances[address(this)] = _balances[address(this)].sub(FIXAmount, "ERC20: transfer amount exceeds balance");
495         _balances[recepient] = _balances[recepient].add(FIXAmount);
496         emit TokensPurchased(recepient, amount, FIXAmount, lastPrice);
497         emit Transfer(address(this), recepient, FIXAmount);
498 
499     }
500 
501     function sellTokens(address stablecoin, uint256 amount) external {
502         require (_isStarted == true, "Contract is not started.");
503         require (_presaleStart > 0, "Presale start not set");
504         require (_presaleEnd > 0, "Presale end not set");
505         require (amount > 0, "FIX value cannot be zero.");
506         require(msg.sender != address(0), "ERC20: transfer to the zero address");
507         require(stablecoin != address(0), "Stablecoin must not be zero address");
508         require(stablecoin.isContract(), "Not a valid stablecoin contract address");
509         uint256 coin_amount;
510         uint256 new_amount = amount;
511         IERC20 coin = IERC20(stablecoin);
512         uint8 coin_decimals = coin.decimals();
513         uint256 lastPrice = calculatePrice();
514         if (!_isFirstSale[msg.sender]) {
515             new_amount = amount.mul(98).div(100);
516             _isFirstSale[msg.sender] = true;
517         }
518         require (_balances[msg.sender] >= amount, "Insufficient FIX token amount");
519         if (coin_decimals >= 12) {
520             coin_amount = new_amount.div(lastPrice).mul(10 ** uint256(coin_decimals-12));
521         } else {
522             coin_amount = new_amount.div(lastPrice).div(10 ** uint256(12 - coin_decimals));
523         }
524 
525         _balances[address(this)] = _balances[address(this)].add(amount);
526         _balances[msg.sender] = _balances[msg.sender].sub(amount);
527         emit Transfer(msg.sender, address(this), amount);
528         emit TokensSold(msg.sender, amount, coin_amount, lastPrice);
529     }
530 
531 }