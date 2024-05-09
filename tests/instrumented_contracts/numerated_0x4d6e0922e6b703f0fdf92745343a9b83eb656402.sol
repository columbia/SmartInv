1 pragma solidity ^0.4.17;
2 
3 library ECVerify {
4 
5     function ecverify(bytes32 hash, bytes signature) internal pure returns (address signature_address) {
6         require(signature.length == 65);
7 
8         bytes32 r;
9         bytes32 s;
10         uint8 v;
11 
12         // The signature format is a compact form of:
13         //   {bytes32 r}{bytes32 s}{uint8 v}
14         // Compact means, uint8 is not padded to 32 bytes.
15         assembly {
16             r := mload(add(signature, 32))
17             s := mload(add(signature, 64))
18 
19             // Here we are loading the last 32 bytes, including 31 bytes of 's'.
20             v := byte(0, mload(add(signature, 96)))
21         }
22 
23         // Version of signature should be 27 or 28, but 0 and 1 are also possible
24         if (v < 27) {
25             v += 27;
26         }
27 
28         require(v == 27 || v == 28);
29 
30         signature_address = ecrecover(hash, v, r, s);
31 
32         // ecrecover returns zero on error
33         require(signature_address != 0x0);
34 
35         return signature_address;
36     }
37 }
38 /// @title Base Token contract - Functions to be implemented by token contracts.
39 contract Token {
40     /*
41      * Implements ERC 20 standard.
42      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
43      * https://github.com/ethereum/EIPs/issues/20
44      *
45      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
46      *  https://github.com/ethereum/EIPs/issues/223
47      */
48 
49     /*
50      * This is a slight change to the ERC20 base standard.
51      * function totalSupply() constant returns (uint256 supply);
52      * is replaced with:
53      * uint256 public totalSupply;
54      * This automatically creates a getter function for the totalSupply.
55      * This is moved to the base contract since public getter functions are not
56      * currently recognised as an implementation of the matching abstract
57      * function by the compiler.
58      */
59     uint256 public totalSupply;
60 
61     /*
62      * NOTE:
63      * The following variables were optional. Now, they are included in ERC 223 interface.
64      * They allow one to customise the token contract & in no way influences the core functionality.
65      */
66     string public name;                   //fancy name: eg Simon Bucks
67     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
68     string public symbol;                 //An identifier: eg SBX
69 
70 
71     /// @param _owner The address from which the balance will be retrieved.
72     /// @return The balance.
73     function balanceOf(address _owner) public constant returns (uint256 balance);
74 
75     /// @notice send `_value` token to `_to` from `msg.sender`.
76     /// @param _to The address of the recipient.
77     /// @param _value The amount of token to be transferred.
78     /// @param _data Data to be sent to `tokenFallback.
79     /// @return Returns success of function call.
80     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
81 
82     /// @notice send `_value` token to `_to` from `msg.sender`.
83     /// @param _to The address of the recipient.
84     /// @param _value The amount of token to be transferred.
85     /// @return Whether the transfer was successful or not.
86     function transfer(address _to, uint256 _value) public returns (bool success);
87 
88     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`.
89     /// @param _from The address of the sender.
90     /// @param _to The address of the recipient.
91     /// @param _value The amount of token to be transferred.
92     /// @return Whether the transfer was successful or not.
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
94 
95     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens.
96     /// @param _spender The address of the account able to transfer the tokens.
97     /// @param _value The amount of tokens to be approved for transfer.
98     /// @return Whether the approval was successful or not.
99     function approve(address _spender, uint256 _value) public returns (bool success);
100 
101     /// @param _owner The address of the account owning tokens.
102     /// @param _spender The address of the account able to transfer the tokens.
103     /// @return Amount of remaining tokens allowed to spent.
104     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
105 
106     /*
107      * Events
108      */
109     event Transfer(address indexed _from, address indexed _to, uint256 _value);
110     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 
112     // There is no ERC223 compatible Transfer event, with `_data` included.
113 }
114 /// @title Raiden MicroTransfer Channels Contract.
115 contract RaidenMicroTransferChannels {
116 
117     /*
118      *  Data structures
119      */
120 
121     uint32 public challenge_period;
122 
123     // Contract semantic version
124     string public constant version = '0.1.0';
125 
126     // We temporarily limit total token deposits in a channel to 100 tokens with 18 decimals.
127     // This was calculated just for RDN with its current (as of 30/11/2017) price and should
128     // not be considered to be the same for other tokens.
129     // This is just for the bug bounty release, as a safety measure.
130     uint256 public constant channel_deposit_bugbounty_limit = 10 ** 18 * 100;
131 
132     Token public token;
133 
134     mapping (bytes32 => Channel) public channels;
135     mapping (bytes32 => ClosingRequest) public closing_requests;
136 
137     // 28 (deposit) + 4 (block no settlement)
138     struct Channel {
139         // uint192 is the maximum uint size needed for deposit based on a
140         // 10^8 * 10^18 token totalSupply.
141         uint192 deposit;
142 
143         // Used in creating a unique identifier for the channel between a sender and receiver.
144         // Supports creation of multiple channels between the 2 parties and prevents
145         // replay of messages in later channels.
146         uint32 open_block_number;
147     }
148 
149     struct ClosingRequest {
150         uint192 closing_balance;
151         uint32 settle_block_number;
152     }
153 
154     /*
155      *  Events
156      */
157 
158     event ChannelCreated(
159         address indexed _sender,
160         address indexed _receiver,
161         uint192 _deposit);
162     event ChannelToppedUp (
163         address indexed _sender,
164         address indexed _receiver,
165         uint32 indexed _open_block_number,
166         uint192 _added_deposit);
167     event ChannelCloseRequested(
168         address indexed _sender,
169         address indexed _receiver,
170         uint32 indexed _open_block_number,
171         uint192 _balance);
172     event ChannelSettled(
173         address indexed _sender,
174         address indexed _receiver,
175         uint32 indexed _open_block_number,
176         uint192 _balance);
177 
178 
179     /*
180      *  Constructor
181      */
182 
183     /// @dev Constructor for creating the uRaiden microtransfer channels contract.
184     /// @param _token_address The address of the Token used by the uRaiden contract.
185     /// @param _challenge_period A fixed number of blocks representing the challenge period.
186     /// We enforce a minimum of 500 blocks waiting period.
187     /// after a sender requests the closing of the channel without the receiver's signature.
188     function RaidenMicroTransferChannels(address _token_address, uint32 _challenge_period) public {
189         require(_token_address != 0x0);
190         require(addressHasCode(_token_address));
191         require(_challenge_period >= 500);
192 
193         token = Token(_token_address);
194 
195         // Check if the contract is indeed a token contract
196         require(token.totalSupply() > 0);
197 
198         challenge_period = _challenge_period;
199     }
200 
201     /*
202      *  Public helper functions (constant)
203      */
204     /// @dev Returns the unique channel identifier used in the contract.
205     /// @param _sender_address The address that sends tokens.
206     /// @param _receiver_address The address that receives tokens.
207     /// @param _open_block_number The block number at which a channel between the
208     /// sender and receiver was created.
209     /// @return Unique channel identifier.
210     function getKey(
211         address _sender_address,
212         address _receiver_address,
213         uint32 _open_block_number)
214         public
215         pure
216         returns (bytes32 data)
217     {
218         return keccak256(_sender_address, _receiver_address, _open_block_number);
219     }
220 
221     /// @dev Returns the sender address extracted from the balance proof.
222     /// Works with eth_signTypedData https://github.com/ethereum/EIPs/pull/712.
223     /// @param _receiver_address The address that receives tokens.
224     /// @param _open_block_number The block number at which a channel between the
225     /// sender and receiver was created.
226     /// @param _balance The amount of tokens owed by the sender to the receiver.
227     /// @param _balance_msg_sig The balance message signed by the sender.
228     /// @return Address of the balance proof signer.
229     function verifyBalanceProof(
230         address _receiver_address,
231         uint32 _open_block_number,
232         uint192 _balance,
233         bytes _balance_msg_sig)
234         public
235         view
236         returns (address)
237     {
238         // The variable names from below will be shown to the sender when signing
239         // the balance proof, so they have to be kept in sync with the Dapp client.
240         // The hashed strings should be kept in sync with this function's parameters
241         // (variable names and types).
242         // ! Note that EIP712 might change how hashing is done, triggering a
243         // new contract deployment with updated code.
244         bytes32 message_hash = keccak256(
245           keccak256('address receiver', 'uint32 block_created', 'uint192 balance', 'address contract'),
246           keccak256(_receiver_address, _open_block_number, _balance, address(this))
247         );
248 
249         // Derive address from signature
250         address signer = ECVerify.ecverify(message_hash, _balance_msg_sig);
251         return signer;
252     }
253 
254     /*
255      *  External functions
256      */
257 
258     /// @dev Opens a new channel or tops up an existing one, compatibility with ERC 223;
259     /// msg.sender is Token contract.
260     /// @param _sender_address The address that sends the tokens.
261     /// @param _deposit The amount of tokens that the sender escrows.
262     /// @param _data Receiver address in bytes.
263     function tokenFallback(address _sender_address, uint256 _deposit, bytes _data) external {
264         // Make sure we trust the token
265         require(msg.sender == address(token));
266 
267         uint192 deposit = uint192(_deposit);
268         require(deposit == _deposit);
269 
270         uint length = _data.length;
271 
272         // createChannel - receiver address (20 bytes)
273         // topUp - receiver address (20 bytes) + open_block_number (4 bytes) = 24 bytes
274         require(length == 20 || length == 24);
275 
276         address receiver = addressFromData(_data);
277 
278         if(length == 20) {
279             createChannelPrivate(_sender_address, receiver, deposit);
280         } else {
281             uint32 open_block_number = blockNumberFromData(_data);
282             updateInternalBalanceStructs(
283                 _sender_address,
284                 receiver,
285                 open_block_number,
286                 deposit
287             );
288         }
289     }
290 
291     /// @dev Creates a new channel between a sender and a receiver and transfers
292     /// the sender's token deposit to this contract, compatibility with ERC20 tokens.
293     /// @param _receiver_address The address that receives tokens.
294     /// @param _deposit The amount of tokens that the sender escrows.
295     function createChannelERC20(address _receiver_address, uint192 _deposit) external {
296         createChannelPrivate(msg.sender, _receiver_address, _deposit);
297 
298         // transferFrom deposit from sender to contract
299         // ! needs prior approval from user
300         require(token.transferFrom(msg.sender, address(this), _deposit));
301     }
302 
303     /// @dev Increase the sender's current deposit.
304     /// @param _receiver_address The address that receives tokens.
305     /// @param _open_block_number The block number at which a channel between the
306     /// sender and receiver was created.
307     /// @param _added_deposit The added token deposit with which the current deposit is increased.
308     function topUpERC20(
309         address _receiver_address,
310         uint32 _open_block_number,
311         uint192 _added_deposit)
312         external
313     {
314         updateInternalBalanceStructs(
315             msg.sender,
316             _receiver_address,
317             _open_block_number,
318             _added_deposit
319         );
320 
321         // transferFrom deposit from msg.sender to contract
322         // ! needs prior approval from user
323         // Do transfer after any state change
324         require(token.transferFrom(msg.sender, address(this), _added_deposit));
325     }
326 
327     /// @dev Function called when any of the parties wants to close the channel and settle;
328     /// receiver needs a balance proof to immediately settle, sender triggers a challenge period.
329     /// @param _receiver_address The address that receives tokens.
330     /// @param _open_block_number The block number at which a channel between the
331     /// sender and receiver was created.
332     /// @param _balance The amount of tokens owed by the sender to the receiver.
333     /// @param _balance_msg_sig The balance message signed by the sender.
334     function uncooperativeClose(
335         address _receiver_address,
336         uint32 _open_block_number,
337         uint192 _balance,
338         bytes _balance_msg_sig)
339         external
340     {
341         address sender = verifyBalanceProof(_receiver_address, _open_block_number, _balance, _balance_msg_sig);
342 
343         if(msg.sender == _receiver_address) {
344             settleChannel(sender, _receiver_address, _open_block_number, _balance);
345         } else {
346             require(msg.sender == sender);
347             initChallengePeriod(_receiver_address, _open_block_number, _balance);
348         }
349     }
350 
351     /// @dev Function called by the sender, when he has a closing signature from the receiver;
352     /// channel is closed immediately.
353     /// @param _receiver_address The address that receives tokens.
354     /// @param _open_block_number The block number at which a channel between the
355     /// sender and receiver was created.
356     /// @param _balance The amount of tokens owed by the sender to the receiver.
357     /// @param _balance_msg_sig The balance message signed by the sender.
358     /// @param _closing_sig The hash of the signed balance message, signed by the receiver.
359     function cooperativeClose(
360         address _receiver_address,
361         uint32 _open_block_number,
362         uint192 _balance,
363         bytes _balance_msg_sig,
364         bytes _closing_sig)
365         external
366     {
367         // Derive receiver address from signature
368         address receiver = ECVerify.ecverify(keccak256(_balance_msg_sig), _closing_sig);
369         require(receiver == _receiver_address);
370 
371         // Derive sender address from signed balance proof
372         address sender = verifyBalanceProof(_receiver_address, _open_block_number, _balance, _balance_msg_sig);
373         require(msg.sender == sender);
374 
375         settleChannel(sender, receiver, _open_block_number, _balance);
376     }
377 
378     /// @dev Function for getting information about a channel.
379     /// @param _sender_address The address that sends tokens.
380     /// @param _receiver_address The address that receives tokens.
381     /// @param _open_block_number The block number at which a channel between the
382     /// sender and receiver was created.
383     /// @return Channel information (unique_identifier, deposit, settle_block_number, closing_balance).
384     function getChannelInfo(
385         address _sender_address,
386         address _receiver_address,
387         uint32 _open_block_number)
388         external
389         constant
390         returns (bytes32, uint192, uint32, uint192)
391     {
392         bytes32 key = getKey(_sender_address, _receiver_address, _open_block_number);
393         require(channels[key].open_block_number > 0);
394 
395         return (
396             key,
397             channels[key].deposit,
398             closing_requests[key].settle_block_number,
399             closing_requests[key].closing_balance
400         );
401     }
402 
403     /// @dev Function called by the sender after the challenge period has ended,
404     /// in case the receiver has not closed the channel.
405     /// @param _receiver_address The address that receives tokens.
406     /// @param _open_block_number The block number at which a channel between
407     /// the sender and receiver was created.
408     function settle(address _receiver_address, uint32 _open_block_number) external {
409         bytes32 key = getKey(msg.sender, _receiver_address, _open_block_number);
410 
411         // Make sure an uncooperativeClose has been initiated
412         require(closing_requests[key].settle_block_number > 0);
413 
414         // Make sure the challenge_period has ended
415 	    require(block.number > closing_requests[key].settle_block_number);
416 
417         settleChannel(msg.sender, _receiver_address, _open_block_number,
418             closing_requests[key].closing_balance
419         );
420     }
421 
422     /*
423      *  Private functions
424      */
425 
426     /// @dev Creates a new channel between a sender and a receiver,
427     /// only callable by the Token contract.
428     /// @param _sender_address The address that sends tokens.
429     /// @param _receiver_address The address that receives tokens.
430     /// @param _deposit The amount of tokens that the sender escrows.
431     function createChannelPrivate(address _sender_address, address _receiver_address, uint192 _deposit) private {
432         require(_deposit <= channel_deposit_bugbounty_limit);
433 
434         uint32 open_block_number = uint32(block.number);
435 
436         // Create unique identifier from sender, receiver and current block number
437         bytes32 key = getKey(_sender_address, _receiver_address, open_block_number);
438 
439         require(channels[key].deposit == 0);
440         require(channels[key].open_block_number == 0);
441         require(closing_requests[key].settle_block_number == 0);
442 
443         // Store channel information
444         channels[key] = Channel({deposit: _deposit, open_block_number: open_block_number});
445         ChannelCreated(_sender_address, _receiver_address, _deposit);
446     }
447 
448     /// @dev Updates internal balance Structures, only callable by the Token contract.
449     /// @param _sender_address The address that sends tokens.
450     /// @param _receiver_address The address that receives tokens.
451     /// @param _open_block_number The block number at which a channel between the
452     /// sender and receiver was created.
453     /// @param _added_deposit The added token deposit with which the current deposit is increased.
454     function updateInternalBalanceStructs(
455         address _sender_address,
456         address _receiver_address,
457         uint32 _open_block_number,
458         uint192 _added_deposit)
459         private
460     {
461         require(_added_deposit > 0);
462         require(_open_block_number > 0);
463 
464         bytes32 key = getKey(_sender_address, _receiver_address, _open_block_number);
465 
466         require(channels[key].deposit > 0);
467         require(closing_requests[key].settle_block_number == 0);
468         require(channels[key].deposit + _added_deposit <= channel_deposit_bugbounty_limit);
469 
470         channels[key].deposit += _added_deposit;
471         assert(channels[key].deposit > _added_deposit);
472         ChannelToppedUp(_sender_address, _receiver_address, _open_block_number, _added_deposit);
473     }
474 
475 
476     /// @dev Sender starts the challenge period; this can only happen once.
477     /// @param _receiver_address The address that receives tokens.
478     /// @param _open_block_number The block number at which a channel between
479     /// the sender and receiver was created.
480     /// @param _balance The amount of tokens owed by the sender to the receiver.
481     function initChallengePeriod(
482         address _receiver_address,
483         uint32 _open_block_number,
484         uint192 _balance)
485         private
486     {
487         bytes32 key = getKey(msg.sender, _receiver_address, _open_block_number);
488 
489         require(closing_requests[key].settle_block_number == 0);
490         require(_balance <= channels[key].deposit);
491 
492         // Mark channel as closed
493         closing_requests[key].settle_block_number = uint32(block.number) + challenge_period;
494         closing_requests[key].closing_balance = _balance;
495         ChannelCloseRequested(msg.sender, _receiver_address, _open_block_number, _balance);
496     }
497 
498     /// @dev Deletes the channel and settles by transfering the balance to the receiver
499     /// and the rest of the deposit back to the sender.
500     /// @param _sender_address The address that sends tokens.
501     /// @param _receiver_address The address that receives tokens.
502     /// @param _open_block_number The block number at which a channel between the
503     /// sender and receiver was created.
504     /// @param _balance The amount of tokens owed by the sender to the receiver.
505     function settleChannel(
506         address _sender_address,
507         address _receiver_address,
508         uint32 _open_block_number,
509         uint192 _balance)
510         private
511     {
512         bytes32 key = getKey(_sender_address, _receiver_address, _open_block_number);
513         Channel memory channel = channels[key];
514 
515         require(channel.open_block_number > 0);
516         require(_balance <= channel.deposit);
517 
518         // Remove closed channel structures
519         // channel.open_block_number will become 0
520         // Change state before transfer call
521         delete channels[key];
522         delete closing_requests[key];
523 
524         // Send _balance to the receiver, as it is always <= deposit
525         require(token.transfer(_receiver_address, _balance));
526 
527         // Send deposit - balance back to sender
528         require(token.transfer(_sender_address, channel.deposit - _balance));
529 
530         ChannelSettled(_sender_address, _receiver_address, _open_block_number, _balance);
531     }
532 
533     /*
534      *  Internal functions
535      */
536 
537     /// @dev Internal function for getting an address from tokenFallback data bytes.
538     /// @param b Bytes received.
539     /// @return Address resulted.
540     function addressFromData (bytes b) internal pure returns (address) {
541         bytes20 addr;
542         assembly {
543             // Read address bytes
544             // Offset of 32 bytes, representing b.length
545             addr := mload(add(b, 0x20))
546         }
547         return address(addr);
548     }
549 
550     /// @dev Internal function for getting the block number from tokenFallback data bytes.
551     /// @param b Bytes received.
552     /// @return Block number.
553     function blockNumberFromData(bytes b) internal pure returns (uint32) {
554         bytes4 block_number;
555         assembly {
556             // Read block number bytes
557             // Offset of 32 bytes (b.length) + 20 bytes (address)
558             block_number := mload(add(b, 0x34))
559         }
560         return uint32(block_number);
561     }
562 
563     /// @notice Check if a contract exists
564     /// @param _contract The address of the contract to check for.
565     /// @return True if a contract exists, false otherwise
566     function addressHasCode(address _contract) internal constant returns (bool) {
567         uint size;
568         assembly {
569             size := extcodesize(_contract)
570         }
571 
572         return size > 0;
573     }
574 }