1 // File: contracts/EternalStorage.sol
2 
3 // Initial code from Roman Storm Multi Sender
4 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
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
25 // Initial code from Roman Storm Multi Sender
26 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
27 pragma solidity 0.4.23;
28 
29 /**
30  * @title UpgradeabilityStorage
31  * @dev This contract holds all the necessary state variables to support the upgrade functionality
32  */
33 contract UpgradeabilityStorage {
34   // Version name of the current implementation
35     string internal _version;
36 
37     // Address of the current implementation
38     address internal _implementation;
39 
40     /**
41     * @dev Tells the version name of the current implementation
42     * @return string representing the name of the current version
43     */
44     function version() public view returns (string) {
45         return _version;
46     }
47 
48     /**
49     * @dev Tells the address of the current implementation
50     * @return address of the current implementation
51     */
52     function implementation() public view returns (address) {
53         return _implementation;
54     }
55 }
56 
57 // File: contracts/UpgradeabilityOwnerStorage.sol
58 
59 // Initial code from Roman Storm Multi Sender
60 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
61 pragma solidity 0.4.23;
62 
63 /**
64  * @title UpgradeabilityOwnerStorage
65  * @dev This contract keeps track of the upgradeability owner
66  */
67 contract UpgradeabilityOwnerStorage {
68   // Owner of the contract
69     address private _upgradeabilityOwner;
70 
71     /**
72     * @dev Tells the address of the owner
73     * @return the address of the owner
74     */
75     function upgradeabilityOwner() public view returns (address) {
76         return _upgradeabilityOwner;
77     }
78 
79     /**
80     * @dev Sets the address of the owner
81     */
82     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
83         _upgradeabilityOwner = newUpgradeabilityOwner;
84     }
85 
86 }
87 
88 // File: contracts/OwnedUpgradeabilityStorage.sol
89 
90 // Initial code from Roman Storm Multi Sender
91 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
92 pragma solidity 0.4.23;
93 
94 
95 
96 
97 /**
98  * @title OwnedUpgradeabilityStorage
99  * @dev This is the storage necessary to perform upgradeable contracts.
100  * This means, required state variables for upgradeability purpose and eternal storage per se.
101  */
102 contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}
103 
104 // File: contracts/bulktokensending/Ownable.sol
105 
106 // Initial code from Roman Storm Multi Sender
107 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
108 pragma solidity 0.4.23;
109 
110 
111 /**
112  * @title Ownable
113  * @dev This contract has an owner address providing basic authorization control
114  */
115 contract Ownable is EternalStorage {
116     /**
117     * @dev Event to show ownership has been transferred
118     * @param previousOwner representing the address of the previous owner
119     * @param newOwner representing the address of the new owner
120     */
121     event OwnershipTransferred(address previousOwner, address newOwner);
122 
123     /**
124     * @dev Throws if called by any account other than the owner.
125     */
126     modifier onlyOwner() {
127         require(msg.sender == owner());
128         _;
129     }
130 
131     /**
132     * @dev Tells the address of the owner
133     * @return the address of the owner
134     */
135     function owner() public view returns (address) {
136         return addressStorage[keccak256("owner")];
137     }
138 
139     /**
140     * @dev Allows the current owner to transfer control of the contract to a newOwner.
141     * @param newOwner the address to transfer ownership to.
142     */
143     function transferOwnership(address newOwner) public onlyOwner {
144         require(newOwner != address(0));
145         setOwner(newOwner);
146     }
147 
148     /**
149     * @dev Sets a new owner address
150     */
151     function setOwner(address newOwner) internal {
152         emit OwnershipTransferred(owner(), newOwner);
153         addressStorage[keccak256("owner")] = newOwner;
154     }
155 }
156 
157 // File: contracts/bulktokensending/Claimable.sol
158 
159 // Initial code from Roman Storm Multi Sender
160 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
161 pragma solidity 0.4.23;
162 
163 
164 
165 /**
166  * @title Claimable
167  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
168  * This allows the new owner to accept the transfer.
169  */
170 contract Claimable is EternalStorage, Ownable {
171     function pendingOwner() public view returns (address) {
172         return addressStorage[keccak256("pendingOwner")];
173     }
174 
175     /**
176     * @dev Modifier throws if called by any account other than the pendingOwner.
177     */
178     modifier onlyPendingOwner() {
179         require(msg.sender == pendingOwner());
180         _;
181     }
182 
183     /**
184     * @dev Allows the current owner to set the pendingOwner address.
185     * @param newOwner The address to transfer ownership to.
186     */
187     function transferOwnership(address newOwner) public onlyOwner {
188         require(newOwner != address(0));
189         addressStorage[keccak256("pendingOwner")] = newOwner;
190     }
191 
192     /**
193     * @dev Allows the pendingOwner address to finalize the transfer.
194     */
195     function claimOwnership() public onlyPendingOwner {
196         emit OwnershipTransferred(owner(), pendingOwner());
197         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
198         addressStorage[keccak256("pendingOwner")] = address(0);
199     }
200 }
201 
202 // File: contracts/SafeMath.sol
203 
204 // Initial code from Roman Storm Multi Sender
205 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
206 pragma solidity 0.4.23;
207 
208 /**
209  * @title SafeMath
210  * @dev Math operations with safety checks that throw on error
211  */
212 library SafeMath {
213 
214   /**
215   * @dev Multiplies two numbers, throws on overflow.
216   */
217   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218     if (a == 0) {
219       return 0;
220     }
221     uint256 c = a * b;
222     assert(c / a == b);
223     return c;
224   }
225 
226   /**
227   * @dev Integer division of two numbers, truncating the quotient.
228   */
229   function div(uint256 a, uint256 b) internal pure returns (uint256) {
230     // assert(b > 0); // Solidity automatically throws when dividing by 0
231     uint256 c = a / b;
232     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233     return c;
234   }
235 
236   /**
237   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
238   */
239   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240     assert(b <= a);
241     return a - b;
242   }
243 
244   /**
245   * @dev Adds two numbers, throws on overflow.
246   */
247   function add(uint256 a, uint256 b) internal pure returns (uint256) {
248     uint256 c = a + b;
249     assert(c >= a);
250     return c;
251   }
252 }
253 
254 // File: contracts\bulktokensending\UpgradebleSender.sol
255 
256 // Initial code from Roman Storm Multi Sender
257 // To Use this Dapp: https://bulktokensenending.github.io/bulktokensenending
258 pragma solidity 0.4.23;
259 
260 
261 
262 
263 /**
264  * @title ERC20Basic
265  * @dev Simpler version of ERC20 interface
266  * @dev see https://github.com/ethereum/EIPs/issues/179
267  */
268 contract ERC20Basic {
269     function totalSupply() public view returns (uint256);
270     function balanceOf(address who) public view returns (uint256);
271     function transfer(address to, uint256 value) public returns (bool);
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 }
274 
275 contract ERC20 is ERC20Basic {
276     function allowance(address owner, address spender) public view returns (uint256);
277     function transferFrom(address from, address to, uint256 value) public returns (bool);
278     function approve(address spender, uint256 value) public returns (bool);
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280 }
281 
282 contract UpgradebleSender is OwnedUpgradeabilityStorage, Claimable {
283     using SafeMath for uint256;
284 
285     event BulkSending(uint256 total, address tokenAddress);
286     event ClaimedTokens(address token, address owner, uint256 balance);
287 
288     modifier hasFee() {
289         if (currentFee(msg.sender) > 0) {
290             require(msg.value >= currentFee(msg.sender));
291         }
292         _;
293     }
294 
295     function() public payable {}
296 
297     function initialize(address _owner) public {
298         require(!initialized());
299         setOwner(_owner);
300         setArrayLimit(200);
301         setDiscountStep(0.00005 ether);
302         setFee(0.05 ether);
303         boolStorage[keccak256("rs_bulktokensenending_initialized")] = true;
304     }
305 
306     function initialized() public view returns (bool) {
307         return boolStorage[keccak256("rs_bulktokensenending_initialized")];
308     }
309 
310     function txCount(address customer) public view returns(uint256) {
311         return uintStorage[keccak256("txCount", customer)];
312     }
313 
314     function arrayLimit() public view returns(uint256) {
315         return uintStorage[keccak256("arrayLimit")];
316     }
317 
318     function setArrayLimit(uint256 _newLimit) public onlyOwner {
319         require(_newLimit != 0);
320         uintStorage[keccak256("arrayLimit")] = _newLimit;
321     }
322 
323     function discountStep() public view returns(uint256) {
324         return uintStorage[keccak256("discountStep")];
325     }
326 
327     function setDiscountStep(uint256 _newStep) public onlyOwner {
328         require(_newStep != 0);
329         uintStorage[keccak256("discountStep")] = _newStep;
330     }
331 
332     function fee() public view returns(uint256) {
333         return uintStorage[keccak256("fee")];
334     }
335 
336     function currentFee(address _customer) public view returns(uint256) {
337         if (fee() > discountRate(msg.sender)) {
338             return fee().sub(discountRate(_customer));
339         } else {
340             return 0;
341         }
342     }
343 
344     function setFee(uint256 _newStep) public onlyOwner {
345         require(_newStep != 0);
346         uintStorage[keccak256("fee")] = _newStep;
347     }
348 
349     function discountRate(address _customer) public view returns(uint256) {
350         uint256 count = txCount(_customer);
351         return count.mul(discountStep());
352     }
353 
354     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
355         if (token == 0x000000000000000000000000000000000000bEEF){
356             multisendEther(_contributors, _balances);
357         } else {
358             uint256 total = 0;
359             require(_contributors.length <= arrayLimit());
360             ERC20 erc20token = ERC20(token);
361             uint8 i = 0;
362             for (i; i < _contributors.length; i++) {
363                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
364                 total += _balances[i];
365             }
366             setTxCount(msg.sender, txCount(msg.sender).add(1));
367             emit BulkSending(total, token);
368         }
369     }
370 
371     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
372         uint256 total = msg.value;
373         uint256 _fee = currentFee(msg.sender);
374         require(total >= _fee);
375         require(_contributors.length <= arrayLimit());
376         total = total.sub(_fee);
377         uint256 i = 0;
378         for (i; i < _contributors.length; i++) {
379             require(total >= _balances[i]);
380             total = total.sub(_balances[i]);
381             _contributors[i].transfer(_balances[i]);
382         }
383         setTxCount(msg.sender, txCount(msg.sender).add(1));
384         emit BulkSending(msg.value, 0x000000000000000000000000000000000000bEEF);
385     }
386 
387     function claimTokens(address _token) public onlyOwner {
388         if (_token == 0x0) {
389             owner().transfer(address(this).balance);
390             return;
391         }
392         ERC20 erc20token = ERC20(_token);
393         uint256 balance = erc20token.balanceOf(this);
394         erc20token.transfer(owner(), balance);
395         emit ClaimedTokens(_token, owner(), balance);
396     }
397 
398     function setTxCount(address customer, uint256 _txCount) private {
399         uintStorage[keccak256("txCount", customer)] = _txCount;
400     }
401 }