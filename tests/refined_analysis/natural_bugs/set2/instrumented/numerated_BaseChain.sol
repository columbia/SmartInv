1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.8;
3 pragma experimental ABIEncoderV2;
4 
5 import "./lib/MerkleProof.sol";
6 import "./openzeppelin/contracts/access/Ownable.sol";
7 import "./umb-network/toolbox/dist/contracts/lib/ValueDecoder.sol";
8 
9 import "./interfaces/IStakingBank.sol";
10 
11 import "./extensions/Registrable.sol";
12 import "./Registry.sol";
13 import "./lib/Decoder.sol";
14 
15 abstract contract BaseChain is Registrable, Ownable {
16   using ValueDecoder for bytes;
17   using Decoder for uint224; // TODO change this to `ValueDecoder` once solution will be in SDK
18   using MerkleProof for bytes32;
19 
20   // ========== STATE VARIABLES ========== //
21 
22   bytes constant public ETH_PREFIX = "\x19Ethereum Signed Message:\n32";
23 
24   struct Block {
25     bytes32 root;
26     uint32 dataTimestamp;
27   }
28 
29   struct FirstClassData {
30     uint224 value;
31     uint32 dataTimestamp;
32   }
33 
34   mapping(uint256 => bytes32) public squashedRoots;
35   mapping(bytes32 => FirstClassData) public fcds;
36 
37   uint32 public blocksCount;
38   uint32 public immutable blocksCountOffset;
39   uint16 public padding;
40   uint16 public immutable requiredSignatures;
41 
42   // ========== CONSTRUCTOR ========== //
43 
44   constructor(
45     address _contractRegistry,
46     uint16 _padding,
47     uint16 _requiredSignatures // we have a plan to use signatures also in foreign Chains so lets keep it in base
48   ) public Registrable(_contractRegistry) {
49     padding = _padding;
50     requiredSignatures = _requiredSignatures;
51     BaseChain oldChain = BaseChain(Registry(_contractRegistry).getAddress("Chain"));
52 
53     blocksCountOffset = address(oldChain) != address(0x0)
54       // +1 because it might be situation when tx is already in progress in old contract
55       ? oldChain.blocksCount() + oldChain.blocksCountOffset() + 1
56       : 0;
57   }
58 
59   // ========== MUTATIVE FUNCTIONS ========== //
60 
61   function setPadding(uint16 _padding) external onlyOwner {
62     padding = _padding;
63     emit LogPadding(msg.sender, _padding);
64   }
65 
66   // ========== VIEWS ========== //
67 
68   function isForeign() virtual external pure returns (bool);
69 
70   function recoverSigner(bytes32 _affidavit, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (address) {
71     bytes32 hash = keccak256(abi.encodePacked(ETH_PREFIX, _affidavit));
72     return ecrecover(hash, _v, _r, _s);
73   }
74 
75   function blocks(uint256 _blockId) external view returns (Block memory) {
76     bytes32 root = squashedRoots[_blockId];
77     return Block(root, root.extractTimestamp());
78   }
79 
80   function getBlockId() public view returns (uint32) {
81     return getBlockIdAtTimestamp(block.timestamp);
82   }
83 
84   // this function does not works for past timestamps
85   function getBlockIdAtTimestamp(uint256 _timestamp) virtual public view returns (uint32) {
86     uint32 _blocksCount = blocksCount + blocksCountOffset;
87 
88     if (_blocksCount == 0) {
89       return 0;
90     }
91 
92     if (squashedRoots[_blocksCount - 1].extractTimestamp() + padding < _timestamp) {
93       return _blocksCount;
94     }
95 
96     return _blocksCount - 1;
97   }
98 
99   function getLatestBlockId() virtual public view returns (uint32) {
100     return blocksCount + blocksCountOffset - 1;
101   }
102 
103   function verifyProof(bytes32[] memory _proof, bytes32 _root, bytes32 _leaf) public pure returns (bool) {
104     if (_root == bytes32(0)) {
105       return false;
106     }
107 
108     return _root.verify(_proof, _leaf);
109   }
110 
111   function hashLeaf(bytes memory _key, bytes memory _value) public pure returns (bytes32) {
112     return keccak256(abi.encodePacked(_key, _value));
113   }
114 
115   function verifyProofForBlock(
116     uint256 _blockId,
117     bytes32[] memory _proof,
118     bytes memory _key,
119     bytes memory _value
120   ) public view returns (bool) {
121     return squashedRoots[_blockId].verifySquashedRoot(_proof, keccak256(abi.encodePacked(_key, _value)));
122   }
123 
124   function bytesToBytes32Array(
125     bytes memory _data,
126     uint256 _offset,
127     uint256 _items
128   ) public pure returns (bytes32[] memory) {
129     bytes32[] memory dataList = new bytes32[](_items);
130 
131     for (uint256 i = 0; i < _items; i++) {
132       bytes32 temp;
133       uint256 idx = (i + 1 + _offset) * 32;
134 
135       // solhint-disable-next-line no-inline-assembly
136       assembly {
137         temp := mload(add(_data, idx))
138       }
139 
140       dataList[i] = temp;
141     }
142 
143     return (dataList);
144   }
145 
146   function verifyProofs(
147     uint32[] memory _blockIds,
148     bytes memory _proofs,
149     uint256[] memory _proofItemsCounter,
150     bytes32[] memory _leaves
151   ) public view returns (bool[] memory results) {
152     results = new bool[](_leaves.length);
153     uint256 offset = 0;
154 
155     for (uint256 i = 0; i < _leaves.length; i++) {
156       results[i] = squashedRoots[_blockIds[i]].verifySquashedRoot(
157         bytesToBytes32Array(_proofs, offset, _proofItemsCounter[i]), _leaves[i]
158       );
159 
160       offset += _proofItemsCounter[i];
161     }
162   }
163 
164   function getBlockRoot(uint32 _blockId) external view returns (bytes32) {
165     return squashedRoots[_blockId].extractRoot();
166   }
167 
168   function getBlockTimestamp(uint32 _blockId) external view returns (uint32) {
169     return squashedRoots[_blockId].extractTimestamp();
170   }
171 
172   function getCurrentValues(bytes32[] calldata _keys)
173   external view returns (uint256[] memory values, uint32[] memory timestamps) {
174     timestamps = new uint32[](_keys.length);
175     values = new uint256[](_keys.length);
176 
177     for (uint i=0; i<_keys.length; i++) {
178       FirstClassData storage numericFCD = fcds[_keys[i]];
179       values[i] = uint256(numericFCD.value);
180       timestamps[i] = numericFCD.dataTimestamp;
181     }
182   }
183 
184   function getCurrentValue(bytes32 _key) external view returns (uint256 value, uint256 timestamp) {
185     FirstClassData storage numericFCD = fcds[_key];
186     return (uint256(numericFCD.value), numericFCD.dataTimestamp);
187   }
188 
189   function getCurrentIntValue(bytes32 _key) external view returns (int256 value, uint256 timestamp) {
190     FirstClassData storage numericFCD = fcds[_key];
191     return (numericFCD.value.toInt(), numericFCD.dataTimestamp);
192   }
193 
194   // TODO once Decoder will be merged into SDK, move this method and tests to SDK as well
195   function testToInt(uint224 u) external pure returns (int256) {
196     return u.toInt();
197   }
198 
199   // ========== EVENTS ========== //
200 
201   event LogPadding(address indexed executor, uint16 timePadding);
202 }