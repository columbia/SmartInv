1 pragma solidity 0.6.4;
2 
3 
4 library ECVerify {
5 
6     function ecverify(bytes32 hash, bytes memory signature)
7         internal
8         pure
9         returns (address signature_address)
10     {
11         require(signature.length == 65);
12 
13         bytes32 r;
14         bytes32 s;
15         uint8 v;
16 
17         // The signature format is a compact form of:
18         //   {bytes32 r}{bytes32 s}{uint8 v}
19         // Compact means, uint8 is not padded to 32 bytes.
20         assembly {
21             r := mload(add(signature, 32))
22             s := mload(add(signature, 64))
23 
24             // Here we are loading the last 32 bytes, including 31 bytes following the signature.
25             v := byte(0, mload(add(signature, 96)))
26         }
27 
28         // Version of signature should be 27 or 28, but 0 and 1 are also possible
29         if (v < 27) {
30             v += 27;
31         }
32 
33         require(v == 27 || v == 28);
34 
35         signature_address = ecrecover(hash, v, r, s);
36 
37         // ecrecover returns zero on error
38         require(signature_address != address(0x0));
39 
40         return signature_address;
41     }
42 }
43 
44 interface Token {
45 
46     /// @return supply total amount of tokens
47     function totalSupply() external view returns (uint256 supply);
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return balance The balance
51     function balanceOf(address _owner) external view returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return success Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) external returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return success Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of wei to be approved for transfer
69     /// @return success Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) external returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return remaining Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80     // Optionally implemented function to show the number of decimals for the token
81     function decimals() external view returns (uint8 decimals);
82 }
83 
84 /// @title Utils
85 /// @notice Utils contract for various helpers used by the Raiden Network smart
86 /// contracts.
87 contract Utils {
88     enum MessageTypeId {
89         None,
90         BalanceProof,
91         BalanceProofUpdate,
92         Withdraw,
93         CooperativeSettle,
94         IOU,
95         MSReward
96     }
97 
98     /// @notice Check if a contract exists
99     /// @param contract_address The address to check whether a contract is
100     /// deployed or not
101     /// @return True if a contract exists, false otherwise
102     function contractExists(address contract_address) public view returns (bool) {
103         uint size;
104 
105         assembly {
106             size := extcodesize(contract_address)
107         }
108 
109         return size > 0;
110     }
111 }
112 
113 /// @title SecretRegistry
114 /// @notice SecretRegistry contract for registering secrets from Raiden Network
115 /// clients.
116 contract SecretRegistry {
117     // sha256(secret) => block number at which the secret was revealed
118     mapping(bytes32 => uint256) private secrethash_to_block;
119 
120     event SecretRevealed(bytes32 indexed secrethash, bytes32 secret);
121 
122     /// @notice Registers a hash time lock secret and saves the block number.
123     /// This allows the lock to be unlocked after the expiration block
124     /// @param secret The secret used to lock the hash time lock
125     /// @return true if secret was registered, false if the secret was already
126     /// registered
127     function registerSecret(bytes32 secret) public returns (bool) {
128         bytes32 secrethash = sha256(abi.encodePacked(secret));
129         if (secrethash_to_block[secrethash] > 0) {
130             return false;
131         }
132         secrethash_to_block[secrethash] = block.number;
133         emit SecretRevealed(secrethash, secret);
134         return true;
135     }
136 
137     /// @notice Registers multiple hash time lock secrets and saves the block
138     /// number
139     /// @param secrets The array of secrets to be registered
140     /// @return true if all secrets could be registered, false otherwise
141     function registerSecretBatch(bytes32[] memory secrets) public returns (bool) {
142         bool completeSuccess = true;
143         for(uint i = 0; i < secrets.length; i++) {
144             if(!registerSecret(secrets[i])) {
145                 completeSuccess = false;
146             }
147         }
148         return completeSuccess;
149     }
150 
151     /// @notice Get the stored block number at which the secret was revealed
152     /// @param secrethash The hash of the registered secret `keccak256(secret)`
153     /// @return The block number at which the secret was revealed
154     function getSecretRevealBlockHeight(bytes32 secrethash) public view returns (uint256) {
155         return secrethash_to_block[secrethash];
156     }
157 }
158 
159 // MIT License
160 
161 // Copyright (c) 2018
162 
163 // Permission is hereby granted, free of charge, to any person obtaining a copy
164 // of this software and associated documentation files (the "Software"), to deal
165 // in the Software without restriction, including without limitation the rights
166 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
167 // copies of the Software, and to permit persons to whom the Software is
168 // furnished to do so, subject to the following conditions:
169 
170 // The above copyright notice and this permission notice shall be included in all
171 // copies or substantial portions of the Software.
172 
173 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
174 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
175 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
176 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
177 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
178 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
179 // SOFTWARE.
180 
181 /// @title TokenNetwork
182 /// @notice Stores and manages all the Raiden Network channels that use the
183 /// token specified
184 /// in this TokenNetwork contract.
185 contract TokenNetwork is Utils {
186     // Instance of the token used by the channels
187     Token public token;
188 
189     // Instance of SecretRegistry used for storing secrets revealed in a
190     // mediating transfer.
191     SecretRegistry public secret_registry;
192 
193     // Chain ID as specified by EIP155 used in balance proof signatures to
194     // avoid replay attacks
195     uint256 public chain_id;
196 
197     uint256 public settlement_timeout_min;
198     uint256 public settlement_timeout_max;
199 
200     uint256 constant public MAX_SAFE_UINT256 = (
201         115792089237316195423570985008687907853269984665640564039457584007913129639935
202     );
203 
204     // The deposit limit per channel per participant.
205     uint256 public channel_participant_deposit_limit;
206     // The total combined deposit of all channels across the whole network
207     uint256 public token_network_deposit_limit;
208 
209     // Global, monotonically increasing counter that keeps track of all the
210     // opened channels in this contract
211     uint256 public channel_counter;
212 
213     string public constant signature_prefix = '\x19Ethereum Signed Message:\n';
214 
215     // Only for the limited Red Eyes release
216     address public deprecation_executor;
217     bool public safety_deprecation_switch = false;
218 
219     // channel_identifier => Channel
220     // channel identifier is the channel_counter value at the time of opening
221     // the channel
222     mapping (uint256 => Channel) public channels;
223 
224     // This is needed to enforce one channel per pair of participants
225     // The key is keccak256(participant1_address, participant2_address)
226     mapping (bytes32 => uint256) public participants_hash_to_channel_identifier;
227 
228     // We keep the unlock data in a separate mapping to allow channel data
229     // structures to be removed when settling uncooperatively. If there are
230     // locked pending transfers, we need to store data needed to unlock them at
231     // a later time.
232     // The key is `keccak256(uint256 channel_identifier, address participant,
233     // address partner)` Where `participant` is the participant that sent the
234     // pending transfers We need `partner` for knowing where to send the
235     // claimable tokens
236     mapping(bytes32 => UnlockData) private unlock_identifier_to_unlock_data;
237 
238     struct Participant {
239         // Total amount of tokens transferred to this smart contract through
240         // the `setTotalDeposit` function, for a specific channel, in the
241         // participant's benefit.
242         // This is a strictly monotonic value. Note that direct token transfer
243         // into the contract cannot be tracked and will be stuck.
244         uint256 deposit;
245 
246         // Total amount of tokens withdrawn by the participant during the
247         // lifecycle of this channel.
248         // This is a strictly monotonic value.
249         uint256 withdrawn_amount;
250 
251         // This is a value set to true after the channel has been closed, only
252         // if this is the participant who closed the channel.
253         bool is_the_closer;
254 
255         // keccak256 of the balance data provided after a closeChannel or an
256         // updateNonClosingBalanceProof call
257         bytes32 balance_hash;
258 
259         // Monotonically increasing counter of the off-chain transfers,
260         // provided along with the balance_hash
261         uint256 nonce;
262     }
263 
264     enum ChannelState {
265         NonExistent, // 0
266         Opened,      // 1
267         Closed,      // 2
268         Settled,     // 3; Note: The channel has at least one pending unlock
269         Removed      // 4; Note: Channel data is removed, there are no pending unlocks
270     }
271 
272     struct Channel {
273         // After opening the channel this value represents the settlement
274         // window. This is the number of blocks that need to be mined between
275         // closing the channel uncooperatively and settling the channel.
276         // After the channel has been uncooperatively closed, this value
277         // represents the block number after which settleChannel can be called.
278         uint256 settle_block_number;
279 
280         ChannelState state;
281 
282         mapping(address => Participant) participants;
283     }
284 
285     struct SettlementData {
286         uint256 deposit;
287         uint256 withdrawn;
288         uint256 transferred;
289         uint256 locked;
290     }
291 
292     struct UnlockData {
293         // keccak256 hash of the pending locks from the Raiden client
294         bytes32 locksroot;
295         // Total amount of tokens locked in the pending locks corresponding
296         // to the `locksroot`
297         uint256 locked_amount;
298     }
299 
300     event ChannelOpened(
301         uint256 indexed channel_identifier,
302         address indexed participant1,
303         address indexed participant2,
304         uint256 settle_timeout
305     );
306 
307     event ChannelNewDeposit(
308         uint256 indexed channel_identifier,
309         address indexed participant,
310         uint256 total_deposit
311     );
312 
313     // Fires when the deprecation_switch's value changes
314     event DeprecationSwitch(bool new_value);
315 
316     // total_withdraw is how much the participant has withdrawn during the
317     // lifetime of the channel. The actual amount which the participant withdrew
318     // is `total_withdraw - total_withdraw_from_previous_event_or_zero`
319     event ChannelWithdraw(
320         uint256 indexed channel_identifier,
321         address indexed participant,
322         uint256 total_withdraw
323     );
324 
325     event ChannelClosed(
326         uint256 indexed channel_identifier,
327         address indexed closing_participant,
328         uint256 indexed nonce,
329         bytes32 balance_hash
330     );
331 
332     event ChannelUnlocked(
333         uint256 indexed channel_identifier,
334         address indexed receiver,
335         address indexed sender,
336         bytes32 locksroot,
337         uint256 unlocked_amount,
338         uint256 returned_tokens
339     );
340 
341     event NonClosingBalanceProofUpdated(
342         uint256 indexed channel_identifier,
343         address indexed closing_participant,
344         uint256 indexed nonce,
345         bytes32 balance_hash
346     );
347 
348     event ChannelSettled(
349         uint256 indexed channel_identifier,
350         uint256 participant1_amount,
351         bytes32 participant1_locksroot,
352         uint256 participant2_amount,
353         bytes32 participant2_locksroot
354     );
355 
356     modifier onlyDeprecationExecutor() {
357         require(msg.sender == deprecation_executor);
358         _;
359     }
360 
361     modifier isSafe() {
362         require(safety_deprecation_switch == false);
363         _;
364     }
365 
366     modifier isOpen(uint256 channel_identifier) {
367         require(channels[channel_identifier].state == ChannelState.Opened);
368         _;
369     }
370 
371     modifier settleTimeoutValid(uint256 timeout) {
372         require(timeout >= settlement_timeout_min);
373         require(timeout <= settlement_timeout_max);
374         _;
375     }
376 
377     /// @param _token_address The address of the ERC20 token contract
378     /// @param _secret_registry The address of SecretRegistry contract that witnesses the onchain secret reveals
379     /// @param _chain_id EIP-155 Chain ID of the blockchain where this instance is being deployed
380     /// @param _settlement_timeout_min The shortest settlement period (in number of blocks)
381     /// that can be chosen at the channel opening
382     /// @param _settlement_timeout_max The longest settlement period (in number of blocks)
383     /// that can be chosen at the channel opening
384     /// @param _deprecation_executor The Ethereum address that can disable new deposits and channel creation
385     /// @param _channel_participant_deposit_limit The maximum amount of tokens that can be deposited by each
386     /// participant of each channel. MAX_SAFE_UINT256 means no limits
387     /// @param _token_network_deposit_limit The maximum amount of tokens that this contract can hold
388     /// MAX_SAFE_UINT256 means no limits
389     constructor(
390         address _token_address,
391         address _secret_registry,
392         uint256 _chain_id,
393         uint256 _settlement_timeout_min,
394         uint256 _settlement_timeout_max,
395         address _deprecation_executor,
396         uint256 _channel_participant_deposit_limit,
397         uint256 _token_network_deposit_limit
398     )
399         public
400     {
401         require(_token_address != address(0x0));
402         require(_secret_registry != address(0x0));
403         require(_deprecation_executor != address(0x0));
404         require(_chain_id > 0);
405         require(_settlement_timeout_min > 0);
406         require(_settlement_timeout_max > _settlement_timeout_min);
407         require(contractExists(_token_address));
408         require(contractExists(_secret_registry));
409         require(_channel_participant_deposit_limit > 0);
410         require(_token_network_deposit_limit > 0);
411         require(_token_network_deposit_limit >= _channel_participant_deposit_limit);
412 
413         token = Token(_token_address);
414 
415         secret_registry = SecretRegistry(_secret_registry);
416         chain_id = _chain_id;
417         settlement_timeout_min = _settlement_timeout_min;
418         settlement_timeout_max = _settlement_timeout_max;
419 
420         // Make sure the contract is indeed a token contract
421         require(token.totalSupply() > 0);
422 
423         deprecation_executor = _deprecation_executor;
424         channel_participant_deposit_limit = _channel_participant_deposit_limit;
425         token_network_deposit_limit = _token_network_deposit_limit;
426     }
427 
428     function deprecate() public isSafe onlyDeprecationExecutor {
429         safety_deprecation_switch = true;
430         emit DeprecationSwitch(safety_deprecation_switch);
431     }
432 
433     /// @notice Opens a new channel between `participant1` and `participant2`.
434     /// Can be called by anyone
435     /// @param participant1 Ethereum address of a channel participant
436     /// @param participant2 Ethereum address of the other channel participant
437     /// @param settle_timeout Number of blocks that need to be mined between a
438     /// call to closeChannel and settleChannel
439     function openChannel(address participant1, address participant2, uint256 settle_timeout)
440         public
441         isSafe
442         settleTimeoutValid(settle_timeout)
443         returns (uint256)
444     {
445         bytes32 pair_hash;
446         uint256 channel_identifier;
447 
448         // Red Eyes release token network limit
449         require(token.balanceOf(address(this)) < token_network_deposit_limit);
450 
451         // First increment the counter
452         // There will never be a channel with channel_identifier == 0
453         channel_counter += 1;
454         channel_identifier = channel_counter;
455 
456         pair_hash = getParticipantsHash(participant1, participant2);
457 
458         // There must only be one channel opened between two participants at
459         // any moment in time.
460         require(participants_hash_to_channel_identifier[pair_hash] == 0);
461         participants_hash_to_channel_identifier[pair_hash] = channel_identifier;
462 
463         Channel storage channel = channels[channel_identifier];
464 
465         // We always increase the channel counter, therefore no channel data can already exist,
466         // corresponding to this channel_identifier. This check must never fail.
467         assert(channel.settle_block_number == 0);
468         assert(channel.state == ChannelState.NonExistent);
469 
470         // Store channel information
471         channel.settle_block_number = settle_timeout;
472         channel.state = ChannelState.Opened;
473 
474         emit ChannelOpened(
475             channel_identifier,
476             participant1,
477             participant2,
478             settle_timeout
479         );
480 
481         return channel_identifier;
482     }
483 
484     /// @notice Sets the channel participant total deposit value.
485     /// Can be called by anyone.
486     /// @param channel_identifier Identifier for the channel on which this
487     /// operation takes place
488     /// @param participant Channel participant whose deposit is being set
489     /// @param total_deposit The total amount of tokens that the participant
490     /// will have as a deposit
491     /// @param partner Channel partner address, needed to compute the total
492     /// channel deposit
493     function setTotalDeposit(
494         uint256 channel_identifier,
495         address participant,
496         uint256 total_deposit,
497         address partner
498     )
499         public
500         isSafe
501         isOpen(channel_identifier)
502     {
503         require(channel_identifier == getChannelIdentifier(participant, partner));
504         require(total_deposit > 0);
505         require(total_deposit <= channel_participant_deposit_limit);
506 
507         uint256 added_deposit;
508         uint256 channel_deposit;
509 
510         Channel storage channel = channels[channel_identifier];
511         Participant storage participant_state = channel.participants[participant];
512         Participant storage partner_state = channel.participants[partner];
513 
514         // Calculate the actual amount of tokens that will be transferred
515         added_deposit = total_deposit - participant_state.deposit;
516 
517         // The actual amount of tokens that will be transferred must be > 0
518         require(added_deposit > 0);
519 
520         // Underflow check; we use <= because added_deposit == total_deposit for the first deposit
521 
522         require(added_deposit <= total_deposit);
523 
524         // This should never fail at this point. Added check for security, because we directly set
525         // the participant_state.deposit = total_deposit, while we transfer `added_deposit` tokens
526         assert(participant_state.deposit + added_deposit == total_deposit);
527 
528         // Red Eyes release token network limit
529         require(token.balanceOf(address(this)) + added_deposit <= token_network_deposit_limit);
530 
531         // Update the participant's channel deposit
532         participant_state.deposit = total_deposit;
533 
534         // Calculate the entire channel deposit, to avoid overflow
535         channel_deposit = participant_state.deposit + partner_state.deposit;
536         // Overflow check
537         require(channel_deposit >= participant_state.deposit);
538 
539         emit ChannelNewDeposit(
540             channel_identifier,
541             participant,
542             participant_state.deposit
543         );
544 
545         // Do the transfer
546         require(token.transferFrom(msg.sender, address(this), added_deposit));
547     }
548 
549     /// @notice Allows `participant` to withdraw tokens from the channel that he
550     /// has with `partner`, without closing it. Can be called by anyone. Can
551     /// only be called once per each signed withdraw message
552     /// @param channel_identifier Identifier for the channel on which this
553     /// operation takes place
554     /// @param participant Channel participant, who will receive the withdrawn
555     /// amount
556     /// @param total_withdraw Total amount of tokens that are marked as
557     /// withdrawn from the channel during the channel lifecycle
558     /// @param participant_signature Participant's signature on the withdraw
559     /// data
560     /// @param partner_signature Partner's signature on the withdraw data
561     function setTotalWithdraw(
562         uint256 channel_identifier,
563         address participant,
564         uint256 total_withdraw,
565         uint256 expiration_block,
566         bytes calldata participant_signature,
567         bytes calldata partner_signature
568     )
569         external
570         isOpen(channel_identifier)
571     {
572         uint256 total_deposit;
573         uint256 current_withdraw;
574         address partner;
575 
576         require(total_withdraw > 0);
577         require(block.number < expiration_block);
578 
579         // Authenticate both channel partners via their signatures.
580         // `participant` is a part of the signed message, so given in the calldata.
581         require(participant == recoverAddressFromWithdrawMessage(
582             channel_identifier,
583             participant,
584             total_withdraw,
585             expiration_block,
586             participant_signature
587         ));
588         partner = recoverAddressFromWithdrawMessage(
589             channel_identifier,
590             participant,
591             total_withdraw,
592             expiration_block,
593             partner_signature
594         );
595 
596         // Validate that authenticated partners and the channel identifier match
597         require(channel_identifier == getChannelIdentifier(participant, partner));
598 
599         // Read channel state after validating the function input
600         Channel storage channel = channels[channel_identifier];
601         Participant storage participant_state = channel.participants[participant];
602         Participant storage partner_state = channel.participants[partner];
603 
604         total_deposit = participant_state.deposit + partner_state.deposit;
605 
606         // Entire withdrawn amount must not be bigger than the current channel deposit
607         require((total_withdraw + partner_state.withdrawn_amount) <= total_deposit);
608         require(total_withdraw <= (total_withdraw + partner_state.withdrawn_amount));
609 
610         // Using the total_withdraw (monotonically increasing) in the signed
611         // message ensures that we do not allow replay attack to happen, by
612         // using the same withdraw proof twice.
613         // Next two lines enforce the monotonicity of total_withdraw and check for an underflow:
614         // (we use <= because current_withdraw == total_withdraw for the first withdraw)
615         current_withdraw = total_withdraw - participant_state.withdrawn_amount;
616         require(current_withdraw <= total_withdraw);
617 
618         // The actual amount of tokens that will be transferred must be > 0 to disable the reuse of
619         // withdraw messages completely.
620         require(current_withdraw > 0);
621 
622         // This should never fail at this point. Added check for security, because we directly set
623         // the participant_state.withdrawn_amount = total_withdraw,
624         // while we transfer `current_withdraw` tokens.
625         assert(participant_state.withdrawn_amount + current_withdraw == total_withdraw);
626 
627         emit ChannelWithdraw(
628             channel_identifier,
629             participant,
630             total_withdraw
631         );
632 
633         // Do the state change and tokens transfer
634         participant_state.withdrawn_amount = total_withdraw;
635         require(token.transfer(participant, current_withdraw));
636 
637         // This should never happen, as we have an overflow check in setTotalDeposit
638         assert(total_deposit >= participant_state.deposit);
639         assert(total_deposit >= partner_state.deposit);
640 
641         // A withdraw should never happen if a participant already has a
642         // balance proof in storage. This should never fail as we use isOpen.
643         assert(participant_state.nonce == 0);
644         assert(partner_state.nonce == 0);
645 
646     }
647 
648     /// @notice Close the channel defined by the two participant addresses.
649     /// Anybody can call this function on behalf of a participant (called
650     /// the closing participant), providing a balance proof signed by
651     /// both parties. Callable only once
652     /// @param channel_identifier Identifier for the channel on which this
653     /// operation takes place
654     /// @param closing_participant Channel participant who closes the channel
655     /// @param non_closing_participant Channel partner of the `closing_participant`,
656     /// who provided the balance proof
657     /// @param balance_hash Hash of (transferred_amount, locked_amount,
658     /// locksroot)
659     /// @param additional_hash Computed from the message. Used for message
660     /// authentication
661     /// @param nonce Strictly monotonic value used to order transfers
662     /// @param non_closing_signature Non-closing participant's signature of the balance proof data
663     /// @param closing_signature Closing participant's signature of the balance
664     /// proof data
665     function closeChannel(
666         uint256 channel_identifier,
667         address non_closing_participant,
668         address closing_participant,
669         // The next four arguments form a balance proof.
670         bytes32 balance_hash,
671         uint256 nonce,
672         bytes32 additional_hash,
673         bytes memory non_closing_signature,
674         bytes memory closing_signature
675     )
676         public
677         isOpen(channel_identifier)
678     {
679         require(channel_identifier == getChannelIdentifier(closing_participant, non_closing_participant));
680 
681         address recovered_non_closing_participant_address;
682 
683         Channel storage channel = channels[channel_identifier];
684 
685         channel.state = ChannelState.Closed;
686         channel.participants[closing_participant].is_the_closer = true;
687 
688         // This is the block number at which the channel can be settled.
689         channel.settle_block_number += uint256(block.number);
690 
691         // The closing participant must have signed the balance proof.
692         address recovered_closing_participant_address = recoverAddressFromBalanceProofCounterSignature(
693             MessageTypeId.BalanceProof,
694             channel_identifier,
695             balance_hash,
696             nonce,
697             additional_hash,
698             non_closing_signature,
699             closing_signature
700         );
701         require(closing_participant == recovered_closing_participant_address);
702 
703         // Nonce 0 means that the closer never received a transfer, therefore
704         // never received a balance proof, or he is intentionally not providing
705         // the latest transfer, in which case the closing party is going to
706         // lose the tokens that were transferred to him.
707         if (nonce > 0) {
708             recovered_non_closing_participant_address = recoverAddressFromBalanceProof(
709                 channel_identifier,
710                 balance_hash,
711                 nonce,
712                 additional_hash,
713                 non_closing_signature
714             );
715             // Signature must be from the channel partner
716             require(non_closing_participant == recovered_non_closing_participant_address);
717 
718             updateBalanceProofData(
719                 channel,
720                 recovered_non_closing_participant_address,
721                 nonce,
722                 balance_hash
723             );
724         }
725 
726         emit ChannelClosed(channel_identifier, closing_participant, nonce, balance_hash);
727     }
728 
729     /// @notice Called on a closed channel, the function allows the non-closing
730     /// participant to provide the last balance proof, which modifies the
731     /// closing participant's state. Can be called multiple times by anyone.
732     /// @param channel_identifier Identifier for the channel on which this
733     /// operation takes place
734     /// @param closing_participant Channel participant who closed the channel
735     /// @param non_closing_participant Channel participant who needs to update
736     /// the balance proof
737     /// @param balance_hash Hash of (transferred_amount, locked_amount,
738     /// locksroot)
739     /// @param additional_hash Computed from the message. Used for message
740     /// authentication
741     /// @param nonce Strictly monotonic value used to order transfers
742     /// @param closing_signature Closing participant's signature of the balance
743     /// proof data
744     /// @param non_closing_signature Non-closing participant signature of the
745     /// balance proof data
746     function updateNonClosingBalanceProof(
747         uint256 channel_identifier,
748         address closing_participant,
749         address non_closing_participant,
750         // The next four arguments form a balance proof
751         bytes32 balance_hash,
752         uint256 nonce,
753         bytes32 additional_hash,
754         bytes calldata closing_signature,
755         bytes calldata non_closing_signature
756     )
757         external
758     {
759         require(channel_identifier == getChannelIdentifier(
760             closing_participant,
761             non_closing_participant
762         ));
763         require(balance_hash != bytes32(0x0));
764         require(nonce > 0);
765 
766         address recovered_non_closing_participant;
767         address recovered_closing_participant;
768 
769         Channel storage channel = channels[channel_identifier];
770 
771         require(channel.state == ChannelState.Closed);
772 
773         // Calling this function after the settlement window is forbidden to
774         // fix the following race condition:
775         //
776         // 1 A badly configured node A, that doesn't have a monitoring service
777         //   and is temporarily offline does not call update during the
778         //   settlement window.
779         // 2 The well behaved partner B, who called close, sees the
780         //   settlement window is over and calls settle. At this point the B's
781         //   balance proofs which should be provided by A is missing, so B will
782         //   call settle with its balance proof zeroed out.
783         // 3 A restarts and calls update, which will change B's balance
784         //   proof.
785         // 4 At this point, the transactions from 2 and 3 are racing, and one
786         //   of them will fail.
787         //
788         // To avoid the above race condition, which would require special
789         // handling on both nodes, the call to update is forbidden after the
790         // settlement window. This does not affect safety, since we assume the
791         // nodes are always properly configured and have a monitoring service
792         // available to call update on the user's behalf.
793         require(channel.settle_block_number >= block.number);
794 
795         // We need the signature from the non-closing participant to allow
796         // anyone to make this transaction. E.g. a monitoring service.
797         recovered_non_closing_participant = recoverAddressFromBalanceProofCounterSignature(
798             MessageTypeId.BalanceProofUpdate,
799             channel_identifier,
800             balance_hash,
801             nonce,
802             additional_hash,
803             closing_signature,
804             non_closing_signature
805         );
806         require(non_closing_participant == recovered_non_closing_participant);
807 
808         recovered_closing_participant = recoverAddressFromBalanceProof(
809             channel_identifier,
810             balance_hash,
811             nonce,
812             additional_hash,
813             closing_signature
814         );
815         require(closing_participant == recovered_closing_participant);
816 
817         Participant storage closing_participant_state = channel.participants[closing_participant];
818         // Make sure the first signature is from the closing participant
819         require(closing_participant_state.is_the_closer);
820 
821         // Update the balance proof data for the closing_participant
822         updateBalanceProofData(channel, closing_participant, nonce, balance_hash);
823 
824         emit NonClosingBalanceProofUpdated(
825             channel_identifier,
826             closing_participant,
827             nonce,
828             balance_hash
829         );
830     }
831 
832     /// @notice Settles the balance between the two parties. Note that arguments
833     /// order counts: `participant1_transferred_amount +
834     /// participant1_locked_amount` <= `participant2_transferred_amount +
835     /// participant2_locked_amount`
836     /// @param channel_identifier Identifier for the channel on which this
837     /// operation takes place
838     /// @param participant1 Channel participant
839     /// @param participant1_transferred_amount The latest known amount of tokens
840     /// transferred from `participant1` to `participant2`
841     /// @param participant1_locked_amount Amount of tokens owed by
842     /// `participant1` to `participant2`, contained in locked transfers that
843     /// will be retrieved by calling `unlock` after the channel is settled
844     /// @param participant1_locksroot The latest known hash of the
845     /// pending hash-time locks of `participant1`, used to validate the unlocked
846     /// proofs. If no balance_hash has been submitted, locksroot is ignored
847     /// @param participant2 Other channel participant
848     /// @param participant2_transferred_amount The latest known amount of tokens
849     /// transferred from `participant2` to `participant1`
850     /// @param participant2_locked_amount Amount of tokens owed by
851     /// `participant2` to `participant1`, contained in locked transfers that
852     /// will be retrieved by calling `unlock` after the channel is settled
853     /// @param participant2_locksroot The latest known hash of the
854     /// pending hash-time locks of `participant2`, used to validate the unlocked
855     /// proofs. If no balance_hash has been submitted, locksroot is ignored
856     function settleChannel(
857         uint256 channel_identifier,
858         address participant1,
859         uint256 participant1_transferred_amount,
860         uint256 participant1_locked_amount,
861         bytes32 participant1_locksroot,
862         address participant2,
863         uint256 participant2_transferred_amount,
864         uint256 participant2_locked_amount,
865         bytes32 participant2_locksroot
866     )
867         public
868     {
869         // There are several requirements that this function MUST enforce:
870         // - it MUST never fail; therefore, any overflows or underflows must be
871         // handled gracefully
872         // - it MUST ensure that if participants use the latest valid balance proofs,
873         // provided by the official Raiden client, the participants will be able
874         // to receive correct final balances at the end of the channel lifecycle
875         // - it MUST ensure that the participants cannot cheat by providing an
876         // old, valid balance proof of their partner; meaning that their partner MUST
877         // receive at least the amount of tokens that he would have received if
878         // the latest valid balance proofs are used.
879         // - the contract cannot determine if a balance proof is invalid (values
880         // are not within the constraints enforced by the official Raiden client),
881         // therefore it cannot ensure correctness. Users MUST use the official
882         // Raiden clients for signing balance proofs.
883 
884         require(channel_identifier == getChannelIdentifier(participant1, participant2));
885 
886         bytes32 pair_hash;
887 
888         pair_hash = getParticipantsHash(participant1, participant2);
889         Channel storage channel = channels[channel_identifier];
890 
891         require(channel.state == ChannelState.Closed);
892 
893         // Settlement window must be over
894         require(channel.settle_block_number < block.number);
895 
896         Participant storage participant1_state = channel.participants[participant1];
897         Participant storage participant2_state = channel.participants[participant2];
898 
899         require(verifyBalanceHashData(
900             participant1_state,
901             participant1_transferred_amount,
902             participant1_locked_amount,
903             participant1_locksroot
904         ));
905 
906         require(verifyBalanceHashData(
907             participant2_state,
908             participant2_transferred_amount,
909             participant2_locked_amount,
910             participant2_locksroot
911         ));
912 
913         // We are calculating the final token amounts that need to be
914         // transferred to the participants now and the amount of tokens that
915         // need to remain locked in the contract. These tokens can be unlocked
916         // by calling `unlock`.
917         // participant1_transferred_amount = the amount of tokens that
918         //   participant1 will receive in this transaction.
919         // participant2_transferred_amount = the amount of tokens that
920         //   participant2 will receive in this transaction.
921         // participant1_locked_amount = the amount of tokens remaining in the
922         //   contract, representing pending transfers from participant1 to participant2.
923         // participant2_locked_amount = the amount of tokens remaining in the
924         //   contract, representing pending transfers from participant2 to participant1.
925         // We are reusing variables due to the local variables number limit.
926         // For better readability this can be refactored further.
927         (
928             participant1_transferred_amount,
929             participant2_transferred_amount,
930             participant1_locked_amount,
931             participant2_locked_amount
932         ) = getSettleTransferAmounts(
933             participant1_state,
934             participant1_transferred_amount,
935             participant1_locked_amount,
936             participant2_state,
937             participant2_transferred_amount,
938             participant2_locked_amount
939         );
940 
941         // Remove the channel data from storage
942         delete channel.participants[participant1];
943         delete channel.participants[participant2];
944         delete channels[channel_identifier];
945 
946         // Remove the pair's channel counter
947         delete participants_hash_to_channel_identifier[pair_hash];
948 
949         // Store balance data needed for `unlock`, including the calculated
950         // locked amounts remaining in the contract.
951         storeUnlockData(
952             channel_identifier,
953             participant1,
954             participant2,
955             participant1_locked_amount,
956             participant1_locksroot
957         );
958         storeUnlockData(
959             channel_identifier,
960             participant2,
961             participant1,
962             participant2_locked_amount,
963             participant2_locksroot
964         );
965 
966         emit ChannelSettled(
967             channel_identifier,
968             participant1_transferred_amount,
969             participant1_locksroot,
970             participant2_transferred_amount,
971             participant2_locksroot
972         );
973 
974         // Do the actual token transfers
975         if (participant1_transferred_amount > 0) {
976             require(token.transfer(participant1, participant1_transferred_amount));
977         }
978 
979         if (participant2_transferred_amount > 0) {
980             require(token.transfer(participant2, participant2_transferred_amount));
981         }
982     }
983 
984     /// @notice Unlocks all pending off-chain transfers from `sender` to
985     /// `receiver` and sends the locked tokens corresponding to locks with
986     /// secrets registered on-chain to the `receiver`. Locked tokens
987     /// corresponding to locks where the secret was not revealed on-chain will
988     /// return to the `sender`. Anyone can call unlock.
989     /// @param channel_identifier Identifier for the channel on which this
990     /// operation takes place
991     /// @param receiver Address who will receive the claimable unlocked
992     /// tokens
993     /// @param sender Address who sent the pending transfers and will receive
994     /// the unclaimable unlocked tokens
995     /// @param locks All pending locks concatenated in order of creation
996     /// that `sender` sent to `receiver`
997     function unlock(
998         uint256 channel_identifier,
999         address receiver,
1000         address sender,
1001         bytes memory locks
1002     )
1003         public
1004     {
1005         // Channel represented by channel_identifier must be settled and
1006         // channel data deleted
1007         require(channel_identifier != getChannelIdentifier(receiver, sender));
1008 
1009         // After the channel is settled the storage is cleared, therefore the
1010         // value will be NonExistent and not Settled. The value Settled is used
1011         // for the external APIs
1012         require(channels[channel_identifier].state == ChannelState.NonExistent);
1013 
1014         bytes32 unlock_key;
1015         bytes32 computed_locksroot;
1016         uint256 unlocked_amount;
1017         uint256 locked_amount;
1018         uint256 returned_tokens;
1019 
1020         // Calculate the locksroot for the pending transfers and the amount of
1021         // tokens corresponding to the locked transfers with secrets revealed
1022         // on chain.
1023         (computed_locksroot, unlocked_amount) = getHashAndUnlockedAmount(
1024             locks
1025         );
1026 
1027         // The sender must have a non-empty locksroot on-chain that must be
1028         // the same as the computed locksroot.
1029         // Get the amount of tokens that have been left in the contract, to
1030         // account for the pending transfers `sender` -> `receiver`.
1031         unlock_key = getUnlockIdentifier(channel_identifier, sender, receiver);
1032         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[unlock_key];
1033         locked_amount = unlock_data.locked_amount;
1034 
1035         // Locksroot must be the same as the computed locksroot
1036         require(unlock_data.locksroot == computed_locksroot);
1037 
1038         // There are no pending transfers if the locked_amount is 0.
1039         // Transaction must fail
1040         require(locked_amount > 0);
1041 
1042         // Make sure we don't transfer more tokens than previously reserved in
1043         // the smart contract.
1044         unlocked_amount = min(unlocked_amount, locked_amount);
1045 
1046         // Transfer the rest of the tokens back to the sender
1047         returned_tokens = locked_amount - unlocked_amount;
1048 
1049         // Remove sender's unlock data
1050         delete unlock_identifier_to_unlock_data[unlock_key];
1051 
1052         emit ChannelUnlocked(
1053             channel_identifier,
1054             receiver,
1055             sender,
1056             computed_locksroot,
1057             unlocked_amount,
1058             returned_tokens
1059         );
1060 
1061         // Transfer the unlocked tokens to the receiver. unlocked_amount can
1062         // be 0
1063         if (unlocked_amount > 0) {
1064             require(token.transfer(receiver, unlocked_amount));
1065         }
1066 
1067         // Transfer the rest of the tokens back to the sender
1068         if (returned_tokens > 0) {
1069             require(token.transfer(sender, returned_tokens));
1070         }
1071 
1072         // At this point, this should always be true
1073         assert(locked_amount >= returned_tokens);
1074         assert(locked_amount >= unlocked_amount);
1075     }
1076 
1077     /* /// @notice Cooperatively settles the balances between the two channel
1078     /// participants and transfers the agreed upon token amounts to the
1079     /// participants. After this the channel lifecycle has ended and no more
1080     /// operations can be done on it.
1081     /// @param channel_identifier Identifier for the channel on which this
1082     /// operation takes place
1083     /// @param participant1_address Address of channel participant
1084     /// @param participant1_balance Amount of tokens that `participant1_address`
1085     /// must receive when the channel is settled and removed
1086     /// @param participant2_address Address of the other channel participant
1087     /// @param participant2_balance Amount of tokens that `participant2_address`
1088     /// must receive when the channel is settled and removed
1089     /// @param participant1_signature Signature of `participant1_address` on the
1090     /// cooperative settle message
1091     /// @param participant2_signature Signature of `participant2_address` on the
1092     /// cooperative settle message
1093     function cooperativeSettle(
1094         uint256 channel_identifier,
1095         address participant1_address,
1096         uint256 participant1_balance,
1097         address participant2_address,
1098         uint256 participant2_balance,
1099         bytes participant1_signature,
1100         bytes participant2_signature
1101     )
1102         public
1103     {
1104         require(channel_identifier == getChannelIdentifier(
1105             participant1_address,
1106             participant2_address
1107         ));
1108         bytes32 pair_hash;
1109         address participant1;
1110         address participant2;
1111         uint256 total_available_deposit;
1112 
1113         pair_hash = getParticipantsHash(participant1_address, participant2_address);
1114         Channel storage channel = channels[channel_identifier];
1115 
1116         require(channel.state == ChannelState.Opened);
1117 
1118         participant1 = recoverAddressFromCooperativeSettleSignature(
1119             channel_identifier,
1120             participant1_address,
1121             participant1_balance,
1122             participant2_address,
1123             participant2_balance,
1124             participant1_signature
1125         );
1126         // The provided address must be the same as the recovered one
1127         require(participant1 == participant1_address);
1128 
1129         participant2 = recoverAddressFromCooperativeSettleSignature(
1130             channel_identifier,
1131             participant1_address,
1132             participant1_balance,
1133             participant2_address,
1134             participant2_balance,
1135             participant2_signature
1136         );
1137         // The provided address must be the same as the recovered one
1138         require(participant2 == participant2_address);
1139 
1140         Participant storage participant1_state = channel.participants[participant1];
1141         Participant storage participant2_state = channel.participants[participant2];
1142 
1143         total_available_deposit = getChannelAvailableDeposit(
1144             participant1_state,
1145             participant2_state
1146         );
1147         // The sum of the provided balances must be equal to the total
1148         // available deposit
1149         require(total_available_deposit == (participant1_balance + participant2_balance));
1150         // Overflow check for the balances addition from the above check.
1151         // This overflow should never happen if the token.transfer function is implemented
1152         // correctly. We do not control the token implementation, therefore we add this
1153         // check for safety.
1154         require(participant1_balance <= participant1_balance + participant2_balance);
1155 
1156         // Remove channel data from storage before doing the token transfers
1157         delete channel.participants[participant1];
1158         delete channel.participants[participant2];
1159         delete channels[channel_identifier];
1160 
1161         // Remove the pair's channel counter
1162         delete participants_hash_to_channel_identifier[pair_hash];
1163 
1164         emit ChannelSettled(channel_identifier, participant1_balance, participant2_balance);
1165 
1166         // Do the token transfers
1167         if (participant1_balance > 0) {
1168             require(token.transfer(participant1, participant1_balance));
1169         }
1170 
1171         if (participant2_balance > 0) {
1172             require(token.transfer(participant2, participant2_balance));
1173         }
1174     } */
1175 
1176     /// @notice Returns the unique identifier for the channel given by the
1177     /// contract
1178     /// @param participant Address of a channel participant
1179     /// @param partner Address of the other channel participant
1180     /// @return Unique identifier for the channel. It can be 0 if channel does
1181     /// not exist
1182     function getChannelIdentifier(address participant, address partner)
1183         public
1184         view
1185         returns (uint256)
1186     {
1187         require(participant != address(0x0));
1188         require(partner != address(0x0));
1189         require(participant != partner);
1190 
1191         bytes32 pair_hash = getParticipantsHash(participant, partner);
1192         return participants_hash_to_channel_identifier[pair_hash];
1193     }
1194 
1195     /// @dev Returns the channel specific data.
1196     /// @param channel_identifier Identifier for the channel on which this
1197     /// operation takes place
1198     /// @param participant1 Address of a channel participant
1199     /// @param participant2 Address of the other channel participant
1200     /// @return Channel settle_block_number and state
1201     /// @notice The contract cannot really distinguish Settled and Removed
1202     /// states, especially when wrong participants are given as input.
1203     /// The contract does not remember the participants of the channel
1204     function getChannelInfo(
1205         uint256 channel_identifier,
1206         address participant1,
1207         address participant2
1208     )
1209         external
1210         view
1211         returns (uint256, ChannelState)
1212     {
1213         bytes32 unlock_key1;
1214         bytes32 unlock_key2;
1215 
1216         Channel storage channel = channels[channel_identifier];
1217         ChannelState state = channel.state;  // This must **not** update the storage
1218 
1219         if (state == ChannelState.NonExistent &&
1220             channel_identifier > 0 &&
1221             channel_identifier <= channel_counter
1222         ) {
1223             // The channel has been settled, channel data is removed Therefore,
1224             // the channel state in storage is actually `0`, or `NonExistent`
1225             // However, for this view function, we return `Settled`, in order
1226             // to provide a consistent external API
1227             state = ChannelState.Settled;
1228 
1229             // We might still have data stored for future unlock operations
1230             // Only if we do not, we can consider the channel as `Removed`
1231             unlock_key1 = getUnlockIdentifier(channel_identifier, participant1, participant2);
1232             UnlockData storage unlock_data1 = unlock_identifier_to_unlock_data[unlock_key1];
1233 
1234             unlock_key2 = getUnlockIdentifier(channel_identifier, participant2, participant1);
1235             UnlockData storage unlock_data2 = unlock_identifier_to_unlock_data[unlock_key2];
1236 
1237             if (unlock_data1.locked_amount == 0 && unlock_data2.locked_amount == 0) {
1238                 state = ChannelState.Removed;
1239             }
1240         }
1241 
1242         return (
1243             channel.settle_block_number,
1244             state
1245         );
1246     }
1247 
1248     /// @dev Returns the channel specific data.
1249     /// @param channel_identifier Identifier for the channel on which this
1250     /// operation takes place
1251     /// @param participant Address of the channel participant whose data will be
1252     /// returned
1253     /// @param partner Address of the channel partner
1254     /// @return Participant's deposit, withdrawn_amount, whether the participant
1255     /// has called `closeChannel` or not, balance_hash, nonce, locksroot,
1256     /// locked_amount
1257     function getChannelParticipantInfo(
1258             uint256 channel_identifier,
1259             address participant,
1260             address partner
1261     )
1262         external
1263         view
1264         returns (uint256, uint256, bool, bytes32, uint256, bytes32, uint256)
1265     {
1266         bytes32 unlock_key;
1267 
1268         Participant storage participant_state = channels[channel_identifier].participants[
1269             participant
1270         ];
1271         unlock_key = getUnlockIdentifier(channel_identifier, participant, partner);
1272         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[unlock_key];
1273 
1274         return (
1275             participant_state.deposit,
1276             participant_state.withdrawn_amount,
1277             participant_state.is_the_closer,
1278             participant_state.balance_hash,
1279             participant_state.nonce,
1280             unlock_data.locksroot,
1281             unlock_data.locked_amount
1282         );
1283     }
1284 
1285     /// @dev Get the hash of the participant addresses, ordered
1286     /// lexicographically
1287     /// @param participant Address of a channel participant
1288     /// @param partner Address of the other channel participant
1289     function getParticipantsHash(address participant, address partner)
1290         public
1291         pure
1292         returns (bytes32)
1293     {
1294         require(participant != address(0x0));
1295         require(partner != address(0x0));
1296         require(participant != partner);
1297 
1298         if (participant < partner) {
1299             return keccak256(abi.encodePacked(participant, partner));
1300         } else {
1301             return keccak256(abi.encodePacked(partner, participant));
1302         }
1303     }
1304 
1305     /// @dev Get the hash of the channel identifier and the participant
1306     /// addresses (whose ordering matters). The hash might be useful for
1307     /// the receiver to look up the appropriate UnlockData to claim
1308     /// @param channel_identifier Identifier for the channel which the
1309     /// UnlockData is about
1310     /// @param sender Sender of the pending transfers that the UnlockData
1311     /// represents
1312     /// @param receiver Receiver of the pending transfers that the UnlockData
1313     /// represents
1314     function getUnlockIdentifier(
1315         uint256 channel_identifier,
1316         address sender,
1317         address receiver
1318     )
1319         public
1320         pure
1321         returns (bytes32)
1322     {
1323         require(sender != receiver);
1324         return keccak256(abi.encodePacked(channel_identifier, sender, receiver));
1325     }
1326 
1327     function updateBalanceProofData(
1328         Channel storage channel,
1329         address participant,
1330         uint256 nonce,
1331         bytes32 balance_hash
1332     )
1333         internal
1334     {
1335         Participant storage participant_state = channel.participants[participant];
1336 
1337         // Multiple calls to updateNonClosingBalanceProof can be made and we
1338         // need to store the last known balance proof data.
1339         // This line prevents Monitoring Services from getting rewards
1340         // again and again using the same reward proof.
1341         require(nonce > participant_state.nonce);
1342 
1343         participant_state.nonce = nonce;
1344         participant_state.balance_hash = balance_hash;
1345     }
1346 
1347     function storeUnlockData(
1348         uint256 channel_identifier,
1349         address sender,
1350         address receiver,
1351         uint256 locked_amount,
1352         bytes32 locksroot
1353     )
1354         internal
1355     {
1356         // If there are transfers to unlock, store the locksroot and total
1357         // amount of tokens
1358         if (locked_amount == 0) {
1359             return;
1360         }
1361 
1362         bytes32 key = getUnlockIdentifier(channel_identifier, sender, receiver);
1363         UnlockData storage unlock_data = unlock_identifier_to_unlock_data[key];
1364         unlock_data.locksroot = locksroot;
1365         unlock_data.locked_amount = locked_amount;
1366     }
1367 
1368     function getChannelAvailableDeposit(
1369         Participant storage participant1_state,
1370         Participant storage participant2_state
1371     )
1372         internal
1373         view
1374         returns (uint256 total_available_deposit)
1375     {
1376         total_available_deposit = (
1377             participant1_state.deposit +
1378             participant2_state.deposit -
1379             participant1_state.withdrawn_amount -
1380             participant2_state.withdrawn_amount
1381         );
1382     }
1383 
1384     /// @dev Function that calculates the amount of tokens that the participants
1385     /// will receive when calling settleChannel.
1386     /// Check https://github.com/raiden-network/raiden-contracts/issues/188 for the settlement
1387     /// algorithm analysis and explanations.
1388     function getSettleTransferAmounts(
1389         Participant storage participant1_state,
1390         uint256 participant1_transferred_amount,
1391         uint256 participant1_locked_amount,
1392         Participant storage participant2_state,
1393         uint256 participant2_transferred_amount,
1394         uint256 participant2_locked_amount
1395     )
1396         private
1397         view
1398         returns (uint256, uint256, uint256, uint256)
1399     {
1400         // The scope of this function is to compute the settlement amounts that
1401         // the two channel participants will receive when calling settleChannel
1402         // and the locked amounts that remain in the contract, to account for
1403         // the pending, not finalized transfers, that will be received by the
1404         // participants when calling `unlock`.
1405 
1406         // The amount of tokens that participant1 MUST receive at the end of
1407         // the channel lifecycle (after settleChannel and unlock) is:
1408         // B1 = D1 - W1 + T2 - T1 + Lc2 - Lc1
1409 
1410         // The amount of tokens that participant2 MUST receive at the end of
1411         // the channel lifecycle (after settleChannel and unlock) is:
1412         // B2 = D2 - W2 + T1 - T2 + Lc1 - Lc2
1413 
1414         // B1 + B2 = TAD = D1 + D2 - W1 - W2
1415         // TAD = total available deposit at settlement time
1416 
1417         // L1 = Lc1 + Lu1
1418         // L2 = Lc2 + Lu2
1419 
1420         // where:
1421         // B1 = final balance of participant1 after the channel is removed
1422         // D1 = total amount deposited by participant1 into the channel
1423         // W1 = total amount withdrawn by participant1 from the channel
1424         // T2 = total amount transferred by participant2 to participant1 (finalized transfers)
1425         // T1 = total amount transferred by participant1 to participant2 (finalized transfers)
1426         // L1 = total amount of tokens locked in pending transfers, sent by
1427         //   participant1 to participant2
1428         // L2 = total amount of tokens locked in pending transfers, sent by
1429         //   participant2 to participant1
1430         // Lc2 = the amount that can be claimed by participant1 from the pending
1431         //   transfers (that have not been finalized off-chain), sent by
1432         //   participant2 to participant1. These are part of the locked amount
1433         //   value from participant2's balance proof. They are considered claimed
1434         //   if the secret corresponding to these locked transfers was registered
1435         //   on-chain, in the SecretRegistry contract, before the lock's expiration.
1436         // Lu1 = unclaimable locked amount from L1
1437         // Lc1 = the amount that can be claimed by participant2 from the pending
1438         //   transfers (that have not been finalized off-chain),
1439         //   sent by participant1 to participant2
1440         // Lu2 = unclaimable locked amount from L2
1441 
1442         // Notes:
1443         // 1) The unclaimble tokens from a locked amount will return to the sender.
1444         // At the time of calling settleChannel, the TokenNetwork contract does
1445         // not know what locked amounts are claimable or unclaimable.
1446         // 2) There are some Solidity constraints that make the calculations
1447         // more difficult: attention to overflows and underflows, that MUST be
1448         // handled without throwing.
1449 
1450         // Cases that require attention:
1451         // case1. If participant1 does NOT provide a balance proof or provides
1452         // an old balance proof.  participant2_transferred_amount can be [0,
1453         // real_participant2_transferred_amount) We MUST NOT punish
1454         // participant2.
1455         // case2. If participant2 does NOT provide a balance proof or provides
1456         // an old balance proof.  participant1_transferred_amount can be [0,
1457         // real_participant1_transferred_amount) We MUST NOT punish
1458         // participant1.
1459         // case3. If neither participants provide a balance proof, we just
1460         // subtract their withdrawn amounts from their deposits.
1461 
1462         // This is why, the algorithm implemented in Solidity is:
1463         // (explained at each step, below)
1464         // RmaxP1 = (T2 + L2) - (T1 + L1) + D1 - W1
1465         // RmaxP1 = min(TAD, RmaxP1)
1466         // RmaxP2 = TAD - RmaxP1
1467         // SL2 = min(RmaxP1, L2)
1468         // S1 = RmaxP1 - SL2
1469         // SL1 = min(RmaxP2, L1)
1470         // S2 = RmaxP2 - SL1
1471 
1472         // where:
1473         // RmaxP1 = due to possible over/underflows that only appear when using
1474         //    old balance proofs & the fact that settlement balance calculation
1475         //    is symmetric (we can calculate either RmaxP1 and RmaxP2 first,
1476         //    order does not affect result), this is a convention used to determine
1477         //    the maximum receivable amount of participant1 at settlement time
1478         // S1 = amount received by participant1 when calling settleChannel
1479         // SL1 = the maximum amount from L1 that can be locked in the
1480         //   TokenNetwork contract when calling settleChannel (due to overflows
1481         //   that only happen when using old balance proofs)
1482         // S2 = amount received by participant2 when calling settleChannel
1483         // SL2 = the maximum amount from L2 that can be locked in the
1484         //   TokenNetwork contract when calling settleChannel (due to overflows
1485         //   that only happen when using old balance proofs)
1486 
1487         uint256 participant1_amount;
1488         uint256 participant2_amount;
1489         uint256 total_available_deposit;
1490 
1491         SettlementData memory participant1_settlement;
1492         SettlementData memory participant2_settlement;
1493 
1494         participant1_settlement.deposit = participant1_state.deposit;
1495         participant1_settlement.withdrawn = participant1_state.withdrawn_amount;
1496         participant1_settlement.transferred = participant1_transferred_amount;
1497         participant1_settlement.locked = participant1_locked_amount;
1498 
1499         participant2_settlement.deposit = participant2_state.deposit;
1500         participant2_settlement.withdrawn = participant2_state.withdrawn_amount;
1501         participant2_settlement.transferred = participant2_transferred_amount;
1502         participant2_settlement.locked = participant2_locked_amount;
1503 
1504         // TAD = D1 + D2 - W1 - W2 = total available deposit at settlement time
1505         total_available_deposit = getChannelAvailableDeposit(
1506             participant1_state,
1507             participant2_state
1508         );
1509 
1510         // RmaxP1 = (T2 + L2) - (T1 + L1) + D1 - W1
1511         // This amount is the maximum possible amount that participant1 can
1512         // receive at settlement time and also contains the entire locked amount
1513         //  of the pending transfers from participant2 to participant1.
1514         participant1_amount = getMaxPossibleReceivableAmount(
1515             participant1_settlement,
1516             participant2_settlement
1517         );
1518 
1519         // RmaxP1 = min(TAD, RmaxP1)
1520         // We need to bound this to the available channel deposit in order to
1521         // not send tokens from other channels. The only case where TAD is
1522         // smaller than RmaxP1 is when at least one balance proof is old.
1523         participant1_amount = min(participant1_amount, total_available_deposit);
1524 
1525         // RmaxP2 = TAD - RmaxP1
1526         // Now it is safe to subtract without underflow
1527         participant2_amount = total_available_deposit - participant1_amount;
1528 
1529         // SL2 = min(RmaxP1, L2)
1530         // S1 = RmaxP1 - SL2
1531         // Both operations are done by failsafe_subtract
1532         // We take out participant2's pending transfers locked amount, bounding
1533         // it by the maximum receivable amount of participant1
1534         (participant1_amount, participant2_locked_amount) = failsafe_subtract(
1535             participant1_amount,
1536             participant2_locked_amount
1537         );
1538 
1539         // SL1 = min(RmaxP2, L1)
1540         // S2 = RmaxP2 - SL1
1541         // Both operations are done by failsafe_subtract
1542         // We take out participant1's pending transfers locked amount, bounding
1543         // it by the maximum receivable amount of participant2
1544         (participant2_amount, participant1_locked_amount) = failsafe_subtract(
1545             participant2_amount,
1546             participant1_locked_amount
1547         );
1548 
1549         // This should never throw:
1550         // S1 and S2 MUST be smaller than TAD
1551         assert(participant1_amount <= total_available_deposit);
1552         assert(participant2_amount <= total_available_deposit);
1553         // S1 + S2 + SL1 + SL2 == TAD
1554         assert(total_available_deposit == (
1555             participant1_amount +
1556             participant2_amount +
1557             participant1_locked_amount +
1558             participant2_locked_amount
1559         ));
1560 
1561         return (
1562             participant1_amount,
1563             participant2_amount,
1564             participant1_locked_amount,
1565             participant2_locked_amount
1566         );
1567     }
1568 
1569     function getMaxPossibleReceivableAmount(
1570         SettlementData memory participant1_settlement,
1571         SettlementData memory participant2_settlement
1572     )
1573         internal
1574         pure
1575         returns (uint256)
1576     {
1577         uint256 participant1_max_transferred;
1578         uint256 participant2_max_transferred;
1579         uint256 participant1_net_max_received;
1580         uint256 participant1_max_amount;
1581 
1582         // This is the maximum possible amount that participant1 could transfer
1583         // to participant2, if all the pending lock secrets have been
1584         // registered
1585         participant1_max_transferred = failsafe_addition(
1586             participant1_settlement.transferred,
1587             participant1_settlement.locked
1588         );
1589 
1590         // This is the maximum possible amount that participant2 could transfer
1591         // to participant1, if all the pending lock secrets have been
1592         // registered
1593         participant2_max_transferred = failsafe_addition(
1594             participant2_settlement.transferred,
1595             participant2_settlement.locked
1596         );
1597 
1598         // We enforce this check artificially, in order to get rid of hard
1599         // to deal with over/underflows. Settlement balance calculation is
1600         // symmetric (we can calculate either RmaxP1 and RmaxP2 first, order does
1601         // not affect result). This means settleChannel must be called with
1602         // ordered values.
1603         require(participant2_max_transferred >= participant1_max_transferred);
1604 
1605         assert(participant1_max_transferred >= participant1_settlement.transferred);
1606         assert(participant2_max_transferred >= participant2_settlement.transferred);
1607 
1608         // This is the maximum amount that participant1 can receive at settlement time
1609         participant1_net_max_received = (
1610             participant2_max_transferred -
1611             participant1_max_transferred
1612         );
1613 
1614         // Next, we add the participant1's deposit and subtract the already
1615         // withdrawn amount
1616         participant1_max_amount = failsafe_addition(
1617             participant1_net_max_received,
1618             participant1_settlement.deposit
1619         );
1620 
1621         // Subtract already withdrawn amount
1622         (participant1_max_amount, ) = failsafe_subtract(
1623             participant1_max_amount,
1624             participant1_settlement.withdrawn
1625         );
1626         return participant1_max_amount;
1627     }
1628 
1629     function verifyBalanceHashData(
1630         Participant storage participant,
1631         uint256 transferred_amount,
1632         uint256 locked_amount,
1633         bytes32 locksroot
1634     )
1635         internal
1636         view
1637         returns (bool)
1638     {
1639         // When no balance proof has been provided, we need to check this
1640         // separately because hashing values of 0 outputs a value != 0
1641         if (participant.balance_hash == 0 &&
1642             transferred_amount == 0 &&
1643             locked_amount == 0
1644             /* locksroot is ignored. */
1645         ) {
1646             return true;
1647         }
1648 
1649         // Make sure the hash of the provided state is the same as the stored
1650         // balance_hash
1651         return participant.balance_hash == keccak256(abi.encodePacked(
1652             transferred_amount,
1653             locked_amount,
1654             locksroot
1655         ));
1656     }
1657 
1658     function recoverAddressFromBalanceProof(
1659         uint256 channel_identifier,
1660         bytes32 balance_hash,
1661         uint256 nonce,
1662         bytes32 additional_hash,
1663         bytes memory signature
1664     )
1665         internal
1666         view
1667         returns (address signature_address)
1668     {
1669         // Length of the actual message: 20 + 32 + 32 + 32 + 32 + 32 + 32
1670         string memory message_length = '212';
1671 
1672         bytes32 message_hash = keccak256(abi.encodePacked(
1673             signature_prefix,
1674             message_length,
1675             address(this),
1676             chain_id,
1677             uint256(MessageTypeId.BalanceProof),
1678             channel_identifier,
1679             balance_hash,
1680             nonce,
1681             additional_hash
1682         ));
1683 
1684         signature_address = ECVerify.ecverify(message_hash, signature);
1685     }
1686 
1687     function recoverAddressFromBalanceProofCounterSignature(
1688         MessageTypeId message_type_id,
1689         uint256 channel_identifier,
1690         bytes32 balance_hash,
1691         uint256 nonce,
1692         bytes32 additional_hash,
1693         bytes memory closing_signature,
1694         bytes memory non_closing_signature
1695     )
1696         internal
1697         view
1698         returns (address signature_address)
1699     {
1700         // Length of the actual message: 20 + 32 + 32 + 32 + 32 + 32 + 32 + 65
1701         string memory message_length = '277';
1702 
1703         bytes32 message_hash = keccak256(abi.encodePacked(
1704             signature_prefix,
1705             message_length,
1706             address(this),
1707             chain_id,
1708             uint256(message_type_id),
1709             channel_identifier,
1710             balance_hash,
1711             nonce,
1712             additional_hash,
1713             closing_signature
1714         ));
1715 
1716         signature_address = ECVerify.ecverify(message_hash, non_closing_signature);
1717     }
1718 
1719     /* function recoverAddressFromCooperativeSettleSignature(
1720         uint256 channel_identifier,
1721         address participant1,
1722         uint256 participant1_balance,
1723         address participant2,
1724         uint256 participant2_balance,
1725         bytes signature
1726     )
1727         view
1728         internal
1729         returns (address signature_address)
1730     {
1731         // Length of the actual message: 20 + 32 + 32 + 32 + 20 + 32 + 20 + 32
1732         string memory message_length = '220';
1733 
1734         bytes32 message_hash = keccak256(abi.encodePacked(
1735             signature_prefix,
1736             message_length,
1737             address(this),
1738             chain_id,
1739             uint256(MessageTypeId.CooperativeSettle),
1740             channel_identifier,
1741             participant1,
1742             participant1_balance,
1743             participant2,
1744             participant2_balance
1745         ));
1746 
1747         signature_address = ECVerify.ecverify(message_hash, signature);
1748     } */
1749 
1750     function recoverAddressFromWithdrawMessage(
1751         uint256 channel_identifier,
1752         address participant,
1753         uint256 total_withdraw,
1754         uint256 expiration_block,
1755         bytes memory signature
1756     )
1757         internal
1758         view
1759         returns (address signature_address)
1760     {
1761         // Length of the actual message: 20 + 32 + 32 + 32 + 20 + 32 + 32
1762         string memory message_length = '200';
1763 
1764         bytes32 message_hash = keccak256(abi.encodePacked(
1765             signature_prefix,
1766             message_length,
1767             address(this),
1768             chain_id,
1769             uint256(MessageTypeId.Withdraw),
1770             channel_identifier,
1771             participant,
1772             total_withdraw,
1773             expiration_block
1774         ));
1775 
1776         signature_address = ECVerify.ecverify(message_hash, signature);
1777     }
1778 
1779     /// @dev Calculates the hash of the pending transfers data and
1780     /// calculates the amount of tokens that can be unlocked because the secret
1781     /// was registered on-chain.
1782     function getHashAndUnlockedAmount(bytes memory locks)
1783         internal
1784         view
1785         returns (bytes32, uint256)
1786     {
1787         uint256 length = locks.length;
1788 
1789         // each lock has this form:
1790         // (locked_amount || expiration_block || secrethash) = 3 * 32 bytes
1791         require(length % 96 == 0);
1792 
1793         uint256 i;
1794         uint256 total_unlocked_amount;
1795         uint256 unlocked_amount;
1796         bytes32 lockhash;
1797         bytes32 total_hash;
1798 
1799         for (i = 32; i < length; i += 96) {
1800             unlocked_amount = getLockedAmountFromLock(locks, i);
1801             total_unlocked_amount += unlocked_amount;
1802         }
1803 
1804         total_hash = keccak256(locks);
1805 
1806         return (total_hash, total_unlocked_amount);
1807     }
1808 
1809     function getLockedAmountFromLock(bytes memory locks, uint256 offset)
1810         internal
1811         view
1812         returns (uint256)
1813     {
1814         uint256 expiration_block;
1815         uint256 locked_amount;
1816         uint256 reveal_block;
1817         bytes32 secrethash;
1818 
1819         if (locks.length <= offset) {
1820             return 0;
1821         }
1822 
1823         assembly {
1824             expiration_block := mload(add(locks, offset))
1825             locked_amount := mload(add(locks, add(offset, 32)))
1826             secrethash := mload(add(locks, add(offset, 64)))
1827         }
1828 
1829         // Check if the lock's secret was revealed in the SecretRegistry The
1830         // secret must have been revealed in the SecretRegistry contract before
1831         // the lock's expiration_block in order for the hash time lock transfer
1832         // to be successful.
1833         reveal_block = secret_registry.getSecretRevealBlockHeight(secrethash);
1834         if (reveal_block == 0 || expiration_block <= reveal_block) {
1835             locked_amount = 0;
1836         }
1837 
1838         return locked_amount;
1839     }
1840 
1841     function min(uint256 a, uint256 b) internal pure returns (uint256)
1842     {
1843         return a > b ? b : a;
1844     }
1845 
1846     function max(uint256 a, uint256 b) internal pure returns (uint256)
1847     {
1848         return a > b ? a : b;
1849     }
1850 
1851     /// @dev Special subtraction function that does not fail when underflowing.
1852     /// @param a Minuend
1853     /// @param b Subtrahend
1854     /// @return Minimum between the result of the subtraction and 0, the maximum
1855     /// subtrahend for which no underflow occurs
1856     function failsafe_subtract(uint256 a, uint256 b)
1857         internal
1858         pure
1859         returns (uint256, uint256)
1860     {
1861         return a > b ? (a - b, b) : (0, a);
1862     }
1863 
1864     /// @dev Special addition function that does not fail when overflowing.
1865     /// @param a Addend
1866     /// @param b Addend
1867     /// @return Maximum between the result of the addition or the maximum
1868     /// uint256 value
1869     function failsafe_addition(uint256 a, uint256 b)
1870         internal
1871         pure
1872         returns (uint256)
1873     {
1874         uint256 sum = a + b;
1875         return sum >= a ? sum : MAX_SAFE_UINT256;
1876     }
1877 }