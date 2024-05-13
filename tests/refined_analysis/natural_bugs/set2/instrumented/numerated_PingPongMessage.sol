1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 import "@summa-tx/memview-sol/contracts/TypedMemView.sol";
5 
6 library PingPongMessage {
7     using TypedMemView for bytes;
8     using TypedMemView for bytes29;
9 
10     /// @dev Each message is encoded as a 1-byte type distinguisher, a 4-byte
11     /// match id, and a 32-byte volley counter. The messages are therefore all
12     /// 37 bytes
13     enum Types {
14         Invalid, // 0
15         Ping, // 1
16         Pong // 2
17     }
18 
19     // ============ Formatters ============
20 
21     /**
22      * @notice Format a Ping volley
23      * @param _count The number of volleys in this match
24      * @return The encoded bytes message
25      */
26     function formatPing(uint32 _match, uint256 _count)
27         internal
28         pure
29         returns (bytes memory)
30     {
31         return abi.encodePacked(uint8(Types.Ping), _match, _count);
32     }
33 
34     /**
35      * @notice Format a Pong volley
36      * @param _count The number of volleys in this match
37      * @return The encoded bytes message
38      */
39     function formatPong(uint32 _match, uint256 _count)
40         internal
41         pure
42         returns (bytes memory)
43     {
44         return abi.encodePacked(uint8(Types.Pong), _match, _count);
45     }
46 
47     // ============ Identifiers ============
48 
49     /**
50      * @notice Get the type that the TypedMemView is cast to
51      * @param _view The message
52      * @return _type The type of the message (either Ping or Pong)
53      */
54     function messageType(bytes29 _view) internal pure returns (Types _type) {
55         _type = Types(uint8(_view.typeOf()));
56     }
57 
58     /**
59      * @notice Determine whether the message contains a Ping volley
60      * @param _view The message
61      * @return True if the volley is Ping
62      */
63     function isPing(bytes29 _view) internal pure returns (bool) {
64         return messageType(_view) == Types.Ping;
65     }
66 
67     /**
68      * @notice Determine whether the message contains a Pong volley
69      * @param _view The message
70      * @return True if the volley is Pong
71      */
72     function isPong(bytes29 _view) internal pure returns (bool) {
73         return messageType(_view) == Types.Pong;
74     }
75 
76     // ============ Getters ============
77 
78     /**
79      * @notice Parse the match ID sent within a Ping or Pong message
80      * @dev The number is encoded as a uint32 at index 1
81      * @param _view The message
82      * @return The match id encoded in the message
83      */
84     function matchId(bytes29 _view) internal pure returns (uint32) {
85         // At index 1, read 4 bytes as a uint, and cast to a uint32
86         return uint32(_view.indexUint(1, 4));
87     }
88 
89     /**
90      * @notice Parse the volley count sent within a Ping or Pong message
91      * @dev The number is encoded as a uint256 at index 1
92      * @param _view The message
93      * @return The count encoded in the message
94      */
95     function count(bytes29 _view) internal pure returns (uint256) {
96         // At index 1, read 32 bytes as a uint
97         return _view.indexUint(1, 32);
98     }
99 }
