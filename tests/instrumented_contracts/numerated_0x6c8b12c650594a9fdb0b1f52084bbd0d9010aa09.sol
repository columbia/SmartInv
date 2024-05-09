1 pragma solidity ^0.4.23;
2 
3 library AZTECInterface {
4     function validateJoinSplit(bytes32[6][], uint, uint, bytes32[4]) external pure returns (bool) {}
5 }
6 
7 /**
8  * @title ERC20 interface
9  * @dev https://github.com/ethereum/EIPs/issues/20
10  **/
11 contract ERC20Interface {
12   function transfer(address to, uint256 value) external returns (bool);
13 
14   function transferFrom(address from, address to, uint256 value)
15     external returns (bool);
16 }
17 
18 /**
19  * @title  AZTEC token, providing a confidential representation of an ERC20 token 
20  * @author Zachary Williamson, AZTEC
21  * Copyright AZTEC 2018. All rights reserved.
22  * We will be releasing AZTEC as an open-source protocol that provides efficient transaction privacy for Ethereum.
23  * This will include our bespoke AZTEC decentralized exchange, allowing for cross-asset transfers with full transaction privacy
24  * and interopability with public decentralized exchanges.
25  * Stay tuned for updates!
26  **/
27 contract AZTECERC20Bridge {
28     uint private constant groupModulusBoundary = 10944121435919637611123202872628637544274182200208017171849102093287904247808;
29     uint private constant groupModulus = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
30     uint public scalingFactor;
31     mapping(bytes32 => address) public noteRegistry;
32     bytes32[4] setupPubKey;
33     bytes32 domainHash;
34     ERC20Interface token;
35 
36     event Created(bytes32 domainHash, address contractAddress);
37     event ConfidentialTransfer();
38 
39     /**
40     * @dev contract constructor.
41     * @param _setupPubKey the trusted setup public key (group element of group G2)
42     * @param _token the address of the ERC20 token being attached to
43     * @param _scalingFactor the mapping from note value -> ERC20 token value.
44     * AZTEC notes have a range between 0 and 2^{25}-1 and ERC20 tokens range between 0 and 2^{255} - 1
45     * so we don't want to directly map note value : token value
46     **/
47     constructor(bytes32[4] _setupPubKey, address _token, uint256 _scalingFactor) public {
48         setupPubKey = _setupPubKey;
49         token = ERC20Interface(_token);
50         scalingFactor = _scalingFactor;
51         // calculate the EIP712 domain hash, for hashing structured data
52         bytes32 _domainHash;
53         assembly {
54             let m := mload(0x40)
55             mstore(m, 0x8d4b25bfecb769291b71726cd5ec8a497664cc7292c02b1868a0534306741fd9)
56             mstore(add(m, 0x20), 0x87a23625953c9fb02b3570c86f75403039bbe5de82b48ca671c10157d91a991a) // name = "AZTEC_MAINNET_DOMAIN"
57             mstore(add(m, 0x40), 0x25130290f410620ec94e7cf11f1cdab5dea284e1039a83fa7b87f727031ff5f4) // version = "0.1.0"
58             mstore(add(m, 0x60), 1) // chain id
59             mstore(add(m, 0x80), 0x210db872dec2e06c375dd40a5a354307bb4ba52ba65bd84594554580ae6f0639)
60             mstore(add(m, 0xa0), address) // verifying contract
61             _domainHash := keccak256(m, 0xc0)
62         }
63         domainHash = _domainHash;
64         emit Created(_domainHash, this);
65     }
66 
67     /**
68     * @dev Determine validity of an input note and remove from note registry
69     * 1. validate that the note is signed by the note owner
70     * 2. validate that the note exists in the note registry
71     *
72     * Note signature is EIP712 signature (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md) over the following struct
73     * struct AZTEC_NOTE_SIGNATURE {
74     *     bytes32[4] note;
75     *     uint256 challenge;
76     *     address sender;    
77     * };
78     * @param note AZTEC confidential note being destroyed
79     * @param signature ECDSA signature from note owner
80     * @param challenge AZTEC zero-knowledge proof challenge
81     * @param domainHashT Temporary holding ```domainHash``` (to minimize # of sload ops)
82     **/
83     function validateInputNote(bytes32[6] note, bytes32[3] signature, uint challenge, bytes32 domainHashT) internal {
84         bytes32 noteHash;
85         bytes32 signatureMessage;
86         assembly {
87             let m := mload(0x40)
88             mstore(m, mload(add(note, 0x40)))
89             mstore(add(m, 0x20), mload(add(note, 0x60)))
90             mstore(add(m, 0x40), mload(add(note, 0x80)))
91             mstore(add(m, 0x60), mload(add(note, 0xa0)))
92             noteHash := keccak256(m, 0x80)
93             mstore(m, 0x1aba5d08f7cd777136d3fa7eb7baa742ab84001b34c9de5b17d922fc2ca75cce) // keccak256 hash of "AZTEC_NOTE_SIGNATURE(bytes32[4] note,uint256 challenge,address sender)"
94             mstore(add(m, 0x20), noteHash)
95             mstore(add(m, 0x40), challenge)
96             mstore(add(m, 0x60), caller)
97             mstore(add(m, 0x40), keccak256(m, 0x80))
98             mstore(add(m, 0x20), domainHashT)
99             mstore(m, 0x1901)
100             signatureMessage := keccak256(add(m, 0x1e), 0x42)
101         }
102         address owner = ecrecover(signatureMessage, uint8(signature[0]), signature[1], signature[2]);
103         require(noteRegistry[noteHash] == owner, "expected input note to exist in registry");
104         noteRegistry[noteHash] = 0;
105     }
106 
107     /**
108     * @dev Validate an output note from an AZTEC confidential transaction
109     * If the note does not already exist in ```noteRegistry```, create it
110     * @param note AZTEC confidential note to be created
111     * @param owner The address of the note owner
112     **/
113     function validateOutputNote(bytes32[6] note, address owner) internal {
114         bytes32 noteHash; // Construct a keccak256 hash of the note coordinates.
115         assembly {
116             let m := mload(0x40)
117             mstore(m, mload(add(note, 0x40)))
118             mstore(add(m, 0x20), mload(add(note, 0x60)))
119             mstore(add(m, 0x40), mload(add(note, 0x80)))
120             mstore(add(m, 0x60), mload(add(note, 0xa0)))
121             noteHash := keccak256(m, 0x80)
122         }
123         require(noteRegistry[noteHash] == 0, "expected output note to not exist in registry");
124         noteRegistry[noteHash] = owner;
125     }
126 
127     /**
128     * @dev Perform a confidential transaction. Takes ```m``` input notes and ```notes.length - m``` output notes.
129     * ```notes, m, challenge``` constitute an AZTEC zero-knowledge proof that states the following:
130     * The sum of the values of the input notes is equal to a the sum of the values of the output notes + a public commitment value ```kPublic```
131     * \sum_{i=0}^{m-1}k_i = \sum_{i=m}^{n-1}k_i + k_{public} (mod p)
132     * notes[6][] contains value ```kPublic```  at notes[notes.length - 1][0].
133     * If ```kPublic``` is negative, this represents ```(GROUP_MODULUS - kPublic) * SCALING_FACTOR``` ERC20 tokens being converted into confidential note form.
134     * If ```kPublic``` is positive, this represents ```kPublic * SCALING_FACTOR``` worth of AZTEC notes being converted into ERC20 form
135     * @param notes defines AZTEC input notes and output notes. notes[0,...,m-1] = input notes. notes[m,...,notes.length-1] = output notes
136     * @param m where notes[0,..., m - 1] = input notes. notes[m,...,notes.length - 1] = output notes
137     * @param challenge AZTEC zero-knowledge proof challenge variable
138     * @param inputSignatures array of ECDSA signatures, one for each input note
139     * @param outputOwners addresses of owners, one for each output note
140     * Unnamed param is metadata: if AZTEC notes are assigned to stealth addresses, metadata should contain the ephemeral keys required for note owner to identify their note
141     */
142     function confidentialTransfer(bytes32[6][] notes, uint256 m, uint256 challenge, bytes32[3][] inputSignatures, address[] outputOwners, bytes) external {
143         require(inputSignatures.length == m, "input signature length invalid");
144         require(inputSignatures.length + outputOwners.length == notes.length, "array length mismatch");
145 
146         // validate AZTEC zero-knowledge proof
147         require(AZTECInterface.validateJoinSplit(notes, m, challenge, setupPubKey), "proof not valid!");
148 
149         // extract variable kPublic from proof
150         uint256 kPublic = uint(notes[notes.length - 1][0]);
151 
152         // iterate over the notes array and validate each input/output note
153         for (uint256 i = 0; i < notes.length; i++) {
154 
155             // if i < m this is an input note
156             if (i < m) {
157 
158                 // call validateInputNote to check that the note exists and that we have a matching signature over the note.
159                 // pass domainHash in as a function parameter to prevent multiple sloads
160                 // this will remove the input notes from noteRegistry
161                 validateInputNote(notes[i], inputSignatures[i], challenge, domainHash);
162             } else {
163                 
164                 // if i >= m this is an output note
165                 // validate that output notes, attached to the specified owners do not exist in noteRegistry.
166                 // if all checks pass, add notes into note registry
167                 validateOutputNote(notes[i], outputOwners[i - m]);
168             }
169         }
170 
171         if (kPublic > 0) {
172             if (kPublic < groupModulusBoundary) {
173 
174                 // if value < the group modulus boundary then this public value represents a conversion from confidential note form to public form
175                 // call token.transfer to send relevent tokens
176                 require(token.transfer(msg.sender, kPublic * scalingFactor), "token transfer to user failed!");
177             } else {
178 
179                 // if value > group modulus boundary, this represents a commitment of a public value into confidential note form.
180                 // only proceed if the required transferFrom call from msg.sender to this contract succeeds
181                 require(token.transferFrom(msg.sender, this, (groupModulus - kPublic) * scalingFactor), "token transfer from user failed!");
182             }
183         }
184 
185         // emit an event to mark this transaction. Can recover notes + metadata from input data
186         emit ConfidentialTransfer();
187     }
188 }