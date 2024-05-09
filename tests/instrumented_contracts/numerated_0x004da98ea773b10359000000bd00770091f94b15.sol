1 pragma solidity 0.5.11; // optimization disabled, evm version: petersburg
2 
3 
4 /**
5  * @title DharmaAccountRecoveryOperatorMultisig
6  * @author 0age (derived from Christian Lundkvist's Simple Multisig)
7  * @notice This contract is a multisig that will initiate timelocks for account
8  * recovery on the Dharma Smart Wallet, based on Christian Lundkvist's Simple
9  * Multisig (found at https://github.com/christianlundkvist/simple-multisig).
10  * The Account Recovery Manager is hard-coded as the only allowable call
11  * destination, and any changes in ownership or signature threshold will require
12  * deploying a new multisig and setting it as the new operator on the account
13  * recovery manager.
14  */
15 contract DharmaAccountRecoveryOperatorMultisig {
16   // Maintain a mapping of used hashes to prevent replays.
17   mapping(bytes32 => bool) private _usedHashes;
18 
19   // Maintain a mapping and a convenience array of owners.
20   mapping(address => bool) private _isOwner;
21   address[] private _owners;
22 
23   // The Account Recovery Manager is the only account the multisig can call.
24   address private constant _DESTINATION = address(
25     0x0000000000DfEd903aD76996FC07BF89C0127B1E
26   );
27 
28   // The threshold is an exact number of valid signatures that must be supplied.
29   uint256 private constant _THRESHOLD = 2;
30 
31   // Note: Owners must be strictly increasing in order to prevent duplicates.
32   constructor(address[] memory owners) public {
33     require(owners.length <= 10, "Cannot have more than 10 owners.");
34     require(_THRESHOLD <= owners.length, "Threshold cannot exceed total owners.");
35 
36     address lastAddress = address(0);
37     for (uint256 i = 0; i < owners.length; i++) {
38       require(
39         owners[i] > lastAddress, "Owner addresses must be strictly increasing."
40       );
41       _isOwner[owners[i]] = true;
42       lastAddress = owners[i];
43     }
44     _owners = owners;
45   }
46 
47   function getHash(
48     bytes calldata data,
49     address executor,
50     uint256 gasLimit,
51     bytes32 salt
52   ) external view returns (bytes32 hash, bool usable) {
53     (hash, usable) = _getHash(data, executor, gasLimit, salt);
54   }
55 
56   function getOwners() external view returns (address[] memory owners) {
57     owners = _owners;
58   }
59 
60   function isOwner(address account) external view returns (bool owner) {
61     owner = _isOwner[account];
62   }
63 
64   function getThreshold() external pure returns (uint256 threshold) {
65     threshold = _THRESHOLD;
66   }
67 
68   function getDestination() external pure returns (address destination) {
69     destination = _DESTINATION;
70   }
71 
72   // Note: addresses recovered from signatures must be strictly increasing.
73   function execute(
74     bytes calldata data,
75     address executor,
76     uint256 gasLimit,
77     bytes32 salt,
78     bytes calldata signatures
79   ) external returns (bool success, bytes memory returnData) {
80     require(
81       executor == msg.sender || executor == address(0),
82       "Must call from the executor account if one is specified."
83     );
84 
85     // Derive the message hash and ensure that it has not been used before.
86     (bytes32 rawHash, bool usable) = _getHash(data, executor, gasLimit, salt);
87     require(usable, "Hash in question has already been used previously.");
88 
89     // wrap the derived message hash as an eth signed messsage hash.
90     bytes32 hash = _toEthSignedMessageHash(rawHash);
91 
92     // Recover each signer from provided signatures and ensure threshold is met.
93     address[] memory signers = _recoverGroup(hash, signatures);
94 
95     require(signers.length == _THRESHOLD, "Total signers must equal threshold.");
96 
97     // Verify that each signatory is an owner and is strictly increasing.
98     address lastAddress = address(0); // cannot have address(0) as an owner
99     for (uint256 i = 0; i < signers.length; i++) {
100       require(
101         _isOwner[signers[i]], "Signature does not correspond to an owner."
102       );
103       require(
104         signers[i] > lastAddress, "Signer addresses must be strictly increasing."
105       );
106       lastAddress = signers[i];
107     }
108 
109     // Add the hash to the mapping of used hashes and execute the transaction.
110     _usedHashes[rawHash] = true;
111     (success, returnData) = _DESTINATION.call.gas(gasLimit)(data);
112   }
113 
114   function _getHash(
115     bytes memory data,
116     address executor,
117     uint256 gasLimit,
118     bytes32 salt
119   ) internal view returns (bytes32 hash, bool usable) {
120     // Note: this is the data used to create a personal signed message hash.
121     hash = keccak256(
122       abi.encodePacked(address(this), salt, executor, gasLimit, data)
123     );
124 
125     usable = !_usedHashes[hash];
126   }
127 
128   /**
129    * @dev Returns each address that signed a hashed message (`hash`) from a
130    * collection of `signatures`.
131    *
132    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
133    * this function rejects them by requiring the `s` value to be in the lower
134    * half order, and the `v` value to be either 27 or 28.
135    *
136    * NOTE: This call _does not revert_ if a signature is invalid, or if the
137    * signer is otherwise unable to be retrieved. In those scenarios, the zero
138    * address is returned for that signature.
139    *
140    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
141    * verification to be secure: it is possible to craft signatures that recover
142    * to arbitrary addresses for non-hashed data.
143    */
144   function _recoverGroup(
145     bytes32 hash,
146     bytes memory signatures
147   ) internal pure returns (address[] memory signers) {
148     // Ensure that the signatures length is a multiple of 65.
149     if (signatures.length % 65 != 0) {
150       return new address[](0);
151     }
152 
153     // Create an appropriately-sized array of addresses for each signer.
154     signers = new address[](signatures.length / 65);
155 
156     // Get each signature location and divide into r, s and v variables.
157     bytes32 signatureLocation;
158     bytes32 r;
159     bytes32 s;
160     uint8 v;
161 
162     for (uint256 i = 0; i < signers.length; i++) {
163       assembly {
164         signatureLocation := add(signatures, mul(i, 65))
165         r := mload(add(signatureLocation, 32))
166         s := mload(add(signatureLocation, 64))
167         v := byte(0, mload(add(signatureLocation, 96)))
168       }
169 
170       // EIP-2 still allows signature malleability for ecrecover(). Remove
171       // this possibility and make the signature unique.
172       if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
173         continue;
174       }
175 
176       if (v != 27 && v != 28) {
177         continue;
178       }
179 
180       // If signature is valid & not malleable, add signer address.
181       signers[i] = ecrecover(hash, v, r, s);
182     }
183   }
184 
185   function _toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
186     return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
187   }
188 }