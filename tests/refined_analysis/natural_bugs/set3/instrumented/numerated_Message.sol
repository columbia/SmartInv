1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import "@summa-tx/memview-sol/contracts/TypedMemView.sol";
5 
6 import {TypeCasts} from "./TypeCasts.sol";
7 
8 /**
9  * @title Message Library
10  * @author Illusory Systems Inc.
11  * @notice Library for formatted messages used by Home and Replica.
12  **/
13 library Message {
14     using TypedMemView for bytes;
15     using TypedMemView for bytes29;
16 
17     // Number of bytes in formatted message before `body` field
18     uint256 internal constant PREFIX_LENGTH = 76;
19 
20     /**
21      * @notice Returns formatted (packed) message with provided fields
22      * @param _originDomain Domain of home chain
23      * @param _sender Address of sender as bytes32
24      * @param _nonce Destination-specific nonce
25      * @param _destinationDomain Domain of destination chain
26      * @param _recipient Address of recipient on destination chain as bytes32
27      * @param _messageBody Raw bytes of message body
28      * @return Formatted message
29      **/
30     function formatMessage(
31         uint32 _originDomain,
32         bytes32 _sender,
33         uint32 _nonce,
34         uint32 _destinationDomain,
35         bytes32 _recipient,
36         bytes memory _messageBody
37     ) internal pure returns (bytes memory) {
38         return
39             abi.encodePacked(
40                 _originDomain,
41                 _sender,
42                 _nonce,
43                 _destinationDomain,
44                 _recipient,
45                 _messageBody
46             );
47     }
48 
49     /**
50      * @notice Returns leaf of formatted message with provided fields.
51      * @param _origin Domain of home chain
52      * @param _sender Address of sender as bytes32
53      * @param _nonce Destination-specific nonce number
54      * @param _destination Domain of destination chain
55      * @param _recipient Address of recipient on destination chain as bytes32
56      * @param _body Raw bytes of message body
57      * @return Leaf (hash) of formatted message
58      **/
59     function messageHash(
60         uint32 _origin,
61         bytes32 _sender,
62         uint32 _nonce,
63         uint32 _destination,
64         bytes32 _recipient,
65         bytes memory _body
66     ) internal pure returns (bytes32) {
67         return
68             keccak256(
69                 formatMessage(
70                     _origin,
71                     _sender,
72                     _nonce,
73                     _destination,
74                     _recipient,
75                     _body
76                 )
77             );
78     }
79 
80     /// @notice Returns message's origin field
81     function origin(bytes29 _message) internal pure returns (uint32) {
82         return uint32(_message.indexUint(0, 4));
83     }
84 
85     /// @notice Returns message's sender field
86     function sender(bytes29 _message) internal pure returns (bytes32) {
87         return _message.index(4, 32);
88     }
89 
90     /// @notice Returns message's nonce field
91     function nonce(bytes29 _message) internal pure returns (uint32) {
92         return uint32(_message.indexUint(36, 4));
93     }
94 
95     /// @notice Returns message's destination field
96     function destination(bytes29 _message) internal pure returns (uint32) {
97         return uint32(_message.indexUint(40, 4));
98     }
99 
100     /// @notice Returns message's recipient field as bytes32
101     function recipient(bytes29 _message) internal pure returns (bytes32) {
102         return _message.index(44, 32);
103     }
104 
105     /// @notice Returns message's recipient field as an address
106     function recipientAddress(bytes29 _message)
107         internal
108         pure
109         returns (address)
110     {
111         return TypeCasts.bytes32ToAddress(recipient(_message));
112     }
113 
114     /// @notice Returns message's body field as bytes29 (refer to TypedMemView library for details on bytes29 type)
115     function body(bytes29 _message) internal pure returns (bytes29) {
116         return _message.slice(PREFIX_LENGTH, _message.len() - PREFIX_LENGTH, 0);
117     }
118 
119     function leaf(bytes29 _message) internal view returns (bytes32) {
120         return
121             messageHash(
122                 origin(_message),
123                 sender(_message),
124                 nonce(_message),
125                 destination(_message),
126                 recipient(_message),
127                 TypedMemView.clone(body(_message))
128             );
129     }
130 }
