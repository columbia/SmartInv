1 pragma solidity ^0.5.0;
2 import "./../../../libs/common/ZeroCopySource.sol";
3 import "./../../../libs/common/ZeroCopySink.sol";
4 import "./../../../libs/utils/Utils.sol";
5 import "./../../../libs/math/SafeMath.sol";
6 library ECCUtils {
7     using SafeMath for uint256;
8     
9     struct Header {
10         uint32 version;
11         uint64 chainId;
12         uint32 timestamp;
13         uint32 height;
14         uint64 consensusData;
15         bytes32 prevBlockHash;
16         bytes32 transactionsRoot;
17         bytes32 crossStatesRoot;
18         bytes32 blockRoot;
19         bytes consensusPayload;
20         bytes20 nextBookkeeper;
21     }
22 
23     struct ToMerkleValue {
24         bytes  txHash;  // cross chain txhash
25         uint64 fromChainID;
26         TxParam makeTxParam;
27     }
28 
29     struct TxParam {
30         bytes txHash; //  source chain txhash
31         bytes crossChainId;
32         bytes fromContract;
33         uint64 toChainId;
34         bytes toContract;
35         bytes method;
36         bytes args;
37     }
38 
39     uint constant POLYCHAIN_PUBKEY_LEN = 67;
40     uint constant POLYCHAIN_SIGNATURE_LEN = 65;
41 
42     /* @notice                  Verify Poly chain transaction whether exist or not
43     *  @param _auditPath        Poly chain merkle proof
44     *  @param _root             Poly chain root
45     *  @return                  The verified value included in _auditPath
46     */
47     function merkleProve(bytes memory _auditPath, bytes32 _root) internal pure returns (bytes memory) {
48         uint256 off = 0;
49         bytes memory value;
50         (value, off)  = ZeroCopySource.NextVarBytes(_auditPath, off);
51 
52         bytes32 hash = Utils.hashLeaf(value);
53         uint size = _auditPath.length.sub(off).div(33);
54         bytes32 nodeHash;
55         byte pos;
56         for (uint i = 0; i < size; i++) {
57             (pos, off) = ZeroCopySource.NextByte(_auditPath, off);
58             (nodeHash, off) = ZeroCopySource.NextHash(_auditPath, off);
59             if (pos == 0x00) {
60                 hash = Utils.hashChildren(nodeHash, hash);
61             } else if (pos == 0x01) {
62                 hash = Utils.hashChildren(hash, nodeHash);
63             } else {
64                 revert("merkleProve, NextByte for position info failed");
65             }
66         }
67         require(hash == _root, "merkleProve, expect root is not equal actual root");
68         return value;
69     }
70 
71     /* @notice              calculate next book keeper according to public key list
72     *  @param _keyLen       consensus node number
73     *  @param _m            minimum signature number
74     *  @param _pubKeyList   consensus node public key list
75     *  @return              two element: next book keeper, consensus node signer addresses
76     */
77     function _getBookKeeper(uint _keyLen, uint _m, bytes memory _pubKeyList) internal pure returns (bytes20, address[] memory){
78          bytes memory buff;
79          buff = ZeroCopySink.WriteUint16(uint16(_keyLen));
80          address[] memory keepers = new address[](_keyLen);
81          bytes32 hash;
82          bytes memory publicKey;
83          for(uint i = 0; i < _keyLen; i++){
84              publicKey = Utils.slice(_pubKeyList, i*POLYCHAIN_PUBKEY_LEN, POLYCHAIN_PUBKEY_LEN);
85              buff =  abi.encodePacked(buff, ZeroCopySink.WriteVarBytes(Utils.compressMCPubKey(publicKey)));
86              hash = keccak256(Utils.slice(publicKey, 3, 64));
87              keepers[i] = address(uint160(uint256(hash)));
88          }
89 
90          buff = abi.encodePacked(buff, ZeroCopySink.WriteUint16(uint16(_m)));
91          bytes20  nextBookKeeper = ripemd160(abi.encodePacked(sha256(buff)));
92          return (nextBookKeeper, keepers);
93     }
94 
95     /* @notice              Verify public key derived from Poly chain
96     *  @param _pubKeyList   serialized consensus node public key list
97     *  @param _sigList      consensus node signature list
98     *  @return              return two element: next book keeper, consensus node signer addresses
99     */
100     function verifyPubkey(bytes memory _pubKeyList) internal pure returns (bytes20, address[] memory) {
101         require(_pubKeyList.length % POLYCHAIN_PUBKEY_LEN == 0, "_pubKeyList length illegal!");
102         uint n = _pubKeyList.length / POLYCHAIN_PUBKEY_LEN;
103         require(n >= 1, "too short _pubKeyList!");
104         return _getBookKeeper(n, n - (n - 1) / 3, _pubKeyList);
105     }
106 
107     /* @notice              Verify Poly chain consensus node signature
108     *  @param _rawHeader    Poly chain block header raw bytes
109     *  @param _sigList      consensus node signature list
110     *  @param _keepers      addresses corresponding with Poly chain book keepers' public keys
111     *  @param _m            minimum signature number
112     *  @return              true or false
113     */
114     function verifySig(bytes memory _rawHeader, bytes memory _sigList, address[] memory _keepers, uint _m) internal pure returns (bool){
115         bytes32 hash = getHeaderHash(_rawHeader);
116 
117         uint sigCount = _sigList.length.div(POLYCHAIN_SIGNATURE_LEN);
118         address[] memory signers = new address[](sigCount);
119         bytes32 r;
120         bytes32 s;
121         uint8 v;
122         for(uint j = 0; j  < sigCount; j++){
123             r = Utils.bytesToBytes32(Utils.slice(_sigList, j*POLYCHAIN_SIGNATURE_LEN, 32));
124             s =  Utils.bytesToBytes32(Utils.slice(_sigList, j*POLYCHAIN_SIGNATURE_LEN + 32, 32));
125             v =  uint8(_sigList[j*POLYCHAIN_SIGNATURE_LEN + 64]) + 27;
126             signers[j] =  ecrecover(sha256(abi.encodePacked(hash)), v, r, s);
127             if (signers[j] == address(0)) return false;
128         }
129         return Utils.containMAddresses(_keepers, signers, _m);
130     }
131     
132 
133     /* @notice               Serialize Poly chain book keepers' info in Ethereum addresses format into raw bytes
134     *  @param keepersBytes   The serialized addresses
135     *  @return               serialized bytes result
136     */
137     function serializeKeepers(address[] memory keepers) internal pure returns (bytes memory) {
138         uint256 keeperLen = keepers.length;
139         bytes memory keepersBytes = ZeroCopySink.WriteUint64(uint64(keeperLen));
140         for(uint i = 0; i < keeperLen; i++) {
141             keepersBytes = abi.encodePacked(keepersBytes, ZeroCopySink.WriteVarBytes(Utils.addressToBytes(keepers[i])));
142         }
143         return keepersBytes;
144     }
145 
146     /* @notice               Deserialize bytes into Ethereum addresses
147     *  @param keepersBytes   The serialized addresses derived from Poly chain book keepers in bytes format
148     *  @return               addresses
149     */
150     function deserializeKeepers(bytes memory keepersBytes) internal pure returns (address[] memory) {
151         uint256 off = 0;
152         uint64 keeperLen;
153         (keeperLen, off) = ZeroCopySource.NextUint64(keepersBytes, off);
154         address[] memory keepers = new address[](keeperLen);
155         bytes memory keeperBytes;
156         for(uint i = 0; i < keeperLen; i++) {
157             (keeperBytes, off) = ZeroCopySource.NextVarBytes(keepersBytes, off);
158             keepers[i] = Utils.bytesToAddress(keeperBytes);
159         }
160         return keepers;
161     }
162 
163     /* @notice               Deserialize Poly chain transaction raw value
164     *  @param _valueBs       Poly chain transaction raw bytes
165     *  @return               ToMerkleValue struct
166     */
167     function deserializeMerkleValue(bytes memory _valueBs) internal pure returns (ToMerkleValue memory) {
168         ToMerkleValue memory toMerkleValue;
169         uint256 off = 0;
170 
171         (toMerkleValue.txHash, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
172 
173         (toMerkleValue.fromChainID, off) = ZeroCopySource.NextUint64(_valueBs, off);
174 
175         TxParam memory txParam;
176 
177         (txParam.txHash, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
178         
179         (txParam.crossChainId, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
180 
181         (txParam.fromContract, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
182 
183         (txParam.toChainId, off) = ZeroCopySource.NextUint64(_valueBs, off);
184 
185         (txParam.toContract, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
186 
187         (txParam.method, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
188 
189         (txParam.args, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
190         toMerkleValue.makeTxParam = txParam;
191 
192         return toMerkleValue;
193     }
194 
195     /* @notice            Deserialize Poly chain block header raw bytes
196     *  @param _valueBs    Poly chain block header raw bytes
197     *  @return            Header struct
198     */
199     function deserializeHeader(bytes memory _headerBs) internal pure returns (Header memory) {
200         Header memory header;
201         uint256 off = 0;
202         (header.version, off)  = ZeroCopySource.NextUint32(_headerBs, off);
203 
204         (header.chainId, off) = ZeroCopySource.NextUint64(_headerBs, off);
205 
206         (header.prevBlockHash, off) = ZeroCopySource.NextHash(_headerBs, off);
207 
208         (header.transactionsRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
209 
210         (header.crossStatesRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
211 
212         (header.blockRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
213 
214         (header.timestamp, off) = ZeroCopySource.NextUint32(_headerBs, off);
215 
216         (header.height, off) = ZeroCopySource.NextUint32(_headerBs, off);
217 
218         (header.consensusData, off) = ZeroCopySource.NextUint64(_headerBs, off);
219 
220         (header.consensusPayload, off) = ZeroCopySource.NextVarBytes(_headerBs, off);
221 
222         (header.nextBookkeeper, off) = ZeroCopySource.NextBytes20(_headerBs, off);
223 
224         return header;
225     }
226 
227     /* @notice            Deserialize Poly chain block header raw bytes
228     *  @param rawHeader   Poly chain block header raw bytes
229     *  @return            header hash same as Poly chain
230     */
231     function getHeaderHash(bytes memory rawHeader) internal pure returns (bytes32) {
232         return sha256(abi.encodePacked(sha256(rawHeader)));
233     }
234 }