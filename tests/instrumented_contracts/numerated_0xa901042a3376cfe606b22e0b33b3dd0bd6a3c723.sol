1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74   address private _owner;
75 
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81   /**
82    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83    * account.
84    */
85   constructor(address custom_owner) public {
86     if (custom_owner != address (0))
87       _owner = custom_owner;
88     else
89       _owner = msg.sender;
90     emit OwnershipTransferred(address(0), _owner);
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipTransferred(_owner, address(0));
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 
146 /*
147     Based on https://etherscan.io/address/0x6dee36e9f915cab558437f97746998048dcaa700#code
148     by https://blog.pennyether.com/posts/realtime-dividend-token.html
149 */
150 
151 contract ERC20 {
152     using SafeMath for uint256;
153 
154     string public name;
155     string public symbol;
156     uint8 public decimals = 18;
157     uint public totalSupply;
158     mapping (address => uint) public balanceOf;
159     mapping (address => mapping (address => uint)) public allowance;
160 
161     event Created(uint time);
162     event Transfer(address indexed from, address indexed to, uint amount);
163     event Approval(address indexed owner, address indexed spender, uint amount);
164     event AllowanceUsed(address indexed owner, address indexed spender, uint amount);
165 
166     constructor(string _name, string _symbol)
167     public
168     {
169         name = _name;
170         symbol = _symbol;
171         emit Created(now);
172     }
173 
174     function transfer(address _to, uint _value)
175     public
176     returns (bool success)
177     {
178         return _transfer(msg.sender, _to, _value);
179     }
180 
181     function approve(address _spender, uint _value)
182     public
183     returns (bool success)
184     {
185         allowance[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     // Attempts to transfer `_value` from `_from` to `_to`
191     //  if `_from` has sufficient allowance for `msg.sender`.
192     function transferFrom(address _from, address _to, uint256 _value)
193     public
194     returns (bool success)
195     {
196         address _spender = msg.sender;
197         require(allowance[_from][_spender] >= _value);
198         allowance[_from][_spender] = allowance[_from][_spender].sub(_value);
199         emit AllowanceUsed(_from, _spender, _value);
200         return _transfer(_from, _to, _value);
201     }
202 
203     // Transfers balance from `_from` to `_to` if `_to` has sufficient balance.
204     // Called from transfer() and transferFrom().
205     function _transfer(address _from, address _to, uint _value)
206     private
207     returns (bool success)
208     {
209         require(balanceOf[_from] >= _value);
210         require(balanceOf[_to].add(_value) > balanceOf[_to]);
211         balanceOf[_from] = balanceOf[_from].sub(_value);
212         balanceOf[_to] = balanceOf[_to].add(_value);
213         emit Transfer(_from, _to, _value);
214         return true;
215     }
216 }
217 
218 interface HasTokenFallback {
219     function tokenFallback(address _from, uint256 _amount, bytes _data)
220     external
221     returns (bool success);
222 }
223 
224 contract ERC667 is ERC20 {
225     constructor(string _name, string _symbol)
226     public
227     ERC20(_name, _symbol)
228     {}
229 
230     function transferAndCall(address _to, uint _value, bytes _data)
231     public
232     returns (bool success)
233     {
234         require(super.transfer(_to, _value));
235         require(HasTokenFallback(_to).tokenFallback(msg.sender, _value, _data));
236         return true;
237     }
238 }
239 
240 /*********************************************************
241 ******************* DIVIDEND TOKEN ***********************
242 **********************************************************
243 
244 UI: https://www.pennyether.com/status/tokens
245 
246 An ERC20 token that can accept Ether and distribute it
247 perfectly to all Token Holders relative to each account's
248 balance at the time the dividend is received.
249 
250 The Token is owned by the creator, and can be frozen,
251 minted, and burned by the owner.
252 
253 Notes:
254     - Accounts can view or receive dividends owed at any time
255     - Dividends received are immediately credited to all
256       current Token Holders and can be redeemed at any time.
257     - Per above, upon transfers, dividends are not
258       transferred. They are kept by the original sender, and
259       not credited to the receiver.
260     - Uses "pull" instead of "push". Token holders must pull
261       their own dividends.
262 
263 */
264 contract DividendTokenERC667 is ERC667, Ownable
265 {
266     using SafeMath for uint256;
267 
268     // How dividends work:
269     //
270     // - A "point" is a fraction of a Wei (1e-32), it's used to reduce rounding errors.
271     //
272     // - totalPointsPerToken represents how many points each token is entitled to
273     //   from all the dividends ever received. Each time a new deposit is made, it
274     //   is incremented by the points oweable per token at the time of deposit:
275     //     (depositAmtInWei * POINTS_PER_WEI) / totalSupply
276     //
277     // - Each account has a `creditedPoints` and `lastPointsPerToken`
278     //   - lastPointsPerToken:
279     //       The value of totalPointsPerToken the last time `creditedPoints` was changed.
280     //   - creditedPoints:
281     //       How many points have been credited to the user. This is incremented by:
282     //         (`totalPointsPerToken` - `lastPointsPerToken` * balance) via
283     //         `.updateCreditedPoints(account)`. This occurs anytime the balance changes
284     //         (transfer, mint, burn).
285     //
286     // - .collectOwedDividends() calls .updateCreditedPoints(account), converts points
287     //   to wei and pays account, then resets creditedPoints[account] to 0.
288     //
289     // - "Credit" goes to Nick Johnson for the concept.
290     //
291     uint constant POINTS_PER_WEI = 1e32;
292     uint public dividendsTotal;
293     uint public dividendsCollected;
294     uint public totalPointsPerToken;
295     mapping (address => uint) public creditedPoints;
296     mapping (address => uint) public lastPointsPerToken;
297 
298     // Events
299     event CollectedDividends(uint time, address indexed account, uint amount);
300     event DividendReceived(uint time, address indexed sender, uint amount);
301 
302     constructor(uint256 _totalSupply, address _custom_owner)
303     public
304     ERC667("Noteshares Token", "NST")
305     Ownable(_custom_owner)
306     {
307         totalSupply = _totalSupply;
308     }
309 
310     // Upon receiving payment, increment lastPointsPerToken.
311     function receivePayment()
312     internal
313     {
314         if (msg.value == 0) return;
315         // POINTS_PER_WEI is 1e32.
316         // So, no multiplication overflow unless msg.value > 1e45 wei (1e27 ETH)
317         totalPointsPerToken = totalPointsPerToken.add((msg.value.mul(POINTS_PER_WEI)).div(totalSupply));
318         dividendsTotal = dividendsTotal.add(msg.value);
319         emit DividendReceived(now, msg.sender, msg.value);
320     }
321     /*************************************************************/
322     /********** PUBLIC FUNCTIONS *********************************/
323     /*************************************************************/
324 
325     // Normal ERC20 transfer, except before transferring
326     //  it credits points for both the sender and receiver.
327     function transfer(address _to, uint _value)
328     public
329     returns (bool success)
330     {
331         // ensure tokens are not frozen.
332         _updateCreditedPoints(msg.sender);
333         _updateCreditedPoints(_to);
334         return ERC20.transfer(_to, _value);
335     }
336 
337     // Normal ERC20 transferFrom, except before transferring
338     //  it credits points for both the sender and receiver.
339     function transferFrom(address _from, address _to, uint256 _value)
340     public
341     returns (bool success)
342     {
343         _updateCreditedPoints(_from);
344         _updateCreditedPoints(_to);
345         return ERC20.transferFrom(_from, _to, _value);
346     }
347 
348     // Normal ERC667 transferAndCall, except before transferring
349     //  it credits points for both the sender and receiver.
350     function transferAndCall(address _to, uint _value, bytes _data)
351     public
352     returns (bool success)
353     {
354         _updateCreditedPoints(msg.sender);
355         _updateCreditedPoints(_to);
356         return ERC667.transferAndCall(_to, _value, _data);
357     }
358 
359     // Updates creditedPoints, sends all wei to the owner
360     function collectOwedDividends()
361     internal
362     returns (uint _amount)
363     {
364         // update creditedPoints, store amount, and zero it.
365         _updateCreditedPoints(msg.sender);
366         _amount = creditedPoints[msg.sender].div(POINTS_PER_WEI);
367         creditedPoints[msg.sender] = 0;
368         dividendsCollected = dividendsCollected.add(_amount);
369         emit CollectedDividends(now, msg.sender, _amount);
370         require(msg.sender.call.value(_amount)());
371     }
372 
373 
374     /*************************************************************/
375     /********** PRIVATE METHODS / VIEWS **************************/
376     /*************************************************************/
377     // Credits _account with whatever dividend points they haven't yet been credited.
378     //  This needs to be called before any user's balance changes to ensure their
379     //  "lastPointsPerToken" credits their current balance, and not an altered one.
380     function _updateCreditedPoints(address _account)
381     private
382     {
383         creditedPoints[_account] = creditedPoints[_account].add(_getUncreditedPoints(_account));
384         lastPointsPerToken[_account] = totalPointsPerToken;
385     }
386 
387     // For a given account, returns how many Wei they haven't yet been credited.
388     function _getUncreditedPoints(address _account)
389     private
390     view
391     returns (uint _amount)
392     {
393         uint _pointsPerToken = totalPointsPerToken.sub(lastPointsPerToken[_account]);
394         // The upper bound on this number is:
395         //   ((1e32 * TOTAL_DIVIDEND_AMT) / totalSupply) * balances[_account]
396         // Since totalSupply >= balances[_account], this will overflow only if
397         //   TOTAL_DIVIDEND_AMT is around 1e45 wei. Not ever going to happen.
398         return _pointsPerToken.mul(balanceOf[_account]);
399     }
400 
401 
402     /*************************************************************/
403     /********* CONSTANTS *****************************************/
404     /*************************************************************/
405     // Returns how many wei a call to .collectOwedDividends() would transfer.
406     function getOwedDividends(address _account)
407     public
408     constant
409     returns (uint _amount)
410     {
411         return (_getUncreditedPoints(_account).add(creditedPoints[_account])).div(POINTS_PER_WEI);
412     }
413 }
414 
415 contract NSERC667 is DividendTokenERC667 {
416     using SafeMath for uint256;
417 
418     uint256 private TOTAL_SUPPLY =  100 * (10 ** uint256(decimals)); //always a 100 tokens representing 100% of ownership
419 
420     constructor (address ecosystemFeeAccount, uint256 ecosystemShare, address _custom_owner)
421     public
422     DividendTokenERC667(TOTAL_SUPPLY, _custom_owner)
423     {
424         uint256 ownerSupply = totalSupply.sub(ecosystemShare);
425         balanceOf[owner()] = ownerSupply;
426         balanceOf[ecosystemFeeAccount] = ecosystemShare;
427     }
428 }
429 
430 contract NotesharesToken is NSERC667 {
431     using SafeMath for uint256;
432 
433     uint8 public state; //0 - canceled, 1 - active, 2 - failed, 3 - complete
434 
435     string private contentLink;
436     string private folderLink;
437     bool public hidden = false;
438 
439     constructor (string _contentLink, string _folderLink, address _ecosystemFeeAccount, uint256 ecosystemShare, address _custom_owner)
440     public
441     NSERC667(_ecosystemFeeAccount, ecosystemShare, _custom_owner) {
442         state = 3;
443         contentLink = _contentLink;
444         folderLink = _folderLink;
445     }
446 
447     //payables
448     /**
449      * Main donation function
450      */
451     function () public payable {
452         require(state == 3); //donations only acceptable if contract is complete
453         receivePayment();
454     }
455 
456     function getContentLink () public view returns (string) {
457         require(hidden == false);
458         return contentLink;
459     }
460 
461     function getFolderLink() public view returns (string) {
462         require(hidden == false);
463         return folderLink;
464     }
465     //Contract control
466     /**
467      * Transfers dividend in ETH if contract is complete or remaining funds to investors if contract is failed
468      */
469 
470     function setCancelled () public onlyOwner {
471         state = 0;
472     }
473 
474     function setHidden (bool _hidden) public onlyOwner {
475         hidden = _hidden;
476     }
477 
478     function claimDividend () public {
479         require(state > 1);
480         collectOwedDividends();
481     }
482 
483     //destruction is possible if there is only one owner
484     function destruct () public onlyOwner {
485         require(state == 2 || state == 3);
486         require(balanceOf[owner()] == totalSupply);
487         selfdestruct(owner());
488     }
489 
490     //to claim ownership you should have 100% of tokens
491     function claimOwnership () public {
492         //require(state == 2);
493         require(balanceOf[msg.sender] == totalSupply);
494         _transferOwnership(msg.sender);
495     }
496 }