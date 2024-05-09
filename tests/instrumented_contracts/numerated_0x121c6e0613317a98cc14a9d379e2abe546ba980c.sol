1 pragma solidity ^0.4.19;
2 
3 contract Multiownable {
4 
5     // VARIABLES
6 
7     uint256 public howManyOwnersDecide;
8     address[] public owners;
9     bytes32[] public allOperations;
10     address insideOnlyManyOwners;
11     
12     // Reverse lookup tables for owners and allOperations
13     mapping(address => uint) ownersIndices; // Starts from 1
14     mapping(bytes32 => uint) allOperationsIndicies;
15     
16     // Owners voting mask per operations
17     mapping(bytes32 => uint256) public votesMaskByOperation;
18     mapping(bytes32 => uint256) public votesCountByOperation;
19     
20     // EVENTS
21 
22     event OwnershipTransferred(address[] previousOwners, address[] newOwners);
23 
24     // ACCESSORS
25 
26     function isOwner(address wallet) public constant returns(bool) {
27         return ownersIndices[wallet] > 0;
28     }
29 
30     function ownersCount() public constant returns(uint) {
31         return owners.length;
32     }
33 
34     function allOperationsCount() public constant returns(uint) {
35         return allOperations.length;
36     }
37 
38     // MODIFIERS
39 
40     /**
41     * @dev Allows to perform method by any of the owners
42     */
43     modifier onlyAnyOwner {
44         require(isOwner(msg.sender));
45         _;
46     }
47 
48     /**
49     * @dev Allows to perform method only after all owners call it with the same arguments
50     */
51     modifier onlyManyOwners {
52         if (insideOnlyManyOwners == msg.sender) {
53             _;
54             return;
55         }
56         require(isOwner(msg.sender));
57 
58         uint ownerIndex = ownersIndices[msg.sender] - 1;
59         bytes32 operation = keccak256(msg.data);
60         
61         if (votesMaskByOperation[operation] == 0) {
62             allOperationsIndicies[operation] = allOperations.length;
63             allOperations.push(operation);
64         }
65         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0);
66         votesMaskByOperation[operation] |= (2 ** ownerIndex);
67         votesCountByOperation[operation] += 1;
68 
69         // If all owners confirm same operation
70         if (votesCountByOperation[operation] == howManyOwnersDecide) {
71             deleteOperation(operation);
72             insideOnlyManyOwners = msg.sender;
73             _;
74             insideOnlyManyOwners = address(0);
75         }
76     }
77 
78     // CONSTRUCTOR
79 
80     function Multiownable() public {
81         owners.push(msg.sender);
82         ownersIndices[msg.sender] = 1;
83         howManyOwnersDecide = 1;
84     }
85 
86     // INTERNAL METHODS
87 
88     /**
89     * @dev Used to delete cancelled or performed operation
90     * @param operation defines which operation to delete
91     */
92     function deleteOperation(bytes32 operation) internal {
93         uint index = allOperationsIndicies[operation];
94         if (allOperations.length > 1) {
95             allOperations[index] = allOperations[allOperations.length - 1];
96             allOperationsIndicies[allOperations[index]] = index;
97         }
98         allOperations.length--;
99         
100         delete votesMaskByOperation[operation];
101         delete votesCountByOperation[operation];
102         delete allOperationsIndicies[operation];
103     }
104 
105     // PUBLIC METHODS
106 
107     /**
108     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
109     * @param operation defines which operation to delete
110     */
111     function cancelPending(bytes32 operation) public onlyAnyOwner {
112         uint ownerIndex = ownersIndices[msg.sender] - 1;
113         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0);
114         
115         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
116         votesCountByOperation[operation]--;
117         if (votesCountByOperation[operation] == 0) {
118             deleteOperation(operation);
119         }
120     }
121 
122     /**
123     * @dev Allows owners to change ownership
124     * @param newOwners defines array of addresses of new owners
125     */
126     function transferOwnership(address[] newOwners) public {
127         transferOwnershipWithHowMany(newOwners, newOwners.length);
128     }
129 
130     /**
131     * @dev Allows owners to change ownership
132     * @param newOwners defines array of addresses of new owners
133     * @param newHowManyOwnersDecide defines how many owners can decide
134     */
135     function transferOwnershipWithHowMany(address[] newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {
136         require(newOwners.length > 0);
137         require(newOwners.length <= 256);
138         require(newHowManyOwnersDecide > 0);
139         require(newHowManyOwnersDecide <= newOwners.length);
140         for (uint i = 0; i < newOwners.length; i++) {
141             require(newOwners[i] != address(0));
142         }
143 
144         OwnershipTransferred(owners, newOwners);
145 
146         // Reset owners array and index reverse lookup table
147         for (i = 0; i < owners.length; i++) {
148             delete ownersIndices[owners[i]];
149         }
150         for (i = 0; i < newOwners.length; i++) {
151             require(ownersIndices[newOwners[i]] == 0);
152             ownersIndices[newOwners[i]] = i + 1;
153         }
154         owners = newOwners;
155         howManyOwnersDecide = newHowManyOwnersDecide;
156 
157         // Discard all pendign operations
158         for (i = 0; i < allOperations.length; i++) {
159             delete votesMaskByOperation[allOperations[i]];
160             delete votesCountByOperation[allOperations[i]];
161             delete allOperationsIndicies[allOperations[i]];
162         }
163         allOperations.length = 0;
164     }
165 
166 }
167 
168 contract owned {
169     address public owner;
170 
171     function owned() public {
172         owner = msg.sender;
173     }
174 
175     modifier onlyOwner {
176         require(msg.sender == owner);
177         _;
178     }
179 
180     function transferOwnership(address newOwner) onlyOwner public {
181         owner = newOwner;
182     }
183 }
184 
185 
186 contract PELOExtensionInterface is owned {
187 
188     event ExtensionCalled(bytes32[8] params);
189 
190     address public ownerContract;
191 
192     function PELOExtensionInterface(address _ownerContract) public {
193         ownerContract = _ownerContract;
194     }
195     
196     function ChangeOwnerContract(address _ownerContract) onlyOwner public {
197         ownerContract = _ownerContract;
198     }
199     
200     function Operation(uint8 opCode, bytes32[8] params) public returns (bytes32[8] result) {}
201 }
202 
203 contract PELOExtension1 is PELOExtensionInterface {
204 
205     function PELOExtension1(address _ownerContract) PELOExtensionInterface(_ownerContract) public {} 
206     
207     function Operation(uint8 opCode, bytes32[8] params) public returns (bytes32[8] result) {
208         if(opCode == 1) {
209             ExtensionCalled(params);
210             return result;
211         }
212         else if(opCode == 2) {
213             ExtensionCalled(params);
214             return result;
215         }
216         else {
217             return result;
218         }
219     }
220 }
221 
222 
223 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
224 
225 contract TokenERC20 {
226     // Public variables of the token
227     string public name;
228     string public symbol;
229     uint8 public decimals = 18;
230     // 18 decimals is the strongly suggested default, avoid changing it
231     uint256 public totalSupply;
232 
233     // This creates an array with all balances
234     mapping (address => uint256) public balanceOf;
235     mapping (address => mapping (address => uint256)) public allowance;
236 
237     // This generates a public event on the blockchain that will notify clients
238     event Transfer(address indexed from, address indexed to, uint256 value);
239 
240     // This notifies clients about the amount burnt
241     event Burn(address indexed from, uint256 value);
242 
243     /**
244      * Constrctor function
245      *
246      * Initializes contract with initial supply tokens to the creator of the contract
247      */
248     function TokenERC20(
249         uint256 initialSupply,
250         string tokenName,
251         string tokenSymbol
252     ) public {
253         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
254         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
255         name = tokenName;                                   // Set the name for display purposes
256         symbol = tokenSymbol;                               // Set the symbol for display purposes
257     }
258 
259     /**
260      * Internal transfer, only can be called by this contract
261      */
262     function _transfer(address _from, address _to, uint _value) internal {
263         // Prevent transfer to 0x0 address. Use burn() instead
264         require(_to != 0x0);
265         // Check if the sender has enough
266         require(balanceOf[_from] >= _value);
267         // Check for overflows
268         require(balanceOf[_to] + _value > balanceOf[_to]);
269         // Save this for an assertion in the future
270         uint previousBalances = balanceOf[_from] + balanceOf[_to];
271         // Subtract from the sender
272         balanceOf[_from] -= _value;
273         // Add the same to the recipient
274         balanceOf[_to] += _value;
275         Transfer(_from, _to, _value);
276         // Asserts are used to use static analysis to find bugs in your code. They should never fail
277         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
278     }
279 
280     /**
281      * Transfer tokens
282      *
283      * Send `_value` tokens to `_to` from your account
284      *
285      * @param _to The address of the recipient
286      * @param _value the amount to send
287      */
288     function transfer(address _to, uint256 _value) public {
289         _transfer(msg.sender, _to, _value);
290     }
291 
292     /**
293      * Transfer tokens from other address
294      *
295      * Send `_value` tokens to `_to` in behalf of `_from`
296      *
297      * @param _from The address of the sender
298      * @param _to The address of the recipient
299      * @param _value the amount to send
300      */
301     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
302         require(_value <= allowance[_from][msg.sender]);     // Check allowance
303         allowance[_from][msg.sender] -= _value;
304         _transfer(_from, _to, _value);
305         return true;
306     }
307 
308     /**
309      * Set allowance for other address
310      *
311      * Allows `_spender` to spend no more than `_value` tokens in your behalf
312      *
313      * @param _spender The address authorized to spend
314      * @param _value the max amount they can spend
315      */
316     function approve(address _spender, uint256 _value) public
317         returns (bool success) {
318         allowance[msg.sender][_spender] = _value;
319         return true;
320     }
321 
322     /**
323      * Set allowance for other address and notify
324      *
325      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
326      *
327      * @param _spender The address authorized to spend
328      * @param _value the max amount they can spend
329      * @param _extraData some extra information to send to the approved contract
330      */
331     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
332         public
333         returns (bool success) {
334         tokenRecipient spender = tokenRecipient(_spender);
335         if (approve(_spender, _value)) {
336             spender.receiveApproval(msg.sender, _value, this, _extraData);
337             return true;
338         }
339     }
340 
341     /**
342      * Destroy tokens
343      *
344      * Remove `_value` tokens from the system irreversibly
345      *
346      * @param _value the amount of money to burn
347      */
348     function burn(uint256 _value) public returns (bool success) {
349         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
350         balanceOf[msg.sender] -= _value;            // Subtract from the sender
351         totalSupply -= _value;                      // Updates totalSupply
352         Burn(msg.sender, _value);
353         return true;
354     }
355 
356     /**
357      * Destroy tokens from other account
358      *
359      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
360      *
361      * @param _from the address of the sender
362      * @param _value the amount of money to burn
363      */
364     function burnFrom(address _from, uint256 _value) public returns (bool success) {
365         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
366         require(_value <= allowance[_from][msg.sender]);    // Check allowance
367         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
368         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
369         totalSupply -= _value;                              // Update totalSupply
370         Burn(_from, _value);
371         return true;
372     }
373 }
374 
375 /******************************************/
376 /*       ADVANCED TOKEN STARTS HERE       */
377 /******************************************/
378 
379 contract PELOCoinToken is Multiownable, TokenERC20 {
380 
381     uint256 public sellPrice;
382     uint256 public buyPrice;
383     
384     bool public userInitialized = false;
385     
386     PELOExtensionInterface public peloExtenstion;
387     
388     struct PELOMember {
389         uint32 id;
390         bytes32 nickname;
391         address ethAddr;
392 
393         /* peloAmount should be specified without decimals. ex: 10000PELO should be specified as 10000 not 10000 * 10^18 */
394         uint peloAmount;
395 
396         /* peloBonus should be specified without decimals. ex: 10000PELO should be specified as 10000 not 10000 * 10^18 */
397         uint peloBonus;
398 
399         /* 1: infinite members, 2: limited member(has expairation date), 4: xxx, 8: xxx, 16: xxx, 32 ... 65536 ... 2^255 */
400         uint bitFlag;
401 
402         uint32 expire;
403         bytes32 extraData1;
404         bytes32 extraData2;
405         bytes32 extraData3;
406     }
407     
408     uint8 public numMembers;
409 
410     mapping (address => bool) public frozenAccount;
411 
412     mapping (address => PELOMember) public PELOMemberMap;
413     mapping (uint32 => address) public PELOMemberIDMap;
414 
415     /* This generates a public event on the blockchain that will notify clients */
416     event FrozenFunds(address target, bool frozen);
417 
418     /* Initializes contract with initial supply tokens to the creator of the contract */
419     function PELOCoinToken(
420         uint256 initialSupply,
421         string tokenName,
422         string tokenSymbol
423     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
424 
425     function GetUserNickName(address _addr) constant public returns(bytes32) {
426         require(PELOMemberMap[_addr].id > 0);
427         PELOMember memory data = PELOMemberMap[_addr]; 
428         
429         return data.nickname;
430     }
431 
432     function GetUserID(address _addr) constant public returns(uint32) {
433         require(PELOMemberMap[_addr].id > 0);
434         PELOMember memory data = PELOMemberMap[_addr]; 
435         
436         return data.id;
437     }
438 
439     function GetUserPELOAmount(address _addr) constant public returns(uint) {
440         require(PELOMemberMap[_addr].id > 0);
441         PELOMember memory data = PELOMemberMap[_addr]; 
442         
443         return data.peloAmount;
444     }
445 
446     function GetUserPELOBonus(address _addr) constant public returns(uint) {
447         require(PELOMemberMap[_addr].id > 0);
448         PELOMember memory data = PELOMemberMap[_addr]; 
449         
450         return data.peloBonus;
451     }
452 
453     function GetUserBitFlag(address _addr) constant public returns(uint) {
454         require(PELOMemberMap[_addr].id > 0);
455         PELOMember memory data = PELOMemberMap[_addr]; 
456         
457         return data.bitFlag;
458     }
459 
460     function TestUserBitFlag(address _addr, uint _flag) constant public returns(bool) {
461         require(PELOMemberMap[_addr].id > 0);
462         PELOMember memory data = PELOMemberMap[_addr]; 
463         
464         return (data.bitFlag & _flag) == _flag;
465     }
466     
467     function GetUserExpire(address _addr) constant public returns(uint32) {
468         require(PELOMemberMap[_addr].id > 0);
469         PELOMember memory data = PELOMemberMap[_addr]; 
470         
471         return data.expire;
472     }
473     
474     function GetUserExtraData1(address _addr) constant public returns(bytes32) {
475         require(PELOMemberMap[_addr].id > 0);
476         PELOMember memory data = PELOMemberMap[_addr]; 
477         
478         return data.extraData1;
479     }
480     
481     function GetUserExtraData2(address _addr) constant public returns(bytes32) {
482         require(PELOMemberMap[_addr].id > 0);
483         PELOMember memory data = PELOMemberMap[_addr]; 
484         
485         return data.extraData2;
486     }
487     
488     function GetUserExtraData3(address _addr) constant public returns(bytes32) {
489         require(PELOMemberMap[_addr].id > 0);
490         PELOMember memory data = PELOMemberMap[_addr]; 
491         
492         return data.extraData3;
493     }
494 
495     function UpdateUserNickName(address _addr, bytes32 _newNickName) onlyManyOwners public {
496         require(PELOMemberMap[_addr].id > 0);
497         PELOMember storage data = PELOMemberMap[_addr]; 
498         
499         data.nickname = _newNickName;
500     }
501 
502     function UpdateUserPELOAmount(address _addr, uint _newValue) onlyManyOwners public {
503         require(PELOMemberMap[_addr].id > 0);
504         PELOMember storage data = PELOMemberMap[_addr]; 
505         
506         data.peloAmount = _newValue;
507     }
508 
509     function UpdateUserPELOBonus(address _addr, uint _newValue) onlyManyOwners public {
510         require(PELOMemberMap[_addr].id > 0);
511         PELOMember storage data = PELOMemberMap[_addr]; 
512         
513         data.peloBonus = _newValue;
514     }
515 
516     function UpdateUserBitFlag(address _addr, uint _newValue) onlyManyOwners public {
517         require(PELOMemberMap[_addr].id > 0);
518         PELOMember storage data = PELOMemberMap[_addr]; 
519         
520         data.bitFlag = _newValue;
521     }
522 
523     function UpdateUserExpire(address _addr, uint32 _newValue) onlyManyOwners public {
524         require(PELOMemberMap[_addr].id > 0);
525         PELOMember storage data = PELOMemberMap[_addr]; 
526         
527         data.expire = _newValue;
528     }
529 
530     function UpdateUserExtraData1(address _addr, bytes32 _newValue) onlyManyOwners public {
531         require(PELOMemberMap[_addr].id > 0);
532         PELOMember storage data = PELOMemberMap[_addr]; 
533         
534         data.extraData1 = _newValue;
535     }
536 
537     function UpdateUserExtraData2(address _addr, bytes32 _newValue) onlyManyOwners public {
538         require(PELOMemberMap[_addr].id > 0);
539         PELOMember storage data = PELOMemberMap[_addr]; 
540         
541         data.extraData2 = _newValue;
542     }
543 
544     function UpdateUserExtraData3(address _addr, bytes32 _newValue) onlyManyOwners public {
545         require(PELOMemberMap[_addr].id > 0);
546         PELOMember storage data = PELOMemberMap[_addr]; 
547         
548         data.extraData3 = _newValue;
549     }
550 
551     function DeleteUserByAddr(address _addr) onlyManyOwners public {
552         require(PELOMemberMap[_addr].id > 0);
553 
554         delete PELOMemberIDMap[PELOMemberMap[_addr].id];
555         delete PELOMemberMap[_addr];
556 
557         numMembers--;
558         assert(numMembers >= 0);
559     }
560 
561     function DeleteUserByID(uint32 _id) onlyManyOwners public {
562         require(PELOMemberIDMap[_id] != 0x0);
563         address addr = PELOMemberIDMap[_id];
564         require(PELOMemberMap[addr].id > 0);
565 
566         delete PELOMemberMap[addr];
567         delete PELOMemberIDMap[_id];
568         
569         numMembers--;
570         assert(numMembers >= 0);
571     }
572 
573     function initializeUsers() onlyManyOwners public {
574         if(!userInitialized) {
575 
576             userInitialized = true;
577         }
578     }
579             
580     function insertNewUser(uint32 _id, bytes32 _nickname, address _ethAddr, uint _peloAmount, uint _peloBonus, uint _bitFlag, uint32 _expire, bool fWithTransfer) onlyManyOwners public {
581 
582         PELOMember memory data; 
583 
584         require(_id > 0);
585         require(PELOMemberMap[_ethAddr].id == 0);
586         require(PELOMemberIDMap[_id] == 0x0);
587 
588         data.id = _id;
589         data.nickname = _nickname;
590         data.ethAddr = _ethAddr;
591         data.peloAmount = _peloAmount;
592         data.peloBonus = _peloBonus;
593         data.bitFlag = _bitFlag;
594         data.expire = _expire;
595 
596         PELOMemberMap[_ethAddr] = data;
597         PELOMemberIDMap[_id] = _ethAddr;
598         
599         if(fWithTransfer) {
600             require(_peloAmount > 0);
601             uint256 amount = (_peloAmount + _peloBonus) * 10 ** uint256(decimals);
602             _transfer(msg.sender, _ethAddr, amount);
603             
604             assert(balanceOf[_ethAddr] == amount);
605         }
606         numMembers++;
607     }
608     
609     function updatePeloExtenstionContract(PELOExtensionInterface _peloExtension) onlyManyOwners public {
610         peloExtenstion = _peloExtension;
611     }
612 
613     /* Internal transfer, only can be called by this contract */
614     function _transfer(address _from, address _to, uint _value) internal {
615         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
616         require (balanceOf[_from] >= _value);                // Check if the sender has enough
617         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
618         require(!frozenAccount[_from]);                     // Check if sender is frozen
619         require(!frozenAccount[_to]);                       // Check if recipient is frozen
620 
621         // Save this for an assertion in the future
622         uint previousBalances = balanceOf[_from] + balanceOf[_to];
623 
624         if(peloExtenstion != PELOExtensionInterface(0x0))
625             peloExtenstion.Operation(1, [bytes32(_from), bytes32(_to), bytes32(_value), bytes32(balanceOf[_from]), bytes32(balanceOf[_to]), bytes32(0), bytes32(0), bytes32(0)]);
626         
627         balanceOf[_from] -= _value;                         // Subtract from the sender
628         balanceOf[_to] += _value;                           // Add the same to the recipient
629         Transfer(_from, _to, _value);
630 
631         // Asserts are used to use static analysis to find bugs in your code. They should never fail
632         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
633         
634         if(peloExtenstion != PELOExtensionInterface(0x0))
635             peloExtenstion.Operation(2, [bytes32(_from), bytes32(_to), bytes32(_value), bytes32(balanceOf[_from]), bytes32(balanceOf[_to]), bytes32(0), bytes32(0), bytes32(0)]);
636     }
637 
638     /// @notice Create `mintedAmount` tokens and send it to `target`
639     /// @param target Address to receive the tokens
640     /// @param mintedAmount the amount of tokens it will receive
641     function mintToken(address target, uint256 mintedAmount) onlyManyOwners public {
642         balanceOf[target] += mintedAmount;
643         totalSupply += mintedAmount;
644         Transfer(0, this, mintedAmount);
645         Transfer(this, target, mintedAmount);
646     }
647 
648     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
649     /// @param target Address to be frozen
650     /// @param freeze either to freeze it or not
651     function freezeAccount(address target, bool freeze) onlyManyOwners public {
652         frozenAccount[target] = freeze;
653         FrozenFunds(target, freeze);
654     }
655     
656     /**
657      * Transfer tokens from other address forcibly(for dealing with illegal usage, etc)
658      *
659      * Send `_value` tokens to `_to` in behalf of `_from`
660      *
661      * @param _from The address of the sender
662      * @param _to The address of the recipient
663      * @param _value the amount to send
664      */
665     function transferFromForcibly(address _from, address _to, uint256 _value) onlyManyOwners public returns (bool success) {
666 
667         if(allowance[_from][msg.sender] > _value)
668             allowance[_from][msg.sender] -= _value;
669         else 
670             allowance[_from][msg.sender] = 0;
671 
672         assert(allowance[_from][msg.sender] >= 0);
673 
674         _transfer(_from, _to, _value);
675         
676         return true;
677     }
678     
679     /**
680      * Transfer all the tokens from other address forcibly(for dealing with illegal usage, etc)
681      *
682      * @param _from The address of the sender
683      * @param _to The address of the recipient
684      */
685     function transferAllFromForcibly(address _from, address _to) onlyManyOwners public returns (bool success) {
686 
687         uint256 _value = balanceOf[_from];
688         require (_value >= 0);
689         return transferFromForcibly(_from, _to, _value);
690     }     
691 
692     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
693     /// @param newSellPrice Price the users can sell to the contract
694     /// @param newBuyPrice Price users can buy from the contract
695     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyManyOwners public {
696         sellPrice = newSellPrice;
697         buyPrice = newBuyPrice;
698     }
699 
700     /// @notice Buy tokens from contract by sending ether
701     function buy() payable public {
702         uint amount = msg.value / buyPrice;               // calculates the amount
703         _transfer(this, msg.sender, amount);              // makes the transfers
704     }
705 
706     /// @notice Sell `amount` tokens to contract
707     /// @param amount amount of tokens to be sold
708     function sell(uint256 amount) public {
709         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
710         _transfer(msg.sender, this, amount);              // makes the transfers
711         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
712     }
713 }