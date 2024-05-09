1 pragma solidity ^0.5.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
68 contract ERC721 {
69     // Required methods
70     function totalSupply() public view returns (uint256 total);
71     function balanceOf(address _owner) public view returns (uint256 balance);
72     function ownerOf(uint256 _tokenId) external view returns (address owner);
73     function approve(address _to, uint256 _tokenId) external;
74     function transfer(address _to, uint256 _tokenId) external;
75     function transferFrom(address _from, address _to, uint256 _tokenId) external;
76 
77     // Events
78     event Transfer(address from, address to, uint256 tokenId);
79     event Approval(address owner, address approved, uint256 tokenId);
80 
81     // Optional
82     // function name() public view returns (string name);
83     // function symbol() public view returns (string symbol);
84     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
85     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
86 
87     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
88     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
89 }
90 
91 contract KittyCoreInterface is ERC721  {
92     uint256 public autoBirthFee;
93     address public saleAuction;
94     address public siringAuction;
95     function breedWithAuto(uint256 _matronId, uint256 _sireId) public payable;
96     function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
97     function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
98     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
99 }
100 
101 contract AuctionInterface {
102     function cancelAuction(uint256 _tokenId) external;
103 }
104 
105 contract Ownable {
106   address payable public owner;
107 
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113   constructor(address payable _owner) public {
114     if(_owner == address(0)) {
115       owner = msg.sender;
116     } else {
117       owner = _owner;
118     }
119   }
120 
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   function transferOwnership(address payable _newOwner) public onlyOwner {
127     _transferOwnership(_newOwner);
128   }
129 
130   function _transferOwnership(address payable _newOwner) internal {
131     require(_newOwner != address(0));
132     emit OwnershipTransferred(owner, _newOwner);
133     owner = _newOwner;
134   }
135 
136   function destroy() public onlyOwner {
137     selfdestruct(owner);
138   }
139 
140   function destroyAndSend(address payable _recipient) public onlyOwner {
141     selfdestruct(_recipient);
142   }
143 }
144 
145 contract Pausable is Ownable {
146     event Pause();
147     event Unpause();
148 
149     bool public paused = false;
150 
151     constructor(address payable _owner) Ownable(_owner) public {}
152 
153     modifier whenNotPaused() {
154         require(!paused, "Contract paused");
155         _;
156     }
157 
158     modifier whenPaused() {
159         require(paused, "Contract should be paused");
160         _;
161     }
162 
163     function pause() public onlyOwner whenNotPaused {
164         paused = true;
165         emit Pause();
166     }
167 
168     function unpause() public onlyOwner whenPaused {
169         paused = false;
170         emit Unpause();
171     }
172 }
173 
174 contract CKProxy is Pausable {
175   KittyCoreInterface public kittyCore;
176   AuctionInterface public saleAuction;
177   AuctionInterface public siringAuction;
178 
179 constructor(address payable _owner, address _kittyCoreAddress) Pausable(_owner) public {
180     require(_kittyCoreAddress != address(0));
181     kittyCore = KittyCoreInterface(_kittyCoreAddress);
182     require(kittyCore.supportsInterface(0x9a20483d));
183 
184     saleAuction = AuctionInterface(kittyCore.saleAuction());
185     siringAuction = AuctionInterface(kittyCore.siringAuction());
186   }
187 
188   /**
189    * Owner can transfer kitty
190    */
191   function transferKitty(address _to, uint256 _kittyId) external onlyOwner {
192     kittyCore.transfer(_to, _kittyId);
193   }
194 
195   /**
196    * Owner can transfer kitty
197    */
198   function transferKittyBulk(address _to, uint256[] calldata _kittyIds) external onlyOwner {
199     for(uint256 i = 0; i < _kittyIds.length; i++) {
200       kittyCore.transfer(_to, _kittyIds[i]);
201     }
202   }
203 
204   /**
205    * Owner can transferFrom kitty
206    */
207   function transferKittyFrom(address _from, address _to, uint256 _kittyId) external onlyOwner {
208     kittyCore.transferFrom(_from, _to, _kittyId);
209   }
210 
211   /**
212    * Owner can approve kitty
213    */
214   function approveKitty(address _to, uint256 _kittyId) external  onlyOwner {
215     kittyCore.approve(_to, _kittyId);
216   }
217 
218   /**
219    * Owner can start sales auction for kitty owned by contract
220    */
221   function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
222     kittyCore.createSaleAuction(_kittyId, _startingPrice, _endingPrice, _duration);
223   }
224 
225   /**
226    * Owner can cancel sales auction for kitty owned by contract
227    */
228   function cancelSaleAuction(uint256 _kittyId) external onlyOwner {
229     saleAuction.cancelAuction(_kittyId);
230   }
231 
232   /**
233    * Owner can start siring auction for kitty owned by contract
234    */
235   function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
236     kittyCore.createSiringAuction(_kittyId, _startingPrice, _endingPrice, _duration);
237   }
238 
239   /**
240    * Owner can cancel siring auction for kitty owned by contract
241    */
242   function cancelSiringAuction(uint256 _kittyId) external onlyOwner {
243     siringAuction.cancelAuction(_kittyId);
244   }
245 }
246 
247  /**
248  * @title SimpleBreeding
249  * @dev Simple breeding contract allows dedicated breeder to breed kitties on behalf of owner, while owner retains control over funds and kitties.
250  * Breeder gets reward per each successful breed. Breeder can breed when contract is not paused.
251  * Owner should transfer kitties and funds to contact to breeding starts and withdraw afterwards.
252  * Breeder can only breed kitties owned by contract and cannot transfer funds or kitties itself.
253  */
254 
255 contract SimpleBreeding is CKProxy {
256   address payable public breeder;
257   uint256 public breederReward;
258   uint256 public originalBreederReward;
259   uint256 public maxBreedingFee;
260 
261   event Breed(address breeder, uint256 matronId, uint256 sireId, uint256 reward);
262   event MaxBreedingFeeChange(uint256 oldBreedingFee, uint256 newBreedingFee);
263   event BreederRewardChange(uint256 oldBreederReward, uint256 newBreederReward);
264 
265   constructor(address payable _owner, address payable _breeder, address _kittyCoreAddress, uint256 _breederReward) CKProxy(_owner, _kittyCoreAddress) public {
266     require(_breeder != address(0));
267     breeder = _breeder;
268     maxBreedingFee = kittyCore.autoBirthFee();
269     breederReward = _breederReward;
270     originalBreederReward = _breederReward;
271   }
272 
273   /**
274    * Contract funds are used to cover breeding fees and pay callee
275    */
276   function () external payable {}
277 
278   /**
279    * Owner can withdraw funds from contract
280    */
281   function withdraw(uint256 amount) external onlyOwner {
282     owner.transfer(amount);
283   }
284 
285   /**
286    * Owner can adjust breedering fee if needed
287    */
288   function setMaxBreedingFee(
289     uint256 _maxBreedingFee
290   ) external onlyOwner {
291     emit MaxBreedingFeeChange(maxBreedingFee, _maxBreedingFee);
292     maxBreedingFee = _maxBreedingFee;
293   }
294 
295    /**
296    * Owner or breeder can change breeder's reward if needed.
297    * Breeder can lower reward to make more attractive offer, it cannot set more than was originally agreed.
298    * Owner can increase reward to motivate breeder to breed during high gas price, it cannot set less than was set by breeder.
299    */
300   function setBreederReward(
301     uint256 _breederReward
302   ) external {
303     require(msg.sender == breeder || msg.sender == owner);
304     
305     if(msg.sender == owner) {
306       require(_breederReward >= originalBreederReward || _breederReward > breederReward, 'Reward value is less than required');
307     } else if(msg.sender == breeder) {
308       require(_breederReward <= originalBreederReward, 'Reward value is more than original');
309     }
310 
311     emit BreederRewardChange(breederReward, _breederReward);
312     breederReward = _breederReward;
313   }
314 
315   /**
316    * Breeder can call this function to breed kitties on behalf of owner
317    * Owner can breed as well
318    */
319   function breed(uint256 _matronId, uint256 _sireId) external whenNotPaused {
320     require(msg.sender == breeder || msg.sender == owner);
321     uint256 fee = kittyCore.autoBirthFee();
322     require(fee <= maxBreedingFee);
323     kittyCore.breedWithAuto.value(fee)(_matronId, _sireId);
324 
325     uint256 reward = 0;
326     // breeder can reenter but that's OK, since breeder is payed per successful breed
327     if(msg.sender == breeder) {
328       reward = breederReward;
329       breeder.transfer(reward);
330     }
331 
332     emit Breed(msg.sender, _matronId, _sireId, reward);
333   }
334 
335   function destroy() public onlyOwner {
336     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
337     selfdestruct(owner);
338   }
339 
340   function destroyAndSend(address payable _recipient) public onlyOwner {
341     require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
342     selfdestruct(_recipient);
343   }
344 }