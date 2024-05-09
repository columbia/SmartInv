1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title MultiOwnable
17  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
18  * functions, this simplifies the implementation of "users permissions".
19  */
20 contract MultiOwnable {
21   address public manager; // address used to set owners
22   address[] public owners;
23   mapping(address => bool) public ownerByAddress;
24 
25   event SetOwners(address[] owners);
26 
27   modifier onlyOwner() {
28     require(ownerByAddress[msg.sender] == true);
29     _;
30   }
31 
32   /**
33     * @dev MultiOwnable constructor sets the manager
34     */
35   constructor() public {
36     manager = msg.sender;
37   }
38 
39   /**
40     * @dev Function to set owners addresses
41     */
42   function setOwners(address[] _owners) public {
43     require(msg.sender == manager);
44     _setOwners(_owners);
45   }
46 
47   function _setOwners(address[] _owners) internal {
48     for(uint256 i = 0; i < owners.length; i++) {
49       ownerByAddress[owners[i]] = false;
50     }
51 
52     for(uint256 j = 0; j < _owners.length; j++) {
53       ownerByAddress[_owners[j]] = true;
54     }
55     owners = _owners;
56     emit SetOwners(_owners);
57   }
58 
59   function getOwners() public view returns (address[]) {
60     return owners;
61   }
62 }
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72   event OwnershipRenounced(address indexed previousOwner);
73   event OwnershipTransferred(
74     address indexed previousOwner,
75     address indexed newOwner
76   );
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    */
97   function renounceOwnership() public onlyOwner {
98     emit OwnershipRenounced(owner);
99     owner = address(0);
100   }
101 
102   /**
103    * @dev Allows the current owner to transfer control of the contract to a newOwner.
104    * @param _newOwner The address to transfer ownership to.
105    */
106   function transferOwnership(address _newOwner) public onlyOwner {
107     _transferOwnership(_newOwner);
108   }
109 
110   /**
111    * @dev Transfers control of the contract to a newOwner.
112    * @param _newOwner The address to transfer ownership to.
113    */
114   function _transferOwnership(address _newOwner) internal {
115     require(_newOwner != address(0));
116     emit OwnershipTransferred(owner, _newOwner);
117     owner = _newOwner;
118   }
119 }
120 
121 /* solium-disable security/no-low-level-calls */
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender)
129     public view returns (uint256);
130 
131   function transferFrom(address from, address to, uint256 value)
132     public returns (bool);
133 
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(
136     address indexed owner,
137     address indexed spender,
138     uint256 value
139   );
140 }
141 
142 /**
143  * @title ERC827 interface, an extension of ERC20 token standard
144  *
145  * @dev Interface of a ERC827 token, following the ERC20 standard with extra
146  * @dev methods to transfer value and data and execute calls in transfers and
147  * @dev approvals.
148  */
149 contract ERC827 is ERC20 {
150   function approveAndCall(
151     address _spender,
152     uint256 _value,
153     bytes _data
154   )
155     public
156     payable
157     returns (bool);
158 
159   function transferAndCall(
160     address _to,
161     uint256 _value,
162     bytes _data
163   )
164     public
165     payable
166     returns (bool);
167 
168   function transferFromAndCall(
169     address _from,
170     address _to,
171     uint256 _value,
172     bytes _data
173   )
174     public
175     payable
176     returns (bool);
177 }
178 
179 /**
180  * @title SafeMath
181  * @dev Math operations with safety checks that throw on error
182  */
183 library SafeMath {
184 
185   /**
186   * @dev Multiplies two numbers, throws on overflow.
187   */
188   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
189     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
190     // benefit is lost if 'b' is also tested.
191     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
192     if (a == 0) {
193       return 0;
194     }
195 
196     c = a * b;
197     assert(c / a == b);
198     return c;
199   }
200 
201   /**
202   * @dev Integer division of two numbers, truncating the quotient.
203   */
204   function div(uint256 a, uint256 b) internal pure returns (uint256) {
205     // assert(b > 0); // Solidity automatically throws when dividing by 0
206     // uint256 c = a / b;
207     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208     return a / b;
209   }
210 
211   /**
212   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
213   */
214   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215     assert(b <= a);
216     return a - b;
217   }
218 
219   /**
220   * @dev Adds two numbers, throws on overflow.
221   */
222   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
223     c = a + b;
224     assert(c >= a);
225     return c;
226   }
227 }
228 
229 /**
230  * @title Basic token
231  * @dev Basic version of StandardToken, with no allowances.
232  */
233 contract BasicToken is ERC20Basic {
234   using SafeMath for uint256;
235 
236   mapping(address => uint256) balances;
237 
238   uint256 totalSupply_;
239 
240   /**
241   * @dev total number of tokens in existence
242   */
243   function totalSupply() public view returns (uint256) {
244     return totalSupply_;
245   }
246 
247   /**
248   * @dev transfer token for a specified address
249   * @param _to The address to transfer to.
250   * @param _value The amount to be transferred.
251   */
252   function transfer(address _to, uint256 _value) public returns (bool) {
253     require(_to != address(0));
254     require(_value <= balances[msg.sender]);
255 
256     balances[msg.sender] = balances[msg.sender].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     emit Transfer(msg.sender, _to, _value);
259     return true;
260   }
261 
262   /**
263   * @dev Gets the balance of the specified address.
264   * @param _owner The address to query the the balance of.
265   * @return An uint256 representing the amount owned by the passed address.
266   */
267   function balanceOf(address _owner) public view returns (uint256) {
268     return balances[_owner];
269   }
270 
271 }
272 
273 /**
274  * @title Standard ERC20 token
275  *
276  * @dev Implementation of the basic standard token.
277  * @dev https://github.com/ethereum/EIPs/issues/20
278  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
279  */
280 contract StandardToken is ERC20, BasicToken {
281 
282   mapping (address => mapping (address => uint256)) internal allowed;
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(
291     address _from,
292     address _to,
293     uint256 _value
294   )
295     public
296     returns (bool)
297   {
298     require(_to != address(0));
299     require(_value <= balances[_from]);
300     require(_value <= allowed[_from][msg.sender]);
301 
302     balances[_from] = balances[_from].sub(_value);
303     balances[_to] = balances[_to].add(_value);
304     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305     emit Transfer(_from, _to, _value);
306     return true;
307   }
308 
309   /**
310    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
311    *
312    * Beware that changing an allowance with this method brings the risk that someone may use both the old
313    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
314    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
315    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316    * @param _spender The address which will spend the funds.
317    * @param _value The amount of tokens to be spent.
318    */
319   function approve(address _spender, uint256 _value) public returns (bool) {
320     allowed[msg.sender][_spender] = _value;
321     emit Approval(msg.sender, _spender, _value);
322     return true;
323   }
324 
325   /**
326    * @dev Function to check the amount of tokens that an owner allowed to a spender.
327    * @param _owner address The address which owns the funds.
328    * @param _spender address The address which will spend the funds.
329    * @return A uint256 specifying the amount of tokens still available for the spender.
330    */
331   function allowance(
332     address _owner,
333     address _spender
334    )
335     public
336     view
337     returns (uint256)
338   {
339     return allowed[_owner][_spender];
340   }
341 
342   /**
343    * @dev Increase the amount of tokens that an owner allowed to a spender.
344    *
345    * approve should be called when allowed[_spender] == 0. To increment
346    * allowed value is better to use this function to avoid 2 calls (and wait until
347    * the first transaction is mined)
348    * From MonolithDAO Token.sol
349    * @param _spender The address which will spend the funds.
350    * @param _addedValue The amount of tokens to increase the allowance by.
351    */
352   function increaseApproval(
353     address _spender,
354     uint _addedValue
355   )
356     public
357     returns (bool)
358   {
359     allowed[msg.sender][_spender] = (
360       allowed[msg.sender][_spender].add(_addedValue));
361     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362     return true;
363   }
364 
365   /**
366    * @dev Decrease the amount of tokens that an owner allowed to a spender.
367    *
368    * approve should be called when allowed[_spender] == 0. To decrement
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _subtractedValue The amount of tokens to decrease the allowance by.
374    */
375   function decreaseApproval(
376     address _spender,
377     uint _subtractedValue
378   )
379     public
380     returns (bool)
381   {
382     uint oldValue = allowed[msg.sender][_spender];
383     if (_subtractedValue > oldValue) {
384       allowed[msg.sender][_spender] = 0;
385     } else {
386       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
387     }
388     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389     return true;
390   }
391 
392 }
393 
394 /**
395  * @title ERC827, an extension of ERC20 token standard
396  *
397  * @dev Implementation the ERC827, following the ERC20 standard with extra
398  * @dev methods to transfer value and data and execute calls in transfers and
399  * @dev approvals.
400  *
401  * @dev Uses OpenZeppelin StandardToken.
402  */
403 contract ERC827Token is ERC827, StandardToken {
404 
405   /**
406    * @dev Addition to ERC20 token methods. It allows to
407    * @dev approve the transfer of value and execute a call with the sent data.
408    *
409    * @dev Beware that changing an allowance with this method brings the risk that
410    * @dev someone may use both the old and the new allowance by unfortunate
411    * @dev transaction ordering. One possible solution to mitigate this race condition
412    * @dev is to first reduce the spender's allowance to 0 and set the desired value
413    * @dev afterwards:
414    * @dev https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
415    *
416    * @param _spender The address that will spend the funds.
417    * @param _value The amount of tokens to be spent.
418    * @param _data ABI-encoded contract call to call `_to` address.
419    *
420    * @return true if the call function was executed successfully
421    */
422   function approveAndCall(
423     address _spender,
424     uint256 _value,
425     bytes _data
426   )
427     public
428     payable
429     returns (bool)
430   {
431     require(_spender != address(this));
432 
433     super.approve(_spender, _value);
434 
435     // solium-disable-next-line security/no-call-value
436     require(_spender.call.value(msg.value)(_data));
437 
438     return true;
439   }
440 
441   /**
442    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
443    * @dev address and execute a call with the sent data on the same transaction
444    *
445    * @param _to address The address which you want to transfer to
446    * @param _value uint256 the amout of tokens to be transfered
447    * @param _data ABI-encoded contract call to call `_to` address.
448    *
449    * @return true if the call function was executed successfully
450    */
451   function transferAndCall(
452     address _to,
453     uint256 _value,
454     bytes _data
455   )
456     public
457     payable
458     returns (bool)
459   {
460     require(_to != address(this));
461 
462     super.transfer(_to, _value);
463 
464     // solium-disable-next-line security/no-call-value
465     require(_to.call.value(msg.value)(_data));
466     return true;
467   }
468 
469   /**
470    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
471    * @dev another and make a contract call on the same transaction
472    *
473    * @param _from The address which you want to send tokens from
474    * @param _to The address which you want to transfer to
475    * @param _value The amout of tokens to be transferred
476    * @param _data ABI-encoded contract call to call `_to` address.
477    *
478    * @return true if the call function was executed successfully
479    */
480   function transferFromAndCall(
481     address _from,
482     address _to,
483     uint256 _value,
484     bytes _data
485   )
486     public payable returns (bool)
487   {
488     require(_to != address(this));
489 
490     super.transferFrom(_from, _to, _value);
491 
492     // solium-disable-next-line security/no-call-value
493     require(_to.call.value(msg.value)(_data));
494     return true;
495   }
496 
497   /**
498    * @dev Addition to StandardToken methods. Increase the amount of tokens that
499    * @dev an owner allowed to a spender and execute a call with the sent data.
500    *
501    * @dev approve should be called when allowed[_spender] == 0. To increment
502    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
503    * @dev the first transaction is mined)
504    * @dev From MonolithDAO Token.sol
505    *
506    * @param _spender The address which will spend the funds.
507    * @param _addedValue The amount of tokens to increase the allowance by.
508    * @param _data ABI-encoded contract call to call `_spender` address.
509    */
510   function increaseApprovalAndCall(
511     address _spender,
512     uint _addedValue,
513     bytes _data
514   )
515     public
516     payable
517     returns (bool)
518   {
519     require(_spender != address(this));
520 
521     super.increaseApproval(_spender, _addedValue);
522 
523     // solium-disable-next-line security/no-call-value
524     require(_spender.call.value(msg.value)(_data));
525 
526     return true;
527   }
528 
529   /**
530    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
531    * @dev an owner allowed to a spender and execute a call with the sent data.
532    *
533    * @dev approve should be called when allowed[_spender] == 0. To decrement
534    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
535    * @dev the first transaction is mined)
536    * @dev From MonolithDAO Token.sol
537    *
538    * @param _spender The address which will spend the funds.
539    * @param _subtractedValue The amount of tokens to decrease the allowance by.
540    * @param _data ABI-encoded contract call to call `_spender` address.
541    */
542   function decreaseApprovalAndCall(
543     address _spender,
544     uint _subtractedValue,
545     bytes _data
546   )
547     public
548     payable
549     returns (bool)
550   {
551     require(_spender != address(this));
552 
553     super.decreaseApproval(_spender, _subtractedValue);
554 
555     // solium-disable-next-line security/no-call-value
556     require(_spender.call.value(msg.value)(_data));
557 
558     return true;
559   }
560 
561 }
562 
563 contract BitScreenerToken is ERC827Token, MultiOwnable {
564   string public name = 'BitScreenerToken';
565   string public symbol = 'BITX';
566   uint8 public decimals = 18;
567   uint256 public totalSupply;
568   address public owner;
569 
570   bool public allowTransfers = false;
571   bool public issuanceFinished = false;
572 
573   event AllowTransfersChanged(bool _newState);
574   event Issue(address indexed _to, uint256 _value);
575   event Burn(address indexed _from, uint256 _value);
576   event IssuanceFinished();
577 
578   modifier transfersAllowed() {
579     require(allowTransfers);
580     _;
581   }
582 
583   modifier canIssue() {
584     require(!issuanceFinished);
585     _;
586   }
587 
588   constructor(address[] _owners) public {
589     _setOwners(_owners);
590   }
591 
592   /**
593   * @dev Enable/disable token transfers. Can be called only by owners
594   * @param _allowTransfers True - allow False - disable
595   */
596   function setAllowTransfers(bool _allowTransfers) external onlyOwner {
597     allowTransfers = _allowTransfers;
598     emit AllowTransfersChanged(_allowTransfers);
599   }
600 
601   function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
602     return super.transfer(_to, _value);
603   }
604 
605   function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
606     return super.transferFrom(_from, _to, _value);
607   }
608 
609   function transferAndCall(address _to, uint256 _value, bytes _data) public payable transfersAllowed returns (bool) {
610     return super.transferAndCall(_to, _value, _data);
611   }
612 
613   function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable transfersAllowed returns (bool) {
614     return super.transferFromAndCall(_from, _to, _value, _data);
615   }
616 
617   /**
618   * @dev Issue tokens to specified wallet
619   * @param _to Wallet address
620   * @param _value Amount of tokens
621   */
622   function issue(address _to, uint256 _value) external onlyOwner canIssue returns (bool) {
623     totalSupply = totalSupply.add(_value);
624     balances[_to] = balances[_to].add(_value);
625     emit Issue(_to, _value);
626     emit Transfer(address(0), _to, _value);
627     return true;
628   }
629 
630   /**
631   * @dev Finish token issuance
632   * @return True if success
633   */
634   function finishIssuance() public onlyOwner returns (bool) {
635     issuanceFinished = true;
636     emit IssuanceFinished();
637     return true;
638   }
639 
640   /**
641   * @dev Burn tokens
642   * @param _value Amount of tokens to burn
643   */
644   function burn(uint256 _value) external {
645     require(balances[msg.sender] >= _value);
646     totalSupply = totalSupply.sub(_value);
647     balances[msg.sender] = balances[msg.sender].sub(_value);
648     emit Transfer(msg.sender, address(0), _value);
649     emit Burn(msg.sender, _value);
650   }
651 }
652 
653 contract BITXDistributionTools is Ownable {
654   BitScreenerToken public token;
655 
656   constructor(BitScreenerToken _token) 
657     public
658   {
659     token = _token;
660   }
661 
662   function issueToMany(address[] _recipients, uint256[] _amount) 
663     public
664     onlyOwner
665   {
666     require(_recipients.length == _amount.length);
667     for (uint i = 0; i < _recipients.length; i++) {
668       // Issue once only
669       if (token.balanceOf(_recipients[i]) < _amount[i]) {
670         require(token.issue(_recipients[i], _amount[i]));
671       }
672     }
673   }
674 }