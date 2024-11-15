1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     function transfer(address _to, uint _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
6     function approve(address _spender, uint _value) public returns (bool success);
7 }
8 
9 /// @title localethereum.com
10 /// @author localethereum.com
11 contract LocalEthereumEscrows {
12     /***********************
13     +   Global settings   +
14     ***********************/
15 
16     // Address of the arbitrator (currently always localethereum staff)
17     address public arbitrator;
18     // Address of the owner (who can withdraw collected fees)
19     address public owner;
20     // Address of the relayer (who is allowed to forward signed instructions from parties)
21     address public relayer;
22     uint32 public requestCancellationMinimumTime;
23     // Cumulative balance of collected fees
24     uint256 public feesAvailableForWithdraw;
25 
26     /***********************
27     +  Instruction types  +
28     ***********************/
29 
30     // Called when the buyer marks payment as sent. Locks funds in escrow
31     uint8 constant INSTRUCTION_SELLER_CANNOT_CANCEL = 0x01;
32     // Buyer cancelling
33     uint8 constant INSTRUCTION_BUYER_CANCEL = 0x02;
34     // Seller cancelling
35     uint8 constant INSTRUCTION_SELLER_CANCEL = 0x03;
36     // Seller requesting to cancel. Begins a window for buyer to object
37     uint8 constant INSTRUCTION_SELLER_REQUEST_CANCEL = 0x04;
38     // Seller releasing funds to the buyer
39     uint8 constant INSTRUCTION_RELEASE = 0x05;
40     // Either party permitting the arbitrator to resolve a dispute
41     uint8 constant INSTRUCTION_RESOLVE = 0x06;
42 
43     /***********************
44     +       Events        +
45     ***********************/
46 
47     event Created(bytes32 indexed _tradeHash);
48     event SellerCancelDisabled(bytes32 indexed _tradeHash);
49     event SellerRequestedCancel(bytes32 indexed _tradeHash);
50     event CancelledBySeller(bytes32 indexed _tradeHash);
51     event CancelledByBuyer(bytes32 indexed _tradeHash);
52     event Released(bytes32 indexed _tradeHash);
53     event DisputeResolved(bytes32 indexed _tradeHash);
54 
55     struct Escrow {
56         // So we know the escrow exists
57         bool exists;
58         // This is the timestamp in whic hthe seller can cancel the escrow after.
59         // It has two special values:
60         // 0 : Permanently locked by the buyer (i.e. marked as paid; the seller can never cancel)
61         // 1 : The seller can only request to cancel, which will change this value to a timestamp.
62         //     This option is avaialble for complex trade terms such as cash-in-person where a
63         //     payment window is inappropriate
64         uint32 sellerCanCancelAfter;
65         // Cumulative cost of gas incurred by the relayer. This amount will be refunded to the owner
66         // in the way of fees once the escrow has completed
67         uint128 totalGasFeesSpentByRelayer;
68     }
69 
70     // Mapping of active trades. The key here is a hash of the trade proprties
71     mapping (bytes32 => Escrow) public escrows;
72 
73     modifier onlyOwner() {
74         require(msg.sender == owner, "Must be owner");
75         _;
76     }
77 
78     modifier onlyArbitrator() {
79         require(msg.sender == arbitrator, "Must be arbitrator");
80         _;
81     }
82 
83     /// @notice Initialize the contract.
84     constructor() public {
85         owner = msg.sender;
86         arbitrator = msg.sender;
87         relayer = msg.sender;
88         requestCancellationMinimumTime = 2 hours;
89     }
90 
91     /// @notice Create and fund a new escrow.
92     /// @param _tradeID The unique ID of the trade, generated by localethereum.com
93     /// @param _seller The selling party
94     /// @param _buyer The buying party
95     /// @param _value The amount of the escrow, exclusive of the fee
96     /// @param _fee Localethereum's commission in 1/10000ths
97     /// @param _paymentWindowInSeconds The time in seconds from escrow creation that the seller can cancel after
98     /// @param _expiry This transaction must be created before this time
99     /// @param _v Signature "v" component
100     /// @param _r Signature "r" component
101     /// @param _s Signature "s" component
102     function createEscrow(
103         bytes16 _tradeID,
104         address _seller,
105         address _buyer,
106         uint256 _value,
107         uint16 _fee,
108         uint32 _paymentWindowInSeconds,
109         uint32 _expiry,
110         uint8 _v,
111         bytes32 _r,
112         bytes32 _s
113     ) payable external {
114         // The trade hash is created by tightly-concatenating and hashing properties of the trade.
115         // This hash becomes the identifier of the escrow, and hence all these variables must be
116         // supplied on future contract calls
117         bytes32 _tradeHash = keccak256(abi.encodePacked(_tradeID, _seller, _buyer, _value, _fee));
118         // Require that trade does not already exist
119         require(!escrows[_tradeHash].exists, "Trade already exists");
120         // A signature (v, r and s) must come from localethereum to open an escrow
121         bytes32 _invitationHash = keccak256(abi.encodePacked(
122             _tradeHash,
123             _paymentWindowInSeconds,
124             _expiry
125         ));
126         require(recoverAddress(_invitationHash, _v, _r, _s) == relayer, "Must be relayer");
127         // These signatures come with an expiry stamp
128         require(block.timestamp < _expiry, "Signature has expired");
129         // Check transaction value against signed _value and make sure is not 0
130         require(msg.value == _value && msg.value > 0, "Incorrect ether sent");
131         uint32 _sellerCanCancelAfter = _paymentWindowInSeconds == 0
132             ? 1
133             : uint32(block.timestamp) + _paymentWindowInSeconds;
134         // Add the escrow to the public mapping
135         escrows[_tradeHash] = Escrow(true, _sellerCanCancelAfter, 0);
136         emit Created(_tradeHash);
137     }
138 
139     uint16 constant GAS_doResolveDispute = 36100;
140     /// @notice Called by the arbitrator to resolve a dispute. Requires a signature from either party.
141     /// @param _tradeID Escrow "tradeID" parameter
142     /// @param _seller Escrow "seller" parameter
143     /// @param _buyer Escrow "buyer" parameter
144     /// @param _value Escrow "value" parameter
145     /// @param _fee Escrow "fee parameter
146     /// @param _v Signature "v" component
147     /// @param _r Signature "r" component
148     /// @param _s Signature "s" component
149     /// @param _buyerPercent What % should be distributed to the buyer (this is usually 0 or 100)
150     function resolveDispute(
151         bytes16 _tradeID,
152         address _seller,
153         address _buyer,
154         uint256 _value,
155         uint16 _fee,
156         uint8 _v,
157         bytes32 _r,
158         bytes32 _s,
159         uint8 _buyerPercent
160     ) external onlyArbitrator {
161         address _signature = recoverAddress(keccak256(abi.encodePacked(
162             _tradeID,
163             INSTRUCTION_RESOLVE
164         )), _v, _r, _s);
165         require(_signature == _buyer || _signature == _seller, "Must be buyer or seller");
166 
167         Escrow memory _escrow;
168         bytes32 _tradeHash;
169         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
170         require(_escrow.exists, "Escrow does not exist");
171         require(_buyerPercent <= 100, "_buyerPercent must be 100 or lower");
172 
173         uint256 _totalFees = _escrow.totalGasFeesSpentByRelayer + (GAS_doResolveDispute * uint128(tx.gasprice));
174         require(_value - _totalFees <= _value, "Overflow error"); // Prevent underflow
175         feesAvailableForWithdraw += _totalFees; // Add the the pot for localethereum to withdraw
176 
177         delete escrows[_tradeHash];
178         emit DisputeResolved(_tradeHash);
179         if (_buyerPercent > 0)
180           _buyer.transfer((_value - _totalFees) * _buyerPercent / 100);
181         if (_buyerPercent < 100)
182           _seller.transfer((_value - _totalFees) * (100 - _buyerPercent) / 100);
183     }
184 
185     /// @notice Release ether in escrow to the buyer. Direct call option.
186     /// @param _tradeID Escrow "tradeID" parameter
187     /// @param _seller Escrow "seller" parameter
188     /// @param _buyer Escrow "buyer" parameter
189     /// @param _value Escrow "value" parameter
190     /// @param _fee Escrow "fee parameter
191     /// @return bool
192     function release(
193         bytes16 _tradeID,
194         address _seller,
195         address _buyer,
196         uint256 _value,
197         uint16 _fee
198     ) external returns (bool){
199         require(msg.sender == _seller, "Must be seller");
200         return doRelease(_tradeID, _seller, _buyer, _value, _fee, 0);
201     }
202 
203     /// @notice Disable the seller from cancelling (i.e. "mark as paid"). Direct call option.
204     /// @param _tradeID Escrow "tradeID" parameter
205     /// @param _seller Escrow "seller" parameter
206     /// @param _buyer Escrow "buyer" parameter
207     /// @param _value Escrow "value" parameter
208     /// @param _fee Escrow "fee parameter
209     /// @return bool
210     function disableSellerCancel(
211         bytes16 _tradeID,
212         address _seller,
213         address _buyer,
214         uint256 _value,
215         uint16 _fee
216     ) external returns (bool) {
217         require(msg.sender == _buyer, "Must be buyer");
218         return doDisableSellerCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
219     }
220 
221     /// @notice Cancel the escrow as a buyer. Direct call option.
222     /// @param _tradeID Escrow "tradeID" parameter
223     /// @param _seller Escrow "seller" parameter
224     /// @param _buyer Escrow "buyer" parameter
225     /// @param _value Escrow "value" parameter
226     /// @param _fee Escrow "fee parameter
227     /// @return bool
228     function buyerCancel(
229       bytes16 _tradeID,
230       address _seller,
231       address _buyer,
232       uint256 _value,
233       uint16 _fee
234     ) external returns (bool) {
235         require(msg.sender == _buyer, "Must be buyer");
236         return doBuyerCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
237     }
238 
239     /// @notice Cancel the escrow as a seller. Direct call option.
240     /// @param _tradeID Escrow "tradeID" parameter
241     /// @param _seller Escrow "seller" parameter
242     /// @param _buyer Escrow "buyer" parameter
243     /// @param _value Escrow "value" parameter
244     /// @param _fee Escrow "fee parameter
245     /// @return bool
246     function sellerCancel(
247         bytes16 _tradeID,
248         address _seller,
249         address _buyer,
250         uint256 _value,
251         uint16 _fee
252     ) external returns (bool) {
253         require(msg.sender == _seller, "Must be seller");
254         return doSellerCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
255     }
256 
257     /// @notice Request to cancel as a seller. Direct call option.
258     /// @param _tradeID Escrow "tradeID" parameter
259     /// @param _seller Escrow "seller" parameter
260     /// @param _buyer Escrow "buyer" parameter
261     /// @param _value Escrow "value" parameter
262     /// @param _fee Escrow "fee parameter
263     /// @return bool
264     function sellerRequestCancel(
265         bytes16 _tradeID,
266         address _seller,
267         address _buyer,
268         uint256 _value,
269         uint16 _fee
270     ) external returns (bool) {
271         require(msg.sender == _seller, "Must be seller");
272         return doSellerRequestCancel(_tradeID, _seller, _buyer, _value, _fee, 0);
273     }
274 
275     /// @notice Relay multiple signed instructions from parties of escrows.
276     /// @param _tradeID List of _tradeID values
277     /// @param _seller List of _seller values
278     /// @param _buyer List of _buyer values
279     /// @param _value List of _value values
280     /// @param _fee List of _fee values
281     /// @param _maximumGasPrice List of _maximumGasPrice values
282     /// @param _v List of signature "v" components
283     /// @param _r List of signature "r" components
284     /// @param _s List of signature "s" components
285     /// @param _instructionByte List of _instructionByte values
286     /// @return bool List of results
287     uint16 constant GAS_batchRelayBaseCost = 28500;
288     function batchRelay(
289         bytes16[] _tradeID,
290         address[] _seller,
291         address[] _buyer,
292         uint256[] _value,
293         uint16[] _fee,
294         uint128[] _maximumGasPrice,
295         uint8[] _v,
296         bytes32[] _r,
297         bytes32[] _s,
298         uint8[] _instructionByte
299     ) public returns (bool[]) {
300         bool[] memory _results = new bool[](_tradeID.length);
301         uint128 _additionalGas = uint128(msg.sender == relayer ? GAS_batchRelayBaseCost / _tradeID.length : 0);
302         for (uint8 i=0; i<_tradeID.length; i++) {
303             _results[i] = relay(
304                 _tradeID[i],
305                 _seller[i],
306                 _buyer[i],
307                 _value[i],
308                 _fee[i],
309                 _maximumGasPrice[i],
310                 _v[i],
311                 _r[i],
312                 _s[i],
313                 _instructionByte[i],
314                 _additionalGas
315             );
316         }
317         return _results;
318     }
319 
320     /// @notice Withdraw fees collected by the contract. Only the owner can call this.
321     /// @param _to Address to withdraw fees in to
322     /// @param _amount Amount to withdraw
323     function withdrawFees(address _to, uint256 _amount) onlyOwner external {
324         // This check also prevents underflow
325         require(_amount <= feesAvailableForWithdraw, "Amount is higher than amount available");
326         feesAvailableForWithdraw -= _amount;
327         _to.transfer(_amount);
328     }
329 
330     /// @notice Set the arbitrator to a new address. Only the owner can call this.
331     /// @param _newArbitrator Address of the replacement arbitrator
332     function setArbitrator(address _newArbitrator) onlyOwner external {
333         arbitrator = _newArbitrator;
334     }
335 
336     /// @notice Change the owner to a new address. Only the owner can call this.
337     /// @param _newOwner Address of the replacement owner
338     function setOwner(address _newOwner) onlyOwner external {
339         owner = _newOwner;
340     }
341 
342     /// @notice Change the relayer to a new address. Only the owner can call this.
343     /// @param _newRelayer Address of the replacement relayer
344     function setRelayer(address _newRelayer) onlyOwner external {
345         relayer = _newRelayer;
346     }
347 
348     /// @notice Change the requestCancellationMinimumTime. Only the owner can call this.
349     /// @param _newRequestCancellationMinimumTime Replacement
350     function setRequestCancellationMinimumTime(
351         uint32 _newRequestCancellationMinimumTime
352     ) onlyOwner external {
353         requestCancellationMinimumTime = _newRequestCancellationMinimumTime;
354     }
355 
356     /// @notice Send ERC20 tokens away. This function allows the owner to withdraw stuck ERC20 tokens.
357     /// @param _tokenContract Token contract
358     /// @param _transferTo Recipient
359     /// @param _value Value
360     function transferToken(
361         Token _tokenContract,
362         address _transferTo,
363         uint256 _value
364     ) onlyOwner external {
365         _tokenContract.transfer(_transferTo, _value);
366     }
367 
368     /// @notice Send ERC20 tokens away. This function allows the owner to withdraw stuck ERC20 tokens.
369     /// @param _tokenContract Token contract
370     /// @param _transferTo Recipient
371     /// @param _transferFrom Sender
372     /// @param _value Value
373     function transferTokenFrom(
374         Token _tokenContract,
375         address _transferTo,
376         address _transferFrom,
377         uint256 _value
378     ) onlyOwner external {
379         _tokenContract.transferFrom(_transferTo, _transferFrom, _value);
380     }
381 
382     /// @notice Send ERC20 tokens away. This function allows the owner to withdraw stuck ERC20 tokens.
383     /// @param _tokenContract Token contract
384     /// @param _spender Spender address
385     /// @param _value Value
386     function approveToken(
387         Token _tokenContract,
388         address _spender,
389         uint256 _value
390     ) onlyOwner external {
391         _tokenContract.approve(_spender, _value);
392     }
393 
394     /// @notice Relay a signed instruction from a party of an escrow.
395     /// @param _tradeID Escrow "tradeID" parameter
396     /// @param _seller Escrow "seller" parameter
397     /// @param _buyer Escrow "buyer" parameter
398     /// @param _value Escrow "value" parameter
399     /// @param _fee Escrow "fee parameter
400     /// @param _maximumGasPrice Maximum gas price permitted for the relayer (set by the instructor)
401     /// @param _v Signature "v" component
402     /// @param _r Signature "r" component
403     /// @param _s Signature "s" component
404     /// @param _additionalGas Additional gas to be deducted after this operation
405     /// @return bool
406     function relay(
407         bytes16 _tradeID,
408         address _seller,
409         address _buyer,
410         uint256 _value,
411         uint16 _fee,
412         uint128 _maximumGasPrice,
413         uint8 _v,
414         bytes32 _r,
415         bytes32 _s,
416         uint8 _instructionByte,
417         uint128 _additionalGas
418     ) private returns (bool) {
419         address _relayedSender = getRelayedSender(
420             _tradeID,
421             _instructionByte,
422             _maximumGasPrice,
423             _v,
424             _r,
425             _s
426         );
427         if (_relayedSender == _buyer) {
428             // Buyer's instructions:
429             if (_instructionByte == INSTRUCTION_SELLER_CANNOT_CANCEL) {
430                 // Disable seller from cancelling
431                 return doDisableSellerCancel(_tradeID, _seller, _buyer, _value, _fee, _additionalGas);
432             } else if (_instructionByte == INSTRUCTION_BUYER_CANCEL) {
433                 // Cancel
434                 return doBuyerCancel(_tradeID, _seller, _buyer, _value, _fee, _additionalGas);
435             }
436         } else if (_relayedSender == _seller) {
437             // Seller's instructions:
438             if (_instructionByte == INSTRUCTION_RELEASE) {
439                 // Release
440                 return doRelease(_tradeID, _seller, _buyer, _value, _fee, _additionalGas);
441             } else if (_instructionByte == INSTRUCTION_SELLER_CANCEL) {
442                 // Cancel
443                 return doSellerCancel(_tradeID, _seller, _buyer, _value, _fee, _additionalGas);
444             } else if (_instructionByte == INSTRUCTION_SELLER_REQUEST_CANCEL){
445                 // Request to cancel
446                 return doSellerRequestCancel(_tradeID, _seller, _buyer, _value, _fee, _additionalGas);
447             }
448         } else {
449             require(msg.sender == _seller, "Unrecognised party");
450             return false;
451         }
452     }
453 
454     /// @notice Increase the amount of gas to be charged later on completion of an escrow
455     /// @param _tradeHash Trade hash
456     /// @param _gas Gas cost
457     function increaseGasSpent(bytes32 _tradeHash, uint128 _gas) private {
458         escrows[_tradeHash].totalGasFeesSpentByRelayer += _gas * uint128(tx.gasprice);
459     }
460 
461     /// @notice Transfer the value of an escrow, minus the fees, minus the gas costs incurred by relay
462     /// @param _to Recipient address
463     /// @param _value Value of the transfer
464     /// @param _totalGasFeesSpentByRelayer Total gas fees spent by the relayer
465     /// @param _fee Commission in 1/10000ths
466     function transferMinusFees(
467         address _to,
468         uint256 _value,
469         uint128 _totalGasFeesSpentByRelayer,
470         uint16 _fee
471     ) private {
472         uint256 _totalFees = (_value * _fee / 10000) + _totalGasFeesSpentByRelayer;
473         // Prevent underflow
474         if(_value - _totalFees > _value) {
475             return;
476         }
477         // Add fees to the pot for localethereum to withdraw
478         feesAvailableForWithdraw += _totalFees;
479         _to.transfer(_value - _totalFees);
480     }
481 
482     uint16 constant GAS_doRelease = 46588;
483     /// @notice Release escrow to the buyer. This completes it and removes it from the mapping.
484     /// @param _tradeID Escrow "tradeID" parameter
485     /// @param _seller Escrow "seller" parameter
486     /// @param _buyer Escrow "buyer" parameter
487     /// @param _value Escrow "value" parameter
488     /// @param _fee Escrow "fee parameter
489     /// @param _additionalGas Additional gas to be deducted after this operation
490     /// @return bool
491     function doRelease(
492         bytes16 _tradeID,
493         address _seller,
494         address _buyer,
495         uint256 _value,
496         uint16 _fee,
497         uint128 _additionalGas
498     ) private returns (bool) {
499         Escrow memory _escrow;
500         bytes32 _tradeHash;
501         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
502         if (!_escrow.exists) return false;
503         uint128 _gasFees = _escrow.totalGasFeesSpentByRelayer
504             + (msg.sender == relayer
505                 ? (GAS_doRelease + _additionalGas ) * uint128(tx.gasprice)
506                 : 0
507             );
508         delete escrows[_tradeHash];
509         emit Released(_tradeHash);
510         transferMinusFees(_buyer, _value, _gasFees, _fee);
511         return true;
512     }
513 
514     uint16 constant GAS_doDisableSellerCancel = 28944;
515     /// @notice Prevents the seller from cancelling an escrow. Used to "mark as paid" by the buyer.
516     /// @param _tradeID Escrow "tradeID" parameter
517     /// @param _seller Escrow "seller" parameter
518     /// @param _buyer Escrow "buyer" parameter
519     /// @param _value Escrow "value" parameter
520     /// @param _fee Escrow "fee parameter
521     /// @param _additionalGas Additional gas to be deducted after this operation
522     /// @return bool
523     function doDisableSellerCancel(
524         bytes16 _tradeID,
525         address _seller,
526         address _buyer,
527         uint256 _value,
528         uint16 _fee,
529         uint128 _additionalGas
530     ) private returns (bool) {
531         Escrow memory _escrow;
532         bytes32 _tradeHash;
533         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
534         if (!_escrow.exists) return false;
535         if(_escrow.sellerCanCancelAfter == 0) return false;
536         escrows[_tradeHash].sellerCanCancelAfter = 0;
537         emit SellerCancelDisabled(_tradeHash);
538         if (msg.sender == relayer) {
539           increaseGasSpent(_tradeHash, GAS_doDisableSellerCancel + _additionalGas);
540         }
541         return true;
542     }
543 
544     uint16 constant GAS_doBuyerCancel = 46255;
545     /// @notice Cancels the trade and returns the ether to the seller. Can only be called the buyer.
546     /// @param _tradeID Escrow "tradeID" parameter
547     /// @param _seller Escrow "seller" parameter
548     /// @param _buyer Escrow "buyer" parameter
549     /// @param _value Escrow "value" parameter
550     /// @param _fee Escrow "fee parameter
551     /// @param _additionalGas Additional gas to be deducted after this operation
552     /// @return bool
553     function doBuyerCancel(
554         bytes16 _tradeID,
555         address _seller,
556         address _buyer,
557         uint256 _value,
558         uint16 _fee,
559         uint128 _additionalGas
560     ) private returns (bool) {
561         Escrow memory _escrow;
562         bytes32 _tradeHash;
563         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
564         if (!_escrow.exists) {
565             return false;
566         }
567         uint128 _gasFees = _escrow.totalGasFeesSpentByRelayer
568             + (msg.sender == relayer
569                 ? (GAS_doBuyerCancel + _additionalGas ) * uint128(tx.gasprice)
570                 : 0
571             );
572         delete escrows[_tradeHash];
573         emit CancelledByBuyer(_tradeHash);
574         transferMinusFees(_seller, _value, _gasFees, 0);
575         return true;
576     }
577 
578     uint16 constant GAS_doSellerCancel = 46815;
579     /// @notice Returns the ether in escrow to the seller. Called by the seller. Sometimes unavailable.
580     /// @param _tradeID Escrow "tradeID" parameter
581     /// @param _seller Escrow "seller" parameter
582     /// @param _buyer Escrow "buyer" parameter
583     /// @param _value Escrow "value" parameter
584     /// @param _fee Escrow "fee parameter
585     /// @param _additionalGas Additional gas to be deducted after this operation
586     /// @return bool
587     function doSellerCancel(
588         bytes16 _tradeID,
589         address _seller,
590         address _buyer,
591         uint256 _value,
592         uint16 _fee,
593         uint128 _additionalGas
594     ) private returns (bool) {
595         Escrow memory _escrow;
596         bytes32 _tradeHash;
597         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
598         if (!_escrow.exists) {
599             return false;
600         }
601         if(_escrow.sellerCanCancelAfter <= 1 || _escrow.sellerCanCancelAfter > block.timestamp) {
602             return false;
603         }
604         uint128 _gasFees = _escrow.totalGasFeesSpentByRelayer
605             + (msg.sender == relayer
606                 ? (GAS_doSellerCancel + _additionalGas ) * uint128(tx.gasprice)
607                 : 0
608             );
609         delete escrows[_tradeHash];
610         emit CancelledBySeller(_tradeHash);
611         transferMinusFees(_seller, _value, _gasFees, 0);
612         return true;
613     }
614 
615     uint16 constant GAS_doSellerRequestCancel = 29507;
616     /// @notice Request to cancel. Used if the buyer is unresponsive. Begins a countdown timer.
617     /// @param _tradeID Escrow "tradeID" parameter
618     /// @param _seller Escrow "seller" parameter
619     /// @param _buyer Escrow "buyer" parameter
620     /// @param _value Escrow "value" parameter
621     /// @param _fee Escrow "fee parameter
622     /// @param _additionalGas Additional gas to be deducted after this operation
623     /// @return bool
624     function doSellerRequestCancel(
625         bytes16 _tradeID,
626         address _seller,
627         address _buyer,
628         uint256 _value,
629         uint16 _fee,
630         uint128 _additionalGas
631     ) private returns (bool) {
632         // Called on unlimited payment window trades where the buyer is not responding
633         Escrow memory _escrow;
634         bytes32 _tradeHash;
635         (_escrow, _tradeHash) = getEscrowAndHash(_tradeID, _seller, _buyer, _value, _fee);
636         if (!_escrow.exists) {
637             return false;
638         }
639         if(_escrow.sellerCanCancelAfter != 1) {
640             return false;
641         }
642         escrows[_tradeHash].sellerCanCancelAfter = uint32(block.timestamp)
643             + requestCancellationMinimumTime;
644         emit SellerRequestedCancel(_tradeHash);
645         if (msg.sender == relayer) {
646           increaseGasSpent(_tradeHash, GAS_doSellerRequestCancel + _additionalGas);
647         }
648         return true;
649     }
650 
651     /// @notice Get the sender of the signed instruction.
652     /// @param _tradeID Identifier of the trade
653     /// @param _instructionByte Identifier of the instruction
654     /// @param _maximumGasPrice Maximum gas price permitted by the sender
655     /// @param _v Signature "v" component
656     /// @param _r Signature "r" component
657     /// @param _s Signature "s" component
658     /// @return address
659     function getRelayedSender(
660       bytes16 _tradeID,
661       uint8 _instructionByte,
662       uint128 _maximumGasPrice,
663       uint8 _v,
664       bytes32 _r,
665       bytes32 _s
666     ) view private returns (address) {
667         bytes32 _hash = keccak256(abi.encodePacked(
668             _tradeID,
669             _instructionByte,
670             _maximumGasPrice
671         ));
672         if(tx.gasprice > _maximumGasPrice) {
673             return;
674         }
675         return recoverAddress(_hash, _v, _r, _s);
676     }
677 
678     /// @notice Hashes the values and returns the matching escrow object and trade hash.
679     /// @dev Returns an empty escrow struct and 0 _tradeHash if not found.
680     /// @param _tradeID Escrow "tradeID" parameter
681     /// @param _seller Escrow "seller" parameter
682     /// @param _buyer Escrow "buyer" parameter
683     /// @param _value Escrow "value" parameter
684     /// @param _fee Escrow "fee parameter
685     /// @return Escrow
686     function getEscrowAndHash(
687         bytes16 _tradeID,
688         address _seller,
689         address _buyer,
690         uint256 _value,
691         uint16 _fee
692     ) view private returns (Escrow, bytes32) {
693         bytes32 _tradeHash = keccak256(abi.encodePacked(
694             _tradeID,
695             _seller,
696             _buyer,
697             _value,
698             _fee
699         ));
700         return (escrows[_tradeHash], _tradeHash);
701     }
702 
703     /// @notice Returns an empty escrow struct and 0 _tradeHash if not found.
704     /// @param _h Data to be hashed
705     /// @param _v Signature "v" component
706     /// @param _r Signature "r" component
707     /// @param _s Signature "s" component
708     /// @return address
709     function recoverAddress(
710         bytes32 _h,
711         uint8 _v,
712         bytes32 _r,
713         bytes32 _s
714     ) private pure returns (address) {
715         bytes memory _prefix = "\x19Ethereum Signed Message:\n32";
716         bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
717         return ecrecover(_prefixedHash, _v, _r, _s);
718     }
719 }