1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50     constructor() public
51     {
52        owner = msg.sender;
53     }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104 
105     // SafeMath.sub will throw if there is not enough balance.
106     balances[msg.sender] = balances[msg.sender].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     emit Transfer(msg.sender, _to, _value);
109     return true;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public constant returns (uint256 balance) {
118     return balances[_owner];
119   }
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public constant returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implementation of the basic standard token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is ERC20, BasicToken {
142 
143   mapping (address => mapping (address => uint256)) allowed;
144 
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint256 the amount of tokens to be transferred
151    */
152   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153     require(_to != address(0));
154 
155     uint256 _allowance = allowed[_from][msg.sender];
156 
157     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
158     // require (_value <= _allowance);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = _allowance.sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     emit Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval (address _spender, uint _addedValue) public
200     returns (bool success) {
201     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
202     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 
206   function decreaseApproval (address _spender, uint _subtractedValue) public
207     returns (bool success) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 }
218 
219 
220 /**
221  * @title Burnable Token
222  * @dev Token that can be irreversibly burned (destroyed).
223  */
224 contract BurnableToken is StandardToken {
225 
226     event Burn(address indexed burner, uint256 value);
227 
228     /**
229      * @dev Burns a specific amount of tokens.
230      * @param _value The amount of token to be burned.
231      */
232     function burn(uint256 _value) public {
233         require(_value > 0);
234         require(_value <= balances[msg.sender]);
235         // no need to require value <= totalSupply, since that would imply the
236         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238         address burner = msg.sender;
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply = totalSupply.sub(_value);
241         emit Burn(burner, _value);
242     }
243 }
244 
245 contract BaconCoin is BurnableToken, Ownable {
246 
247     string public constant name = "BaconCoin";
248     string public constant symbol = "BAK";
249     uint public constant decimals = 8;
250     uint256 public constant initialSupply = 2200000000 * (10 ** uint256(decimals));
251 
252     // use Nonce for stop replay-attack
253     struct Wallet {
254         uint256 balance;
255         uint256 tokenBalance;
256         mapping(address => bool) authed;   
257         uint64 seedNonce;
258         uint64 withdrawNonce;
259     }
260     
261     address[] public admins;
262 
263     mapping(bytes32 => Wallet) private wallets;
264     mapping(address => bool) private isAdmin;
265 
266     uint256 private agentBalance;
267     uint256 private agentTokenBalance;
268     
269     modifier onlyAdmin {
270         require(isAdmin[msg.sender]);
271         _;
272     }
273 
274     modifier onlyRootAdmin {
275         require(msg.sender == admins[0]);
276         _;
277     }
278 
279     event Auth(
280         bytes32 indexed walletID,
281         address indexed agent
282     );
283 
284     event Withdraw(
285         bytes32 indexed walletID,
286         uint256 indexed nonce,
287         uint256 indexed value,
288         address recipient
289     );
290     
291     event Deposit(
292         bytes32 indexed walletID,
293         address indexed sender,
294         uint256 indexed value
295     );
296 
297     event Seed(
298         bytes32 indexed walletID,
299         uint256 indexed nonce,
300         uint256 indexed value
301     );
302 
303     event Gain(
304         bytes32 indexed walletID,
305         uint256 indexed requestID,
306         uint256 indexed value
307     );
308 
309     event DepositToken(
310         bytes32 indexed walletID,
311         address indexed sender, 
312         uint256 indexed amount
313     );
314     
315     event WithdrawToken(
316         bytes32 indexed walletID,
317         uint256 indexed nonce,
318         uint256 indexed amount,
319         address recipient
320     );
321     
322     event SeedToken(
323         bytes32 indexed walletID,
324         uint256 indexed nonce,
325         uint256 indexed amount
326     );
327 
328     event GainToken(
329         bytes32 indexed walletID,
330         uint256 indexed requestID,
331         uint256 indexed amount
332     );
333     
334     constructor() public
335     {
336         totalSupply = initialSupply;
337         balances[msg.sender] = initialSupply; 
338 
339         admins.push(msg.sender);
340         isAdmin[msg.sender] = true;
341     }
342 
343     function auth(
344         bytes32[] walletIDs,
345         bytes32[] nameIDs,
346         address[] agents,
347         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
348     {
349         require(
350             walletIDs.length == nameIDs.length &&
351             walletIDs.length == agents.length &&
352             walletIDs.length == v.length &&
353             walletIDs.length == r.length &&
354             walletIDs.length == s.length
355         );
356 
357         for (uint i = 0; i < walletIDs.length; i++) {
358             bytes32 walletID = walletIDs[i];
359             address agent = agents[i];
360 
361             address signer = getMessageSigner(
362                 getAuthDigest(walletID, agent), v[i], r[i], s[i]
363             );
364 
365             Wallet storage wallet = wallets[walletID];
366 
367             if (wallet.authed[signer] || walletID == getWalletDigest(nameIDs[i], signer)) {
368                 wallet.authed[agent] = true;
369 
370                 emit Auth(walletID, agent);
371             }
372         }
373     }
374 
375     function deposit( bytes32 walletID) payable public
376     {
377         wallets[walletID].balance += msg.value;
378 
379         emit Deposit(walletID, msg.sender, msg.value);
380     }
381 
382     function withdraw(
383         bytes32[] walletIDs,
384         address[] receivers,
385         uint256[] values,
386         uint64[] nonces,
387         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
388     {
389         require(
390             walletIDs.length == receivers.length &&
391             walletIDs.length == values.length &&
392             walletIDs.length == nonces.length &&
393             walletIDs.length == v.length &&
394             walletIDs.length == r.length &&
395             walletIDs.length == s.length
396         );
397 
398         for (uint i = 0; i < walletIDs.length; i++) {
399             bytes32 walletID = walletIDs[i];
400             address receiver = receivers[i];
401             uint256 value = values[i];
402             uint64 nonce = nonces[i];
403 
404             address signer = getMessageSigner(
405                 getWithdrawDigest(walletID, receiver, value, nonce), v[i], r[i], s[i]
406             );
407 
408             Wallet storage wallet = wallets[walletID];
409 
410             if (
411                 wallet.withdrawNonce < nonce &&
412                 wallet.balance >= value &&
413                 wallet.authed[signer] &&
414                 receiver.send(value)
415             ) {
416                 wallet.withdrawNonce = nonce;
417                 wallet.balance -= value;
418 
419                 emit Withdraw(walletID, nonce, value, receiver);
420             }
421         }
422     }
423 
424     function seed(
425         bytes32[] walletIDs,
426         uint256[] values,
427         uint64[] nonces,
428         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
429     {
430         require(
431             walletIDs.length == values.length &&
432             walletIDs.length == nonces.length &&
433             walletIDs.length == v.length &&
434             walletIDs.length == r.length &&
435             walletIDs.length == s.length
436         );
437 
438         uint256 addition = 0;
439 
440         for (uint i = 0; i < walletIDs.length; i++) {
441             bytes32 walletID = walletIDs[i];
442             uint256 value = values[i];
443             uint64 nonce = nonces[i];
444 
445             address signer = getMessageSigner(
446                 getSeedDigest(walletID, value, nonce), v[i], r[i], s[i]
447             );
448 
449             Wallet storage wallet = wallets[walletID];
450 
451             if (
452                 wallet.seedNonce < nonce &&
453                 wallet.balance >= value &&
454                 wallet.authed[signer]
455             ) {
456                 wallet.seedNonce = nonce;
457                 wallet.balance -= value;
458 
459                 emit Seed(walletID, nonce, value);
460 
461                 addition += value;
462             }
463         }
464 
465         agentBalance += addition;
466     }
467 
468 
469     function gain(
470         bytes32[] walletIDs,
471         uint256[] recordIDs,
472         uint256[] values) onlyAdmin public
473     {
474         require(
475             walletIDs.length == recordIDs.length &&
476             walletIDs.length == values.length
477         );
478 
479         uint256 remaining = agentBalance;
480 
481         for (uint i = 0; i < walletIDs.length; i++) {
482             bytes32 walletID = walletIDs[i];
483             uint256 value = values[i];
484 
485             require(value <= remaining);
486 
487             wallets[walletID].balance += value;
488             remaining -= value;
489 
490             emit Gain(walletID, recordIDs[i], value);
491         }
492 
493         agentBalance = remaining;
494     }
495 
496     function getMessageSigner(
497         bytes32 message,
498         uint8 v, bytes32 r, bytes32 s) public pure returns(address)
499     {
500         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
501         bytes32 prefixedMessage = keccak256(
502             abi.encodePacked(prefix, message)
503         );
504         return ecrecover(prefixedMessage, v, r, s);
505     }
506 
507     function getNameDigest(
508         string myname) public pure returns (bytes32)
509     {
510         return keccak256(abi.encodePacked(myname));
511     }
512 
513     function getWalletDigest(
514         bytes32 myname,
515         address root) public pure returns (bytes32)
516     {
517         return keccak256(abi.encodePacked(
518             myname, root
519         ));
520     }
521 
522     function getAuthDigest(
523         bytes32 walletID,
524         address agent) public pure returns (bytes32)
525     {
526         return keccak256(abi.encodePacked(
527             walletID, agent
528         ));
529     }
530 
531     function getSeedDigest(
532         bytes32 walletID,
533         uint256 value,
534         uint64 nonce) public pure returns (bytes32)
535     {
536         return keccak256(abi.encodePacked(
537             walletID, value, nonce
538         ));
539     }
540 
541     function getWithdrawDigest(
542         bytes32 walletID,
543         address receiver,
544         uint256 value,
545         uint64 nonce) public pure returns (bytes32)
546     {
547         return keccak256(abi.encodePacked(
548             walletID, receiver, value, nonce
549         ));
550     }
551 
552     function getSeedNonce(
553         bytes32 walletID) public view returns (uint256)
554     {
555         return wallets[walletID].seedNonce + 1;
556     }
557 
558     function getWithdrawNonce(
559         bytes32 walletID) public view returns (uint256)
560     {
561         return wallets[walletID].withdrawNonce + 1;
562     }
563 
564     function getAuthStatus(
565         bytes32 walletID,
566         address member) public view returns (bool)
567     {
568         return wallets[walletID].authed[member];
569     }
570 
571     function getBalance(
572         bytes32 walletID) public view returns (uint256)
573     {
574         return wallets[walletID].balance;
575     }
576     
577     function gettokenBalance(
578         bytes32 walletID) public view returns (uint256)
579     {
580         return wallets[walletID].tokenBalance;
581     }
582 
583     function getagentBalance() public view returns (uint256)
584     {
585       return agentBalance;
586     }
587 
588     function getagentTokenBalance() public view returns (uint256)
589     {
590       return agentTokenBalance;
591     }
592     
593     function removeAdmin(
594         address oldAdmin) onlyRootAdmin public
595     {
596         require(isAdmin[oldAdmin] && admins[0] != oldAdmin);
597 
598         bool found = false;
599         for (uint i = 1; i < admins.length - 1; i++) {
600             if (!found && admins[i] == oldAdmin) {
601                 found = true;
602             }
603             if (found) {
604                 admins[i] = admins[i + 1];
605             }
606         }
607 
608         admins.length--;
609         isAdmin[oldAdmin] = false;
610     }
611 
612     function changeRootAdmin(
613         address newRootAdmin) onlyRootAdmin public
614     {
615         if (isAdmin[newRootAdmin] && admins[0] != newRootAdmin) {
616             removeAdmin(newRootAdmin);
617         }
618         admins[0] = newRootAdmin;
619         isAdmin[newRootAdmin] = true;
620     }
621 
622     function addAdmin(
623         address newAdmin) onlyRootAdmin public
624     {
625         require(!isAdmin[newAdmin]);
626 
627         isAdmin[newAdmin] = true;
628         admins.push(newAdmin);
629     }
630     
631     function depositToken(bytes32 walletID, uint256 amount) public returns (bool)
632     {
633         require(amount > 0);
634         require(approve(msg.sender, amount+1));
635    
636         uint256 _allowance = allowed[msg.sender][msg.sender];
637         balances[msg.sender] = balances[msg.sender].sub(amount);
638 
639         wallets[walletID].tokenBalance = wallets[walletID].tokenBalance.add(amount);
640         allowed[msg.sender][msg.sender] = _allowance.sub(amount);
641 
642         emit DepositToken(walletID, msg.sender, amount);
643         return true;
644     }
645   
646     function withdrawToken(
647         bytes32[] walletIDs,
648         address[] receivers,
649         uint256[] amounts,
650         uint64[] nonces,
651         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public returns (bool)
652     {
653         require(
654             walletIDs.length == receivers.length &&
655             walletIDs.length == amounts.length &&
656             walletIDs.length == nonces.length &&
657             walletIDs.length == v.length &&
658             walletIDs.length == r.length &&
659             walletIDs.length == s.length
660         );
661 
662         for (uint i = 0; i < walletIDs.length; i++) {
663             bytes32 walletID = walletIDs[i];
664             address receiver = receivers[i];
665             uint256 amount = amounts[i];
666             uint64 nonce = nonces[i];
667             
668             address signer = getMessageSigner(
669                 getWithdrawDigest(walletID, receiver, amount, nonce), v[i], r[i], s[i]
670             );
671             Wallet storage wallet = wallets[walletID];
672             if (
673                 wallet.withdrawNonce < nonce &&
674                 wallet.tokenBalance >= amount &&
675                 wallet.authed[signer]
676             ) 
677             {
678                 wallet.withdrawNonce = nonce;
679                 wallet.tokenBalance = wallet.tokenBalance.sub(amount);
680 		        balances[receiver] = balances[receiver].add(amount);
681 		       
682                 emit WithdrawToken(walletID, nonce, amount, receiver);
683                 return true;
684             }
685         }
686     }
687 
688     function seedToken(
689         bytes32[] walletIDs,
690         uint256[] amounts,
691         uint64[] nonces,
692         uint8[] v, bytes32[] r, bytes32[] s) onlyAdmin public
693     {
694         require(
695             walletIDs.length == amounts.length &&
696             walletIDs.length == nonces.length &&
697             walletIDs.length == v.length &&
698             walletIDs.length == r.length &&
699             walletIDs.length == s.length
700         );
701         
702         uint256 addition = 0;
703 
704         for (uint i = 0; i < walletIDs.length; i++) {
705             bytes32 walletID = walletIDs[i];
706             uint256 amount = amounts[i];
707             uint64 nonce = nonces[i];
708 
709             address signer = getMessageSigner(
710                 getSeedDigest(walletID, amount, nonce), v[i], r[i], s[i]
711             );
712 
713             Wallet storage wallet = wallets[walletID];
714             if (
715                 wallet.seedNonce < nonce &&
716                 wallet.tokenBalance >= amount &&
717                 wallet.authed[signer]
718             ) {
719                 wallet.seedNonce = nonce;
720                 wallet.tokenBalance = wallet.tokenBalance.sub(amount);
721                 emit SeedToken(walletID, nonce, amount);
722                 addition += amount;
723             }
724         }
725 
726         agentTokenBalance += addition;
727     }
728 
729 
730     function gainToken(
731         bytes32[] walletIDs,
732         uint256[] recordIDs,
733         uint256[] amounts) onlyAdmin public
734     {
735         require(
736             walletIDs.length == recordIDs.length &&
737             walletIDs.length == amounts.length
738         );
739 
740         uint256 remaining = agentTokenBalance;
741         
742         
743         for (uint i = 0; i < walletIDs.length; i++) {
744             bytes32 walletID = walletIDs[i];
745             uint256 amount = amounts[i];
746             
747             Wallet storage wallet = wallets[walletID];
748             require(amount <= remaining);
749 
750             wallet.tokenBalance = wallet.tokenBalance.add(amount);
751             remaining = remaining.sub(amount);
752 
753             emit GainToken(walletID, recordIDs[i], amount);
754         }
755 
756         agentTokenBalance = remaining;
757     }
758 
759 }