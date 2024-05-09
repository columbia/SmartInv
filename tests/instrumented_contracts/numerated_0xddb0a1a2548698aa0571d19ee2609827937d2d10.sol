1 // File: contracts/EternalStorage.sol
2 
3 pragma solidity 0.4.25;
4 
5 
6 /**
7  * @title EternalStorage
8  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
9  */
10 contract EternalStorage {
11 
12     mapping(bytes32 => uint256) internal uintStorage;
13     mapping(bytes32 => string) internal stringStorage;
14     mapping(bytes32 => address) internal addressStorage;
15     mapping(bytes32 => bytes) internal bytesStorage;
16     mapping(bytes32 => bool) internal boolStorage;
17     mapping(bytes32 => int256) internal intStorage;
18 
19 }
20 
21 // File: contracts/UpgradeabilityOwnerStorage.sol
22 
23 
24 /**
25  * @title UpgradeabilityOwnerStorage
26  * @dev This contract keeps track of the upgradeability owner
27  */
28 contract UpgradeabilityOwnerStorage {
29   // Owner of the contract
30     address private _upgradeabilityOwner;
31 
32     /**
33     * @dev Tells the address of the owner
34     * @return the address of the owner
35     */
36     function upgradeabilityOwner() public view returns (address) {
37         return _upgradeabilityOwner;
38     }
39 
40     /**
41     * @dev Sets the address of the owner
42     */
43     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
44         _upgradeabilityOwner = newUpgradeabilityOwner;
45     }
46 
47 }
48 
49 // File: contracts/UpgradeabilityStorage.sol
50 
51 
52 /**
53  * @title UpgradeabilityStorage
54  * @dev This contract holds all the necessary state variables to support the upgrade functionality
55  */
56 contract UpgradeabilityStorage {
57   // Version name of the current implementation
58     string internal _version;
59 
60     // Address of the current implementation
61     address internal _implementation;
62 
63     /**
64     * @dev Tells the version name of the current implementation
65     * @return string representing the name of the current version
66     */
67     function version() public view returns (string) {
68         return _version;
69     }
70 
71     /**
72     * @dev Tells the address of the current implementation
73     * @return address of the current implementation
74     */
75     function implementation() public view returns (address) {
76         return _implementation;
77     }
78 }
79 
80 // File: contracts/OwnedUpgradeabilityStorage.sol
81 
82 
83 /**
84  * @title OwnedUpgradeabilityStorage
85  * @dev This is the storage necessary to perform upgradeable contracts.
86  * This means, required state variables for upgradeability purpose and eternal storage per se.
87  */
88 contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}
89 
90 // File: contracts/SafeMath.sol
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: contracts/multisender/Ownable.sol
140 
141 
142 
143 /**
144  * @title Ownable
145  * @dev This contract has an owner address providing basic authorization control
146  */
147 contract Ownable is EternalStorage {
148     /**
149     * @dev Event to show ownership has been transferred
150     * @param previousOwner representing the address of the previous owner
151     * @param newOwner representing the address of the new owner
152     */
153     event OwnershipTransferred(address previousOwner, address newOwner);
154 
155     /**
156     * @dev Throws if called by any account other than the owner.
157     */
158     modifier onlyOwner() {
159         require(msg.sender == owner());
160         _;
161     }
162 
163     /**
164     * @dev Tells the address of the owner
165     * @return the address of the owner
166     */
167     function owner() public view returns (address) {
168         return addressStorage[keccak256("owner")];
169     }
170 
171     /**
172     * @dev Allows the current owner to transfer control of the contract to a newOwner.
173     * @param newOwner the address to transfer ownership to.
174     */
175     function transferOwnership(address newOwner) public onlyOwner {
176         require(newOwner != address(0));
177         setOwner(newOwner);
178     }
179 
180     /**
181     * @dev Sets a new owner address
182     */
183     function setOwner(address newOwner) internal {
184         emit OwnershipTransferred(owner(), newOwner);
185         addressStorage[keccak256("owner")] = newOwner;
186     }
187 }
188 
189 // File: contracts/multisender/Claimable.sol
190 
191 
192 
193 /**
194  * @title Claimable
195  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
196  * This allows the new owner to accept the transfer.
197  */
198 contract Claimable is EternalStorage, Ownable {
199     function pendingOwner() public view returns (address) {
200         return addressStorage[keccak256("pendingOwner")];
201     }
202 
203     /**
204     * @dev Modifier throws if called by any account other than the pendingOwner.
205     */
206     modifier onlyPendingOwner() {
207         require(msg.sender == pendingOwner());
208         _;
209     }
210 
211     /**
212     * @dev Allows the current owner to set the pendingOwner address.
213     * @param newOwner The address to transfer ownership to.
214     */
215     function transferOwnership(address newOwner) public onlyOwner {
216         require(newOwner != address(0));
217         addressStorage[keccak256("pendingOwner")] = newOwner;
218     }
219 
220     /**
221     * @dev Allows the pendingOwner address to finalize the transfer.
222     */
223     function claimOwnership() public onlyPendingOwner {
224         emit OwnershipTransferred(owner(), pendingOwner());
225         addressStorage[keccak256("owner")] = addressStorage[keccak256("pendingOwner")];
226         addressStorage[keccak256("pendingOwner")] = address(0);
227     }
228 }
229 
230 // File: contracts/multisender/UpgradebleStormSender.sol
231 
232 
233 
234 /**
235  * @title ERC20Basic
236  * @dev Simpler version of ERC20 interface
237  * @dev see https://github.com/ethereum/EIPs/issues/179
238  */
239 contract ERC20Basic {
240     function totalSupply() public view returns (uint256);
241     function balanceOf(address who) public view returns (uint256);
242     function transfer(address to, uint256 value) public returns (bool);
243     event Transfer(address indexed from, address indexed to, uint256 value);
244 }
245 
246 
247 contract ERC20 is ERC20Basic {
248     function allowance(address owner, address spender) public view returns (uint256);
249     function transferFrom(address from, address to, uint256 value) public returns (bool);
250     function approve(address spender, uint256 value) public returns (bool);
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 }
253 
254 
255 contract MultiSender is OwnedUpgradeabilityStorage, Claimable {
256     using SafeMath for uint256;
257 
258     event Multisended(uint256 total, address tokenAddress);
259     event ClaimedTokens(address token, address owner, uint256 balance);
260 
261     modifier hasFee() {
262         if (currentFee(msg.sender) >= 0) {
263             require(msg.value >= currentFee(msg.sender));
264         }
265         _;
266     }
267 
268     function() public payable {}
269 
270     function initialize(address _owner) public {
271         require(!initialized());
272         setOwner(_owner);
273         setArrayLimit(200);
274         setDiscountStep(0 ether);
275         setFee(0 ether);
276         boolStorage[keccak256("rs_multisender_initialized")] = true;
277     }
278 
279     function initialized() public view returns (bool) {
280         return boolStorage[keccak256("rs_multisender_initialized")];
281     }
282  
283     function txCount(address customer) public view returns(uint256) {
284         return uintStorage[keccak256(abi.encodePacked("txCount", customer))];
285     }
286 
287     function arrayLimit() public view returns(uint256) {
288         return uintStorage[keccak256(abi.encodePacked("arrayLimit"))];
289     }
290 
291     function setArrayLimit(uint256 _newLimit) public onlyOwner {
292         require(_newLimit != 0);
293         uintStorage[keccak256("arrayLimit")] = _newLimit;
294     }
295 
296     function discountStep() public view returns(uint256) {
297         return uintStorage[keccak256("discountStep")];
298     }
299 
300     function setDiscountStep(uint256 _newStep) public onlyOwner {
301         require(_newStep >= 0);
302         uintStorage[keccak256("discountStep")] = _newStep;
303     }
304 
305     function fee() public view returns(uint256) {
306         return uintStorage[keccak256("fee")];
307     }
308 
309     function currentFee(address _customer) public view returns(uint256) {
310             return 0;
311     }
312 
313     function setFee(uint256 _newStep) public onlyOwner {
314         require(_newStep >= 0);
315         uintStorage[keccak256("fee")] = _newStep;
316     }
317 
318     function discountRate(address _customer) public view returns(uint256) {
319         return 0;
320     }
321 
322     function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
323         if (token == 0x000000000000000000000000000000000000bEEF){
324             multisendEther(_contributors, _balances);
325         } else {
326             uint256 total = 0;
327             require(_contributors.length <= arrayLimit());
328             ERC20 erc20token = ERC20(token);
329             uint8 i = 0;
330             for (i; i < _contributors.length; i++) {
331                 erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
332                 total += _balances[i];
333             }
334             setTxCount(msg.sender, txCount(msg.sender).add(1));
335             emit Multisended(total, token);
336         }
337     }
338 
339     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
340         uint256 total = msg.value;
341         uint256 userfee = currentFee(msg.sender);
342         require(total >= userfee);
343         require(_contributors.length <= arrayLimit());
344         total = total.sub(userfee);
345         uint256 i = 0;
346         for (i; i < _contributors.length; i++) {
347             require(total >= _balances[i]);
348             total = total.sub(_balances[i]);
349             _contributors[i].transfer(_balances[i]);
350         }
351         setTxCount(msg.sender, txCount(msg.sender).add(1));
352         emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
353     }
354 
355     function claimTokens(address _token) public onlyOwner {
356         if (_token == 0x0) {
357             owner().transfer(address(this).balance);
358             return;
359         }
360         ERC20 erc20token = ERC20(_token);
361         uint256 balance = erc20token.balanceOf(this);
362         erc20token.transfer(owner(), balance);
363         emit ClaimedTokens(_token, owner(), balance);
364     }
365     
366     function setTxCount(address customer, uint256 _txCount) private {
367         uintStorage[keccak256(abi.encodePacked("txCount", customer))] = _txCount;
368     }
369 
370 }