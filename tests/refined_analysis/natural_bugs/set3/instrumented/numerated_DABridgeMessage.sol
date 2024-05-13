1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "@summa-tx/memview-sol/contracts/TypedMemView.sol";
5 
6 library DABridgeMessage {
7     // ============ Libraries ============
8 
9     using TypedMemView for bytes;
10     using TypedMemView for bytes29;
11 
12     // ============ Enums ============
13 
14     // WARNING: do NOT re-write the numbers / order
15     // of message types in an upgrade;
16     // will cause in-flight messages to be mis-interpreted
17     // The Types enum has to do with the TypedMemView library and it defines
18     // the types of `views` that we use in BridgeMessage. A view is not interesting data
19     // itself, but rather it points to a specific part of the memory where
20     // the data we care about live. When we give a `type` to a view, we define what type
21     // is the data it points to, so that we can do easy runtime assertions without
22     // having to fetch the whole data from memory and check for ourselves. In BridgeMessage.sol
23     // the types of `data` we can have are defined in this enum and may belong to different taxonomies.
24 
25     enum Types {
26         Invalid, // 0
27         DataRoot // 1
28     }
29 
30     // ============ Constants ============
31 
32     uint256 private constant IDENTIFIER_LEN = 1;
33     uint256 private constant BLOCK_NUMBER_LEN = 4;
34     uint256 private constant DATA_ROOT_LEN = 32;
35 
36     // ============ Internal Functions ============
37 
38     /**
39      * @notice Read the message identifer (first byte) of a message
40      * @param _view The bytes string
41      * @return The message identifier
42      */
43     function identifier(bytes29 _view) internal pure returns (uint8) {
44         return uint8(_view.indexUint(0, 1));
45     }
46 
47     /**
48      * @notice Checks that view is a valid message length
49      * @param _view The bytes string
50      * @return TRUE if message is valid
51      */
52     function isValidDataRootLength(bytes29 _view) internal pure returns (bool) {
53         uint256 _len = _view.len();
54         return _len == IDENTIFIER_LEN + BLOCK_NUMBER_LEN + DATA_ROOT_LEN;
55     }
56 
57     /**
58      * @notice Returns the type of the message
59      * @param _view The message
60      * @return The type of the message
61      */
62     function messageType(bytes29 _view) internal pure returns (Types) {
63         return Types(uint8(_view.typeOf()));
64     }
65 
66     /**
67      * @notice Checks that the message is of the specified type
68      * @param _type the type to check for
69      * @param _view The message
70      * @return True if the message is of the specified type
71      */
72     function isType(bytes29 _view, Types _type) internal pure returns (bool) {
73         return messageType(_view) == _type;
74     }
75 
76     /**
77      * @notice Checks that the message is of type DataRoot
78      * @param _view The message
79      * @return True if the message is of type DataRoot
80      */
81     function isDataRoot(bytes29 _view) internal pure returns (bool) {
82         return isType(_view, Types.DataRoot);
83     }
84 
85     /**
86      * @notice Creates a serialized data root from components
87      * @param _blockNumber The block number
88      * @param _root The root
89      * @return The formatted data root
90      */
91     function formatDataRoot(uint32 _blockNumber, bytes32 _root)
92         internal
93         pure
94         returns (bytes memory)
95     {
96         return abi.encodePacked(uint8(Types.DataRoot), _blockNumber, _root);
97     }
98 
99     /**
100      * @notice Retrieves the block number from a message
101      * @param _message The message
102      * @return The block number
103      */
104     function blockNumber(bytes29 _message) internal pure returns (uint32) {
105         return
106             uint32(_message.indexUint(IDENTIFIER_LEN, uint8(BLOCK_NUMBER_LEN)));
107     }
108 
109     /**
110      * @notice Retrieves the data root from a message
111      * @param _message The message
112      * @return The data root
113      */
114     function dataRoot(bytes29 _message) internal pure returns (bytes32) {
115         return
116             _message.index(
117                 BLOCK_NUMBER_LEN + IDENTIFIER_LEN,
118                 uint8(DATA_ROOT_LEN)
119             );
120     }
121 
122     function isValidDataRoot(bytes29 _view) internal pure returns (bool) {
123         return isType(_view, Types.DataRoot) && isValidDataRootLength(_view);
124     }
125 
126     function getTypedView(bytes29 _view) internal pure returns (bytes29) {
127         Types _type = Types(identifier(_view));
128         return _view.castTo(uint40(_type));
129     }
130 }
