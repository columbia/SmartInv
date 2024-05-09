1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.12;
3 
4 /// @title Multicall3
5 /// @notice Aggregate results from multiple function calls
6 /// @dev Multicall & Multicall2 backwards-compatible
7 /// @dev Aggregate methods are marked `payable` to save 24 gas per call
8 /// @author Michael Elliot <mike@makerdao.com>
9 /// @author Joshua Levine <joshua@makerdao.com>
10 /// @author Nick Johnson <arachnid@notdot.net>
11 /// @author Andreas Bigger <andreas@nascent.xyz>
12 /// @author Matt Solomon <matt@mattsolomon.dev>
13 contract Multicall3 {
14     struct Call {
15         address target;
16         bytes callData;
17     }
18 
19     struct Call3 {
20         address target;
21         bool allowFailure;
22         bytes callData;
23     }
24 
25     struct Call3Value {
26         address target;
27         bool allowFailure;
28         uint256 value;
29         bytes callData;
30     }
31 
32     struct Result {
33         bool success;
34         bytes returnData;
35     }
36 
37     /// @notice Backwards-compatible call aggregation with Multicall
38     /// @param calls An array of Call structs
39     /// @return blockNumber The block number where the calls were executed
40     /// @return returnData An array of bytes containing the responses
41     function aggregate(Call[] calldata calls) public payable returns (uint256 blockNumber, bytes[] memory returnData) {
42         blockNumber = block.number;
43         uint256 length = calls.length;
44         returnData = new bytes[](length);
45         Call calldata call;
46         for (uint256 i = 0; i < length;) {
47             bool success;
48             call = calls[i];
49             (success, returnData[i]) = call.target.call(call.callData);
50             require(success, "Multicall3: call failed");
51             unchecked { ++i; }
52         }
53     }
54 
55     /// @notice Backwards-compatible with Multicall2
56     /// @notice Aggregate calls without requiring success
57     /// @param requireSuccess If true, require all calls to succeed
58     /// @param calls An array of Call structs
59     /// @return returnData An array of Result structs
60     function tryAggregate(bool requireSuccess, Call[] calldata calls) public payable returns (Result[] memory returnData) {
61         uint256 length = calls.length;
62         returnData = new Result[](length);
63         Call calldata call;
64         for (uint256 i = 0; i < length;) {
65             Result memory result = returnData[i];
66             call = calls[i];
67             (result.success, result.returnData) = call.target.call(call.callData);
68             if (requireSuccess) require(result.success, "Multicall3: call failed");
69             unchecked { ++i; }
70         }
71     }
72 
73     /// @notice Backwards-compatible with Multicall2
74     /// @notice Aggregate calls and allow failures using tryAggregate
75     /// @param calls An array of Call structs
76     /// @return blockNumber The block number where the calls were executed
77     /// @return blockHash The hash of the block where the calls were executed
78     /// @return returnData An array of Result structs
79     function tryBlockAndAggregate(bool requireSuccess, Call[] calldata calls) public payable returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
80         blockNumber = block.number;
81         blockHash = blockhash(block.number);
82         returnData = tryAggregate(requireSuccess, calls);
83     }
84 
85     /// @notice Backwards-compatible with Multicall2
86     /// @notice Aggregate calls and allow failures using tryAggregate
87     /// @param calls An array of Call structs
88     /// @return blockNumber The block number where the calls were executed
89     /// @return blockHash The hash of the block where the calls were executed
90     /// @return returnData An array of Result structs
91     function blockAndAggregate(Call[] calldata calls) public payable returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
92         (blockNumber, blockHash, returnData) = tryBlockAndAggregate(true, calls);
93     }
94 
95     /// @notice Aggregate calls, ensuring each returns success if required
96     /// @param calls An array of Call3 structs
97     /// @return returnData An array of Result structs
98     function aggregate3(Call3[] calldata calls) public payable returns (Result[] memory returnData) {
99         uint256 length = calls.length;
100         returnData = new Result[](length);
101         Call3 calldata calli;
102         for (uint256 i = 0; i < length;) {
103             Result memory result = returnData[i];
104             calli = calls[i];
105             (result.success, result.returnData) = calli.target.call(calli.callData);
106             assembly {
107                 // Revert if the call fails and failure is not allowed
108                 // `allowFailure := calldataload(add(calli, 0x20))` and `success := mload(result)`
109                 if iszero(or(calldataload(add(calli, 0x20)), mload(result))) {
110                     // set "Error(string)" signature: bytes32(bytes4(keccak256("Error(string)")))
111                     mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
112                     // set data offset
113                     mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
114                     // set length of revert string
115                     mstore(0x24, 0x0000000000000000000000000000000000000000000000000000000000000017)
116                     // set revert string: bytes32(abi.encodePacked("Multicall3: call failed"))
117                     mstore(0x44, 0x4d756c746963616c6c333a2063616c6c206661696c6564000000000000000000)
118                     revert(0x00, 0x64)
119                 }
120             }
121             unchecked { ++i; }
122         }
123     }
124 
125     /// @notice Aggregate calls with a msg value
126     /// @notice Reverts if msg.value is less than the sum of the call values
127     /// @param calls An array of Call3Value structs
128     /// @return returnData An array of Result structs
129     function aggregate3Value(Call3Value[] calldata calls) public payable returns (Result[] memory returnData) {
130         uint256 valAccumulator;
131         uint256 length = calls.length;
132         returnData = new Result[](length);
133         Call3Value calldata calli;
134         for (uint256 i = 0; i < length;) {
135             Result memory result = returnData[i];
136             calli = calls[i];
137             uint256 val = calli.value;
138             // Humanity will be a Type V Kardashev Civilization before this overflows - andreas
139             // ~ 10^25 Wei in existence << ~ 10^76 size uint fits in a uint256
140             unchecked { valAccumulator += val; }
141             (result.success, result.returnData) = calli.target.call{value: val}(calli.callData);
142             assembly {
143                 // Revert if the call fails and failure is not allowed
144                 // `allowFailure := calldataload(add(calli, 0x20))` and `success := mload(result)`
145                 if iszero(or(calldataload(add(calli, 0x20)), mload(result))) {
146                     // set "Error(string)" signature: bytes32(bytes4(keccak256("Error(string)")))
147                     mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
148                     // set data offset
149                     mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
150                     // set length of revert string
151                     mstore(0x24, 0x0000000000000000000000000000000000000000000000000000000000000017)
152                     // set revert string: bytes32(abi.encodePacked("Multicall3: call failed"))
153                     mstore(0x44, 0x4d756c746963616c6c333a2063616c6c206661696c6564000000000000000000)
154                     revert(0x00, 0x84)
155                 }
156             }
157             unchecked { ++i; }
158         }
159         // Finally, make sure the msg.value = SUM(call[0...i].value)
160         require(msg.value == valAccumulator, "Multicall3: value mismatch");
161     }
162 
163     /// @notice Returns the block hash for the given block number
164     /// @param blockNumber The block number
165     function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
166         blockHash = blockhash(blockNumber);
167     }
168 
169     /// @notice Returns the block number
170     function getBlockNumber() public view returns (uint256 blockNumber) {
171         blockNumber = block.number;
172     }
173 
174     /// @notice Returns the block coinbase
175     function getCurrentBlockCoinbase() public view returns (address coinbase) {
176         coinbase = block.coinbase;
177     }
178 
179     /// @notice Returns the block difficulty
180     function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
181         difficulty = block.difficulty;
182     }
183 
184     /// @notice Returns the block gas limit
185     function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
186         gaslimit = block.gaslimit;
187     }
188 
189     /// @notice Returns the block timestamp
190     function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
191         timestamp = block.timestamp;
192     }
193 
194     /// @notice Returns the (ETH) balance of a given address
195     function getEthBalance(address addr) public view returns (uint256 balance) {
196         balance = addr.balance;
197     }
198 
199     /// @notice Returns the block hash of the last block
200     function getLastBlockHash() public view returns (bytes32 blockHash) {
201         unchecked {
202             blockHash = blockhash(block.number - 1);
203         }
204     }
205 
206     /// @notice Gets the base fee of the given block
207     /// @notice Can revert if the BASEFEE opcode is not implemented by the given chain
208     function getBasefee() public view returns (uint256 basefee) {
209         basefee = block.basefee;
210     }
211 
212     /// @notice Returns the chain id
213     function getChainId() public view returns (uint256 chainid) {
214         chainid = block.chainid;
215     }
216 }