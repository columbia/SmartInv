1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // Libraries
5 import {BridgeMessage} from "../BridgeMessage.sol";
6 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/libs/TypeCasts.sol";
7 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
8 
9 // Contracts
10 import {BridgeToken} from "../BridgeToken.sol";
11 import {BridgeRouterBaseTest} from "./BridgeRouterBase.t.sol";
12 
13 contract BridgeRouterTest is BridgeRouterBaseTest {
14     using TypeCasts for bytes32;
15     using TypeCasts for address payable;
16     using TypeCasts for address;
17     using TypedMemView for bytes;
18     using TypedMemView for bytes29;
19     using BridgeMessage for bytes29;
20 
21     event Receive(
22         uint64 indexed originAndNonce,
23         address indexed token,
24         address indexed recipient,
25         address liquidityProvider,
26         uint256 amount
27     );
28 
29     function test_giveTokensLocal() public {
30         uint32 origin = remoteDomain;
31         uint32 nonce = 12;
32         address recipient = address(0xBEEF);
33         uint256 tokenAmount = 100;
34         bytes32 tokenDetailsHash = "adsf";
35         bytes memory action = abi.encodePacked(
36             BridgeMessage.Types.Transfer,
37             recipient.addressToBytes32(),
38             tokenAmount,
39             tokenDetailsHash
40         );
41         bytes memory tokenId = abi.encodePacked(
42             homeDomain,
43             address(localToken).addressToBytes32()
44         );
45         localToken.mint(address(bridgeRouter), tokenAmount);
46         vm.expectEmit(true, true, false, true, address(localToken));
47         emit Transfer(address(bridgeRouter), recipient, tokenAmount);
48         vm.expectEmit(true, true, true, true, address(bridgeRouter));
49         emit Receive(
50             (uint64(remoteDomain) << 32) | uint64(nonce),
51             address(localToken),
52             recipient,
53             address(0),
54             tokenAmount
55         );
56         bridgeRouter.exposed_giveTokens(
57             origin,
58             nonce,
59             tokenId,
60             action,
61             recipient
62         );
63         assertEq(localToken.balanceOf(recipient), tokenAmount);
64     }
65 
66     function test_giveTokensRemoteExistingRepresentationSucceeds() public {
67         uint32 origin = remoteDomain;
68         uint32 nonce = 12;
69         address recipient = address(0xBEEF);
70         uint256 tokenAmount = 100;
71         bytes32 tokenDetailsHash = "adsf";
72         address token = remoteTokenLocalAddress;
73         bytes memory action = abi.encodePacked(
74             BridgeMessage.Types.Transfer,
75             recipient.addressToBytes32(),
76             tokenAmount,
77             tokenDetailsHash
78         );
79         bytes memory tokenId = abi.encodePacked(
80             homeDomain,
81             token.addressToBytes32()
82         );
83         vm.expectEmit(true, true, false, true, token);
84         // It mints new representations
85         emit Transfer(address(0), recipient, tokenAmount);
86         vm.expectEmit(true, true, true, true);
87         emit Receive(
88             (uint64(remoteDomain) << 32) | uint64(nonce),
89             token,
90             recipient,
91             address(0),
92             tokenAmount
93         );
94         bridgeRouter.exposed_giveTokens(
95             origin,
96             nonce,
97             tokenId,
98             action,
99             recipient
100         );
101         assertEq(remoteToken.balanceOf(recipient), tokenAmount);
102         assertEq(BridgeToken(token).detailsHash(), tokenDetailsHash);
103     }
104 
105     function test_giveTokensRemoteNewRepresentationSucceeds() public {
106         uint32 origin = remoteDomain;
107         uint32 nonce = 12;
108         address recipient = address(0xBEEF);
109         uint256 tokenAmount = 100;
110         bytes32 tokenDetailsHash = "adsf";
111         bytes32 token = "remote token addr";
112         bytes memory action = abi.encodePacked(
113             BridgeMessage.Types.Transfer,
114             recipient.addressToBytes32(),
115             tokenAmount,
116             tokenDetailsHash
117         );
118         bytes memory tokenId = abi.encodePacked(remoteDomain, token);
119         // As the token has no representation on the local domain
120         // bridgeRouter will ask TokenRegistry to deploy a new BridgeToken representation
121         // The address of the deployment is determenistic because it uses CREATE
122         address tokenRepresentation = computeCreateAddress(
123             address(tokenRegistry),
124             // we use nonce = 2, because this is the second contract deployed by
125             // tokenRegistry
126             vm.getNonce(address(tokenRegistry))
127         );
128         vm.expectEmit(true, true, false, true);
129         // It mints new representation tokens
130         emit Transfer(address(0), recipient, tokenAmount);
131         vm.expectEmit(true, true, true, true);
132         emit Receive(
133             (uint64(remoteDomain) << 32) | uint64(nonce),
134             tokenRepresentation,
135             recipient,
136             address(0),
137             tokenAmount
138         );
139         bridgeRouter.exposed_giveTokens(
140             origin,
141             nonce,
142             tokenId,
143             action,
144             recipient
145         );
146         assertEq(
147             BridgeToken(tokenRepresentation).balanceOf(recipient),
148             tokenAmount
149         );
150         assertEq(
151             BridgeToken(tokenRepresentation).detailsHash(),
152             tokenDetailsHash
153         );
154     }
155 }
