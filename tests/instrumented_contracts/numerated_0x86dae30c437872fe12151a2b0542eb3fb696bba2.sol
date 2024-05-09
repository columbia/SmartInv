1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ECRecovery.sol
4 
5 /**
6  * @title Eliptic curve signature operations
7  *
8  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
9  *
10  * TODO Remove this library once solidity supports passing a signature to ecrecover.
11  * See https://github.com/ethereum/solidity/issues/864
12  *
13  */
14 
15 library ECRecovery {
16 
17   /**
18    * @dev Recover signer address from a message by using their signature
19    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
20    * @param sig bytes signature, the signature is generated using web3.eth.sign()
21    */
22   function recover(bytes32 hash, bytes sig)
23     internal
24     pure
25     returns (address)
26   {
27     bytes32 r;
28     bytes32 s;
29     uint8 v;
30 
31     // Check the signature length
32     if (sig.length != 65) {
33       return (address(0));
34     }
35 
36     // Divide the signature in r, s and v variables
37     // ecrecover takes the signature parameters, and the only way to get them
38     // currently is to use assembly.
39     // solium-disable-next-line security/no-inline-assembly
40     assembly {
41       r := mload(add(sig, 32))
42       s := mload(add(sig, 64))
43       v := byte(0, mload(add(sig, 96)))
44     }
45 
46     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
47     if (v < 27) {
48       v += 27;
49     }
50 
51     // If the version is correct return the signer address
52     if (v != 27 && v != 28) {
53       return (address(0));
54     } else {
55       // solium-disable-next-line arg-overflow
56       return ecrecover(hash, v, r, s);
57     }
58   }
59 
60   /**
61    * toEthSignedMessageHash
62    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
63    * @dev and hash the result
64    */
65   function toEthSignedMessageHash(bytes32 hash)
66     internal
67     pure
68     returns (bytes32)
69   {
70     // 32 is the length in bytes of hash,
71     // enforced by the type signature above
72     return keccak256(
73       "\x19Ethereum Signed Message:\n32",
74       hash
75     );
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 contract Ownable {
87   address public owner;
88 
89 
90   event OwnershipRenounced(address indexed previousOwner);
91   event OwnershipTransferred(
92     address indexed previousOwner,
93     address indexed newOwner
94   );
95 
96 
97   /**
98    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99    * account.
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104 
105   /**
106    * @dev Throws if called by any account other than the owner.
107    */
108   modifier onlyOwner() {
109     require(msg.sender == owner);
110     _;
111   }
112 
113   /**
114    * @dev Allows the current owner to relinquish control of the contract.
115    */
116   function renounceOwnership() public onlyOwner {
117     emit OwnershipRenounced(owner);
118     owner = address(0);
119   }
120 
121   /**
122    * @dev Allows the current owner to transfer control of the contract to a newOwner.
123    * @param _newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address _newOwner) public onlyOwner {
126     _transferOwnership(_newOwner);
127   }
128 
129   /**
130    * @dev Transfers control of the contract to a newOwner.
131    * @param _newOwner The address to transfer ownership to.
132    */
133   function _transferOwnership(address _newOwner) internal {
134     require(_newOwner != address(0));
135     emit OwnershipTransferred(owner, _newOwner);
136     owner = _newOwner;
137   }
138 }
139 
140 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable {
147   event Pause();
148   event Unpause();
149 
150   bool public paused = false;
151 
152 
153   /**
154    * @dev Modifier to make a function callable only when the contract is not paused.
155    */
156   modifier whenNotPaused() {
157     require(!paused);
158     _;
159   }
160 
161   /**
162    * @dev Modifier to make a function callable only when the contract is paused.
163    */
164   modifier whenPaused() {
165     require(paused);
166     _;
167   }
168 
169   /**
170    * @dev called by the owner to pause, triggers stopped state
171    */
172   function pause() onlyOwner whenNotPaused public {
173     paused = true;
174     emit Pause();
175   }
176 
177   /**
178    * @dev called by the owner to unpause, returns to normal state
179    */
180   function unpause() onlyOwner whenPaused public {
181     paused = false;
182     emit Unpause();
183   }
184 }
185 
186 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
187 
188 /**
189  * @title SafeMath
190  * @dev Math operations with safety checks that throw on error
191  */
192 library SafeMath {
193 
194   /**
195   * @dev Multiplies two numbers, throws on overflow.
196   */
197   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
198     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
199     // benefit is lost if 'b' is also tested.
200     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
201     if (a == 0) {
202       return 0;
203     }
204 
205     c = a * b;
206     assert(c / a == b);
207     return c;
208   }
209 
210   /**
211   * @dev Integer division of two numbers, truncating the quotient.
212   */
213   function div(uint256 a, uint256 b) internal pure returns (uint256) {
214     // assert(b > 0); // Solidity automatically throws when dividing by 0
215     // uint256 c = a / b;
216     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217     return a / b;
218   }
219 
220   /**
221   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
222   */
223   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224     assert(b <= a);
225     return a - b;
226   }
227 
228   /**
229   * @dev Adds two numbers, throws on overflow.
230   */
231   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
232     c = a + b;
233     assert(c >= a);
234     return c;
235   }
236 }
237 
238 // File: contracts/Airdrop.sol
239 
240 contract KMHTokenInterface {
241   function checkRole(address addr, string roleName) public view;
242 
243   function mint(address _to, uint256 _amount) public returns (bool);
244 }
245 
246 contract NameRegistryInterface {
247   function registerName(address addr, string name) public;
248   function finalizeName(address addr, string name) public;
249 }
250 
251 // Pausable is Ownable
252 contract Airdrop is Pausable {
253   using SafeMath for uint;
254   using ECRecovery for bytes32;
255 
256   event Distribution(address indexed to, uint256 amount);
257 
258   mapping(bytes32 => address) public users;
259   mapping(bytes32 => uint) public unclaimedRewards;
260 
261   address public signer;
262 
263   KMHTokenInterface public token;
264   NameRegistryInterface public nameRegistry;
265 
266   constructor(address _token, address _nameRegistry, address _signer) public {
267     require(_token != address(0));
268     require(_nameRegistry != address(0));
269     require(_signer != address(0));
270 
271     token = KMHTokenInterface(_token);
272     nameRegistry = NameRegistryInterface(_nameRegistry);
273     signer = _signer;
274   }
275 
276   function setSigner(address newSigner) public onlyOwner {
277     require(newSigner != address(0));
278 
279     signer = newSigner;
280   }
281 
282   function claim(
283     address receiver,
284     bytes32 id,
285     string username,
286     bool verified,
287     uint256 amount,
288     bytes32 inviterId,
289     uint256 inviteReward,
290     bytes sig
291   ) public whenNotPaused {
292     require(users[id] == address(0));
293 
294     bytes32 proveHash = getProveHash(receiver, id, username, verified, amount, inviterId, inviteReward);
295     address proveSigner = getMsgSigner(proveHash, sig);
296     require(proveSigner == signer);
297 
298     users[id] = receiver;
299 
300     uint256 unclaimedReward = unclaimedRewards[id];
301     if (unclaimedReward > 0) {
302       unclaimedRewards[id] = 0;
303       _distribute(receiver, unclaimedReward.add(amount));
304     } else {
305       _distribute(receiver, amount);
306     }
307 
308     if (verified) {
309       nameRegistry.finalizeName(receiver, username);
310     } else {
311       nameRegistry.registerName(receiver, username);
312     }
313 
314     if (inviterId == 0) {
315       return;
316     }
317 
318     if (users[inviterId] == address(0)) {
319       unclaimedRewards[inviterId] = unclaimedRewards[inviterId].add(inviteReward);
320     } else {
321       _distribute(users[inviterId], inviteReward);
322     }
323   }
324 
325   function getAccountState(bytes32 id) public view returns (address addr, uint256 unclaimedReward) {
326     addr = users[id];
327     unclaimedReward = unclaimedRewards[id];
328   }
329 
330   function getProveHash(
331     address receiver, bytes32 id, string username, bool verified, uint256 amount, bytes32 inviterId, uint256 inviteReward
332   ) public pure returns (bytes32) {
333     return keccak256(abi.encodePacked(receiver, id, username, verified, amount, inviterId, inviteReward));
334   }
335 
336   function getMsgSigner(bytes32 proveHash, bytes sig) public pure returns (address) {
337     return proveHash.recover(sig);
338   }
339 
340   function _distribute(address to, uint256 amount) internal {
341     token.mint(to, amount);
342     emit Distribution(to, amount);
343   }
344 }