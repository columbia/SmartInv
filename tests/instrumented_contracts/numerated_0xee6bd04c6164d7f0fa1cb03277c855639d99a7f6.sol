1 pragma solidity 0.5.2;
2 
3 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/cryptography/ECDSA.sol
4 
5 /**
6  * @title Elliptic curve signature operations
7  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  */
11 
12 library ECDSA {
13     /**
14      * @dev Recover signer address from a message by using their signature
15      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
16      * @param signature bytes signature, the signature is generated using web3.eth.sign()
17      */
18     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
19         bytes32 r;
20         bytes32 s;
21         uint8 v;
22 
23         // Check the signature length
24         if (signature.length != 65) {
25             return (address(0));
26         }
27 
28         // Divide the signature in r, s and v variables
29         // ecrecover takes the signature parameters, and the only way to get them
30         // currently is to use assembly.
31         // solhint-disable-next-line no-inline-assembly
32         assembly {
33             r := mload(add(signature, 0x20))
34             s := mload(add(signature, 0x40))
35             v := byte(0, mload(add(signature, 0x60)))
36         }
37 
38         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
39         if (v < 27) {
40             v += 27;
41         }
42 
43         // If the version is correct return the signer address
44         if (v != 27 && v != 28) {
45             return (address(0));
46         } else {
47             return ecrecover(hash, v, r, s);
48         }
49     }
50 
51     /**
52      * toEthSignedMessageHash
53      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
54      * and hash the result
55      */
56     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
57         // 32 is the length in bytes of hash,
58         // enforced by the type signature above
59         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
60     }
61 }
62 
63 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/ownership/Ownable.sol
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address private _owner;
72 
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     /**
76      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77      * account.
78      */
79     constructor () internal {
80         _owner = msg.sender;
81         emit OwnershipTransferred(address(0), _owner);
82     }
83 
84     /**
85      * @return the address of the owner.
86      */
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(isOwner());
96         _;
97     }
98 
99     /**
100      * @return true if `msg.sender` is the owner of the contract.
101      */
102     function isOwner() public view returns (bool) {
103         return msg.sender == _owner;
104     }
105 
106     /**
107      * @dev Allows the current owner to relinquish control of the contract.
108      * @notice Renouncing to ownership will leave the contract without an owner.
109      * It will not be possible to call the functions with the `onlyOwner`
110      * modifier anymore.
111      */
112     function renounceOwnership() public onlyOwner {
113         emit OwnershipTransferred(_owner, address(0));
114         _owner = address(0);
115     }
116 
117     /**
118      * @dev Allows the current owner to transfer control of the contract to a newOwner.
119      * @param newOwner The address to transfer ownership to.
120      */
121     function transferOwnership(address newOwner) public onlyOwner {
122         _transferOwnership(newOwner);
123     }
124 
125     /**
126      * @dev Transfers control of the contract to a newOwner.
127      * @param newOwner The address to transfer ownership to.
128      */
129     function _transferOwnership(address newOwner) internal {
130         require(newOwner != address(0));
131         emit OwnershipTransferred(_owner, newOwner);
132         _owner = newOwner;
133     }
134 }
135 
136 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/access/Roles.sol
137 
138 /**
139  * @title Roles
140  * @dev Library for managing addresses assigned to a Role.
141  */
142 library Roles {
143     struct Role {
144         mapping (address => bool) bearer;
145     }
146 
147     /**
148      * @dev give an account access to this role
149      */
150     function add(Role storage role, address account) internal {
151         require(account != address(0));
152         require(!has(role, account));
153 
154         role.bearer[account] = true;
155     }
156 
157     /**
158      * @dev remove an account's access to this role
159      */
160     function remove(Role storage role, address account) internal {
161         require(account != address(0));
162         require(has(role, account));
163 
164         role.bearer[account] = false;
165     }
166 
167     /**
168      * @dev check if an account has this role
169      * @return bool
170      */
171     function has(Role storage role, address account) internal view returns (bool) {
172         require(account != address(0));
173         return role.bearer[account];
174     }
175 }
176 
177 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/access/roles/PauserRole.sol
178 
179 contract PauserRole {
180     using Roles for Roles.Role;
181 
182     event PauserAdded(address indexed account);
183     event PauserRemoved(address indexed account);
184 
185     Roles.Role private _pausers;
186 
187     constructor () internal {
188         _addPauser(msg.sender);
189     }
190 
191     modifier onlyPauser() {
192         require(isPauser(msg.sender));
193         _;
194     }
195 
196     function isPauser(address account) public view returns (bool) {
197         return _pausers.has(account);
198     }
199 
200     function addPauser(address account) public onlyPauser {
201         _addPauser(account);
202     }
203 
204     function renouncePauser() public {
205         _removePauser(msg.sender);
206     }
207 
208     function _addPauser(address account) internal {
209         _pausers.add(account);
210         emit PauserAdded(account);
211     }
212 
213     function _removePauser(address account) internal {
214         _pausers.remove(account);
215         emit PauserRemoved(account);
216     }
217 }
218 
219 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/lifecycle/Pausable.sol
220 
221 /**
222  * @title Pausable
223  * @dev Base contract which allows children to implement an emergency stop mechanism.
224  */
225 contract Pausable is PauserRole {
226     event Paused(address account);
227     event Unpaused(address account);
228 
229     bool private _paused;
230 
231     constructor () internal {
232         _paused = false;
233     }
234 
235     /**
236      * @return true if the contract is paused, false otherwise.
237      */
238     function paused() public view returns (bool) {
239         return _paused;
240     }
241 
242     /**
243      * @dev Modifier to make a function callable only when the contract is not paused.
244      */
245     modifier whenNotPaused() {
246         require(!_paused);
247         _;
248     }
249 
250     /**
251      * @dev Modifier to make a function callable only when the contract is paused.
252      */
253     modifier whenPaused() {
254         require(_paused);
255         _;
256     }
257 
258     /**
259      * @dev called by the owner to pause, triggers stopped state
260      */
261     function pause() public onlyPauser whenNotPaused {
262         _paused = true;
263         emit Paused(msg.sender);
264     }
265 
266     /**
267      * @dev called by the owner to unpause, returns to normal state
268      */
269     function unpause() public onlyPauser whenPaused {
270         _paused = false;
271         emit Unpaused(msg.sender);
272     }
273 }
274 
275 // File: ../mch-dailyaction/contracts/lib/github.com/OpenZeppelin/openzeppelin-solidity-2.1.1/contracts/math/SafeMath.sol
276 
277 /**
278  * @title SafeMath
279  * @dev Unsigned math operations with safety checks that revert on error
280  */
281 library SafeMath {
282     /**
283     * @dev Multiplies two unsigned integers, reverts on overflow.
284     */
285     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
286         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
287         // benefit is lost if 'b' is also tested.
288         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
289         if (a == 0) {
290             return 0;
291         }
292 
293         uint256 c = a * b;
294         require(c / a == b);
295 
296         return c;
297     }
298 
299     /**
300     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
301     */
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         // Solidity only automatically asserts when dividing by 0
304         require(b > 0);
305         uint256 c = a / b;
306         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307 
308         return c;
309     }
310 
311     /**
312     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
313     */
314     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
315         require(b <= a);
316         uint256 c = a - b;
317 
318         return c;
319     }
320 
321     /**
322     * @dev Adds two unsigned integers, reverts on overflow.
323     */
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a + b;
326         require(c >= a);
327 
328         return c;
329     }
330 
331     /**
332     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
333     * reverts when dividing by zero.
334     */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         require(b != 0);
337         return a % b;
338     }
339 }
340 
341 // File: ../mch-dailyaction/contracts/DailyAction.sol
342 
343 contract DailyAction is Ownable, Pausable {
344     using SafeMath for uint256;
345 
346     uint256 public term;
347     address public validater;
348     mapping(address => mapping(address => uint256)) public counter;
349     mapping(address => uint256) public latestActionTime;
350 
351     event Action(
352         address indexed user,
353         address indexed referrer,
354         uint256 at
355     );
356     
357     constructor() public {
358         term = 86400 - 600;
359     }
360     
361     function withdrawEther() external onlyOwner() {
362         msg.sender.transfer(address(this).balance);
363     }
364 
365     function setValidater(address _varidater) external onlyOwner() {
366         validater = _varidater;
367     }
368 
369     function updateTerm(uint256 _term) external onlyOwner() {
370         term = _term;
371     }
372 
373     function requestDailyActionReward(bytes calldata _signature, address _referrer) external whenNotPaused() {
374         require(!isInTerm(msg.sender), "this sender got daily reward within term");
375         uint256 count = getCount(msg.sender);
376         require(validateSig(_signature, count), "invalid signature");
377         emit Action(
378             msg.sender,
379             _referrer,
380             block.timestamp
381         );
382         setCount(msg.sender, count + 1);
383         latestActionTime[msg.sender] = block.timestamp;
384     }
385 
386     function isInTerm(address _sender) public view returns (bool) {
387         if (latestActionTime[_sender] == 0) {
388             return false;
389         } else if (block.timestamp >= latestActionTime[_sender].add(term)) {
390             return false;
391         }
392         return true;
393     }
394 
395     function getCount(address _sender) public view returns (uint256) {
396         if (counter[validater][_sender] == 0) {
397             return 1;
398         }
399         return counter[validater][_sender];
400     }
401 
402     function setCount(address _sender, uint256 _count) private {
403         counter[validater][_sender] = _count;
404     }
405 
406     function validateSig(bytes memory _signature, uint256 _count) private view returns (bool) {
407         require(validater != address(0));
408         uint256 hash = uint256(msg.sender) * _count;
409         address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(bytes32(hash)), _signature);
410         return (signer == validater);
411     }
412 
413     /* function getAddress(bytes32 hash, bytes memory signature) public pure returns (address) { */
414     /*     return ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), signature); */
415     /* } */
416 
417 }