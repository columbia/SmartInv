1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Eliptic curve signature operations
6  *
7  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
8  */
9 
10 library ECRecovery {
11 
12   /**
13    * @dev Recover signer address from a message by using his signature
14    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
15    * @param sig bytes signature, the signature is generated using web3.eth.sign()
16    */
17   function recover(bytes32 hash, bytes sig) public constant returns (address) {
18     bytes32 r;
19     bytes32 s;
20     uint8 v;
21 
22     //Check the signature length
23     if (sig.length != 65) {
24       return (address(0));
25     }
26 
27     // Divide the signature in r, s and v variables
28     assembly {
29       r := mload(add(sig, 32))
30       s := mload(add(sig, 64))
31       v := byte(0, mload(add(sig, 96)))
32     }
33 
34     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
35     if (v < 27) {
36       v += 27;
37     }
38 
39     // If the version is correct return the signer address
40     if (v != 27 && v != 28) {
41       return (address(0));
42     } else {
43       return ecrecover(hash, v, r, s);
44     }
45   }
46 
47 }
48 
49 
50 //Papyrus State Channel Library
51 //moved to separate library to save gas
52 library ChannelLibrary {
53     
54     struct Data {
55         uint close_timeout;
56         uint settle_timeout;
57         uint audit_timeout;
58         uint opened;
59         uint close_requested;
60         uint closed;
61         uint settled;
62         uint audited;
63         ChannelManagerContract manager;
64     
65         address sender;
66         address receiver;
67         address client;
68         uint balance;
69         address auditor;
70 
71         //state update for close
72         uint nonce;
73         uint completed_transfers;
74     }
75 
76     struct StateUpdate {
77         uint nonce;
78         uint completed_transfers;
79     }
80 
81     modifier notSettledButClosed(Data storage self) {
82         require(self.settled <= 0 && self.closed > 0);
83         _;
84     }
85 
86     modifier notAuditedButClosed(Data storage self) {
87         require(self.audited <= 0 && self.closed > 0);
88         _;
89     }
90 
91     modifier stillTimeout(Data storage self) {
92         require(self.closed + self.settle_timeout >= block.number);
93         _;
94     }
95 
96     modifier timeoutOver(Data storage self) {
97         require(self.closed + self.settle_timeout <= block.number);
98         _;
99     }
100 
101     modifier channelSettled(Data storage self) {
102         require(self.settled != 0);
103         _;
104     }
105 
106     modifier senderOnly(Data storage self) {
107         require(self.sender == msg.sender);
108         _;
109     }
110 
111     modifier receiverOnly(Data storage self) {
112         require(self.receiver == msg.sender);
113         _;
114     }
115 
116     /// @notice Sender deposits amount to channel.
117     /// must deposit before the channel is opened.
118     /// @param amount The amount to be deposited to the address
119     /// @return Success if the transfer was successful
120     /// @return The new balance of the invoker
121     function deposit(Data storage self, uint256 amount) 
122     senderOnly(self)
123     returns (bool success, uint256 balance)
124     {
125         require(self.opened > 0);
126         require(self.closed == 0);
127 
128         StandardToken token = self.manager.token();
129 
130         require (token.balanceOf(msg.sender) >= amount);
131 
132         success = token.transferFrom(msg.sender, this, amount);
133     
134         if (success == true) {
135             self.balance += amount;
136 
137             return (true, self.balance);
138         }
139 
140         return (false, 0);
141     }
142 
143     function request_close(
144         Data storage self
145     ) {
146         require(msg.sender == self.sender || msg.sender == self.receiver);
147         require(self.close_requested == 0);
148         self.close_requested = block.number;
149     }
150 
151     function close(
152         Data storage self,
153         address channel_address,
154         uint nonce,
155         uint completed_transfers,
156         bytes signature
157     )
158     {
159         if (self.close_timeout > 0) {
160             require(self.close_requested > 0);
161             require(block.number - self.close_requested >= self.close_timeout);
162         }
163         require(nonce > self.nonce);
164         require(completed_transfers >= self.completed_transfers);
165         require(completed_transfers <= self.balance);
166     
167         if (msg.sender != self.sender) {
168             //checking signature
169             bytes32 signed_hash = hashState(
170                 channel_address,
171                 nonce,
172                 completed_transfers
173             );
174 
175             address sign_address = ECRecovery.recover(signed_hash, signature);
176             require(sign_address == self.sender);
177         }
178 
179         if (self.closed == 0) {
180             self.closed = block.number;
181         }
182     
183         self.nonce = nonce;
184         self.completed_transfers = completed_transfers;
185     }
186 
187     function hashState (
188         address channel_address,
189         uint nonce,
190         uint completed_transfers
191     ) returns (bytes32) {
192         return sha3 (
193             channel_address,
194             nonce,
195             completed_transfers
196         );
197     }
198 
199     /// @notice Settles the balance between the two parties
200     /// @dev Settles the balances of the two parties fo the channel
201     /// @return The participants with netted balances
202     function settle(Data storage self)
203         notSettledButClosed(self)
204         timeoutOver(self)
205     {
206         StandardToken token = self.manager.token();
207         
208         if (self.completed_transfers > 0) {
209             require(token.transfer(self.receiver, self.completed_transfers));
210         }
211 
212         if (self.completed_transfers < self.balance) {
213             require(token.transfer(self.sender, self.balance - self.completed_transfers));
214         }
215 
216         self.settled = block.number;
217     }
218 
219     function audit(Data storage self, address auditor)
220         notAuditedButClosed(self) {
221         require(self.auditor == auditor);
222         require(block.number <= self.closed + self.audit_timeout);
223         self.audited = block.number;
224     }
225 
226     function validateTransfer(
227         Data storage self,
228         address transfer_id,
229         address channel_address,
230         uint sum,
231         bytes lock_data,
232         bytes signature
233     ) returns (uint256) {
234 
235         bytes32 signed_hash = hashTransfer(
236             transfer_id,
237             channel_address,
238             lock_data,
239             sum
240         );
241 
242         address sign_address = ECRecovery.recover(signed_hash, signature);
243         require(sign_address == self.client);
244     }
245 
246     function hashTransfer(
247         address transfer_id,
248         address channel_address,
249         bytes lock_data,
250         uint sum
251     ) returns (bytes32) {
252         if (lock_data.length > 0) {
253             return sha3 (
254                 transfer_id,
255                 channel_address,
256                 sum,
257                 lock_data
258             );
259         } else {
260             return sha3 (
261                 transfer_id,
262                 channel_address,
263                 sum
264             );
265         }
266     }
267 }
268 
269 
270 /// @title ERC20 interface
271 /// @dev Full ERC20 interface described at https://github.com/ethereum/EIPs/issues/20.
272 contract ERC20 {
273 
274   // EVENTS
275 
276   event Transfer(address indexed from, address indexed to, uint256 value);
277   event Approval(address indexed owner, address indexed spender, uint256 value);
278 
279   // PUBLIC FUNCTIONS
280 
281   function transfer(address _to, uint256 _value) public returns (bool);
282   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
283   function approve(address _spender, uint256 _value) public returns (bool);
284   function balanceOf(address _owner) public constant returns (uint256);
285   function allowance(address _owner, address _spender) public constant returns (uint256);
286 
287   // FIELDS
288 
289   uint256 public totalSupply;
290 }
291 
292 
293 /// @title SafeMath
294 /// @dev Math operations with safety checks that throw on error.
295 library SafeMath {
296   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
297     uint256 c = a * b;
298     assert(a == 0 || c / a == b);
299     return c;
300   }
301 
302   function div(uint256 a, uint256 b) internal constant returns (uint256) {
303     // assert(b > 0); // Solidity automatically throws when dividing by 0
304     uint256 c = a / b;
305     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306     return c;
307   }
308 
309   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
310     assert(b <= a);
311     return a - b;
312   }
313 
314   function add(uint256 a, uint256 b) internal constant returns (uint256) {
315     uint256 c = a + b;
316     assert(c >= a);
317     return c;
318   }
319 }
320 
321 
322 /// @title Standard ERC20 token
323 /// @dev Implementation of the basic standard token.
324 contract StandardToken is ERC20 {
325   using SafeMath for uint256;
326 
327   // PUBLIC FUNCTIONS
328 
329   /// @dev Transfers tokens to a specified address.
330   /// @param _to The address which you want to transfer to.
331   /// @param _value The amount of tokens to be transferred.
332   /// @return A boolean that indicates if the operation was successful.
333   function transfer(address _to, uint256 _value) public returns (bool) {
334     require(_to != address(0));
335     require(_value <= balances[msg.sender]);
336     balances[msg.sender] = balances[msg.sender].sub(_value);
337     balances[_to] = balances[_to].add(_value);
338     Transfer(msg.sender, _to, _value);
339     return true;
340   }
341   
342   /// @dev Transfers tokens from one address to another.
343   /// @param _from The address which you want to send tokens from.
344   /// @param _to The address which you want to transfer to.
345   /// @param _value The amount of tokens to be transferred.
346   /// @return A boolean that indicates if the operation was successful.
347   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
348     require(_to != address(0));
349     require(_value <= balances[_from]);
350     require(_value <= allowances[_from][msg.sender]);
351     balances[_from] = balances[_from].sub(_value);
352     balances[_to] = balances[_to].add(_value);
353     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
354     Transfer(_from, _to, _value);
355     return true;
356   }
357 
358   /// @dev Approves the specified address to spend the specified amount of tokens on behalf of msg.sender.
359   /// Beware that changing an allowance with this method brings the risk that someone may use both the old
360   /// and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361   /// race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362   /// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363   /// @param _spender The address which will spend tokens.
364   /// @param _value The amount of tokens to be spent.
365   /// @return A boolean that indicates if the operation was successful.
366   function approve(address _spender, uint256 _value) public returns (bool) {
367     allowances[msg.sender][_spender] = _value;
368     Approval(msg.sender, _spender, _value);
369     return true;
370   }
371 
372   /// @dev Gets the balance of the specified address.
373   /// @param _owner The address to query the balance of.
374   /// @return An uint256 representing the amount owned by the specified address.
375   function balanceOf(address _owner) public constant returns (uint256) {
376     return balances[_owner];
377   }
378 
379   /// @dev Function to check the amount of tokens that an owner allowances to a spender.
380   /// @param _owner The address which owns tokens.
381   /// @param _spender The address which will spend tokens.
382   /// @return A uint256 specifying the amount of tokens still available for the spender.
383   function allowance(address _owner, address _spender) public constant returns (uint256) {
384     return allowances[_owner][_spender];
385   }
386 
387   // FIELDS
388 
389   mapping (address => uint256) balances;
390   mapping (address => mapping (address => uint256)) allowances;
391 }
392 
393 
394 contract ChannelApi {
395     function applyRuntimeUpdate(address from, address to, uint impressionsCount, uint fraudCount);
396 
397     function applyAuditorsCheckUpdate(address from, address to, uint fraudCountDelta);
398 }
399 
400 
401 contract ChannelContract {
402     using ChannelLibrary for ChannelLibrary.Data;
403     ChannelLibrary.Data data;
404 
405     event ChannelNewBalance(address token_address, address participant, uint balance, uint block_number);
406     event ChannelCloseRequested(address closing_address, uint block_number);
407     event ChannelClosed(address closing_address, uint block_number);
408     event TransferUpdated(address node_address, uint block_number);
409     event ChannelSettled(uint block_number);
410     event ChannelAudited(uint block_number);
411     event ChannelSecretRevealed(bytes32 secret, address receiver_address);
412 
413     modifier onlyManager() {
414         require(msg.sender == address(data.manager));
415         _;
416     }
417 
418     function ChannelContract(
419         address manager_address,
420         address sender,
421         address client,
422         address receiver,
423         uint close_timeout,
424         uint settle_timeout,
425         uint audit_timeout,
426         address auditor
427     )
428     {
429         //allow creation only from manager contract
430         require(msg.sender == manager_address);
431         require (sender != receiver);
432         require (client != receiver);
433         require (audit_timeout >= 0);
434         require (settle_timeout > 0);
435         require (close_timeout >= 0);
436 
437         data.sender = sender;
438         data.client = client;
439         data.receiver = receiver;
440         data.auditor = auditor;
441         data.manager = ChannelManagerContract(manager_address);
442         data.close_timeout = close_timeout;
443         data.settle_timeout = settle_timeout;
444         data.audit_timeout = audit_timeout;
445         data.opened = block.number;
446     }
447 
448     /// @notice Caller makes a deposit into their channel balance.
449     /// @param amount The amount caller wants to deposit.
450     /// @return True if deposit is successful.
451     function deposit(uint256 amount) returns (bool) {
452         bool success;
453         uint256 balance;
454 
455         (success, balance) = data.deposit(amount);
456 
457         if (success == true) {
458             ChannelNewBalance(data.manager.token(), msg.sender, balance, 0);
459         }
460 
461         return success;
462     }
463 
464     /// @notice Get the address and balance of both partners in a channel.
465     /// @return The address and balance pairs.
466     function addressAndBalance()
467         constant
468         returns (
469         address sender,
470         address receiver,
471         uint balance)
472     {
473         sender = data.sender;
474         receiver = data.receiver;
475         balance = data.balance;
476     }
477 
478     /// @notice Request to close the channel. 
479     function request_close () {
480         data.request_close();
481         ChannelCloseRequested(msg.sender, data.closed);
482     }
483 
484     /// @notice Close the channel. 
485     function close (
486         uint nonce,
487         uint256 completed_transfers,
488         bytes signature
489     ) {
490         data.close(address(this), nonce, completed_transfers, signature);
491         ChannelClosed(msg.sender, data.closed);
492     }
493 
494     /// @notice Settle the transfers and balances of the channel and pay out to
495     ///         each participant. Can only be called after the channel is closed
496     ///         and only after the number of blocks in the settlement timeout
497     ///         have passed.
498     function settle() {
499         data.settle();
500         ChannelSettled(data.settled);
501     }
502 
503     /// @notice Settle the transfers and balances of the channel and pay out to
504     ///         each participant. Can only be called after the channel is closed
505     ///         and only after the number of blocks in the settlement timeout
506     ///         have passed.
507     function audit(address auditor) onlyManager {
508         data.audit(auditor);
509         ChannelAudited(data.audited);
510     }
511 
512     function destroy() onlyManager {
513         require(data.settled > 0);
514         require(data.audited > 0 || block.number > data.closed + data.audit_timeout);
515         selfdestruct(0);
516     }
517 
518     function sender() constant returns (address) {
519         return data.sender;
520     }
521 
522     function receiver() constant returns (address) {
523         return data.receiver;
524     }
525 
526     function client() constant returns (address) {
527         return data.client;
528     }
529 
530     function auditor() constant returns (address) {
531         return data.auditor;
532     }
533 
534     function closeTimeout() constant returns (uint) {
535         return data.close_timeout;
536     }
537 
538     function settleTimeout() constant returns (uint) {
539         return data.settle_timeout;
540     }
541 
542     function auditTimeout() constant returns (uint) {
543         return data.audit_timeout;
544     }
545 
546     /// @return Returns the address of the manager.
547     function manager() constant returns (address) {
548         return data.manager;
549     }
550 
551     function balance() constant returns (uint) {
552         return data.balance;
553     }
554 
555     function nonce() constant returns (uint) {
556         return data.nonce;
557     }
558 
559     function completedTransfers() constant returns (uint) {
560         return data.completed_transfers;
561     }
562 
563     /// @notice Returns the block number for when the channel was opened.
564     /// @return The block number for when the channel was opened.
565     function opened() constant returns (uint) {
566         return data.opened;
567     }
568 
569     function closeRequested() constant returns (uint) {
570         return data.close_requested;
571     }
572 
573     function closed() constant returns (uint) {
574         return data.closed;
575     }
576 
577     function settled() constant returns (uint) {
578         return data.settled;
579     }
580 
581     function audited() constant returns (uint) {
582         return data.audited;
583     }
584 
585     function () { revert(); }
586 }
587 
588 
589 contract ChannelManagerContract {
590 
591     event ChannelNew(
592         address channel_address,
593         address indexed sender,
594         address client,
595         address indexed receiver,
596         uint close_timeout,
597         uint settle_timeout,
598         uint audit_timeout
599     );
600 
601     event ChannelDeleted(
602         address channel_address,
603         address indexed sender,
604         address indexed receiver
605     );
606 
607     StandardToken public token;
608     ChannelApi public channel_api;
609 
610     function ChannelManagerContract(address token_address, address channel_api_address) {
611         require(token_address != 0);
612         require(channel_api_address != 0);
613         token = StandardToken(token_address);
614         channel_api = ChannelApi(channel_api_address);
615     }
616 
617     /// @notice Create a new channel from msg.sender to receiver
618     /// @param receiver The address of the receiver
619     /// @param settle_timeout The settle timeout in blocks
620     /// @return The address of the newly created ChannelContract.
621     function newChannel(
622         address client, 
623         address receiver, 
624         uint close_timeout,
625         uint settle_timeout,
626         uint audit_timeout,
627         address auditor
628     )
629         returns (address)
630     {
631         address new_channel_address = new ChannelContract(
632             this,
633             msg.sender,
634             client,
635             receiver,
636             close_timeout,
637             settle_timeout,
638             audit_timeout,
639             auditor
640         );
641 
642         ChannelNew(
643             new_channel_address, 
644             msg.sender, 
645             client, 
646             receiver,
647             close_timeout,
648             settle_timeout,
649             audit_timeout
650         );
651 
652         return new_channel_address;
653     }
654 
655     function auditReport(address contract_address, uint total, uint fraud) {
656         ChannelContract ch = ChannelContract(contract_address);
657         require(ch.manager() == address(this));
658         address auditor = msg.sender;
659         ch.audit(auditor);
660         channel_api.applyRuntimeUpdate(ch.sender(), ch.receiver(), total, fraud);
661     }
662     
663     function destroyChannel(address channel_address) {
664         ChannelContract ch = ChannelContract(channel_address);
665         require(ch.manager() == address(this));
666         ChannelDeleted(channel_address,ch.sender(),ch.receiver());
667         ch.destroy();
668     }
669 }