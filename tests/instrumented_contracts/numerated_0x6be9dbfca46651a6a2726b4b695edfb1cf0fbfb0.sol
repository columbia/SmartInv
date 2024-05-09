1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 contract Escrow {
7     using SafeMath for uint256;
8     using ContentUtils for ContentUtils.ContentMapping;
9 
10     ContentUtils.ContentMapping public content;
11     address escrowAddr = address(this);
12 
13     uint256 public claimable = 0; 
14     uint256 public currentBalance = 0; 
15     mapping(bytes32 => uint256) public claimableRewards;
16 
17     /// @notice valid reward and user has enough funds
18     modifier validReward(uint256 _reward) {
19         require(_reward > 0 && _depositEscrow(_reward));
20         _;
21     }
22 
23     /// @notice complete deliverable by making reward amount claimable
24     function completeDeliverable(bytes32 _id, address _creator, address _brand) internal returns(bool) {
25         require(content.isFulfilled(_id, _creator, _brand));
26         content.completeDeliverable(_id);
27         return _approveEscrow(_id, content.rewardOf(_id));       
28     }
29 
30     /// @notice update current balance, if proper token amount approved
31     function _depositEscrow(uint256 _amount) internal returns(bool) {
32         currentBalance = currentBalance.add(_amount);
33         return true;
34     }
35 
36     /// @notice approve reward amount for transfer from escrow contract to creator
37     function _approveEscrow(bytes32 _id, uint256 _amount) internal returns(bool) {
38         claimable = claimable.add(_amount);
39         claimableRewards[_id] = _amount;
40         return true;
41     }
42 
43     function getClaimableRewards(bytes32 _id) public returns(uint256) {
44         return claimableRewards[_id];
45     }
46 
47     function getContentByName(string _name) public view returns(
48         string name,
49         string description,
50         uint reward,
51         uint addedOn) 
52     {
53         var (_content, exist) = content.getContentByName(_name);
54         if (exist) {
55             return (_content.name, _content.description, _content.deliverable.reward, _content.addedOn);
56         } else {
57             return ("", "", 0, 0);
58         }
59     }
60 
61     function currentFulfillment(string _name) public view returns(bool fulfillment) {
62         var (_content, exist) = content.getContentByName(_name);
63         if (exist) {
64             return _content.deliverable.fulfillment[msg.sender];
65         } else {
66             false;
67         }
68     }
69 }
70 
71 
72 
73 
74 
75 /**
76  * @title SafeMath
77  * @dev Math operations with safety checks that throw on error
78  */
79 library SafeMath {
80 
81   /**
82   * @dev Multiplies two numbers, throws on overflow.
83   */
84   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
86     // benefit is lost if 'b' is also tested.
87     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88     if (a == 0) {
89       return 0;
90     }
91 
92     c = a * b;
93     assert(c / a == b);
94     return c;
95   }
96 
97   /**
98   * @dev Integer division of two numbers, truncating the quotient.
99   */
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     // uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return a / b;
105   }
106 
107   /**
108   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109   */
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   /**
116   * @dev Adds two numbers, throws on overflow.
117   */
118   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
119     c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 
126 
127 
128 
129 
130 
131 
132 library DeliverableUtils {
133 
134     struct Deliverable {
135         uint256 reward;
136         mapping(address=>bool) fulfillment;
137         bool fulfilled;
138     }
139 
140     /// @notice msg.sender can be creator or brand and mark their delivery or approval, returns check if completely Fulfilled
141     function fulfill(Deliverable storage self, address _creator, address _brand) internal returns(bool) {
142         require(msg.sender == _creator || msg.sender == _brand);
143         self.fulfillment[msg.sender] = true;
144         return self.fulfillment[_creator] && self.fulfillment[_brand];
145     }
146 
147     /// @notice check if deliverable fulfilled completely
148     function isFulfilled(Deliverable storage self, address _creator, address _brand) internal view returns(bool) {
149         return self.fulfillment[_creator] && self.fulfillment[_brand];
150     }
151 
152     /// @notice return new deliverable struct if reward greater than 0
153     function newDeliverable(uint256 _reward) internal pure returns(Deliverable _deliverable) {
154         require(_reward > 0);
155         return Deliverable(_reward, false);
156     }
157 }
158 
159 library ContentUtils {
160     using SafeMath for uint256;
161     using DeliverableUtils for DeliverableUtils.Deliverable;
162 
163     struct Content {
164         bytes32 id;
165         string name;
166         string description;
167         uint addedOn;
168         DeliverableUtils.Deliverable deliverable;
169     }
170 
171     /// @notice utility for mapping bytes32=>Content. Keys must be unique. It can be updated until it is locked.
172     struct ContentMapping {
173         mapping(bytes32=>Content) data;
174         bytes32[] keys;
175         bool locked;
176     }
177 
178     string constant UNIQUE_KEY_ERR = "Content with ID already exists ";
179     string constant KEY_NOT_FOUND_ERR = "Key not found";
180 
181     /// @notice put item into mapping
182     function put(ContentMapping storage self, 
183         string _name, 
184         string _description, 
185         uint _reward) public returns (bool) 
186     {
187             require(!self.locked);
188 
189             bytes32 _id = generateContentID(_name);
190             require(self.data[_id].id == bytes32(0));
191 
192             self.data[_id] = Content(_id, _name, _description, block.timestamp, DeliverableUtils.newDeliverable(_reward));
193             self.keys.push(_id);
194             return true;
195     }
196     
197     /// @notice get amount of items in mapping
198     function size(ContentMapping storage self) public view returns (uint) {
199         return self.keys.length;
200     }
201 
202     /// @notice return reward of content delivarable
203     function rewardOf(ContentMapping storage self, bytes32 _id) public view returns (uint256) {
204         return self.data[_id].deliverable.reward;
205     }
206 
207     function getKey(ContentMapping storage self, uint _index) public view returns (bytes32) {
208         isValidIndex(_index, self.keys.length);
209         return self.keys[_index];
210     }
211 
212     /// @notice get content by plain string name
213     function getContentByName(ContentMapping storage self, string _name) public view returns (Content storage _content, bool exists) {
214         bytes32 _hash = generateContentID(_name);
215         return (self.data[_hash], self.data[_hash].addedOn != 0);
216     }
217 
218     /// @notice get content by sha3 ID hash
219     function getContentByID(ContentMapping storage self, bytes32 _id) public view returns (Content storage _content, bool exists) {
220         return (self.data[_id], self.data[_id].id == bytes32(0));
221     }
222 
223     /// @notice get content by _index into key array 
224     function getContentByKeyIndex(ContentMapping storage self, uint _index) public view returns (Content storage _content) {
225         isValidIndex(_index, self.keys.length);
226         return (self.data[self.keys[_index]]);
227     }
228 
229     /// @notice wrapper around internal deliverable method
230     function fulfill(ContentMapping storage self, bytes32 _id, address _creator, address _brand) public returns(bool) {
231         return self.data[_id].deliverable.fulfill(_creator, _brand);
232     }
233 
234     /// @notice wrapper around internal deliverable method
235     function isFulfilled(ContentMapping storage self, bytes32 _id, address _creator, address _brand) public view returns(bool) {
236         return self.data[_id].deliverable.isFulfilled(_creator, _brand);
237     }
238 
239     /// @notice marks deliverable as fulfilled
240     function completeDeliverable(ContentMapping storage self, bytes32 _id) internal returns(bool) {
241         self.data[_id].deliverable.fulfilled = true;
242         return true;
243     }
244 
245     /// @notice get sha256 hash of name for content ID
246     function generateContentID(string _name) public pure returns (bytes32) {
247         return keccak256(_name);
248     }
249 
250     /// @notice index not out of bounds
251     function isValidIndex(uint _index, uint _size) public pure {
252         require(_index < _size, KEY_NOT_FOUND_ERR);
253     }
254 }
255 
256 
257 
258 contract Agreement is Escrow {
259     
260     bool public locked;
261     uint  public createdOn;
262     uint public expiration;
263     uint public startTime;
264     address public brand;
265     address public creator;
266     
267     constructor(address _creator, uint _expiration, address _token) public {
268         brand = msg.sender;
269         creator = _creator;
270         expiration = _expiration;
271     }
272 
273     /// @notice only brand is authorized
274     modifier onlyBrand() {
275         require(msg.sender == brand);
276         _;
277     }
278 
279     /// @notice only creator is authorized
280     modifier onlyCreator() {
281         require(msg.sender == creator);
282         _;
283     }
284 
285     /// @notice deliverable fulfilled
286     modifier fulfilled(bytes32 _id) {
287         require(content.isFulfilled(_id, creator, brand));
288         _;
289     }
290 
291     /// @notice agreement expired, refunds remaining balance in escrow
292     modifier expired() {
293         require(block.timestamp > expiration);
294         _;
295     }
296 
297     /// @notice agreement not expired, refunds remaining balance in escrow
298     modifier notExpired() {
299         require(block.timestamp < expiration);
300         _;
301     }
302 
303     /// @notice agreement not locked
304     modifier notLocked() {
305         require(!locked);
306         _;
307     }
308 
309     /// @notice add content to the agreement
310     function addContent(string _name, 
311         string _description, 
312         uint _reward) notLocked onlyBrand validReward(_reward) 
313         public returns(bool _success) {
314             return content.put(_name, _description, _reward);
315     }
316 
317     function _fulfill(bytes32 _id) private returns (bool) {
318         bool _fulfilled = content.fulfill(_id, creator, brand);
319         if(_fulfilled) {
320             return completeDeliverable(_id, creator, brand);
321         }
322 
323         return false;
324     }
325 
326     function fulfillDeliverable(bytes32 _id) notExpired onlyCreator public returns (bool) {
327         return _fulfill(_id);
328     }
329 
330     function approveDeliverable(bytes32 _id) onlyBrand public returns (bool) {
331         return _fulfill(_id);
332     }
333     
334     function claim(bytes32 _id) external onlyCreator {
335         claimableRewards[_id] = 0;
336     }
337 
338 
339     function lock() onlyBrand public {
340         content.locked == true;
341         locked = true;
342         startTime = block.timestamp;
343     }
344 
345     function extendExpiration(uint _expiration) onlyBrand public returns (bool) {
346         require(_expiration > expiration && _expiration >= block.timestamp);
347         expiration = _expiration;
348         return true;
349     }
350 
351     function destroy() onlyBrand expired public {
352         selfdestruct(msg.sender);
353     }
354 
355     function deposit() payable {}
356 }
357 
358 /**
359  * @title ERC20 interface
360  */
361 contract ERC20 {
362     uint public totalSupply;
363 
364     function balanceOf(address who) constant returns (uint);
365 
366     function allowance(address owner, address spender) constant returns (uint);
367 
368     function transfer(address to, uint value) returns (bool ok);
369 
370     function transferFrom(address from, address to, uint value) returns (bool ok);
371 
372     function approve(address spender, uint value) returns (bool ok);
373 
374     event Transfer(address indexed from, address indexed to, uint value);
375     event Approval(address indexed owner, address indexed spender, uint value);
376 }
377 
378 
379 /**
380  * @title Ownable
381  * @dev The Ownable contract has an owner address, and provides basic authorization control
382  * functions, this simplifies the implementation of "user permissions".
383  */
384 contract Ownable {
385     address public owner;
386 
387     function Ownable() {
388         owner = msg.sender;
389     }
390 
391     function transferOwnership(address newOwner) onlyOwner {
392         if (newOwner != address(0))
393             owner = newOwner;
394     }
395 
396     function kill() {
397         if (msg.sender == owner)
398             selfdestruct(owner);
399     }
400 
401     modifier onlyOwner() {
402         if (msg.sender == owner)
403             _;
404     }
405 }
406 
407 // Token Contract
408 contract CCOIN is ERC20, Ownable {
409 
410     struct Escrow {
411         address creator;
412         address brand;
413         address agreementContract;
414         uint256 reward;
415     }
416 
417     // Public variables of the token
418     string public constant name = "CCOIN";
419     string public constant symbol = "CCOIN";
420     uint public constant decimals = 18;
421     uint public totalSupply = 1000000000 * 10 ** 18;
422     bool public locked;
423 
424     address public multisigETH; // SafeMath.multisig contract that will receive the ETH
425     address public crowdSaleaddress; // Crowdsale address
426     uint public ethReceived; // Number of ETH received
427     uint public totalTokensSent; // Number of tokens sent to ETH contributors
428     uint public startBlock; // Crowdsale start block
429     uint public endBlock; // Crowdsale end block
430     uint public maxCap; // Maximum number of token to sell
431     uint public minCap; // Minimum number of ETH to raise
432     uint public minContributionETH; // Minimum amount to invest
433     uint public tokenPriceWei;
434 
435     uint firstPeriod;
436     uint secondPeriod;
437     uint thirdPeriod;
438     uint fourthPeriod;
439     uint fifthPeriod;
440     uint firstBonus;
441     uint secondBonus;
442     uint thirdBonus;
443     uint fourthBonus;
444     uint fifthBonus;
445     uint public multiplier;
446 
447     bool public stopInEmergency = false;
448 
449     mapping(address => uint) balances;
450     mapping(address => mapping(address => uint)) allowed;
451     mapping(address => Escrow) escrowAgreements;
452     // Whitelist
453     mapping(address => bool) public whitelisted;
454 
455     event Whitelist(address indexed participant);
456     event Locked();
457     event Unlocked();
458     event StoppedCrowdsale();
459     event RestartedCrowdsale();
460     event Burned(uint256 value);
461 
462     // Lock transfer during the ICO
463     modifier onlyUnlocked() {
464         if (msg.sender != crowdSaleaddress && locked && msg.sender != owner)
465             revert();
466         _;
467     }
468 
469     // @notice to protect short address attack
470     modifier onlyPayloadSize(uint numWords){
471         assert(msg.data.length >= numWords * 32 + 4);
472         _;
473     }
474 
475     modifier onlyAuthorized() {
476         if (msg.sender != crowdSaleaddress && msg.sender != owner)
477             revert();
478         _;
479     }
480 
481     // The Token constructor
482     constructor() public {
483         locked = true;
484         multiplier = 10 ** 18;
485 
486         multisigETH = msg.sender;
487         minContributionETH = 1;
488         startBlock = 0;
489         endBlock = 0;
490         maxCap = 1000 * multiplier;
491         tokenPriceWei = SafeMath.div(1, 1400);
492         minCap = 100 * multiplier;
493         totalTokensSent = 0;
494         firstPeriod = 100;
495         secondPeriod = 200;
496         thirdPeriod = 300;
497         fourthPeriod = 400;
498         fifthPeriod = 500;
499 
500         firstBonus = 120;
501         secondBonus = 115;
502         thirdBonus = 110;
503         fourthBonus = SafeMath.div(1075, 10);
504         fifthBonus = 105;
505         balances[multisigETH] = totalSupply;
506     }
507 
508     function resetCrowdSaleaddress(address _newCrowdSaleaddress) public onlyAuthorized() {
509         crowdSaleaddress = _newCrowdSaleaddress;
510     }
511 
512     function unlock() public onlyAuthorized {
513         locked = false;
514         emit Unlocked();
515     }
516 
517     function lock() public onlyAuthorized {
518         locked = true;
519         emit Locked();
520     }
521 
522     function burn(address _member, uint256 _value) public onlyAuthorized returns (bool) {
523         balances[_member] = SafeMath.sub(balances[_member], _value);
524         totalSupply = SafeMath.sub(totalSupply, _value);
525         emit Transfer(_member, 0x0, _value);
526         emit Burned(_value);
527         return true;
528     }
529 
530     function Airdrop(address _to, uint256 _tokens) external onlyAuthorized returns(bool) {
531         require(transfer(_to, _tokens));
532     } 
533 
534     function transfer(address _to, uint _value) public onlyUnlocked returns (bool) {
535         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
536         balances[_to] = SafeMath.add(balances[_to], _value);
537         emit Transfer(msg.sender, _to, _value);
538         return true;
539     }
540 
541     /* A contract attempts to get the coins */
542     function transferFrom(address _from, address _to, uint256 _value) public onlyUnlocked returns (bool success) {
543         if (balances[_from] < _value)
544             revert();
545         // Check if the sender has enough
546         if (_value > allowed[_from][msg.sender])
547             revert();
548         // Check allowance
549         balances[_from] = SafeMath.sub(balances[_from], _value);
550         // SafeMath.subtract from the sender
551         balances[_to] = SafeMath.add(balances[_to], _value);
552         // SafeMath.add the same to the recipient
553         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
554         emit Transfer(_from, _to, _value);
555         return true;
556     }
557 
558     function balanceOf(address _owner) public constant returns (uint balance) {
559         return balances[_owner];
560     }
561 
562     function approve(address _spender, uint _value) public returns (bool) {
563         allowed[msg.sender][_spender] = _value;
564         emit Approval(msg.sender, _spender, _value);
565         return true;
566     }
567 
568     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
569         return allowed[_owner][_spender];
570     }
571 
572     function withdrawFromEscrow(address _agreementAddr, bytes32 _id) {
573         require(balances[_agreementAddr] > 0);
574         Agreement agreement = Agreement(_agreementAddr);
575         require(agreement.creator() == msg.sender);
576         uint256 reward = agreement.getClaimableRewards(_id);
577         require(reward > 0);
578         balances[_agreementAddr] = SafeMath.sub(balances[_agreementAddr], reward);
579         balances[msg.sender] = SafeMath.add(balances[msg.sender], reward);
580     }
581 
582     function WhitelistParticipant(address participant) external onlyAuthorized {
583         whitelisted[participant] = true;
584         emit Whitelist(participant);
585     }
586 
587     function BlacklistParticipant(address participant) external onlyAuthorized {
588         whitelisted[participant] = false;
589         emit Whitelist(participant);
590     }
591 
592     // {fallback function}
593     // @notice It will call internal function which handles allocation of Ether and calculates tokens.
594     function() public payable onlyPayloadSize(2) {
595         contribute(msg.sender);
596     }
597 
598     // @notice It will be called by fallback function whenever ether is sent to it
599     // @param  _backer {address} address of beneficiary
600     // @return res {bool} true if transaction was successful
601     function contribute(address _backer) internal returns (bool res) {
602         // stop when required minimum is not sent
603         if (msg.value < minContributionETH)
604             revert();
605 
606         // calculate number of tokens
607         uint tokensToSend = calculateNoOfTokensToSend();
608 
609         // Ensure that max cap hasn't been reached
610         if (SafeMath.add(totalTokensSent, tokensToSend) > maxCap)
611             revert();
612 
613         // Transfer tokens to contributor
614         if (!transfer(_backer, tokensToSend))
615             revert();
616 
617         ethReceived = SafeMath.add(ethReceived, msg.value);
618         totalTokensSent = SafeMath.add(totalTokensSent, tokensToSend);
619 
620         return true;
621     }
622 
623     // @notice This function will return number of tokens based on time intervals in the campaign
624     function calculateNoOfTokensToSend() constant internal returns (uint) {
625         uint tokenAmount = SafeMath.div(SafeMath.mul(msg.value, multiplier), tokenPriceWei);
626         if (block.number <= startBlock + firstPeriod)
627             return tokenAmount + SafeMath.div(SafeMath.mul(tokenAmount, firstBonus), 100);
628         else if (block.number <= startBlock + secondPeriod)
629             return tokenAmount + SafeMath.div(SafeMath.mul(tokenAmount, secondBonus), 100);
630         else if (block.number <= startBlock + thirdPeriod)
631             return tokenAmount + SafeMath.div(SafeMath.mul(tokenAmount, thirdBonus), 100);
632         else if (block.number <= startBlock + fourthPeriod)
633             return tokenAmount + SafeMath.div(SafeMath.mul(tokenAmount, fourthBonus), 100);
634         else if (block.number <= startBlock + fifthPeriod)
635             return tokenAmount + SafeMath.div(SafeMath.mul(tokenAmount, fifthBonus), 100);
636         else
637             return tokenAmount;
638     }
639 
640     function stopCrowdsale() external onlyOwner{
641         stopInEmergency = true;
642         emit StoppedCrowdsale();
643     }
644 
645     function restartCrowdsale() external onlyOwner{
646         stopInEmergency = false;
647         emit RestartedCrowdsale();
648     }
649 
650 }