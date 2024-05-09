1 pragma solidity ^0.4.23;
2 
3 /// @title Utils
4 /// @notice Utils contract for various helpers used by the Raiden Network smart
5 /// contracts.
6 contract Utils {
7     string constant public contract_version = "0.4.0";
8 
9     /// @notice Check if a contract exists
10     /// @param contract_address The address to check whether a contract is
11     /// deployed or not
12     /// @return True if a contract exists, false otherwise
13     function contractExists(address contract_address) public view returns (bool) {
14         uint size;
15 
16         assembly {
17             size := extcodesize(contract_address)
18         }
19 
20         return size > 0;
21     }
22 }
23 
24 
25 interface Token {
26 
27     /// @return total amount of tokens
28     function totalSupply() external view returns (uint256 supply);
29 
30     /// @param _owner The address from which the balance will be retrieved
31     /// @return The balance
32     function balanceOf(address _owner) external view returns (uint256 balance);
33 
34     /// @notice send `_value` token to `_to` from `msg.sender`
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transfer(address _to, uint256 _value) external returns (bool success);
39 
40     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41     /// @param _from The address of the sender
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
46 
47     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @param _value The amount of wei to be approved for transfer
50     /// @return Whether the approval was successful or not
51     function approve(address _spender, uint256 _value) external returns (bool success);
52 
53     /// @param _owner The address of the account owning tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @return Amount of remaining tokens allowed to spent
56     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     // Optionally implemented function to show the number of decimals for the token
62     function decimals() external view returns (uint8 decimals);
63 }
64 
65 
66 library ECVerify {
67 
68     function ecverify(bytes32 hash, bytes signature)
69         internal
70         pure
71         returns (address signature_address)
72     {
73         require(signature.length == 65);
74 
75         bytes32 r;
76         bytes32 s;
77         uint8 v;
78 
79         // The signature format is a compact form of:
80         //   {bytes32 r}{bytes32 s}{uint8 v}
81         // Compact means, uint8 is not padded to 32 bytes.
82         assembly {
83             r := mload(add(signature, 32))
84             s := mload(add(signature, 64))
85 
86             // Here we are loading the last 32 bytes, including 31 bytes of 's'.
87             v := byte(0, mload(add(signature, 96)))
88         }
89 
90         // Version of signature should be 27 or 28, but 0 and 1 are also possible
91         if (v < 27) {
92             v += 27;
93         }
94 
95         require(v == 27 || v == 28);
96 
97         signature_address = ecrecover(hash, v, r, s);
98 
99         // ecrecover returns zero on error
100         require(signature_address != address(0x0));
101 
102         return signature_address;
103     }
104 }
105 
106 
107 /// @title SecretRegistry
108 /// @notice SecretRegistry contract for registering secrets from Raiden Network
109 /// clients.
110 contract SecretRegistry {
111 
112     string constant public contract_version = "0.4.0";
113 
114     // keccak256(secret) => block number at which the secret was revealed
115     mapping(bytes32 => uint256) private secrethash_to_block;
116 
117     event SecretRevealed(bytes32 indexed secrethash, bytes32 secret);
118 
119     /// @notice Registers a hash time lock secret and saves the block number.
120     /// This allows the lock to be unlocked after the expiration block.
121     /// @param secret The secret used to lock the hash time lock.
122     /// @return true if secret was registered, false if the secret was already
123     /// registered.
124     function registerSecret(bytes32 secret) public returns (bool) {
125         bytes32 secrethash = keccak256(abi.encodePacked(secret));
126         if (secret == bytes32(0x0) || secrethash_to_block[secrethash] > 0) {
127             return false;
128         }
129         secrethash_to_block[secrethash] = block.number;
130         emit SecretRevealed(secrethash, secret);
131         return true;
132     }
133 
134     /// @notice Registers multiple hash time lock secrets and saves the block
135     /// number.
136     /// @param secrets The array of secrets to be registered.
137     /// @return true if all secrets could be registered, false otherwise.
138     function registerSecretBatch(bytes32[] secrets) public returns (bool) {
139         bool completeSuccess = true;
140         for(uint i = 0; i < secrets.length; i++) {
141             if(!registerSecret(secrets[i])) {
142                 completeSuccess = false;
143             }
144         }
145         return completeSuccess;
146     }
147 
148     /// @notice Get the stored block number at which the secret was revealed.
149     /// @param secrethash The hash of the registered secret `keccak256(secret)`.
150     /// @return The block number at which the secret was revealed.
151     function getSecretRevealBlockHeight(bytes32 secrethash) public view returns (uint256) {
152         return secrethash_to_block[secrethash];
153     }
154 }
155 
156 
157 
158 /// @title TokenNetwork
159 /// @notice Stores and manages all the Raiden Network channels that use the
160 /// token specified
161 /// in this TokenNetwork contract.
162 contract TokenNetwork is Utils {
163 
164     string constant public contract_version = "0.4.0";
165 
166     // Instance of the token used by the channels
167     Token public token;
168 
169     // Instance of SecretRegistry used for storing secrets revealed in a
170     // mediating transfer.
171     SecretRegistry public secret_registry;
172 
173     // Chain ID as specified by EIP155 used in balance proof signatures to
174     // avoid replay attacks
175     uint256 public chain_id;
176 
177     uint256 public settlement_timeout_min;
178     uint256 public settlement_timeout_max;
179 
180     uint256 constant public MAX_SAFE_UINT256 = (
181         115792089237316195423570985008687907853269984665640564039457584007913129639935
182     );
183 
184     // Red Eyes release deposit limits
185     // The combined deposit of one channel is limited to 0.15 ETH.
186     // So 0.075 ETH per participant.
187     uint256 constant public channel_participant_deposit_limit = 75000000000000000 wei;
188     // The total combined deposit of all channels across the whole network is
189     // limited to 250 ETH.
190     uint256 constant public token_network_deposit_limit = 250000000000000000000 wei;
191 
192     // Global, monotonically increasing counter that keeps track of all the
193     // opened channels in this contract
194     uint256 public channel_counter;
195 
196     string public constant signature_prefix = '\x19Ethereum Signed Message:\n';
197 
198     // Only for the limited Red Eyes release
199     address public deprecation_executor;
200     bool public safety_deprecation_switch = false;
201 
202     // channel_identifier => Channel
203     // channel identifier is the channel_counter value at the time of opening
204     // the channel
205     mapping (uint256 => Channel) public channels;
206 
207     // This is needed to enforce one channel per pair of participants
208     // The key is keccak256(participant1_address, participant2_address)
209     mapping (bytes32 => uint256) public participants_hash_to_channel_identifier;
210 
211     // We keep the unlock data in a separate mapping to allow channel data
212     // structures to be removed when settling uncooperatively. If there are
213     // locked pending transfers, we need to store data needed to unlock them at
214     // a later time.
215     // The key is `keccak256(uint256 channel_identifier, address participant,
216     // address partner)` Where `participant` is the participant that sent the
217     // pending transfers We need `partner` for knowing where to send the
218     // claimable tokens
219     mapping(bytes32 => UnlockData) private unlock_identifier_to_unlock_data;
220 
221     struct Participant {
222         // Total amount of tokens transferred to this smart contract through
223         // the `setTotalDeposit` function, for a specific channel, in the
224         // participant's benefit.
225         // This is a strictly monotonic value. Note that direct token transfer
226         // cannot be tracked and will be burned.
227         uint256 deposit;
228 
229         // Total amount of tokens withdrawn by the participant during the
230         // lifecycle of this channel.
231         // This is a strictly monotonic value.
232         uint256 withdrawn_amount;
233 
234         // This is a value set to true after the channel has been closed, only
235         // if this is the participant who closed the channel.
236         bool is_the_closer;
237 
238         // keccak256 of the balance data provided after a closeChannel or an
239         // updateNonClosingBalanceProof call
240         bytes32 balance_hash;
241 
242         // Monotonically increasing counter of the off-chain transfers,
243         // provided along with the balance_hash
244         uint256 nonce;
245     }
246 
247     enum ChannelState {
248         NonExistent, // 0
249         Opened,      // 1
250         Closed,      // 2
251         Settled,     // 3; Note: The channel has at least one pending unlock
252         Removed      // 4; Note: Channel data is removed, there are no pending unlocks
253     }
254 
255     enum MessageTypeId {
256         None,
257         BalanceProof,
258         BalanceProofUpdate,
259         Withdraw,
260         CooperativeSettle
261     }
262 
263     struct Channel {
264         // After opening the channel this value represents the settlement
265         // window. This is the number of blocks that need to be mined between
266         // closing the channel uncooperatively and settling the channel.
267         // After the channel has been uncooperatively closed, this value
268         // represents the block number after which settleChannel can be called.
269         uint256 settle_block_number;
270 
271         ChannelState state;
272 
273         mapping(address => Participant) participants;
274     }
275 
276     struct SettlementData {
277         uint256 deposit;
278         uint256 withdrawn;
279         uint256 transferred;
280         uint256 locked;
281     }
282 
283     struct UnlockData {
284         // Merkle root of the pending transfers tree from the Raiden client
285         bytes32 locksroot;
286         // Total amount of tokens locked in the pending transfers corresponding
287         // to the `locksroot`
288         uint256 locked_amount;
289     }
290 
291     event ChannelOpened(
292         uint256 indexed channel_identifier,
293         address indexed participant1,
294         address indexed participant2,
295         uint256 settle_timeout
296     );
297 
298     event ChannelNewDeposit(
299         uint256 indexed channel_identifier,
300         address indexed participant,
301         uint256 total_deposit
302     );
303 
304     // total_withdraw is how much the participant has withdrawn during the
305     // lifetime of the channel. The actual amount which the participant withdrew
306     // is `total_withdraw - total_withdraw_from_previous_event_or_zero`
307     /* event ChannelWithdraw(
308         uint256 indexed channel_identifier,
309         address indexed participant,
310         uint256 total_withdraw
311     ); */
312 
313     event ChannelClosed(
314         uint256 indexed channel_identifier,
315         address indexed closing_participant,
316         uint256 indexed nonce
317     );
318 
319     event ChannelUnlocked(
320         uint256 indexed channel_identifier,
321         address indexed participant,
322         address indexed partner,
323         bytes32 locksroot,
324         uint256 unlocked_amount,
325         uint256 returned_tokens
326     );
327 
328     event NonClosingBalanceProofUpdated(
329         uint256 indexed channel_identifier,
330         address indexed closing_participant,
331         uint256 indexed nonce
332     );
333 
334     event ChannelSettled(
335         uint256 indexed channel_identifier,
336         uint256 participant1_amount,
337         uint256 participant2_amount
338     );
339 
340     modifier onlyDeprecationExecutor() {
341         require(msg.sender == deprecation_executor);
342         _;
343     }
344 
345     modifier isSafe() {
346         require(safety_deprecation_switch == false);
347         _;
348     }
349 
350     modifier isOpen(uint256 channel_identifier) {
351         require(channels[channel_identifier].state == ChannelState.Opened);
352         _;
353     }
354 
355     modifier settleTimeoutValid(uint256 timeout) {
356         require(timeout >= settlement_timeout_min);
357         require(timeout <= settlement_timeout_max);
358         _;
359     }
360 
361     constructor(
362         address _token_address,
363         address _secret_registry,
364         uint256 _chain_id,
365         uint256 _settlement_timeout_min,
366         uint256 _settlement_timeout_max,
367         address _deprecation_executor
368     )
369         public
370     {
371         require(_token_address != address(0x0));
372         require(_secret_registry != address(0x0));
373         require(_deprecation_executor != address(0x0));
374         require(_chain_id > 0);
375         require(_settlement_timeout_min > 0);
376         require(_settlement_timeout_max > _settlement_timeout_min);
377         require(contractExists(_token_address));
378         require(contractExists(_secret_registry));
379 
380         token = Token(_token_address);
381 
382         secret_registry = SecretRegistry(_secret_registry);
383         chain_id = _chain_id;
384         settlement_timeout_min = _settlement_timeout_min;
385         settlement_timeout_max = _settlement_timeout_max;
386 
387         // Make sure the contract is indeed a token contract
388         require(token.totalSupply() > 0);
389 
390         deprecation_executor = _deprecation_executor;
391     }
392 
393     function deprecate() isSafe onlyDeprecationExecutor public {
394         safety_deprecation_switch = true;
395     }
396 
397     /// @notice Opens a new channel between `participant1` and `participant2`.
398     /// Can be called by anyone.
399     /// @param participant1 Ethereum address of a channel participant.
400     /// @param participant2 Ethereum address of the other channel participant.
401     /// @param settle_timeout Number of blocks that need to be mined between a
402     /// call to closeChannel and settleChannel.
403     function openChannel(address participant1, address participant2, uint256 settle_timeout)
404         isSafe
405         settleTimeoutValid(settle_timeout)
406         public
407         returns (uint256)
408     {
409         bytes32 pair_hash;
410         uint256 channel_identifier;
411 
412         // Red Eyes release token network limit
413         require(token.balanceOf(address(this)) < token_network_deposit_limit);
414 
415         // First increment the counter
416         // There will never be a channel with channel_identifier == 0
417         channel_counter += 1;
418         channel_identifier = channel_counter;
419 
420         pair_hash = getParticipantsHash(participant1, participant2);
421 
422         // There must only be one channel opened between two participants at
423         // any moment in time.
424         require(participants_hash_to_channel_identifier[pair_hash] == 0);
425         participants_hash_to_channel_identifier[pair_hash] = channel_identifier;
426 
427         Channel storage channel = channels[channel_identifier];
428 
429         // We always increase the channel counter, therefore no channel data can already exist,
430         // corresponding to this channel_identifier. This check must never fail.
431         assert(channel.settle_block_number == 0);
432         assert(channel.state == ChannelState.NonExistent);
433 
434         // Store channel information
435         channel.settle_block_number = settle_timeout;
436         channel.state = ChannelState.Opened;
437 
438         emit ChannelOpened(
439             channel_identifier,
440             participant1,
441             participant2,
442             settle_timeout
443         );
444 
445         return channel_identifier;
446     }
447 
448     /// @notice Sets the channel participant total deposit value.
449     /// Can be called by anyone.
450     /// @param channel_identifier Identifier for the channel on which this
451     /// operation takes place.
452     /// @param participant Channel participant whose deposit is being set.
453     /// @param total_deposit The total amount of tokens that the participant
454     /// will have as a deposit.
455     /// @param partner Channel partner address, needed to compute the total
456     /// channel deposit.
457     function setTotalDeposit(
458         uint256 channel_identifier,
459         address participant,
460         uint256 total_deposit,
461         address partner
462     )
463         isSafe
464         isOpen(channel_identifier)
465         public
466     {
467         require(channel_identifier == getChannelIdentifier(participant, partner));
468         require(total_deposit > 0);
469         require(total_deposit <= channel_participant_deposit_limit);
470 
471         uint256 added_deposit;
472         uint256 channel_deposit;
473 
474         Channel storage channel = channels[channel_identifier];
475         Participant storage participant_state = channel.participants[participant];
476         Participant storage partner_state = channel.participants[partner];
477 
478         // Calculate the actual amount of tokens that will be transferred
479         added_deposit = total_deposit - participant_state.deposit;
480 
481         // The actual amount of tokens that will be transferred must be > 0
482         require(added_deposit > 0);
483 
484         // Underflow check; we use <= because added_deposit == total_deposit for the first deposit
485 
486         require(added_deposit <= total_deposit);
487 
488         // This should never fail at this point. Added check for security, because we directly set
489         // the participant_state.deposit = total_deposit, while we transfer `added_deposit` tokens.
490         assert(participant_state.deposit + added_deposit == total_deposit);
491 
492         // Red Eyes release token network limit
493         require(token.balanceOf(address(this)) + added_deposit <= token_network_deposit_limit);
494 
495         // Update the participant's channel deposit
496         participant_state.deposit = total_deposit;
497 
498         // Calculate the entire channel deposit, to avoid overflow
499         channel_deposit = participant_state.deposit + partner_state.deposit;
500         // Overflow check
501         require(channel_deposit >= participant_state.deposit);
502 
503         emit ChannelNewDeposit(
504             channel_identifier,
505             participant,
506             participant_state.deposit
507         );
508 
509         // Do the transfer
510         require(token.transferFrom(msg.sender, address(this), added_deposit));
511     }
512 
513     /* /// @notice Allows `participant` to withdraw tokens from the channel that he
514     /// has with `partner`, without closing it. Can be called by anyone. Can
515     /// only be called once per each signed withdraw message.
516     /// @param channel_identifier Identifier for the channel on which this
517     /// operation takes place.
518     /// @param participant Channel participant, who will receive the withdrawn
519     /// amount.
520     /// @param total_withdraw Total amount of tokens that are marked as
521     /// withdrawn from the channel during the channel lifecycle.
522     /// @param participant_signature Participant's signature on the withdraw
523     /// data.
524     /// @param partner_signature Partner's signature on the withdraw data.
525     function setTotalWithdraw(
526         uint256 channel_identifier,
527         address participant,
528         uint256 total_withdraw,
529         bytes participant_signature,
530         bytes partner_signature
531     )
532         isOpen(channel_identifier)
533         external
534     {
535         uint256 total_deposit;
536         uint256 current_withdraw;
537         address partner;
538 
539         require(total_withdraw > 0);
540 
541         // Authenticate both channel partners via there signatures:
542         require(participant == recoverAddressFromWithdrawMessage(
543             channel_identifier,
544             participant,
545             total_withdraw,
546             participant_signature
547         ));
548         partner = recoverAddressFromWithdrawMessage(
549             channel_identifier,
550             participant,
551             total_withdraw,
552             partner_signature
553         );
554 
555         // Validate that authenticated partners and the channel identifier match
556         require(channel_identifier == getChannelIdentifier(participant, partner));
557 
558         // Read channel state after validating the function input
559         Channel storage channel = channels[channel_identifier];
560         Participant storage participant_state = channel.participants[participant];
561         Participant storage partner_state = channel.participants[partner];
562 
563         total_deposit = participant_state.deposit + partner_state.deposit;
564 
565         // Entire withdrawn amount must not be bigger than the current channel deposit
566         require((total_withdraw + partner_state.withdrawn_amount) <= total_deposit);
567         require(total_withdraw <= (total_withdraw + partner_state.withdrawn_amount));
568 
569         // Using the total_withdraw (monotonically increasing) in the signed
570         // message ensures that we do not allow replay attack to happen, by
571         // using the same withdraw proof twice.
572         // Next two lines enforce the monotonicity of total_withdraw and check for an underflow:
573         // (we use <= because current_withdraw == total_withdraw for the first withdraw)
574         current_withdraw = total_withdraw - participant_state.withdrawn_amount;
575         require(current_withdraw <= total_withdraw);
576 
577         // The actual amount of tokens that will be transferred must be > 0 to disable the reuse of
578         // withdraw messages completely.
579         require(current_withdraw > 0);
580 
581         // This should never fail at this point. Added check for security, because we directly set
582         // the participant_state.withdrawn_amount = total_withdraw,
583         // while we transfer `current_withdraw` tokens.
584         assert(participant_state.withdrawn_amount + current_withdraw == total_withdraw);
585 
586         emit ChannelWithdraw(
587             channel_identifier,
588             participant,
589             total_withdraw
590         );
591 
592         // Do the state change and tokens transfer
593         participant_state.withdrawn_amount = total_withdraw;
594         require(token.transfer(participant, current_withdraw));
595 
596         // This should never happen, as we have an overflow check in setTotalDeposit
597         assert(total_deposit >= participant_state.deposit);
598         assert(total_deposit >= partner_state.deposit);
599 
600         // A withdraw should never happen if a participant already has a
601         // balance proof in storage. This should never fail as we use isOpen.
602         assert(participant_state.nonce == 0);
603         assert(partner_state.nonce == 0);
604 
605     } */
606 
607     /// @notice Close the channel defined by the two participant addresses. Only
608     /// a participant may close the channel, providing a balance proof signed by
609     /// its partner. Callable only once.
610     /// @param channel_identifier Identifier for the channel on which this
611     /// operation takes place.
612     /// @param partner Channel partner of the `msg.sender`, who provided the
613     /// signature.
614     /// @param balance_hash Hash of (transferred_amount, locked_amount,
615     /// locksroot).
616     /// @param additional_hash Computed from the message. Used for message
617     /// authentication.
618     /// @param nonce Strictly monotonic value used to order transfers.
619     /// @param signature Partner's signature of the balance proof data.
620     function closeChannel(
621         uint256 channel_identifier,
622         address partner,
623         bytes32 balance_hash,
624         uint256 nonce,
625         bytes32 additional_hash,
626         bytes signature
627     )
628         isOpen(channel_identifier)
629         public
630     {
631         require(channel_identifier == getChannelIdentifier(msg.sender, partner));
632 
633         address recovered_partner_address;
634 
635         Channel storage channel = channels[channel_identifier];
636 
637         channel.state = ChannelState.Closed;
638         channel.participants[msg.sender].is_the_closer = true;
639 
640         // This is the block number at which the channel can be settled.
641         channel.settle_block_number += uint256(block.number);
642 
643         // Nonce 0 means that the closer never received a transfer, therefore
644         // never received a balance proof, or he is intentionally not providing
645         // the latest transfer, in which case the closing party is going to
646         // lose the tokens that were transferred to him.
647         if (nonce > 0) {
648             recovered_partner_address = recoverAddressFromBalanceProof(
649                 channel_identifier,
650                 balance_hash,
651                 nonce,
652                 additional_hash,
653                 signature
654             );
655             // Signature must be from the channel partner
656             require(partner == recovered_partner_address);
657 
658             updateBalanceProofData(
659                 channel,
660                 recovered_partner_address,
661                 nonce,
662                 balance_hash
663             );
664         }
665 
666         emit ChannelClosed(channel_identifier, msg.sender, nonce);
667     }
668 
669     /// @notice Called on a closed channel, the function allows the non-closing
670     /// participant to provide the last balance proof, which modifies the
671     /// closing participant's state. Can be called multiple times by anyone.
672     /// @param channel_identifier Identifier for the channel on which this
673     /// operation takes place.
674     /// @param closing_participant Channel participant who closed the channel.
675     /// @param non_closing_participant Channel participant who needs to update
676     /// the balance proof.
677     /// @param balance_hash Hash of (transferred_amount, locked_amount,
678     /// locksroot).
679     /// @param additional_hash Computed from the message. Used for message
680     /// authentication.
681     /// @param nonce Strictly monotonic value used to order transfers.
682     /// @param closing_signature Closing participant's signature of the balance
683     /// proof data.
684     /// @param non_closing_signature Non-closing participant signature of the
685     /// balance proof data.
686     function updateNonClosingBalanceProof(
687         uint256 channel_identifier,
688         address closing_participant,
689         address non_closing_participant,
690         bytes32 balance_hash,
691         uint256 nonce,
692         bytes32 additional_hash,
693         bytes closing_signature,
694         bytes non_closing_signature
695     )
696         external
697     {
698         require(channel_identifier == getChannelIdentifier(
699             closing_participant,
700             non_closing_participant
701         ));
702         require(balance_hash != bytes32(0x0));
703         require(nonce > 0);
704 
705         address recovered_non_closing_participant;
706         address recovered_closing_participant;
707 
708         Channel storage channel = channels[channel_identifier];
709 
710         require(channel.state == ChannelState.Closed);
711         // Channel must be in the settlement window
712         require(channel.settle_block_number >= block.number);
713 
714         // We need the signature from the non-closing participant to allow
715         // anyone to make this transaction. E.g. a monitoring service.
716         recovered_non_closing_participant = recoverAddressFromBalanceProofUpdateMessage(
717             channel_identifier,
718             balance_hash,
719             nonce,
720             additional_hash,
721             closing_signature,
722             non_closing_signature
723         );
724         require(non_closing_participant == recovered_non_closing_participant);
725 
726         recovered_closing_participant = recoverAddressFromBalanceProof(
727             channel_identifier,
728             balance_hash,
729             nonce,
730             additional_hash,
731             closing_signature
732         );
733         require(closing_participant == recovered_closing_participant);
734 
735         Participant storage closing_participant_state = channel.participants[closing_participant];
736         // Make sure the first signature is from the closing participant
737         require(closing_participant_state.is_the_closer);
738 
739         // Update the balance proof data for the closing_participant
740         updateBalanceProofData(channel, closing_participant, nonce, balance_hash);
741 
742         emit NonClosingBalanceProofUpdated(
743             channel_identifier,
744             closing_participant,
745             nonce
746         );
747     }
748 
749     /// @notice Settles the balance between the two parties. Note that arguments
750     /// order counts: `participant1_transferred_amount +
751     /// participant1_locked_amount` <= `participant2_transferred_amount +
752     /// participant2_locked_amount`
753     /// @param channel_identifier Identifier for the channel on which this
754     /// operation takes place.
755     /// @param participant1 Channel participant.
756     /// @param participant1_transferred_amount The latest known amount of tokens
757     /// transferred from `participant1` to `participant2`.
758     /// @param participant1_locked_amount Amount of tokens owed by
759     /// `participant1` to `participant2`, contained in locked transfers that
760     /// will be retrieved by calling `unlock` after the channel is settled.
761     /// @param participant1_locksroot The latest known merkle root of the
762     /// pending hash-time locks of `participant1`, used to validate the unlocked
763     /// proofs.
764     /// @param participant2 Other channel participant.
765     /// @param participant2_transferred_amount The latest known amount of tokens
766     /// transferred from `participant2` to `participant1`.
767     /// @param participant2_locked_amount Amount of tokens owed by
768     /// `participant2` to `participant1`, contained in locked transfers that
769     /// will be retrieved by calling `unlock` after the channel is settled.
770     /// @param participant2_locksroot The latest known merkle root of the
771     /// pending hash-time locks of `participant2`, used to validate the unlocked
772     /// proofs.
773     function settleChannel(
774         uint256 channel_identifier,
775         address participant1,
776         uint256 participant1_transferred_amount,
777         uint256 participant1_locked_amount,
778         bytes32 participant1_locksroot,
779         address participant2,
780         uint256 participant2_transferred_amount,
781         uint256 participant2_locked_amount,
782         bytes32 participant2_locksroot
783     )
784         public
785     {
786         // There are several requirements that this function MUST enforce:
787         // - it MUST never fail; therefore, any overflows or underflows must be
788         // handled gracefully
789         // - it MUST ensure that if participants use the latest valid balance proofs,
790         // provided by the official Raiden client, the participants will be able
791         // to receive correct final balances at the end of the channel lifecycle
792         // - it MUST ensure that the participants cannot cheat by providing an
793         // old, valid balance proof of their partner; meaning that their partner MUST
794         // receive at least the amount of tokens that he would have received if
795         // the latest valid balance proofs are used.
796         // - the contract cannot determine if a balance proof is invalid (values
797         // are not within the constraints enforced by the official Raiden client),
798         // therefore it cannot ensure correctness. Users MUST use the official
799         // Raiden clients for signing balance proofs.
800 
801         require(channel_identifier == getChannelIdentifier(participant1, participant2));
802 
803         bytes32 pair_hash;
804 
805         pair_hash = getParticipantsHash(participant1, participant2);
806         Channel storage channel = channels[channel_identifier];
807 
808         require(channel.state == ChannelState.Closed);
809 
810         // Settlement window must be over
811         require(channel.settle_block_number < block.number);
812 
813         Participant storage participant1_state = channel.participants[participant1];
814         Participant storage participant2_state = channel.participants[participant2];
815 
816         require(verifyBalanceHashData(
817             participant1_state,
818             participant1_transferred_amount,
819             participant1_locked_amount,
820             participant1_locksroot
821         ));
822 
823         require(verifyBalanceHashData(
824             participant2_state,
825             participant2_transferred_amount,
826             participant2_locked_amount,
827             participant2_locksroot
828         ));
829 
830         // We are calculating the final token amounts that need to be
831         // transferred to the participants now and the amount of tokens that
832         // need to remain locked in the contract. These tokens can be unlocked
833         // by calling `unlock`.
834         // participant1_transferred_amount = the amount of tokens that
835         //   participant1 will receive in this transaction.
836         // participant2_transferred_amount = the amount of tokens that
837         //   participant2 will receive in this transaction.
838         // participant1_locked_amount = the amount of tokens remaining in the
839         //   contract, representing pending transfers from participant1 to participant2.
840         // participant2_locked_amount = the amount of tokens remaining in the
841         //   contract, representing pending transfers from participant2 to participant1.
842         // We are reusing variables due to the local variables number limit.
843         // For better readability this can be refactored further.
844         (
845             participant1_transferred_amount,
846             participant2_transferred_amount,
847             participant1_locked_amount,
848             participant2_locked_amount
849         ) = getSettleTransferAmounts(
850             participant1_state,
851             participant1_transferred_amount,
852             participant1_locked_amount,
853             participant2_state,
854             participant2_transferred_amount,
855             participant2_locked_amount
856         );
857 
858         // Remove the channel data from storage
859         delete channel.participants[participant1];
860         delete channel.participants[participant2];
861         delete channels[channel_identifier];
862 
863         // Remove the pair's channel counter
864         delete participants_hash_to_channel_identifier[pair_hash];
865 
866         // Store balance data needed for `unlock`, including the calculated
867         // locked amounts remaining in the contract.
868         storeUnlockData(
869             channel_identifier,
870             participant1,
871             participant2,
872             participant1_locked_amount,
873             participant1_locksroot
874         );
875         storeUnlockData(
876             channel_identifier,
877             participant2,
878             participant1,
879             participant2_locked_amount,
880             participant2_locksroot
881         );
882 
883         emit ChannelSettled(
884             channel_identifier,
885             participant1_transferred_amount,
886             participant2_transferred_amount
887         );
888 
889         // Do the actual token transfers
890         if (participant1_transferred_amount > 0) {
891             require(token.transfer(participant1, participant1_transferred_amount));
892         }
893 
894         if (participant2_transferred_amount > 0) {
895             require(token.transfer(participant2, participant2_transferred_amount));
896         }
897     }
898 
899     /// @notice Unlocks all pending off-chain transfers from `partner` to
900     /// `participant` and sends the locked tokens corresponding to locks with
901     /// secrets registered on-chain to the `participant`. Locked tokens
902     /// corresponding to locks where the secret was not revelead on-chain will
903     /// return to the `partner`. Anyone can call unlock.
904     /// @param channel_identifier Identifier for the channel on which this
905     /// operation takes place.
906     /// @param participant Address who will receive the claimable unlocked
907     /// tokens.
908     /// @param partner Address who sent the pending transfers and will receive
909     /// the unclaimable unlocked tokens.
910     /// @param merkle_tree_leaves The entire merkle tree of pending transfers
911     /// that `partner` sent to `participant`.
912     function unlock(
913         uint256 channel_identifier,
914         address participant,
915         address partner,
916         bytes merkle_tree_leaves
917     )
918         public
919     {
920         // Channel represented by channel_identifier must be settled and
921         // channel data deleted
922         require(channel_identifier != getChannelIdentifier(participant, partner));
923 
924         // After the channel is settled the storage is cleared, therefore the
925         // value will be NonExistent and not Settled. The value Settled is used
926         // for the external APIs
927         require(channels[channel_identifier].state == ChannelState.NonExistent);
928 
929         require(merkle_tree_leaves.length > 0);
930 
931         bytes32 unlock_key;
932         bytes32 computed_locksroot;
933         uint256 unlocked_amount;
934         uint256 locked_amount;
935         uint256 returned_tokens;
936 
937         // Calculate the locksroot for the pending transfers and the amount of
938         // tokens corresponding to the locked transfers with secrets revealed
939         // on chain.
940         (computed_locksroot, unlocked_amount) = getMerkleRootAndUnlockedAmount(
941             merkle_tree_leaves
942         );
943 
944         // The partner must have a non-empty locksroot on-chain that must be
945         // the same as the computed locksroot.
946         // Get the amount of tokens that have been left in the contract, to
947         // account for the pending transfers `partner` -> `participant`.
948         unlock_key = getUnlockIdentifier(channel_identifier, partner, participant);
949         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[unlock_key];
950         locked_amount = unlock_data.locked_amount;
951 
952         // Locksroot must be the same as the computed locksroot
953         require(unlock_data.locksroot == computed_locksroot);
954 
955         // There are no pending transfers if the locked_amount is 0.
956         // Transaction must fail
957         require(locked_amount > 0);
958 
959         // Make sure we don't transfer more tokens than previously reserved in
960         // the smart contract.
961         unlocked_amount = min(unlocked_amount, locked_amount);
962 
963         // Transfer the rest of the tokens back to the partner
964         returned_tokens = locked_amount - unlocked_amount;
965 
966         // Remove partner's unlock data
967         delete unlock_identifier_to_unlock_data[unlock_key];
968 
969         emit ChannelUnlocked(
970             channel_identifier,
971             participant,
972             partner,
973             computed_locksroot,
974             unlocked_amount,
975             returned_tokens
976         );
977 
978         // Transfer the unlocked tokens to the participant. unlocked_amount can
979         // be 0
980         if (unlocked_amount > 0) {
981             require(token.transfer(participant, unlocked_amount));
982         }
983 
984         // Transfer the rest of the tokens back to the partner
985         if (returned_tokens > 0) {
986             require(token.transfer(partner, returned_tokens));
987         }
988 
989         // At this point, this should always be true
990         assert(locked_amount >= returned_tokens);
991         assert(locked_amount >= unlocked_amount);
992     }
993 
994     /* /// @notice Cooperatively settles the balances between the two channel
995     /// participants and transfers the agreed upon token amounts to the
996     /// participants. After this the channel lifecycle has ended and no more
997     /// operations can be done on it.
998     /// @param channel_identifier Identifier for the channel on which this
999     /// operation takes place.
1000     /// @param participant1_address Address of channel participant.
1001     /// @param participant1_balance Amount of tokens that `participant1_address`
1002     /// must receive when the channel is settled and removed.
1003     /// @param participant2_address Address of the other channel participant.
1004     /// @param participant2_balance Amount of tokens that `participant2_address`
1005     /// must receive when the channel is settled and removed.
1006     /// @param participant1_signature Signature of `participant1_address` on the
1007     /// cooperative settle message.
1008     /// @param participant2_signature Signature of `participant2_address` on the
1009     /// cooperative settle message.
1010     function cooperativeSettle(
1011         uint256 channel_identifier,
1012         address participant1_address,
1013         uint256 participant1_balance,
1014         address participant2_address,
1015         uint256 participant2_balance,
1016         bytes participant1_signature,
1017         bytes participant2_signature
1018     )
1019         public
1020     {
1021         require(channel_identifier == getChannelIdentifier(
1022             participant1_address,
1023             participant2_address
1024         ));
1025         bytes32 pair_hash;
1026         address participant1;
1027         address participant2;
1028         uint256 total_available_deposit;
1029 
1030         pair_hash = getParticipantsHash(participant1_address, participant2_address);
1031         Channel storage channel = channels[channel_identifier];
1032 
1033         require(channel.state == ChannelState.Opened);
1034 
1035         participant1 = recoverAddressFromCooperativeSettleSignature(
1036             channel_identifier,
1037             participant1_address,
1038             participant1_balance,
1039             participant2_address,
1040             participant2_balance,
1041             participant1_signature
1042         );
1043         // The provided address must be the same as the recovered one
1044         require(participant1 == participant1_address);
1045 
1046         participant2 = recoverAddressFromCooperativeSettleSignature(
1047             channel_identifier,
1048             participant1_address,
1049             participant1_balance,
1050             participant2_address,
1051             participant2_balance,
1052             participant2_signature
1053         );
1054         // The provided address must be the same as the recovered one
1055         require(participant2 == participant2_address);
1056 
1057         Participant storage participant1_state = channel.participants[participant1];
1058         Participant storage participant2_state = channel.participants[participant2];
1059 
1060         total_available_deposit = getChannelAvailableDeposit(
1061             participant1_state,
1062             participant2_state
1063         );
1064         // The sum of the provided balances must be equal to the total
1065         // available deposit
1066         require(total_available_deposit == (participant1_balance + participant2_balance));
1067         // Overflow check for the balances addition from the above check.
1068         // This overflow should never happen if the token.transfer function is implemented
1069         // correctly. We do not control the token implementation, therefore we add this
1070         // check for safety.
1071         require(participant1_balance <= participant1_balance + participant2_balance);
1072 
1073         // Remove channel data from storage before doing the token transfers
1074         delete channel.participants[participant1];
1075         delete channel.participants[participant2];
1076         delete channels[channel_identifier];
1077 
1078         // Remove the pair's channel counter
1079         delete participants_hash_to_channel_identifier[pair_hash];
1080 
1081         emit ChannelSettled(channel_identifier, participant1_balance, participant2_balance);
1082 
1083         // Do the token transfers
1084         if (participant1_balance > 0) {
1085             require(token.transfer(participant1, participant1_balance));
1086         }
1087 
1088         if (participant2_balance > 0) {
1089             require(token.transfer(participant2, participant2_balance));
1090         }
1091     } */
1092 
1093     /// @notice Returns the unique identifier for the channel given by the
1094     /// contract.
1095     /// @param participant Address of a channel participant.
1096     /// @param partner Address of the other channel participant.
1097     /// @return Unique identifier for the channel. It can be 0 if channel does
1098     /// not exist.
1099     function getChannelIdentifier(address participant, address partner)
1100         view
1101         public
1102         returns (uint256)
1103     {
1104         require(participant != address(0x0));
1105         require(partner != address(0x0));
1106         require(participant != partner);
1107 
1108         bytes32 pair_hash = getParticipantsHash(participant, partner);
1109         return participants_hash_to_channel_identifier[pair_hash];
1110     }
1111 
1112     /// @dev Returns the channel specific data.
1113     /// @param channel_identifier Identifier for the channel on which this
1114     /// operation takes place.
1115     /// @param participant1 Address of a channel participant.
1116     /// @param participant2 Address of the other channel participant.
1117     /// @return Channel settle_block_number and state.
1118     function getChannelInfo(
1119         uint256 channel_identifier,
1120         address participant1,
1121         address participant2
1122     )
1123         view
1124         external
1125         returns (uint256, ChannelState)
1126     {
1127         bytes32 unlock_key1;
1128         bytes32 unlock_key2;
1129 
1130         Channel storage channel = channels[channel_identifier];
1131         ChannelState state = channel.state;  // This must **not** update the storage
1132 
1133         if (state == ChannelState.NonExistent &&
1134             channel_identifier > 0 &&
1135             channel_identifier <= channel_counter
1136         ) {
1137             // The channel has been settled, channel data is removed Therefore,
1138             // the channel state in storage is actually `0`, or `NonExistent`
1139             // However, for this view function, we return `Settled`, in order
1140             // to provide a consistent external API
1141             state = ChannelState.Settled;
1142 
1143             // We might still have data stored for future unlock operations
1144             // Only if we do not, we can consider the channel as `Removed`
1145             unlock_key1 = getUnlockIdentifier(channel_identifier, participant1, participant2);
1146             UnlockData storage unlock_data1 = unlock_identifier_to_unlock_data[unlock_key1];
1147 
1148             unlock_key2 = getUnlockIdentifier(channel_identifier, participant2, participant1);
1149             UnlockData storage unlock_data2 = unlock_identifier_to_unlock_data[unlock_key2];
1150 
1151             if (unlock_data1.locked_amount == 0 && unlock_data2.locked_amount == 0) {
1152                 state = ChannelState.Removed;
1153             }
1154         }
1155 
1156         return (
1157             channel.settle_block_number,
1158             state
1159         );
1160     }
1161 
1162     /// @dev Returns the channel specific data.
1163     /// @param channel_identifier Identifier for the channel on which this
1164     /// operation takes place.
1165     /// @param participant Address of the channel participant whose data will be
1166     /// returned.
1167     /// @param partner Address of the channel partner.
1168     /// @return Participant's deposit, withdrawn_amount, whether the participant
1169     /// has called `closeChannel` or not, balance_hash, nonce, locksroot,
1170     /// locked_amount.
1171     function getChannelParticipantInfo(
1172             uint256 channel_identifier,
1173             address participant,
1174             address partner
1175     )
1176         view
1177         external
1178         returns (uint256, uint256, bool, bytes32, uint256, bytes32, uint256)
1179     {
1180         bytes32 unlock_key;
1181 
1182         Participant storage participant_state = channels[channel_identifier].participants[
1183             participant
1184         ];
1185         unlock_key = getUnlockIdentifier(channel_identifier, participant, partner);
1186         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[unlock_key];
1187 
1188         return (
1189             participant_state.deposit,
1190             participant_state.withdrawn_amount,
1191             participant_state.is_the_closer,
1192             participant_state.balance_hash,
1193             participant_state.nonce,
1194             unlock_data.locksroot,
1195             unlock_data.locked_amount
1196         );
1197     }
1198 
1199     /// @dev Get the hash of the participant addresses, ordered
1200     /// lexicographically.
1201     /// @param participant Address of a channel participant.
1202     /// @param partner Address of the other channel participant.
1203     function getParticipantsHash(address participant, address partner)
1204         pure
1205         public
1206         returns (bytes32)
1207     {
1208         require(participant != address(0x0));
1209         require(partner != address(0x0));
1210         require(participant != partner);
1211 
1212         if (participant < partner) {
1213             return keccak256(abi.encodePacked(participant, partner));
1214         } else {
1215             return keccak256(abi.encodePacked(partner, participant));
1216         }
1217     }
1218 
1219     function getUnlockIdentifier(
1220         uint256 channel_identifier,
1221         address participant,
1222         address partner
1223     )
1224         pure
1225         public
1226         returns (bytes32)
1227     {
1228         require(participant != partner);
1229         return keccak256(abi.encodePacked(channel_identifier, participant, partner));
1230     }
1231 
1232     function updateBalanceProofData(
1233         Channel storage channel,
1234         address participant,
1235         uint256 nonce,
1236         bytes32 balance_hash
1237     )
1238         internal
1239     {
1240         Participant storage participant_state = channel.participants[participant];
1241 
1242         // Multiple calls to updateNonClosingBalanceProof can be made and we
1243         // need to store the last known balance proof data
1244         require(nonce > participant_state.nonce);
1245 
1246         participant_state.nonce = nonce;
1247         participant_state.balance_hash = balance_hash;
1248     }
1249 
1250     function storeUnlockData(
1251         uint256 channel_identifier,
1252         address participant,
1253         address partner,
1254         uint256 locked_amount,
1255         bytes32 locksroot
1256     )
1257         internal
1258     {
1259         // If there are transfers to unlock, store the locksroot and total
1260         // amount of tokens
1261         if (locked_amount == 0 || locksroot == 0) {
1262             return;
1263         }
1264 
1265         bytes32 key = getUnlockIdentifier(channel_identifier, participant, partner);
1266         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[key];
1267         unlock_data.locksroot = locksroot;
1268         unlock_data.locked_amount = locked_amount;
1269     }
1270 
1271     function getChannelAvailableDeposit(
1272         Participant storage participant1_state,
1273         Participant storage participant2_state
1274     )
1275         view
1276         internal
1277         returns (uint256 total_available_deposit)
1278     {
1279         total_available_deposit = (
1280             participant1_state.deposit +
1281             participant2_state.deposit -
1282             participant1_state.withdrawn_amount -
1283             participant2_state.withdrawn_amount
1284         );
1285     }
1286 
1287     /// @dev Function that calculates the amount of tokens that the participants
1288     /// will receive when calling settleChannel.
1289     /// Check https://github.com/raiden-network/raiden-contracts/issues/188 for the settlement
1290     /// algorithm analysis and explanations.
1291     function getSettleTransferAmounts(
1292         Participant storage participant1_state,
1293         uint256 participant1_transferred_amount,
1294         uint256 participant1_locked_amount,
1295         Participant storage participant2_state,
1296         uint256 participant2_transferred_amount,
1297         uint256 participant2_locked_amount
1298     )
1299         view
1300         private
1301         returns (uint256, uint256, uint256, uint256)
1302     {
1303         // The scope of this function is to compute the settlement amounts that
1304         // the two channel participants will receive when calling settleChannel
1305         // and the locked amounts that remain in the contract, to account for
1306         // the pending, not finalized transfers, that will be received by the
1307         // participants when calling `unlock`.
1308 
1309         // The amount of tokens that participant1 MUST receive at the end of
1310         // the channel lifecycle (after settleChannel and unlock) is:
1311         // B1 = D1 - W1 + T2 - T1 + Lc2 - Lc1
1312 
1313         // The amount of tokens that participant2 MUST receive at the end of
1314         // the channel lifecycle (after settleChannel and unlock) is:
1315         // B2 = D2 - W2 + T1 - T2 + Lc1 - Lc2
1316 
1317         // B1 + B2 = TAD = D1 + D2 - W1 - W2
1318         // TAD = total available deposit at settlement time
1319 
1320         // L1 = Lc1 + Lu1
1321         // L2 = Lc2 + Lu2
1322 
1323         // where:
1324         // B1 = final balance of participant1 after the channel is removed
1325         // D1 = total amount deposited by participant1 into the channel
1326         // W1 = total amount withdrawn by participant1 from the channel
1327         // T2 = total amount transferred by participant2 to participant1 (finalized transfers)
1328         // T1 = total amount transferred by participant1 to participant2 (finalized transfers)
1329         // L1 = total amount of tokens locked in pending transfers, sent by
1330         //   participant1 to participant2
1331         // L2 = total amount of tokens locked in pending transfers, sent by
1332         //   participant2 to participant1
1333         // Lc2 = the amount that can be claimed by participant1 from the pending
1334         //   transfers (that have not been finalized off-chain), sent by
1335         //   participant2 to participant1. These are part of the locked amount
1336         //   value from participant2's balance proof. They are considered claimed
1337         //   if the secret corresponding to these locked transfers was registered
1338         //   on-chain, in the SecretRegistry contract, before the lock's expiration.
1339         // Lu1 = unclaimable locked amount from L1
1340         // Lc1 = the amount that can be claimed by participant2 from the pending
1341         //   transfers (that have not been finalized off-chain),
1342         //   sent by participant1 to participant2
1343         // Lu2 = unclaimable locked amount from L2
1344 
1345         // Notes:
1346         // 1) The unclaimble tokens from a locked amount will return to the sender.
1347         // At the time of calling settleChannel, the TokenNetwork contract does
1348         // not know what locked amounts are claimable or unclaimable.
1349         // 2) There are some Solidity constraints that make the calculations
1350         // more difficult: attention to overflows and underflows, that MUST be
1351         // handled without throwing.
1352 
1353         // Cases that require attention:
1354         // case1. If participant1 does NOT provide a balance proof or provides
1355         // an old balance proof.  participant2_transferred_amount can be [0,
1356         // real_participant2_transferred_amount) We MUST NOT punish
1357         // participant2.
1358         // case2. If participant2 does NOT provide a balance proof or provides
1359         // an old balance proof.  participant1_transferred_amount can be [0,
1360         // real_participant1_transferred_amount) We MUST NOT punish
1361         // participant1.
1362         // case3. If neither participants provide a balance proof, we just
1363         // subtract their withdrawn amounts from their deposits.
1364 
1365         // This is why, the algorithm implemented in Solidity is:
1366         // (explained at each step, below)
1367         // RmaxP1 = (T2 + L2) - (T1 + L1) + D1 - W1
1368         // RmaxP1 = min(TAD, RmaxP1)
1369         // RmaxP2 = TAD - RmaxP1
1370         // SL2 = min(RmaxP1, L2)
1371         // S1 = RmaxP1 - SL2
1372         // SL1 = min(RmaxP2, L1)
1373         // S2 = RmaxP2 - SL1
1374 
1375         // where:
1376         // RmaxP1 = due to possible over/underflows that only appear when using
1377         //    old balance proofs & the fact that settlement balance calculation
1378         //    is symmetric (we can calculate either RmaxP1 and RmaxP2 first,
1379         //    order does not affect result), this is a convention used to determine
1380         //    the maximum receivable amount of participant1 at settlement time
1381         // S1 = amount received by participant1 when calling settleChannel
1382         // SL1 = the maximum amount from L1 that can be locked in the
1383         //   TokenNetwork contract when calling settleChannel (due to overflows
1384         //   that only happen when using old balance proofs)
1385         // S2 = amount received by participant2 when calling settleChannel
1386         // SL2 = the maximum amount from L2 that can be locked in the
1387         //   TokenNetwork contract when calling settleChannel (due to overflows
1388         //   that only happen when using old balance proofs)
1389 
1390         uint256 participant1_amount;
1391         uint256 participant2_amount;
1392         uint256 total_available_deposit;
1393 
1394         SettlementData memory participant1_settlement;
1395         SettlementData memory participant2_settlement;
1396 
1397         participant1_settlement.deposit = participant1_state.deposit;
1398         participant1_settlement.withdrawn = participant1_state.withdrawn_amount;
1399         participant1_settlement.transferred = participant1_transferred_amount;
1400         participant1_settlement.locked = participant1_locked_amount;
1401 
1402         participant2_settlement.deposit = participant2_state.deposit;
1403         participant2_settlement.withdrawn = participant2_state.withdrawn_amount;
1404         participant2_settlement.transferred = participant2_transferred_amount;
1405         participant2_settlement.locked = participant2_locked_amount;
1406 
1407         // TAD = D1 + D2 - W1 - W2 = total available deposit at settlement time
1408         total_available_deposit = getChannelAvailableDeposit(
1409             participant1_state,
1410             participant2_state
1411         );
1412 
1413         // RmaxP1 = (T2 + L2) - (T1 + L1) + D1 - W1
1414         // This amount is the maximum possible amount that participant1 can
1415         // receive at settlement time and also contains the entire locked amount
1416         //  of the pending transfers from participant2 to participant1.
1417         participant1_amount = getMaxPossibleReceivableAmount(
1418             participant1_settlement,
1419             participant2_settlement
1420         );
1421 
1422         // RmaxP1 = min(TAD, RmaxP1)
1423         // We need to bound this to the available channel deposit in order to
1424         // not send tokens from other channels. The only case where TAD is
1425         // smaller than RmaxP1 is when at least one balance proof is old.
1426         participant1_amount = min(participant1_amount, total_available_deposit);
1427 
1428         // RmaxP2 = TAD - RmaxP1
1429         // Now it is safe to subtract without underflow
1430         participant2_amount = total_available_deposit - participant1_amount;
1431 
1432         // SL2 = min(RmaxP1, L2)
1433         // S1 = RmaxP1 - SL2
1434         // Both operations are done by failsafe_subtract
1435         // We take out participant2's pending transfers locked amount, bounding
1436         // it by the maximum receivable amount of participant1
1437         (participant1_amount, participant2_locked_amount) = failsafe_subtract(
1438             participant1_amount,
1439             participant2_locked_amount
1440         );
1441 
1442         // SL1 = min(RmaxP2, L1)
1443         // S2 = RmaxP2 - SL1
1444         // Both operations are done by failsafe_subtract
1445         // We take out participant1's pending transfers locked amount, bounding
1446         // it by the maximum receivable amount of participant2
1447         (participant2_amount, participant1_locked_amount) = failsafe_subtract(
1448             participant2_amount,
1449             participant1_locked_amount
1450         );
1451 
1452         // This should never throw:
1453         // S1 and S2 MUST be smaller than TAD
1454         assert(participant1_amount <= total_available_deposit);
1455         assert(participant2_amount <= total_available_deposit);
1456         // S1 + S2 + SL1 + SL2 == TAD
1457         assert(total_available_deposit == (
1458             participant1_amount +
1459             participant2_amount +
1460             participant1_locked_amount +
1461             participant2_locked_amount
1462         ));
1463 
1464         return (
1465             participant1_amount,
1466             participant2_amount,
1467             participant1_locked_amount,
1468             participant2_locked_amount
1469         );
1470     }
1471 
1472     function getMaxPossibleReceivableAmount(
1473         SettlementData participant1_settlement,
1474         SettlementData participant2_settlement
1475     )
1476         pure
1477         internal
1478         returns (uint256)
1479     {
1480         uint256 participant1_max_transferred;
1481         uint256 participant2_max_transferred;
1482         uint256 participant1_net_max_received;
1483         uint256 participant1_max_amount;
1484 
1485         // This is the maximum possible amount that participant1 could transfer
1486         // to participant2, if all the pending lock secrets have been
1487         // registered
1488         participant1_max_transferred = failsafe_addition(
1489             participant1_settlement.transferred,
1490             participant1_settlement.locked
1491         );
1492 
1493         // This is the maximum possible amount that participant2 could transfer
1494         // to participant1, if all the pending lock secrets have been
1495         // registered
1496         participant2_max_transferred = failsafe_addition(
1497             participant2_settlement.transferred,
1498             participant2_settlement.locked
1499         );
1500 
1501         // We enforce this check artificially, in order to get rid of hard
1502         // to deal with over/underflows. Settlement balance calculation is
1503         // symmetric (we can calculate either RmaxP1 and RmaxP2 first, order does
1504         // not affect result). This means settleChannel must be called with
1505         // ordered values.
1506         require(participant2_max_transferred >= participant1_max_transferred);
1507 
1508         assert(participant1_max_transferred >= participant1_settlement.transferred);
1509         assert(participant2_max_transferred >= participant2_settlement.transferred);
1510 
1511         // This is the maximum amount that participant1 can receive at settlement time
1512         participant1_net_max_received = (
1513             participant2_max_transferred -
1514             participant1_max_transferred
1515         );
1516 
1517         // Next, we add the participant1's deposit and subtract the already
1518         // withdrawn amount
1519         participant1_max_amount = failsafe_addition(
1520             participant1_net_max_received,
1521             participant1_settlement.deposit
1522         );
1523 
1524         // Subtract already withdrawn amount
1525         (participant1_max_amount, ) = failsafe_subtract(
1526             participant1_max_amount,
1527             participant1_settlement.withdrawn
1528         );
1529         return participant1_max_amount;
1530     }
1531 
1532     function verifyBalanceHashData(
1533         Participant storage participant,
1534         uint256 transferred_amount,
1535         uint256 locked_amount,
1536         bytes32 locksroot
1537     )
1538         view
1539         internal
1540         returns (bool)
1541     {
1542         // When no balance proof has been provided, we need to check this
1543         // separately because hashing values of 0 outputs a value != 0
1544         if (participant.balance_hash == 0 &&
1545             transferred_amount == 0 &&
1546             locked_amount == 0 &&
1547             locksroot == 0
1548         ) {
1549             return true;
1550         }
1551 
1552         // Make sure the hash of the provided state is the same as the stored
1553         // balance_hash
1554         return participant.balance_hash == keccak256(abi.encodePacked(
1555             transferred_amount,
1556             locked_amount,
1557             locksroot
1558         ));
1559     }
1560 
1561     function recoverAddressFromBalanceProof(
1562         uint256 channel_identifier,
1563         bytes32 balance_hash,
1564         uint256 nonce,
1565         bytes32 additional_hash,
1566         bytes signature
1567     )
1568         view
1569         internal
1570         returns (address signature_address)
1571     {
1572         // Length of the actual message: 20 + 32 + 32 + 32 + 32 + 32 + 32
1573         string memory message_length = '212';
1574 
1575         bytes32 message_hash = keccak256(abi.encodePacked(
1576             signature_prefix,
1577             message_length,
1578             address(this),
1579             chain_id,
1580             uint256(MessageTypeId.BalanceProof),
1581             channel_identifier,
1582             balance_hash,
1583             nonce,
1584             additional_hash
1585         ));
1586 
1587         signature_address = ECVerify.ecverify(message_hash, signature);
1588     }
1589 
1590     function recoverAddressFromBalanceProofUpdateMessage(
1591         uint256 channel_identifier,
1592         bytes32 balance_hash,
1593         uint256 nonce,
1594         bytes32 additional_hash,
1595         bytes closing_signature,
1596         bytes non_closing_signature
1597     )
1598         view
1599         internal
1600         returns (address signature_address)
1601     {
1602         // Length of the actual message: 20 + 32 + 32 + 32 + 32 + 32 + 32 + 65
1603         string memory message_length = '277';
1604 
1605         bytes32 message_hash = keccak256(abi.encodePacked(
1606             signature_prefix,
1607             message_length,
1608             address(this),
1609             chain_id,
1610             uint256(MessageTypeId.BalanceProofUpdate),
1611             channel_identifier,
1612             balance_hash,
1613             nonce,
1614             additional_hash,
1615             closing_signature
1616         ));
1617 
1618         signature_address = ECVerify.ecverify(message_hash, non_closing_signature);
1619     }
1620 
1621     /* function recoverAddressFromCooperativeSettleSignature(
1622         uint256 channel_identifier,
1623         address participant1,
1624         uint256 participant1_balance,
1625         address participant2,
1626         uint256 participant2_balance,
1627         bytes signature
1628     )
1629         view
1630         internal
1631         returns (address signature_address)
1632     {
1633         // Length of the actual message: 20 + 32 + 32 + 32 + 20 + 32 + 20 + 32
1634         string memory message_length = '220';
1635 
1636         bytes32 message_hash = keccak256(abi.encodePacked(
1637             signature_prefix,
1638             message_length,
1639             address(this),
1640             chain_id,
1641             uint256(MessageTypeId.CooperativeSettle),
1642             channel_identifier,
1643             participant1,
1644             participant1_balance,
1645             participant2,
1646             participant2_balance
1647         ));
1648 
1649         signature_address = ECVerify.ecverify(message_hash, signature);
1650     } */
1651 
1652     /* function recoverAddressFromWithdrawMessage(
1653         uint256 channel_identifier,
1654         address participant,
1655         uint256 total_withdraw,
1656         bytes signature
1657     )
1658         view
1659         internal
1660         returns (address signature_address)
1661     {
1662         // Length of the actual message: 20 + 32 + 32 + 32 + 20 + 32
1663         string memory message_length = '168';
1664 
1665         bytes32 message_hash = keccak256(abi.encodePacked(
1666             signature_prefix,
1667             message_length,
1668             address(this),
1669             chain_id,
1670             uint256(MessageTypeId.Withdraw),
1671             channel_identifier,
1672             participant,
1673             total_withdraw
1674         ));
1675 
1676         signature_address = ECVerify.ecverify(message_hash, signature);
1677     } */
1678 
1679     /// @dev Calculates the merkle root for the pending transfers data and
1680     //calculates the amount / of tokens that can be unlocked because the secret
1681     //was registered on-chain.
1682     function getMerkleRootAndUnlockedAmount(bytes merkle_tree_leaves)
1683         view
1684         internal
1685         returns (bytes32, uint256)
1686     {
1687         uint256 length = merkle_tree_leaves.length;
1688 
1689         // each merkle_tree lock component has this form:
1690         // (locked_amount || expiration_block || secrethash) = 3 * 32 bytes
1691         require(length % 96 == 0);
1692 
1693         uint256 i;
1694         uint256 total_unlocked_amount;
1695         uint256 unlocked_amount;
1696         bytes32 lockhash;
1697         bytes32 merkle_root;
1698 
1699         bytes32[] memory merkle_layer = new bytes32[](length / 96 + 1);
1700 
1701         for (i = 32; i < length; i += 96) {
1702             (lockhash, unlocked_amount) = getLockDataFromMerkleTree(merkle_tree_leaves, i);
1703             total_unlocked_amount += unlocked_amount;
1704             merkle_layer[i / 96] = lockhash;
1705         }
1706 
1707         length /= 96;
1708 
1709         while (length > 1) {
1710             if (length % 2 != 0) {
1711                 merkle_layer[length] = merkle_layer[length - 1];
1712                 length += 1;
1713             }
1714 
1715             for (i = 0; i < length - 1; i += 2) {
1716                 if (merkle_layer[i] == merkle_layer[i + 1]) {
1717                     lockhash = merkle_layer[i];
1718                 } else if (merkle_layer[i] < merkle_layer[i + 1]) {
1719                     lockhash = keccak256(abi.encodePacked(merkle_layer[i], merkle_layer[i + 1]));
1720                 } else {
1721                     lockhash = keccak256(abi.encodePacked(merkle_layer[i + 1], merkle_layer[i]));
1722                 }
1723                 merkle_layer[i / 2] = lockhash;
1724             }
1725             length = i / 2;
1726         }
1727 
1728         merkle_root = merkle_layer[0];
1729 
1730         return (merkle_root, total_unlocked_amount);
1731     }
1732 
1733     function getLockDataFromMerkleTree(bytes merkle_tree_leaves, uint256 offset)
1734         view
1735         internal
1736         returns (bytes32, uint256)
1737     {
1738         uint256 expiration_block;
1739         uint256 locked_amount;
1740         uint256 reveal_block;
1741         bytes32 secrethash;
1742         bytes32 lockhash;
1743 
1744         if (merkle_tree_leaves.length <= offset) {
1745             return (lockhash, 0);
1746         }
1747 
1748         assembly {
1749             expiration_block := mload(add(merkle_tree_leaves, offset))
1750             locked_amount := mload(add(merkle_tree_leaves, add(offset, 32)))
1751             secrethash := mload(add(merkle_tree_leaves, add(offset, 64)))
1752         }
1753 
1754         // Calculate the lockhash for computing the merkle root
1755         lockhash = keccak256(abi.encodePacked(expiration_block, locked_amount, secrethash));
1756 
1757         // Check if the lock's secret was revealed in the SecretRegistry The
1758         // secret must have been revealed in the SecretRegistry contract before
1759         // the lock's expiration_block in order for the hash time lock transfer
1760         // to be successful.
1761         reveal_block = secret_registry.getSecretRevealBlockHeight(secrethash);
1762         if (reveal_block == 0 || expiration_block <= reveal_block) {
1763             locked_amount = 0;
1764         }
1765 
1766         return (lockhash, locked_amount);
1767     }
1768 
1769     function min(uint256 a, uint256 b) pure internal returns (uint256)
1770     {
1771         return a > b ? b : a;
1772     }
1773 
1774     function max(uint256 a, uint256 b) pure internal returns (uint256)
1775     {
1776         return a > b ? a : b;
1777     }
1778 
1779     /// @dev Special subtraction function that does not fail when underflowing.
1780     /// @param a Minuend
1781     /// @param b Subtrahend
1782     /// @return Minimum between the result of the subtraction and 0, the maximum
1783     /// subtrahend for which no underflow occurs.
1784     function failsafe_subtract(uint256 a, uint256 b)
1785         pure
1786         internal
1787         returns (uint256, uint256)
1788     {
1789         return a > b ? (a - b, b) : (0, a);
1790     }
1791 
1792     /// @dev Special addition function that does not fail when overflowing.
1793     /// @param a Addend
1794     /// @param b Addend
1795     /// @return Maximum between the result of the addition or the maximum
1796     /// uint256 value.
1797     function failsafe_addition(uint256 a, uint256 b)
1798         pure
1799         internal
1800         returns (uint256)
1801     {
1802         uint256 sum = a + b;
1803         return sum >= a ? sum : MAX_SAFE_UINT256;
1804     }
1805 }
1806 
1807 
1808 
1809 
1810 /// @title TokenNetworkRegistry
1811 /// @notice The TokenNetwork Registry deploys new TokenNetwork contracts for the
1812 /// Raiden Network protocol.
1813 contract TokenNetworkRegistry is Utils {
1814 
1815     string constant public contract_version = "0.4.0";
1816     address public secret_registry_address;
1817     uint256 public chain_id;
1818     uint256 public settlement_timeout_min;
1819     uint256 public settlement_timeout_max;
1820 
1821     // Only for the limited Red Eyes release
1822     address public deprecation_executor;
1823     bool public token_network_created = false;
1824 
1825     // Token address => TokenNetwork address
1826     mapping(address => address) public token_to_token_networks;
1827 
1828     event TokenNetworkCreated(address indexed token_address, address indexed token_network_address);
1829 
1830     modifier canCreateTokenNetwork() {
1831         require(token_network_created == false);
1832         _;
1833     }
1834 
1835     constructor(
1836         address _secret_registry_address,
1837         uint256 _chain_id,
1838         uint256 _settlement_timeout_min,
1839         uint256 _settlement_timeout_max
1840     )
1841         public
1842     {
1843         require(_chain_id > 0);
1844         require(_settlement_timeout_min > 0);
1845         require(_settlement_timeout_max > 0);
1846         require(_settlement_timeout_max > _settlement_timeout_min);
1847         require(_secret_registry_address != address(0x0));
1848         require(contractExists(_secret_registry_address));
1849         secret_registry_address = _secret_registry_address;
1850         chain_id = _chain_id;
1851         settlement_timeout_min = _settlement_timeout_min;
1852         settlement_timeout_max = _settlement_timeout_max;
1853 
1854         deprecation_executor = msg.sender;
1855     }
1856 
1857     /// @notice Deploy a new TokenNetwork contract for the Token deployed at
1858     /// `_token_address`.
1859     /// @param _token_address Ethereum address of an already deployed token, to
1860     /// be used in the new TokenNetwork contract.
1861     function createERC20TokenNetwork(address _token_address)
1862         canCreateTokenNetwork
1863         external
1864         returns (address token_network_address)
1865     {
1866         require(token_to_token_networks[_token_address] == address(0x0));
1867 
1868         // We limit the number of token networks to 1 for the Bug Bounty release
1869         token_network_created = true;
1870 
1871         TokenNetwork token_network;
1872 
1873         // Token contract checks are in the corresponding TokenNetwork contract
1874         token_network = new TokenNetwork(
1875             _token_address,
1876             secret_registry_address,
1877             chain_id,
1878             settlement_timeout_min,
1879             settlement_timeout_max,
1880             deprecation_executor
1881         );
1882 
1883         token_network_address = address(token_network);
1884 
1885         token_to_token_networks[_token_address] = token_network_address;
1886         emit TokenNetworkCreated(_token_address, token_network_address);
1887 
1888         return token_network_address;
1889     }
1890 }