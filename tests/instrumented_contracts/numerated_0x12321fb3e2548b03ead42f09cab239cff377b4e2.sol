1 pragma solidity 0.4.18;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions,
5 /// this simplifies the implementation of "user permissions".
6 /// @dev Based on OpenZeppelin's Ownable.
7 
8 contract Ownable {
9     address public owner;
10     address public newOwnerCandidate;
11 
12     event OwnershipRequested(address indexed _by, address indexed _to);
13     event OwnershipTransferred(address indexed _from, address indexed _to);
14 
15     /// @dev Constructor sets the original `owner` of the contract to the sender account.
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20     /// @dev Reverts if called by any account other than the owner.
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     modifier onlyOwnerCandidate() {
27         require(msg.sender == newOwnerCandidate);
28         _;
29     }
30 
31     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
32     /// @param _newOwnerCandidate address The address to transfer ownership to.
33     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
34         require(_newOwnerCandidate != address(0));
35 
36         newOwnerCandidate = _newOwnerCandidate;
37 
38         OwnershipRequested(msg.sender, newOwnerCandidate);
39     }
40 
41     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
42     function acceptOwnership() external onlyOwnerCandidate {
43         address previousOwner = owner;
44 
45         owner = newOwnerCandidate;
46         newOwnerCandidate = address(0);
47 
48         OwnershipTransferred(previousOwner, owner);
49     }
50 }
51 
52 /// @title Math operations with safety checks
53 library SafeMath {
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a * b;
56         require(a == 0 || c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // require(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // require(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75         return c;
76     }
77 
78     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
79         return a >= b ? a : b;
80     }
81 
82     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
83         return a < b ? a : b;
84     }
85 
86     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a >= b ? a : b;
88     }
89 
90     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a < b ? a : b;
92     }
93 
94     function toPower2(uint256 a) internal pure returns (uint256) {
95         return mul(a, a);
96     }
97 
98     function sqrt(uint256 a) internal pure returns (uint256) {
99         uint256 c = (a + 1) / 2;
100         uint256 b = a;
101         while (c < b) {
102             b = c;
103             c = (a / c + c) / 2;
104         }
105         return b;
106     }
107 }
108 
109 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
110 contract ERC20 {
111     uint public totalSupply;
112     function balanceOf(address _owner) constant public returns (uint balance);
113     function transfer(address _to, uint _value) public returns (bool success);
114     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
115     function approve(address _spender, uint _value) public returns (bool success);
116     function allowance(address _owner, address _spender) public constant returns (uint remaining);
117     event Transfer(address indexed from, address indexed to, uint value);
118     event Approval(address indexed owner, address indexed spender, uint value);
119 }
120 
121 
122 
123 /// @title ERC Token Standard #677 Interface (https://github.com/ethereum/EIPs/issues/677)
124 contract ERC677 is ERC20 {
125     function transferAndCall(address to, uint value, bytes data) public returns (bool ok);
126 
127     event TransferAndCall(address indexed from, address indexed to, uint value, bytes data);
128 }
129 
130 /// @title ERC223Receiver Interface
131 /// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
132 contract ERC223Receiver {
133     function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
134 }
135 
136 
137 
138 
139 /// @title Basic ERC20 token contract implementation.
140 /// @dev Based on OpenZeppelin's StandardToken.
141 contract BasicToken is ERC20 {
142     using SafeMath for uint256;
143 
144     uint256 public totalSupply;
145     mapping (address => mapping (address => uint256)) allowed;
146     mapping (address => uint256) balances;
147 
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152     /// @param _spender address The address which will spend the funds.
153     /// @param _value uint256 The amount of tokens to be spent.
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve (see NOTE)
156         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
157             revert();
158         }
159 
160         allowed[msg.sender][_spender] = _value;
161 
162         Approval(msg.sender, _spender, _value);
163 
164         return true;
165     }
166 
167     /// @dev Function to check the amount of tokens that an owner allowed to a spender.
168     /// @param _owner address The address which owns the funds.
169     /// @param _spender address The address which will spend the funds.
170     /// @return uint256 specifying the amount of tokens still available for the spender.
171     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175 
176     /// @dev Gets the balance of the specified address.
177     /// @param _owner address The address to query the the balance of.
178     /// @return uint256 representing the amount owned by the passed address.
179     function balanceOf(address _owner) constant public returns (uint256 balance) {
180         return balances[_owner];
181     }
182 
183     /// @dev Transfer token to a specified address.
184     /// @param _to address The address to transfer to.
185     /// @param _value uint256 The amount to be transferred.
186     function transfer(address _to, uint256 _value) public returns (bool) {
187         require(_to != address(0));
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190 
191         Transfer(msg.sender, _to, _value);
192 
193         return true;
194     }
195 
196     /// @dev Transfer tokens from one address to another.
197     /// @param _from address The address which you want to send tokens from.
198     /// @param _to address The address which you want to transfer to.
199     /// @param _value uint256 the amount of tokens to be transferred.
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201         require(_to != address(0));
202         var _allowance = allowed[_from][msg.sender];
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206 
207         allowed[_from][msg.sender] = _allowance.sub(_value);
208 
209         Transfer(_from, _to, _value);
210 
211         return true;
212     }
213 }
214 
215 
216 
217 
218 
219 
220 /// @title Standard677Token implentation, base on https://github.com/ethereum/EIPs/issues/677
221 
222 contract Standard677Token is ERC677, BasicToken {
223 
224   /// @dev ERC223 safe token transfer from one address to another
225   /// @param _to address the address which you want to transfer to.
226   /// @param _value uint256 the amount of tokens to be transferred.
227   /// @param _data bytes data that can be attached to the token transation
228   function transferAndCall(address _to, uint _value, bytes _data) public returns (bool) {
229     require(super.transfer(_to, _value)); // do a normal token transfer
230     TransferAndCall(msg.sender, _to, _value, _data);
231     //filtering if the target is a contract with bytecode inside it
232     if (isContract(_to)) return contractFallback(_to, _value, _data);
233     return true;
234   }
235 
236   /// @dev called when transaction target is a contract
237   /// @param _to address the address which you want to transfer to.
238   /// @param _value uint256 the amount of tokens to be transferred.
239   /// @param _data bytes data that can be attached to the token transation
240   function contractFallback(address _to, uint _value, bytes _data) private returns (bool) {
241     ERC223Receiver receiver = ERC223Receiver(_to);
242     require(receiver.tokenFallback(msg.sender, _value, _data));
243     return true;
244   }
245 
246   /// @dev check if the address is contract
247   /// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
248   /// @param _addr address the address to check
249   function isContract(address _addr) private constant returns (bool is_contract) {
250     // retrieve the size of the code on target address, this needs assembly
251     uint length;
252     assembly { length := extcodesize(_addr) }
253     return length > 0;
254   }
255 }
256 
257 
258 
259 
260 
261 /// @title Token holder contract.
262 contract TokenHolder is Ownable {
263     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
264     /// @param _tokenAddress address The address of the ERC20 contract.
265     /// @param _amount uint256 The amount of tokens to be transferred.
266     function transferAnyERC20Token(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
267         return ERC20(_tokenAddress).transfer(owner, _amount);
268     }
269 }
270 
271 
272 
273 
274 
275 
276 /// @title Colu Local Network contract.
277 /// @author Tal Beja.
278 contract ColuLocalNetwork is Ownable, Standard677Token, TokenHolder {
279     using SafeMath for uint256;
280 
281     string public constant name = "Colu Local Network";
282     string public constant symbol = "CLN";
283 
284     // Using same decimals value as ETH (makes ETH-CLN conversion much easier).
285     uint8 public constant decimals = 18;
286 
287     // States whether token transfers is allowed or not.
288     // Used during token sale.
289     bool public isTransferable = false;
290 
291     event TokensTransferable();
292 
293     modifier transferable() {
294         require(msg.sender == owner || isTransferable);
295         _;
296     }
297 
298     /// @dev Creates all tokens and gives them to the owner.
299     function ColuLocalNetwork(uint256 _totalSupply) public {
300         totalSupply = _totalSupply;
301         balances[msg.sender] = totalSupply;
302     }
303 
304     /// @dev start transferable mode.
305     function makeTokensTransferable() external onlyOwner {
306         if (isTransferable) {
307             return;
308         }
309 
310         isTransferable = true;
311 
312         TokensTransferable();
313     }
314 
315     /// @dev Same ERC20 behavior, but reverts if not transferable.
316     /// @param _spender address The address which will spend the funds.
317     /// @param _value uint256 The amount of tokens to be spent.
318     function approve(address _spender, uint256 _value) public transferable returns (bool) {
319         return super.approve(_spender, _value);
320     }
321 
322     /// @dev Same ERC20 behavior, but reverts if not transferable.
323     /// @param _to address The address to transfer to.
324     /// @param _value uint256 The amount to be transferred.
325     function transfer(address _to, uint256 _value) public transferable returns (bool) {
326         return super.transfer(_to, _value);
327     }
328 
329     /// @dev Same ERC20 behavior, but reverts if not transferable.
330     /// @param _from address The address to send tokens from.
331     /// @param _to address The address to transfer to.
332     /// @param _value uint256 the amount of tokens to be transferred.
333     function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {
334         return super.transferFrom(_from, _to, _value);
335     }
336 
337     /// @dev Same ERC677 behavior, but reverts if not transferable.
338     /// @param _to address The address to transfer to.
339     /// @param _value uint256 The amount to be transferred.
340     /// @param _data bytes data to send to receiver if it is a contract.
341     function transferAndCall(address _to, uint _value, bytes _data) public transferable returns (bool success) {
342       return super.transferAndCall(_to, _value, _data);
343     }
344 }
345 
346 
347 
348  /// @title Standard ERC223 Token Receiver implementing tokenFallback function and tokenPayable modifier
349 
350 contract Standard223Receiver is ERC223Receiver {
351   Tkn tkn;
352 
353   struct Tkn {
354     address addr;
355     address sender; // the transaction caller
356     uint256 value;
357   }
358 
359   bool __isTokenFallback;
360 
361   modifier tokenPayable {
362     require(__isTokenFallback);
363     _;
364   }
365 
366   /// @dev Called when the receiver of transfer is contract
367   /// @param _sender address the address of tokens sender
368   /// @param _value uint256 the amount of tokens to be transferred.
369   /// @param _data bytes data that can be attached to the token transation
370   function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok) {
371     if (!supportsToken(msg.sender)) {
372       return false;
373     }
374 
375     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
376     // Solution: Remove the the data
377     tkn = Tkn(msg.sender, _sender, _value);
378     __isTokenFallback = true;
379     if (!address(this).delegatecall(_data)) {
380       __isTokenFallback = false;
381       return false;
382     }
383     // avoid doing an overwrite to .token, which would be more expensive
384     // makes accessing .tkn values outside tokenPayable functions unsafe
385     __isTokenFallback = false;
386 
387     return true;
388   }
389 
390   function supportsToken(address token) public constant returns (bool);
391 }
392 
393 
394 
395 
396 
397 /// @title TokenOwnable
398 /// @dev The TokenOwnable contract adds a onlyTokenOwner modifier as a tokenReceiver with ownable addaptation
399 
400 contract TokenOwnable is Standard223Receiver, Ownable {
401     /// @dev Reverts if called by any account other than the owner for token sending.
402     modifier onlyTokenOwner() {
403         require(tkn.sender == owner);
404         _;
405     }
406 }
407 
408 
409 
410 
411 
412 
413 /// @title Vesting trustee contract for Colu Local Network.
414 /// @dev This Contract can't be TokenHolder, since it will allow its owner to drain its vested tokens.
415 /// @dev This means that any token sent to it different than ColuLocalNetwork is basicly stucked here forever.
416 /// @dev ColuLocalNetwork that sent here (by mistake) can withdrawn using the grant method.
417 contract VestingTrustee is TokenOwnable {
418     using SafeMath for uint256;
419 
420     // Colu Local Network contract.
421     ColuLocalNetwork public cln;
422 
423     // Vesting grant for a speicifc holder.
424     struct Grant {
425         uint256 value;
426         uint256 start;
427         uint256 cliff;
428         uint256 end;
429         uint256 installmentLength; // In seconds.
430         uint256 transferred;
431         bool revokable;
432     }
433 
434     // Holder to grant information mapping.
435     mapping (address => Grant) public grants;
436 
437     // Total tokens vested.
438     uint256 public totalVesting;
439 
440     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
441     event TokensUnlocked(address indexed _to, uint256 _value);
442     event GrantRevoked(address indexed _holder, uint256 _refund);
443 
444     uint constant OK = 1;
445     uint constant ERR_INVALID_VALUE = 10001;
446     uint constant ERR_INVALID_VESTED = 10002;
447     uint constant ERR_INVALID_TRANSFERABLE = 10003;
448 
449     event Error(address indexed sender, uint error);
450 
451     /// @dev Constructor that initializes the address of the Colu Local Network contract.
452     /// @param _cln ColuLocalNetwork The address of the previously deployed Colu Local Network contract.
453     function VestingTrustee(ColuLocalNetwork _cln) public {
454         require(_cln != address(0));
455 
456         cln = _cln;
457     }
458 
459     /// @dev Allow only cln token to be tokenPayable
460     /// @param token the token to check
461     function supportsToken(address token) public constant returns (bool) {
462         return (cln == token);
463     }
464 
465     /// @dev Grant tokens to a specified address.
466     /// @param _to address The holder address.
467     /// @param _start uint256 The beginning of the vesting period (timestamp).
468     /// @param _cliff uint256 When the first installment is made (timestamp).
469     /// @param _end uint256 The end of the vesting period (timestamp).
470     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
471     /// @param _revokable bool Whether the grant is revokable or not.
472     function grant(address _to, uint256 _start, uint256 _cliff, uint256 _end,
473         uint256 _installmentLength, bool _revokable)
474         external onlyTokenOwner tokenPayable {
475 
476         require(_to != address(0));
477         require(_to != address(this)); // Protect this contract from receiving a grant.
478 
479         uint256 value = tkn.value;
480 
481         require(value > 0);
482 
483         // Require that every holder can be granted tokens only once.
484         require(grants[_to].value == 0);
485 
486         // Require for time ranges to be consistent and valid.
487         require(_start <= _cliff && _cliff <= _end);
488 
489         // Require installment length to be valid and no longer than (end - start).
490         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
491 
492         // Grant must not exceed the total amount of tokens currently available for vesting.
493         require(totalVesting.add(value) <= cln.balanceOf(address(this)));
494 
495         // Assign a new grant.
496         grants[_to] = Grant({
497             value: value,
498             start: _start,
499             cliff: _cliff,
500             end: _end,
501             installmentLength: _installmentLength,
502             transferred: 0,
503             revokable: _revokable
504         });
505 
506         // Since tokens have been granted, increase the total amount vested.
507         totalVesting = totalVesting.add(value);
508 
509         NewGrant(msg.sender, _to, value);
510     }
511 
512     /// @dev Grant tokens to a specified address.
513     /// @param _to address The holder address.
514     /// @param _value uint256 The amount of tokens to be granted.
515     /// @param _start uint256 The beginning of the vesting period (timestamp).
516     /// @param _cliff uint256 When the first installment is made (timestamp).
517     /// @param _end uint256 The end of the vesting period (timestamp).
518     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
519     /// @param _revokable bool Whether the grant is revokable or not.
520     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
521         uint256 _installmentLength, bool _revokable)
522         external onlyOwner {
523 
524         require(_to != address(0));
525         require(_to != address(this)); // Protect this contract from receiving a grant.
526         require(_value > 0);
527 
528         // Require that every holder can be granted tokens only once.
529         require(grants[_to].value == 0);
530 
531         // Require for time ranges to be consistent and valid.
532         require(_start <= _cliff && _cliff <= _end);
533 
534         // Require installment length to be valid and no longer than (end - start).
535         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
536 
537         // Grant must not exceed the total amount of tokens currently available for vesting.
538         require(totalVesting.add(_value) <= cln.balanceOf(address(this)));
539 
540         // Assign a new grant.
541         grants[_to] = Grant({
542             value: _value,
543             start: _start,
544             cliff: _cliff,
545             end: _end,
546             installmentLength: _installmentLength,
547             transferred: 0,
548             revokable: _revokable
549         });
550 
551         // Since tokens have been granted, increase the total amount vested.
552         totalVesting = totalVesting.add(_value);
553 
554         NewGrant(msg.sender, _to, _value);
555     }
556 
557     /// @dev Revoke the grant of tokens of a specifed address.
558     /// @dev Unlocked tokens will be sent to the grantee, the rest is transferred to the trustee's owner.
559     /// @param _holder The address which will have its tokens revoked.
560     function revoke(address _holder) public onlyOwner {
561         Grant memory grant = grants[_holder];
562 
563         // Grant must be revokable.
564         require(grant.revokable);
565 
566         // Get the total amount of vested tokens, acccording to grant.
567         uint256 vested = calculateVestedTokens(grant, now);
568 
569         // Calculate the untransferred vested tokens.
570         uint256 transferable = vested.sub(grant.transferred);
571 
572         if (transferable > 0) {
573             // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
574             grant.transferred = grant.transferred.add(transferable);
575             totalVesting = totalVesting.sub(transferable);
576             require(cln.transfer(_holder, transferable));
577 
578             TokensUnlocked(_holder, transferable);
579         }
580 
581         // Calculate amount of remaining tokens that can still be returned.
582         uint256 refund = grant.value.sub(grant.transferred);
583 
584         // Remove the grant.
585         delete grants[_holder];
586 
587         // Update total vesting amount and transfer previously calculated tokens to owner.
588         totalVesting = totalVesting.sub(refund);
589         require(cln.transfer(msg.sender, refund));
590 
591         GrantRevoked(_holder, refund);
592     }
593 
594     /// @dev Calculate the amount of ready tokens of a holder.
595     /// @param _holder address The address of the holder.
596     /// @return a uint256 Representing a holder's total amount of vested tokens.
597     function readyTokens(address _holder) public constant returns (uint256) {
598         Grant memory grant = grants[_holder];
599 
600         if (grant.value == 0) {
601             return 0;
602         }
603 
604         uint256 vested = calculateVestedTokens(grant, now);
605 
606         if (vested == 0) {
607             return 0;
608         }
609 
610         return vested.sub(grant.transferred);
611     }
612 
613     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
614     /// @param _holder address The address of the holder.
615     /// @param _time uint256 The specific time to calculate against.
616     /// @return a uint256 Representing a holder's total amount of vested tokens.
617     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
618         Grant memory grant = grants[_holder];
619         if (grant.value == 0) {
620             return 0;
621         }
622 
623         return calculateVestedTokens(grant, _time);
624     }
625 
626     /// @dev Calculate amount of vested tokens at a specifc time.
627     /// @param _grant Grant The vesting grant.
628     /// @param _time uint256 The time to be checked
629     /// @return An uint256 Representing the amount of vested tokens of a specific grant.
630     function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {
631         // If we're before the cliff, then nothing is vested.
632         if (_time < _grant.cliff) {
633             return 0;
634         }
635 
636         // If we're after the end of the vesting period - everything is vested.
637         if (_time >= _grant.end) {
638             return _grant.value;
639         }
640 
641         // Calculate amount of installments past until now.
642         //
643         // NOTE: result gets floored because of integer division.
644         uint256 installmentsPast = _time.sub(_grant.start).div(_grant.installmentLength);
645 
646         // Calculate amount of days in entire vesting period.
647         uint256 vestingDays = _grant.end.sub(_grant.start);
648 
649         // Calculate and return the number of tokens according to vesting days that have passed.
650         return _grant.value.mul(installmentsPast.mul(_grant.installmentLength)).div(vestingDays);
651     }
652 
653     /// @dev Unlock vested tokens and transfer them to the grantee.
654     /// @return a uint The success or error code.
655     function unlockVestedTokens() external returns (uint) {
656         return unlockVestedTokens(msg.sender);
657     }
658 
659     /// @dev Unlock vested tokens and transfer them to the grantee (helper function).
660     /// @param _grantee address The address of the grantee.
661     /// @return a uint The success or error code.
662     function unlockVestedTokens(address _grantee) private returns (uint) {
663         Grant storage grant = grants[_grantee];
664 
665         // Make sure the grant has tokens available.
666         if (grant.value == 0) {
667             Error(_grantee, ERR_INVALID_VALUE);
668             return ERR_INVALID_VALUE;
669         }
670 
671         // Get the total amount of vested tokens, acccording to grant.
672         uint256 vested = calculateVestedTokens(grant, now);
673         if (vested == 0) {
674             Error(_grantee, ERR_INVALID_VESTED);
675             return ERR_INVALID_VESTED;
676         }
677 
678         // Make sure the holder doesn't transfer more than what he already has.
679         uint256 transferable = vested.sub(grant.transferred);
680         if (transferable == 0) {
681             Error(_grantee, ERR_INVALID_TRANSFERABLE);
682             return ERR_INVALID_TRANSFERABLE;
683         }
684 
685         // Update transferred and total vesting amount, then transfer remaining vested funds to holder.
686         grant.transferred = grant.transferred.add(transferable);
687         totalVesting = totalVesting.sub(transferable);
688         require(cln.transfer(_grantee, transferable));
689 
690         TokensUnlocked(_grantee, transferable);
691         return OK;
692     }
693 
694     /// @dev batchUnlockVestedTokens vested tokens and transfer them to the grantees.
695     /// @param _grantees address[] The addresses of the grantees.
696     /// @return a boo if success.
697     function batchUnlockVestedTokens(address[] _grantees) external onlyOwner returns (bool success) {
698         for (uint i = 0; i<_grantees.length; i++) {
699             unlockVestedTokens(_grantees[i]);
700         }
701         return true;
702     }
703 
704     /// @dev Allow the owner to transfer out any accidentally sent ERC20 tokens.
705     /// @param _tokenAddress address The address of the ERC20 contract.
706     /// @param _amount uint256 The amount of tokens to be transferred.
707     function withdrawERC20(address _tokenAddress, uint256 _amount) public onlyOwner returns (bool success) {
708         if (_tokenAddress == address(cln)) {
709             // If the token is cln, allow to withdraw only non vested tokens.
710             uint256 availableCLN = cln.balanceOf(this).sub(totalVesting);
711             require(_amount <= availableCLN);
712         }
713         return ERC20(_tokenAddress).transfer(owner, _amount);
714     }
715 }
716 
717 
718 
719 
720 
721 
722 
723 
724 /// @title Colu Local Network sale contract.
725 /// @author Tal Beja.
726 contract ColuLocalNetworkSale is Ownable, TokenHolder {
727     using SafeMath for uint256;
728 
729     // External parties:
730 
731     // Colu Local Network contract.
732     ColuLocalNetwork public cln;
733 
734     // Vesting contract for presale participants.
735     VestingTrustee public trustee;
736 
737     // Received funds are forwarded to this address.
738     address public fundingRecipient;
739 
740     // Post-TDE multisig addresses.
741     address public communityPoolAddress;
742     address public futureDevelopmentPoolAddress;
743     address public stakeholdersPoolAddress;
744 
745     // Colu Local Network decimals.
746     // Using same decimals value as ETH (makes ETH-CLN conversion much easier).
747     // This is the same as in Colu Local Network contract.
748     uint256 public constant TOKEN_DECIMALS = 10 ** 18;
749 
750     // Additional Lockup Allocation Pool
751     uint256 public constant ALAP = 40701333592592592592614116;
752 
753     // Maximum number of tokens in circulation: 1.5 trillion.
754     uint256 public constant MAX_TOKENS = 15 * 10 ** 8 * TOKEN_DECIMALS + ALAP;
755 
756     // Maximum tokens offered in the sale (35%) + ALAP.
757     uint256 public constant MAX_TOKENS_SOLD = 525 * 10 ** 6 * TOKEN_DECIMALS + ALAP;
758 
759     // Maximum tokens offered in the presale (from the initial 35% offered tokens) + ALAP.
760     uint256 public constant MAX_PRESALE_TOKENS_SOLD = 2625 * 10 ** 5 * TOKEN_DECIMALS + ALAP;
761 
762     // Tokens allocated for Community pool (30%).
763     uint256 public constant COMMUNITY_POOL = 45 * 10 ** 7 * TOKEN_DECIMALS;
764 
765     // Tokens allocated for Future development pool (29%).
766     uint256 public constant FUTURE_DEVELOPMENT_POOL = 435 * 10 ** 6 * TOKEN_DECIMALS;
767 
768     // Tokens allocated for Stakeholdes pool (6%).
769     uint256 public constant STAKEHOLDERS_POOL = 9 * 10 ** 7 * TOKEN_DECIMALS;
770 
771     // CLN to ETH ratio.
772     uint256 public constant CLN_PER_ETH = 8600;
773 
774     // Sale start, end blocks (time ranges)
775     uint256 public constant SALE_DURATION = 4 days;
776     uint256 public startTime;
777     uint256 public endTime;
778 
779     // Amount of tokens sold until now in the sale.
780     uint256 public tokensSold = 0;
781 
782     // Amount of tokens sold until now in the presale.
783     uint256 public presaleTokensSold = 0;
784 
785     // Accumulated amount each participant has contributed so far in the sale (in WEI).
786     mapping (address => uint256) public participationHistory;
787 
788     // Accumulated amount each participant have contributed so far in the presale.
789     mapping (address => uint256) public participationPresaleHistory;
790 
791     // Maximum amount that each particular is allowed to contribute (in ETH-WEI).
792     // Defaults to zero. Serving as a functional whitelist. 
793     mapping (address => uint256) public participationCaps;
794 
795     // Maximum amount ANYONE is currently allowed to contribute. Set to max uint256 so no limitation other than personal participationCaps.
796     uint256 public hardParticipationCap = uint256(-1);
797 
798     // initialization of the contract, splitted from the constructor to avoid gas block limit.
799     bool public initialized = false;
800 
801     // Vesting plan structure for presale
802     struct VestingPlan {
803         uint256 startOffset;
804         uint256 cliffOffset;
805         uint256 endOffset;
806         uint256 installmentLength;
807         uint8 alapPercent;
808     }
809 
810     // Vesting plans for presale
811     VestingPlan[] public vestingPlans;
812 
813     // Each token that is sent from the ColuLocalNetworkSale is considered as issued.
814     event TokensIssued(address indexed to, uint256 tokens);
815 
816     /// @dev Reverts if called not before the sale.
817     modifier onlyBeforeSale() {
818         if (now >= startTime) {
819             revert();
820         }
821 
822         _;
823     }
824 
825     /// @dev Reverts if called not during the sale.
826     modifier onlyDuringSale() {
827         if (tokensSold >= MAX_TOKENS_SOLD || now < startTime || now >= endTime) {
828             revert();
829         }
830 
831         _;
832     }
833 
834     /// @dev Reverts if called before the sale ends.
835     modifier onlyAfterSale() {
836         if (!(tokensSold >= MAX_TOKENS_SOLD || now >= endTime)) {
837             revert();
838         }
839 
840         _;
841     }
842 
843     /// @dev Reverts if called before the sale is initialized.
844     modifier notInitialized() {
845         if (initialized) {
846             revert();
847         }
848 
849         _;
850     }
851 
852 
853     /// @dev Reverts if called after the sale is initialized.
854     modifier isInitialized() {
855         if (!initialized) {
856             revert();
857         }
858 
859         _;
860     }
861 
862     /// @dev Constructor sets the sale addresses and start time.
863     /// @param _owner address The address of this contract owner.
864     /// @param _fundingRecipient address The address of the funding recipient.
865     /// @param _communityPoolAddress address The address of the community pool.
866     /// @param _futureDevelopmentPoolAddress address The address of the future development pool.
867     /// @param _stakeholdersPoolAddress address The address of the team pool.
868     /// @param _startTime uint256 The start time of the token sale.
869     function ColuLocalNetworkSale(address _owner,
870         address _fundingRecipient,
871         address _communityPoolAddress,
872         address _futureDevelopmentPoolAddress,
873         address _stakeholdersPoolAddress,
874         uint256 _startTime) public {
875         require(_owner != address(0));
876         require(_fundingRecipient != address(0));
877         require(_communityPoolAddress != address(0));
878         require(_futureDevelopmentPoolAddress != address(0));
879         require(_stakeholdersPoolAddress != address(0));
880         require(_startTime > now);
881 
882         owner = _owner;
883         fundingRecipient = _fundingRecipient;
884         communityPoolAddress = _communityPoolAddress;
885         futureDevelopmentPoolAddress = _futureDevelopmentPoolAddress;
886         stakeholdersPoolAddress = _stakeholdersPoolAddress;
887         startTime = _startTime;
888         endTime = startTime + SALE_DURATION;
889     }
890 
891     /// @dev Initialize the sale conditions.
892     function initialize() public onlyOwner notInitialized {
893         initialized = true;
894 
895         uint256 months = 1 years / 12;
896 
897         vestingPlans.push(VestingPlan(0, 0, 1, 1, 0));
898         vestingPlans.push(VestingPlan(0, 0, 6 * months, 1 * months, 4));
899         vestingPlans.push(VestingPlan(0, 0, 1 years, 1 * months, 12));
900         vestingPlans.push(VestingPlan(0, 0, 2 years, 1 * months, 26));
901         vestingPlans.push(VestingPlan(0, 0, 3 years, 1 * months, 35));
902 
903         // Deploy new ColuLocalNetwork contract.
904         cln = new ColuLocalNetwork(MAX_TOKENS);
905 
906         // Deploy new VestingTrustee contract.
907         trustee = new VestingTrustee(cln);
908 
909         // allocate pool tokens:
910         // Issue the remaining tokens to designated pools.
911         require(transferTokens(communityPoolAddress, COMMUNITY_POOL));
912 
913         // stakeholdersPoolAddress will create its own vesting trusts.
914         require(transferTokens(stakeholdersPoolAddress, STAKEHOLDERS_POOL));
915     }
916 
917     /// @dev Allocate tokens to presale participant according to its vesting plan and invesment value.
918     /// @param _recipient address The presale participant address to recieve the tokens.
919     /// @param _etherValue uint256 The invesment value (in ETH).
920     /// @param _vestingPlanIndex uint8 The vesting plan index.
921     function presaleAllocation(address _recipient, uint256 _etherValue, uint8 _vestingPlanIndex) external onlyOwner onlyBeforeSale isInitialized {
922         require(_recipient != address(0));
923         require(_vestingPlanIndex < vestingPlans.length);
924 
925         // Calculate plan and token amount.
926         VestingPlan memory plan = vestingPlans[_vestingPlanIndex];
927         uint256 tokensAndALAPPerEth = CLN_PER_ETH.mul(SafeMath.add(100, plan.alapPercent)).div(100);
928 
929         uint256 tokensLeftInPreSale = MAX_PRESALE_TOKENS_SOLD.sub(presaleTokensSold);
930         uint256 weiLeftInSale = tokensLeftInPreSale.div(tokensAndALAPPerEth);
931         uint256 weiToParticipate = SafeMath.min256(_etherValue, weiLeftInSale);
932         require(weiToParticipate > 0);
933         participationPresaleHistory[msg.sender] = participationPresaleHistory[msg.sender].add(weiToParticipate);
934         uint256 tokensToTransfer = weiToParticipate.mul(tokensAndALAPPerEth);
935         presaleTokensSold = presaleTokensSold.add(tokensToTransfer);
936         tokensSold = tokensSold.add(tokensToTransfer);
937 
938         // Transfer tokens to trustee and create grant.
939         grant(_recipient, tokensToTransfer, startTime.add(plan.startOffset), startTime.add(plan.cliffOffset),
940             startTime.add(plan.endOffset), plan.installmentLength, false);
941     }
942 
943     /// @dev Add a list of participants to a capped participation tier.
944     /// @param _participants address[] The list of participant addresses.
945     /// @param _cap uint256 The cap amount (in ETH-WEI).
946     function setParticipationCap(address[] _participants, uint256 _cap) external onlyOwner isInitialized {
947         for (uint i = 0; i < _participants.length; i++) {
948             participationCaps[_participants[i]] = _cap;
949         }
950     }
951 
952     /// @dev Set hard participation cap for all participants.
953     /// @param _cap uint256 The hard cap amount.
954     function setHardParticipationCap(uint256 _cap) external onlyOwner isInitialized {
955         require(_cap > 0);
956 
957         hardParticipationCap = _cap;
958     }
959 
960     /// @dev Fallback function that will delegate the request to participate().
961     function () external payable onlyDuringSale isInitialized {
962         participate(msg.sender);
963     }
964 
965     /// @dev Create and sell tokens to the caller.
966     /// @param _recipient address The address of the recipient receiving the tokens.
967     function participate(address _recipient) public payable onlyDuringSale isInitialized {
968         require(_recipient != address(0));
969 
970         // Enforce participation cap (in WEI received).
971         uint256 weiAlreadyParticipated = participationHistory[_recipient];
972         uint256 participationCap = SafeMath.min256(participationCaps[_recipient], hardParticipationCap);
973         uint256 cappedWeiReceived = SafeMath.min256(msg.value, participationCap.sub(weiAlreadyParticipated));
974         require(cappedWeiReceived > 0);
975 
976         // Accept funds and transfer to funding recipient.
977         uint256 tokensLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold);
978         uint256 weiLeftInSale = tokensLeftInSale.div(CLN_PER_ETH);
979         uint256 weiToParticipate = SafeMath.min256(cappedWeiReceived, weiLeftInSale);
980         participationHistory[_recipient] = weiAlreadyParticipated.add(weiToParticipate);
981         fundingRecipient.transfer(weiToParticipate);
982 
983         // Transfer tokens to recipient.
984         uint256 tokensToTransfer = weiToParticipate.mul(CLN_PER_ETH);
985         if (tokensLeftInSale.sub(tokensToTransfer) < CLN_PER_ETH) {
986             // If purchase would cause less than CLN_PER_ETH tokens to be left then nobody could ever buy them.
987             // So, gift them to the last buyer.
988             tokensToTransfer = tokensLeftInSale;
989         }
990         tokensSold = tokensSold.add(tokensToTransfer);
991         require(transferTokens(_recipient, tokensToTransfer));
992 
993         // Partial refund if full participation not possible
994         // e.g. due to cap being reached.
995         uint256 refund = msg.value.sub(weiToParticipate);
996         if (refund > 0) {
997             msg.sender.transfer(refund);
998         }
999     }
1000 
1001     /// @dev Finalizes the token sale event: make future development pool grant (lockup) and make token transfarable.
1002     function finalize() external onlyAfterSale onlyOwner isInitialized {
1003         if (cln.isTransferable()) {
1004             revert();
1005         }
1006 
1007         // Add unsold token to the future development pool grant (lockup).
1008         uint256 tokensLeftInSale = MAX_TOKENS_SOLD.sub(tokensSold);
1009         uint256 futureDevelopmentPool = FUTURE_DEVELOPMENT_POOL.add(tokensLeftInSale);
1010         // Future Development Pool is locked for 3 years.
1011         grant(futureDevelopmentPoolAddress, futureDevelopmentPool, startTime, startTime.add(3 years),
1012             startTime.add(3 years), 1 days, false);
1013 
1014         // Make tokens Transferable, end the sale!.
1015         cln.makeTokensTransferable();
1016     }
1017 
1018     function grant(address _grantee, uint256 _amount, uint256 _start, uint256 _cliff, uint256 _end,
1019         uint256 _installmentLength, bool _revokable) private {
1020         // bytes4 grantSig = bytes4(keccak256("grant(address,uint256,uint256,uint256,uint256,bool)"));
1021         bytes4 grantSig = 0x5ee7e96d;
1022         // 6 arguments of size 32
1023         uint256 argsSize = 6 * 32;
1024         // sig + arguments size
1025         uint256 dataSize = 4 + argsSize;
1026 
1027         bytes memory m_data = new bytes(dataSize);
1028 
1029         assembly {
1030             // Add the signature first to memory
1031             mstore(add(m_data, 0x20), grantSig)
1032             // Add the parameters
1033             mstore(add(m_data, 0x24), _grantee)
1034             mstore(add(m_data, 0x44), _start)
1035             mstore(add(m_data, 0x64), _cliff)
1036             mstore(add(m_data, 0x84), _end)
1037             mstore(add(m_data, 0xa4), _installmentLength)
1038             mstore(add(m_data, 0xc4), _revokable)
1039         }
1040 
1041         require(transferTokens(trustee, _amount, m_data));
1042     }
1043 
1044     /// @dev Transfer tokens from the sale contract to a recipient.
1045     /// @param _recipient address The address of the recipient.
1046     /// @param _tokens uint256 The amount of tokens to transfer.
1047     function transferTokens(address _recipient, uint256 _tokens) private returns (bool ans) {
1048         ans = cln.transfer(_recipient, _tokens);
1049         if (ans) {
1050             TokensIssued(_recipient, _tokens);
1051         }
1052     }
1053 
1054     /// @dev Transfer tokens from the sale contract to a recipient.
1055     /// @param _recipient address The address of the recipient.
1056     /// @param _tokens uint256 The amount of tokens to transfer.
1057     /// @param _data bytes data to send to receiver if it is a contract.
1058     function transferTokens(address _recipient, uint256 _tokens, bytes _data) private returns (bool ans) {
1059         // Request Colu Local Network contract to transfer the requested tokens for the buyer.
1060         ans = cln.transferAndCall(_recipient, _tokens, _data);
1061         if (ans) {
1062             TokensIssued(_recipient, _tokens);
1063         }
1064     }
1065 
1066     /// @dev Requests to transfer control of the Colu Local Network contract to a new owner.
1067     /// @param _newOwnerCandidate address The address to transfer ownership to.
1068     ///
1069     /// NOTE:
1070     ///   1. The new owner will need to call Colu Local Network contract's acceptOwnership directly in order to accept the ownership.
1071     ///   2. Calling this method during the token sale will prevent the token sale to continue, since only the owner of
1072     ///      the Colu Local Network contract can transfer tokens during the sale.
1073     function requestColuLocalNetworkOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
1074         cln.requestOwnershipTransfer(_newOwnerCandidate);
1075     }
1076 
1077     /// @dev Accepts new ownership on behalf of the Colu Local Network contract.
1078     // This can be used by the sale contract itself to claim back ownership of the Colu Local Network contract.
1079     function acceptColuLocalNetworkOwnership() external onlyOwner {
1080         cln.acceptOwnership();
1081     }
1082 
1083     /// @dev Requests to transfer control of the VestingTrustee contract to a new owner.
1084     /// @param _newOwnerCandidate address The address to transfer ownership to.
1085     ///
1086     /// NOTE:
1087     ///   1. The new owner will need to call trustee contract's acceptOwnership directly in order to accept the ownership.
1088     ///   2. Calling this method during the token sale will prevent the token sale from alocation presale grunts add finalize, since only the owner of
1089     ///      the trustee contract can create grunts needed in the presaleAlocation add finalize methods.
1090     function requestVestingTrusteeOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
1091         trustee.requestOwnershipTransfer(_newOwnerCandidate);
1092     }
1093 
1094     /// @dev Accepts new ownership on behalf of the VestingTrustee contract.
1095     /// This can be used by the token sale contract itself to claim back ownership of the VestingTrustee contract.
1096     function acceptVestingTrusteeOwnership() external onlyOwner {
1097         trustee.acceptOwnership();
1098     }
1099 }