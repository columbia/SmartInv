1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
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
48     modifier typeAssert(bytes29 _view, Types _t) {
49         _view.assertType(uint40(_t));
50         _;
51     }
52 
53     // Read the type of a message
54     function messageType(bytes29 _view) internal pure returns (Types) {
55         return Types(uint8(_view.typeOf()));
56     }
57 
58     // Read the message identifer (first byte) of a message
59     function identifier(bytes29 _view) internal pure returns (uint8) {
60         return uint8(_view.indexUint(0, 1));
61     }
62 
63     /*
64      *   Message Type: BATCH
65      *   struct Call {
66      *       identifier,     // message ID -- 1 byte
67      *       batchHash       // Hash of serialized calls (see below) -- 32 bytes
68      *   }
69      *
70      *   struct Call {
71      *       to,         // address to call -- 32 bytes
72      *       dataLen,    // call data length -- 4 bytes,
73      *       data        // call data -- 0+ bytes (variable)
74      *   }
75      *
76      *   struct Calls
77      *       numCalls,   // number of calls -- 1 byte
78      *       calls[]     // serialized Call -- 0+ bytes
79      *   }
80      */
81 
82     // create a Batch message from a list of calls
83     function formatBatch(Call[] memory _calls)
84         internal
85         view
86         returns (bytes memory)
87     {
88         return abi.encodePacked(Types.Batch, getBatchHash(_calls));
89     }
90 
91     // serialize a call to memory and return a reference
92     function serializeCall(Call memory _call) internal pure returns (bytes29) {
93         return
94             abi
95                 .encodePacked(_call.to, uint32(_call.data.length), _call.data)
96                 .ref(0);
97     }
98 
99     function getBatchHash(Call[] memory _calls)
100         internal
101         view
102         returns (bytes32)
103     {
104         // length prefix + 1 entry for each
105         bytes29[] memory _encodedCalls = new bytes29[](
106             _calls.length + CALLS_PREFIX_ITEMS
107         );
108         _encodedCalls[0] = abi.encodePacked(uint8(_calls.length)).ref(0);
109         for (uint256 i = 0; i < _calls.length; i++) {
110             _encodedCalls[i + CALLS_PREFIX_ITEMS] = serializeCall(_calls[i]);
111         }
112         return keccak256(TypedMemView.join(_encodedCalls));
113     }
114 
115     function isValidBatch(bytes29 _view) internal pure returns (bool) {
116         return
117             identifier(_view) == uint8(Types.Batch) &&
118             _view.len() == BATCH_MESSAGE_LEN;
119     }
120 
121     function isBatch(bytes29 _view) internal pure returns (bool) {
122         return isValidBatch(_view) && messageType(_view) == Types.Batch;
123     }
124 
125     function tryAsBatch(bytes29 _view) internal pure returns (bytes29) {
126         if (isValidBatch(_view)) {
127             return _view.castTo(uint40(Types.Batch));
128         }
129         return TypedMemView.nullView();
130     }
131 
132     function mustBeBatch(bytes29 _view) internal pure returns (bytes29) {
133         return tryAsBatch(_view).assertValid();
134     }
135 
136     // Types.Batch
137     function batchHash(bytes29 _view) internal pure returns (bytes32) {
138         return _view.index(BATCH_PREFIX_LEN, 32);
139     }
140 
141     /*
142      *   Message Type: TRANSFER GOVERNOR
143      *   struct TransferGovernor {
144      *       identifier, // message ID -- 1 byte
145      *       domain,     // domain of new governor -- 4 bytes
146      *       addr        // address of new governor -- 32 bytes
147      *   }
148      */
149 
150     function formatTransferGovernor(uint32 _domain, bytes32 _governor)
151         internal
152         view
153         returns (bytes memory _msg)
154     {
155         _msg = TypedMemView.clone(
156             mustBeTransferGovernor(
157                 abi
158                     .encodePacked(Types.TransferGovernor, _domain, _governor)
159                     .ref(0)
160             )
161         );
162     }
163 
164     function isValidTransferGovernor(bytes29 _view)
165         internal
166         pure
167         returns (bool)
168     {
169         return
170             identifier(_view) == uint8(Types.TransferGovernor) &&
171             _view.len() == TRANSFER_GOV_MESSAGE_LEN;
172     }
173 
174     function isTransferGovernor(bytes29 _view) internal pure returns (bool) {
175         return
176             isValidTransferGovernor(_view) &&
177             messageType(_view) == Types.TransferGovernor;
178     }
179 
180     function tryAsTransferGovernor(bytes29 _view)
181         internal
182         pure
183         returns (bytes29)
184     {
185         if (isValidTransferGovernor(_view)) {
186             return _view.castTo(uint40(Types.TransferGovernor));
187         }
188         return TypedMemView.nullView();
189     }
190 
191     function mustBeTransferGovernor(bytes29 _view)
192         internal
193         pure
194         returns (bytes29)
195     {
196         return tryAsTransferGovernor(_view).assertValid();
197     }
198 
199     // Types.TransferGovernor
200     function domain(bytes29 _view) internal pure returns (uint32) {
201         return uint32(_view.indexUint(1, 4));
202     }
203 
204     // Types.TransferGovernor
205     function governor(bytes29 _view) internal pure returns (bytes32) {
206         return _view.index(5, 32);
207     }
208 }
