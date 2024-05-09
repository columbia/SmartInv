1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title Eliptic curve signature operations
67  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
68  * TODO Remove this library once solidity supports passing a signature to ecrecover.
69  * See https://github.com/ethereum/solidity/issues/864
70  */
71 
72 library ECRecovery {
73 
74   /**
75    * @dev Recover signer address from a message by using their signature
76    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
77    * @param sig bytes signature, the signature is generated using web3.eth.sign()
78    */
79   function recover(bytes32 hash, bytes sig)
80     internal
81     pure
82     returns (address)
83   {
84     bytes32 r;
85     bytes32 s;
86     uint8 v;
87 
88     // Check the signature length
89     if (sig.length != 65) {
90       return (address(0));
91     }
92 
93     // Divide the signature in r, s and v variables
94     // ecrecover takes the signature parameters, and the only way to get them
95     // currently is to use assembly.
96     // solium-disable-next-line security/no-inline-assembly
97     assembly {
98       r := mload(add(sig, 32))
99       s := mload(add(sig, 64))
100       v := byte(0, mload(add(sig, 96)))
101     }
102 
103     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
104     if (v < 27) {
105       v += 27;
106     }
107 
108     // If the version is correct return the signer address
109     if (v != 27 && v != 28) {
110       return (address(0));
111     } else {
112       // solium-disable-next-line arg-overflow
113       return ecrecover(hash, v, r, s);
114     }
115   }
116 
117   /**
118    * toEthSignedMessageHash
119    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
120    * and hash the result
121    */
122   function toEthSignedMessageHash(bytes32 hash)
123     internal
124     pure
125     returns (bytes32)
126   {
127     // 32 is the length in bytes of hash,
128     // enforced by the type signature above
129     return keccak256(
130       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
131     );
132   }
133 }
134 
135 library Utils {
136 
137     /**
138      * @notice Converts a number to its string/bytes representation
139      *
140      * @param _v the uint to convert
141      */
142     function uintToBytes(uint256 _v) internal pure returns (bytes) {
143         uint256 v = _v;
144         if (v == 0) {
145             return "0";
146         }
147 
148         uint256 digits = 0;
149         uint256 v2 = v;
150         while (v2 > 0) {
151             v2 /= 10;
152             digits += 1;
153         }
154 
155         bytes memory result = new bytes(digits);
156 
157         for (uint256 i = 0; i < digits; i++) {
158             result[digits - i - 1] = bytes1((v % 10) + 48);
159             v /= 10;
160         }
161 
162         return result;
163     }
164 
165     /**
166      * @notice Retrieves the address from a signature
167      *
168      * @param _hash the message that was signed (any length of bytes)
169      * @param _signature the signature (65 bytes)
170      */
171     function addr(bytes _hash, bytes _signature) internal pure returns (address) {
172         bytes memory prefix = "\x19Ethereum Signed Message:\n";
173         bytes memory encoded = abi.encodePacked(prefix, uintToBytes(_hash.length), _hash);
174         bytes32 prefixedHash = keccak256(encoded);
175 
176         return ECRecovery.recover(prefixedHash, _signature);
177     }
178 
179 }
180 
181 /// @notice RenExBrokerVerifier implements the BrokerVerifier contract,
182 /// verifying broker signatures for order opening and fund withdrawal.
183 contract RenExBrokerVerifier is Ownable {
184     string public VERSION; // Passed in as a constructor parameter.
185 
186     // Events
187     event LogBalancesContractUpdated(address previousBalancesContract, address nextBalancesContract);
188     event LogBrokerRegistered(address broker);
189     event LogBrokerDeregistered(address broker);
190 
191     // Storage
192     mapping(address => bool) public brokers;
193     mapping(address => uint256) public traderNonces;
194 
195     address public balancesContract;
196 
197     modifier onlyBalancesContract() {
198         require(msg.sender == balancesContract, "not authorized");
199         _;
200     }
201 
202     /// @notice The contract constructor.
203     ///
204     /// @param _VERSION A string defining the contract version.
205     constructor(string _VERSION) public {
206         VERSION = _VERSION;
207     }
208 
209     /// @notice Allows the owner of the contract to update the address of the
210     /// RenExBalances contract.
211     ///
212     /// @param _balancesContract The address of the new balances contract
213     function updateBalancesContract(address _balancesContract) external onlyOwner {
214         emit LogBalancesContractUpdated(balancesContract, _balancesContract);
215 
216         balancesContract = _balancesContract;
217     }
218 
219     /// @notice Approved an address to sign order-opening and withdrawals.
220     /// @param _broker The address of the broker.
221     function registerBroker(address _broker) external onlyOwner {
222         require(!brokers[_broker], "already registered");
223         brokers[_broker] = true;
224         emit LogBrokerRegistered(_broker);
225     }
226 
227     /// @notice Reverts the a broker's registration.
228     /// @param _broker The address of the broker.
229     function deregisterBroker(address _broker) external onlyOwner {
230         require(brokers[_broker], "not registered");
231         brokers[_broker] = false;
232         emit LogBrokerDeregistered(_broker);
233     }
234 
235     /// @notice Verifies a broker's signature for an order opening.
236     /// The data signed by the broker is a prefixed message and the order ID.
237     ///
238     /// @param _trader The trader requesting the withdrawal.
239     /// @param _signature The 65-byte signature from the broker.
240     /// @param _orderID The 32-byte order ID.
241     /// @return True if the signature is valid, false otherwise.
242     function verifyOpenSignature(
243         address _trader,
244         bytes _signature,
245         bytes32 _orderID
246     ) external view returns (bool) {
247         bytes memory data = abi.encodePacked("Republic Protocol: open: ", _trader, _orderID);
248         address signer = Utils.addr(data, _signature);
249         return (brokers[signer] == true);
250     }
251 
252     /// @notice Verifies a broker's signature for a trader withdrawal.
253     /// The data signed by the broker is a prefixed message, the trader address
254     /// and a 256-bit trader nonce, which is incremented every time a valid
255     /// signature is checked.
256     ///
257     /// @param _trader The trader requesting the withdrawal.
258     /// @param _signature 65-byte signature from the broker.
259     /// @return True if the signature is valid, false otherwise.
260     function verifyWithdrawSignature(
261         address _trader,
262         bytes _signature
263     ) external onlyBalancesContract returns (bool) {
264         bytes memory data = abi.encodePacked("Republic Protocol: withdraw: ", _trader, traderNonces[_trader]);
265         address signer = Utils.addr(data, _signature);
266         if (brokers[signer]) {
267             traderNonces[_trader] += 1;
268             return true;
269         }
270         return false;
271     }
272 }