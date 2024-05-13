1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ External Imports ============
5 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
6 // ============ Internal Imports ============
7 import {PingPongMessage} from "./PingPongMessage.sol";
8 import {Router} from "../Router.sol";
9 import {XAppConnectionClient} from "../XAppConnectionClient.sol";
10 
11 /*
12 ============ PingPong xApp ============
13 The PingPong xApp is capable of initiating PingPong "matches" between two chains.
14 A match consists of "volleys" sent back-and-forth between the two chains via Nomad.
15 
16 The first volley in a match is always a Ping volley.
17 When a Router receives a Ping volley, it returns a Pong.
18 When a Router receives a Pong volley, it returns a Ping.
19 
20 The Routers keep track of the number of volleys in a given match,
21 and emit events for each Sent and Received volley so that spectators can watch.
22 */
23 contract PingPongRouter is Router {
24     // ============ Libraries ============
25 
26     using TypedMemView for bytes;
27     using TypedMemView for bytes29;
28     using PingPongMessage for bytes29;
29 
30     // ============ Mutable State ============
31     uint32 nextMatch;
32 
33     // ============ Events ============
34 
35     event Received(
36         uint32 indexed domain,
37         uint32 indexed matchId,
38         uint256 count,
39         bool isPing
40     );
41     event Sent(
42         uint32 indexed domain,
43         uint32 indexed matchId,
44         uint256 count,
45         bool isPing
46     );
47 
48     // ============ Constructor ============
49     constructor(address _xAppConnectionManager) {
50         require(false, "example xApp, do not deploy");
51 
52         __XAppConnectionClient_initialize(_xAppConnectionManager);
53     }
54 
55     // ============ Handle message functions ============
56 
57     /**
58      * @notice Handle "volleys" sent via Nomad from other remote PingPong Routers
59      * @param _origin The domain the message is coming from
60      * @param _sender The address the message is coming from
61      * @param _message The message in the form of raw bytes
62      */
63     function handle(
64         uint32 _origin,
65         uint32, // nonce
66         bytes32 _sender,
67         bytes memory _message
68     ) external override onlyReplica onlyRemoteRouter(_origin, _sender) {
69         bytes29 _msg = _message.ref(0);
70         if (_msg.isPing()) {
71             _handlePing(_origin, _msg);
72         } else if (_msg.isPong()) {
73             _handlePong(_origin, _msg);
74         } else {
75             // if _message doesn't match any valid actions, revert
76             require(false, "!valid action");
77         }
78     }
79 
80     /**
81      * @notice Handle a Ping volley
82      * @param _origin The domain that sent the volley
83      * @param _message The message in the form of raw bytes
84      */
85     function _handlePing(uint32 _origin, bytes29 _message) internal {
86         bool _isPing = true;
87         _handle(_origin, _isPing, _message);
88     }
89 
90     /**
91      * @notice Handle a Pong volley
92      * @param _origin The domain that sent the volley
93      * @param _message The message in the form of raw bytes
94      */
95     function _handlePong(uint32 _origin, bytes29 _message) internal {
96         bool _isPing = false;
97         _handle(_origin, _isPing, _message);
98     }
99 
100     /**
101      * @notice Upon receiving a volley, emit an event, increment the count and return a the opposite volley
102      * @param _origin The domain that sent the volley
103      * @param _isPing True if the volley received is a Ping, false if it is a Pong
104      * @param _message The message in the form of raw bytes
105      */
106     function _handle(
107         uint32 _origin,
108         bool _isPing,
109         bytes29 _message
110     ) internal {
111         // get the volley count for this game
112         uint256 _count = _message.count();
113         uint32 _match = _message.matchId();
114         // emit a Received event
115         emit Received(_origin, _match, _count, _isPing);
116         // send the opposite volley back
117         _send(_origin, !_isPing, _match, _count + 1);
118     }
119 
120     // ============ Dispatch message functions ============
121 
122     /**
123      * @notice Initiate a PingPong match with the destination domain
124      * by sending the first Ping volley.
125      * @param _destinationDomain The domain to initiate the match with
126      */
127     function initiatePingPongMatch(uint32 _destinationDomain) external {
128         // the PingPong match always begins with a Ping volley
129         bool _isPing = true;
130         // increment match counter
131         uint32 _match = nextMatch;
132         nextMatch = _match + 1;
133         // send the first volley to the destination domain
134         _send(_destinationDomain, _isPing, _match, 0);
135     }
136 
137     /**
138      * @notice Send a Ping or Pong volley to the destination domain
139      * @param _destinationDomain The domain to send the volley to
140      * @param _isPing True if the volley to send is a Ping, false if it is a Pong
141      * @param _count The number of volleys in this match
142      */
143     function _send(
144         uint32 _destinationDomain,
145         bool _isPing,
146         uint32 _match,
147         uint256 _count
148     ) internal {
149         // get the xApp Router at the destinationDomain
150         bytes32 _remoteRouterAddress = _mustHaveRemote(_destinationDomain);
151         // format the ping message
152         bytes memory _message = _isPing
153             ? PingPongMessage.formatPing(_match, _count)
154             : PingPongMessage.formatPong(_match, _count);
155         // send the message to the xApp Router
156         (_home()).dispatch(_destinationDomain, _remoteRouterAddress, _message);
157         // emit a Sent event
158         emit Sent(_destinationDomain, _match, _count, _isPing);
159     }
160 }
