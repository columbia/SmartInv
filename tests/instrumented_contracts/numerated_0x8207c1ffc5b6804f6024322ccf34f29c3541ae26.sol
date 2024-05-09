1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender)
114     public view returns (uint256);
115 
116   function transferFrom(address from, address to, uint256 value)
117     public returns (bool);
118 
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(
121     address indexed owner,
122     address indexed spender,
123     uint256 value
124   );
125 }
126 
127 contract Pausable is Ownable {
128   event Pause();
129   event Unpause();
130 
131   bool public paused = false;
132 
133 
134   /**
135    * @dev Modifier to make a function callable only when the contract is not paused.
136    */
137   modifier whenNotPaused() {
138     require(!paused);
139     _;
140   }
141 
142   /**
143    * @dev Modifier to make a function callable only when the contract is paused.
144    */
145   modifier whenPaused() {
146     require(paused);
147     _;
148   }
149 
150   /**
151    * @dev called by the owner to pause, triggers stopped state
152    */
153   function pause() onlyOwner whenNotPaused public {
154     paused = true;
155     emit Pause();
156   }
157 
158   /**
159    * @dev called by the owner to unpause, returns to normal state
160    */
161   function unpause() onlyOwner whenPaused public {
162     paused = false;
163     emit Unpause();
164   }
165 }
166 
167 contract DetailedERC20 is ERC20 {
168   string public name;
169   string public symbol;
170   uint8 public decimals;
171 
172   constructor(string _name, string _symbol, uint8 _decimals) public {
173     name = _name;
174     symbol = _symbol;
175     decimals = _decimals;
176   }
177 }
178 
179 contract BasicToken is ERC20Basic {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   uint256 totalSupply_;
185 
186   /**
187   * @dev total number of tokens in existence
188   */
189   function totalSupply() public view returns (uint256) {
190     return totalSupply_;
191   }
192 
193   /**
194   * @dev transfer token for a specified address
195   * @param _to The address to transfer to.
196   * @param _value The amount to be transferred.
197   */
198   function transfer(address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0));
200     require(_value <= balances[msg.sender]);
201 
202     balances[msg.sender] = balances[msg.sender].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     emit Transfer(msg.sender, _to, _value);
205     return true;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param _owner The address to query the the balance of.
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address _owner) public view returns (uint256) {
214     return balances[_owner];
215   }
216 
217 }
218 
219 contract BurnableToken is BasicToken {
220 
221   event Burn(address indexed burner, uint256 value);
222 
223   /**
224    * @dev Burns a specific amount of tokens.
225    * @param _value The amount of token to be burned.
226    */
227   function burn(uint256 _value) public {
228     _burn(msg.sender, _value);
229   }
230 
231   function _burn(address _who, uint256 _value) internal {
232     require(_value <= balances[_who]);
233     // no need to require value <= totalSupply, since that would imply the
234     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
235 
236     balances[_who] = balances[_who].sub(_value);
237     totalSupply_ = totalSupply_.sub(_value);
238     emit Burn(_who, _value);
239     emit Transfer(_who, address(0), _value);
240   }
241 }
242 
243 contract StandardToken is ERC20, BasicToken {
244 
245   mapping (address => mapping (address => uint256)) internal allowed;
246 
247 
248   /**
249    * @dev Transfer tokens from one address to another
250    * @param _from address The address which you want to send tokens from
251    * @param _to address The address which you want to transfer to
252    * @param _value uint256 the amount of tokens to be transferred
253    */
254   function transferFrom(
255     address _from,
256     address _to,
257     uint256 _value
258   )
259     public
260     returns (bool)
261   {
262     require(_to != address(0));
263     require(_value <= balances[_from]);
264     require(_value <= allowed[_from][msg.sender]);
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     emit Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    *
276    * Beware that changing an allowance with this method brings the risk that someone may use both the old
277    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280    * @param _spender The address which will spend the funds.
281    * @param _value The amount of tokens to be spent.
282    */
283   function approve(address _spender, uint256 _value) public returns (bool) {
284     allowed[msg.sender][_spender] = _value;
285     emit Approval(msg.sender, _spender, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Function to check the amount of tokens that an owner allowed to a spender.
291    * @param _owner address The address which owns the funds.
292    * @param _spender address The address which will spend the funds.
293    * @return A uint256 specifying the amount of tokens still available for the spender.
294    */
295   function allowance(
296     address _owner,
297     address _spender
298    )
299     public
300     view
301     returns (uint256)
302   {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * @dev Increase the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseApproval(
317     address _spender,
318     uint _addedValue
319   )
320     public
321     returns (bool)
322   {
323     allowed[msg.sender][_spender] = (
324       allowed[msg.sender][_spender].add(_addedValue));
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329   /**
330    * @dev Decrease the amount of tokens that an owner allowed to a spender.
331    *
332    * approve should be called when allowed[_spender] == 0. To decrement
333    * allowed value is better to use this function to avoid 2 calls (and wait until
334    * the first transaction is mined)
335    * From MonolithDAO Token.sol
336    * @param _spender The address which will spend the funds.
337    * @param _subtractedValue The amount of tokens to decrease the allowance by.
338    */
339   function decreaseApproval(
340     address _spender,
341     uint _subtractedValue
342   )
343     public
344     returns (bool)
345   {
346     uint oldValue = allowed[msg.sender][_spender];
347     if (_subtractedValue > oldValue) {
348       allowed[msg.sender][_spender] = 0;
349     } else {
350       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
351     }
352     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
353     return true;
354   }
355 
356 }
357 
358 contract PausableToken is StandardToken, Pausable {
359 
360   function transfer(
361     address _to,
362     uint256 _value
363   )
364     public
365     whenNotPaused
366     returns (bool)
367   {
368     return super.transfer(_to, _value);
369   }
370 
371   function transferFrom(
372     address _from,
373     address _to,
374     uint256 _value
375   )
376     public
377     whenNotPaused
378     returns (bool)
379   {
380     return super.transferFrom(_from, _to, _value);
381   }
382 
383   function approve(
384     address _spender,
385     uint256 _value
386   )
387     public
388     whenNotPaused
389     returns (bool)
390   {
391     return super.approve(_spender, _value);
392   }
393 
394   function increaseApproval(
395     address _spender,
396     uint _addedValue
397   )
398     public
399     whenNotPaused
400     returns (bool success)
401   {
402     return super.increaseApproval(_spender, _addedValue);
403   }
404 
405   function decreaseApproval(
406     address _spender,
407     uint _subtractedValue
408   )
409     public
410     whenNotPaused
411     returns (bool success)
412   {
413     return super.decreaseApproval(_spender, _subtractedValue);
414   }
415 }
416 
417 contract MintableToken is StandardToken, Ownable {
418   event Mint(address indexed to, uint256 amount);
419   event MintFinished();
420 
421   bool public mintingFinished = false;
422 
423 
424   modifier canMint() {
425     require(!mintingFinished);
426     _;
427   }
428 
429   modifier hasMintPermission() {
430     require(msg.sender == owner);
431     _;
432   }
433 
434   /**
435    * @dev Function to mint tokens
436    * @param _to The address that will receive the minted tokens.
437    * @param _amount The amount of tokens to mint.
438    * @return A boolean that indicates if the operation was successful.
439    */
440   function mint(
441     address _to,
442     uint256 _amount
443   )
444     hasMintPermission
445     canMint
446     public
447     returns (bool)
448   {
449     totalSupply_ = totalSupply_.add(_amount);
450     balances[_to] = balances[_to].add(_amount);
451     emit Mint(_to, _amount);
452     emit Transfer(address(0), _to, _amount);
453     return true;
454   }
455 
456   /**
457    * @dev Function to stop minting new tokens.
458    * @return True if the operation was successful.
459    */
460   function finishMinting() onlyOwner canMint public returns (bool) {
461     mintingFinished = true;
462     emit MintFinished();
463     return true;
464   }
465 }
466 
467 contract WhitelistedPausableToken is PausableToken {
468     // UNIX timestamp (in seconds) after which this whitelist no longer applies
469     uint256 public whitelistExpiration;
470     // While the whitelist is active, either the sender or recipient must be
471     // in allowedTransactors.
472     mapping (address => bool) public allowedTransactors;
473 
474     event SetWhitelistExpiration(uint256 expiration);
475     event AllowedTransactorAdded(address sender);
476     event AllowedTransactorRemoved(address sender);
477 
478     //
479     // Functions for maintaining whitelist
480     //
481 
482     modifier allowedTransfer(address _from, address _to) {
483         require(
484             // solium-disable-next-line operator-whitespace
485             !whitelistActive() ||
486             allowedTransactors[_from] ||
487             allowedTransactors[_to],
488             "neither sender nor recipient are allowed"
489         );
490         _;
491     }
492 
493     function whitelistActive() public view returns (bool) {
494         return block.timestamp < whitelistExpiration;
495     }
496 
497     function addAllowedTransactor(address _transactor) public onlyOwner {
498         emit AllowedTransactorAdded(_transactor);
499         allowedTransactors[_transactor] = true;
500     }
501 
502     function removeAllowedTransactor(address _transactor) public onlyOwner {
503         emit AllowedTransactorRemoved(_transactor);
504         delete allowedTransactors[_transactor];
505     }
506 
507     /**
508     * @dev Set the whitelist expiration, after which the whitelist no longer
509     * applies.
510     */
511     function setWhitelistExpiration(uint256 _expiration) public onlyOwner {
512         // allow only if whitelist expiration hasn't yet been set, or if the
513         // whitelist expiration hasn't passed yet
514         require(
515             whitelistExpiration == 0 || whitelistActive(),
516             "an expired whitelist cannot be extended"
517         );
518         // prevent possible mistakes in calling this function
519         require(
520             _expiration >= block.timestamp + 1 days,
521             "whitelist expiration not far enough into the future"
522         );
523         emit SetWhitelistExpiration(_expiration);
524         whitelistExpiration = _expiration;
525     }
526 
527     //
528     // ERC20 transfer functions that have been overridden to enforce the
529     // whitelist.
530     //
531 
532     function transfer(
533         address _to,
534         uint256 _value
535     )
536         public
537         allowedTransfer(msg.sender, _to)
538         returns (bool)
539     {
540         return super.transfer(_to, _value);
541     }
542 
543     function transferFrom(
544         address _from,
545         address _to,
546         uint256 _value
547     )
548     public
549         allowedTransfer(_from, _to)
550     returns (bool)
551     {
552         return super.transferFrom(_from, _to, _value);
553     }
554 }
555 
556 contract OriginToken is BurnableToken, MintableToken, WhitelistedPausableToken, DetailedERC20 {
557     event AddCallSpenderWhitelist(address enabler, address spender);
558     event RemoveCallSpenderWhitelist(address disabler, address spender);
559 
560     mapping (address => bool) public callSpenderWhitelist;
561 
562     // @dev Constructor that gives msg.sender all initial tokens.
563     constructor(uint256 _initialSupply) DetailedERC20("OriginToken", "OGN", 18) public {
564         owner = msg.sender;
565         mint(owner, _initialSupply);
566     }
567 
568     //
569     // Burn methods
570     //
571 
572     // @dev Burns tokens belonging to the sender
573     // @param _value Amount of token to be burned
574     function burn(uint256 _value) public onlyOwner {
575         // TODO: add a function & modifier to enable for all accounts without doing
576         // a contract migration?
577         super.burn(_value);
578     }
579 
580     // @dev Burns tokens belonging to the specified address
581     // @param _who The account whose tokens we're burning
582     // @param _value Amount of token to be burned
583     function burn(address _who, uint256 _value) public onlyOwner {
584         _burn(_who, _value);
585     }
586 
587     //
588     // approveAndCall methods
589     //
590 
591     // @dev Add spender to whitelist of spenders for approveAndCall
592     // @param _spender Address to add
593     function addCallSpenderWhitelist(address _spender) public onlyOwner {
594         callSpenderWhitelist[_spender] = true;
595         emit AddCallSpenderWhitelist(msg.sender, _spender);
596     }
597 
598     // @dev Remove spender from whitelist of spenders for approveAndCall
599     // @param _spender Address to remove
600     function removeCallSpenderWhitelist(address _spender) public onlyOwner {
601         delete callSpenderWhitelist[_spender];
602         emit RemoveCallSpenderWhitelist(msg.sender, _spender);
603     }
604 
605     // @dev Approve transfer of tokens and make a contract call in a single
606     // @dev transaction. This allows a DApp to avoid requiring two MetaMask
607     // @dev approvals for a single logical action, such as creating a listing,
608     // @dev which requires the seller to approve a token transfer and the
609     // @dev marketplace contract to transfer tokens from the seller.
610     //
611     // @dev This is based on the ERC827 function approveAndCall and avoids
612     // @dev security issues by only working with a whitelisted set of _spender
613     // @dev addresses. The other difference is that the combination of this
614     // @dev function ensures that the proxied function call receives the
615     // @dev msg.sender for this function as its first parameter.
616     //
617     // @param _spender The address that will spend the funds.
618     // @param _value The amount of tokens to be spent.
619     // @param _selector Function selector for function to be called.
620     // @param _callParams Packed, encoded parameters, omitting the first parameter which is always msg.sender
621     function approveAndCallWithSender(
622         address _spender,
623         uint256 _value,
624         bytes4 _selector,
625         bytes _callParams
626     )
627         public
628         payable
629         returns (bool)
630     {
631         require(_spender != address(this), "token contract can't be approved");
632         require(callSpenderWhitelist[_spender], "spender not in whitelist");
633 
634         require(super.approve(_spender, _value), "approve failed");
635 
636         bytes memory callData = abi.encodePacked(_selector, uint256(msg.sender), _callParams);
637         // solium-disable-next-line security/no-call-value
638         require(_spender.call.value(msg.value)(callData), "proxied call failed");
639         return true;
640     }
641 }