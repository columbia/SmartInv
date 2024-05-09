1 // File: contracts/EternalStorage.sol
2 
3 // Roman Storm Multi Sender
4 // To Use this Dapp: https://poanetwork.github.io/multisender
5 pragma solidity 0.4.20;
6 
7 
8 /**
9  * @title EternalStorage
10  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
11  */
12 contract EternalStorage {
13 
14     mapping(bytes32 => uint256) internal uintStorage;
15     mapping(bytes32 => string) internal stringStorage;
16     mapping(bytes32 => address) internal addressStorage;
17     mapping(bytes32 => bytes) internal bytesStorage;
18     mapping(bytes32 => bool) internal boolStorage;
19     mapping(bytes32 => int256) internal intStorage;
20 
21 }
22 
23 // File: contracts/UpgradeabilityOwnerStorage.sol
24 
25 // Roman Storm Multi Sender
26 // To Use this Dapp: https://poanetwork.github.io/multisender
27 pragma solidity 0.4.20;
28 
29 
30 /**
31  * @title UpgradeabilityOwnerStorage
32  * @dev This contract keeps track of the upgradeability owner
33  */
34 contract UpgradeabilityOwnerStorage {
35   // Owner of the contract
36     address private _upgradeabilityOwner;
37 
38     /**
39     * @dev Tells the address of the owner
40     * @return the address of the owner
41     */
42     function upgradeabilityOwner() public view returns (address) {
43         return _upgradeabilityOwner;
44     }
45 
46     /**
47     * @dev Sets the address of the owner
48     */
49     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
50         _upgradeabilityOwner = newUpgradeabilityOwner;
51     }
52 
53 }
54 
55 // File: contracts/UpgradeabilityStorage.sol
56 
57 // Roman Storm Multi Sender
58 // To Use this Dapp: https://poanetwork.github.io/multisender
59 pragma solidity 0.4.20;
60 
61 
62 /**
63  * @title UpgradeabilityStorage
64  * @dev This contract holds all the necessary state variables to support the upgrade functionality
65  */
66 contract UpgradeabilityStorage {
67   // Version name of the current implementation
68     string internal _version;
69 
70     // Address of the current implementation
71     address internal _implementation;
72 
73     /**
74     * @dev Tells the version name of the current implementation
75     * @return string representing the name of the current version
76     */
77     function version() public view returns (string) {
78         return _version;
79     }
80 
81     /**
82     * @dev Tells the address of the current implementation
83     * @return address of the current implementation
84     */
85     function implementation() public view returns (address) {
86         return _implementation;
87     }
88 }
89 
90 // File: contracts/OwnedUpgradeabilityStorage.sol
91 
92 // Roman Storm Multi Sender
93 // To Use this Dapp: https://poanetwork.github.io/multisender
94 pragma solidity 0.4.20;
95 
96 
97 
98 
99 
100 /**
101  * @title OwnedUpgradeabilityStorage
102  * @dev This is the storage necessary to perform upgradeable contracts.
103  * This means, required state variables for upgradeability purpose and eternal storage per se.
104  */
105 contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}
106 
107 // File: contracts/SafeMath.sol
108 
109 // Roman Storm Multi Sender
110 // To Use this Dapp: https://poanetwork.github.io/multisender
111 pragma solidity 0.4.20;
112 
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that throw on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, throws on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124     if (a == 0) {
125       return 0;
126     }
127     uint256 c = a * b;
128     assert(c / a == b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 a, uint256 b) internal pure returns (uint256) {
136     // assert(b > 0); // Solidity automatically throws when dividing by 0
137     uint256 c = a / b;
138     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139     return c;
140   }
141 
142   /**
143   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     assert(b <= a);
147     return a - b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 a, uint256 b) internal pure returns (uint256) {
154     uint256 c = a + b;
155     assert(c >= a);
156     return c;
157   }
158 }
159 
160 // File: contracts/multisender/Ownable.sol
161 
162 // Roman Storm Multi Sender
163 // To Use this Dapp: https://poanetwork.github.io/multisender
164 pragma solidity 0.4.20;
165 
166 
167 
168 /**
169  * @title Ownable
170  * @dev This contract has an owner address providing basic authorization control
171  */
172 contract Ownable is EternalStorage {
173     /**
174     * @dev Event to show ownership has been transferred
175     * @param previousOwner representing the address of the previous owner
176     * @param newOwner representing the address of the new owner
177     */
178     event OwnershipTransferred(address previousOwner, address newOwner);
179 
180     /**
181     * @dev Throws if called by any account other than the owner.
182     */
183     modifier onlyOwner() {
184         require(msg.sender == owner());
185         _;
186     }
187 
188     /**
189     * @dev Tells the address of the owner
190     * @return the address of the owner
191     */
192     function owner() public view returns (address) {
193         return addressStorage[keccak256("owner")];
194     }
195 
196     /**
197     * @dev Allows the current owner to transfer control of the contract to a newOwner.
198     * @param newOwner the address to transfer ownership to.
199     */
200     function transferOwnership(address newOwner) public onlyOwner {
201         require(newOwner != address(0));
202         setOwner(newOwner);
203     }
204 
205     /**
206     * @dev Sets a new owner address
207     */
208     function setOwner(address newOwner) internal {
209         OwnershipTransferred(owner(), newOwner);
210         addressStorage[keccak256("owner")] = newOwner;
211     }
212 }
213 
214 // File: contracts/multisender/Claimable.sol
215 
216 // Roman Storm Multi Sender
217 // To Use this Dapp: https://poanetwork.github.io/multisender
218 pragma solidity 0.4.20;
219 
220 
221 
222 
223 /**
224  * @title Claimable
225  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
226  * This allows the new owner to accept the transfer.
227  */
228 contract Claimable is EternalStorage, Ownable {
229     function pendingOwner() public view returns (address) {
230         return addressStorage[keccak256("pendingOwner")];
231     }
232 
233     /**
234     * @dev Modifier throws if called by any account other than the pendingOwner.
235     */
236     modifier onlyPendingOwner() {
237         require(msg.sender == pendingOwner());
238         _;
239     }
240 
241     /**
242     * @dev Allows the current owner to set the pendingOwner address.
243     * @param newOwner The address to transfer ownership to.
244     */
245     function transferOwnership(address newOwner) public onlyOwner {
246         require(newOwner != address(0));
247         addressStorage[keccak256("pendingOwner")] = newOwner;
248     }
249 
250     /**
251     * @dev Allows the pendingOwner address to finalize the transfer.
252     */
253     function claimOwnership() public onlyPendingOwner {
254         OwnershipTransferred(owner(), pendingOwner());
255         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
256         addressStorage[keccak256("pendingOwner")] = address(0);
257     }
258 }
259 
260 // File: contracts/multisender/UpgradebleStormSender.sol
261 
262 // Roman Storm Multi Sender
263 // To Use this Dapp: https://poanetwork.github.io/multisender
264 pragma solidity 0.4.20;
265 
266 
267 
268 
269 /**
270  * @title ERC20Basic
271  * @dev Simpler version of ERC20 interface
272  * @dev see https://github.com/ethereum/EIPs/issues/179
273  */
274 contract ERC20Basic {
275     function totalSupply() public view returns (uint256);
276     function balanceOf(address who) public view returns (uint256);
277     function transfer(address to, uint256 value) public returns (bool);
278     event Transfer(address indexed from, address indexed to, uint256 value);
279 }
280 
281 
282 contract ERC20 is ERC20Basic {
283     function allowance(address owner, address spender) public view returns (uint256);
284     function transferFrom(address from, address to, uint256 value) public returns (bool);
285     function approve(address spender, uint256 value) public returns (bool);
286     event Approval(address indexed owner, address indexed spender, uint256 value);
287 }
288 
289 
290 contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
291     using SafeMath for uint256;
292 
293     event Multisended(uint256 total, address tokenAddress);
294     event ClaimedTokens(address token, address owner, uint256 balance);
295 
296     modifier hasFee() {
297         if (currentFee(msg.sender) > 0) {
298             require(msg.value >= currentFee(msg.sender));
299         }
300         _;
301     }
302 
303     function() public payable {}
304 
305     function initialize(address _owner) public {
306         require(!initialized());
307         setOwner(_owner);
308         setArrayLimit(200);
309         setDiscountStep(0.00005 ether);
310         setFee(0.05 ether);
311         boolStorage[keccak256("rs_multisender_initialized")] = true;
312     }
313 
314     function initialized() public view returns (bool) {
315         return boolStorage[keccak256("rs_multisender_initialized")];
316     }
317  
318     function txCount(address customer) public view returns(uint256) {
319         return uintStorage[keccak256("txCount", customer)];
320     }
321 
322     function arrayLimit() public view returns(uint256) {
323         return uintStorage[keccak256("arrayLimit")];
324     }
325 
326     function setArrayLimit(uint256 _newLimit) public onlyOwner {
327         require(_newLimit != 0);
328         uintStorage[keccak256("arrayLimit")] = _newLimit;
329     }
330 
331     function discountStep() public view returns(uint256) {
332         return uintStorage[keccak256("discountStep")];
333     }
334 
335     function setDiscountStep(uint256 _newStep) public onlyOwner {
336         require(_newStep != 0);
337         uintStorage[keccak256("discountStep")] = _newStep;
338     }
339 
340     function fee() public view returns(uint256) {
341         return uintStorage[keccak256("fee")];
342     }
343 
344     function currentFee(address _customer) public view returns(uint256) {
345         if (fee() > discountRate(msg.sender)) {
346             return fee().sub(discountRate(_customer));
347         } else {
348             return 0;
349         }
350     }
351 
352     function setFee(uint256 _newStep) public onlyOwner {
353         require(_newStep != 0);
354         uintStorage[keccak256("fee")] = _newStep;
355     }
356 
357     function discountRate(address _customer) public view returns(uint256) {
358         uint256 count = txCount(_customer);
359         return count.mul(discountStep());
360     }
361 
362     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
363         uint256 total = 0;
364         require(_contributors.length <= arrayLimit());
365         ERC20 erc20token = ERC20(token);
366         uint8 i = 0;
367         for (i; i < _contributors.length; i++) {
368             erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
369             total += _balances[i];
370         }
371         setTxCount(msg.sender, txCount(msg.sender).add(1));
372         Multisended(total, token);
373     }
374 
375     function claimTokens(address _token) public onlyOwner {
376         if (_token == 0x0) {
377             owner().transfer(this.balance);
378             return;
379         }
380         ERC20 erc20token = ERC20(_token);
381         uint256 balance = erc20token.balanceOf(this);
382         erc20token.transfer(owner(), balance);
383         ClaimedTokens(_token, owner(), balance);
384     }
385     
386     function setTxCount(address customer, uint256 _txCount) private {
387         uintStorage[keccak256("txCount", customer)] = _txCount;
388     }
389 
390 }