1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 interface SimpleDatabaseInterface {
45   function set(string variable, address value) external returns (bool);
46   function get(string variable) external view returns (address);
47 }
48 
49 library QueryDB {
50   function getAddress(address _db, string _name) internal view returns (address) {
51     return SimpleDatabaseInterface(_db).get(_name);
52   }
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65     if (a == 0) {
66       return 0;
67     }
68     c = a * b;
69     assert(c / a == b);
70     return c;
71   }
72 
73   /**
74   * @dev Integer division of two numbers, truncating the quotient.
75   */
76   function div(uint256 a, uint256 b) internal pure returns (uint256) {
77     // assert(b > 0); // Solidity automatically throws when dividing by 0
78     // uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80     return a / b;
81   }
82 
83   /**
84   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
85   */
86   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87     assert(b <= a);
88     return a - b;
89   }
90 
91   /**
92   * @dev Adds two numbers, throws on overflow.
93   */
94   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
95     c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 /**
102  * @title Elliptic curve signature operations
103  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
104  * TODO Remove this library once solidity supports passing a signature to ecrecover.
105  * See https://github.com/ethereum/solidity/issues/864
106  */
107 
108 library ECDSA {
109     /**
110      * @dev Recover signer address from a message by using their signature
111      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
112      * @param signature bytes signature, the signature is generated using web3.eth.sign()
113      */
114     function recover(bytes32 hash, bytes signature) internal pure returns (address) {
115         bytes32 r;
116         bytes32 s;
117         uint8 v;
118 
119         // Check the signature length
120         if (signature.length != 65) {
121             return (address(0));
122         }
123 
124         // Divide the signature in r, s and v variables
125         // ecrecover takes the signature parameters, and the only way to get them
126         // currently is to use assembly.
127         // solium-disable-next-line security/no-inline-assembly
128         assembly {
129             r := mload(add(signature, 0x20))
130             s := mload(add(signature, 0x40))
131             v := byte(0, mload(add(signature, 0x60)))
132         }
133 
134         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
135         if (v < 27) {
136             v += 27;
137         }
138 
139         // If the version is correct return the signer address
140         if (v != 27 && v != 28) {
141             return (address(0));
142         } else {
143             // solium-disable-next-line arg-overflow
144             return ecrecover(hash, v, r, s);
145         }
146     }
147 
148     /**
149      * toEthSignedMessageHash
150      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
151      * and hash the result
152      */
153     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
154         // 32 is the length in bytes of hash,
155         // enforced by the type signature above
156         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
157     }
158 }
159 
160 interface TokenInterface {
161   function balanceOf(address who) external view returns (uint256);
162   function transfer(address to, uint256 value) external returns (bool);
163   function allowance(address owner, address spender) external view returns (uint256);
164   function transferFrom(address from, address to, uint256 value) external returns (bool);
165   function approve(address spender, uint256 value) external returns (bool);
166 }
167 
168 contract Redeemer is Ownable {
169   using SafeMath for uint256;
170   using QueryDB for address;
171 
172   // Need this struct because of stack too deep error
173   struct Code {
174     address user;
175     uint256 value;
176     uint256 unlockTimestamp;
177     uint256 entropy;
178     bytes signature;
179     bool deactivated;
180     uint256 velocity;
181   }
182 
183   address public DB;
184   address[] public SIGNERS;
185 
186   mapping(bytes32 => Code) public codes;
187 
188   event AddSigner(address indexed owner, address signer);
189   event RemoveSigner(address indexed owner, address signer);
190   event RevokeAllToken(address indexed owner, address recipient, uint256 value);
191   event SupportUser(address indexed owner, address indexed user, uint256 value, uint256 unlockTimestamp, uint256 entropy, bytes signature, uint256 velocity);
192   event DeactivateCode(address indexed owner, address indexed user, uint256 value, uint256 unlockTimestamp, uint256 entropy, bytes signature);
193   event Redeem(address indexed user, uint256 value, uint256 unlockTimestamp, uint256 entropy, bytes signature, uint256 velocity);
194 
195   /**
196    * Constructor
197    */
198   constructor (address _db) public {
199     DB = _db;
200     SIGNERS = [msg.sender];
201   }
202 
203 
204   /**
205    * Modifiers
206    */
207   modifier isValidCode(Code _code) {
208     bytes32 _hash = hash(_code);
209     require(!codes[_hash].deactivated, "Deactivated code.");
210     require(now >= _code.unlockTimestamp, "Lock time is not over.");
211     require(validateSignature(_hash, _code.signature), "Invalid signer.");
212     _;
213   }
214 
215   modifier isValidCodeOwner(address _codeOwner) {
216     require(_codeOwner != address(0), "Invalid sender.");
217     require(msg.sender == _codeOwner, "Invalid sender.");
218     _;
219   }
220 
221   modifier isValidBalance(uint256 _value) {
222     require(_value <= myBalance(), "Not enough balance.");
223     _;
224   }
225 
226   modifier isValidAddress(address _who) {
227     require(_who != address(0), "Invalid address.");
228     _;
229   }
230 
231 
232   /**
233    * Private functions
234    */
235   
236   // Hash function
237   function hash(Code _code) private pure returns (bytes32) {
238     return keccak256(abi.encode(_code.user, _code.value, _code.unlockTimestamp, _code.entropy));
239   }
240 
241   // Check signature
242   function validateSignature(bytes32 _hash, bytes _signature) private view returns (bool) {
243     address _signer = ECDSA.recover(_hash, _signature);
244     return signerExists(_signer);
245   }
246 
247   // Transfer KAT
248   function transferKAT(address _to, uint256 _value) private returns (bool) {
249     bool ok = TokenInterface(DB.getAddress("TOKEN")).transfer(_to, _value);
250     if(!ok) return false;
251     return true;    
252   }
253 
254 
255   /**
256    * Management functions
257    */
258 
259   // Balance of KAT
260   function myBalance() public view returns (uint256) {
261      return TokenInterface(DB.getAddress("TOKEN")).balanceOf(address(this));
262   }
263   
264   // Check address whether is in signer list
265   function signerExists(address _signer) public view returns (bool) {
266     if(_signer == address(0)) return false;
267     for(uint256 i = 0; i < SIGNERS.length; i++) {
268       if(_signer == SIGNERS[i]) return true;
269     }
270     return false;
271   }
272 
273   // Add a signer
274   function addSigner(address _signer) public onlyOwner isValidAddress(_signer) returns (bool) {
275     if(signerExists(_signer)) return true;
276     SIGNERS.push(_signer);
277     emit AddSigner(msg.sender, _signer);
278     return true;
279   }
280 
281   // Remove a signer
282   function removeSigner(address _signer) public onlyOwner isValidAddress(_signer) returns (bool) {
283     for(uint256 i = 0; i < SIGNERS.length; i++) {
284       if(_signer == SIGNERS[i]) {
285         SIGNERS[i] = SIGNERS[SIGNERS.length - 1];
286         delete SIGNERS[SIGNERS.length - 1];
287         emit RemoveSigner(msg.sender, _signer);
288         return true;
289       }
290     }
291     return true;
292   }
293 
294   // Revoke all KAT in case
295   function revokeAllToken(address _recipient) public onlyOwner returns (bool) {
296     uint256 _value = myBalance();
297     emit RevokeAllToken(msg.sender, _recipient, _value);
298     return transferKAT(_recipient, _value);
299   }
300 
301   // Kambria manually supports user in case they don't controll
302   function supportUser(
303     address _user,
304     uint256 _value,
305     uint256 _unlockTimestamp,
306     uint256 _entropy,
307     bytes _signature
308   )
309     public
310     onlyOwner
311     isValidCode(Code(_user, _value, _unlockTimestamp, _entropy, _signature, false, 0))
312     returns (bool)
313   {
314     uint256 _velocity = now - _unlockTimestamp;
315     Code memory _code = Code(_user, _value, _unlockTimestamp, _entropy, _signature, true, _velocity);
316     bytes32 _hash = hash(_code);
317     codes[_hash] = _code;
318     emit SupportUser(msg.sender, _code.user, _code.value, _code.unlockTimestamp, _code.entropy, _code.signature, _code.velocity);
319     return transferKAT(_code.user, _code.value);
320   }
321 
322   // Kambria manually deactivate code
323   function deactivateCode(
324     address _user,
325     uint256 _value,
326     uint256 _unlockTimestamp,
327     uint256 _entropy,
328     bytes _signature
329   ) 
330     public
331     onlyOwner
332     returns (bool)
333   {
334     Code memory _code = Code(_user, _value, _unlockTimestamp, _entropy, _signature, true, 0);
335     bytes32 _hash = hash(_code);
336     codes[_hash] = _code;
337     emit DeactivateCode(msg.sender, _code.user, _code.value, _code.unlockTimestamp, _code.entropy, _code.signature);
338     return true;
339   }
340 
341   /**
342    * User functions
343    */
344   
345   // Redeem
346   function redeem(
347     address _user,
348     uint256 _value,
349     uint256 _unlockTimestamp,
350     uint256 _entropy,
351     bytes _signature
352   )
353     public
354     isValidBalance(_value)
355     isValidCodeOwner(_user)
356     isValidCode(Code(_user, _value, _unlockTimestamp, _entropy, _signature, false, 0))
357     returns (bool)
358   {
359     uint256 _velocity = now - _unlockTimestamp;
360     Code memory _code = Code(_user, _value, _unlockTimestamp, _entropy, _signature, true, _velocity);
361     bytes32 _hash = hash(_code);
362     codes[_hash] = _code;
363     emit Redeem(_code.user, _code.value, _code.unlockTimestamp, _code.entropy, _code.signature, _code.velocity);
364     return transferKAT(_code.user, _code.value);
365   }
366 }