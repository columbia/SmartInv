1 pragma solidity ^0.4.24;
2 
3 // File: contracts/deps/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/deps/IERC20.sol
70 
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender)
77     external view returns (uint256);
78 
79     function transfer(address to, uint256 value) external returns (bool);
80 
81     function approve(address spender, uint256 value)
82     external returns (bool);
83 
84     function transferFrom(address from, address to, uint256 value)
85     external returns (bool);
86     
87     function _mint(address account, uint256 amount) external;
88 
89     event Transfer(
90         address indexed from,
91         address indexed to,
92         uint256 value
93     );
94 
95     event Approval(
96         address indexed owner,
97         address indexed spender,
98         uint256 value
99     );
100 }
101 
102 // File: contracts/deps/SafeERC20.sol
103 
104 library SafeERC20 {
105     function safeTransfer(
106         IERC20 token,
107         address to,
108         uint256 value
109     )
110     internal
111     {
112         require(token.transfer(to, value));
113     }
114 
115     function safeTransferFrom(
116         IERC20 token,
117         address from,
118         address to,
119         uint256 value
120     )
121     internal
122     {
123         require(token.transferFrom(from, to, value));
124     }
125 
126     function safeApprove(
127         IERC20 token,
128         address spender,
129         uint256 value
130     )
131     internal
132     {
133         require(token.approve(spender, value));
134     }
135 }
136 
137 // File: contracts/deps/Ownable.sol
138 
139 /**
140  * @title Ownable
141  * @dev The Ownable contract has an owner address, and provides basic authorization control
142  * functions, this simplifies the implementation of "user permissions".
143  */
144 contract Ownable {
145     address private _owner;
146 
147     event OwnershipRenounced(address indexed previousOwner);
148     event OwnershipTransferred(
149         address indexed previousOwner,
150         address indexed newOwner
151     );
152 
153     /**
154      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155      * account.
156      */
157     constructor() public {
158         _owner = msg.sender;
159     }
160 
161     /**
162      * @return the address of the owner.
163      */
164     function owner() public view returns(address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(isOwner());
173         _;
174     }
175 
176     /**
177      * @return true if `msg.sender` is the owner of the contract.
178      */
179     function isOwner() public view returns(bool) {
180         return msg.sender == _owner;
181     }
182 
183     /**
184      * @dev Allows the current owner to relinquish control of the contract.
185      * @notice Renouncing to ownership will leave the contract without an owner.
186      * It will not be possible to call the functions with the `onlyOwner`
187      * modifier anymore.
188      */
189     function renounceOwnership() public onlyOwner {
190         emit OwnershipRenounced(_owner);
191         _owner = address(0);
192     }
193 
194     /**
195      * @dev Allows the current owner to transfer control of the contract to a newOwner.
196      * @param newOwner The address to transfer ownership to.
197      */
198     function transferOwnership(address newOwner) public onlyOwner {
199         _transferOwnership(newOwner);
200     }
201 
202     /**
203      * @dev Transfers control of the contract to a newOwner.
204      * @param newOwner The address to transfer ownership to.
205      */
206     function _transferOwnership(address newOwner) internal {
207         require(newOwner != address(0));
208         emit OwnershipTransferred(_owner, newOwner);
209         _owner = newOwner;
210     }
211 }
212 
213 // File: contracts/IPCToken.sol
214 
215 contract IPCToken is IERC20, Ownable {
216 
217     string public name = "Iranian Phoenix Coin";
218     uint8 public decimals = 18;
219 
220 
221     string public symbol = "IPC";
222 
223     using SafeMath for uint256;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowed;
228 
229     uint256 private _totalSupply;
230 
231 
232     constructor() public {}
233 
234     function totalSupply() public view returns (uint256) {
235         return _totalSupply;
236     }
237 
238 
239     function balanceOf(address owner) public view returns (uint256) {
240         return _balances[owner];
241     }
242 
243 
244     function allowance(
245         address owner,
246         address spender
247     )
248     public
249     view
250     returns (uint256)
251     {
252         return _allowed[owner][spender];
253     }
254 
255 
256     function transfer(address to, uint256 value) public returns (bool) {
257         require(value <= _balances[msg.sender]);
258         require(to != address(0));
259 
260         _balances[msg.sender] = _balances[msg.sender].sub(value);
261         _balances[to] = _balances[to].add(value);
262         emit Transfer(msg.sender, to, value);
263         return true;
264     }
265 
266 
267     function approve(address spender, uint256 value) public returns (bool) {
268         require(spender != address(0));
269 
270         _allowed[msg.sender][spender] = value;
271         emit Approval(msg.sender, spender, value);
272         return true;
273     }
274 
275 
276     function transferFrom(
277         address from,
278         address to,
279         uint256 value
280     )
281     public onlyOwner
282     returns (bool)
283     {
284         require(value <= _balances[from]);
285         require(value <= _allowed[from][msg.sender]);
286         require(to != address(0));
287 
288         _balances[from] = _balances[from].sub(value);
289         _balances[to] = _balances[to].add(value);
290         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
291         emit Transfer(from, to, value);
292         return true;
293     }
294 
295 
296     function increaseAllowance(
297         address spender,
298         uint256 addedValue
299     )
300     public
301     returns (bool)
302     {
303         require(spender != address(0));
304 
305         _allowed[msg.sender][spender] = (
306         _allowed[msg.sender][spender].add(addedValue));
307         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308         return true;
309     }
310 
311 
312 
313     function decreaseAllowance(
314         address spender,
315         uint256 subtractedValue
316     )
317     public
318     returns (bool)
319     {
320         require(spender != address(0));
321 
322         _allowed[msg.sender][spender] = (
323         _allowed[msg.sender][spender].sub(subtractedValue));
324         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
325         return true;
326     }
327 
328 
329     function _mint(address account, uint256 amount) external onlyOwner {
330         require(account != 0);
331         _totalSupply = _totalSupply.add(amount);
332         _balances[account] = _balances[account].add(amount);
333         emit Transfer(address(0), account, amount);
334     }
335 
336     function _burn(address account, uint256 amount) internal {
337         require(account != 0);
338         require(amount <= _balances[account]);
339 
340         _totalSupply = _totalSupply.sub(amount);
341         _balances[account] = _balances[account].sub(amount);
342 
343         emit Transfer(account, address(0), amount);
344     }
345 
346     function burnFrom(address account, uint256 amount) public onlyOwner {
347         require(amount <= _allowed[account][msg.sender]);
348 
349         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
350             amount);
351         _burn(account, amount);
352     }
353 }
354 
355 // File: contracts/IPCCrowdsale.sol
356 
357 contract IPCCrowdsale is Ownable {
358 
359     using SafeMath for uint;
360     using SafeERC20 for IPCToken;
361 
362 
363     IPCToken private _token = new IPCToken();
364 
365     uint currentPhase = 0;
366 
367     uint256  _weiRaised;
368 
369     uint8[] phase_bonuses =  [50, 0];
370 
371     uint256[] phase_supply_limits = [ 150000 ether, 400000 ether];
372 
373     address private _wallet = 0x67E6Efc62635353aE31d16AD844Cc4BDBCaCe53D;
374 
375     uint private usd_per_barrel_rate = 55;
376     uint private eth_per_usd_rate = 21800 ;
377 
378 
379     event TokensPurchased(
380         address indexed purchaser,
381         address indexed beneficiary,
382         uint256 value,
383         uint256 amount
384     );
385 
386 
387     constructor() public {
388         transferOwnership(_wallet);
389         _token._mint(_wallet, 50000 ether);
390     
391     }
392 
393 
394     function startMainSale() public onlyOwner {
395         require(currentPhase == 0);
396         currentPhase = 1;
397     }
398 
399 
400     function() external payable {
401         buyTokens(msg.sender);
402     }
403 
404 
405     function token() public view returns (IERC20) {
406         return _token;
407     }
408 
409 
410     function wallet() public view returns (address) {
411         return _wallet;
412     }
413 
414 
415     function rate() public view returns (uint256) {
416         return eth_per_usd_rate.div(usd_per_barrel_rate);
417     }
418 
419     function setBarrelPrice(uint _price){
420         usd_per_barrel_rate =_price;
421     }
422 
423 
424     function setEtherPrice(uint _price){
425         eth_per_usd_rate = _price;
426     }
427 
428 
429     /**
430      * @return the mount of wei raised.
431      */
432     function weiRaised() public view returns (uint256) {
433         return _weiRaised;
434     }
435 
436 
437     function get_max_supply() public view returns (uint256) {
438         return phase_supply_limits[currentPhase];
439     }
440 
441 
442     function buyTokens(address beneficiary) public payable {
443 
444         uint256 weiAmount = msg.value;
445 
446         uint256 tokens = _getTokenAmount(weiAmount);
447         uint256 bonus = tokens.mul(phase_bonuses[currentPhase]).div(100);
448         _weiRaised = _weiRaised.add(weiAmount);
449         
450 
451         _processPurchase(beneficiary, tokens + bonus);
452 
453         require(token().totalSupply() < get_max_supply());
454 
455         // emit TokensPurchased(
456         //     msg.sender,
457         //     beneficiary,
458         //     weiAmount,
459         //     tokens
460         // );
461 
462 
463         _forwardFunds();
464     }
465 
466 
467 
468 
469     function _deliverTokens(
470         address beneficiary,
471         uint256 tokenAmount
472     )
473     internal
474     {
475         _token._mint(beneficiary, tokenAmount);
476     }
477 
478 
479     function _processPurchase(
480         address beneficiary,
481         uint256 tokenAmount
482     )
483     internal
484     {
485         _deliverTokens(beneficiary, tokenAmount);
486     }
487 
488     function _getTokenAmount(uint256 weiAmount)
489     internal view returns (uint256)
490     {
491         return weiAmount.mul(rate()).div(100);
492     }
493 
494     function _forwardFunds() internal {
495         _wallet.transfer(msg.value);
496     }
497 }