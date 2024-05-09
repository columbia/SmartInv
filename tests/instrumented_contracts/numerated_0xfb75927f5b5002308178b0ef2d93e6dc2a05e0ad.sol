1 // File: contracts/EternalStorage.sol
2 
3 // Roman Storm Multi Sender
4 // To Use this Dapp: https://rstormsf.github.io/multisender
5 pragma solidity 0.4.24;
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
26 // To Use this Dapp: https://rstormsf.github.io/multisender
27 
28 
29 /**
30  * @title UpgradeabilityOwnerStorage
31  * @dev This contract keeps track of the upgradeability owner
32  */
33 contract UpgradeabilityOwnerStorage {
34   // Owner of the contract
35     address private _upgradeabilityOwner;
36 
37     /**
38     * @dev Tells the address of the owner
39     * @return the address of the owner
40     */
41     function upgradeabilityOwner() public view returns (address) {
42         return _upgradeabilityOwner;
43     }
44 
45     /**
46     * @dev Sets the address of the owner
47     */
48     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
49         _upgradeabilityOwner = newUpgradeabilityOwner;
50     }
51 
52 }
53 
54 // File: contracts/UpgradeabilityStorage.sol
55 
56 // Roman Storm Multi Sender
57 // To Use this Dapp: https://rstormsf.github.io/multisender
58 
59 
60 /**
61  * @title UpgradeabilityStorage
62  * @dev This contract holds all the necessary state variables to support the upgrade functionality
63  */
64 contract UpgradeabilityStorage {
65   // Version name of the current implementation
66     string internal _version;
67 
68     // Address of the current implementation
69     address internal _implementation;
70 
71     /**
72     * @dev Tells the version name of the current implementation
73     * @return string representing the name of the current version
74     */
75     function version() public view returns (string) {
76         return _version;
77     }
78 
79     /**
80     * @dev Tells the address of the current implementation
81     * @return address of the current implementation
82     */
83     function implementation() public view returns (address) {
84         return _implementation;
85     }
86 }
87 
88 // File: contracts/OwnedUpgradeabilityStorage.sol
89 
90 // Roman Storm Multi Sender
91 // To Use this Dapp: https://rstormsf.github.io/multisender
92 
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
104 // File: contracts/SafeMath.sol
105 
106 // Roman Storm Multi Sender
107 // To Use this Dapp: https://rstormsf.github.io/multisender
108 
109 
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115 
116   /**
117   * @dev Multiplies two numbers, throws on overflow.
118   */
119   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120     if (a == 0) {
121       return 0;
122     }
123     uint256 c = a * b;
124     assert(c / a == b);
125     return c;
126   }
127 
128   /**
129   * @dev Integer division of two numbers, truncating the quotient.
130   */
131   function div(uint256 a, uint256 b) internal pure returns (uint256) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return c;
136   }
137 
138   /**
139   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
140   */
141   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142     assert(b <= a);
143     return a - b;
144   }
145 
146   /**
147   * @dev Adds two numbers, throws on overflow.
148   */
149   function add(uint256 a, uint256 b) internal pure returns (uint256) {
150     uint256 c = a + b;
151     assert(c >= a);
152     return c;
153   }
154 }
155 
156 // File: contracts/multisender/Ownable.sol
157 
158 // Roman Storm Multi Sender
159 // To Use this Dapp: https://rstormsf.github.io/multisender
160 
161 
162 
163 /**
164  * @title Ownable
165  * @dev This contract has an owner address providing basic authorization control
166  */
167 contract Ownable is EternalStorage {
168     /**
169     * @dev Event to show ownership has been transferred
170     * @param previousOwner representing the address of the previous owner
171     * @param newOwner representing the address of the new owner
172     */
173     event OwnershipTransferred(address previousOwner, address newOwner);
174 
175     /**
176     * @dev Throws if called by any account other than the owner.
177     */
178     modifier onlyOwner() {
179         require(msg.sender == owner());
180         _;
181     }
182 
183     /**
184     * @dev Tells the address of the owner
185     * @return the address of the owner
186     */
187     function owner() public view returns (address) {
188         return addressStorage[keccak256("owner")];
189     }
190 
191     /**
192     * @dev Allows the current owner to transfer control of the contract to a newOwner.
193     * @param newOwner the address to transfer ownership to.
194     */
195     function transferOwnership(address newOwner) public onlyOwner {
196         require(newOwner != address(0));
197         setOwner(newOwner);
198     }
199 
200     /**
201     * @dev Sets a new owner address
202     */
203     function setOwner(address newOwner) internal {
204         emit OwnershipTransferred(owner(), newOwner);
205         addressStorage[keccak256("owner")] = newOwner;
206     }
207 }
208 
209 // File: contracts/multisender/Claimable.sol
210 
211 // Roman Storm Multi Sender
212 // To Use this Dapp: https://rstormsf.github.io/multisender
213 
214 
215 
216 
217 /**
218  * @title Claimable
219  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
220  * This allows the new owner to accept the transfer.
221  */
222 contract Claimable is EternalStorage, Ownable {
223     function pendingOwner() public view returns (address) {
224         return addressStorage[keccak256("pendingOwner")];
225     }
226 
227     /**
228     * @dev Modifier throws if called by any account other than the pendingOwner.
229     */
230     modifier onlyPendingOwner() {
231         require(msg.sender == pendingOwner());
232         _;
233     }
234 
235     /**
236     * @dev Allows the current owner to set the pendingOwner address.
237     * @param newOwner The address to transfer ownership to.
238     */
239     function transferOwnership(address newOwner) public onlyOwner {
240         require(newOwner != address(0));
241         addressStorage[keccak256("pendingOwner")] = newOwner;
242     }
243 
244     /**
245     * @dev Allows the pendingOwner address to finalize the transfer.
246     */
247     function claimOwnership() public onlyPendingOwner {
248         emit OwnershipTransferred(owner(), pendingOwner());
249         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
250         addressStorage[keccak256("pendingOwner")] = address(0);
251     }
252 }
253 
254 // File: contracts/multisender/UpgradebleStormSender.sol
255 
256 // Roman Storm Multi Sender
257 // To Use this Dapp: https://rstormsf.github.io/multisender
258 
259 
260 
261 
262 /**
263  * @title ERC20Basic
264  * @dev Simpler version of ERC20 interface
265  * @dev see https://github.com/ethereum/EIPs/issues/179
266  */
267 contract ERC20Basic {
268     function totalSupply() public view returns (uint256);
269     function balanceOf(address who) public view returns (uint256);
270     function transfer(address to, uint256 value) public returns (bool);
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 }
273 
274 
275 contract ERC20 is ERC20Basic {
276     function allowance(address owner, address spender) public view returns (uint256);
277     function transferFrom(address from, address to, uint256 value) public returns (bool);
278     function approve(address spender, uint256 value) public returns (bool);
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280 }
281 
282 
283 contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
284     using SafeMath for uint256;
285 
286     event Multisended(uint256 total, address tokenAddress);
287     event ClaimedTokens(address token, address owner, uint256 balance);
288 
289     modifier hasFee() {
290         if (currentFee(msg.sender) > 0) {
291             require(msg.value >= currentFee(msg.sender));
292         }
293         _;
294     }
295 
296     function() public payable {}
297 
298     function initialize(address _owner) public {
299         require(!initialized());
300         setOwner(_owner);
301         setArrayLimit(200);
302         setDiscountStep(0.0005 ether);
303         setFee(0.05 ether);
304         boolStorage[keccak256("rs_multisender_initialized")] = true;
305     }
306 
307     function initialized() public view returns (bool) {
308         return boolStorage[keccak256("rs_multisender_initialized")];
309     }
310  
311     function txCount(address customer) public view returns(uint256) {
312         return uintStorage[keccak256(abi.encodePacked("txCount", customer))];
313     }
314 
315     function arrayLimit() public view returns(uint256) {
316         return uintStorage[keccak256(abi.encodePacked("arrayLimit"))];
317     }
318 
319     function setArrayLimit(uint256 _newLimit) public onlyOwner {
320         require(_newLimit != 0);
321         uintStorage[keccak256("arrayLimit")] = _newLimit;
322     }
323 
324     function discountStep() public view returns(uint256) {
325         return uintStorage[keccak256("discountStep")];
326     }
327 
328     function setDiscountStep(uint256 _newStep) public onlyOwner {
329         require(_newStep != 0);
330         uintStorage[keccak256("discountStep")] = _newStep;
331     }
332 
333     function fee() public view returns(uint256) {
334         return uintStorage[keccak256("fee")];
335     }
336 
337     function currentFee(address _customer) public view returns(uint256) {
338         if (fee() > discountRate(msg.sender)) {
339             return fee().sub(discountRate(_customer));
340         } else {
341             return 0;
342         }
343     }
344 
345     function setFee(uint256 _newStep) public onlyOwner {
346         require(_newStep != 0);
347         uintStorage[keccak256("fee")] = _newStep;
348     }
349 
350     function discountRate(address _customer) public view returns(uint256) {
351         uint256 count = txCount(_customer);
352         return count.mul(discountStep());
353     }
354 
355     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
356         if (token == 0x000000000000000000000000000000000000bEEF){
357             multisendEther(_contributors, _balances);
358         } else {
359             uint256 total = 0;
360             require(_contributors.length <= arrayLimit());
361             ERC20 erc20token = ERC20(token);
362             uint8 i = 0;
363             for (i; i < _contributors.length; i++) {
364                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
365                 total += _balances[i];
366             }
367             setTxCount(msg.sender, txCount(msg.sender).add(1));
368             emit Multisended(total, token);
369         }
370     }
371 
372     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
373         uint256 total = msg.value;
374         uint256 userfee = currentFee(msg.sender);
375         require(total >= userfee);
376         require(_contributors.length <= arrayLimit());
377         total = total.sub(userfee);
378         uint256 i = 0;
379         for (i; i < _contributors.length; i++) {
380             require(total >= _balances[i]);
381             total = total.sub(_balances[i]);
382             _contributors[i].transfer(_balances[i]);
383         }
384         setTxCount(msg.sender, txCount(msg.sender).add(1));
385         emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
386     }
387 
388     function claimTokens(address _token) public onlyOwner {
389         if (_token == 0x0) {
390             owner().transfer(address(this).balance);
391             return;
392         }
393         ERC20 erc20token = ERC20(_token);
394         uint256 balance = erc20token.balanceOf(this);
395         erc20token.transfer(owner(), balance);
396         emit ClaimedTokens(_token, owner(), balance);
397     }
398     
399     function setTxCount(address customer, uint256 _txCount) private {
400         uintStorage[keccak256(abi.encodePacked("txCount", customer))] = _txCount;
401     }
402     
403     function sendEtherToOwner() public onlyOwner {                       
404         owner().transfer(this.balance);
405     }
406     
407     function destroy() public onlyOwner {
408         selfdestruct(owner());
409     }
410 
411 }