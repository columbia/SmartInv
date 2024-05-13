1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {Message} from "../libs/Message.sol";
5 import "forge-std/Test.sol";
6 
7 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
8 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
9 
10 contract MessageTest is Test {
11     using TypedMemView for bytes;
12     using TypedMemView for bytes29;
13     using Message for bytes29;
14 
15     // Message components
16     uint32 originDomain;
17     bytes32 sender;
18     uint32 nonce;
19     uint32 destinationDomain;
20     bytes32 recipient;
21     bytes body;
22 
23     bytes message;
24     bytes32 messageHash;
25     bytes29 messageView;
26 
27     function setUp() public {
28         originDomain = 1000;
29         sender = TypeCasts.addressToBytes32(vm.addr(1));
30         nonce = 24;
31         destinationDomain = 12340;
32         recipient = TypeCasts.addressToBytes32(vm.addr(2));
33         body = hex"E93F";
34         message = abi.encodePacked(
35             originDomain,
36             sender,
37             nonce,
38             destinationDomain,
39             recipient,
40             body
41         );
42         messageHash = keccak256(message);
43     }
44 
45     function test_prefixIs76() public {
46         assertEq(Message.PREFIX_LENGTH, 76);
47     }
48 
49     function test_formatMessage() public {
50         assertEq(
51             Message.formatMessage(
52                 originDomain,
53                 sender,
54                 nonce,
55                 destinationDomain,
56                 recipient,
57                 body
58             ),
59             message
60         );
61     }
62 
63     function test_messageHash() public {
64         assertEq(
65             Message.messageHash(
66                 originDomain,
67                 sender,
68                 nonce,
69                 destinationDomain,
70                 recipient,
71                 body
72             ),
73             messageHash
74         );
75     }
76 
77     function test_origin() public {
78         messageView = message.ref(0);
79         assertEq(uint256(messageView.origin()), uint256(originDomain));
80     }
81 
82     function test_sender() public {
83         messageView = message.ref(0);
84         assertEq(messageView.sender(), sender);
85     }
86 
87     function test_nonce() public {
88         messageView = message.ref(0);
89         assertEq(uint256(messageView.nonce()), uint256(nonce));
90     }
91 
92     function test_destination() public {
93         messageView = message.ref(0);
94         assertEq(
95             uint256(messageView.destination()),
96             uint256(destinationDomain)
97         );
98     }
99 
100     function test_recipient() public {
101         messageView = message.ref(0);
102         assertEq(messageView.recipient(), recipient);
103     }
104 
105     function test_body() public {
106         messageView = message.ref(0);
107         assertEq(messageView.body().keccak(), body.ref(0).keccak());
108     }
109 
110     function test_leaf() public {
111         messageView = message.ref(0);
112         assertEq(messageView.leaf(), messageHash);
113     }
114 }
