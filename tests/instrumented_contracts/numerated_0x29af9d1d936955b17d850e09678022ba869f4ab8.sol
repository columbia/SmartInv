1 // File: @openzeppelin\contracts\utils\Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: contracts\SalesContract\SalesStorage.sol
48 
49 
50 pragma solidity ^0.8.4;
51 
52 /**
53 > Collection
54 @notice this contract is standard ERC721 to used as xanalia user's collection managing his NFTs
55  */
56 contract SalesStorage {
57 using Counters for Counters.Counter;
58 
59     mapping(address => bool) _allowAddress;
60 
61     uint256 status;
62     struct VIPPass {
63         uint256 price;
64         uint256 limit;
65         uint256 maxSupply;
66         bytes32 merkleRoot;
67         bool isWhiteList;
68         uint256 supply;
69     }
70 
71     mapping(uint256 => VIPPass) public _vip;
72     
73     uint256[] public vipPassIds;
74 
75     struct productDetail {
76         uint256 vipPassId;
77         uint256 amount;
78         address buyer;
79         bytes32[] proof;
80     }
81 
82     struct Order {
83         uint256 amount;
84         // uint256 vip1; //alpha pass
85         // uint256 vip2; //ultraman
86         // uint256 vip3; //astroboy
87         // uint256 vip4; //rooster fighter
88         // uint256 vip5; //whitelist
89         mapping (uint256=> uint256) productCount;
90         uint256 paid;
91         address buyer;
92 
93     }
94 
95     mapping(uint256 => Order) order;
96 
97     mapping(address => uint256[]) userOrders;
98 
99     
100     //adddress => vip pass id => user bought count
101     mapping (address=> mapping(uint256 => uint256)) public userBought;
102 
103     uint256 orderId;
104 
105     address seller;
106 
107     mapping (uint256=> bytes32) whitelistRoot;
108 
109     bool public saleWhiteList;
110 
111     uint256 public whiteListSaleId;
112 
113 
114     uint256 startTime;
115 
116     uint256 whitelistStartTime;
117 
118     uint256 endTime;
119     
120 
121 
122 }
123 
124 // File: @openzeppelin\contracts\utils\Context.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @dev Provides information about the current execution context, including the
133  * sender of the transaction and its data. While these are generally available
134  * via msg.sender and msg.data, they should not be accessed in such a direct
135  * manner, since when dealing with meta-transactions the account sending and
136  * paying for execution may not be the actual sender (as far as an application
137  * is concerned).
138  *
139  * This contract is only required for intermediate, library-like contracts.
140  */
141 abstract contract Context {
142     function _msgSender() internal view virtual returns (address) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes calldata) {
147         return msg.data;
148     }
149 }
150 
151 // File: contracts\SalesContract\Ownable.sol
152 
153 
154 
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @dev Contract module which provides a basic access control mechanism, where
159  * there is an account (an owner) that can be granted exclusive access to
160  * specific functions.
161  *
162  * By default, the owner account will be the one that deploys the contract. This
163  * can later be changed with {transferOwnership}.
164  *
165  * This module is used through inheritance. It will make available the modifier
166  * `onlyOwner`, which can be applied to your functions to restrict their use to
167  * the owner.
168  */
169 abstract contract Ownable is Context {
170     address private _owner;
171 
172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
173 
174     /**
175      * @dev Initializes the contract setting the deployer as the initial owner.
176      */
177     constructor() {
178         _setOwner(_msgSender());
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view virtual returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(owner() == _msgSender(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public virtual onlyOwner {
204         _setOwner(address(0));
205     }
206 
207     /**
208      * @dev Transfers ownership of the contract to a new account (`newOwner`).
209      * Can only be called by the current owner.
210      */
211     function transferOwnership(address newOwner) public virtual onlyOwner {
212         require(newOwner != address(0), "Ownable: new owner is the zero address");
213         _setOwner(newOwner);
214     }
215 
216     function _setOwner(address newOwner) internal {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: contracts\SalesContract\MerkleProof.sol
224 
225 pragma solidity ^0.8.4;
226 
227 library MerkleProof {
228     
229     function verify(
230         bytes32[] memory proof,
231         bytes32 root,
232         bytes32 leaf
233     ) internal pure returns (bool) {
234         return processProof(proof, leaf) == root;
235     }
236 
237     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
238         bytes32 computedHash = leaf;
239         for (uint256 i = 0; i < proof.length; i++) {
240             bytes32 proofElement = proof[i];
241             if (computedHash <= proofElement) {
242                 // Hash(current computed hash + current element of the proof)
243                 computedHash = _efficientHash(computedHash, proofElement);
244             } else {
245                 // Hash(current element of the proof + current computed hash)
246                 computedHash = _efficientHash(proofElement, computedHash);
247             }
248         }
249         return computedHash;
250     }
251 
252     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
253         assembly {
254             mstore(0x00, a)
255             mstore(0x20, b)
256             value := keccak256(0x00, 0x40)
257         }
258     }
259 }
260 
261 // File: contracts\SalesContract\Sales.sol
262 
263 
264 pragma solidity ^0.8.4;
265 /**
266 > Collection
267 @notice this contract is standard ERC721 to used as xanalia user's collection managing his NFTs
268  */
269 contract Sales is  Ownable, SalesStorage{
270 
271 
272 
273   constructor() public {
274    
275     _allowAddress[msg.sender] = true;
276   
277   }
278 modifier isValid() {
279   require(_allowAddress[msg.sender], "not authorize");
280   _;
281 }
282 
283     function addAllowedAddress(address _address) onlyOwner public {
284         _allowAddress[_address] = !_allowAddress[_address];
285     }
286 
287     function setSales(uint256 _startTime, uint256 _endTime, uint256 _whitelistStartTime) onlyOwner public {
288         startTime = _startTime;
289         endTime = _endTime;
290         whitelistStartTime = _whitelistStartTime;
291         status = 1;
292     }
293 
294     function getStatus() public view returns(uint256) {
295         return status;
296     }
297 
298     function setVIPPASS(uint256 vipPassId, uint256 price, uint256 limit, bool isWhitelist) public onlyOwner {
299         _vip[vipPassId].price = price;
300         _vip[vipPassId].limit = limit;
301         _vip[vipPassId].isWhiteList = isWhitelist;
302         if(isWhitelist){
303             saleWhiteList = true;
304             whiteListSaleId = vipPassId;
305         }
306     }
307 
308     function setVipPassIds(uint256[] memory _vipPassIds) public onlyOwner {
309        vipPassIds = _vipPassIds;
310     
311     }
312     function getVipPassIds() public view returns(uint256[] memory) {
313        return vipPassIds;
314     }
315 
316      function setVIPPASSBulk(VIPPass[] memory vipPass) public onlyOwner {
317         for (uint256 index = 0; index < vipPass.length; index++) {
318              _vip[index + 1] = vipPass[index];
319         }
320     }
321 
322     function getVipPassDetails() public view returns(VIPPass[] memory vipPass) {
323         for (uint256 index = 0; index < vipPassIds.length; index++) {
324             vipPass[index] = _vip[vipPassIds[index]];
325         }
326     }
327 
328     function getUserBought(address _add) public view returns(productDetail[] memory userBoughtDetails) {
329         bytes32[] memory temp;
330         for (uint256 index = 0; index < vipPassIds.length; index++) {
331             userBoughtDetails[index] = productDetail(vipPassIds[index], userBought[_add][vipPassIds[index]], _add,temp);
332 
333         }  
334     }
335 
336     function placeOrder(productDetail[] calldata _productDetail, uint256 totalAmount ) payable external {
337         require(status == 1, "0");
338         require(msg.value > 0, "1" );
339         require(totalAmount > 0, "2" );
340         require(startTime < block.timestamp, "3");
341         require(endTime > block.timestamp, "4");
342         
343         uint256 amount = 0;
344         uint256 price = 0;
345         orderId++;
346         bool valid = true;
347         bool whiteListSale = true;
348         for (uint256 index = 0; index < _productDetail.length; index++) {
349             productDetail calldata tempProduct = _productDetail[index];
350             amount += tempProduct.amount;
351             price += ( _vip[tempProduct.vipPassId].price * tempProduct.amount);
352             order[orderId].productCount[tempProduct.vipPassId] = tempProduct.amount;
353             _vip[tempProduct.vipPassId].supply += tempProduct.amount;
354             userBought[msg.sender][tempProduct.vipPassId] += tempProduct.amount;
355             if(tempProduct.vipPassId == whiteListSaleId){
356                 whiteListSale = whitelistStartTime < block.timestamp;
357                 valid = _verify(_leaf(msg.sender), tempProduct.proof, whitelistRoot[whiteListSaleId]);
358             }
359         }
360         require(whiteListSale, "5");
361         require(amount == totalAmount, "6");
362         require(valid, "7");
363          uint256 depositAmount = msg.value;
364         require(price <= depositAmount, "8");
365         userOrders[msg.sender].push(orderId);
366         order[orderId].buyer = msg.sender;
367         order[orderId].amount = amount;
368         payable(seller).call{value: msg.value}("");
369         emit PlaceOrder(_productDetail, orderId, totalAmount, msg.value, msg.sender, seller, price);
370     }
371 
372     function setSellerAddress(address _add) onlyOwner public {
373         seller = _add;
374     }
375 
376 
377     function setStatus(uint256 _status) onlyOwner public  {
378         status = _status;
379     }
380 
381     	function isWhitelisted(address account, bytes32[] calldata proof, uint256 _vipId) public view returns (bool) {
382         return _verify(_leaf(account), proof, whitelistRoot[_vipId]);
383     }
384     function setWhitelistRoot(bytes32 newWhitelistroot, uint256 _vipId) public onlyOwner {
385         whitelistRoot[_vipId] = newWhitelistroot;
386     }
387     function _leaf(address account) internal pure returns (bytes32) {
388         return keccak256(abi.encodePacked(account));
389     }
390     function _verify(bytes32 leaf,bytes32[] memory proof,bytes32 root) internal pure returns (bool) {
391         return MerkleProof.verify(proof, root, leaf);
392     }
393 
394     function getSaleTime() public view returns(uint256 _startTime, uint256 _whitelistStartTime, uint256 _endTime) {
395         _startTime = startTime;
396         _whitelistStartTime = whitelistStartTime;
397         _endTime = endTime;
398     }
399     fallback() payable external {}
400     receive() payable external {}
401 
402   // events
403   event PlaceOrder(productDetail[] ProductDetails, uint256 indexed orderId, uint256 totalAmount, uint256 totalPrice, address buyer, address seller, uint256 orderPrice);
404 }