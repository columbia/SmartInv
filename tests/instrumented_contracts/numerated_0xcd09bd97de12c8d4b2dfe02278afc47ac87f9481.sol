1 pragma solidity ^0.5.3;
2 
3 pragma solidity ^0.5.3;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
70 contract ERC721 {
71     // Required methods
72     function totalSupply() public view returns (uint256 total);
73     function balanceOf(address _owner) public view returns (uint256 balance);
74     function ownerOf(uint256 _tokenId) external view returns (address owner);
75     function approve(address _to, uint256 _tokenId) external;
76     function transfer(address _to, uint256 _tokenId) external;
77     function transferFrom(address _from, address _to, uint256 _tokenId) external;
78 
79     // Events
80     event Transfer(address from, address to, uint256 tokenId);
81     event Approval(address owner, address approved, uint256 tokenId);
82 
83     // Optional
84     // function name() public view returns (string name);
85     // function symbol() public view returns (string symbol);
86     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
87     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
88 
89     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
90     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
91 }
92 
93 contract KittyCoreInterface is ERC721  {
94     uint256 public autoBirthFee;
95     address public saleAuction;
96     address public siringAuction;
97     function breedWithAuto(uint256 _matronId, uint256 _sireId) public payable;
98     function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
99     function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
100     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
101 }
102 
103 contract AuctionInterface {
104     function cancelAuction(uint256 _tokenId) external;
105 }
106 
107 contract Ownable {
108   address payable public owner;
109 
110   event OwnershipTransferred(
111     address indexed previousOwner,
112     address indexed newOwner
113   );
114 
115   constructor(address payable _owner) public {
116     if(_owner == address(0)) {
117       owner = msg.sender;
118     } else {
119       owner = _owner;
120     }
121   }
122 
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   function transferOwnership(address payable _newOwner) public onlyOwner {
129     _transferOwnership(_newOwner);
130   }
131 
132   function _transferOwnership(address payable _newOwner) internal {
133     require(_newOwner != address(0));
134     emit OwnershipTransferred(owner, _newOwner);
135     owner = _newOwner;
136   }
137 
138   function destroy() public onlyOwner {
139     selfdestruct(owner);
140   }
141 
142   function destroyAndSend(address payable _recipient) public onlyOwner {
143     selfdestruct(_recipient);
144   }
145 }
146 
147 contract Pausable is Ownable {
148     event Pause();
149     event Unpause();
150 
151     bool public paused = false;
152 
153     constructor(address payable _owner) Ownable(_owner) public {}
154 
155     modifier whenNotPaused() {
156         require(!paused, "Contract paused");
157         _;
158     }
159 
160     modifier whenPaused() {
161         require(paused, "Contract should be paused");
162         _;
163     }
164 
165     function pause() public onlyOwner whenNotPaused {
166         paused = true;
167         emit Pause();
168     }
169 
170     function unpause() public onlyOwner whenPaused {
171         paused = false;
172         emit Unpause();
173     }
174 }
175 
176 contract CKProxy is Pausable {
177   KittyCoreInterface public kittyCore;
178   AuctionInterface public saleAuction;
179   AuctionInterface public siringAuction;
180 
181 constructor(address payable _owner, address _kittyCoreAddress) Pausable(_owner) public {
182     require(_kittyCoreAddress != address(0));
183     kittyCore = KittyCoreInterface(_kittyCoreAddress);
184     require(kittyCore.supportsInterface(0x9a20483d));
185 
186     saleAuction = AuctionInterface(kittyCore.saleAuction());
187     siringAuction = AuctionInterface(kittyCore.siringAuction());
188   }
189 
190   /**
191    * Owner can transfer kitty
192    */
193   function transferKitty(address _to, uint256 _kittyId) external onlyOwner {
194     kittyCore.transfer(_to, _kittyId);
195   }
196 
197   /**
198    * Owner can transfer kitty
199    */
200   function transferKittyBulk(address _to, uint256[] calldata _kittyIds) external onlyOwner {
201     for(uint256 i = 0; i < _kittyIds.length; i++) {
202       kittyCore.transfer(_to, _kittyIds[i]);
203     }
204   }
205 
206   /**
207    * Owner can transferFrom kitty
208    */
209   function transferKittyFrom(address _from, address _to, uint256 _kittyId) external onlyOwner {
210     kittyCore.transferFrom(_from, _to, _kittyId);
211   }
212 
213   /**
214    * Owner can approve kitty
215    */
216   function approveKitty(address _to, uint256 _kittyId) external  onlyOwner {
217     kittyCore.approve(_to, _kittyId);
218   }
219 
220   /**
221    * Owner can start sales auction for kitty owned by contract
222    */
223   function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
224     kittyCore.createSaleAuction(_kittyId, _startingPrice, _endingPrice, _duration);
225   }
226 
227   /**
228    * Owner can cancel sales auction for kitty owned by contract
229    */
230   function cancelSaleAuction(uint256 _kittyId) external onlyOwner {
231     saleAuction.cancelAuction(_kittyId);
232   }
233 
234   /**
235    * Owner can start siring auction for kitty owned by contract
236    */
237   function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
238     kittyCore.createSiringAuction(_kittyId, _startingPrice, _endingPrice, _duration);
239   }
240 
241   /**
242    * Owner can cancel siring auction for kitty owned by contract
243    */
244   function cancelSiringAuction(uint256 _kittyId) external onlyOwner {
245     siringAuction.cancelAuction(_kittyId);
246   }
247 }
248 
249  /**
250  * @title SimpleBreeding
251  * @dev Simple breeding contract allows dedicated breeder to breed kitties on behalf of owner, while owner retains control over funds and kitties.
252  * Breeder gets reward per each successful breed. Breeder can breed when contract is not paused.
253  * Owner should transfer kitties and funds to contact to breeding starts and withdraw afterwards.
254  * Breeder can only breed kitties owned by contract and cannot transfer funds or kitties itself.
255  */
256 
257 contract SimpleBreeding is CKProxy {
258   address payable public breeder;
259   uint256 public breederReward;
260   uint256 public originalBreederReward;
261   uint256 public maxBreedingFee;
262 
263   event Breed(address breeder, uint256 matronId, uint256 sireId, uint256 reward);
264   event MaxBreedingFeeChange(uint256 oldBreedingFee, uint256 newBreedingFee);
265   event BreederRewardChange(uint256 oldBreederReward, uint256 newBreederReward);
266 
267   constructor(address payable _owner, address payable _breeder, address _kittyCoreAddress, uint256 _breederReward) CKProxy(_owner, _kittyCoreAddress) public {
268     require(_breeder != address(0));
269     breeder = _breeder;
270     maxBreedingFee = kittyCore.autoBirthFee();
271     breederReward = _breederReward;
272     originalBreederReward = _breederReward;
273   }
274 
275   /**
276    * Contract funds are used to cover breeding fees and pay callee
277    */
278   function () external payable {}
279 
280   /**
281    * Owner can withdraw funds from contract
282    */
283   function withdraw(uint256 amount) external onlyOwner {
284     owner.transfer(amount);
285   }
286 
287   /**
288    * Owner can adjust breedering fee if needed
289    */
290   function setMaxBreedingFee(
291     uint256 _maxBreedingFee
292   ) external onlyOwner {
293     emit MaxBreedingFeeChange(maxBreedingFee, _maxBreedingFee);
294     maxBreedingFee = _maxBreedingFee;
295   }
296 
297    /**
298    * Owner or breeder can change breeder's reward if needed.
299    * Breeder can lower reward to make more attractive offer, it cannot set more than was originally agreed.
300    * Owner can increase reward to motivate breeder to breed during high gas price, it cannot set less than was set by breeder.
301    */
302   function setBreederReward(
303     uint256 _breederReward
304   ) external {
305     require(msg.sender == breeder || msg.sender == owner);
306     
307     if(msg.sender == owner) {
308       require(_breederReward >= originalBreederReward || _breederReward > breederReward, 'Reward value is less than required');
309     } else if(msg.sender == breeder) {
310       require(_breederReward <= originalBreederReward, 'Reward value is more than original');
311     }
312 
313     emit BreederRewardChange(breederReward, _breederReward);
314     breederReward = _breederReward;
315   }
316 
317   /**
318    * Breeder can call this function to breed kitties on behalf of owner
319    * Owner can breed as well
320    */
321   function breed(uint256 _matronId, uint256 _sireId) external whenNotPaused {
322     require(msg.sender == breeder || msg.sender == owner);
323     uint256 fee = kittyCore.autoBirthFee();
324     require(fee <= maxBreedingFee);
325     kittyCore.breedWithAuto.value(fee)(_matronId, _sireId);
326 
327     uint256 reward = 0;
328     // breeder can reenter but that's OK, since breeder is payed per successful breed
329     if(msg.sender == breeder) {
330       reward = breederReward;
331       breeder.transfer(reward);
332     }
333 
334     emit Breed(msg.sender, _matronId, _sireId, reward);
335   }
336 
337   function destroy() public onlyOwner {
338     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
339     selfdestruct(owner);
340   }
341 
342   function destroyAndSend(address payable _recipient) public onlyOwner {
343     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
344     selfdestruct(_recipient);
345   }
346 }
347 
348 contract SimpleBreedingFactory is Pausable {
349     using SafeMath for uint256;
350 
351     KittyCoreInterface public kittyCore;
352     uint256 public breederReward = 0.001 ether;
353     uint256 public commission = 0 wei;
354     uint256 public provisionFee;
355     mapping (bytes32 => address) public breederToContract;
356 
357     event ContractCreated(address contractAddress, address breeder, address owner);
358     event ContractRemoved(address contractAddress);
359 
360     constructor(address _kittyCoreAddress) Pausable(address(0)) public {
361         provisionFee = commission + breederReward;
362         kittyCore = KittyCoreInterface(_kittyCoreAddress);
363         require(kittyCore.supportsInterface(0x9a20483d), "Invalid contract");
364     }
365 
366     /**
367      * Owner can adjust breeder reward
368      * Factory contract does not use breeder reward directly, but sets it to Breeding contracts during contract creation
369      * Existing contracts won't be affected by the change
370      */
371     function setBreederReward(uint256 _breederReward) external onlyOwner {
372         require(_breederReward > 0, "Breeder reward must be greater than 0");
373         breederReward = _breederReward;
374         provisionFee = uint256(commission).add(breederReward);
375     }
376 
377     /**
378      * Owner can set flat fee for contract creation
379      */
380     function setCommission(uint256 _commission) external onlyOwner {
381         commission = _commission;
382         provisionFee = uint256(commission).add(breederReward);
383     }
384 
385     /**
386      * Just in case owner can change address of Kitty Core contract
387      * Factory contract does not user Kitty Core directly, but sets it to Breeding contracts during contract creation
388      * Existing contracts won't be affected by the change
389      */
390     function setKittyCore(address _kittyCore) external onlyOwner {
391         kittyCore = KittyCoreInterface(_kittyCore);
392         require(kittyCore.supportsInterface(0x9a20483d), "Invalid contract");
393     }
394 
395     function () external payable {
396         revert("Do not send funds to contract");
397     }
398 
399     /**
400      * Owner can withdraw funds from contracts, if any
401      * Contract can only gets funds from contraction creation commission
402      */
403     function withdraw(uint256 amount) external onlyOwner {
404         owner.transfer(amount);
405     }
406     
407     /**
408      * Create new breeding contract for breeder. This function should be called by user during breeder enrollment process.
409      * Message value should be greater than breeder reward + commission. Value excess wil be transfered to created contract.
410      * Breeder reward amount is transfered to breeder's address so it can start sending transactions
411      * Comission amount stays in the contract
412      * When contract is created, provisioning script can get address its address from breederToContract mapping
413      */
414     function createContract(address payable _breederAddress) external payable whenNotPaused {
415         require(msg.value >= provisionFee, "Invalid value");
416 
417         // owner's address and breeder's address should uniquely identify contract
418         // also we need to avoid situation when existing contract address is overwritten by enrolling breeder by same owner twice,
419         // or enrolling same breeder by different owner
420         bytes32 key = keccak256(abi.encodePacked(_breederAddress, msg.sender));
421         require(breederToContract[key] == address(0), "Breeder already enrolled");
422         
423         //transfer value excess to new contract, owner can widthdraw later or use it for breeding
424         uint256 excess = uint256(msg.value).sub(provisionFee);
425         SimpleBreeding newContract = new SimpleBreeding(msg.sender, _breederAddress, address(kittyCore), breederReward);
426         breederToContract[key] = address(newContract);
427         if(excess > 0) {
428             address(newContract).transfer(excess);
429         }
430 
431         //transfer 1st breeder reward to breeder
432         _breederAddress.transfer(breederReward);
433 
434         emit ContractCreated(address(newContract), _breederAddress, msg.sender);
435     }
436 
437     /**
438      * In most cases it does not make sense to delete contract's address. If needed it can be done by owner of factory contract.
439      * This will not destroy breeding contract, just remove it address from the mapping, so user can deploy new contract for same breeder
440      */
441     function removeContract(address _breederAddress, address _ownerAddress) external onlyOwner {
442         bytes32 key = keccak256(abi.encodePacked(_breederAddress, _ownerAddress));
443         address contractAddress = breederToContract[key];
444         require(contractAddress != address(0), "Breeder not enrolled");
445         delete breederToContract[key];
446 
447         emit ContractRemoved(contractAddress);
448     }
449 }