1 pragma solidity ^0.5.3;
2 
3 
4 contract AuctionInterface {
5     function cancelAuction(uint256 _tokenId) external;
6 }
7 
8 contract ERC721 {
9     // Required methods
10     function totalSupply() public view returns (uint256 total);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12     function ownerOf(uint256 _tokenId) external view returns (address owner);
13     function approve(address _to, uint256 _tokenId) external;
14     function transfer(address _to, uint256 _tokenId) external;
15     function transferFrom(address _from, address _to, uint256 _tokenId) external;
16 
17     // Events
18     event Transfer(address from, address to, uint256 tokenId);
19     event Approval(address owner, address approved, uint256 tokenId);
20 
21     // Optional
22     // function name() public view returns (string name);
23     // function symbol() public view returns (string symbol);
24     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
25     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
26 
27     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
28     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
29 }
30 
31 contract KittyCoreInterface is ERC721  {
32     uint256 public autoBirthFee;
33     address public saleAuction;
34     address public siringAuction;
35     function breedWithAuto(uint256 _matronId, uint256 _sireId) public payable;
36     function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
37     function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
38     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
39 }
40 
41 library SafeMath {
42     /**
43      * @dev Multiplies two unsigned integers, reverts on overflow.
44      */
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
61      */
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Solidity only automatically asserts when dividing by 0
64         require(b > 0);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     /**
72      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Adds two unsigned integers, reverts on overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a);
87 
88         return c;
89     }
90 
91     /**
92      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
93      * reverts when dividing by zero.
94      */
95     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b != 0);
97         return a % b;
98     }
99 }
100 
101 /**
102  * @title AccessControl
103  * @dev AccessControl contract sets roles and permissions
104  * Owner - has full control over contract
105  * Operator - has limited sub set of allowed actions over contract
106  * Multiple operators can be added by owner to delegate a number of tasks in the contract
107  */
108 contract AccessControl {
109   address payable public owner;
110   mapping(address => bool) public operators;
111 
112   event OwnershipTransferred(
113     address indexed previousOwner,
114     address indexed newOwner
115   );
116 
117   event OperatorAdded(
118     address indexed operator
119   );
120 
121   event OperatorRemoved(
122     address indexed operator
123   );
124 
125   constructor(address payable _owner) public {
126     if(_owner == address(0)) {
127       owner = msg.sender;
128     } else {
129       owner = _owner;
130     }
131   }
132 
133   modifier onlyOwner() {
134     require(msg.sender == owner, 'Invalid sender');
135     _;
136   }
137 
138   modifier onlyOwnerOrOperator() {
139     require(msg.sender == owner || operators[msg.sender] == true, 'Invalid sender');
140     _;
141   }
142 
143   function transferOwnership(address payable _newOwner) public onlyOwner {
144     _transferOwnership(_newOwner);
145   }
146 
147   function _transferOwnership(address payable _newOwner) internal {
148     require(_newOwner != address(0), 'Invalid address');
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 
153   function addOperator(address payable _operator) public onlyOwner {
154     require(operators[_operator] != true, 'Operator already exists');
155     operators[_operator] = true;
156 
157     emit OperatorAdded(_operator);
158   }
159 
160   function removeOperator(address payable _operator) public onlyOwner {
161     require(operators[_operator] == true, 'Operator already exists');
162     delete operators[_operator];
163 
164     emit OperatorRemoved(_operator);
165   }
166 
167   function destroy() public onlyOwner {
168     selfdestruct(owner);
169   }
170 
171   function destroyAndSend(address payable _recipient) public onlyOwner {
172     selfdestruct(_recipient);
173   }
174 }
175 
176 /**
177  * @title Pausable
178  * @dev The Pausable contract can be paused and started by owner
179  */
180 contract Pausable is AccessControl {
181     event Pause();
182     event Unpause();
183 
184     bool public paused = false;
185 
186     constructor(address payable _owner) AccessControl(_owner) public {}
187 
188     modifier whenNotPaused() {
189         require(!paused, "Contract paused");
190         _;
191     }
192 
193     modifier whenPaused() {
194         require(paused, "Contract should be paused");
195         _;
196     }
197 
198     function pause() public onlyOwner whenNotPaused {
199         paused = true;
200         emit Pause();
201     }
202 
203     function unpause() public onlyOwner whenPaused {
204         paused = false;
205         emit Unpause();
206     }
207 }
208 
209  /**
210  * @title CKProxy
211  * @dev CKProxy contract allows owner or operator to proxy call to CK Core contract to manage kitties owned by contract
212  */
213 contract CKProxy is Pausable {
214   KittyCoreInterface public kittyCore;
215   AuctionInterface public saleAuction;
216   AuctionInterface public siringAuction;
217 
218 constructor(address payable _owner, address _kittyCoreAddress) Pausable(_owner) public {
219     require(_kittyCoreAddress != address(0), 'Invalid Kitty Core contract address');
220     kittyCore = KittyCoreInterface(_kittyCoreAddress);
221     require(kittyCore.supportsInterface(0x9a20483d), 'Invalid Kitty Core contract');
222 
223     saleAuction = AuctionInterface(kittyCore.saleAuction());
224     siringAuction = AuctionInterface(kittyCore.siringAuction());
225   }
226 
227   /**
228    * Owner or operator can transfer kitty
229    */
230   function transferKitty(address _to, uint256 _kittyId) external onlyOwnerOrOperator {
231     kittyCore.transfer(_to, _kittyId);
232   }
233 
234   /**
235    * Owner or operator can transfer kittie in batched to optimize gas usage
236    */
237   function transferKittyBulk(address _to, uint256[] calldata _kittyIds) external onlyOwnerOrOperator {
238     for(uint256 i = 0; i < _kittyIds.length; i++) {
239       kittyCore.transfer(_to, _kittyIds[i]);
240     }
241   }
242 
243   /**
244    * Owner or operator can transferFrom kitty
245    */
246   function transferKittyFrom(address _from, address _to, uint256 _kittyId) external onlyOwnerOrOperator {
247     kittyCore.transferFrom(_from, _to, _kittyId);
248   }
249 
250   /**
251    * Owner or operator an approve kitty
252    */
253   function approveKitty(address _to, uint256 _kittyId) external  onlyOwnerOrOperator {
254     kittyCore.approve(_to, _kittyId);
255   }
256 
257   /**
258    * Owner or operator can start sales auction for kitty owned by contract
259    */
260   function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwnerOrOperator {
261     kittyCore.createSaleAuction(_kittyId, _startingPrice, _endingPrice, _duration);
262   }
263 
264   /**
265    * Owner or operator can cancel sales auction for kitty owned by contract
266    */
267   function cancelSaleAuction(uint256 _kittyId) external onlyOwnerOrOperator {
268     saleAuction.cancelAuction(_kittyId);
269   }
270 
271   /**
272    * Owner or operator can start siring auction for kitty owned by contract
273    */
274   function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwnerOrOperator {
275     kittyCore.createSiringAuction(_kittyId, _startingPrice, _endingPrice, _duration);
276   }
277 
278   /**
279    * Owner or operator can cancel siring auction for kitty owned by contract
280    */
281   function cancelSiringAuction(uint256 _kittyId) external onlyOwnerOrOperator {
282     siringAuction.cancelAuction(_kittyId);
283   }
284 }
285 
286  /**
287  * @title SimpleBreeding
288  * @dev Simple breeding contract allows dedicated breeder to breed kitties on behalf of owner, while owner retains control over funds and kitties.
289  * Breeder gets reward per each successful breed. Breeder can breed when contract is not paused.
290  * Owner should transfer kitties and funds to contact to breeding starts and withdraw afterwards.
291  * Breeder can only breed kitties owned by contract and cannot transfer funds or kitties itself.
292  */
293 contract SimpleBreeding is CKProxy {
294   address payable public breeder;
295   uint256 public breederReward;
296   uint256 public originalBreederReward;
297   uint256 public maxBreedingFee;
298 
299   event Breed(address breeder, uint256 matronId, uint256 sireId, uint256 reward);
300   event MaxBreedingFeeChange(uint256 oldBreedingFee, uint256 newBreedingFee);
301   event BreederRewardChange(uint256 oldBreederReward, uint256 newBreederReward);
302 
303   constructor(address payable _owner, address payable _breeder, address _kittyCoreAddress, uint256 _breederReward)
304     CKProxy(_owner, _kittyCoreAddress) public {
305     require(_breeder != address(0), 'Invalid breeder address');
306     breeder = _breeder;
307     maxBreedingFee = kittyCore.autoBirthFee();
308     breederReward = _breederReward;
309     originalBreederReward = _breederReward;
310   }
311 
312   /**
313    * Contract funds are used to cover breeding fees and pay callee
314    */
315   function () external payable {}
316 
317   /**
318    * Owner can withdraw funds from contract
319    */
320   function withdraw(uint256 amount) external onlyOwner {
321     owner.transfer(amount);
322   }
323 
324   /**
325    * Owner can adjust breedering fee if needed
326    */
327   function setMaxBreedingFee(
328     uint256 _maxBreedingFee
329   ) external onlyOwner {
330     emit MaxBreedingFeeChange(maxBreedingFee, _maxBreedingFee);
331     maxBreedingFee = _maxBreedingFee;
332   }
333 
334    /**
335    * Owner or breeder can change breeder's reward if needed.
336    * Breeder can lower reward to make more attractive offer, it cannot set more than was originally agreed.
337    * Owner can increase reward to motivate breeder to breed during high gas price, it cannot set less than was set by breeder.
338    */
339   function setBreederReward(
340     uint256 _breederReward
341   ) external {
342     require(msg.sender == breeder || msg.sender == owner, 'Invalid sender');
343 
344     if(msg.sender == owner) {
345       require(_breederReward >= originalBreederReward || _breederReward > breederReward, 'Reward value is less than required');
346     } else if(msg.sender == breeder) {
347       require(_breederReward <= originalBreederReward, 'Reward value is more than original');
348     }
349 
350     emit BreederRewardChange(breederReward, _breederReward);
351     breederReward = _breederReward;
352   }
353 
354   /**
355    * Breeder can call this function to breed kitties on behalf of owner
356    * Owner can breed as well
357    */
358   function breed(uint256 _matronId, uint256 _sireId) external whenNotPaused {
359     require(msg.sender == breeder || msg.sender == owner, 'Invalid sender');
360     uint256 fee = kittyCore.autoBirthFee();
361     require(fee <= maxBreedingFee, 'Breeding fee is too high');
362     kittyCore.breedWithAuto.value(fee)(_matronId, _sireId);
363 
364     uint256 reward = 0;
365     // breeder can reenter but that's OK, since breeder is payed per successful breed
366     if(msg.sender == breeder) {
367       reward = breederReward;
368       breeder.transfer(reward);
369     }
370 
371     emit Breed(msg.sender, _matronId, _sireId, reward);
372   }
373 
374   function destroy() public onlyOwner {
375     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
376     selfdestruct(owner);
377   }
378 
379   function destroyAndSend(address payable _recipient) public onlyOwner {
380     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
381     selfdestruct(_recipient);
382   }
383 }