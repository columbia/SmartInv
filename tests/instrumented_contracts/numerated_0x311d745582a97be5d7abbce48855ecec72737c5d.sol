1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /* The authentication manager details user accounts that have access to certain priviledges and keeps a permanent ledger of who has and has had these rights. */
34 contract AuthenticationManager {
35    
36     /* Map addresses to admins */
37     mapping (address => bool) adminAddresses;
38 
39     /* Map addresses to account readers */
40     mapping (address => bool) accountReaderAddresses;
41 
42     /* Map addresses to account minters */
43     mapping (address => bool) accountMinterAddresses;
44 
45     /* Details of all admins that have ever existed */
46     address[] adminAudit;
47 
48     /* Details of all account readers that have ever existed */
49     address[] accountReaderAudit;
50 
51     /* Details of all account minters that have ever existed */
52     address[] accountMinterAudit;
53 
54     /* Fired whenever an admin is added to the contract. */
55     event AdminAdded(address addedBy, address admin);
56 
57     /* Fired whenever an admin is removed from the contract. */
58     event AdminRemoved(address removedBy, address admin);
59 
60     /* Fired whenever an account-reader contract is added. */
61     event AccountReaderAdded(address addedBy, address account);
62 
63     /* Fired whenever an account-reader contract is removed. */
64     event AccountReaderRemoved(address removedBy, address account);
65 
66     /* Fired whenever an account-minter contract is added. */
67     event AccountMinterAdded(address addedBy, address account);
68 
69     /* Fired whenever an account-minter contract is removed. */
70     event AccountMinterRemoved(address removedBy, address account);
71 
72     /* When this contract is first setup we use the creator as the first admin */    
73     function AuthenticationManager() {
74         /* Set the first admin to be the person creating the contract */
75         adminAddresses[msg.sender] = true;
76         AdminAdded(0, msg.sender);
77         adminAudit.length++;
78         adminAudit[adminAudit.length - 1] = msg.sender;
79     }
80 
81     /* Gets whether or not the specified address is currently an admin */
82     function isCurrentAdmin(address _address) constant returns (bool) {
83         return adminAddresses[_address];
84     }
85 
86     /* Gets whether or not the specified address has ever been an admin */
87     function isCurrentOrPastAdmin(address _address) constant returns (bool) {
88         for (uint256 i = 0; i < adminAudit.length; i++)
89             if (adminAudit[i] == _address)
90                 return true;
91         return false;
92     }
93 
94     /* Gets whether or not the specified address is currently an account reader */
95     function isCurrentAccountReader(address _address) constant returns (bool) {
96         return accountReaderAddresses[_address];
97     }
98 
99     /* Gets whether or not the specified address has ever been an admin */
100     function isCurrentOrPastAccountReader(address _address) constant returns (bool) {
101         for (uint256 i = 0; i < accountReaderAudit.length; i++)
102             if (accountReaderAudit[i] == _address)
103                 return true;
104         return false;
105     }
106 
107     /* Gets whether or not the specified address is currently an account minter */
108     function isCurrentAccountMinter(address _address) constant returns (bool) {
109         return accountMinterAddresses[_address];
110     }
111 
112     /* Gets whether or not the specified address has ever been an admin */
113     function isCurrentOrPastAccountMinter(address _address) constant returns (bool) {
114         for (uint256 i = 0; i < accountMinterAudit.length; i++)
115             if (accountMinterAudit[i] == _address)
116                 return true;
117         return false;
118     }
119 
120     /* Adds a user to our list of admins */
121     function addAdmin(address _address) {
122         /* Ensure we're an admin */
123         if (!isCurrentAdmin(msg.sender))
124             throw;
125 
126         // Fail if this account is already admin
127         if (adminAddresses[_address])
128             throw;
129         
130         // Add the user
131         adminAddresses[_address] = true;
132         AdminAdded(msg.sender, _address);
133         adminAudit.length++;
134         adminAudit[adminAudit.length - 1] = _address;
135 
136     }
137 
138     /* Removes a user from our list of admins but keeps them in the history audit */
139     function removeAdmin(address _address) {
140         /* Ensure we're an admin */
141         if (!isCurrentAdmin(msg.sender))
142             throw;
143 
144         /* Don't allow removal of self */
145         if (_address == msg.sender)
146             throw;
147 
148         // Fail if this account is already non-admin
149         if (!adminAddresses[_address])
150             throw;
151 
152         /* Remove this admin user */
153         adminAddresses[_address] = false;
154         AdminRemoved(msg.sender, _address);
155     }
156 
157     /* Adds a user/contract to our list of account readers */
158     function addAccountReader(address _address) {
159         /* Ensure we're an admin */
160         if (!isCurrentAdmin(msg.sender))
161             throw;
162 
163         // Fail if this account is already in the list
164         if (accountReaderAddresses[_address])
165             throw;
166         
167         // Add the account reader
168         accountReaderAddresses[_address] = true;
169         AccountReaderAdded(msg.sender, _address);
170         accountReaderAudit.length++;
171         accountReaderAudit[accountReaderAudit.length - 1] = _address;
172     }
173 
174     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
175     function removeAccountReader(address _address) {
176         /* Ensure we're an admin */
177         if (!isCurrentAdmin(msg.sender))
178             throw;
179 
180         // Fail if this account is already not in the list
181         if (!accountReaderAddresses[_address])
182             throw;
183 
184         /* Remove this account reader */
185         accountReaderAddresses[_address] = false;
186         AccountReaderRemoved(msg.sender, _address);
187     }
188 
189     /* Add a contract to our list of account minters */
190     function addAccountMinter(address _address) {
191         /* Ensure we're an admin */
192         if (!isCurrentAdmin(msg.sender))
193             throw;
194 
195         // Fail if this account is already in the list
196         if (accountMinterAddresses[_address])
197             throw;
198         
199         // Add the minter
200         accountMinterAddresses[_address] = true;
201         AccountMinterAdded(msg.sender, _address);
202         accountMinterAudit.length++;
203         accountMinterAudit[accountMinterAudit.length - 1] = _address;
204     }
205 
206     /* Removes a user/contracts from our list of account readers but keeps them in the history audit */
207     function removeAccountMinter(address _address) {
208         /* Ensure we're an admin */
209         if (!isCurrentAdmin(msg.sender))
210             throw;
211 
212         // Fail if this account is already not in the list
213         if (!accountMinterAddresses[_address])
214             throw;
215 
216         /* Remove this minter account */
217         accountMinterAddresses[_address] = false;
218         AccountMinterRemoved(msg.sender, _address);
219     }
220 }
221 
222 // parse a raw bitcoin transaction byte array
223 library BTC {
224     // Convert a variable integer into something useful and return it and
225     // the index to after it.
226     function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {
227         // the first byte tells us how big the integer is
228         var ibit = uint8(txBytes[pos]);
229         pos += 1;  // skip ibit
230 
231         if (ibit < 0xfd) {
232             return (ibit, pos);
233         } else if (ibit == 0xfd) {
234             return (getBytesLE(txBytes, pos, 16), pos + 2);
235         } else if (ibit == 0xfe) {
236             return (getBytesLE(txBytes, pos, 32), pos + 4);
237         } else if (ibit == 0xff) {
238             return (getBytesLE(txBytes, pos, 64), pos + 8);
239         }
240     }
241     // convert little endian bytes to uint
242     function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {
243         if (bits == 8) {
244             return uint8(data[pos]);
245         } else if (bits == 16) {
246             return uint16(data[pos])
247                  + uint16(data[pos + 1]) * 2 ** 8;
248         } else if (bits == 32) {
249             return uint32(data[pos])
250                  + uint32(data[pos + 1]) * 2 ** 8
251                  + uint32(data[pos + 2]) * 2 ** 16
252                  + uint32(data[pos + 3]) * 2 ** 24;
253         } else if (bits == 64) {
254             return uint64(data[pos])
255                  + uint64(data[pos + 1]) * 2 ** 8
256                  + uint64(data[pos + 2]) * 2 ** 16
257                  + uint64(data[pos + 3]) * 2 ** 24
258                  + uint64(data[pos + 4]) * 2 ** 32
259                  + uint64(data[pos + 5]) * 2 ** 40
260                  + uint64(data[pos + 6]) * 2 ** 48
261                  + uint64(data[pos + 7]) * 2 ** 56;
262         }
263     }
264     // scan the full transaction bytes and return the first two output
265     // values (in satoshis) and addresses (in binary)
266     function getFirstTwoOutputs(bytes txBytes)
267              returns (uint, bytes20, uint, bytes20)
268     {
269         uint pos;
270         uint[] memory input_script_lens = new uint[](2);
271         uint[] memory output_script_lens = new uint[](2);
272         uint[] memory script_starts = new uint[](2);
273         uint[] memory output_values = new uint[](2);
274         bytes20[] memory output_addresses = new bytes20[](2);
275 
276         pos = 4;  // skip version
277 
278         (input_script_lens, pos) = scanInputs(txBytes, pos, 0);
279 
280         (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);
281 
282         for (uint i = 0; i < 2; i++) {
283             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
284             output_addresses[i] = pkhash;
285         }
286 
287         return (output_values[0], output_addresses[0],
288                 output_values[1], output_addresses[1]);
289     }
290     // Check whether `btcAddress` is in the transaction outputs *and*
291     // whether *at least* `value` has been sent to it.
292     function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)
293              returns (bool)
294     {
295         uint pos = 4;  // skip version
296         (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs
297 
298         // scan *all* the outputs and find where they are
299         var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);
300 
301         // look at each output and check whether it at least value to btcAddress
302         for (uint i = 0; i < output_values.length; i++) {
303             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
304             if (pkhash == btcAddress && output_values[i] >= value) {
305                 return true;
306             }
307         }
308     }
309     // scan the inputs and find the script lengths.
310     // return an array of script lengths and the end position
311     // of the inputs.
312     // takes a 'stop' argument which sets the maximum number of
313     // outputs to scan through. stop=0 => scan all.
314     function scanInputs(bytes txBytes, uint pos, uint stop)
315              returns (uint[], uint)
316     {
317         uint n_inputs;
318         uint halt;
319         uint script_len;
320 
321         (n_inputs, pos) = parseVarInt(txBytes, pos);
322 
323         if (stop == 0 || stop > n_inputs) {
324             halt = n_inputs;
325         } else {
326             halt = stop;
327         }
328 
329         uint[] memory script_lens = new uint[](halt);
330 
331         for (var i = 0; i < halt; i++) {
332             pos += 36;  // skip outpoint
333             (script_len, pos) = parseVarInt(txBytes, pos);
334             script_lens[i] = script_len;
335             pos += script_len + 4;  // skip sig_script, seq
336         }
337 
338         return (script_lens, pos);
339     }
340     // scan the outputs and find the values and script lengths.
341     // return array of values, array of script lengths and the
342     // end position of the outputs.
343     // takes a 'stop' argument which sets the maximum number of
344     // outputs to scan through. stop=0 => scan all.
345     function scanOutputs(bytes txBytes, uint pos, uint stop)
346              returns (uint[], uint[], uint[], uint)
347     {
348         uint n_outputs;
349         uint halt;
350         uint script_len;
351 
352         (n_outputs, pos) = parseVarInt(txBytes, pos);
353 
354         if (stop == 0 || stop > n_outputs) {
355             halt = n_outputs;
356         } else {
357             halt = stop;
358         }
359 
360         uint[] memory script_starts = new uint[](halt);
361         uint[] memory script_lens = new uint[](halt);
362         uint[] memory output_values = new uint[](halt);
363 
364         for (var i = 0; i < halt; i++) {
365             output_values[i] = getBytesLE(txBytes, pos, 64);
366             pos += 8;
367 
368             (script_len, pos) = parseVarInt(txBytes, pos);
369             script_starts[i] = pos;
370             script_lens[i] = script_len;
371             pos += script_len;
372         }
373 
374         return (output_values, script_starts, script_lens, pos);
375     }
376     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
377     function sliceBytes20(bytes data, uint start) returns (bytes20) {
378         uint160 slice = 0;
379         for (uint160 i = 0; i < 20; i++) {
380             slice += uint160(data[i + start]) << (8 * (19 - i));
381         }
382         return bytes20(slice);
383     }
384     // returns true if the bytes located in txBytes by pos and
385     // script_len represent a P2PKH script
386     function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {
387         return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script
388             && (txBytes[pos] == 0x76)       // OP_DUP
389             && (txBytes[pos + 1] == 0xa9)   // OP_HASH160
390             && (txBytes[pos + 2] == 0x14)   // bytes to push
391             && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY
392             && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG
393     }
394     // returns true if the bytes located in txBytes by pos and
395     // script_len represent a P2SH script
396     function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {
397         return (script_len == 23)           // 20 byte scripthash + 3 bytes of script
398             && (txBytes[pos + 0] == 0xa9)   // OP_HASH160
399             && (txBytes[pos + 1] == 0x14)   // bytes to push
400             && (txBytes[pos + 22] == 0x87); // OP_EQUAL
401     }
402     // Get the pubkeyhash / scripthash from an output script. Assumes
403     // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.
404     // Returns the pubkeyhash/ scripthash, or zero if unknown output.
405     function parseOutputScript(bytes txBytes, uint pos, uint script_len)
406              returns (bytes20)
407     {
408         if (isP2PKH(txBytes, pos, script_len)) {
409             return sliceBytes20(txBytes, pos + 3);
410         } else if (isP2SH(txBytes, pos, script_len)) {
411             return sliceBytes20(txBytes, pos + 2);
412         } else {
413             return;
414         }
415     }
416 }
417 
418 contract LockinManager {
419     using SafeMath for uint256;
420 
421     /*Defines the structure for a lock*/
422     struct Lock {
423         uint256 amount;
424         uint256 unlockDate;
425         uint256 lockedFor;
426     }
427     
428     /*Object of Lock*/    
429     Lock lock;
430 
431     /*Value of default lock days*/
432     uint256 defaultAllowedLock = 7;
433 
434     /* mapping of list of locked address with array of locks for a particular address */
435     mapping (address => Lock[]) public lockedAddresses;
436 
437     /* mapping of valid contracts with their lockin timestamp */
438     mapping (address => uint256) public allowedContracts;
439 
440     /* list of locked days mapped with their locked timestamp*/
441     mapping (uint => uint256) public allowedLocks;
442 
443     /* Defines our interface to the token contract */
444     Token token;
445 
446     /* Defines the admin contract we interface with for credentails. */
447     AuthenticationManager authenticationManager;
448 
449      /* Fired whenever lock day is added by the admin. */
450     event LockedDayAdded(address _admin, uint256 _daysLocked, uint256 timestamp);
451 
452      /* Fired whenever lock day is removed by the admin. */
453     event LockedDayRemoved(address _admin, uint256 _daysLocked, uint256 timestamp);
454 
455      /* Fired whenever valid contract is added by the admin. */
456     event ValidContractAdded(address _admin, address _validAddress, uint256 timestamp);
457 
458      /* Fired whenever valid contract is removed by the admin. */
459     event ValidContractRemoved(address _admin, address _validAddress, uint256 timestamp);
460 
461     /* Create a new instance of this fund with links to other contracts that are required. */
462     function LockinManager(address _token, address _authenticationManager) {
463       
464         /* Setup access to our other contracts and validate their versions */
465         token  = Token(_token);
466         authenticationManager = AuthenticationManager(_authenticationManager);
467     }
468    
469     /* This modifier allows a method to only be called by current admins */
470     modifier adminOnly {
471         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
472         _;
473     }
474 
475     /* This modifier allows a method to only be called by token contract */
476     modifier validContractOnly {
477         require(allowedContracts[msg.sender] != 0);
478 
479         _;
480     }
481 
482     /* Gets the length of locked values for an account */
483     function getLocks(address _owner) validContractOnly constant returns (uint256) {
484         return lockedAddresses[_owner].length;
485     }
486 
487     function getLock(address _owner, uint256 count) validContractOnly returns(uint256 amount, uint256 unlockDate, uint256 lockedFor) {
488         amount     = lockedAddresses[_owner][count].amount;
489         unlockDate = lockedAddresses[_owner][count].unlockDate;
490         lockedFor   = lockedAddresses[_owner][count].lockedFor;
491     }
492     
493     /* Gets amount for which an address is locked with locked index */
494     function getLocksAmount(address _owner, uint256 count) validContractOnly returns(uint256 amount) {        
495         amount = lockedAddresses[_owner][count].amount;
496     }
497 
498     /* Gets unlocked timestamp for which an address is locked with locked index */
499     function getLocksUnlockDate(address _owner, uint256 count) validContractOnly returns(uint256 unlockDate) {
500         unlockDate = lockedAddresses[_owner][count].unlockDate;
501     }
502 
503     /* Gets days for which an address is locked with locked index */
504     function getLocksLockedFor(address _owner, uint256 count) validContractOnly returns(uint256 lockedFor) {
505         lockedFor = lockedAddresses[_owner][count].lockedFor;
506     }
507 
508     /* Locks tokens for an address for the default number of days */
509     function defaultLockin(address _address, uint256 _value) validContractOnly
510     {
511         lockIt(_address, _value, defaultAllowedLock);
512     }
513 
514     /* locks tokens for sender for n days*/
515     function lockForDays(uint256 _value, uint256 _days) 
516     {
517         require( ! ifInAllowedLocks(_days));        
518 
519         require(token.availableBalance(msg.sender) >= _value);
520         
521         lockIt(msg.sender, _value, _days);     
522     }
523 
524     function lockIt(address _address, uint256 _value, uint256 _days) internal {
525 
526         // expiry will be calculated as 24 * 60 * 60
527         uint256 _expiry = now + _days.mul(86400);
528         lockedAddresses[_address].push(Lock(_value, _expiry, _days));        
529     }
530 
531     /* check if input day is present in locked days */
532     function ifInAllowedLocks(uint256 _days) constant returns(bool) {
533         return allowedLocks[_days] == 0;
534     }
535 
536     /* Adds a day to our list of allowedLocks */
537     function addAllowedLock(uint _day) adminOnly {
538 
539         // Fail if day is already present in locked days
540         if (allowedLocks[_day] != 0)
541             throw;
542         
543         // Add day in locked days 
544         allowedLocks[_day] = now;
545         LockedDayAdded(msg.sender, _day, now);
546     }
547 
548     /* Remove allowed Lock */
549     function removeAllowedLock(uint _day) adminOnly {
550 
551         // Fail if day doesnot exist in allowedLocks
552         if ( allowedLocks[_day] ==  0)
553             throw;
554 
555         /* Remove locked day  */
556         allowedLocks[_day] = 0;
557         LockedDayRemoved(msg.sender, _day, now);
558     }
559 
560     /* Adds a address to our list of allowedContracts */
561     function addValidContract(address _address) adminOnly {
562 
563         // Fail if address is already present in valid contracts
564         if (allowedContracts[_address] != 0)
565             throw;
566         
567         // add an address in allowedContracts
568         allowedContracts[_address] = now;
569 
570         ValidContractAdded(msg.sender, _address, now);
571     }
572 
573     /* Removes allowed contract from the list of allowedContracts */
574     function removeValidContract(address _address) adminOnly {
575 
576         // Fail if address doesnot exist in allowedContracts
577         if ( allowedContracts[_address] ==  0)
578             throw;
579 
580         /* Remove allowed contract from allowedContracts  */
581         allowedContracts[_address] = 0;
582 
583         ValidContractRemoved(msg.sender, _address, now);
584     }
585 
586     /* Set default allowed lock */
587     function setDefaultAllowedLock(uint _days) adminOnly {
588         defaultAllowedLock = _days;
589     }
590 }
591 
592 /* The Token itself is a simple extension of the ERC20 that allows for granting other Token contracts special rights to act on behalf of all transfers. */
593 contract Token {
594     using SafeMath for uint256;
595 
596     /* Map all our our balances for issued tokens */
597     mapping (address => uint256) public balances;
598 
599     /* Map between users and their approval addresses and amounts */
600     mapping(address => mapping (address => uint256)) allowed;
601 
602     /* List of all token holders */
603     address[] allTokenHolders;
604 
605     /* The name of the contract */
606     string public name;
607 
608     /* The symbol for the contract */
609     string public symbol;
610 
611     /* How many DPs are in use in this contract */
612     uint8 public decimals;
613 
614     /* Defines the current supply of the token in its own units */
615     uint256 totalSupplyAmount = 0;
616     
617     /* Defines the address of the Refund Manager contract which is the only contract to destroy tokens. */
618     address public refundManagerContractAddress;
619 
620     /* Defines the admin contract we interface with for credentails. */
621     AuthenticationManager authenticationManager;
622 
623     /* Instance of lockin contract */
624     LockinManager lockinManager;
625 
626     /** @dev Returns the balance that a given address has available for transfer.
627       * @param _owner The address of the token owner.
628       */
629     function availableBalance(address _owner) constant returns(uint256) {
630         
631         uint256 length =  lockinManager.getLocks(_owner);
632     
633         uint256 lockedValue = 0;
634         
635         for(uint256 i = 0; i < length; i++) {
636 
637             if(lockinManager.getLocksUnlockDate(_owner, i) > now) {
638                 uint256 _value = lockinManager.getLocksAmount(_owner, i);    
639                 lockedValue = lockedValue.add(_value);                
640             }
641         }
642         
643         return balances[_owner].sub(lockedValue);
644     }
645 
646     /* Fired when the fund is eventually closed. */
647     event FundClosed();
648     
649     /* Our transfer event to fire whenever we shift SMRT around */
650     event Transfer(address indexed from, address indexed to, uint256 value);
651     
652     /* Our approval event when one user approves another to control */
653     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
654 
655     /* Create a new instance of this fund with links to other contracts that are required. */
656     function Token(address _authenticationManagerAddress) {
657         // Setup defaults
658         name = "PIE (Authorito Capital)";
659         symbol = "PIE";
660         decimals = 18;
661 
662         /* Setup access to our other contracts */
663         authenticationManager = AuthenticationManager(_authenticationManagerAddress);        
664     }
665 
666     modifier onlyPayloadSize(uint numwords) {
667         assert(msg.data.length == numwords * 32 + 4);
668         _;
669     }
670 
671     /* This modifier allows a method to only be called by account readers */
672     modifier accountReaderOnly {
673         if (!authenticationManager.isCurrentAccountReader(msg.sender)) throw;
674         _;
675     }
676 
677     /* This modifier allows a method to only be called by current admins */
678     modifier adminOnly {
679         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
680         _;
681     }   
682     
683     function setLockinManagerAddress(address _lockinManager) adminOnly {
684         lockinManager = LockinManager(_lockinManager);
685     }
686 
687     function setRefundManagerContract(address _refundManagerContractAddress) adminOnly {
688         refundManagerContractAddress = _refundManagerContractAddress;
689     }
690 
691     /* Transfer funds between two addresses that are not the current msg.sender - this requires approval to have been set separately and follows standard ERC20 guidelines */
692     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3) returns (bool) {
693         
694         if (availableBalance(_from) >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to].add(_amount) > balances[_to]) {
695             bool isNew = balances[_to] == 0;
696             balances[_from] = balances[_from].sub(_amount);
697             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
698             balances[_to] = balances[_to].add(_amount);
699             if (isNew)
700                 tokenOwnerAdd(_to);
701             if (balances[_from] == 0)
702                 tokenOwnerRemove(_from);
703             Transfer(_from, _to, _amount);
704             return true;
705         }
706         return false;
707     }
708 
709     /* Returns the total number of holders of this currency. */
710     function tokenHolderCount() accountReaderOnly constant returns (uint256) {
711         return allTokenHolders.length;
712     }
713 
714     /* Gets the token holder at the specified index. */
715     function tokenHolder(uint256 _index) accountReaderOnly constant returns (address) {
716         return allTokenHolders[_index];
717     }
718  
719     /* Adds an approval for the specified account to spend money of the message sender up to the defined limit */
720     function approve(address _spender, uint256 _amount) onlyPayloadSize(2) returns (bool success) {
721         allowed[msg.sender][_spender] = _amount;
722         Approval(msg.sender, _spender, _amount);
723         return true;
724     }
725 
726     /* Gets the current allowance that has been approved for the specified spender of the owner address */
727     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
728         return allowed[_owner][_spender];
729     }
730 
731     /* Gets the total supply available of this token */
732     function totalSupply() constant returns (uint256) {
733         return totalSupplyAmount;
734     }
735 
736     /* Gets the balance of a specified account */
737     function balanceOf(address _owner) constant returns (uint256 balance) {
738         return balances[_owner];
739     }
740 
741     /* Transfer the balance from owner's account to another account */
742     function transfer(address _to, uint256 _amount) onlyPayloadSize(2) returns (bool) {
743                 
744         /* Check if sender has balance and for overflows */
745         if (availableBalance(msg.sender) < _amount || balances[_to].add(_amount) < balances[_to])
746             return false;
747 
748         /* Do a check to see if they are new, if so we'll want to add it to our array */
749         bool isRecipientNew = balances[_to] == 0;
750 
751         /* Add and subtract new balances */
752         balances[msg.sender] = balances[msg.sender].sub(_amount);
753         balances[_to] = balances[_to].add(_amount);
754         
755         /* Consolidate arrays if they are new or if sender now has empty balance */
756         if (isRecipientNew)
757             tokenOwnerAdd(_to);
758         if (balances[msg.sender] <= 0)
759             tokenOwnerRemove(msg.sender);
760 
761         /* Fire notification event */
762         Transfer(msg.sender, _to, _amount);
763         return true; 
764     }
765 
766     /* If the specified address is not in our owner list, add them - this can be called by descendents to ensure the database is kept up to date. */
767     function tokenOwnerAdd(address _addr) internal {
768         /* First check if they already exist */
769         uint256 tokenHolderCount = allTokenHolders.length;
770         for (uint256 i = 0; i < tokenHolderCount; i++)
771             if (allTokenHolders[i] == _addr)
772                 /* Already found so we can abort now */
773                 return;
774         
775         /* They don't seem to exist, so let's add them */
776         allTokenHolders.length++;
777         allTokenHolders[allTokenHolders.length - 1] = _addr;
778     }
779 
780     /* If the specified address is in our owner list, remove them - this can be called by descendents to ensure the database is kept up to date. */
781     function tokenOwnerRemove(address _addr) internal {
782         /* Find out where in our array they are */
783         uint256 tokenHolderCount = allTokenHolders.length;
784         uint256 foundIndex = 0;
785         bool found = false;
786         uint256 i;
787         for (i = 0; i < tokenHolderCount; i++)
788             if (allTokenHolders[i] == _addr) {
789                 foundIndex = i;
790                 found = true;
791                 break;
792             }
793         
794         /* If we didn't find them just return */
795         if (!found)
796             return;
797         
798         /* We now need to shuffle down the array */
799         for (i = foundIndex; i < tokenHolderCount - 1; i++)
800             allTokenHolders[i] = allTokenHolders[i + 1];
801         allTokenHolders.length--;
802     }
803 
804     /* Mint new tokens - this can only be done by special callers (i.e. the ICO management) during the ICO phase. */
805     function mintTokens(address _address, uint256 _amount) onlyPayloadSize(2) {
806 
807         /* if it is comming from account minter */
808         if ( ! authenticationManager.isCurrentAccountMinter(msg.sender))
809             throw;
810 
811         /* Mint the tokens for the new address*/
812         bool isNew = balances[_address] == 0;
813         totalSupplyAmount = totalSupplyAmount.add(_amount);
814         balances[_address] = balances[_address].add(_amount);
815 
816         lockinManager.defaultLockin(_address, _amount);        
817 
818         if (isNew)
819             tokenOwnerAdd(_address);
820         Transfer(0, _address, _amount);
821     }
822 
823     /** This will destroy the tokens of the investor and called by sale contract only at the time of refund. */
824     function destroyTokens(address _investor, uint256 tokenCount) returns (bool) {
825         
826         /* Can only be called by refund manager, also refund manager address must not be empty */
827         if ( refundManagerContractAddress  == 0x0 || msg.sender != refundManagerContractAddress)
828             throw;
829 
830         uint256 balance = availableBalance(_investor);
831 
832         if (balance < tokenCount) {
833             return false;
834         }
835 
836         balances[_investor] -= tokenCount;
837         totalSupplyAmount -= tokenCount;
838 
839         if(balances[_investor] <= 0)
840             tokenOwnerRemove(_investor);
841 
842         return true;
843     }
844 }
845 
846 contract Tokensale {
847     using SafeMath for uint256;
848     
849     /* Defines whether or not the  Token Contract address has yet been set.  */
850     bool public tokenContractDefined = false;
851     
852     /* Defines whether or not we are in the Sale phase */
853     bool public salePhase = true;
854 
855     /* Defines the sale price of ethereum during Sale */
856     uint256 public ethereumSaleRate = 700; // The number of tokens to be minted for every ETH
857 
858     /* Defines the sale price of bitcoin during Sale */
859     uint256 public bitcoinSaleRate = 14000; // The number of tokens to be minted for every BTC
860 
861     /* Defines our interface to the  Token contract. */
862     Token token;
863 
864     /* Defines the admin contract we interface with for credentails. */
865     AuthenticationManager authenticationManager;
866 
867     /* Claimed Transactions from btc relay. */
868     mapping(uint256 => bool) public transactionsClaimed;
869 
870     /* Defines the minimum ethereum to invest during Sale */
871     uint256 public minimunEthereumToInvest = 0;
872 
873     /* Defines the minimum btc to invest during Sale */
874     uint256 public minimunBTCToInvest = 0;
875 
876     /* Defines our event fired when the Sale is closed */
877     event SaleClosed();
878 
879     /* Defines our event fired when the Sale is reopened */
880     event SaleStarted();
881 
882     /* Ethereum Rate updated by the admin. */
883     event EthereumRateUpdated(uint256 rate, uint256 timestamp);
884 
885     /* Bitcoin Rate updated by the admin. */
886     event BitcoinRateUpdated(uint256 rate, uint256 timestamp);
887 
888     /* Minimun Ethereum Investment updated by the admin. */
889     event MinimumEthereumInvestmentUpdated(uint256 _value, uint256 timestamp);
890 
891     /* Minimun Bitcoin Investment updated by the admin. */
892     event MinimumBitcoinInvestmentUpdated(uint256 _value, uint256 timestamp);
893 
894     /* Ensures that once the Sale is over this contract cannot be used until the point it is destructed. */
895     modifier onlyDuringSale {
896 
897         if (!tokenContractDefined || (!salePhase)) throw;
898         _;
899     }
900 
901     /* This modifier allows a method to only be called by current admins */
902     modifier adminOnly {
903         if (!authenticationManager.isCurrentAdmin(msg.sender)) throw;
904         _;
905     }
906 
907     /* Create the  token sale and define the address of the main authentication Manager address. */
908     function Tokensale(address _authenticationManagerAddress) {        
909                 
910         /* Setup access to our other contracts */
911         authenticationManager = AuthenticationManager(_authenticationManagerAddress);
912     }
913 
914     /* Set the Token contract address as a one-time operation.  This happens after all the contracts are created and no
915        other functionality can be used until this is set. */
916     function setTokenContractAddress(address _tokenContractAddress) adminOnly {
917         /* This can only happen once in the lifetime of this contract */
918         if (tokenContractDefined)
919             throw;
920 
921         /* Setup access to our other contracts */
922         token = Token(_tokenContractAddress);
923 
924         tokenContractDefined = true;
925     }
926 
927     /* Run this function when transaction has been verified by the btc relay */
928     function processBTCTransaction(bytes txn, uint256 _txHash, address ethereumAddress, bytes20 bitcoinAddress) adminOnly returns (uint256)
929     {
930         /* Transaction is already claimed */
931         if(transactionsClaimed[_txHash] != false) 
932             throw;
933 
934         var (outputValue1, outputAddress1, outputValue2, outputAddress2) = BTC.getFirstTwoOutputs(txn);
935 
936         if(BTC.checkValueSent(txn, bitcoinAddress, 1))
937         {
938             require(outputValue1 >= minimunBTCToInvest);
939 
940              //multiply by exchange rate
941             uint256 tokensPurchased = outputValue1 * bitcoinSaleRate * (10**10);  
942 
943             token.mintTokens(ethereumAddress, tokensPurchased);
944 
945             transactionsClaimed[_txHash] = true;
946         }
947         else
948         {
949             // value was not sent to this btc address
950             throw;
951         }
952     }
953 
954     function btcTransactionClaimed(uint256 _txHash) returns(bool) {
955         return transactionsClaimed[_txHash];
956     }   
957     
958     // fallback function can be used to buy tokens
959     function () payable {
960     
961         buyTokens(msg.sender);
962     
963     }
964 
965     /* Handle receiving ether in Sale phase - we work out how much the user has bought, allocate a suitable balance and send their change */
966     function buyTokens(address beneficiary) onlyDuringSale payable {
967 
968         require(beneficiary != 0x0);
969         require(validPurchase());
970         
971         uint256 weiAmount = msg.value;
972 
973         uint256 tokensPurchased = weiAmount.mul(ethereumSaleRate);
974         
975         /* Increase their new balance if they actually purchased any */
976         if (tokensPurchased > 0)
977         {
978             token.mintTokens(beneficiary, tokensPurchased);
979         }
980     }
981 
982     // @return true if the transaction can buy tokens
983     function validPurchase() internal constant returns (bool) {
984 
985         bool nonZeroPurchase = ( msg.value != 0 && msg.value >= minimunEthereumToInvest);
986         return nonZeroPurchase;
987     }
988 
989     /* Rate on which */
990     function setEthereumRate(uint256 _rate) adminOnly {
991 
992         ethereumSaleRate = _rate;
993 
994         /* Audit this */
995         EthereumRateUpdated(ethereumSaleRate, now);
996     }
997 
998       /* Rate on which */
999     function setBitcoinRate(uint256 _rate) adminOnly {
1000 
1001         bitcoinSaleRate = _rate;
1002 
1003         /* Audit this */
1004         BitcoinRateUpdated(bitcoinSaleRate, now);
1005     }    
1006 
1007         /* update min Ethereum to invest */
1008     function setMinimumEthereumToInvest(uint256 _value) adminOnly {
1009 
1010         minimunEthereumToInvest = _value;
1011 
1012         /* Audit this */
1013         MinimumEthereumInvestmentUpdated(_value, now);
1014     }    
1015 
1016           /* update minimum Bitcoin to invest */
1017     function setMinimumBitcoinToInvest(uint256 _value) adminOnly {
1018 
1019         minimunBTCToInvest = _value;
1020 
1021         /* Audit this */
1022         MinimumBitcoinInvestmentUpdated(_value, now);
1023     }
1024 
1025       /* Close the Sale phase and transition to execution phase */
1026     function close() adminOnly onlyDuringSale {
1027 
1028         // Close the Sale
1029         salePhase = false;
1030         SaleClosed();
1031 
1032         // Withdraw funds to the caller
1033         if (!msg.sender.send(this.balance))
1034             throw;
1035     }
1036 
1037     /* Open the sale phase*/
1038     function openSale() adminOnly {        
1039         salePhase = true;
1040         SaleStarted();
1041     }
1042 }