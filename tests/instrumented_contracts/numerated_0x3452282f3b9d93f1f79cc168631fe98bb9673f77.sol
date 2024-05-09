1 pragma solidity ^0.4.18;
2 
3 // File: contracts/IEscrow.sol
4 
5 /**
6  * @title Escrow interface
7  *
8  * @dev https://send.sd/token
9  */
10 interface IEscrow {
11 
12   event Created(
13     address indexed sender,
14     address indexed recipient,
15     address indexed arbitrator,
16     uint256 transactionId
17   );
18   event Released(address indexed arbitrator, address indexed sentTo, uint256 transactionId);
19   event Dispute(address indexed arbitrator, uint256 transactionId);
20   event Paid(address indexed arbitrator, uint256 transactionId);
21 
22   function create(
23       address _sender,
24       address _recipient,
25       address _arbitrator,
26       uint256 _transactionId,
27       uint256 _tokens,
28       uint256 _fee,
29       uint256 _expiration
30   ) public;
31 
32   function fund(
33       address _sender,
34       address _arbitrator,
35       uint256 _transactionId,
36       uint256 _tokens,
37       uint256 _fee
38   ) public;
39 
40 }
41 
42 // File: contracts/ISendToken.sol
43 
44 /**
45  * @title ISendToken - Send Consensus Network Token interface
46  * @dev token interface built on top of ERC20 standard interface
47  * @dev see https://send.sd/token
48  */
49 interface ISendToken {
50   function transfer(address to, uint256 value) public returns (bool);
51 
52   function isVerified(address _address) public constant returns(bool);
53 
54   function verify(address _address) public;
55 
56   function unverify(address _address) public;
57 
58   function verifiedTransferFrom(
59       address from,
60       address to,
61       uint256 value,
62       uint256 referenceId,
63       uint256 exchangeRate,
64       uint256 fee
65   ) public;
66 
67   function issueExchangeRate(
68       address _from,
69       address _to,
70       address _verifiedAddress,
71       uint256 _value,
72       uint256 _referenceId,
73       uint256 _exchangeRate
74   ) public;
75 
76   event VerifiedTransfer(
77       address indexed from,
78       address indexed to,
79       address indexed verifiedAddress,
80       uint256 value,
81       uint256 referenceId,
82       uint256 exchangeRate
83   );
84 }
85 
86 // File: contracts/ISnapshotToken.sol
87 
88 /**
89  * @title Snapshot Token
90  *
91  * @dev Snapshot Token interface
92  * @dev https://send.sd/token
93  */
94 interface ISnapshotToken {
95   function requestSnapshots(uint256 _blockNumber) public;
96   function takeSnapshot(address _owner) public returns(uint256);
97 }
98 
99 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107   address public owner;
108 
109 
110   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   function Ownable() public {
118     owner = msg.sender;
119   }
120 
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130 
131   /**
132    * @dev Allows the current owner to transfer control of the contract to a newOwner.
133    * @param newOwner The address to transfer ownership to.
134    */
135   function transferOwnership(address newOwner) public onlyOwner {
136     require(newOwner != address(0));
137     OwnershipTransferred(owner, newOwner);
138     owner = newOwner;
139   }
140 
141 }
142 
143 // File: zeppelin-solidity/contracts/math/SafeMath.sol
144 
145 /**
146  * @title SafeMath
147  * @dev Math operations with safety checks that throw on error
148  */
149 library SafeMath {
150   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151     if (a == 0) {
152       return 0;
153     }
154     uint256 c = a * b;
155     assert(c / a == b);
156     return c;
157   }
158 
159   function div(uint256 a, uint256 b) internal pure returns (uint256) {
160     // assert(b > 0); // Solidity automatically throws when dividing by 0
161     uint256 c = a / b;
162     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163     return c;
164   }
165 
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     assert(b <= a);
168     return a - b;
169   }
170 
171   function add(uint256 a, uint256 b) internal pure returns (uint256) {
172     uint256 c = a + b;
173     assert(c >= a);
174     return c;
175   }
176 }
177 
178 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
179 
180 /**
181  * @title ERC20Basic
182  * @dev Simpler version of ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/179
184  */
185 contract ERC20Basic {
186   uint256 public totalSupply;
187   function balanceOf(address who) public view returns (uint256);
188   function transfer(address to, uint256 value) public returns (bool);
189   event Transfer(address indexed from, address indexed to, uint256 value);
190 }
191 
192 // File: zeppelin-solidity/contracts/token/BasicToken.sol
193 
194 /**
195  * @title Basic token
196  * @dev Basic version of StandardToken, with no allowances.
197  */
198 contract BasicToken is ERC20Basic {
199   using SafeMath for uint256;
200 
201   mapping(address => uint256) balances;
202 
203   /**
204   * @dev transfer token for a specified address
205   * @param _to The address to transfer to.
206   * @param _value The amount to be transferred.
207   */
208   function transfer(address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[msg.sender]);
211 
212     // SafeMath.sub will throw if there is not enough balance.
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     Transfer(msg.sender, _to, _value);
216     return true;
217   }
218 
219   /**
220   * @dev Gets the balance of the specified address.
221   * @param _owner The address to query the the balance of.
222   * @return An uint256 representing the amount owned by the passed address.
223   */
224   function balanceOf(address _owner) public view returns (uint256 balance) {
225     return balances[_owner];
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/ERC20.sol
231 
232 /**
233  * @title ERC20 interface
234  * @dev see https://github.com/ethereum/EIPs/issues/20
235  */
236 contract ERC20 is ERC20Basic {
237   function allowance(address owner, address spender) public view returns (uint256);
238   function transferFrom(address from, address to, uint256 value) public returns (bool);
239   function approve(address spender, uint256 value) public returns (bool);
240   event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: zeppelin-solidity/contracts/token/StandardToken.sol
244 
245 /**
246  * @title Standard ERC20 token
247  *
248  * @dev Implementation of the basic standard token.
249  * @dev https://github.com/ethereum/EIPs/issues/20
250  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
251  */
252 contract StandardToken is ERC20, BasicToken {
253 
254   mapping (address => mapping (address => uint256)) internal allowed;
255 
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param _from address The address which you want to send tokens from
260    * @param _to address The address which you want to transfer to
261    * @param _value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
264     require(_to != address(0));
265     require(_value <= balances[_from]);
266     require(_value <= allowed[_from][msg.sender]);
267 
268     balances[_from] = balances[_from].sub(_value);
269     balances[_to] = balances[_to].add(_value);
270     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
271     Transfer(_from, _to, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277    *
278    * Beware that changing an allowance with this method brings the risk that someone may use both the old
279    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
281    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282    * @param _spender The address which will spend the funds.
283    * @param _value The amount of tokens to be spent.
284    */
285   function approve(address _spender, uint256 _value) public returns (bool) {
286     allowed[msg.sender][_spender] = _value;
287     Approval(msg.sender, _spender, _value);
288     return true;
289   }
290 
291   /**
292    * @dev Function to check the amount of tokens that an owner allowed to a spender.
293    * @param _owner address The address which owns the funds.
294    * @param _spender address The address which will spend the funds.
295    * @return A uint256 specifying the amount of tokens still available for the spender.
296    */
297   function allowance(address _owner, address _spender) public view returns (uint256) {
298     return allowed[_owner][_spender];
299   }
300 
301   /**
302    * @dev Increase the amount of tokens that an owner allowed to a spender.
303    *
304    * approve should be called when allowed[_spender] == 0. To increment
305    * allowed value is better to use this function to avoid 2 calls (and wait until
306    * the first transaction is mined)
307    * From MonolithDAO Token.sol
308    * @param _spender The address which will spend the funds.
309    * @param _addedValue The amount of tokens to increase the allowance by.
310    */
311   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
312     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
313     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317   /**
318    * @dev Decrease the amount of tokens that an owner allowed to a spender.
319    *
320    * approve should be called when allowed[_spender] == 0. To decrement
321    * allowed value is better to use this function to avoid 2 calls (and wait until
322    * the first transaction is mined)
323    * From MonolithDAO Token.sol
324    * @param _spender The address which will spend the funds.
325    * @param _subtractedValue The amount of tokens to decrease the allowance by.
326    */
327   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
328     uint oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338 }
339 
340 // File: contracts/SnapshotToken.sol
341 
342 /**
343  * @title Snapshot Token
344  *
345  * @dev Snapshot Token implementtion
346  * @dev https://send.sd/token
347  */
348 contract SnapshotToken is ISnapshotToken, StandardToken, Ownable {
349   uint256 public snapshotBlock;
350 
351   mapping (address => Snapshot) internal snapshots;
352 
353   struct Snapshot {
354     uint256 block;
355     uint256 balance;
356   }
357 
358   address public polls;
359 
360   modifier isPolls() {
361     require(msg.sender == address(polls));
362     _;
363   }
364 
365   /**
366    * @dev Remove Verified status of a given address
367    * @notice Only contract owner
368    * @param _address Address to unverify
369    */
370   function setPolls(address _address) public onlyOwner {
371     polls = _address;
372   }
373 
374   /**
375    * @dev Extend OpenZeppelin's BasicToken transfer function to store snapshot
376    * @param _to The address to transfer to.
377    * @param _value The amount to be transferred.
378    */
379   function transfer(address _to, uint256 _value) public returns (bool) {
380     takeSnapshot(msg.sender);
381     takeSnapshot(_to);
382     return BasicToken.transfer(_to, _value);
383   }
384 
385   /**
386    * @dev Extend OpenZeppelin's StandardToken transferFrom function to store snapshot
387    * @param _from address The address which you want to send tokens from
388    * @param _to address The address which you want to transfer to
389    * @param _value uint256 the amount of tokens to be transferred
390    */
391   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
392     takeSnapshot(_from);
393     takeSnapshot(_to);
394     return StandardToken.transferFrom(_from, _to, _value);
395   }
396 
397   /**
398    * @dev Take snapshot
399    * @param _owner address The address to take snapshot from
400    */
401   function takeSnapshot(address _owner) public returns(uint256) {
402     if (snapshots[_owner].block < snapshotBlock) {
403       snapshots[_owner].block = snapshotBlock;
404       snapshots[_owner].balance = balanceOf(_owner);
405     }
406     return snapshots[_owner].balance;
407   }
408 
409   /**
410    * @dev Set snacpshot block
411    * @param _blockNumber uint256 The new blocknumber for snapshots
412    */
413   function requestSnapshots(uint256 _blockNumber) public isPolls {
414     snapshotBlock = _blockNumber;
415   }
416 }
417 
418 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
419 
420 /**
421  * @title Burnable Token
422  * @dev Token that can be irreversibly burned (destroyed).
423  */
424 contract BurnableToken is BasicToken {
425 
426     event Burn(address indexed burner, uint256 value);
427 
428     /**
429      * @dev Burns a specific amount of tokens.
430      * @param _value The amount of token to be burned.
431      */
432     function burn(uint256 _value) public {
433         require(_value <= balances[msg.sender]);
434         // no need to require value <= totalSupply, since that would imply the
435         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
436 
437         address burner = msg.sender;
438         balances[burner] = balances[burner].sub(_value);
439         totalSupply = totalSupply.sub(_value);
440         Burn(burner, _value);
441     }
442 }
443 
444 // File: contracts/SendToken.sol
445 
446 /**
447  * @title Send token
448  *
449  * @dev Implementation of Send Consensus network Standard
450  * @dev https://send.sd/token
451  */
452 contract SendToken is ISendToken, SnapshotToken, BurnableToken {
453   IEscrow public escrow;
454 
455   mapping (address => bool) internal verifiedAddresses;
456 
457   modifier verifiedResticted() {
458     require(verifiedAddresses[msg.sender]);
459     _;
460   }
461 
462   modifier escrowResticted() {
463     require(msg.sender == address(escrow));
464     _;
465   }
466 
467   /**
468    * @dev Check if an address is whitelisted by SEND
469    * @param _address Address to check
470    * @return bool
471    */
472   function isVerified(address _address) public view returns(bool) {
473     return verifiedAddresses[_address];
474   }
475 
476   /**
477    * @dev Verify an addres
478    * @notice Only contract owner
479    * @param _address Address to verify
480    */
481   function verify(address _address) public onlyOwner {
482     verifiedAddresses[_address] = true;
483   }
484 
485   /**
486    * @dev Remove Verified status of a given address
487    * @notice Only contract owner
488    * @param _address Address to unverify
489    */
490   function unverify(address _address) public onlyOwner {
491     verifiedAddresses[_address] = false;
492   }
493 
494   /**
495    * @dev Remove Verified status of a given address
496    * @notice Only contract owner
497    * @param _address Address to unverify
498    */
499   function setEscrow(address _address) public onlyOwner {
500     escrow = IEscrow(_address);
501   }
502 
503   /**
504    * @dev Transfer from one address to another issuing ane xchange rate
505    * @notice Only verified addresses
506    * @notice Exchange rate has 18 decimal places
507    * @notice Value + fee <= allowance
508    * @param _from address The address which you want to send tokens from
509    * @param _to address The address which you want to transfer to
510    * @param _value uint256 the amount of tokens to be transferred
511    * @param _referenceId internal app/user ID
512    * @param _exchangeRate Exchange rate to sign transaction
513    * @param _fee fee tot ake from sender
514    */
515   function verifiedTransferFrom(
516       address _from,
517       address _to,
518       uint256 _value,
519       uint256 _referenceId,
520       uint256 _exchangeRate,
521       uint256 _fee
522   ) public verifiedResticted {
523     require(_exchangeRate > 0);
524 
525     transferFrom(_from, _to, _value);
526     transferFrom(_from, msg.sender, _fee);
527 
528     VerifiedTransfer(
529       _from,
530       _to,
531       msg.sender,
532       _value,
533       _referenceId,
534       _exchangeRate
535     );
536   }
537 
538   /**
539    * @dev create an escrow transfer being the arbitrator
540    * @param _sender Address to send tokens
541    * @param _recipient Address to receive tokens
542    * @param _transactionId internal ID for arbitrator
543    * @param _tokens Amount of tokens to lock
544    * @param _fee A fee to be paid to arbitrator (may be 0)
545    * @param _expiration After this timestamp, user can claim tokens back.
546    */
547   function createEscrow(
548       address _sender,
549       address _recipient,
550       uint256 _transactionId,
551       uint256 _tokens,
552       uint256 _fee,
553       uint256 _expiration
554   ) public {
555     escrow.create(
556       _sender,
557       _recipient,
558       msg.sender,
559       _transactionId,
560       _tokens,
561       _fee,
562       _expiration
563     );
564   }
565 
566   /**
567    * @dev fund escrow
568    * @dev specified amount will be locked on escrow contract
569    * @param _arbitrator Address of escrow arbitrator
570    * @param _transactionId internal ID for arbitrator
571    * @param _tokens Amount of tokens to lock
572    * @param _fee A fee to be paid to arbitrator (may be 0)
573    */
574   function fundEscrow(
575       address _arbitrator,
576       uint256 _transactionId,
577       uint256 _tokens,
578       uint256 _fee
579   ) public {
580     uint256 total = _tokens.add(_fee);
581     transfer(escrow, total);
582 
583     escrow.fund(
584       msg.sender,
585       _arbitrator,
586       _transactionId,
587       _tokens,
588       _fee
589     );
590   }
591 
592   /**
593    * @dev Issue exchange rates from escrow contract
594    * @param _from Address to send tokens
595    * @param _to Address to receive tokens
596    * @param _verifiedAddress Address issuing the exchange rate
597    * @param _value amount
598    * @param _transactionId internal ID for issuer's reference
599    * @param _exchangeRate exchange rate
600    */
601   function issueExchangeRate(
602       address _from,
603       address _to,
604       address _verifiedAddress,
605       uint256 _value,
606       uint256 _transactionId,
607       uint256 _exchangeRate
608   ) public escrowResticted {
609     bool noRate = (_exchangeRate == 0);
610     if (isVerified(_verifiedAddress)) {
611       require(!noRate);
612       VerifiedTransfer(
613         _from,
614         _to,
615         _verifiedAddress,
616         _value,
617         _transactionId,
618         _exchangeRate
619       );
620     } else {
621       require(noRate);
622     }
623   }
624 }
625 
626 // File: contracts/SDT.sol
627 
628 /**
629  * @title To instance SendToken for SEND foundation crowdasale
630  * @dev see https://send.sd/token
631  */
632 contract SDT is SendToken {
633   string constant public name = "SEND Token";
634   string constant public symbol = "SDT";
635   uint256 constant public decimals = 18;
636 
637   modifier validAddress(address _address) {
638     require(_address != address(0x0));
639     _;
640   }
641 
642   /**
643   * @dev Constructor
644   * @param _sale Address that will hold all vesting allocated tokens
645   * @notice contract owner will have special powers in the contract
646   * @notice _sale should hold all tokens in production as all pool will be vested
647   * @return A uint256 representing the locked amount of tokens
648   */
649   function SDT(address _sale) public validAddress(_sale) {
650     verifiedAddresses[owner] = true;
651     totalSupply = 700000000 * 10 ** decimals;
652     balances[_sale] = totalSupply;
653   }
654 }