1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 import {MockWeth} from "./utils/MockWeth.sol";
5 import "forge-std/Test.sol";
6 
7 contract BridgeTokenTest is Test {
8     MockWeth token;
9 
10     bytes32 constant PERMIT_TYPEHASH =
11         keccak256(
12             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
13         );
14 
15     function setUp() public {
16         token = new MockWeth();
17         token.initialize();
18     }
19 
20     function test_mint() public {
21         token.mint(address(0xBEEF), 1e18);
22         assertEq(token.totalSupply(), 1e18);
23         assertEq(token.balanceOf(address(0xBEEF)), 1e18);
24     }
25 
26     function test_mintOnlyOwner() public {
27         token.mint(address(0xBEEF), 1e18);
28         vm.startPrank(address(0xBEEF));
29         vm.expectRevert("Ownable: caller is not the owner");
30         token.mint(address(0xBEEF), 1e18);
31         vm.stopPrank();
32     }
33 
34     function test_burn() public {
35         token.mint(address(0xBEEF), 1e18);
36         token.burn(address(0xBEEF), 0.9e18);
37 
38         assertEq(token.totalSupply(), 1e18 - 0.9e18);
39         assertEq(token.balanceOf(address(0xBEEF)), 1e18 - 0.9e18);
40     }
41 
42     function test_burnOnlyOwner() public {
43         token.mint(address(0xBEEF), 1e18);
44         vm.startPrank(address(0xBEEF));
45         vm.expectRevert("Ownable: caller is not the owner");
46         token.burn(address(0xBEEF), 0.9e18);
47         vm.stopPrank();
48     }
49 
50     event UpdateDetails(
51         string indexed name,
52         string indexed symbol,
53         uint8 indexed decimals
54     );
55 
56     function test_setDetailsHashAndSetDetails(
57         string memory name,
58         string memory symbol,
59         uint8 decimals
60     ) public {
61         vm.assume(
62             decimals != 0 ||
63                 bytes(symbol).length != 0 ||
64                 bytes(name).length != 0
65         );
66         bytes32 h = keccak256(
67             abi.encodePacked(
68                 bytes(name).length,
69                 name,
70                 bytes(symbol).length,
71                 symbol,
72                 decimals
73             )
74         );
75         // set initial details
76         token.setDetails("a", "b", 33);
77         require(keccak256(bytes(token.name())) == keccak256(bytes("a")));
78         require(keccak256(bytes(token.symbol())) == keccak256(bytes("b")));
79         require(token.decimals() == 33);
80         // test event emission on second details
81         token.setDetailsHash(h);
82         vm.expectEmit(true, true, true, false);
83         emit UpdateDetails(name, symbol, decimals);
84         token.setDetails(name, symbol, decimals);
85         require(keccak256(bytes(token.name())) == keccak256(bytes(name)));
86         require(keccak256(bytes(token.symbol())) == keccak256(bytes(symbol)));
87         require(token.decimals() == decimals);
88     }
89 
90     function test_setDailtsFailSecondTime() public {
91         token.setDetails("", "", 1);
92         string memory name = "Numenor";
93         string memory symbol = "NM";
94         uint8 decimals = 19;
95         vm.expectRevert("!committed details");
96         token.setDetails(name, symbol, decimals);
97     }
98 
99     function test_setDetailsHashOwner() public {
100         bytes32 h = "hash";
101         vm.prank(address(0xBEEF));
102         vm.expectRevert("Ownable: caller is not the owner");
103         token.setDetailsHash(h);
104     }
105 
106     function test_domainSeperator() public {
107         uint256 _chainId;
108         assembly {
109             _chainId := chainid()
110         }
111         bytes32 sep = keccak256(
112             abi.encode(
113                 keccak256(
114                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
115                 ),
116                 keccak256(bytes(token.name())),
117                 keccak256(bytes("1")),
118                 _chainId,
119                 address(token)
120             )
121         );
122         assertEq(sep, token.domainSeparator());
123     }
124 
125     function test_permitSuccess() public {
126         uint256 key = 123;
127         address owner = vm.addr(key);
128         address toPermit = address(0xBEEF);
129 
130         (uint8 v, bytes32 r, bytes32 s) = vm.sign(
131             key,
132             keccak256(
133                 abi.encodePacked(
134                     "\x19\x01",
135                     token.domainSeparator(),
136                     keccak256(
137                         abi.encode(
138                             PERMIT_TYPEHASH,
139                             owner,
140                             toPermit,
141                             1e18,
142                             0,
143                             block.timestamp
144                         )
145                     )
146                 )
147             )
148         );
149         token.permit(owner, toPermit, 1e18, block.timestamp, v, r, s);
150         assertEq(token.allowance(owner, toPermit), uint256(1e18));
151         assertEq(token.nonces(owner), uint256(1));
152     }
153 
154     function test_permitRevertsBadNonce() public {
155         uint256 key = 123;
156         address owner = vm.addr(key);
157         address toPermit = address(0xBEEF);
158 
159         (uint8 v, bytes32 r, bytes32 s) = vm.sign(
160             key,
161             keccak256(
162                 abi.encodePacked(
163                     "\x19\x01",
164                     token.domainSeparator(),
165                     keccak256(
166                         abi.encode(
167                             PERMIT_TYPEHASH,
168                             owner,
169                             toPermit,
170                             1e18,
171                             1,
172                             block.timestamp
173                         )
174                     )
175                 )
176             )
177         );
178         vm.expectRevert("ERC20Permit: invalid signature");
179         token.permit(owner, toPermit, 1e18, block.timestamp, v, r, s);
180     }
181 
182     function test_permitRevertsBadDeadline() public {
183         uint256 key = 123;
184         address owner = vm.addr(key);
185         address toPermit = address(0xBEEF);
186 
187         (uint8 v, bytes32 r, bytes32 s) = vm.sign(
188             key,
189             keccak256(
190                 abi.encodePacked(
191                     "\x19\x01",
192                     token.domainSeparator(),
193                     keccak256(
194                         abi.encode(
195                             PERMIT_TYPEHASH,
196                             owner,
197                             toPermit,
198                             1e18,
199                             0,
200                             block.timestamp
201                         )
202                     )
203                 )
204             )
205         );
206         vm.expectRevert("ERC20Permit: invalid signature");
207         token.permit(owner, toPermit, 1e18, block.timestamp + 1, v, r, s);
208     }
209 
210     function test_permitRevertsPastDeadline() public {
211         uint256 key = 123;
212         address owner = vm.addr(key);
213         address toPermit = address(0xBEEF);
214 
215         (uint8 v, bytes32 r, bytes32 s) = vm.sign(
216             key,
217             keccak256(
218                 abi.encodePacked(
219                     "\x19\x01",
220                     token.domainSeparator(),
221                     keccak256(
222                         abi.encode(
223                             PERMIT_TYPEHASH,
224                             owner,
225                             toPermit,
226                             1e18,
227                             0,
228                             block.timestamp - 1
229                         )
230                     )
231                 )
232             )
233         );
234         vm.expectRevert("ERC20Permit: expired deadline");
235         token.permit(owner, toPermit, 1e18, block.timestamp - 1, v, r, s);
236     }
237 
238     function test_permitRevertsOnReplay() public {
239         uint256 key = 123;
240         address owner = vm.addr(key);
241         address toPermit = address(0xBEEF);
242 
243         (uint8 v, bytes32 r, bytes32 s) = vm.sign(
244             key,
245             keccak256(
246                 abi.encodePacked(
247                     "\x19\x01",
248                     token.domainSeparator(),
249                     keccak256(
250                         abi.encode(
251                             PERMIT_TYPEHASH,
252                             owner,
253                             toPermit,
254                             1e18,
255                             0,
256                             block.timestamp
257                         )
258                     )
259                 )
260             )
261         );
262         token.permit(owner, toPermit, 1e18, block.timestamp, v, r, s);
263         vm.expectRevert("ERC20Permit: invalid signature");
264         token.permit(owner, toPermit, 1e18, block.timestamp, v, r, s);
265     }
266 
267     function test_transferOwnership() public {
268         address newOwner = address(0xBEEF);
269         token.transferOwnership(newOwner);
270         assertEq(token.owner(), newOwner);
271     }
272 
273     function test_transferOwnershipOnlyOwner() public {
274         address newOwner = address(0xBEEF);
275         vm.startPrank(newOwner);
276         vm.expectRevert("Ownable: caller is not the owner");
277         token.transferOwnership(newOwner);
278         vm.stopPrank();
279     }
280 
281     function test_renounceOwnershipNoOp() public {
282         address userA = token.owner();
283         token.renounceOwnership();
284         assertEq(token.owner(), userA);
285     }
286 }
