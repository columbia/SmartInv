1 pragma solidity >=0.5.7 <0.6.0;
2 
3 contract SmartLockerRegistrar {
4 
5     // forward registrar
6     mapping(address=>bytes32) registrar;
7 
8     // reverse registrar
9     mapping(bytes32=>address) reverseRegistrar;
10 
11     // fallback function (external non-payable)
12     function() external {}
13 
14     // events
15     event SmartLockerCreated(bytes32 name, address smartLockerAddress);
16 
17     // create new smart locker with given name and keyname (external payable)
18     function createSmartLocker(bytes32 name, bytes32 keyname) external payable
19         returns (address) {
20 
21         // require name not null
22         require(name != bytes32(0));
23 
24         // require name not already exist
25         require(reverseRegistrar[name] == address(0));
26 
27         // require keyname not null
28         require(keyname != bytes32(0));
29 
30         // deploy a new smart locker and send all value
31         SmartLocker smartLocker = (new SmartLocker).value(msg.value)(msg.sender, keyname);
32 
33         // register the smart locker address with the given name
34         address smartLockerAddress = address(smartLocker);
35         registrar[smartLockerAddress] = name;
36 
37         // add corresponding entry to the reverse registrar
38         reverseRegistrar[name] = smartLockerAddress;
39 
40         // emit event
41         emit SmartLockerCreated(name, smartLockerAddress);
42 
43         // return the smart locker address
44         return smartLockerAddress;
45     }
46 
47     // get the name of the smart locker with given address (external view)
48     function getName(address smartLockerAddress) external view
49         returns (bytes32) {
50 
51         return registrar[smartLockerAddress];
52     }
53 
54     // get the address of the smart locker with given name (external view)
55     function getAddress(bytes32 name) external view
56         returns (address) {
57 
58         return reverseRegistrar[name];
59     }
60 }
61 
62 contract SmartLocker {
63 
64     // use ECDSA library for recovering signatures of hashes
65     using ECDSA for bytes32;
66 
67     // Key
68     struct Key {
69         uint256 index;
70         bool authorised;
71         bytes32 keyname;
72         // TODO: other attributes here, e.g. management flag, threshold
73     }
74 
75     // keys
76     mapping(address=>Key) keys;
77 
78     // authorised key count
79     uint256 authorisedKeyCount;
80 
81     // key list
82     address[] keyList;
83 
84     // next transaction nonce
85     uint256 nextNonce;
86 
87     // events
88     event KeyAdded(address key, bytes32 keyname);
89     event KeyRemoved(address key);
90     event KeyUpdated(address key, bytes32 keyname);
91     event SignedExecuted(address from, address to, uint value, bytes data, uint256 nonce, uint gasPrice, uint gasLimit, bytes result);
92 
93     // only authorised keys or self modifier
94     modifier onlyAuthorisedKeysOrSelf(address sender) {
95 
96         require(keys[sender].authorised || sender == address(this));
97         _;
98     }
99 
100     // fallback function (payable)
101     function() external payable {}
102 
103     // constructor with given key and keyname (public payable)
104     constructor(address key, bytes32 keyname) public payable {
105 
106         // require key not null
107         require(key != address(0));
108 
109         // require keyname not null
110         require(keyname != bytes32(0));
111 
112         // add the key
113         _addKey(key, keyname);
114     }
115 
116     // add authorisation for given key and keyname (external)
117     function addKey(address key, bytes32 keyname) external
118         onlyAuthorisedKeysOrSelf(msg.sender) {
119 
120         // require key not null
121         require(key != address(0));
122 
123         // require key not already authorised
124         require(!keys[key].authorised);
125 
126         // require keyname not null
127         require(keyname != bytes32(0));
128 
129         // add the key
130         _addKey(key, keyname);
131     }
132 
133     // add authorisation for given key and keyname (internal)
134     function _addKey(address key, bytes32 keyname) internal {
135 
136         // add the key as an authorised key
137         keys[key].index = keyList.length;
138         keys[key].authorised = true;
139         keys[key].keyname = keyname;
140         authorisedKeyCount++;
141 
142         // add to the key list
143         keyList.push(key);
144 
145         // emit event
146         emit KeyAdded(key, keyname);
147     }
148 
149     // remove authorisation for given key (external)
150     function removeKey(address key) external
151         onlyAuthorisedKeysOrSelf(msg.sender) {
152 
153         // require key already authorised
154         require(keys[key].authorised);
155 
156         // require key not the only authorised key
157         require(authorisedKeyCount > 1);
158 
159         // remove the key as an authorised key
160         keys[key].authorised = false;
161         authorisedKeyCount--;
162 
163         // delete from the key list
164         delete keyList[keys[key].index];
165 
166         // emit event
167         emit KeyRemoved(key);
168     }
169 
170     // update the given key (external)
171     function updateKey(address key, bytes32 keyname) external
172         onlyAuthorisedKeysOrSelf(msg.sender) {
173 
174         // require keyname not null
175         require(keyname != bytes32(0));
176 
177         // update the key
178         keys[key].keyname = keyname;
179         // TODO: other attributes here, e.g. management flag, threshold
180 
181         // emit event
182         emit KeyUpdated(key, keyname);
183     }
184 
185     // execute transactions if signed by authorised keys (external)
186     function executeSigned(address to, uint value, bytes calldata data, uint gasPrice, uint gasLimit, bytes calldata signature) external
187         onlyAuthorisedKeysOrSelf(_recoverSigner(address(this), to, value, data, nextNonce, gasPrice, gasLimit, signature))
188         returns (bytes memory) {
189 
190         // measure initial gas
191         uint256 gasUsed = gasleft();
192 
193         // execute the transaction
194         (bool success, bytes memory result) = to.call.value(value)(data);
195 
196         // calculate gas used
197         gasUsed = gasUsed - gasleft();
198 
199         // require success
200         require(success);
201 
202         // require gas used not over gas limit
203         require(gasUsed <= gasLimit);
204 
205         // emit event
206         emit SignedExecuted(address(this), to, value, data, nextNonce, gasPrice, gasLimit, result);
207 
208         // update the nonce
209         nextNonce++;
210 
211         // refund the gas used plus overhead of 40,000 and 68 for each input byte
212         msg.sender.transfer((gasUsed + 40000 + (msg.data.length * 68)) * gasPrice);
213 
214         // return the result
215         return result;
216     }
217 
218     // recover the signer of a signed message (internal pure)
219     function _recoverSigner(address from, address to, uint value, bytes memory data, uint256 nonce, uint gasPrice, uint gasLimit, bytes memory signature) internal pure
220         returns (address) {
221 
222         bytes32 hash = keccak256(abi.encodePacked(from, to, value, data, nonce, gasPrice, gasLimit));
223         return hash.toEthSignedMessageHash().recover(signature);
224     }
225 
226     // is the given key an authorised key (external view)
227     function isAuthorisedKey(address key) external view
228         returns (bool) {
229 
230         return keys[key].authorised;
231     }
232 
233     // get the given key (external view)
234     function getKey(address key) external view
235         returns (bytes32) {
236 
237         return keys[key].keyname;
238         // TODO: other attributes here, e.g. management flag, threshold
239     }
240 
241     // get the count of keys (external view)
242     function getAuthorisedKeyCount() external view
243         returns (uint256) {
244 
245         return authorisedKeyCount;
246     }
247 
248     // get the key list (external view)
249     function getKeyList() external view
250         returns (address[] memory) {
251 
252         return keyList;
253     }
254 
255     // get the next execution nonce (external view)
256     function getNextNonce() external view
257         returns (uint256) {
258 
259         return nextNonce;
260     }
261 }
262 pragma solidity ^0.5.2;
263 
264 /**
265  * @title Elliptic curve signature operations
266  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
267  * TODO Remove this library once solidity supports passing a signature to ecrecover.
268  * See https://github.com/ethereum/solidity/issues/864
269  */
270 
271 library ECDSA {
272     /**
273      * @dev Recover signer address from a message by using their signature
274      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
275      * @param signature bytes signature, the signature is generated using web3.eth.sign()
276      */
277     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
278         bytes32 r;
279         bytes32 s;
280         uint8 v;
281 
282         // Check the signature length
283         if (signature.length != 65) {
284             return (address(0));
285         }
286 
287         // Divide the signature in r, s and v variables
288         // ecrecover takes the signature parameters, and the only way to get them
289         // currently is to use assembly.
290         // solhint-disable-next-line no-inline-assembly
291         assembly {
292             r := mload(add(signature, 0x20))
293             s := mload(add(signature, 0x40))
294             v := byte(0, mload(add(signature, 0x60)))
295         }
296 
297         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
298         if (v < 27) {
299             v += 27;
300         }
301 
302         // If the version is correct return the signer address
303         if (v != 27 && v != 28) {
304             return (address(0));
305         } else {
306             return ecrecover(hash, v, r, s);
307         }
308     }
309 
310     /**
311      * toEthSignedMessageHash
312      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
313      * and hash the result
314      */
315     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
316         // 32 is the length in bytes of hash,
317         // enforced by the type signature above
318         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
319     }
320 }