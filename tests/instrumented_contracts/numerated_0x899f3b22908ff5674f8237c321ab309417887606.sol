1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     emit Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 // File: zeppelin-solidity/contracts/lifecycle/TokenDestructible.sol
106 
107 /**
108  * @title TokenDestructible:
109  * @author Remco Bloemen <remco@2π.com>
110  * @dev Base contract that can be destroyed by owner. All funds in contract including
111  * listed tokens will be sent to the owner.
112  */
113 contract TokenDestructible is Ownable {
114 
115   function TokenDestructible() public payable { }
116 
117   /**
118    * @notice Terminate contract and refund to owner
119    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
120    refund.
121    * @notice The called token contracts could try to re-enter this contract. Only
122    supply token contracts you trust.
123    */
124   function destroy(address[] tokens) onlyOwner public {
125 
126     // Transfer tokens to owner
127     for (uint256 i = 0; i < tokens.length; i++) {
128       ERC20Basic token = ERC20Basic(tokens[i]);
129       uint256 balance = token.balanceOf(this);
130       token.transfer(owner, balance);
131     }
132 
133     // Transfer Eth to owner and terminate contract
134     selfdestruct(owner);
135   }
136 }
137 
138 // File: contracts/Atonomi.sol
139 
140 // solhint-disable-line
141 
142 
143 
144 
145 /// @title ERC-20 Token Standard
146 /// @author Fabian Vogelsteller <fabian@ethereum.org>, Vitalik Buterin <vitalik.buterin@ethereum.org>
147 /// @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
148 interface ERC20Interface {
149     function decimals() public constant returns (uint8);
150     function totalSupply() public constant returns (uint);
151     function balanceOf(address tokenOwner) public constant returns (uint balance);
152     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
153     function transfer(address to, uint tokens) public returns (bool success);
154     function approve(address spender, uint tokens) public returns (bool success);
155     function transferFrom(address from, address to, uint tokens) public returns (bool success);
156 
157     event Transfer(address indexed from, address indexed to, uint tokens);   // solhint-disable-line
158     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
159 }
160 
161 
162 /// @title Safe Math library
163 /// @dev Math operations with safety checks that throw on error
164 /// @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
165 library SafeMath {
166     /// @dev Multiplies two numbers, throws on overflow.
167     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
168         if (a == 0) {
169             return 0;
170         }
171         c = a * b;
172         assert(c / a == b);
173         return c;
174     }
175 
176     /// @dev Integer division of two numbers, truncating the quotient.
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         // assert(b > 0); // Solidity automatically throws when dividing by 0
179         // uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181         return a / b;
182     }
183 
184     /// @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         assert(b <= a);
187         return a - b;
188     }
189 
190     /// @dev Adds two numbers, throws on overflow.
191     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
192         c = a + b;
193         assert(c >= a);
194         return c;
195     }
196 }
197 
198 
199 /// @dev Interface for the Network Settings contract
200 interface SettingsInterface {
201     function registrationFee() external view returns (uint256);
202     function activationFee() external view returns (uint256);
203     function defaultReputationReward() external view returns (uint256);
204     function reputationIRNNodeShare() external view returns (uint256);
205     function blockThreshold() external view returns (uint256);
206 }
207 
208 
209 /// @title Atonomi Smart Contract
210 /// @author Atonomi
211 /// @notice Governs the activation, registration, and reputation of devices on the Atonomi network
212 /// @dev Ownable: Owner governs the access of Atonomi Admins, Fees, and Rewards on the network
213 /// @dev Pausable: Gives ability for Owner to pull emergency stop to prevent actions on the network
214 /// @dev TokenDestructible: Gives owner ability to kill the contract and extract funds to a new contract
215 contract Atonomi is Pausable, TokenDestructible {
216     using SafeMath for uint256;
217 
218     /// @title ATMI Token
219     /// @notice Standard ERC20 Token
220     /// @dev AMLToken source: https://github.com/TokenMarketNet/ico/blob/master/contracts/AMLToken.sol
221     ERC20Interface public token;
222 
223     /// @title Network Settings
224     /// @notice Atonomi Owner controlled settings are governed in this contract
225     SettingsInterface public settings;
226 
227     ///
228     /// STORAGE MAPPINGS 
229     ///
230     /// @title Atonomi Devices registry
231     /// @notice Contains all devices participating in the Atonomi Network
232     /// @dev Key is a keccak256 hash of the device id
233     /// @dev Value is a struct that contains the device status and metadata
234     mapping (bytes32 => Device) public devices;
235 
236     /// @title Atonomi Participant whitelist
237     /// @notice Contains all the network participants
238     /// @dev Atonomi Admins: Govern the access to manufacturers and IRN Nodes on the network
239     /// @dev IRN Nodes: Governs reputation score data of devices
240     /// @dev Manufacturers: Governs devices on the network
241     /// @dev Key is ethereum account of the participant
242     /// @dev Value is a struct that contains the role of the participant
243     mapping (address => NetworkMember) public network;
244 
245     /// @title Token Pools
246     /// @notice each manufacturer will manage a pool of tokens for reputation rewards
247     /// @dev Key is ethereum account for pool owner
248     /// @dev Value is struct representing token pool attributes
249     /// @dev incoming tokens will come from registrations, activations, or public donations
250     /// @dev outgoing tokens will come from reputation rewards
251     mapping (address => TokenPool) public pools;
252 
253     /// @title Reward Balances
254     /// @notice balances of rewards that are able to be claimed by participants
255     /// @dev Key is ethereum account of the owner of the tokens
256     /// @dev Value is tokens available for withdraw
257     mapping (address => uint256) public rewards;
258 
259     /// @title Lookup by Manufacturer ID the wallet for reputation rewards
260     /// @dev Key is the manufacturer id
261     /// @dev Value is ethereum account to be rewarded
262     mapping (bytes32 => address) public manufacturerRewards;
263 
264     /// @title Track last write by reputation author
265     /// @dev First key is the ethereum address of the reputation author
266     /// @dev Second key is the device id
267     /// @dev Value is the block number of the last time the author has submitted a score for the device
268     mapping (address => mapping (bytes32 => uint256)) public authorWrites;
269 
270     /// @title Default Repuration score for manufacturers
271     /// @dev Key is the manufacturer id
272     /// @dev value is the score to use for newly registered devices
273     mapping (bytes32 => bytes32) public defaultManufacturerReputations;
274 
275     ///
276     /// TYPES 
277     ///
278     /// @title Atonomi Device
279     /// @notice Contains the device state on the Atonomi network
280     /// @dev manufacturerId is the manufacturer the device belongs to
281     /// @dev deviceType is the type of device categorized by the manufacturer
282     /// @dev registered is true when device is registered, otherwise false
283     /// @dev activated is true when device is activated, otherwise false
284     /// @dev reputationScore is official Atonomi Reputation score for the device
285     /// @dev devicePublicKey is public key used by IRN Nodes for validation
286     struct Device {
287         bytes32 manufacturerId;
288         bytes32 deviceType;
289         bool registered;
290         bool activated;
291         bytes32 reputationScore;
292         bytes32 devicePublicKey;
293     }
294 
295     /// @title Token Pool
296     /// @notice Contains balance and reputation reward amounts for each token pool
297     /// @dev balance is total amount of tokens available in the pool
298     /// @dev rewardAmount is the total amount distributed between the manufacturer and reputation author
299     struct TokenPool {
300         uint256 balance;
301         uint256 rewardAmount;
302     }
303 
304     /// @title Atonomi Network Participant
305     /// @notice Contains role information for a participant
306     /// @dev isIRNAdmin is true if participant is an IRN Admin, otherwise false
307     /// @dev isManufacturer is true if participant is a Manufacturer, otherwise false
308     /// @dev isIRNNode is true if participant is an IRN Node, otherwise false
309     /// @dev memberId is the manufacturer id, for all other participants this will be 0
310     struct NetworkMember {
311         bool isIRNAdmin;
312         bool isManufacturer;
313         bool isIRNNode;
314         bytes32 memberId;
315     }
316 
317     ///
318     /// MODIFIERS
319     ///
320     /// @notice only manufacturers can call, otherwise throw
321     modifier onlyManufacturer() {
322         require(network[msg.sender].isManufacturer, "must be a manufacturer");
323         _;
324     }
325 
326     /// @notice only IRNAdmins or Owner can call, otherwise throw
327     modifier onlyIRNorOwner() {
328         require(msg.sender == owner || network[msg.sender].isIRNAdmin, "must be owner or an irn admin");
329         _;
330     }
331 
332     /// @notice only IRN Nodes can call, otherwise throw
333     modifier onlyIRNNode() {
334         require(network[msg.sender].isIRNNode, "must be an irn node");
335         _;
336     }
337 
338     /// @notice Constructor sets the ERC Token contract and initial values for network fees
339     /// @param _token is the Atonomi Token contract address (must be ERC20)
340     /// @param _settings is the Atonomi Network Settings contract address
341     constructor (
342         address _token,
343         address _settings) public {
344         require(_token != address(0), "token address cannot be 0x0");
345         require(_settings != address(0), "settings address cannot be 0x0");
346         token = ERC20Interface(_token);
347         settings = SettingsInterface(_settings);
348     }
349 
350     ///
351     /// EVENTS 
352     ///
353     /// @notice emitted on successful device registration
354     /// @param _sender manufacturer paying for registration
355     /// @param _fee registration fee paid by manufacturer
356     /// @param _deviceHashKey keccak256 hash of device id used as the key in devices mapping
357     /// @param _manufacturerId of the manufacturer the device belongs to
358     /// @param _deviceType is the type of device categorized by the manufacturer
359     event DeviceRegistered(
360         address indexed _sender,
361         uint256 _fee,
362         bytes32 indexed _deviceHashKey,
363         bytes32 indexed _manufacturerId,
364         bytes32 _deviceType
365     );
366 
367     /// @notice emitted on successful device activation
368     /// @param _sender manufacturer or device owner paying for activation
369     /// @param _fee registration fee paid by manufacturer
370     /// @param _deviceId the real device id (only revealed after activation)
371     /// @param _manufacturerId of the manufacturer the device belongs to
372     /// @param _deviceType is the type of device categorized by the manufacturer
373     event DeviceActivated(
374         address indexed _sender,
375         uint256 _fee,
376         bytes32 indexed _deviceId,
377         bytes32 indexed _manufacturerId,
378         bytes32 _deviceType
379     );
380 
381     /// @notice emitted on reputation change for a device
382     /// @param _deviceId device id of the target device
383     /// @param _deviceType is the type of device categorized by the manufacturer
384     /// @param _newScore updated reputation score
385     /// @param _irnNode IRN node submitting the new reputation
386     /// @param _irnReward tokens awarded to irn node
387     /// @param _manufacturerWallet manufacturer associated with the device is rewared a share of tokens
388     /// @param _manufacturerReward tokens awarded to contributor
389     event ReputationScoreUpdated(
390         bytes32 indexed _deviceId,
391         bytes32 _deviceType,
392         bytes32 _newScore,
393         address indexed _irnNode,
394         uint256 _irnReward,
395         address indexed _manufacturerWallet,
396         uint256 _manufacturerReward
397     );
398 
399     /// @notice emitted on successful addition of network member address
400     /// @param _sender ethereum account of participant that made the change
401     /// @param _member address of added member
402     /// @param _memberId manufacturer id for manufacturer, otherwise 0x0
403     event NetworkMemberAdded(
404         address indexed _sender,
405         address indexed _member,
406         bytes32 indexed _memberId
407     );
408 
409     /// @notice emitted on successful removal of network member address
410     /// @param _sender ethereum account of participant that made the change
411     /// @param _member address of removed member
412     /// @param _memberId manufacturer id for manufacturer, otherwise 0x0
413     event NetworkMemberRemoved(
414         address indexed _sender,
415         address indexed _member,
416         bytes32 indexed _memberId
417     );
418 
419     /// @notice emitted everytime a manufacturer changes their wallet for rewards
420     /// @param _old ethereum account
421     /// @param _new ethereum account
422     /// @param _manufacturerId that the member belongs to
423     event ManufacturerRewardWalletChanged(
424         address indexed _old,
425         address indexed _new,
426         bytes32 indexed _manufacturerId
427     );
428 
429     /// @notice emitted everytime a token pool reward amount changes
430     /// @param _sender ethereum account of the token pool owner
431     /// @param _newReward new reward value in ATMI tokens
432     event TokenPoolRewardUpdated(
433         address indexed _sender,
434         uint256 _newReward
435     );
436 
437     /// @notice emitted everytime someone donates tokens to a manufacturer
438     /// @param _sender ethereum account of the donater
439     /// @param _manufacturerId of the manufacturer
440     /// @param _manufacturer ethereum account
441     /// @param _amount of tokens deposited
442     event TokensDeposited(
443         address indexed _sender,
444         bytes32 indexed _manufacturerId,
445         address indexed _manufacturer,
446         uint256 _amount
447     );
448     
449     /// @notice emitted everytime a participant withdraws from token pool
450     /// @param _sender ethereum account of participant that made the change
451     /// @param _amount tokens withdrawn
452     event TokensWithdrawn(
453         address indexed _sender,
454         uint256 _amount
455     );
456 
457     /// @notice emitted everytime the default reputation for a manufacturer changes
458     /// @param _sender ethereum account of participant that made the change
459     /// @param _manufacturerId of the manufacturer
460     /// @param _newDefaultScore to use for newly registered devices
461     event DefaultReputationScoreChanged(
462         address indexed _sender,
463         bytes32 indexed _manufacturerId,
464         bytes32 _newDefaultScore
465     );
466 
467     ///
468     /// DEVICE ONBOARDING
469     ///
470     /// @notice registers device on the Atonomi network
471     /// @param _deviceIdHash keccak256 hash of the device's id (needs to be hashed by caller)
472     /// @param _deviceType is the type of device categorized by the manufacturer
473     /// @dev devicePublicKey is public key used by IRN Nodes for validation
474     /// @return true if successful, otherwise false
475     /// @dev msg.sender is expected to be the manufacturer
476     /// @dev tokens will be deducted from the manufacturer and added to the token pool
477     /// @dev owner has ability to pause this operation
478     function registerDevice(
479         bytes32 _deviceIdHash,
480         bytes32 _deviceType,
481         bytes32 _devicePublicKey)
482         public onlyManufacturer whenNotPaused returns (bool)
483     {
484         uint256 registrationFee = settings.registrationFee();
485         Device memory d = _registerDevice(msg.sender, _deviceIdHash, _deviceType, _devicePublicKey);
486         emit DeviceRegistered(
487             msg.sender,
488             registrationFee,
489             _deviceIdHash,
490             d.manufacturerId,
491             _deviceType);
492         _depositTokens(msg.sender, registrationFee);
493         require(token.transferFrom(msg.sender, address(this), registrationFee), "transferFrom failed");
494         return true;
495     }
496 
497     /// @notice Activates the device
498     /// @param _deviceId id of the real device id to be activated (not the hash of the device id)
499     /// @return true if successful, otherwise false
500     /// @dev if the hash doesnt match, the device is considered not registered and will throw
501     /// @dev anyone with the device id (in hand) is considered the device owner
502     /// @dev tokens will be deducted from the device owner and added to the token pool
503     /// @dev owner has ability to pause this operation
504     function activateDevice(bytes32 _deviceId) public whenNotPaused returns (bool) {
505         uint256 activationFee = settings.activationFee();
506         Device memory d = _activateDevice(_deviceId);
507         emit DeviceActivated(msg.sender, activationFee, _deviceId, d.manufacturerId, d.deviceType);
508         address manufacturer = manufacturerRewards[d.manufacturerId];
509         require(manufacturer != address(this), "manufacturer is unknown");
510         _depositTokens(manufacturer, activationFee);
511         require(token.transferFrom(msg.sender, address(this), activationFee), "transferFrom failed");
512         return true;
513     }
514 
515     /// @notice Registers and immediately activates device, used by manufacturers to prepay activation
516     /// @param _deviceId id of the real device id to be activated (not the has of the device id)
517     /// @param _deviceType is the type of device categorized by the manufacturer
518     /// @return true if successful, otherwise false
519     /// @dev since the manufacturer is trusted, no need for the caller to hash the device id
520     /// @dev msg.sender is expected to be the manufacturer
521     /// @dev tokens will be deducted from the manufacturer and added to the token pool
522     /// @dev owner has ability to pause this operation
523     function registerAndActivateDevice(
524         bytes32 _deviceId,
525         bytes32 _deviceType,
526         bytes32 _devicePublicKey) 
527         public onlyManufacturer whenNotPaused returns (bool)
528     {
529         uint256 registrationFee = settings.registrationFee();
530         uint256 activationFee = settings.activationFee();
531 
532         bytes32 deviceIdHash = keccak256(_deviceId);
533         Device memory d = _registerDevice(msg.sender, deviceIdHash, _deviceType, _devicePublicKey);
534         bytes32 manufacturerId = d.manufacturerId;
535         emit DeviceRegistered(msg.sender, registrationFee, deviceIdHash, manufacturerId, _deviceType);
536 
537         d = _activateDevice(_deviceId);
538         emit DeviceActivated(msg.sender, activationFee, _deviceId, manufacturerId, _deviceType);
539 
540         uint256 fee = registrationFee.add(activationFee);
541         _depositTokens(msg.sender, fee);
542         require(token.transferFrom(msg.sender, address(this), fee), "transferFrom failed");
543         return true;
544     }
545 
546     ///
547     /// REPUTATION MANAGEMENT
548     ///
549     /// @notice updates reputation for a device
550     /// @param _deviceId target device Id
551     /// @param _reputationScore updated reputation score computed by the author
552     /// @return true if successful, otherwise false
553     /// @dev msg.sender is expected to be the reputation author (either irn node or the reputation auditor)
554     /// @dev tokens will be deducted from the contract pool
555     /// @dev author and manufacturer will be rewarded a split of the tokens
556     /// @dev owner has ability to pause this operation
557     function updateReputationScore(
558         bytes32 _deviceId,
559         bytes32 _reputationScore)
560         public onlyIRNNode whenNotPaused returns (bool)
561     {
562         Device memory d = _updateReputationScore(_deviceId, _reputationScore);
563 
564         address _manufacturerWallet = manufacturerRewards[d.manufacturerId];
565         require(_manufacturerWallet != address(0), "_manufacturerWallet cannot be 0x0");
566         require(_manufacturerWallet != msg.sender, "manufacturers cannot collect the full reward");
567 
568         uint256 irnReward;
569         uint256 manufacturerReward;
570         (irnReward, manufacturerReward) = getReputationRewards(msg.sender, _manufacturerWallet, _deviceId);
571         _distributeRewards(_manufacturerWallet, msg.sender, irnReward);
572         _distributeRewards(_manufacturerWallet, _manufacturerWallet, manufacturerReward);
573         emit ReputationScoreUpdated(
574             _deviceId,
575             d.deviceType,
576             _reputationScore,
577             msg.sender,
578             irnReward,
579             _manufacturerWallet,
580             manufacturerReward);
581         authorWrites[msg.sender][_deviceId] = block.number;
582         return true;
583     }
584 
585     /// @notice computes the portion of the reputation reward allotted to the manufacturer and author
586     /// @param author is the reputation node submitting the score
587     /// @param manufacturer is the token pool owner
588     /// @param deviceId of the device being updated
589     /// @return irnReward and manufacturerReward
590     function getReputationRewards(
591         address author,
592         address manufacturer,
593         bytes32 deviceId)
594         public view returns (uint256 irnReward, uint256 manufacturerReward)
595     {
596         uint256 lastWrite = authorWrites[author][deviceId];
597         uint256 blocks = 0;
598         if (lastWrite > 0) {
599             blocks = block.number.sub(lastWrite);
600         }
601         uint256 totalRewards = calculateReward(pools[manufacturer].rewardAmount, blocks);
602         irnReward = totalRewards.mul(settings.reputationIRNNodeShare()).div(100);
603         manufacturerReward = totalRewards.sub(irnReward);
604     }
605 
606     /// @notice computes total reward based on the authors last submission
607     /// @param rewardAmount total amount available for reward
608     /// @param blocksSinceLastWrite number of blocks since last write
609     /// @return actual reward available
610     function calculateReward(uint256 rewardAmount, uint256 blocksSinceLastWrite) public view returns (uint256) {
611         uint256 totalReward = rewardAmount;
612         uint256 blockThreshold = settings.blockThreshold();
613         if (blocksSinceLastWrite > 0 && blocksSinceLastWrite < blockThreshold) {
614             uint256 multiplier = 10 ** uint256(token.decimals());
615             totalReward = rewardAmount.mul(blocksSinceLastWrite.mul(multiplier)).div(blockThreshold.mul(multiplier));
616         }
617         return totalReward;
618     }
619 
620     ///
621     /// BULK OPERATIONS
622     ///
623     /// @notice registers multiple devices on the Atonomi network
624     /// @param _deviceIdHashes array of keccak256 hashed ID's of each device
625     /// @param _deviceTypes array of types of device categorized by the manufacturer
626     /// @param _devicePublicKeys array of public keys associated with the devices
627     /// @return true if successful, otherwise false
628     /// @dev msg.sender is expected to be the manufacturer
629     /// @dev tokens will be deducted from the manufacturer and added to the token pool
630     /// @dev owner has ability to pause this operation
631     function registerDevices(
632         bytes32[] _deviceIdHashes,
633         bytes32[] _deviceTypes,
634         bytes32[] _devicePublicKeys)
635         public onlyManufacturer whenNotPaused returns (bool)
636     {
637         require(_deviceIdHashes.length > 0, "at least one device is required");
638         require(
639             _deviceIdHashes.length == _deviceTypes.length,
640             "device type array needs to be same size as devices"
641         );
642         require(
643             _deviceIdHashes.length == _devicePublicKeys.length,
644             "device public key array needs to be same size as devices"
645         );
646 
647         uint256 runningBalance = 0;
648         uint256 registrationFee = settings.registrationFee();
649         for (uint256 i = 0; i < _deviceIdHashes.length; i++) {
650             bytes32 deviceIdHash = _deviceIdHashes[i];
651             bytes32 deviceType = _deviceTypes[i];
652             bytes32 devicePublicKey = _devicePublicKeys[i];
653             Device memory d = _registerDevice(msg.sender, deviceIdHash, deviceType, devicePublicKey);
654             emit DeviceRegistered(msg.sender, registrationFee, deviceIdHash, d.manufacturerId, deviceType);
655 
656             runningBalance = runningBalance.add(registrationFee);
657         }
658 
659         _depositTokens(msg.sender, runningBalance);
660         require(token.transferFrom(msg.sender, address(this), runningBalance), "transferFrom failed");
661         return true;
662     }
663 
664     ///
665     /// WHITELIST PARTICIPANT MANAGEMENT
666     ///
667     /// @notice add a member to the network
668     /// @param _member ethereum address of member to be added
669     /// @param _isIRNAdmin true if an irn admin, otherwise false
670     /// @param _isManufacturer true if an manufactuter, otherwise false
671     /// @param _memberId manufacturer id for manufacturers, otherwise 0x0
672     /// @return true if successful, otherwise false
673     /// @dev _memberId is only relevant for manufacturer, but is flexible to allow use for other purposes
674     /// @dev msg.sender is expected to be either owner or irn admin
675     function addNetworkMember(
676         address _member,
677         bool _isIRNAdmin,
678         bool _isManufacturer,
679         bool _isIRNNode,
680         bytes32 _memberId)
681         public onlyIRNorOwner returns(bool)
682     {
683         NetworkMember storage m = network[_member];
684         require(!m.isIRNAdmin, "already an irn admin");
685         require(!m.isManufacturer, "already a manufacturer");
686         require(!m.isIRNNode, "already an irn node");
687         require(m.memberId == 0, "already assigned a member id");
688 
689         m.isIRNAdmin = _isIRNAdmin;
690         m.isManufacturer = _isManufacturer;
691         m.isIRNNode = _isIRNNode;
692         m.memberId = _memberId;
693 
694         if (m.isManufacturer) {
695             require(_memberId != 0, "manufacturer id is required");
696 
697             // keep lookup for rewards in sync
698             require(manufacturerRewards[m.memberId] == address(0), "manufacturer is already assigned");
699             manufacturerRewards[m.memberId] = _member;
700 
701             // set reputation reward if token pool doesnt exist
702             if (pools[_member].rewardAmount == 0) {
703                 pools[_member].rewardAmount = settings.defaultReputationReward();
704             }
705         }
706 
707         emit NetworkMemberAdded(msg.sender, _member, _memberId);
708 
709         return true;
710     }
711 
712     /// @notice remove a member from the network
713     /// @param _member ethereum address of member to be removed
714     /// @return true if successful, otherwise false
715     /// @dev msg.sender is expected to be either owner or irn admin
716     function removeNetworkMember(address _member) public onlyIRNorOwner returns(bool) {
717         bytes32 memberId = network[_member].memberId;
718         if (network[_member].isManufacturer) {
719             // remove token pool if there is a zero balance
720             if (pools[_member].balance == 0) {
721                 delete pools[_member];
722             }
723 
724             // keep lookup with rewards in sync
725             delete manufacturerRewards[memberId];
726         }
727 
728         delete network[_member];
729 
730         emit NetworkMemberRemoved(msg.sender, _member, memberId);
731         return true;
732     }
733 
734     //
735     // TOKEN POOL MANAGEMENT
736     //
737     /// @notice changes the ethereum wallet for a manufacturer used in reputation rewards
738     /// @param _new new ethereum account
739     /// @return true if successful, otherwise false
740     /// @dev msg.sender is expected to be original manufacturer account
741     function changeManufacturerWallet(address _new) public onlyManufacturer returns (bool) {
742         require(_new != address(0), "new address cannot be 0x0");
743 
744         NetworkMember memory old = network[msg.sender];
745         require(old.isManufacturer && old.memberId != 0, "must be a manufacturer");
746 
747         // copy permissions
748         require(!network[_new].isIRNAdmin, "already an irn admin");
749         require(!network[_new].isManufacturer, "already a manufacturer");
750         require(!network[_new].isIRNNode, "already an irn node");
751         require(network[_new].memberId == 0, "memberId already exists");
752         network[_new] = NetworkMember(
753             old.isIRNAdmin,
754             old.isManufacturer,
755             old.isIRNNode,
756             old.memberId
757         );
758 
759         // transfer balance from old pool to the new pool
760         require(pools[_new].balance == 0 && pools[_new].rewardAmount == 0, "new token pool already exists");
761         pools[_new].balance = pools[msg.sender].balance;
762         pools[_new].rewardAmount = pools[msg.sender].rewardAmount;
763         delete pools[msg.sender];
764 
765         // update reward mapping
766         manufacturerRewards[old.memberId] = _new;
767 
768         // delete old member
769         delete network[msg.sender];
770 
771         emit ManufacturerRewardWalletChanged(msg.sender, _new, old.memberId);
772         return true;
773     }
774 
775     /// @notice allows a token pool owner to set a new reward amount
776     /// @param newReward new reputation reward amount
777     /// @return true if successful, otherwise false
778     /// @dev msg.sender expected to be manufacturer
779     function setTokenPoolReward(uint256 newReward) public onlyManufacturer returns (bool) {
780         require(newReward != 0, "newReward is required");
781 
782         TokenPool storage p = pools[msg.sender];
783         require(p.rewardAmount != newReward, "newReward should be different");
784 
785         p.rewardAmount = newReward;
786         emit TokenPoolRewardUpdated(msg.sender, newReward);
787         return true;
788     }
789 
790     /// @notice anyone can donate tokens to a manufacturer's pool
791     /// @param manufacturerId of the manufacturer to receive the tokens
792     /// @param amount of tokens to deposit
793     function depositTokens(bytes32 manufacturerId, uint256 amount) public returns (bool) {
794         require(manufacturerId != 0, "manufacturerId is required");
795         require(amount > 0, "amount is required");
796 
797         address manufacturer = manufacturerRewards[manufacturerId];
798         require(manufacturer != address(0));
799 
800         _depositTokens(manufacturer, amount);
801         emit TokensDeposited(msg.sender, manufacturerId, manufacturer, amount);
802 
803         require(token.transferFrom(msg.sender, address(this), amount));
804         return true;
805     }
806 
807     /// @notice allows participants in the Atonomi network to claim their rewards
808     /// @return true if successful, otherwise false
809     /// @dev owner has ability to pause this operation
810     function withdrawTokens() public whenNotPaused returns (bool) {
811         uint256 amount = rewards[msg.sender];
812         require(amount > 0, "amount is zero");
813 
814         rewards[msg.sender] = 0;
815         emit TokensWithdrawn(msg.sender, amount);
816 
817         require(token.transfer(msg.sender, amount), "token transfer failed");
818         return true;
819     }
820 
821     /// @notice allows the owner to change the default reputation for manufacturers
822     /// @param _manufacturerId of the manufacturer
823     /// @param _newDefaultScore to use for newly registered devices
824     /// @return true if successful, otherwise false
825     /// @dev owner is the only one with this feature
826     function setDefaultReputationForManufacturer(
827         bytes32 _manufacturerId,
828         bytes32 _newDefaultScore) public onlyOwner returns (bool) {
829         require(_manufacturerId != 0, "_manufacturerId is required");
830         require(
831             _newDefaultScore != defaultManufacturerReputations[_manufacturerId],
832             "_newDefaultScore should be different"
833         );
834 
835         defaultManufacturerReputations[_manufacturerId] = _newDefaultScore;
836         emit DefaultReputationScoreChanged(msg.sender, _manufacturerId, _newDefaultScore);
837         return true;
838     }
839 
840     ///
841     /// INTERNAL FUNCTIONS
842     ///
843     /// @dev track balances of any deposits going into a token pool
844     function _depositTokens(address _owner, uint256 _amount) internal {
845         pools[_owner].balance = pools[_owner].balance.add(_amount);
846     }
847 
848     /// @dev track balances of any rewards going out of the token pool
849     function _distributeRewards(address _manufacturer, address _owner, uint256 _amount) internal {
850         require(_amount > 0, "_amount is required");
851         pools[_manufacturer].balance = pools[_manufacturer].balance.sub(_amount);
852         rewards[_owner] = rewards[_owner].add(_amount);
853     }
854 
855     /// @dev ensure a device is validated for registration
856     /// @dev updates device registry
857     function _registerDevice(
858         address _manufacturer,
859         bytes32 _deviceIdHash,
860         bytes32 _deviceType,
861         bytes32 _devicePublicKey) internal returns (Device) {
862         require(_manufacturer != address(0), "manufacturer is required");
863         require(_deviceIdHash != 0, "device id hash is required");
864         require(_deviceType != 0, "device type is required");
865         require(_devicePublicKey != 0, "device public key is required");
866 
867         Device storage d = devices[_deviceIdHash];
868         require(!d.registered, "device is already registered");
869         require(!d.activated, "device is already activated");
870 
871         bytes32 manufacturerId = network[_manufacturer].memberId;
872         require(manufacturerId != 0, "manufacturer id is unknown");
873 
874         d.manufacturerId = manufacturerId;
875         d.deviceType = _deviceType;
876         d.registered = true;
877         d.activated = false;
878         d.reputationScore = defaultManufacturerReputations[manufacturerId];
879         d.devicePublicKey = _devicePublicKey;
880         return d;
881     }
882 
883     /// @dev ensure a device is validated for activation
884     /// @dev updates device registry
885     function _activateDevice(bytes32 _deviceId) internal returns (Device) {
886         bytes32 deviceIdHash = keccak256(_deviceId);
887         Device storage d = devices[deviceIdHash];
888         require(d.registered, "not registered");
889         require(!d.activated, "already activated");
890         require(d.manufacturerId != 0, "no manufacturer id was found");
891 
892         d.activated = true;
893         return d;
894     }
895 
896     /// @dev ensure a device is validated for a new reputation score
897     /// @dev updates device registry
898     function _updateReputationScore(bytes32 _deviceId, bytes32 _reputationScore) internal returns (Device) {
899         require(_deviceId != 0, "device id is empty");
900 
901         Device storage d = devices[keccak256(_deviceId)];
902         require(d.registered, "not registered");
903         require(d.activated, "not activated");
904         require(d.reputationScore != _reputationScore, "new score needs to be different");
905 
906         d.reputationScore = _reputationScore;
907         return d;
908     }
909 }