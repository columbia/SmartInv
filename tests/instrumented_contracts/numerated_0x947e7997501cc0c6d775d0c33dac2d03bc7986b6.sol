1 pragma solidity 0.5.5; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 ███████╗███╗   ██╗██╗   ██╗ ██████╗ ██╗   ██╗     ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗
12 ██╔════╝████╗  ██║██║   ██║██╔═══██╗╚██╗ ██╔╝    ██╔════╝██║  ██║██╔══██╗██║████╗  ██║
13 █████╗  ██╔██╗ ██║██║   ██║██║   ██║ ╚████╔╝     ██║     ███████║███████║██║██╔██╗ ██║
14 ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║   ██║  ╚██╔╝      ██║     ██╔══██║██╔══██║██║██║╚██╗██║
15 ███████╗██║ ╚████║ ╚████╔╝ ╚██████╔╝   ██║       ╚██████╗██║  ██║██║  ██║██║██║ ╚████║
16 ╚══════╝╚═╝  ╚═══╝  ╚═══╝   ╚═════╝    ╚═╝        ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
17                                                                                       
18                                                                                         
19   
20 // ----------------------------------------------------------------------------
21 // 'Envoy' Token contract with following features
22 //      => ERC20 Compliance
23 //      => Higher degree of control by owner - safeguard functionality
24 //      => SafeMath implementation 
25 //      => Burnable and minting 
26 //      => user whitelisting 
27 //      => air drop (active and passive)
28 //      => in-built buy/sell functions 
29 //      => in-built ICO simple phased 
30 //      => upgradibilitiy 
31 //
32 // Name        : Envoy
33 // Symbol      : NVOY
34 // Total supply: 250,000,000
35 // Decimals    : 18
36 //
37 // Copyright 2019 onwards - Envoy Group ( http://envoychain.io )
38 // Special thanks to openzeppelin for inspiration: 
39 // https://github.com/zeppelinos/labs/tree/master/upgradeability_using_unstructured_storage
40 // ----------------------------------------------------------------------------
41 */ 
42 
43 //*******************************************************************//
44 //------------------------ SafeMath Library -------------------------//
45 //*******************************************************************//
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     if (a == 0) {
53       return 0;
54     }
55     uint256 c = a * b;
56     assert(c / a == b);
57     return c;
58   }
59 
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 
80 //*******************************************************************//
81 //------------------ Contract to Manage Ownership -------------------//
82 //*******************************************************************//
83     
84 contract owned {
85     address payable public owner;
86     
87      constructor () public {
88         owner = msg.sender;
89     }
90 
91     modifier onlyOwner {
92         require(msg.sender == owner);
93         _;
94     }
95 
96     function transferOwnership(address payable newOwner) onlyOwner public {
97         owner = newOwner;
98     }
99 }
100     
101 
102     
103 //****************************************************************************//
104 //---------------------        MAIN CODE STARTS HERE     ---------------------//
105 //****************************************************************************//
106     
107 contract EnvoyChain_v1 is owned {
108     
109 
110     /*===============================
111     =         DATA STORAGE          =
112     ===============================*/
113 
114     // Public variables of the token
115     using SafeMath for uint256;
116     string public name;
117     string public symbol;
118     uint256 public decimals;
119     uint256 public totalSupply;
120     bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
121 
122     // This creates a mapping with all data storage
123     mapping (address => uint256) public balanceOf;
124     mapping (address => mapping (address => uint256)) public allowance;
125     mapping (address => bool) public frozenAccount;
126 
127 
128     /*===============================
129     =         PUBLIC EVENTS         =
130     ===============================*/
131 
132     // This generates a public event of token transfer
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     // This notifies clients about the amount burnt
136     event Burn(address indexed from, uint256 value);
137         
138     // This generates a public event for frozen (blacklisting) accounts
139     event FrozenFunds(address target, bool frozen);
140 
141 
142 
143     /*======================================
144     =       STANDARD ERC20 FUNCTIONS       =
145     ======================================*/
146 
147     /* Internal transfer, only can be called by this contract */
148     function _transfer(address _from, address _to, uint _value) internal {
149         
150         //checking conditions
151         require(!safeguard);
152         require (_to != address(0));                      // Prevent transfer to 0x0 address. Use burn() instead
153         require(!frozenAccount[_from]);                     // Check if sender is frozen
154         require(!frozenAccount[_to]);                       // Check if recipient is frozen
155         
156         // overflow and undeflow checked by SafeMath Library
157         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
158         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
159         
160         // emit Transfer event
161         emit Transfer(_from, _to, _value);
162     }
163 
164     /**
165         * Transfer tokens
166         *
167         * Send `_value` tokens to `_to` from your account
168         *
169         * @param _to The address of the recipient
170         * @param _value the amount to send
171         */
172     function transfer(address _to, uint256 _value) public returns (bool success) {
173         //no need to check for input validations, as that is ruled by SafeMath
174         _transfer(msg.sender, _to, _value);
175         return true;
176     }
177 
178     /**
179         * Transfer tokens from other address
180         *
181         * Send `_value` tokens to `_to` in behalf of `_from`
182         *
183         * @param _from The address of the sender
184         * @param _to The address of the recipient
185         * @param _value the amount to send
186         */
187     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
188         require(_value <= allowance[_from][msg.sender]);     // Check allowance
189         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
190         _transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195         * Set allowance for other address
196         *
197         * Allows `_spender` to spend no more than `_value` tokens in your behalf
198         *
199         * @param _spender The address authorized to spend
200         * @param _value the max amount they can spend
201         */
202     function approve(address _spender, uint256 _value) public returns (bool success) {
203         require(!safeguard);
204         allowance[msg.sender][_spender] = _value;
205         return true;
206     }
207 
208 
209     /*=====================================
210     =       CUSTOM PUBLIC FUNCTIONS       =
211     ======================================*/
212     
213     constructor() public{
214         //sending all the tokens to Owner
215         balanceOf[owner] = totalSupply;
216         
217         //firing event which logs this transaction
218         emit Transfer(address(0), owner, totalSupply);
219     }
220     
221     function () external payable {
222         
223         buyTokens();
224     }
225 
226     /**
227         * Destroy tokens
228         *
229         * Remove `_value` tokens from the system irreversibly
230         *
231         * @param _value the amount of money to burn
232         */
233     function burn(uint256 _value) public returns (bool success) {
234         require(!safeguard);
235         //checking of enough token balance is done by SafeMath
236         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
237         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
238         emit Burn(msg.sender, _value);
239         return true;
240     }
241 
242     /**
243         * Destroy tokens from other account
244         *
245         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
246         *
247         * @param _from the address of the sender
248         * @param _value the amount of money to burn
249         */
250     function burnFrom(address _from, uint256 _value) public returns (bool success) {
251         require(!safeguard);
252         //checking of allowance and token value is done by SafeMath
253         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
254         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
255         totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
256         emit  Burn(_from, _value);
257         return true;
258     }
259         
260     
261     /** 
262         * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
263         * @param target Address to be frozen
264         * @param freeze either to freeze it or not
265         */
266     function freezeAccount(address target, bool freeze) onlyOwner public {
267             frozenAccount[target] = freeze;
268         emit  FrozenFunds(target, freeze);
269     }
270     
271     /** 
272         * @notice Create `mintedAmount` tokens and send it to `target`
273         * @param target Address to receive the tokens
274         * @param mintedAmount the amount of tokens it will receive
275         */
276     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
277         balanceOf[target] = balanceOf[target].add(mintedAmount);
278         totalSupply = totalSupply.add(mintedAmount);
279         emit Transfer(address(0), target, mintedAmount);
280     }
281 
282         
283 
284     /**
285         * Owner can transfer tokens from contract to owner address
286         *
287         * When safeguard is true, then all the non-owner functions will stop working.
288         * When safeguard is false, then all the functions will resume working back again!
289         */
290     
291     function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
292         // no need for overflow checking as that will be done in transfer function
293         _transfer(address(this), owner, tokenAmount);
294     }
295     
296     //Just in rare case, owner wants to transfer Ether from contract to owner address
297     function manualWithdrawEther()onlyOwner public{
298         address(owner).transfer(address(this).balance);
299     }
300     
301     /**
302         * Change safeguard status on or off
303         *
304         * When safeguard is true, then all the non-owner functions will stop working.
305         * When safeguard is false, then all the functions will resume working back again!
306         */
307     function changeSafeguardStatus() onlyOwner public{
308         if (safeguard == false){
309             safeguard = true;
310         }
311         else{
312             safeguard = false;    
313         }
314     }
315     
316     /*************************************/
317     /*    Section for User Air drop      */
318     /*************************************/
319     
320     bool public passiveAirdropStatus;
321     uint256 public passiveAirdropTokensAllocation;
322     uint256 public airdropAmount;  //in wei
323     uint256 public passiveAirdropTokensSold;
324     mapping(uint256 => mapping(address => bool)) public airdropClaimed;
325     uint256 internal airdropClaimedIndex;
326     uint256 public airdropFee = 0.05 ether;
327     
328     /**
329      * This function to start a passive air drop by admin only
330      * Admin have to put airdrop amount (in wei) and total toens allocated for it.
331      * Admin must keep allocated tokens in the contract
332      */
333     function startNewPassiveAirDrop(uint256 passiveAirdropTokensAllocation_, uint256 airdropAmount_  ) public onlyOwner {
334         passiveAirdropTokensAllocation = passiveAirdropTokensAllocation_;
335         airdropAmount = airdropAmount_;
336         passiveAirdropStatus = true;
337     } 
338     
339     /**
340      * This function will stop any ongoing passive airdrop
341      */
342     function stopPassiveAirDropCompletely() public onlyOwner{
343         passiveAirdropTokensAllocation = 0;
344         airdropAmount = 0;
345         airdropClaimedIndex++;
346         passiveAirdropStatus = false;
347     }
348     
349     /**
350      * This function called by user who want to claim passive air drop.
351      * He can only claim air drop once, for current air drop. If admin stop an air drop and start fresh, then users can claim again (once only).
352      */
353     function claimPassiveAirdrop() public payable returns(bool) {
354         require(airdropAmount > 0, 'Token amount must not be zero');
355         require(passiveAirdropStatus, 'Air drop is not active');
356         require(passiveAirdropTokensSold <= passiveAirdropTokensAllocation, 'Air drop sold out');
357         require(!airdropClaimed[airdropClaimedIndex][msg.sender], 'user claimed air drop already');
358         require(!isContract(msg.sender),  'No contract address allowed to claim air drop');
359         require(msg.value >= airdropFee, 'Not enough ether to claim this airdrop');
360         
361         _transfer(address(this), msg.sender, airdropAmount);
362         passiveAirdropTokensSold += airdropAmount;
363         airdropClaimed[airdropClaimedIndex][msg.sender] = true; 
364         return true;
365     }
366     
367     function changePassiveAirdropAmount(uint256 newAmount) public onlyOwner{
368         airdropAmount = newAmount;
369     }
370     
371     function isContract(address _address) public view returns (bool){
372         uint32 size;
373         assembly {
374             size := extcodesize(_address)
375         }
376         return (size > 0);
377     }
378     
379     function updateAirdropFee(uint256 newFee) public onlyOwner{
380         airdropFee = newFee;
381     }
382     
383     /**
384      * Run an ACTIVE Air-Drop
385      *
386      * It requires an array of all the addresses and amount of tokens to distribute
387      * It will only process first 150 recipients. That limit is fixed to prevent gas limit
388      */
389     function airdropACTIVE(address[] memory recipients,uint256 tokenAmount) public onlyOwner {
390         require(recipients.length <= 150);
391         uint256 totalAddresses = recipients.length;
392         for(uint i = 0; i < totalAddresses; i++)
393         {
394           //This will loop through all the recipients and send them the specified tokens
395           //Input data validation is unncessary, as that is done by SafeMath and which also saves some gas.
396           _transfer(address(this), recipients[i], tokenAmount);
397         }
398     }
399     
400     
401     
402     
403     /*************************************/
404     /*  Section for User whitelisting    */
405     /*************************************/
406     bool public whitelistingStatus;
407     mapping (address => bool) public whitelisted;
408     
409     /**
410      * Change whitelisting status on or off
411      *
412      * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
413      */
414     function changeWhitelistingStatus() onlyOwner public{
415         if (whitelistingStatus == false){
416             whitelistingStatus = true;
417         }
418         else{
419             whitelistingStatus = false;    
420         }
421     }
422     
423     /**
424      * Whitelist any user address - only Owner can do this
425      *
426      * It will add user address in whitelisted mapping
427      */
428     function whitelistUser(address userAddress) onlyOwner public{
429         require(whitelistingStatus == true);
430         require(userAddress != address(0));
431         whitelisted[userAddress] = true;
432     }
433     
434     /**
435      * Whitelist Many user address at once - only Owner can do this
436      * It will require maximum of 150 addresses to prevent block gas limit max-out and DoS attack
437      * It will add user address in whitelisted mapping
438      */
439     function whitelistManyUsers(address[] memory userAddresses) onlyOwner public{
440         require(whitelistingStatus == true);
441         uint256 addressCount = userAddresses.length;
442         require(addressCount <= 150);
443         for(uint256 i = 0; i < addressCount; i++){
444             require(userAddresses[i] != address(0));
445             whitelisted[userAddresses[i]] = true;
446         }
447     }
448     
449     
450     /*************************************/
451     /*  Section for Buy/Sell of tokens   */
452     /*************************************/
453     
454     uint256 public sellPrice;
455     uint256 public buyPrice;
456     
457     /** 
458      * Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
459      * newSellPrice Price the users can sell to the contract
460      * newBuyPrice Price users can buy from the contract
461      */
462     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
463         sellPrice = newSellPrice;   //sellPrice is 1 Token = ?? WEI
464         buyPrice = newBuyPrice;     //buyPrice is 1 ETH = ?? Tokens
465     }
466 
467     /**
468      * Buy tokens from contract by sending ether
469      * buyPrice is 1 ETH = ?? Tokens
470      */
471     
472     function buyTokens() payable public {
473         uint amount = msg.value * buyPrice;                 // calculates the amount
474         _transfer(address(this), msg.sender, amount);       // makes the transfers
475     }
476 
477     /**
478      * Sell `amount` tokens to contract
479      * amount amount of tokens to be sold
480      */
481     function sellTokens(uint256 amount) public {
482         uint256 etherAmount = amount * sellPrice/(10**decimals);
483         require(address(this).balance >= etherAmount);   // checks if the contract has enough ether to buy
484         _transfer(msg.sender, address(this), amount);           // makes the transfers
485         msg.sender.transfer(etherAmount);                // sends ether to the seller. It's important to do this last to avoid recursion attacks
486     }
487     
488     
489     /********************************************/
490     /* Custom Code for the contract Upgradation */
491     /********************************************/
492     
493     bool internal initialized;
494     function initialize(
495         address payable _owner
496     ) public {
497         require(!initialized);
498         require(owner == address(0)); //When this methods called, then owner address must be zero
499 
500         name = "Envoy";
501         symbol = "NVOY";
502         decimals = 18;
503         totalSupply = 250000000 * (10**decimals);
504         owner = _owner;
505         
506         //sending all the tokens to Owner
507         balanceOf[owner] = totalSupply;
508         
509         //firing event which logs this transaction
510         emit Transfer(address(0), owner, totalSupply);
511         
512         initialized = true;
513     }
514     
515 
516 }
517 
518 
519 
520 
521 
522 
523 
524 //********************************************************************************//
525 //-------------  MAIN PROXY CONTRACTS (UPGRADEABILITY) SECTION STARTS ------------//
526 //********************************************************************************//
527 
528 
529 /****************************************/
530 /*            Proxy Contract            */
531 /****************************************/
532 /**
533  * @title Proxy
534  * @dev Gives the possibility to delegate any call to a foreign implementation.
535  */
536 contract Proxy {
537   /**
538   * @dev Tells the address of the implementation where every call will be delegated.
539   * @return address of the implementation to which it will be delegated
540   */
541   function implementation() public view returns (address);
542 
543   /**
544   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
545   * This function will return whatever the implementation call returns
546   */
547   function () payable external {
548     address _impl = implementation();
549     require(_impl != address(0));
550 
551     assembly {
552       let ptr := mload(0x40)
553       calldatacopy(ptr, 0, calldatasize)
554       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
555       let size := returndatasize
556       returndatacopy(ptr, 0, size)
557 
558       switch result
559       case 0 { revert(ptr, size) }
560       default { return(ptr, size) }
561     }
562   }
563 }
564 
565 
566 /****************************************/
567 /*    UpgradeabilityProxy Contract      */
568 /****************************************/
569 /**
570  * @title UpgradeabilityProxy
571  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
572  */
573 contract UpgradeabilityProxy is Proxy {
574   /**
575    * @dev This event will be emitted every time the implementation gets upgraded
576    * @param implementation representing the address of the upgraded implementation
577    */
578   event Upgraded(address indexed implementation);
579 
580   // Storage position of the address of the current implementation
581   bytes32 private constant implementationPosition = keccak256("EtherAuthority.io.proxy.implementation");
582 
583   /**
584    * @dev Constructor function
585    */
586   constructor () public {}
587 
588   /**
589    * @dev Tells the address of the current implementation
590    * @return address of the current implementation
591    */
592   function implementation() public view returns (address impl) {
593     bytes32 position = implementationPosition;
594     assembly {
595       impl := sload(position)
596     }
597   }
598 
599   /**
600    * @dev Sets the address of the current implementation
601    * @param newImplementation address representing the new implementation to be set
602    */
603   function setImplementation(address newImplementation) internal {
604     bytes32 position = implementationPosition;
605     assembly {
606       sstore(position, newImplementation)
607     }
608   }
609 
610   /**
611    * @dev Upgrades the implementation address
612    * @param newImplementation representing the address of the new implementation to be set
613    */
614   function _upgradeTo(address newImplementation) internal {
615     address currentImplementation = implementation();
616     require(currentImplementation != newImplementation);
617     setImplementation(newImplementation);
618     emit Upgraded(newImplementation);
619   }
620 }
621 
622 /****************************************/
623 /*  OwnedUpgradeabilityProxy contract   */
624 /****************************************/
625 /**
626  * @title OwnedUpgradeabilityProxy
627  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
628  */
629 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
630   /**
631   * @dev Event to show ownership has been transferred
632   * @param previousOwner representing the address of the previous owner
633   * @param newOwner representing the address of the new owner
634   */
635   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
636 
637   // Storage position of the owner of the contract
638   bytes32 private constant proxyOwnerPosition = keccak256("EtherAuthority.io.proxy.owner");
639 
640   /**
641   * @dev the constructor sets the original owner of the contract to the sender account.
642   */
643   constructor () public {
644     setUpgradeabilityOwner(msg.sender);
645   }
646 
647   /**
648   * @dev Throws if called by any account other than the owner.
649   */
650   modifier onlyProxyOwner() {
651     require(msg.sender == proxyOwner());
652     _;
653   }
654 
655   /**
656    * @dev Tells the address of the owner
657    * @return the address of the owner
658    */
659   function proxyOwner() public view returns (address owner) {
660     bytes32 position = proxyOwnerPosition;
661     assembly {
662       owner := sload(position)
663     }
664   }
665 
666   /**
667    * @dev Sets the address of the owner
668    */
669   function setUpgradeabilityOwner(address newProxyOwner) internal {
670     bytes32 position = proxyOwnerPosition;
671     assembly {
672       sstore(position, newProxyOwner)
673     }
674   }
675 
676   /**
677    * @dev Allows the current owner to transfer control of the contract to a newOwner.
678    * @param newOwner The address to transfer ownership to.
679    */
680   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
681     require(newOwner != address(0));
682     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
683     setUpgradeabilityOwner(newOwner);
684   }
685 
686   /**
687    * @dev Allows the proxy owner to upgrade the current version of the proxy.
688    * @param implementation representing the address of the new implementation to be set.
689    */
690   function upgradeTo(address implementation) public onlyProxyOwner {
691     _upgradeTo(implementation);
692   }
693 
694   /**
695    * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
696    * to initialize whatever is needed through a low level call.
697    * @param implementation representing the address of the new implementation to be set.
698    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
699    * signature of the implementation to be called with the needed payload
700    */
701   function upgradeToAndCall(address implementation, bytes memory data) payable public onlyProxyOwner {
702     _upgradeTo(implementation);
703     (bool success,) = address(this).call.value(msg.value).gas(200000)(data);
704     require(success,'initialize function errored');
705   }
706   
707   function generateData() public view returns(bytes memory){
708         
709     return abi.encodeWithSignature("initialize(address)",msg.sender);
710       
711   }
712 }
713 
714 
715 /****************************************/
716 /*      EnvoyChain Proxy Contract       */
717 /****************************************/
718 
719 /**
720  * @title EnvoyChain_proxy
721  * @dev This contract proxies FiatToken calls and enables FiatToken upgrades
722 */ 
723 contract EnvoyChain_proxy is OwnedUpgradeabilityProxy {
724     constructor() public OwnedUpgradeabilityProxy() {
725     }
726 }