1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 import "@summa-tx/memview-sol/contracts/TypedMemView.sol";
5 
6 import {
7     TypeCasts
8 } from "./TypeCasts.sol";
9 
10 /**
11  * @title Message Library
12  * @author Illusory Systems Inc.
13  * @notice Library for formatted messages used by Home and Replica.
14  **/
15 library Message {
16     using TypedMemView for bytes;
17     using TypedMemView for bytes29;
18 
19     // Number of bytes in formatted message before `body` field
20     uint256 internal constant PREFIX_LENGTH = 76;
21 
22     /**
23      * @notice Returns formatted (packed) message with provided fields
24      * @param _originDomain Domain of home chain
25      * @param _sender Address of sender as bytes32
26      * @param _nonce Destination-specific nonce
27      * @param _destinationDomain Domain of destination chain
28      * @param _recipient Address of recipient on destination chain as bytes32
29      * @param _messageBody Raw bytes of message body
30      * @return Formatted message
31      **/
32     function formatMessage(
33         uint32 _originDomain,
34         bytes32 _sender,
35         uint32 _nonce,
36         uint32 _destinationDomain,
37         bytes32 _recipient,
38         bytes memory _messageBody
39     ) internal pure returns (bytes memory) {
40         return
41             abi.encodePacked(
42                 _originDomain,
43                 _sender,
44                 _nonce,
45                 _destinationDomain,
46                 _recipient,
47                 _messageBody
48             );
49     }
50 
51     /**
52      * @notice Returns leaf of formatted message with provided fields.
53      * @param _origin Domain of home chain
54      * @param _sender Address of sender as bytes32
55      * @param _nonce Destination-specific nonce number
56      * @param _destination Domain of destination chain
57      * @param _recipient Address of recipient on destination chain as bytes32
58      * @param _body Raw bytes of message body
59      * @return Leaf (hash) of formatted message
60      **/
61     function messageHash(
62         uint32 _origin,
63         bytes32 _sender,
64         uint32 _nonce,
65         uint32 _destination,
66         bytes32 _recipient,
67         bytes memory _body
68     ) internal pure returns (bytes32) {
69         return
70             keccak256(
71                 formatMessage(
72                     _origin,
73                     _sender,
74                     _nonce,
75                     _destination,
76                     _recipient,
77                     _body
78                 )
79             );
80     }
81 
82     /// @notice Returns message's origin field
83     function origin(bytes29 _message) internal pure returns (uint32) {
84         return uint32(_message.indexUint(0, 4));
85     }
86 
87     /// @notice Returns message's sender field
88     function sender(bytes29 _message) internal pure returns (bytes32) {
89         return _message.index(4, 32);
90     }
91 
92     /// @notice Returns message's nonce field
93     function nonce(bytes29 _message) internal pure returns (uint32) {
94         return uint32(_message.indexUint(36, 4));
95     }
96 
97     /// @notice Returns message's destination field
98     function destination(bytes29 _message) internal pure returns (uint32) {
99         return uint32(_message.indexUint(40, 4));
100     }
101 
102     /// @notice Returns message's recipient field as bytes32
103     function recipient(bytes29 _message) internal pure returns (bytes32) {
104         return _message.index(44, 32);
105     }
106 
107     /// @notice Returns message's recipient field as an address
108     function recipientAddress(bytes29 _message)
109         internal
110         pure
111         returns (address)
112     {
113         return TypeCasts.bytes32ToAddress(recipient(_message));
114     }
115 
116     /// @notice Returns message's body field as bytes29 (refer to TypedMemView library for details on bytes29 type)
117     function body(bytes29 _message) internal pure returns (bytes29) {
118         return _message.slice(PREFIX_LENGTH, _message.len() - PREFIX_LENGTH, 0);
119     }
120 
121     function leaf(bytes29 _message) internal view returns (bytes32) {
122         return messageHash(origin(_message), sender(_message), nonce(_message), destination(_message), recipient(_message), TypedMemView.clone(body(_message)));
123     }
124 }
