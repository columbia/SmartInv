1 // File: contracts/EternalStorage.sol
2 
3 // Roman Storm Multi Sender
4 // To Use this Dapp: https://rstormsf.github.io/multisender
5 pragma solidity 0.4.23;
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
23 // File: contracts/UpgradeabilityStorage.sol
24 
25 // Roman Storm Multi Sender
26 // To Use this Dapp: https://rstormsf.github.io/multisender
27 pragma solidity 0.4.23;
28 
29 
30 /**
31  * @title UpgradeabilityStorage
32  * @dev This contract holds all the necessary state variables to support the upgrade functionality
33  */
34 contract UpgradeabilityStorage {
35   // Version name of the current implementation
36     string internal _version;
37 
38     // Address of the current implementation
39     address internal _implementation;
40 
41     /**
42     * @dev Tells the version name of the current implementation
43     * @return string representing the name of the current version
44     */
45     function version() public view returns (string) {
46         return _version;
47     }
48 
49     /**
50     * @dev Tells the address of the current implementation
51     * @return address of the current implementation
52     */
53     function implementation() public view returns (address) {
54         return _implementation;
55     }
56 }
57 
58 // File: contracts/UpgradeabilityOwnerStorage.sol
59 
60 // Roman Storm Multi Sender
61 // To Use this Dapp: https://rstormsf.github.io/multisender
62 pragma solidity 0.4.23;
63 
64 
65 /**
66  * @title UpgradeabilityOwnerStorage
67  * @dev This contract keeps track of the upgradeability owner
68  */
69 contract UpgradeabilityOwnerStorage {
70   // Owner of the contract
71     address private _upgradeabilityOwner;
72 
73     /**
74     * @dev Tells the address of the owner
75     * @return the address of the owner
76     */
77     function upgradeabilityOwner() public view returns (address) {
78         return _upgradeabilityOwner;
79     }
80 
81     /**
82     * @dev Sets the address of the owner
83     */
84     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
85         _upgradeabilityOwner = newUpgradeabilityOwner;
86     }
87 
88 }
89 
90 // File: contracts/OwnedUpgradeabilityStorage.sol
91 
92 // Roman Storm Multi Sender
93 // To Use this Dapp: https://rstormsf.github.io/multisender
94 pragma solidity 0.4.23;
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
107 // File: contracts/multisender/Ownable.sol
108 
109 // Roman Storm Multi Sender
110 // To Use this Dapp: https://rstormsf.github.io/multisender
111 pragma solidity 0.4.23;
112 
113 
114 
115 /**
116  * @title Ownable
117  * @dev This contract has an owner address providing basic authorization control
118  */
119 contract Ownable is EternalStorage {
120     /**
121     * @dev Event to show ownership has been transferred
122     * @param previousOwner representing the address of the previous owner
123     * @param newOwner representing the address of the new owner
124     */
125     event OwnershipTransferred(address previousOwner, address newOwner);
126 
127     /**
128     * @dev Throws if called by any account other than the owner.
129     */
130     modifier onlyOwner() {
131         require(msg.sender == owner());
132         _;
133     }
134 
135     /**
136     * @dev Tells the address of the owner
137     * @return the address of the owner
138     */
139     function owner() public view returns (address) {
140         return addressStorage[keccak256("owner")];
141     }
142 
143     /**
144     * @dev Allows the current owner to transfer control of the contract to a newOwner.
145     * @param newOwner the address to transfer ownership to.
146     */
147     function transferOwnership(address newOwner) public onlyOwner {
148         require(newOwner != address(0));
149         setOwner(newOwner);
150     }
151 
152     /**
153     * @dev Sets a new owner address
154     */
155     function setOwner(address newOwner) internal {
156         OwnershipTransferred(owner(), newOwner);
157         addressStorage[keccak256("owner")] = newOwner;
158     }
159 }
160 
161 // File: contracts/multisender/Claimable.sol
162 
163 // Roman Storm Multi Sender
164 // To Use this Dapp: https://rstormsf.github.io/multisender
165 pragma solidity 0.4.23;
166 
167 
168 
169 
170 /**
171  * @title Claimable
172  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
173  * This allows the new owner to accept the transfer.
174  */
175 contract Claimable is EternalStorage, Ownable {
176     function pendingOwner() public view returns (address) {
177         return addressStorage[keccak256("pendingOwner")];
178     }
179 
180     /**
181     * @dev Modifier throws if called by any account other than the pendingOwner.
182     */
183     modifier onlyPendingOwner() {
184         require(msg.sender == pendingOwner());
185         _;
186     }
187 
188     /**
189     * @dev Allows the current owner to set the pendingOwner address.
190     * @param newOwner The address to transfer ownership to.
191     */
192     function transferOwnership(address newOwner) public onlyOwner {
193         require(newOwner != address(0));
194         addressStorage[keccak256("pendingOwner")] = newOwner;
195     }
196 
197     /**
198     * @dev Allows the pendingOwner address to finalize the transfer.
199     */
200     function claimOwnership() public onlyPendingOwner {
201         OwnershipTransferred(owner(), pendingOwner());
202         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
203         addressStorage[keccak256("pendingOwner")] = address(0);
204     }
205 }
206 
207 // File: contracts/SafeMath.sol
208 
209 // Roman Storm Multi Sender
210 // To Use this Dapp: https://rstormsf.github.io/multisender
211 pragma solidity 0.4.23;
212 
213 
214 /**
215  * @title SafeMath
216  * @dev Math operations with safety checks that throw on error
217  */
218 library SafeMath {
219 
220   /**
221   * @dev Multiplies two numbers, throws on overflow.
222   */
223   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224     if (a == 0) {
225       return 0;
226     }
227     uint256 c = a * b;
228     assert(c / a == b);
229     return c;
230   }
231 
232   /**
233   * @dev Integer division of two numbers, truncating the quotient.
234   */
235   function div(uint256 a, uint256 b) internal pure returns (uint256) {
236     // assert(b > 0); // Solidity automatically throws when dividing by 0
237     uint256 c = a / b;
238     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239     return c;
240   }
241 
242   /**
243   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
244   */
245   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246     assert(b <= a);
247     return a - b;
248   }
249 
250   /**
251   * @dev Adds two numbers, throws on overflow.
252   */
253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
254     uint256 c = a + b;
255     assert(c >= a);
256     return c;
257   }
258 }
259 
260 // File: contracts/multisender/UpgradebleStormSender.sol
261 
262 // Roman Storm Multi Sender
263 // To Use this Dapp: https://rstormsf.github.io/multisender
264 pragma solidity 0.4.23;
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
298             require(msg.value >= 0);
299         }
300         _;
301     }
302 
303     function() public payable {}
304 
305     function initialize(address _owner) public {
306         require(!initialized());
307         setOwner(_owner);
308         setArrayLimit(150);
309         setDiscountStep(0.00001 ether);
310         setFee(0.0005 ether);
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
363         if (token == 0x000000000000000000000000000000000000bEEF){
364             multisendEther(_contributors, _balances);
365         } else {
366             uint256 total = 0;
367             require(_contributors.length <= arrayLimit());
368             ERC20 erc20token = ERC20(token);
369             uint8 i = 0;
370             for (i; i < _contributors.length; i++) {
371                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
372                 total += _balances[i];
373             }
374             setTxCount(msg.sender, txCount(msg.sender).add(1));
375             Multisended(total, token);
376         }
377     }
378 
379     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
380         uint256 total = msg.value;
381         uint256 fee = currentFee(msg.sender);
382         require(total >= fee);
383         require(_contributors.length <= arrayLimit());
384         total = total.sub(fee);
385         uint256 i = 0;
386         for (i; i < _contributors.length; i++) {
387             require(total >= _balances[i]);
388             total = total.sub(_balances[i]);
389             _contributors[i].transfer(_balances[i]);
390         }
391         setTxCount(msg.sender, txCount(msg.sender).add(1));
392         Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
393     }
394 
395     function claimTokens(address _token) public onlyOwner {
396         if (_token == 0x0) {
397             owner().transfer(this.balance);
398             return;
399         }
400         ERC20 erc20token = ERC20(_token);
401         uint256 balance = erc20token.balanceOf(this);
402         erc20token.transfer(owner(), balance);
403         ClaimedTokens(_token, owner(), balance);
404     }
405 
406     function setTxCount(address customer, uint256 _txCount) private {
407         uintStorage[keccak256("txCount", customer)] = _txCount;
408     }
409 
410 }