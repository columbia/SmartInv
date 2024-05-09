1 // File: contracts/interfaces/IERC1620.sol
2 
3 pragma solidity 0.5.9;
4 
5 /// @title ERC-1620 Money Streaming Standard
6 /// @dev See https://github.com/ethereum/eips/issues/1620
7 
8 interface IERC1620 {
9 
10     /// @dev This emits when streams are successfully created and added
11     ///  in the mapping object.
12     event CreateStream(
13         uint256 indexed streamId,
14         address indexed sender,
15         address indexed recipient,
16         address tokenAddress,
17         uint256 startBlock,
18         uint256 stopBlock,
19         uint256 payment,
20         uint256 interval
21     );
22 
23     /// @dev This emits when the receiver of a stream withdraws a portion
24     ///  or all of their available funds from an ongoing stream, without
25     ///  stopping it. Note that we don't emit both the sender and the
26     ///  recipient's balance because only the recipient can withdraw
27     ///  while the stream is active.
28     event WithdrawFromStream(
29         uint256 indexed streamId,
30         address indexed recipient,
31         uint256 amount
32     );
33 
34     /// @dev This emits when a stream is successfully redeemed and
35     ///  all involved parties get their share of the available funds.
36     event RedeemStream(
37         uint256 indexed streamId,
38         address indexed sender,
39         address indexed recipient,
40         uint256 senderAmount,
41         uint256 recipientAmount
42     );
43 
44     /// @dev This emits when an update is successfully committed by
45     ///  one of the involved parties.
46     event ConfirmUpdate(
47         uint256 indexed streamId,
48         address indexed confirmer,
49         address newTokenAddress,
50         uint256 newStopBlock,
51         uint256 newPayment,
52         uint256 newInterval
53     );
54 
55     /// @dev This emits when one of the involved parties revokes
56     ///  a proposed update to the stream.
57     event RevokeUpdate(
58         uint256 indexed streamId,
59         address indexed revoker,
60         address newTokenAddress,
61         uint256 newStopBlock,
62         uint256 newPayment,
63         uint256 newInterval
64     );
65 
66     /// @dev This emits when an update (that is, modifications to
67     ///  payment rate, starting or stopping block) is successfully
68     ///  approved by all involved parties.
69     event ExecuteUpdate(
70         uint256 indexed streamId,
71         address indexed sender,
72         address indexed recipient,
73         address newTokenAddress,
74         uint256 newStopBlock,
75         uint256 newPayment,
76         uint256 newInterval
77     );
78 
79     /// @notice Creates a new stream between `msg.sender` and `_recipient`
80     /// @dev Throws unless `msg.value` is exactly
81     ///  `_payment * ((_stopBlock - _startBlock) / _interval)`.
82     ///  Throws if `_startBlock` is not higher than `block.number`.
83     ///  Throws if `_stopBlock` is not higher than `_startBlock`.
84     ///  Throws if the total streaming duration `_stopBlock - _startBlock`
85     ///  is not a multiple of `_interval`.
86     /// @param _recipient The stream sender or the payer
87     /// @param _recipient The stream recipient or the payee
88     /// @param _tokenAddress The token contract address
89     /// @param _startBlock The starting time of the stream
90     /// @param _stopBlock The stopping time of the stream
91     /// @param _payment How much money moves from sender to recipient
92     /// @param _interval How often the `payment` moves from sender to recipient
93     function createStream(
94         address _sender,
95         address _recipient,
96         address _tokenAddress,
97         uint256 _startBlock,
98         uint256 _stopBlock,
99         uint256 _payment,
100         uint256 _interval
101     )
102     external;
103 
104     /// @notice Withdraws all or a fraction of the available funds
105     /// @dev If the stream ended and the recipient withdraws the deposit in full,
106     ///  the stream object gets deleted after this operation
107     ///  to save gas for the user and optimise contract storage.
108     ///  Throws if `_streamId` doesn't point to a valid stream.
109     ///  Throws if `msg.sender` is not the recipient of the given `streamId`
110     /// @param _streamId The stream to withdraw from
111     /// @param _funds The amount of money to withdraw
112     function withdrawFromStream(
113         uint256 _streamId,
114         uint256 _funds
115     )
116     external;
117 
118     /// @notice Redeems the stream by distributing the funds to the sender and the recipient
119     /// @dev The stream object gets deleted after this operation
120     ///  to save gas for the user and optimise contract storage.
121     ///  Throws if `_streamId` doesn't point to a valid stream.
122     ///  Throws unless `msg.sender` is either the sender or the recipient
123     ///  of the given `streamId`.
124     /// @param _streamId The stream to stop
125     function redeemStream(
126         uint256 _streamId
127     )
128     external;
129 
130     /// @notice Signals one party's willingness to update the stream
131     /// @dev Throws if `_streamId` doesn't point to a valid stream.
132     ///  Not executed prior to everyone agreeing to the new terms.
133     ///  In terms of validation, it works exactly the same as the `createStream` function.
134     /// @param _streamId The stream to update
135     /// @param _tokenAddress The token contract address
136     /// @param _stopBlock The new stopping time of the stream
137     /// @param _payment How much money moves from sender to recipient
138     /// @param _interval How often the `payment` moves from sender to recipient
139     function confirmUpdate(
140         uint256 _streamId,
141         address _tokenAddress,
142         uint256 _stopBlock,
143         uint256 _payment,
144         uint256 _interval
145     )
146     external;
147 
148     /// @notice Revokes an update proposed by one of the involved parties
149     /// @dev Throws if `_streamId` doesn't point to a valid stream. The parameters
150     ///  are merely for logging purposes.
151     function revokeUpdate(
152         uint256 _streamId,
153         address _tokenAddress,
154         uint256 _stopBlock,
155         uint256 _payment,
156         uint256 _interval
157     )
158     external;
159 
160     /// @notice Returns available funds for the given stream id and address
161     /// @dev Streams assigned to the zero address are considered invalid, and
162     ///  this function throws for queries about the zero address.
163     /// @param _streamId The stream for whom to query the balance
164     /// @param _addr The address for whom to query the balance
165     /// @return The total funds available to `addr` to withdraw
166     function balanceOf(
167         uint256 _streamId,
168         address _addr
169     )
170     external
171     view
172     returns (
173         uint256 balance
174     );
175 
176     /// @notice Returns the full stream data
177     /// @dev Throws if `_streamId` doesn't point to a valid stream.
178     /// @param _streamId The stream to return data for
179     function getStream(
180         uint256 _streamId
181     )
182     external
183     view
184     returns (
185         address _sender,
186         address _recipient,
187         address _tokenAddress,
188         uint256 _balance,
189         uint256 _startBlock,
190         uint256 _stopBlock,
191         uint256 _payment,
192         uint256 _interval
193     );
194 }
195 
196 // File: contracts/zeppelin/IERC20.sol
197 
198 pragma solidity 0.5.9;
199 
200 /// @title ERC20 interface
201 /// @author /// OpenZeppelin Community - <maintainers@openzeppelin.org>
202 /// @dev see https://eips.ethereum.org/EIPS/eip-20
203 
204 interface IERC20 {
205     function transfer(address to, uint256 value) external returns (bool);
206 
207     function approve(address spender, uint256 value) external returns (bool);
208 
209     function transferFrom(address from, address to, uint256 value) external returns (bool);
210 
211     function totalSupply() external view returns (uint256);
212 
213     function balanceOf(address who) external view returns (uint256);
214 
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 // File: contracts/zeppelin/SafeMath.sol
223 
224 pragma solidity 0.5.9;
225 
226 /// @title SafeMath
227 /// @author OpenZeppelin Community - <maintainers@openzeppelin.org>
228 /// @dev Unsigned math operations with safety checks that revert on error
229 
230 library SafeMath {
231     /**
232      * @dev Multiplies two unsigned integers, reverts on overflow.
233      */
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236         // benefit is lost if 'b' is also tested.
237         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b);
244 
245         return c;
246     }
247 
248     /**
249      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         // Solidity only automatically asserts when dividing by 0
253         require(b > 0);
254         uint256 c = a / b;
255         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
256 
257         return c;
258     }
259 
260     /**
261      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
262      */
263     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
264         require(b <= a);
265         uint256 c = a - b;
266 
267         return c;
268     }
269 
270     /**
271      * @dev Adds two unsigned integers, reverts on overflow.
272      */
273     function add(uint256 a, uint256 b) internal pure returns (uint256) {
274         uint256 c = a + b;
275         require(c >= a);
276 
277         return c;
278     }
279 
280     /**
281      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
282      * reverts when dividing by zero.
283      */
284     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
285         require(b != 0);
286         return a % b;
287     }
288 }
289 
290 // File: contracts/Sablier.sol
291 
292 pragma solidity 0.5.9;
293 
294 
295 
296 
297 /// @title Sablier - ERC Money Streaming Implementation
298 /// @author Paul Berg - <hello@paulrberg.com>
299 
300 contract Sablier is IERC1620 {
301     using SafeMath for uint256;
302 
303     /**
304      * Types
305      */
306     struct Timeframe {
307         uint256 start;
308         uint256 stop;
309     }
310 
311     struct Rate {
312         uint256 payment;
313         uint256 interval;
314     }
315 
316     struct Stream {
317         address sender;
318         address recipient;
319         address tokenAddress;
320         Timeframe timeframe;
321         Rate rate;
322         uint256 balance;
323     }
324 
325     /**
326      * Storage
327      */
328     mapping(uint256 => Stream) private streams;
329     uint256 private streamNonce;
330     mapping(uint256 => mapping(address => bool)) private updates;
331 
332     /**
333      * Events
334      */
335     event CreateStream(
336         uint256 indexed streamId,
337         address indexed sender,
338         address indexed recipient,
339         address tokenAddress,
340         uint256 startBlock,
341         uint256 stopBlock,
342         uint256 payment,
343         uint256 interval,
344         uint256 deposit
345     );
346 
347     event WithdrawFromStream(
348         uint256 indexed streamId,
349         address indexed recipient,
350         uint256 amount
351     );
352 
353     event RedeemStream(
354         uint256 indexed streamId,
355         address indexed sender,
356         address indexed recipient,
357         uint256 senderAmount,
358         uint256 recipientAmount
359     );
360 
361     event ConfirmUpdate(
362         uint256 indexed streamId,
363         address indexed confirmer,
364         address newTokenAddress,
365         uint256 newStopBlock,
366         uint256 newPayment,
367         uint256 newInterval
368     );
369 
370     event RevokeUpdate(
371         uint256 indexed streamId,
372         address indexed revoker,
373         address newTokenAddress,
374         uint256 newStopBlock,
375         uint256 newPayment,
376         uint256 newInterval
377     );
378 
379     event ExecuteUpdate(
380         uint256 indexed streamId,
381         address indexed sender,
382         address indexed recipient,
383         address newTokenAddress,
384         uint256 newStopBlock,
385         uint256 newPayment,
386         uint256 newInterval
387     );
388 
389     /*
390     * Modifiers
391     */
392     modifier onlyRecipient(uint256 _streamId) {
393         require(
394             streams[_streamId].recipient == msg.sender,
395             "only the stream recipient is allowed to perform this action"
396         );
397         _;
398     }
399 
400     modifier onlySenderOrRecipient(uint256 _streamId) {
401         require(
402             msg.sender == streams[_streamId].sender ||
403             msg.sender == streams[_streamId].recipient,
404             "only the sender or the recipient of the stream can perform this action"
405         );
406         _;
407     }
408 
409     modifier streamExists(uint256 _streamId) {
410         require(
411             streams[_streamId].sender != address(0x0), "stream doesn't exist");
412         _;
413     }
414 
415     modifier updateConfirmed(uint256 _streamId, address _addr) {
416         require(
417             updates[_streamId][_addr] == true,
418             "msg.sender has not confirmed the update"
419         );
420         _;
421     }
422 
423     /**
424      * Functions
425      */
426     constructor() public {
427         streamNonce = 1;
428     }
429 
430     function balanceOf(uint256 _streamId, address _addr)
431     public
432     view
433     streamExists(_streamId)
434     returns (uint256 balance)
435     {
436         Stream memory stream = streams[_streamId];
437         uint256 deposit = depositOf(_streamId);
438         uint256 delta = deltaOf(_streamId);
439         uint256 funds = delta.div(stream.rate.interval).mul(stream.rate.payment);
440 
441         if (stream.balance != deposit)
442             funds = funds.sub(deposit.sub(stream.balance));
443 
444         if (_addr == stream.recipient) {
445             return funds;
446         } else if (_addr == stream.sender) {
447             return stream.balance.sub(funds);
448         } else {
449             return 0;
450         }
451     }
452 
453     function getStream(uint256 _streamId)
454     public
455     view
456     streamExists(_streamId)
457     returns (
458         address sender,
459         address recipient,
460         address tokenAddress,
461         uint256 balance,
462         uint256 startBlock,
463         uint256 stopBlock,
464         uint256 payment,
465         uint256 interval
466     )
467     {
468         Stream memory stream = streams[_streamId];
469         return (
470             stream.sender,
471             stream.recipient,
472             stream.tokenAddress,
473             stream.balance,
474             stream.timeframe.start,
475             stream.timeframe.stop,
476             stream.rate.payment,
477             stream.rate.interval
478         );
479     }
480 
481     function getUpdate(uint256 _streamId, address _addr)
482     public
483     view
484     streamExists(_streamId)
485     returns (bool active)
486     {
487         return updates[_streamId][_addr];
488     }
489 
490     function createStream(
491         address _sender,
492         address _recipient,
493         address _tokenAddress,
494         uint256 _startBlock,
495         uint256 _stopBlock,
496         uint256 _payment,
497         uint256 _interval
498     )
499         public
500     {
501         verifyTerms(
502             _tokenAddress,
503             _startBlock,
504             _stopBlock,
505             _interval
506         );
507 
508         // only ERC20 tokens can be streamed
509         uint256 deposit = _stopBlock.sub(_startBlock).div(_interval).mul(_payment);
510         IERC20 tokenContract = IERC20(_tokenAddress);
511         uint256 allowance = tokenContract.allowance(_sender, address(this));
512         require(allowance >= deposit, "contract not allowed to transfer enough tokens");
513 
514         // create and log the stream if the deposit is okay
515         streams[streamNonce] = Stream({
516             balance : deposit,
517             sender : _sender,
518             recipient : _recipient,
519             tokenAddress : _tokenAddress,
520             timeframe : Timeframe(_startBlock, _stopBlock),
521             rate : Rate(_payment, _interval)
522         });
523         emit CreateStream(
524             streamNonce,
525             _sender,
526             _recipient,
527             _tokenAddress,
528             _startBlock,
529             _stopBlock,
530             _payment,
531             _interval,
532             deposit
533         );
534         streamNonce = streamNonce.add(1);
535 
536         // apply Checks-Effects-Interactions
537         require(tokenContract.transferFrom(_sender, address(this), deposit), "initial deposit failed");
538     }
539 
540     function withdrawFromStream(
541         uint256 _streamId,
542         uint256 _amount
543     )
544     public
545     streamExists(_streamId)
546     onlyRecipient(_streamId)
547     {
548         Stream memory stream = streams[_streamId];
549         uint256 availableFunds = balanceOf(_streamId, stream.recipient);
550         require(availableFunds >= _amount, "not enough funds");
551 
552         streams[_streamId].balance = streams[_streamId].balance.sub(_amount);
553         emit WithdrawFromStream(_streamId, stream.recipient, _amount);
554 
555         // saving gas
556         if (streams[_streamId].balance == 0) {
557             delete streams[_streamId];
558             updates[_streamId][stream.sender] = false;
559             updates[_streamId][stream.recipient] = false;
560         }
561 
562         // saving gas by checking beforehand
563         if (_amount > 0)
564             require(IERC20(stream.tokenAddress).transfer(stream.recipient, _amount), "erc20 transfer failed");
565     }
566 
567     function redeemStream(uint256 _streamId)
568     public
569     streamExists(_streamId)
570     onlySenderOrRecipient(_streamId)
571     {
572         Stream memory stream = streams[_streamId];
573         uint256 senderAmount = balanceOf(_streamId, stream.sender);
574         uint256 recipientAmount = balanceOf(_streamId, stream.recipient);
575         emit RedeemStream(
576             _streamId,
577             stream.sender,
578             stream.recipient,
579             senderAmount,
580             recipientAmount
581         );
582 
583         // saving gas
584         delete streams[_streamId];
585         updates[_streamId][stream.sender] = false;
586         updates[_streamId][stream.recipient] = false;
587 
588         IERC20 tokenContract = IERC20(stream.tokenAddress);
589         // saving gas by checking beforehand
590         if (recipientAmount > 0)
591             require(tokenContract.transfer(stream.recipient, recipientAmount), "erc20 transfer failed");
592         if (senderAmount > 0)
593             require(tokenContract.transfer(stream.sender, senderAmount), "erc20 transfer failed");
594     }
595 
596     function confirmUpdate(
597         uint256 _streamId,
598         address _tokenAddress,
599         uint256 _stopBlock,
600         uint256 _payment,
601         uint256 _interval
602     )
603     public
604     streamExists(_streamId)
605     onlySenderOrRecipient(_streamId)
606     {
607         onlyNewTerms(
608             _streamId,
609             _tokenAddress,
610             _stopBlock,
611             _payment,
612             _interval
613         );
614         verifyTerms(
615             _tokenAddress,
616             block.number,
617             _stopBlock,
618             _interval
619         );
620 
621         emit ConfirmUpdate(
622             _streamId,
623             msg.sender,
624             _tokenAddress,
625             _stopBlock,
626             _payment,
627             _interval
628         );
629         updates[_streamId][msg.sender] = true;
630 
631         executeUpdate(
632             _streamId,
633             _tokenAddress,
634             _stopBlock,
635             _payment,
636             _interval
637         );
638     }
639 
640     function revokeUpdate(
641         uint256 _streamId,
642         address _tokenAddress,
643         uint256 _stopBlock,
644         uint256 _payment,
645         uint256 _interval
646     )
647         public
648         updateConfirmed(_streamId, msg.sender)
649     {
650         emit RevokeUpdate(
651             _streamId,
652             msg.sender,
653             _tokenAddress,
654             _stopBlock,
655             _payment,
656             _interval
657         );
658         updates[_streamId][msg.sender] = false;
659     }
660 
661     /**
662      * Private
663      */
664     function deltaOf(uint256 _streamId)
665     private
666     view
667     returns (uint256 delta)
668     {
669         Stream memory stream = streams[_streamId];
670         uint256 startBlock = stream.timeframe.start;
671         uint256 stopBlock = stream.timeframe.stop;
672 
673         // before the start of the stream
674         if (block.number <= startBlock)
675             return 0;
676 
677         // during the stream
678         if (block.number <= stopBlock)
679             return block.number - startBlock;
680 
681         // after the end of the stream
682         return stopBlock - startBlock;
683     }
684 
685     function depositOf(uint256 _streamId)
686     private
687     view
688     returns (uint256 funds)
689     {
690         Stream memory stream = streams[_streamId];
691         return stream.timeframe.stop
692             .sub(stream.timeframe.start)
693             .div(stream.rate.interval)
694             .mul(stream.rate.payment);
695     }
696 
697     function onlyNewTerms(
698         uint256 _streamId,
699         address _tokenAddress,
700         uint256 _stopBlock,
701         uint256 _payment,
702         uint256 _interval
703     )
704     private
705     view
706     returns (bool valid)
707     {
708         require(
709             streams[_streamId].tokenAddress != _tokenAddress ||
710             streams[_streamId].timeframe.stop != _stopBlock ||
711             streams[_streamId].rate.payment != _payment ||
712             streams[_streamId].rate.interval != _interval,
713             "stream has these terms already"
714         );
715         return true;
716     }
717 
718     function verifyTerms(
719         address _tokenAddress,
720         uint256 _startBlock,
721         uint256 _stopBlock,
722         uint256 _interval
723     )
724     private
725     view
726     returns (bool valid)
727     {
728         require(
729             _tokenAddress != address(0x0),
730             "token contract address needs to be provided"
731         );
732         require(
733             _startBlock >= block.number,
734             "the start block needs to be higher than the current block number"
735         );
736         require(
737             _stopBlock > _startBlock,
738             "the stop block needs to be higher than the start block"
739         );
740         uint256 delta = _stopBlock - _startBlock;
741         require(
742             delta >= _interval,
743             "the block difference needs to be higher than the payment interval"
744         );
745         require(
746             delta.mod(_interval) == 0,
747             "the block difference needs to be a multiple of the payment interval"
748         );
749         return true;
750     }
751 
752     function executeUpdate(
753         uint256 _streamId,
754         address _tokenAddress,
755         uint256 _stopBlock,
756         uint256 _payment,
757         uint256 _interval
758     )
759         private
760         streamExists(_streamId)
761     {
762         Stream memory stream = streams[_streamId];
763         if (updates[_streamId][stream.sender] == false)
764             return;
765         if (updates[_streamId][stream.recipient] == false)
766             return;
767 
768         // adjust stop block
769         uint256 remainder = _stopBlock.sub(block.number).mod(_interval);
770         uint256 adjustedStopBlock = _stopBlock.sub(remainder);
771         emit ExecuteUpdate(
772             _streamId,
773             stream.sender,
774             stream.recipient,
775             _tokenAddress,
776             adjustedStopBlock,
777             _payment,
778             _interval
779         );
780         updates[_streamId][stream.sender] = false;
781         updates[_streamId][stream.recipient] = false;
782 
783         redeemStream(_streamId);
784         createStream(
785             stream.sender,
786             stream.recipient,
787             _tokenAddress,
788             block.number,
789             adjustedStopBlock,
790             _payment,
791             _interval
792         );
793     }
794 }