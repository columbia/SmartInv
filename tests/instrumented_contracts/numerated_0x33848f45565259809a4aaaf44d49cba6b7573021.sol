1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor(address custom_owner) public {
21     if (custom_owner != address (0))
22       _owner = custom_owner;
23     else
24       _owner = msg.sender;
25     emit OwnershipTransferred(address(0), _owner);
26   }
27 
28   /**
29    * @return the address of the owner.
30    */
31   function owner() public view returns(address) {
32     return _owner;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(isOwner());
40     _;
41   }
42 
43   /**
44    * @return true if `msg.sender` is the owner of the contract.
45    */
46   function isOwner() public view returns(bool) {
47     return msg.sender == _owner;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipTransferred(_owner, address(0));
58     _owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     _transferOwnership(newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address newOwner) internal {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(_owner, newOwner);
76     _owner = newOwner;
77   }
78 }
79 
80 
81 contract Authorizable is Ownable {
82     mapping (address => bool) addressesAllowed;
83 
84     constructor () Ownable(address(0)) public {
85         addressesAllowed[owner()] = true;
86     }
87 
88     function addAuthorization (address authAddress) public onlyOwner {
89         addressesAllowed[authAddress] = true;
90     }
91 
92     function removeAuthorization (address authAddress) public onlyOwner {
93         delete(addressesAllowed[authAddress]);
94     }
95 
96     function isAuthorized () public view returns(bool) {
97         return addressesAllowed[msg.sender];
98     }
99 
100     modifier authorized() {
101         require(isAuthorized());
102         _;
103     }
104 }
105 
106 contract NotesharesCatalog is Authorizable {
107     address[] public tokens;
108     mapping (address => bool) public banned; // 1 - banned, 0 - allowed
109 
110     event tokenAdded (address tokenAddress);
111     event permissionChanged (address tokenAddress, bool permission);
112 
113     function getTokens () public view returns(address[]) {
114         return tokens;
115     }
116 
117     function getTokensCount () public view returns(uint256) {
118         return tokens.length;
119     }
120 
121     function isBanned (address tokenAddress) public view returns(bool) {
122         return banned[tokenAddress];
123     }
124 
125     function setPermission (address tokenAddress, bool permission) public onlyOwner {
126         if (permission)
127             banned[tokenAddress] = permission;
128         else
129             delete(banned[tokenAddress]);
130 
131         emit permissionChanged(tokenAddress, permission);
132     }
133 
134     function addExistingToken (address token) public authorized {
135         require(token != address (0));
136         tokens.push(token);
137         emit tokenAdded (token);
138     }
139 
140     function destruct () public onlyOwner {
141         selfdestruct(owner());
142     }
143 }
144 
145 /*
146     Based on https://etherscan.io/address/0x6dee36e9f915cab558437f97746998048dcaa700#code
147     by https://blog.pennyether.com/posts/realtime-dividend-token.html
148 */
149 
150 /**
151  * @title SafeMath
152  * @dev Math operations with safety checks that revert on error
153  */
154 library SafeMath {
155 
156   /**
157   * @dev Multiplies two numbers, reverts on overflow.
158   */
159   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161     // benefit is lost if 'b' is also tested.
162     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
163     if (a == 0) {
164       return 0;
165     }
166 
167     uint256 c = a * b;
168     require(c / a == b);
169 
170     return c;
171   }
172 
173   /**
174   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
175   */
176   function div(uint256 a, uint256 b) internal pure returns (uint256) {
177     require(b > 0); // Solidity only automatically asserts when dividing by 0
178     uint256 c = a / b;
179     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
180 
181     return c;
182   }
183 
184   /**
185   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
186   */
187   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188     require(b <= a);
189     uint256 c = a - b;
190 
191     return c;
192   }
193 
194   /**
195   * @dev Adds two numbers, reverts on overflow.
196   */
197   function add(uint256 a, uint256 b) internal pure returns (uint256) {
198     uint256 c = a + b;
199     require(c >= a);
200 
201     return c;
202   }
203 
204   /**
205   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
206   * reverts when dividing by zero.
207   */
208   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209     require(b != 0);
210     return a % b;
211   }
212 }
213 
214 
215 contract ERC20 {
216     using SafeMath for uint256;
217 
218     string public name;
219     string public symbol;
220     uint8 public decimals = 18;
221     uint public totalSupply;
222     mapping (address => uint) public balanceOf;
223     mapping (address => mapping (address => uint)) public allowance;
224 
225     event Created(uint time);
226     event Transfer(address indexed from, address indexed to, uint amount);
227     event Approval(address indexed owner, address indexed spender, uint amount);
228     event AllowanceUsed(address indexed owner, address indexed spender, uint amount);
229 
230     constructor(string _name, string _symbol)
231     public
232     {
233         name = _name;
234         symbol = _symbol;
235         emit Created(now);
236     }
237 
238     function transfer(address _to, uint _value)
239     public
240     returns (bool success)
241     {
242         return _transfer(msg.sender, _to, _value);
243     }
244 
245     function approve(address _spender, uint _value)
246     public
247     returns (bool success)
248     {
249         allowance[msg.sender][_spender] = _value;
250         emit Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     // Attempts to transfer `_value` from `_from` to `_to`
255     //  if `_from` has sufficient allowance for `msg.sender`.
256     function transferFrom(address _from, address _to, uint256 _value)
257     public
258     returns (bool success)
259     {
260         address _spender = msg.sender;
261         require(allowance[_from][_spender] >= _value);
262         allowance[_from][_spender] = allowance[_from][_spender].sub(_value);
263         emit AllowanceUsed(_from, _spender, _value);
264         return _transfer(_from, _to, _value);
265     }
266 
267     // Transfers balance from `_from` to `_to` if `_to` has sufficient balance.
268     // Called from transfer() and transferFrom().
269     function _transfer(address _from, address _to, uint _value)
270     private
271     returns (bool success)
272     {
273         require(balanceOf[_from] >= _value);
274         require(balanceOf[_to].add(_value) > balanceOf[_to]);
275         balanceOf[_from] = balanceOf[_from].sub(_value);
276         balanceOf[_to] = balanceOf[_to].add(_value);
277         emit Transfer(_from, _to, _value);
278         return true;
279     }
280 }
281 
282 interface HasTokenFallback {
283     function tokenFallback(address _from, uint256 _amount, bytes _data)
284     external
285     returns (bool success);
286 }
287 
288 contract ERC667 is ERC20 {
289     constructor(string _name, string _symbol)
290     public
291     ERC20(_name, _symbol)
292     {}
293 
294     function transferAndCall(address _to, uint _value, bytes _data)
295     public
296     returns (bool success)
297     {
298         require(super.transfer(_to, _value));
299         require(HasTokenFallback(_to).tokenFallback(msg.sender, _value, _data));
300         return true;
301     }
302 }
303 
304 /*********************************************************
305 ******************* DIVIDEND TOKEN ***********************
306 **********************************************************
307 
308 UI: https://www.pennyether.com/status/tokens
309 
310 An ERC20 token that can accept Ether and distribute it
311 perfectly to all Token Holders relative to each account's
312 balance at the time the dividend is received.
313 
314 The Token is owned by the creator, and can be frozen,
315 minted, and burned by the owner.
316 
317 Notes:
318     - Accounts can view or receive dividends owed at any time
319     - Dividends received are immediately credited to all
320       current Token Holders and can be redeemed at any time.
321     - Per above, upon transfers, dividends are not
322       transferred. They are kept by the original sender, and
323       not credited to the receiver.
324     - Uses "pull" instead of "push". Token holders must pull
325       their own dividends.
326 
327 */
328 contract DividendTokenERC667 is ERC667, Ownable
329 {
330     using SafeMath for uint256;
331 
332     // How dividends work:
333     //
334     // - A "point" is a fraction of a Wei (1e-32), it's used to reduce rounding errors.
335     //
336     // - totalPointsPerToken represents how many points each token is entitled to
337     //   from all the dividends ever received. Each time a new deposit is made, it
338     //   is incremented by the points oweable per token at the time of deposit:
339     //     (depositAmtInWei * POINTS_PER_WEI) / totalSupply
340     //
341     // - Each account has a `creditedPoints` and `lastPointsPerToken`
342     //   - lastPointsPerToken:
343     //       The value of totalPointsPerToken the last time `creditedPoints` was changed.
344     //   - creditedPoints:
345     //       How many points have been credited to the user. This is incremented by:
346     //         (`totalPointsPerToken` - `lastPointsPerToken` * balance) via
347     //         `.updateCreditedPoints(account)`. This occurs anytime the balance changes
348     //         (transfer, mint, burn).
349     //
350     // - .collectOwedDividends() calls .updateCreditedPoints(account), converts points
351     //   to wei and pays account, then resets creditedPoints[account] to 0.
352     //
353     // - "Credit" goes to Nick Johnson for the concept.
354     //
355     uint constant POINTS_PER_WEI = 1e32;
356     uint public dividendsTotal;
357     uint public dividendsCollected;
358     uint public totalPointsPerToken;
359     mapping (address => uint) public creditedPoints;
360     mapping (address => uint) public lastPointsPerToken;
361 
362     // Events
363     event CollectedDividends(uint time, address indexed account, uint amount);
364     event DividendReceived(uint time, address indexed sender, uint amount);
365 
366     constructor(uint256 _totalSupply, address _custom_owner)
367     public
368     ERC667("Noteshares Token", "NST")
369     Ownable(_custom_owner)
370     {
371         totalSupply = _totalSupply;
372     }
373 
374     // Upon receiving payment, increment lastPointsPerToken.
375     function receivePayment()
376     internal
377     {
378         if (msg.value == 0) return;
379         // POINTS_PER_WEI is 1e32.
380         // So, no multiplication overflow unless msg.value > 1e45 wei (1e27 ETH)
381         totalPointsPerToken = totalPointsPerToken.add((msg.value.mul(POINTS_PER_WEI)).div(totalSupply));
382         dividendsTotal = dividendsTotal.add(msg.value);
383         emit DividendReceived(now, msg.sender, msg.value);
384     }
385     /*************************************************************/
386     /********** PUBLIC FUNCTIONS *********************************/
387     /*************************************************************/
388 
389     // Normal ERC20 transfer, except before transferring
390     //  it credits points for both the sender and receiver.
391     function transfer(address _to, uint _value)
392     public
393     returns (bool success)
394     {
395         // ensure tokens are not frozen.
396         _updateCreditedPoints(msg.sender);
397         _updateCreditedPoints(_to);
398         return ERC20.transfer(_to, _value);
399     }
400 
401     // Normal ERC20 transferFrom, except before transferring
402     //  it credits points for both the sender and receiver.
403     function transferFrom(address _from, address _to, uint256 _value)
404     public
405     returns (bool success)
406     {
407         _updateCreditedPoints(_from);
408         _updateCreditedPoints(_to);
409         return ERC20.transferFrom(_from, _to, _value);
410     }
411 
412     // Normal ERC667 transferAndCall, except before transferring
413     //  it credits points for both the sender and receiver.
414     function transferAndCall(address _to, uint _value, bytes _data)
415     public
416     returns (bool success)
417     {
418         _updateCreditedPoints(msg.sender);
419         _updateCreditedPoints(_to);
420         return ERC667.transferAndCall(_to, _value, _data);
421     }
422 
423     // Updates creditedPoints, sends all wei to the owner
424     function collectOwedDividends()
425     internal
426     returns (uint _amount)
427     {
428         // update creditedPoints, store amount, and zero it.
429         _updateCreditedPoints(msg.sender);
430         _amount = creditedPoints[msg.sender].div(POINTS_PER_WEI);
431         creditedPoints[msg.sender] = 0;
432         dividendsCollected = dividendsCollected.add(_amount);
433         emit CollectedDividends(now, msg.sender, _amount);
434         require(msg.sender.call.value(_amount)());
435     }
436 
437 
438     /*************************************************************/
439     /********** PRIVATE METHODS / VIEWS **************************/
440     /*************************************************************/
441     // Credits _account with whatever dividend points they haven't yet been credited.
442     //  This needs to be called before any user's balance changes to ensure their
443     //  "lastPointsPerToken" credits their current balance, and not an altered one.
444     function _updateCreditedPoints(address _account)
445     private
446     {
447         creditedPoints[_account] = creditedPoints[_account].add(_getUncreditedPoints(_account));
448         lastPointsPerToken[_account] = totalPointsPerToken;
449     }
450 
451     // For a given account, returns how many Wei they haven't yet been credited.
452     function _getUncreditedPoints(address _account)
453     private
454     view
455     returns (uint _amount)
456     {
457         uint _pointsPerToken = totalPointsPerToken.sub(lastPointsPerToken[_account]);
458         // The upper bound on this number is:
459         //   ((1e32 * TOTAL_DIVIDEND_AMT) / totalSupply) * balances[_account]
460         // Since totalSupply >= balances[_account], this will overflow only if
461         //   TOTAL_DIVIDEND_AMT is around 1e45 wei. Not ever going to happen.
462         return _pointsPerToken.mul(balanceOf[_account]);
463     }
464 
465 
466     /*************************************************************/
467     /********* CONSTANTS *****************************************/
468     /*************************************************************/
469     // Returns how many wei a call to .collectOwedDividends() would transfer.
470     function getOwedDividends(address _account)
471     public
472     constant
473     returns (uint _amount)
474     {
475         return (_getUncreditedPoints(_account).add(creditedPoints[_account])).div(POINTS_PER_WEI);
476     }
477 }
478 
479 contract NSERC667 is DividendTokenERC667 {
480     using SafeMath for uint256;
481 
482     uint256 private TOTAL_SUPPLY =  100 * (10 ** uint256(decimals)); //always a 100 tokens representing 100% of ownership
483 
484     constructor (address ecosystemFeeAccount, uint256 ecosystemShare, address _custom_owner)
485     public
486     DividendTokenERC667(TOTAL_SUPPLY, _custom_owner)
487     {
488         uint256 ownerSupply = totalSupply.sub(ecosystemShare);
489         balanceOf[owner()] = ownerSupply;
490         balanceOf[ecosystemFeeAccount] = ecosystemShare;
491     }
492 }
493 
494 contract NotesharesToken is NSERC667 {
495     using SafeMath for uint256;
496 
497     uint8 public state; //0 - canceled, 1 - active, 2 - failed, 3 - complete
498 
499     string private contentLink;
500     string private folderLink;
501     bool public hidden = false;
502 
503     constructor (string _contentLink, string _folderLink, address _ecosystemFeeAccount, uint256 ecosystemShare, address _custom_owner)
504     public
505     NSERC667(_ecosystemFeeAccount, ecosystemShare, _custom_owner) {
506         state = 3;
507         contentLink = _contentLink;
508         folderLink = _folderLink;
509     }
510 
511     //payables
512     /**
513      * Main donation function
514      */
515     function () public payable {
516         require(state == 3); //donations only acceptable if contract is complete
517         receivePayment();
518     }
519 
520     function getContentLink () public view returns (string) {
521         require(hidden == false);
522         return contentLink;
523     }
524 
525     function getFolderLink() public view returns (string) {
526         require(hidden == false);
527         return folderLink;
528     }
529     //Contract control
530     /**
531      * Transfers dividend in ETH if contract is complete or remaining funds to investors if contract is failed
532      */
533 
534     function setCancelled () public onlyOwner {
535         state = 0;
536     }
537 
538     function setHidden (bool _hidden) public onlyOwner {
539         hidden = _hidden;
540     }
541 
542     function claimDividend () public {
543         require(state > 1);
544         collectOwedDividends();
545     }
546 
547     //destruction is possible if there is only one owner
548     function destruct () public onlyOwner {
549         require(state == 2 || state == 3);
550         require(balanceOf[owner()] == totalSupply);
551         selfdestruct(owner());
552     }
553 
554     //to claim ownership you should have 100% of tokens
555     function claimOwnership () public {
556         //require(state == 2);
557         require(balanceOf[msg.sender] == totalSupply);
558         _transferOwnership(msg.sender);
559     }
560 }
561 
562 contract NotesharesTokenFactory is Ownable (address(0)) {
563     address public catalogAddress;
564     address public ecosystemFeeAccount;
565 
566     event tokenCreated (address tokenAddress);
567 
568     constructor (address _catalogAddress, address _ecosystemFeeAccount) public {
569         catalogAddress = _catalogAddress;
570         ecosystemFeeAccount = _ecosystemFeeAccount;
571     }
572 
573     function setEcosystemFeeAccount (address _ecosystemFeeAccount) public onlyOwner {
574         ecosystemFeeAccount = _ecosystemFeeAccount;
575     }
576 
577     function setCatalogAddress (address _catalogAddress) public onlyOwner {
578         catalogAddress = _catalogAddress;
579     }
580 
581     function addTokenToCatalog (address token) internal {
582         NotesharesCatalog NSC = NotesharesCatalog(catalogAddress);
583         NSC.addExistingToken(address(token));
584     }
585 
586     function createToken (string _contentLink, string _folderLink, uint256 ecosystemShare) public returns (address){
587         NotesharesToken NST = new NotesharesToken(_contentLink, _folderLink, ecosystemFeeAccount, ecosystemShare, msg.sender);
588         emit tokenCreated(address(NST));
589         addTokenToCatalog(address(NST));
590     }
591 
592     function destruct () public onlyOwner {
593         selfdestruct(owner());
594     }
595 }