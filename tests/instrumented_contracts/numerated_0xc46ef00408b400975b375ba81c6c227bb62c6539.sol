1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * @title Roles
78  * @dev Library for managing addresses assigned to a Role.
79  */
80 library Roles {
81     struct Role {
82         mapping (address => bool) bearer;
83     }
84 
85     /**
86      * @dev give an account access to this role
87      */
88     function add(Role storage role, address account) internal {
89         require(account != address(0));
90         require(!has(role, account));
91 
92         role.bearer[account] = true;
93     }
94 
95     /**
96      * @dev remove an account's access to this role
97      */
98     function remove(Role storage role, address account) internal {
99         require(account != address(0));
100         require(has(role, account));
101 
102         role.bearer[account] = false;
103     }
104 
105     /**
106      * @dev check if an account has this role
107      * @return bool
108      */
109     function has(Role storage role, address account) internal view returns (bool) {
110         require(account != address(0));
111         return role.bearer[account];
112     }
113 }
114 
115 pragma solidity ^0.5.0;
116 
117 
118 contract PauserRole {
119     using Roles for Roles.Role;
120 
121     event PauserAdded(address indexed account);
122     event PauserRemoved(address indexed account);
123 
124     Roles.Role private _pausers;
125 
126     constructor () internal {
127         _addPauser(msg.sender);
128     }
129 
130     modifier onlyPauser() {
131         require(isPauser(msg.sender));
132         _;
133     }
134 
135     function isPauser(address account) public view returns (bool) {
136         return _pausers.has(account);
137     }
138 
139     function addPauser(address account) public onlyPauser {
140         _addPauser(account);
141     }
142 
143     function renouncePauser() public {
144         _removePauser(msg.sender);
145     }
146 
147     function _addPauser(address account) internal {
148         _pausers.add(account);
149         emit PauserAdded(account);
150     }
151 
152     function _removePauser(address account) internal {
153         _pausers.remove(account);
154         emit PauserRemoved(account);
155     }
156 }
157 
158 pragma solidity ^0.5.0;
159 
160 
161 /**
162  * @title Pausable
163  * @dev Base contract which allows children to implement an emergency stop mechanism.
164  */
165 contract Pausable is PauserRole {
166     event Paused(address account);
167     event Unpaused(address account);
168 
169     bool private _paused;
170 
171     constructor () internal {
172         _paused = false;
173     }
174 
175     /**
176      * @return true if the contract is paused, false otherwise.
177      */
178     function paused() public view returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is not paused.
184      */
185     modifier whenNotPaused() {
186         require(!_paused);
187         _;
188     }
189 
190     /**
191      * @dev Modifier to make a function callable only when the contract is paused.
192      */
193     modifier whenPaused() {
194         require(_paused);
195         _;
196     }
197 
198     /**
199      * @dev called by the owner to pause, triggers stopped state
200      */
201     function pause() public onlyPauser whenNotPaused {
202         _paused = true;
203         emit Paused(msg.sender);
204     }
205 
206     /**
207      * @dev called by the owner to unpause, returns to normal state
208      */
209     function unpause() public onlyPauser whenPaused {
210         _paused = false;
211         emit Unpaused(msg.sender);
212     }
213 }
214 
215 pragma solidity ^0.5.0;
216 
217 /**
218  * @title Elliptic curve signature operations
219  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
220  * TODO Remove this library once solidity supports passing a signature to ecrecover.
221  * See https://github.com/ethereum/solidity/issues/864
222  */
223 
224 library ECDSA {
225     /**
226      * @dev Recover signer address from a message by using their signature
227      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
228      * @param signature bytes signature, the signature is generated using web3.eth.sign()
229      */
230     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
231         bytes32 r;
232         bytes32 s;
233         uint8 v;
234 
235         // Check the signature length
236         if (signature.length != 65) {
237             return (address(0));
238         }
239 
240         // Divide the signature in r, s and v variables
241         // ecrecover takes the signature parameters, and the only way to get them
242         // currently is to use assembly.
243         // solhint-disable-next-line no-inline-assembly
244         assembly {
245             r := mload(add(signature, 0x20))
246             s := mload(add(signature, 0x40))
247             v := byte(0, mload(add(signature, 0x60)))
248         }
249 
250         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
251         if (v < 27) {
252             v += 27;
253         }
254 
255         // If the version is correct return the signer address
256         if (v != 27 && v != 28) {
257             return (address(0));
258         } else {
259             return ecrecover(hash, v, r, s);
260         }
261     }
262 
263     /**
264      * toEthSignedMessageHash
265      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
266      * and hash the result
267      */
268     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
269         // 32 is the length in bytes of hash,
270         // enforced by the type signature above
271         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
272     }
273 }
274 
275 pragma solidity ^0.5.0;
276 
277 /**
278  * Валидаторы
279  */
280 
281 contract ValidationUtil {
282     function requireNotEmptyAddress(address value) internal view{
283         require(isAddressNotEmpty(value));
284     }
285 
286     function isAddressNotEmpty(address value) internal view returns (bool result){
287         return value != address(0x0);
288     }
289 }
290 
291 pragma solidity ^0.5.0;
292 
293 /**
294  * Контракт шахт
295  */
296 
297 contract ImpMine is Ownable, Pausable, ValidationUtil {
298     using ECDSA for bytes32;
299 
300     /* Акк, куда переводятся средства */
301     address payable private _destinationWallet;
302 
303     /* Мапа уже совершенных апгрейдов, хэш: акк пользователя + id шахты + level */
304     mapping (bytes32 => bool) private _userUpgrades;
305 
306     /* Мапа стоимостей агрейда: level => wei */
307     mapping (uint => uint) private _upgradePrices;
308 
309     /* Событие апгрейда шахты */
310     event MineUpgraded(address receiver, uint mineId, uint level, uint buyPrice);
311 
312     function upgrade(uint mineId, uint level, bytes calldata signature) external payable validDestinationWallet whenNotPaused {
313         // 0 суммы - не принимаем
314         require(msg.value != 0);
315 
316         // Акк пользователя, id шахты, уровень апгрейда
317         bytes32 validatingHash = keccak256(abi.encodePacked(msg.sender, mineId, level));
318 
319         // Подписывать все транзакции должен owner
320         address addressRecovered = validatingHash.toEthSignedMessageHash().recover(signature);
321         require(addressRecovered == owner());
322 
323         // Проверям, был ли уже апгрейд?
324         require(!_userUpgrades[validatingHash]);
325 
326         //Проверяем установленную сумму в апгрейде
327         require(_upgradePrices[level] == msg.value);
328 
329         // Делаем перевод получателю, в случае неудачи будет throws
330         _destinationWallet.transfer(msg.value);
331 
332         _userUpgrades[validatingHash] = true;
333 
334         emit MineUpgraded(msg.sender, mineId, level, msg.value);
335     }
336 
337     function isUserUpgraded(address userAddress, uint mineId, uint level) public view returns (bool) {
338         return _userUpgrades[keccak256(abi.encodePacked(userAddress, mineId, level))];
339     }
340 
341     function setUpgradePrice(uint level, uint price) external onlyOwner {
342         // 0 суммы - не принимаем
343         require(price != 0);
344 
345         _upgradePrices[level] = price;
346     }
347 
348     function getUpgradePrice(uint level) public view returns (uint) {
349         return _upgradePrices[level];
350     }
351 
352     function setDestinationWallet(address payable walletAddress) external onlyOwner {
353         requireNotEmptyAddress(walletAddress);
354 
355         _destinationWallet = walletAddress;
356     }
357 
358     function getDestinationWallet() public view returns (address) {
359         return _destinationWallet;
360     }
361 
362     modifier validDestinationWallet() {
363         requireNotEmptyAddress(_destinationWallet);
364         _;
365     }
366 }