1 pragma solidity ^0.4.23;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     if (a == 0) {
28       return 0;
29     }
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     require(newOwner != address(0));
92     emit OwnershipTransferred(owner, newOwner);
93     owner = newOwner;
94   }
95 
96 }
97 
98 contract CanReclaimToken is Ownable {
99   using SafeERC20 for ERC20Basic;
100 
101   /**
102    * @dev Reclaim all ERC20Basic compatible tokens
103    * @param token ERC20Basic The address of the token contract
104    */
105   function reclaimToken(ERC20Basic token) external onlyOwner {
106     uint256 balance = token.balanceOf(this);
107     token.safeTransfer(owner, balance);
108   }
109 
110 }
111 
112 contract HasNoContracts is Ownable {
113 
114   /**
115    * @dev Reclaim ownership of Ownable contracts
116    * @param contractAddr The address of the Ownable to be reclaimed.
117    */
118   function reclaimContract(address contractAddr) external onlyOwner {
119     Ownable contractInst = Ownable(contractAddr);
120     contractInst.transferOwnership(owner);
121   }
122 }
123 
124 contract HasNoEther is Ownable {
125 
126   /**
127   * @dev Constructor that rejects incoming Ether
128   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
129   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
130   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
131   * we could use assembly to access msg.value.
132   */
133   function HasNoEther() public payable {
134     require(msg.value == 0);
135   }
136 
137   /**
138    * @dev Disallows direct send by settings a default function without the `payable` flag.
139    */
140   function() external {
141   }
142 
143   /**
144    * @dev Transfer all Ether held by the contract to the owner.
145    */
146   function reclaimEther() external onlyOwner {
147     // solium-disable-next-line security/no-send
148     assert(owner.send(address(this).balance));
149   }
150 }
151 
152 contract HasNoTokens is CanReclaimToken {
153 
154  /**
155   * @dev Reject all ERC223 compatible tokens
156   * @param from_ address The address that is transferring the tokens
157   * @param value_ uint256 the amount of the specified token
158   * @param data_ Bytes The data passed from the caller.
159   */
160   function tokenFallback(address from_, uint256 value_, bytes data_) external {
161     from_;
162     value_;
163     data_;
164     revert();
165   }
166 
167 }
168 
169 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
170 }
171 
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender) public view returns (uint256);
181   function transferFrom(address from, address to, uint256 value) public returns (bool);
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 library SafeERC20 {
187   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
188     assert(token.transfer(to, value));
189   }
190 
191   function safeTransferFrom(
192     ERC20 token,
193     address from,
194     address to,
195     uint256 value
196   )
197     internal
198   {
199     assert(token.transferFrom(from, to, value));
200   }
201 
202   function safeApprove(ERC20 token, address spender, uint256 value) internal {
203     assert(token.approve(spender, value));
204   }
205 }
206 
207 contract CheckpointStorage {
208 
209   /**
210    * @dev `Checkpoint` is the structure that attaches a block number to a
211    * @dev given value, the block number attached is the one that last changed the
212    * @dev value
213    */
214   struct Checkpoint {
215     // `fromBlock` is the block number that the value was generated from
216     uint128 fromBlock;
217 
218     // `value` is the amount of tokens at a specific block number
219     uint128 value;
220   }
221 
222   // Tracks the history of the `totalSupply` of the token
223   Checkpoint[] public totalSupplyHistory;
224 
225   /**
226    * @dev `getValueAt` retrieves the number of tokens at a given block number
227    *
228    * @param checkpoints The history of values being queried
229    * @param _block The block number to retrieve the value at
230    * @return The number of tokens being queried
231    */
232   function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view returns (uint) {
233     if (checkpoints.length == 0)
234       return 0;
235 
236     // Shortcut for the actual value
237     if (_block >= checkpoints[checkpoints.length - 1].fromBlock)
238       return checkpoints[checkpoints.length - 1].value;
239     if (_block < checkpoints[0].fromBlock)
240       return 0;
241 
242     // Binary search of the value in the array
243     uint min = 0;
244     uint max = checkpoints.length - 1;
245     while (max > min) {
246       uint mid = (max + min + 1) / 2;
247       if (checkpoints[mid].fromBlock <= _block) {
248         min = mid;
249       } else {
250         max = mid - 1;
251       }
252     }
253     return checkpoints[min].value;
254   }
255 
256   /**
257    * @dev `updateValueAtNow` used to update the `balances` map and the
258    * @dev `totalSupplyHistory`
259    *
260    * @param checkpoints The history of data being updated
261    * @param _value The new number of tokens
262    */
263   function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
264     if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
265       Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
266       newCheckPoint.fromBlock = uint128(block.number);
267       newCheckPoint.value = uint128(_value);
268     } else {
269       Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
270       oldCheckPoint.value = uint128(_value);
271     }
272   }
273 }
274 
275 contract SatisfactionToken is ERC20, CheckpointStorage, NoOwner {
276 
277   event Transfer(address indexed from, address indexed to, uint256 value);
278   event Approval(address indexed owner, address indexed spender, uint256 value);
279 
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282   event Burn(address indexed burner, uint256 value);
283 
284   using SafeMath for uint256;
285 
286   string public name = "Satisfaction Token";
287   uint8 public decimals = 18;
288   string public symbol = "SAT";
289   string public version;
290 
291   /**
292    * `parentToken` is the Token address that was cloned to produce this token;
293    *  it will be 0x0 for a token that was not cloned
294    */
295   SatisfactionToken public parentToken;
296 
297   /**
298    * `parentSnapShotBlock` is the block number from the Parent Token that was
299    *  used to determine the initial distribution of the Clone Token
300    */
301   uint256 public parentSnapShotBlock;
302 
303   // `creationBlock` is the block number that the Clone Token was created
304   uint256 public creationBlock;
305 
306   /**
307    * `balances` is the map that tracks the balance of each address, in this
308    *  contract when the balance changes the block number that the change
309    *  occurred is also included in the map
310    */
311   mapping(address => Checkpoint[]) internal balances;
312 
313   // `allowed` tracks any extra transfer rights as in all ERC20 tokens
314   mapping(address => mapping(address => uint256)) internal allowed;
315 
316   // Flag that determines if the token is transferable or not.
317   bool public transfersEnabled;
318 
319   bool public mintingFinished = false;
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   constructor(
327     address _parentToken,
328     uint256 _parentSnapShotBlock,
329     string _tokenVersion,
330     bool _transfersEnabled) public
331   {
332     version = _tokenVersion;
333     parentToken = SatisfactionToken(_parentToken);
334     parentSnapShotBlock = _parentSnapShotBlock;
335     transfersEnabled = _transfersEnabled;
336     creationBlock = block.number;
337   }
338 
339   /**
340    * @dev Transfer token for a specified address
341    *
342    * @param _to address The address which you want to transfer to
343    * @param _value uint256 the amout of tokens to be transfered
344   */
345   function transfer(address _to, uint256 _value) public returns (bool) {
346     require(transfersEnabled);
347     require(parentSnapShotBlock < block.number);
348     require(_to != address(0));
349 
350     uint256 lastBalance = balanceOfAt(msg.sender, block.number);
351     require(_value <= lastBalance);
352 
353     return doTransfer(msg.sender, _to, _value, lastBalance);
354   }
355 
356   /**
357    * @dev Addition to ERC20 token methods. Transfer tokens to a specified
358    * @dev address and execute a call with the sent data on the same transaction
359    *
360    * @param _to address The address which you want to transfer to
361    * @param _value uint256 the amout of tokens to be transfered
362    * @param _data ABI-encoded contract call to call `_to` address.
363    *
364    * @return true if the call function was executed successfully
365    */
366   function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
367     require(_to != address(this));
368 
369     transfer(_to, _value);
370 
371     // solium-disable-next-line security/no-call-value
372     require(_to.call.value(msg.value)(_data));
373     return true;
374   }
375 
376   /**
377    * @dev Transfer tokens from one address to another
378    *
379    * @param _from address The address which you want to send tokens from
380    * @param _to address The address which you want to transfer to
381    * @param _value uint256 the amount of tokens to be transferred
382    */
383   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
384     require(transfersEnabled);
385     require(parentSnapShotBlock < block.number);
386     require(_to != address(0));
387     require(_value <= allowed[_from][msg.sender]);
388 
389     uint256 lastBalance = balanceOfAt(_from, block.number);
390     require(_value <= lastBalance);
391 
392     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
393 
394     return doTransfer(_from, _to, _value, lastBalance);
395   }
396 
397   /**
398    * @dev Addition to ERC20 token methods. Transfer tokens from one address to
399    * @dev another and make a contract call on the same transaction
400    *
401    * @param _from The address which you want to send tokens from
402    * @param _to The address which you want to transfer to
403    * @param _value The amout of tokens to be transferred
404    * @param _data ABI-encoded contract call to call `_to` address.
405    *
406    * @return true if the call function was executed successfully
407    */
408   function transferFromAndCall(
409     address _from,
410     address _to,
411     uint256 _value,
412     bytes _data
413   )
414     public payable returns (bool)
415   {
416     require(_to != address(this));
417 
418     transferFrom(_from, _to, _value);
419 
420     // solium-disable-next-line security/no-call-value
421     require(_to.call.value(msg.value)(_data));
422     return true;
423   }
424 
425   /**
426    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
427    *
428    * Beware that changing an allowance with this method brings the risk that someone may use both the old
429    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
430    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
431    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
432    *
433    * @param _spender The address which will spend the funds.
434    * @param _value The amount of tokens to be spent.
435    */
436   function approve(address _spender, uint256 _value) public returns (bool) {
437     allowed[msg.sender][_spender] = _value;
438     emit Approval(msg.sender, _spender, _value);
439     return true;
440   }
441 
442   /**
443    * @dev Function to check the amount of tokens that an owner allowed to a spender.
444    *
445    * @param _owner address The address which owns the funds.
446    * @param _spender address The address which will spend the funds.
447    * @return A uint256 specifying the amount of tokens still available for the spender.
448    */
449   function allowance(address _owner, address _spender) public view returns (uint256) {
450     return allowed[_owner][_spender];
451   }
452 
453   /**
454    * @dev Increase the amount of tokens that an owner allowed to a spender.
455    *
456    * @dev approve should be called when allowed[_spender] == 0. To increment
457    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
458    * t@dev he first transaction is mined)
459    * @dev From MonolithDAO Token.sol
460    *
461    * @param _spender The address which will spend the funds.
462    * @param _addedValue The amount of tokens to increase the allowance by.
463    */
464   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
465     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
466     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
467     return true;
468   }
469 
470   /**
471    * @dev Addition to StandardToken methods. Increase the amount of tokens that
472    * @dev an owner allowed to a spender and execute a call with the sent data.
473    *
474    * @dev approve should be called when allowed[_spender] == 0. To increment
475    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
476    * @dev the first transaction is mined)
477    * @dev From MonolithDAO Token.sol
478    *
479    * @param _spender The address which will spend the funds.
480    * @param _addedValue The amount of tokens to increase the allowance by.
481    * @param _data ABI-encoded contract call to call `_spender` address.
482    */
483   function increaseApprovalAndCall(address _spender, uint _addedValue, bytes _data) public payable returns (bool) {
484     require(_spender != address(this));
485 
486     increaseApproval(_spender, _addedValue);
487 
488     // solium-disable-next-line security/no-call-value
489     require(_spender.call.value(msg.value)(_data));
490 
491     return true;
492   }
493 
494   /**
495    * @dev Decrease the amount of tokens that an owner allowed to a spender.
496    *
497    * @dev approve should be called when allowed[_spender] == 0. To decrement
498    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
499    * @dev the first transaction is mined)
500    * @dev From MonolithDAO Token.sol
501    *
502    * @param _spender The address which will spend the funds.
503    * @param _subtractedValue The amount of tokens to decrease the allowance by.
504    */
505   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
506     uint oldValue = allowed[msg.sender][_spender];
507     if (_subtractedValue > oldValue) {
508       allowed[msg.sender][_spender] = 0;
509     } else {
510       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
511     }
512     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
513     return true;
514   }
515 
516   /**
517    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
518    * @dev an owner allowed to a spender and execute a call with the sent data.
519    *
520    * @dev approve should be called when allowed[_spender] == 0. To decrement
521    * @dev allowed value is better to use this function to avoid 2 calls (and wait until
522    * @dev the first transaction is mined)
523    * @dev From MonolithDAO Token.sol
524    *
525    * @param _spender The address which will spend the funds.
526    * @param _subtractedValue The amount of tokens to decrease the allowance by.
527    * @param _data ABI-encoded contract call to call `_spender` address.
528    */
529   function decreaseApprovalAndCall(address _spender, uint _subtractedValue, bytes _data) public payable returns (bool) {
530     require(_spender != address(this));
531 
532     decreaseApproval(_spender, _subtractedValue);
533 
534     // solium-disable-next-line security/no-call-value
535     require(_spender.call.value(msg.value)(_data));
536 
537     return true;
538   }
539 
540   /**
541    * @param _owner The address that's balance is being requested
542    * @return The balance of `_owner` at the current block
543    */
544   function balanceOf(address _owner) public view returns (uint256) {
545     return balanceOfAt(_owner, block.number);
546   }
547 
548   /**
549    * @dev Queries the balance of `_owner` at a specific `_blockNumber`
550    *
551    * @param _owner The address from which the balance will be retrieved
552    * @param _blockNumber The block number when the balance is queried
553    * @return The balance at `_blockNumber`
554    */
555   function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256) {
556     // These next few lines are used when the balance of the token is
557     //  requested before a check point was ever created for this token, it
558     //  requires that the `parentToken.balanceOfAt` be queried at the
559     //  genesis block for that token as this contains initial balance of
560     //  this token
561     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
562       if (address(parentToken) != address(0)) {
563         return parentToken.balanceOfAt(_owner, Math.min256(_blockNumber, parentSnapShotBlock));
564       } else {
565         // Has no parent
566         return 0;
567       }
568     // This will return the expected balance during normal situations
569     } else {
570       return getValueAt(balances[_owner], _blockNumber);
571     }
572   }
573 
574   /**
575    * @dev This function makes it easy to get the total number of tokens
576    *
577    * @return The total number of tokens
578    */
579   function totalSupply() public view returns (uint256) {
580     return totalSupplyAt(block.number);
581   }
582 
583   /**
584    * @dev Total amount of tokens at a specific `_blockNumber`.
585    *
586    * @param _blockNumber The block number when the totalSupply is queried
587    * @return The total amount of tokens at `_blockNumber`
588    */
589   function totalSupplyAt(uint256 _blockNumber) public view returns(uint256) {
590 
591     // These next few lines are used when the totalSupply of the token is
592     //  requested before a check point was ever created for this token, it
593     //  requires that the `parentToken.totalSupplyAt` be queried at the
594     //  genesis block for this token as that contains totalSupply of this
595     //  token at this block number.
596     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
597       if (address(parentToken) != 0) {
598         return parentToken.totalSupplyAt(Math.min256(_blockNumber, parentSnapShotBlock));
599       } else {
600         return 0;
601       }
602     // This will return the expected totalSupply during normal situations
603     } else {
604       return getValueAt(totalSupplyHistory, _blockNumber);
605     }
606   }
607 
608   /**
609    * @dev Function to mint tokens
610    *
611    * @param _to The address that will receive the minted tokens.
612    * @param _amount The amount of tokens to mint.
613    * @return A boolean that indicates if the operation was successful.
614    */
615   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
616     uint256 curTotalSupply = totalSupply();
617     uint256 lastBalance = balanceOf(_to);
618 
619     updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
620     updateValueAtNow(balances[_to], lastBalance.add(_amount));
621 
622     emit Mint(_to, _amount);
623     emit Transfer(address(0), _to, _amount);
624     return true;
625   }
626 
627   /**
628    * @dev Function to stop minting new tokens.
629    *
630    * @return True if the operation was successful.
631    */
632   function finishMinting() public onlyOwner canMint returns (bool) {
633     mintingFinished = true;
634     emit MintFinished();
635     return true;
636   }
637 
638   /**
639    * @dev Burns a specific amount of tokens.
640    *
641    * @param _value uint256 The amount of token to be burned.
642    */
643   function burn(uint256 _value) public {
644     uint256 lastBalance = balanceOf(msg.sender);
645     require(_value <= lastBalance);
646 
647     address burner = msg.sender;
648     uint256 curTotalSupply = totalSupply();
649 
650     updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_value));
651     updateValueAtNow(balances[burner], lastBalance.sub(_value));
652 
653     emit Burn(burner, _value);
654   }
655 
656   /**
657    * @dev Burns a specific amount of tokens from an address
658    *
659    * @param _from address The address which you want to send tokens from
660    * @param _value uint256 The amount of token to be burned.
661    */
662   function burnFrom(address _from, uint256 _value) public {
663     require(_value <= allowed[_from][msg.sender]);
664 
665     uint256 lastBalance = balanceOfAt(_from, block.number);
666     require(_value <= lastBalance);
667 
668     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
669 
670     address burner = _from;
671     uint256 curTotalSupply = totalSupply();
672 
673     updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_value));
674     updateValueAtNow(balances[burner], lastBalance.sub(_value));
675 
676     emit Burn(burner, _value);
677   }
678 
679   /**
680    * @dev Enables token holders to transfer their tokens freely if true
681    *
682    * @param _transfersEnabled True if transfers are allowed in the clone
683    */
684   function enableTransfers(bool _transfersEnabled) public onlyOwner canMint {
685     transfersEnabled = _transfersEnabled;
686   }
687 
688   /**
689    * @dev This is the actual transfer function in the token contract, it can
690    * @dev only be called by other functions in this contract.
691    *
692    * @param _from The address holding the tokens being transferred
693    * @param _to The address of the recipient
694    * @param _value The amount of tokens to be transferred
695    * @param _lastBalance The last balance of from
696    * @return True if the transfer was successful
697    */
698   function doTransfer(address _from, address _to, uint256 _value, uint256 _lastBalance) internal returns (bool) {
699     if (_value == 0) {
700       return true;
701     }
702 
703     updateValueAtNow(balances[_from], _lastBalance.sub(_value));
704 
705     uint256 previousBalance = balanceOfAt(_to, block.number);
706     updateValueAtNow(balances[_to], previousBalance.add(_value));
707 
708     emit Transfer(_from, _to, _value);
709     return true;
710   }
711 }