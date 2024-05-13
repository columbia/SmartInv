1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 // ============ External Imports ============
6 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
7 
8 library GovernanceMessage {
9     using TypedMemView for bytes;
10     using TypedMemView for bytes29;
11 
12     // Batch message characteristics
13     // * 1 item - the type
14     uint256 private constant BATCH_PREFIX_ITEMS = 1;
15     // * type is 1 byte long
16     uint256 private constant BATCH_PREFIX_LEN = 1;
17     // * Length of a Batch message
18     // * type + batch hash
19     uint256 private constant BATCH_MESSAGE_LEN = 1 + 32;
20 
21     // Serialized Call[] characteristics
22     // * 1 item - the type
23     uint256 private constant CALLS_PREFIX_ITEMS = 1;
24     // * type is 1 byte long
25     uint256 private constant CALLS_PREFIX_LEN = 1;
26 
27     // Serialized Call characteristics
28     // * Location of the data blob in a serialized call
29     // * address + length
30     uint256 private constant CALL_DATA_OFFSET = 32 + 4;
31 
32     // Transfer Governance message characteristics
33     // * Length of a Transfer Governance message
34     // * type + domain + address
35     uint256 private constant TRANSFER_GOV_MESSAGE_LEN = 1 + 4 + 32;
36 
37     struct Call {
38         bytes32 to;
39         bytes data;
40     }
41 
42     enum Types {
43         Invalid, // 0
44         Batch, // 1 - A Batch message
45         TransferGovernor // 2 - A TransferGovernor message
46     }
47 
48     // Read the type of a message
49     function messageType(bytes29 _view) internal pure returns (Types) {
50         return Types(uint8(_view.typeOf()));
51     }
52 
53     // Read the message identifer (first byte) of a message
54     function identifier(bytes29 _view) internal pure returns (uint8) {
55         return uint8(_view.indexUint(0, 1));
56     }
57 
58     /*
59      *   Message Type: BATCH
60      *   struct Call {
61      *       identifier,     // message ID -- 1 byte
62      *       batchHash       // Hash of serialized calls (see below) -- 32 bytes
63      *   }
64      *
65      *   struct Call {
66      *       to,         // address to call -- 32 bytes
67      *       dataLen,    // call data length -- 4 bytes,
68      *       data        // call data -- 0+ bytes (variable)
69      *   }
70      *
71      *   struct Calls
72      *       numCalls,   // number of calls -- 1 byte
73      *       calls[]     // serialized Call -- 0+ bytes
74      *   }
75      */
76 
77     // create a Batch message from a list of calls
78     function formatBatch(Call[] memory _calls)
79         internal
80         view
81         returns (bytes memory)
82     {
83         return abi.encodePacked(Types.Batch, getBatchHash(_calls));
84     }
85 
86     // serialize a call to memory and return a reference
87     function serializeCall(Call memory _call) internal pure returns (bytes29) {
88         return
89             abi
90                 .encodePacked(_call.to, uint32(_call.data.length), _call.data)
91                 .ref(0);
92     }
93 
94     function getBatchHash(Call[] memory _calls)
95         internal
96         view
97         returns (bytes32)
98     {
99         // length prefix + 1 entry for each
100         bytes29[] memory _encodedCalls = new bytes29[](
101             _calls.length + CALLS_PREFIX_ITEMS
102         );
103         _encodedCalls[0] = abi.encodePacked(uint8(_calls.length)).ref(0);
104         for (uint256 i = 0; i < _calls.length; i++) {
105             _encodedCalls[i + CALLS_PREFIX_ITEMS] = serializeCall(_calls[i]);
106         }
107         return keccak256(TypedMemView.join(_encodedCalls));
108     }
109 
110     function isValidBatch(bytes29 _view) internal pure returns (bool) {
111         return
112             identifier(_view) == uint8(Types.Batch) &&
113             _view.len() == BATCH_MESSAGE_LEN;
114     }
115 
116     function isBatch(bytes29 _view) internal pure returns (bool) {
117         return isValidBatch(_view) && messageType(_view) == Types.Batch;
118     }
119 
120     function tryAsBatch(bytes29 _view) internal pure returns (bytes29) {
121         if (isValidBatch(_view)) {
122             return _view.castTo(uint40(Types.Batch));
123         }
124         return TypedMemView.nullView();
125     }
126 
127     function mustBeBatch(bytes29 _view) internal pure returns (bytes29) {
128         return tryAsBatch(_view).assertValid();
129     }
130 
131     // Types.Batch
132     function batchHash(bytes29 _view) internal pure returns (bytes32) {
133         return _view.index(BATCH_PREFIX_LEN, 32);
134     }
135 
136     /*
137      *   Message Type: TRANSFER GOVERNOR
138      *   struct TransferGovernor {
139      *       identifier, // message ID -- 1 byte
140      *       domain,     // domain of new governor -- 4 bytes
141      *       addr        // address of new governor -- 32 bytes
142      *   }
143      */
144 
145     function formatTransferGovernor(uint32 _domain, bytes32 _governor)
146         internal
147         view
148         returns (bytes memory _msg)
149     {
150         _msg = TypedMemView.clone(
151             mustBeTransferGovernor(
152                 abi
153                     .encodePacked(Types.TransferGovernor, _domain, _governor)
154                     .ref(0)
155             )
156         );
157     }
158 
159     function isValidTransferGovernor(bytes29 _view)
160         internal
161         pure
162         returns (bool)
163     {
164         return
165             identifier(_view) == uint8(Types.TransferGovernor) &&
166             _view.len() == TRANSFER_GOV_MESSAGE_LEN;
167     }
168 
169     function isTransferGovernor(bytes29 _view) internal pure returns (bool) {
170         return
171             isValidTransferGovernor(_view) &&
172             messageType(_view) == Types.TransferGovernor;
173     }
174 
175     function tryAsTransferGovernor(bytes29 _view)
176         internal
177         pure
178         returns (bytes29)
179     {
180         if (isValidTransferGovernor(_view)) {
181             return _view.castTo(uint40(Types.TransferGovernor));
182         }
183         return TypedMemView.nullView();
184     }
185 
186     function mustBeTransferGovernor(bytes29 _view)
187         internal
188         pure
189         returns (bytes29)
190     {
191         return tryAsTransferGovernor(_view).assertValid();
192     }
193 
194     // Types.TransferGovernor
195     function domain(bytes29 _view) internal pure returns (uint32) {
196         return uint32(_view.indexUint(1, 4));
197     }
198 
199     // Types.TransferGovernor
200     function governor(bytes29 _view) internal pure returns (bytes32) {
201         return _view.index(5, 32);
202     }
203 }
