1 pragma solidity ^0.4.13;
2 
3 contract PolicyPalNetworkAirdrop {
4     struct BountyType {
5       bool twitter;
6       bool signature;
7     }
8 
9     /**
10     * @dev Air drop Public Variables
11     */
12     address                         public admin;
13     PolicyPalNetworkToken           public token;
14     mapping(address => bool)        public airdrops;
15     mapping(address => bool)        public twitterdrops;
16     mapping(address => bool)        public signaturedrops;
17     uint256                         public numDrops;
18     uint256                         public dropAmount;
19 
20     using SafeMath for uint256;
21 
22     /**
23     * @dev   Token Contract Modifier
24     * Check if only admin
25     *
26     */
27     modifier onlyAdmin() {
28       require(msg.sender == admin);
29       _;
30     }
31 
32     /**
33     * @dev   Token Contract Modifier
34     * Check if valid address
35     *
36     * @param _addr - The address to check
37     *
38     */
39     modifier validAddress(address _addr) {
40         require(_addr != address(0x0));
41         require(_addr != address(this));
42         _;
43     }
44 
45     /**
46     * @dev   Token Contract Modifier
47     * Check if the batch transfer amount is
48     * equal or more than balance
49     * (For single batch amount)
50     *
51     * @param _recipients - The recipients to send
52     * @param _amount - The amount to send
53     *
54     */
55     modifier validBalance(address[] _recipients, uint256 _amount) {
56         // Assert balance
57         uint256 balance = token.balanceOf(this);
58         require(balance > 0);
59         require(balance >= _recipients.length.mul(_amount));
60         _;
61     }
62 
63     /**
64     * @dev   Token Contract Modifier
65     * Check if the batch transfer amount is
66     * equal or more than balance
67     * (For multiple batch amounts)
68     *
69     * @param _recipients - The recipients to send
70     * @param _amounts - The amounts to send
71     *
72     */
73     modifier validBalanceMultiple(address[] _recipients, uint256[] _amounts) {
74         // Assert balance
75         uint256 balance = token.balanceOf(this);
76         require(balance > 0);
77 
78         uint256 totalAmount;
79         for (uint256 i = 0 ; i < _recipients.length ; i++) {
80             totalAmount = totalAmount.add(_amounts[i]);
81         }
82         require(balance >= totalAmount);
83         _;
84     }
85 
86     /**
87     * @dev Airdrop Contract Constructor
88     * @param _token - PPN Token address
89     * @param _adminAddr - Address of the Admin
90     */
91     function PolicyPalNetworkAirdrop(
92         PolicyPalNetworkToken _token, 
93         address _adminAddr
94     )
95         public
96         validAddress(_adminAddr)
97         validAddress(_token)
98     {
99         // Assign addresses
100         admin = _adminAddr;
101         token = _token;
102     }
103     
104     /**
105      * @dev TokenDrop Event
106      */
107     event TokenDrop(address _receiver, uint _amount, string _type);
108 
109     /**
110      * @dev Air Drop batch by single amount
111      * @param _recipients - Address of the recipient
112      * @param _amount - Amount to transfer used in this batch
113      */
114     function airDropSingleAmount(address[] _recipients, uint256 _amount) external
115         onlyAdmin
116         validBalance(_recipients, _amount)
117     {
118         // Loop through all recipients
119         for (uint256 i = 0 ; i < _recipients.length ; i++) {
120             address recipient = _recipients[i];
121             // If recipient not transfered yet
122             if (!airdrops[recipient]) {
123                 // Transfer amount
124                 assert(token.transfer(recipient, _amount));
125                 // Flag as transfered
126                 airdrops[recipient] = true;
127                 // Increment number of drops and total amount
128                 numDrops = numDrops.add(1);
129                 dropAmount = dropAmount.add(_amount);
130                 // TokenDrop event
131                 TokenDrop(recipient, _amount, "AIRDROP");
132             }
133         }
134     }
135 
136     /**
137      * @dev Air Drop batch by single amount
138      * @param _recipients - Address of the recipient
139      * @param _amounts - Amount to transfer used in this batch
140      */
141     function airDropMultipleAmount(address[] _recipients, uint256[] _amounts) external
142         onlyAdmin
143         validBalanceMultiple(_recipients, _amounts)
144     {
145         // Loop through all recipients
146         for (uint256 i = 0 ; i < _recipients.length ; i++) {
147             address recipient = _recipients[i];
148             uint256 amount = _amounts[i];
149             // If recipient not transfered yet
150             if (!airdrops[recipient]) {
151                 // Transfer amount
152                 assert(token.transfer(recipient, amount));
153                 // Flag as transfered
154                 airdrops[recipient] = true;
155                 // Increment number of drops and total amount
156                 numDrops = numDrops.add(1);
157                 dropAmount = dropAmount.add(amount);
158                 // TokenDrop event
159                 TokenDrop(recipient, amount, "AIRDROP");
160             }
161         }
162     }
163 
164     /**
165      * @dev Twitter Bounty Drop batch by single amount
166      * @param _recipients - Address of the recipient
167      * @param _amount - Amount to transfer used in this batch
168      */
169     function twitterDropSingleAmount(address[] _recipients, uint256 _amount) external
170         onlyAdmin
171         validBalance(_recipients, _amount)
172     {
173         // Loop through all recipients
174         for (uint256 i = 0 ; i < _recipients.length ; i++) {
175             address recipient = _recipients[i];
176             // If recipient not transfered yet
177             if (!twitterdrops[recipient]) {
178               // Transfer amount
179               assert(token.transfer(recipient, _amount));
180               // Flag as transfered
181               twitterdrops[recipient] = true;
182               // Increment number of drops and total amount
183               numDrops = numDrops.add(1);
184               dropAmount = dropAmount.add(_amount);
185               // TokenDrop event
186               TokenDrop(recipient, _amount, "TWITTER");
187             }
188         }
189     }
190 
191     /**
192      * @dev Twitter Bounty Drop batch by single amount
193      * @param _recipients - Address of the recipient
194      * @param _amounts - Amount to transfer used in this batch
195      */
196     function twitterDropMultipleAmount(address[] _recipients, uint256[] _amounts) external
197         onlyAdmin
198         validBalanceMultiple(_recipients, _amounts)
199     {
200         // Loop through all recipients
201         for (uint256 i = 0 ; i < _recipients.length ; i++) {
202             address recipient = _recipients[i];
203             uint256 amount = _amounts[i];
204             // If recipient not transfered yet
205             if (!twitterdrops[recipient]) {
206               // Transfer amount
207               assert(token.transfer(recipient, amount));
208               // Flag as transfered
209               twitterdrops[recipient] = true;
210               // Increment number of drops and total amount
211               numDrops = numDrops.add(1);
212               dropAmount = dropAmount.add(amount);
213               // TokenDrop event
214               TokenDrop(recipient, amount, "TWITTER");
215             }
216         }
217     }
218 
219     /**
220      * @dev Signature Bounty Drop batch by single amount
221      * @param _recipients - Address of the recipient
222      * @param _amount - Amount to transfer used in this batch
223      */
224     function signatureDropSingleAmount(address[] _recipients, uint256 _amount) external
225         onlyAdmin
226         validBalance(_recipients, _amount)
227     {
228         // Loop through all recipients
229         for (uint256 i = 0 ; i < _recipients.length ; i++) {
230             address recipient = _recipients[i];
231             // If recipient not transfered yet
232             if (!signaturedrops[recipient]) {
233               // Transfer amount
234               assert(token.transfer(recipient, _amount));
235               // Flag as transfered
236               signaturedrops[recipient] = true;
237               // Increment number of drops and total amount
238               numDrops = numDrops.add(1);
239               dropAmount = dropAmount.add(_amount);
240               // TokenDrop event
241               TokenDrop(recipient, _amount, "SIGNATURE");
242             }
243         }
244     }
245 
246     /**
247      * @dev Signature Bounty Drop batch by single amount
248      * @param _recipients - Address of the recipient
249      * @param _amounts - Amount to transfer used in this batch
250      */
251     function signatureDropMultipleAmount(address[] _recipients, uint256[] _amounts) external
252         onlyAdmin
253         validBalanceMultiple(_recipients, _amounts)
254     {
255         // Loop through all recipients
256         for (uint256 i = 0 ; i < _recipients.length ; i++) {
257             address recipient = _recipients[i];
258             uint256 amount = _amounts[i];
259             // If recipient not transfered yet
260             if (!signaturedrops[recipient]) {
261               // Transfer amount
262               assert(token.transfer(recipient, amount));
263               // Flag as transfered
264               signaturedrops[recipient] = true;
265               // Increment number of drops and total amount
266               numDrops = numDrops.add(1);
267               dropAmount = dropAmount.add(amount);
268               // TokenDrop event
269               TokenDrop(recipient, amount, "SIGNATURE");
270             }
271         }
272     }
273 
274     /**
275      * @dev Emergency drain of tokens
276      * @param _recipient - Address of the recipient
277      * @param _amount - Amount to drain
278      */
279     function emergencyDrain(address _recipient, uint256 _amount) external
280       onlyAdmin
281     {
282         assert(token.transfer(_recipient, _amount));
283     }
284 }
285 
286 library SafeMath {
287 
288   /**
289   * @dev Multiplies two numbers, throws on overflow.
290   */
291   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292     if (a == 0) {
293       return 0;
294     }
295     uint256 c = a * b;
296     assert(c / a == b);
297     return c;
298   }
299 
300   /**
301   * @dev Integer division of two numbers, truncating the quotient.
302   */
303   function div(uint256 a, uint256 b) internal pure returns (uint256) {
304     // assert(b > 0); // Solidity automatically throws when dividing by 0
305     uint256 c = a / b;
306     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307     return c;
308   }
309 
310   /**
311   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
312   */
313   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314     assert(b <= a);
315     return a - b;
316   }
317 
318   /**
319   * @dev Adds two numbers, throws on overflow.
320   */
321   function add(uint256 a, uint256 b) internal pure returns (uint256) {
322     uint256 c = a + b;
323     assert(c >= a);
324     return c;
325   }
326 }
327 
328 contract Ownable {
329   address public owner;
330 
331 
332   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334 
335   /**
336    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
337    * account.
338    */
339   function Ownable() public {
340     owner = msg.sender;
341   }
342 
343   /**
344    * @dev Throws if called by any account other than the owner.
345    */
346   modifier onlyOwner() {
347     require(msg.sender == owner);
348     _;
349   }
350 
351   /**
352    * @dev Allows the current owner to transfer control of the contract to a newOwner.
353    * @param newOwner The address to transfer ownership to.
354    */
355   function transferOwnership(address newOwner) public onlyOwner {
356     require(newOwner != address(0));
357     OwnershipTransferred(owner, newOwner);
358     owner = newOwner;
359   }
360 
361 }
362 
363 contract ERC20Basic {
364   function totalSupply() public view returns (uint256);
365   function balanceOf(address who) public view returns (uint256);
366   function transfer(address to, uint256 value) public returns (bool);
367   event Transfer(address indexed from, address indexed to, uint256 value);
368 }
369 
370 contract BasicToken is ERC20Basic {
371   using SafeMath for uint256;
372 
373   mapping(address => uint256) balances;
374 
375   uint256 totalSupply_;
376 
377   /**
378   * @dev total number of tokens in existence
379   */
380   function totalSupply() public view returns (uint256) {
381     return totalSupply_;
382   }
383 
384   /**
385   * @dev transfer token for a specified address
386   * @param _to The address to transfer to.
387   * @param _value The amount to be transferred.
388   */
389   function transfer(address _to, uint256 _value) public returns (bool) {
390     require(_to != address(0));
391     require(_value <= balances[msg.sender]);
392 
393     // SafeMath.sub will throw if there is not enough balance.
394     balances[msg.sender] = balances[msg.sender].sub(_value);
395     balances[_to] = balances[_to].add(_value);
396     Transfer(msg.sender, _to, _value);
397     return true;
398   }
399 
400   /**
401   * @dev Gets the balance of the specified address.
402   * @param _owner The address to query the the balance of.
403   * @return An uint256 representing the amount owned by the passed address.
404   */
405   function balanceOf(address _owner) public view returns (uint256 balance) {
406     return balances[_owner];
407   }
408 
409 }
410 
411 contract BurnableToken is BasicToken {
412 
413   event Burn(address indexed burner, uint256 value);
414 
415   /**
416    * @dev Burns a specific amount of tokens.
417    * @param _value The amount of token to be burned.
418    */
419   function burn(uint256 _value) public {
420     require(_value <= balances[msg.sender]);
421     // no need to require value <= totalSupply, since that would imply the
422     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
423 
424     address burner = msg.sender;
425     balances[burner] = balances[burner].sub(_value);
426     totalSupply_ = totalSupply_.sub(_value);
427     Burn(burner, _value);
428   }
429 }
430 
431 contract ERC20 is ERC20Basic {
432   function allowance(address owner, address spender) public view returns (uint256);
433   function transferFrom(address from, address to, uint256 value) public returns (bool);
434   function approve(address spender, uint256 value) public returns (bool);
435   event Approval(address indexed owner, address indexed spender, uint256 value);
436 }
437 
438 contract StandardToken is ERC20, BasicToken {
439 
440   mapping (address => mapping (address => uint256)) internal allowed;
441 
442 
443   /**
444    * @dev Transfer tokens from one address to another
445    * @param _from address The address which you want to send tokens from
446    * @param _to address The address which you want to transfer to
447    * @param _value uint256 the amount of tokens to be transferred
448    */
449   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
450     require(_to != address(0));
451     require(_value <= balances[_from]);
452     require(_value <= allowed[_from][msg.sender]);
453 
454     balances[_from] = balances[_from].sub(_value);
455     balances[_to] = balances[_to].add(_value);
456     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
457     Transfer(_from, _to, _value);
458     return true;
459   }
460 
461   /**
462    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
463    *
464    * Beware that changing an allowance with this method brings the risk that someone may use both the old
465    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
466    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
467    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
468    * @param _spender The address which will spend the funds.
469    * @param _value The amount of tokens to be spent.
470    */
471   function approve(address _spender, uint256 _value) public returns (bool) {
472     allowed[msg.sender][_spender] = _value;
473     Approval(msg.sender, _spender, _value);
474     return true;
475   }
476 
477   /**
478    * @dev Function to check the amount of tokens that an owner allowed to a spender.
479    * @param _owner address The address which owns the funds.
480    * @param _spender address The address which will spend the funds.
481    * @return A uint256 specifying the amount of tokens still available for the spender.
482    */
483   function allowance(address _owner, address _spender) public view returns (uint256) {
484     return allowed[_owner][_spender];
485   }
486 
487   /**
488    * @dev Increase the amount of tokens that an owner allowed to a spender.
489    *
490    * approve should be called when allowed[_spender] == 0. To increment
491    * allowed value is better to use this function to avoid 2 calls (and wait until
492    * the first transaction is mined)
493    * From MonolithDAO Token.sol
494    * @param _spender The address which will spend the funds.
495    * @param _addedValue The amount of tokens to increase the allowance by.
496    */
497   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
498     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
499     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
500     return true;
501   }
502 
503   /**
504    * @dev Decrease the amount of tokens that an owner allowed to a spender.
505    *
506    * approve should be called when allowed[_spender] == 0. To decrement
507    * allowed value is better to use this function to avoid 2 calls (and wait until
508    * the first transaction is mined)
509    * From MonolithDAO Token.sol
510    * @param _spender The address which will spend the funds.
511    * @param _subtractedValue The amount of tokens to decrease the allowance by.
512    */
513   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
514     uint oldValue = allowed[msg.sender][_spender];
515     if (_subtractedValue > oldValue) {
516       allowed[msg.sender][_spender] = 0;
517     } else {
518       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
519     }
520     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
521     return true;
522   }
523 
524 }
525 
526 contract PolicyPalNetworkToken is StandardToken, BurnableToken, Ownable {
527     /**
528     * @dev Token Contract Constants
529     */
530     string    public constant name     = "PolicyPal Network Token";
531     string    public constant symbol   = "PAL";
532     uint8     public constant decimals = 18;
533 
534     /**
535     * @dev Token Contract Public Variables
536     */
537     address public  tokenSaleContract;
538     bool    public  isTokenTransferable = false;
539 
540 
541     /**
542     * @dev   Token Contract Modifier
543     *
544     * Check if a transfer is allowed
545     * Transfers are restricted to token creator & owner(admin) during token sale duration
546     * Transfers after token sale is limited by `isTokenTransferable` toggle
547     *
548     */
549     modifier onlyWhenTransferAllowed() {
550         require(isTokenTransferable || msg.sender == owner || msg.sender == tokenSaleContract);
551         _;
552     }
553 
554     /**
555      * @dev Token Contract Modifier
556      * @param _to - Address to check if valid
557      *
558      *  Check if an address is valid
559      *  A valid address is as follows,
560      *    1. Not zero address
561      *    2. Not token address
562      *
563      */
564     modifier isValidDestination(address _to) {
565         require(_to != address(0x0));
566         require(_to != address(this));
567         _;
568     }
569 
570     /**
571      * @dev Enable Transfers (Only Owner)
572      */
573     function toggleTransferable(bool _toggle) external
574         onlyOwner
575     {
576         isTokenTransferable = _toggle;
577     }
578     
579 
580     /**
581     * @dev Token Contract Constructor
582     * @param _adminAddr - Address of the Admin
583     */
584     function PolicyPalNetworkToken(
585         uint _tokenTotalAmount,
586         address _adminAddr
587     ) 
588         public
589         isValidDestination(_adminAddr)
590     {
591         require(_tokenTotalAmount > 0);
592 
593         totalSupply_ = _tokenTotalAmount;
594 
595         // Mint all token
596         balances[msg.sender] = _tokenTotalAmount;
597         Transfer(address(0x0), msg.sender, _tokenTotalAmount);
598 
599         // Assign token sale contract to creator
600         tokenSaleContract = msg.sender;
601 
602         // Transfer contract ownership to admin
603         transferOwnership(_adminAddr);
604     }
605 
606     /**
607     * @dev Token Contract transfer
608     * @param _to - Address to transfer to
609     * @param _value - Value to transfer
610     * @return bool - Result of transfer
611     * "Overloaded" Function of ERC20Basic's transfer
612     *
613     */
614     function transfer(address _to, uint256 _value) public
615         onlyWhenTransferAllowed
616         isValidDestination(_to)
617         returns (bool)
618     {
619         return super.transfer(_to, _value);
620     }
621 
622     /**
623     * @dev Token Contract transferFrom
624     * @param _from - Address to transfer from
625     * @param _to - Address to transfer to
626     * @param _value - Value to transfer
627     * @return bool - Result of transferFrom
628     *
629     * "Overloaded" Function of ERC20's transferFrom
630     * Added with modifiers,
631     *    1. onlyWhenTransferAllowed
632     *    2. isValidDestination
633     *
634     */
635     function transferFrom(address _from, address _to, uint256 _value) public
636         onlyWhenTransferAllowed
637         isValidDestination(_to)
638         returns (bool)
639     {
640         return super.transferFrom(_from, _to, _value);
641     }
642 
643     /**
644     * @dev Token Contract burn
645     * @param _value - Value to burn
646     * "Overloaded" Function of BurnableToken's burn
647     */
648     function burn(uint256 _value)
649         public
650     {
651         super.burn(_value);
652         Transfer(msg.sender, address(0x0), _value);
653     }
654 
655     /**
656     * @dev Token Contract Emergency Drain
657     * @param _token - Token to drain
658     * @param _amount - Amount to drain
659     */
660     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public
661         onlyOwner
662     {
663         _token.transfer(owner, _amount);
664     }
665 }