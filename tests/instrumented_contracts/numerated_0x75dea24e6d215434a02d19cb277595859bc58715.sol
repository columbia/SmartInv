1 pragma solidity ^0.4.19;
2 
3 
4 contract OwnableToken {
5     mapping (address => bool) owners;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8     event OwnershipExtended(address indexed host, address indexed guest);
9 
10     modifier onlyOwner() {
11         require(owners[msg.sender]);
12         _;
13     }
14 
15     function OwnableToken() public {
16         owners[msg.sender] = true;
17     }
18 
19     function addOwner(address guest) public onlyOwner {
20         require(guest != address(0));
21         owners[guest] = true;
22         emit OwnershipExtended(msg.sender, guest);
23     }
24 
25     function transferOwnership(address newOwner) public onlyOwner {
26         require(newOwner != address(0));
27         owners[newOwner] = true;
28         delete owners[msg.sender];
29         emit OwnershipTransferred(msg.sender, newOwner);
30     }
31 }
32 
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44     if (a == 0) {
45       return 0;
46     }
47     uint256 c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     // SafeMath.sub will throw if there is not enough balance.
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/20
143  */
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public view returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 /**
153  * @title Standard ERC20 token
154  *
155  * @dev Implementation of the basic standard token.
156  * @dev https://github.com/ethereum/EIPs/issues/20
157  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
158  */
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171     require(_to != address(0));
172     require(_value <= balances[_from]);
173     require(_value <= allowed[_from][msg.sender]);
174 
175     balances[_from] = balances[_from].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178     Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184    *
185    * Beware that changing an allowance with this method brings the risk that someone may use both the old
186    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
187    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
188    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189    * @param _spender The address which will spend the funds.
190    * @param _value The amount of tokens to be spent.
191    */
192   function approve(address _spender, uint256 _value) public returns (bool) {
193     allowed[msg.sender][_spender] = _value;
194     Approval(msg.sender, _spender, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Function to check the amount of tokens that an owner allowed to a spender.
200    * @param _owner address The address which owns the funds.
201    * @param _spender address The address which will spend the funds.
202    * @return A uint256 specifying the amount of tokens still available for the spender.
203    */
204   function allowance(address _owner, address _spender) public view returns (uint256) {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
219     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224   /**
225    * @dev Decrease the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 // File: contracts/token/ABL.sol
248 
249 contract ABL is StandardToken, OwnableToken {
250     using SafeMath for uint256;
251 
252     // Token Distribution Rate
253     uint256 public constant SUM = 400000000;   // totalSupply
254     uint256 public constant DISTRIBUTION = 221450000; // distribution
255     uint256 public constant DEVELOPERS = 178550000;   // developer
256 
257     // Token Information
258     string public constant name = "Airbloc";
259     string public constant symbol = "ABL";
260     uint256 public constant decimals = 18;
261     uint256 public totalSupply = SUM.mul(10 ** uint256(decimals));
262 
263     // token is non-transferable until owner calls unlock()
264     // (to prevent OTC before the token to be listed on exchanges)
265     bool isTransferable = false;
266 
267     function ABL(
268         address _dtb,
269         address _dev
270         ) public {
271         require(_dtb != address(0));
272         require(_dev != address(0));
273         require(DISTRIBUTION + DEVELOPERS == SUM);
274 
275         balances[_dtb] = DISTRIBUTION.mul(10 ** uint256(decimals));
276         emit Transfer(address(0), _dtb, balances[_dtb]);
277 
278         balances[_dev] = DEVELOPERS.mul(10 ** uint256(decimals));
279         emit Transfer(address(0), _dev, balances[_dev]);
280     }
281 
282     function unlock() external onlyOwner {
283         isTransferable = true;
284     }
285 
286     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
287         require(isTransferable || owners[msg.sender]);
288         return super.transferFrom(_from, _to, _value);
289     }
290 
291     function transfer(address _to, uint256 _value) public returns (bool) {
292         require(isTransferable || owners[msg.sender]);
293         return super.transfer(_to, _value);
294     }
295 
296 //////////////////////
297 //  mint and burn   //
298 //////////////////////
299     function mint(
300         address _to,
301         uint256 _amount
302         ) onlyOwner public returns (bool) {
303         require(_to != address(0));
304         require(_amount >= 0);
305 
306         uint256 amount = _amount.mul(10 ** uint256(decimals));
307 
308         totalSupply = totalSupply.add(amount);
309         balances[_to] = balances[_to].add(amount);
310 
311         emit Mint(_to, amount);
312         emit Transfer(address(0), _to, amount);
313 
314         return true;
315     }
316 
317     function burn(
318         uint256 _amount
319         ) onlyOwner public {
320         require(_amount >= 0);
321         require(_amount <= balances[msg.sender]);
322 
323         totalSupply = totalSupply.sub(_amount.mul(10 ** uint256(decimals)));
324         balances[msg.sender] = balances[msg.sender].sub(_amount.mul(10 ** uint256(decimals)));
325 
326         emit Burn(msg.sender, _amount.mul(10 ** uint256(decimals)));
327         emit Transfer(msg.sender, address(0), _amount.mul(10 ** uint256(decimals)));
328     }
329 
330     event Mint(address indexed _to, uint256 _amount);
331     event Burn(address indexed _from, uint256 _amount);
332 }
333 
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341   address public owner;
342 
343 
344   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346 
347   /**
348    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
349    * account.
350    */
351   function Ownable() public {
352     owner = msg.sender;
353   }
354 
355   /**
356    * @dev Throws if called by any account other than the owner.
357    */
358   modifier onlyOwner() {
359     require(msg.sender == owner);
360     _;
361   }
362 
363   /**
364    * @dev Allows the current owner to transfer control of the contract to a newOwner.
365    * @param newOwner The address to transfer ownership to.
366    */
367   function transferOwnership(address newOwner) public onlyOwner {
368     require(newOwner != address(0));
369     OwnershipTransferred(owner, newOwner);
370     owner = newOwner;
371   }
372 
373 }
374 
375 
376 /**
377  * @title Pausable
378  * @dev Base contract which allows children to implement an emergency stop mechanism.
379  */
380 contract Pausable is Ownable {
381   event Pause();
382   event Unpause();
383 
384   bool public paused = false;
385 
386 
387   /**
388    * @dev Modifier to make a function callable only when the contract is not paused.
389    */
390   modifier whenNotPaused() {
391     require(!paused);
392     _;
393   }
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is paused.
397    */
398   modifier whenPaused() {
399     require(paused);
400     _;
401   }
402 
403   /**
404    * @dev called by the owner to pause, triggers stopped state
405    */
406   function pause() onlyOwner whenNotPaused public {
407     paused = true;
408     Pause();
409   }
410 
411   /**
412    * @dev called by the owner to unpause, returns to normal state
413    */
414   function unpause() onlyOwner whenPaused public {
415     paused = false;
416     Unpause();
417   }
418 }
419 
420 
421 /**
422  * @title Whitelist
423  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
424  * @dev This simplifies the implementation of "user permissions".
425  */
426 contract Whitelist is Ownable {
427   mapping(address => bool) public whitelist;
428 
429   event WhitelistedAddressAdded(address addr);
430   event WhitelistedAddressRemoved(address addr);
431 
432   /**
433    * @dev Throws if called by any account that's not whitelisted.
434    */
435   modifier onlyWhitelisted() {
436     require(whitelist[msg.sender]);
437     _;
438   }
439 
440   /**
441    * @dev add an address to the whitelist
442    * @param addr address
443    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
444    */
445   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
446     if (!whitelist[addr]) {
447       whitelist[addr] = true;
448       WhitelistedAddressAdded(addr);
449       success = true;
450     }
451   }
452 
453   /**
454    * @dev add addresses to the whitelist
455    * @param addrs addresses
456    * @return true if at least one address was added to the whitelist,
457    * false if all addresses were already in the whitelist
458    */
459   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
460     for (uint256 i = 0; i < addrs.length; i++) {
461       if (addAddressToWhitelist(addrs[i])) {
462         success = true;
463       }
464     }
465   }
466 
467   /**
468    * @dev remove an address from the whitelist
469    * @param addr address
470    * @return true if the address was removed from the whitelist,
471    * false if the address wasn't in the whitelist in the first place
472    */
473   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
474     if (whitelist[addr]) {
475       whitelist[addr] = false;
476       WhitelistedAddressRemoved(addr);
477       success = true;
478     }
479   }
480 
481   /**
482    * @dev remove addresses from the whitelist
483    * @param addrs addresses
484    * @return true if at least one address was removed from the whitelist,
485    * false if all addresses weren't in the whitelist in the first place
486    */
487   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
488     for (uint256 i = 0; i < addrs.length; i++) {
489       if (removeAddressFromWhitelist(addrs[i])) {
490         success = true;
491       }
492     }
493   }
494 
495 }
496 
497 
498 /**
499  * @title SafeERC20
500  * @dev Wrappers around ERC20 operations that throw on failure.
501  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
502  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
503  */
504 library SafeERC20 {
505   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
506     assert(token.transfer(to, value));
507   }
508 
509   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
510     assert(token.transferFrom(from, to, value));
511   }
512 
513   function safeApprove(ERC20 token, address spender, uint256 value) internal {
514     assert(token.approve(spender, value));
515   }
516 }
517 
518 
519 contract PresaleFirst is Whitelist, Pausable {
520     using SafeMath for uint256;
521     using SafeERC20 for ERC20;
522 
523     uint256 public constant maxcap = 1500 ether;
524     uint256 public constant exceed = 300 ether;
525     uint256 public constant minimum = 0.5 ether;
526     uint256 public constant rate = 11500;
527 
528     uint256 public startNumber;
529     uint256 public endNumber;
530     uint256 public weiRaised;
531     address public wallet;
532     ERC20 public token;
533 
534     function PresaleFirst (
535         uint256 _startNumber,
536         uint256 _endNumber,
537         address _wallet,
538         address _token
539         ) public {
540         require(_wallet != address(0));
541         require(_token != address(0));
542 
543         startNumber = _startNumber;
544         endNumber = _endNumber;
545         wallet = _wallet;
546         token = ERC20(_token);
547         weiRaised = 0;
548     }
549 
550 //////////////////
551 //  collect eth
552 //////////////////
553 
554     mapping (address => uint256) public buyers;
555     address[] private keys;
556 
557     function () external payable {
558         collect(msg.sender);
559     }
560 
561     function collect(address _buyer) public payable onlyWhitelisted whenNotPaused {
562         require(_buyer != address(0));
563         require(weiRaised <= maxcap);
564         require(preValidation());
565         require(buyers[_buyer] < exceed);
566 
567         // get exist amount
568         if(buyers[_buyer] == 0) {
569             keys.push(_buyer);
570         }
571 
572         uint256 purchase = getPurchaseAmount(_buyer);
573         uint256 refund = (msg.value).sub(purchase);
574 
575         // refund
576         _buyer.transfer(refund);
577 
578         // buy
579         uint256 tokenAmount = purchase.mul(rate);
580         weiRaised = weiRaised.add(purchase);
581 
582         // wallet
583         buyers[_buyer] = buyers[_buyer].add(purchase);
584         emit BuyTokens(_buyer, purchase, tokenAmount);
585     }
586 
587 //////////////////
588 //  validation functions for collect
589 //////////////////
590 
591     function preValidation() private constant returns (bool) {
592         // check minimum
593         bool a = msg.value >= minimum;
594 
595         // sale duration
596         bool b = block.number >= startNumber && block.number <= endNumber;
597 
598         return a && b;
599     }
600 
601     function getPurchaseAmount(address _buyer) private constant returns (uint256) {
602         return checkOverMaxcap(checkOverExceed(_buyer));
603     }
604 
605     // 1. check over exceed
606     function checkOverExceed(address _buyer) private constant returns (uint256) {
607         if(msg.value >= exceed) {
608             return exceed;
609         } else if(msg.value.add(buyers[_buyer]) >= exceed) {
610             return exceed.sub(buyers[_buyer]);
611         } else {
612             return msg.value;
613         }
614     }
615 
616     // 2. check sale hardcap
617     function checkOverMaxcap(uint256 amount) private constant returns (uint256) {
618         if((amount + weiRaised) >= maxcap) {
619             return (maxcap.sub(weiRaised));
620         } else {
621             return amount;
622         }
623     }
624 
625 //////////////////
626 //  release
627 //////////////////
628     bool finalized = false;
629 
630     function release() external onlyOwner {
631         require(!finalized);
632         require(weiRaised >= maxcap || block.number >= endNumber);
633 
634         wallet.transfer(address(this).balance);
635 
636         for(uint256 i = 0; i < keys.length; i++) {
637             token.safeTransfer(keys[i], buyers[keys[i]].mul(rate));
638             emit Release(keys[i], buyers[keys[i]].mul(rate));
639         }
640 
641         withdraw();
642 
643         finalized = true;
644     }
645 
646     function refund() external onlyOwner {
647         require(!finalized);
648         pause();
649 
650         withdraw();
651 
652         for(uint256 i = 0; i < keys.length; i++) {
653             keys[i].transfer(buyers[keys[i]]);
654             emit Refund(keys[i], buyers[keys[i]]);
655         }
656 
657         finalized = true;
658     }
659 
660     function withdraw() public onlyOwner {
661         token.safeTransfer(wallet, token.balanceOf(this));
662         emit Withdraw(wallet, token.balanceOf(this));
663     }
664 
665 //////////////////
666 //  events
667 //////////////////
668 
669     event Release(address indexed _to, uint256 _amount);
670     event Withdraw(address indexed _from, uint256 _amount);
671     event Refund(address indexed _to, uint256 _amount);
672     event BuyTokens(address indexed buyer, uint256 price, uint256 tokens);
673 }