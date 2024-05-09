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
125     
126     event OwnershipTransferred(address previousOwner, address newOwner);
127 
128     /**
129     * @dev Throws if called by any account other than the owner.
130     */
131     modifier onlyOwner() {
132         require(msg.sender == owner());
133         _;
134     }
135 
136     /**
137     * @dev Tells the address of the owner
138     * @return the address of the owner
139     */
140     function owner() public view returns (address) {
141         return addressStorage[keccak256("owner")];
142     }
143 
144     /**
145     * @dev Allows the current owner to transfer control of the contract to a newOwner.
146     * @param newOwner the address to transfer ownership to.
147     */
148     function transferOwnership(address newOwner) public onlyOwner {
149         require(newOwner != address(0));
150         setOwner(newOwner);
151     }
152 
153     /**
154     * @dev Sets a new owner address
155     */
156     function setOwner(address newOwner) internal {
157         newOwner = msg.sender;
158         OwnershipTransferred(owner(), newOwner);
159         addressStorage[keccak256("owner")] = newOwner;
160     }
161 }
162 
163 // File: contracts/multisender/Claimable.sol
164 
165 // Roman Storm Multi Sender
166 // To Use this Dapp: https://rstormsf.github.io/multisender
167 pragma solidity 0.4.23;
168 
169 
170 
171 
172 /**
173  * @title Claimable
174  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
175  * This allows the new owner to accept the transfer.
176  */
177 contract Claimable is EternalStorage, Ownable {
178     function pendingOwner() public view returns (address) {
179         return addressStorage[keccak256("pendingOwner")];
180     }
181 
182     /**
183     * @dev Modifier throws if called by any account other than the pendingOwner.
184     */
185     modifier onlyPendingOwner() {
186         require(msg.sender == pendingOwner());
187         _;
188     }
189 
190     /**
191     * @dev Allows the current owner to set the pendingOwner address.
192     * @param newOwner The address to transfer ownership to.
193     */
194     function transferOwnership(address newOwner) public onlyOwner {
195         require(newOwner != address(0));
196         addressStorage[keccak256("pendingOwner")] = newOwner;
197     }
198 
199     /**
200     * @dev Allows the pendingOwner address to finalize the transfer.
201     */
202     function claimOwnership() public onlyPendingOwner {
203         OwnershipTransferred(owner(), pendingOwner());
204         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
205         addressStorage[keccak256("pendingOwner")] = address(0);
206     }
207 }
208 
209 // File: contracts/SafeMath.sol
210 
211 // Roman Storm Multi Sender
212 // To Use this Dapp: https://rstormsf.github.io/multisender
213 pragma solidity 0.4.23;
214 
215 
216 /**
217  * @title SafeMath
218  * @dev Math operations with safety checks that throw on error
219  */
220 library SafeMath {
221 
222   /**
223   * @dev Multiplies two numbers, throws on overflow.
224   */
225   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226     if (a == 0) {
227       return 0;
228     }
229     uint256 c = a * b;
230     assert(c / a == b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241     return c;
242   }
243 
244   /**
245   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 a, uint256 b) internal pure returns (uint256) {
256     uint256 c = a + b;
257     assert(c >= a);
258     return c;
259   }
260 }
261 
262 // File: contracts/multisender/UpgradebleStormSender.sol
263 
264 // Roman Storm Multi Sender
265 // To Use this Dapp: https://rstormsf.github.io/multisender
266 pragma solidity 0.4.23;
267 
268 
269 
270 
271 /**
272  * @title ERC20Basic
273  * @dev Simpler version of ERC20 interface
274  * @dev see https://github.com/ethereum/EIPs/issues/179
275  */
276 contract ERC20Basic {
277     function totalSupply() public view returns (uint256);
278     function balanceOf(address who) public view returns (uint256);
279     function transfer(address to, uint256 value) public returns (bool);
280     event Transfer(address indexed from, address indexed to, uint256 value);
281 }
282 
283 
284 contract ERC20 is ERC20Basic {
285     function allowance(address owner, address spender) public view returns (uint256);
286     function transferFrom(address from, address to, uint256 value) public returns (bool);
287     function approve(address spender, uint256 value) public returns (bool);
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 
292 contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
293     using SafeMath for uint256;
294 
295     event Multisended(uint256 total, address tokenAddress);
296     event ClaimedTokens(address token, address owner, uint256 balance);
297 
298     modifier hasFee() {
299         if (currentFee(msg.sender) > 0) {
300             require(msg.value >= 0);
301         }
302         _;
303     }
304 
305     function() public payable {}
306 
307     function initialize(address _owner) public {
308         require(!initialized());
309         setOwner(_owner);
310         setArrayLimit(150);
311         setDiscountStep(0.00000 ether);
312         setFee(0.00000 ether);
313         boolStorage[keccak256("rs_multisender_initialized")] = true;
314     }
315 
316     function initialized() public view returns (bool) {
317         return boolStorage[keccak256("rs_multisender_initialized")];
318     }
319 
320     function txCount(address customer) public view returns(uint256) {
321         return uintStorage[keccak256("txCount", customer)];
322     }
323 
324     function arrayLimit() public view returns(uint256) {
325         return uintStorage[keccak256("arrayLimit")];
326     }
327 
328     function setArrayLimit(uint256 _newLimit) public onlyOwner {
329         require(_newLimit != 0);
330         uintStorage[keccak256("arrayLimit")] = _newLimit;
331     }
332 
333     function discountStep() public view returns(uint256) {
334         return uintStorage[keccak256("discountStep")];
335     }
336 
337     function setDiscountStep(uint256 _newStep) public onlyOwner {
338         require(_newStep != 0);
339         uintStorage[keccak256("discountStep")] = _newStep;
340     }
341 
342     function fee() public view returns(uint256) {
343         return uintStorage[keccak256("fee")];
344     }
345 
346     function currentFee(address _customer) public view returns(uint256) {
347         if (fee() > discountRate(msg.sender)) {
348             return fee().sub(discountRate(_customer));
349         } else {
350             return 0;
351         }
352     }
353 
354     function setFee(uint256 _newStep) public onlyOwner {
355         require(_newStep != 0);
356         uintStorage[keccak256("fee")] = _newStep;
357     }
358 
359     function discountRate(address _customer) public view returns(uint256) {
360         uint256 count = txCount(_customer);
361         return count.mul(discountStep());
362     }
363 
364     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
365         if (token == 0x000000000000000000000000000000000000bEEF){
366             multisendEther(_contributors, _balances);
367         } else {
368             uint256 total = 0;
369             require(_contributors.length <= arrayLimit());
370             ERC20 erc20token = ERC20(token);
371             uint8 i = 0;
372             for (i; i < _contributors.length; i++) {
373                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
374                 total += _balances[i];
375             }
376             setTxCount(msg.sender, txCount(msg.sender).add(1));
377             Multisended(total, token);
378         }
379     }
380 
381     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
382         uint256 total = msg.value;
383         uint256 fee = currentFee(msg.sender);
384         require(total >= fee);
385         require(_contributors.length <= arrayLimit());
386         total = total.sub(fee);
387         uint256 i = 0;
388         for (i; i < _contributors.length; i++) {
389             require(total >= _balances[i]);
390             total = total.sub(_balances[i]);
391             _contributors[i].transfer(_balances[i]);
392         }
393         setTxCount(msg.sender, txCount(msg.sender).add(1));
394         Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
395     }
396 
397     function claimTokens(address _token) public onlyOwner {
398         if (_token == 0x0) {
399             owner().transfer(this.balance);
400             return;
401         }
402         ERC20 erc20token = ERC20(_token);
403         uint256 balance = erc20token.balanceOf(this);
404         erc20token.transfer(owner(), balance);
405         ClaimedTokens(_token, owner(), balance);
406     }
407 
408     function setTxCount(address customer, uint256 _txCount) private {
409         uintStorage[keccak256("txCount", customer)] = _txCount;
410     }
411 
412 }