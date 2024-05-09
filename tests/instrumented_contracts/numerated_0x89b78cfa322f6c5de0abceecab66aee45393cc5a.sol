1 pragma solidity ^0.6.7;
2 
3 // SPDX-License-Identifier: GPL-3.0-or-later
4 pragma solidity >=0.5.12;
5 
6 // https://github.com/makerdao/dss/blob/master/src/join.sol
7 interface DaiJoinAbstract {
8     function wards(address) external view returns (uint256);
9     function rely(address usr) external;
10     function deny(address usr) external;
11     function vat() external view returns (address);
12     function dai() external view returns (address);
13     function live() external view returns (uint256);
14     function cage() external;
15     function join(address, uint256) external;
16     function exit(address, uint256) external;
17 }
18 
19 // SPDX-License-Identifier: GPL-3.0-or-later
20 pragma solidity >=0.5.12;
21 
22 // https://github.com/makerdao/dss/blob/master/src/dai.sol
23 interface DaiAbstract {
24     function wards(address) external view returns (uint256);
25     function rely(address) external;
26     function deny(address) external;
27     function name() external view returns (string memory);
28     function symbol() external view returns (string memory);
29     function version() external view returns (string memory);
30     function decimals() external view returns (uint8);
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address) external view returns (uint256);
33     function allowance(address, address) external view returns (uint256);
34     function nonces(address) external view returns (uint256);
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external view returns (bytes32);
37     function transfer(address, uint256) external;
38     function transferFrom(address, address, uint256) external returns (bool);
39     function mint(address, uint256) external;
40     function burn(address, uint256) external;
41     function approve(address, uint256) external returns (bool);
42     function push(address, uint256) external;
43     function pull(address, uint256) external;
44     function move(address, address, uint256) external;
45     function permit(address, address, uint256, uint256, bool, uint8, bytes32, bytes32) external;
46 }
47 
48 // SPDX-License-Identifier: GPL-3.0-or-later
49 pragma solidity >=0.5.12;
50 
51 // https://github.com/makerdao/dss/blob/master/src/vat.sol
52 interface VatAbstract {
53     function wards(address) external view returns (uint256);
54     function rely(address) external;
55     function deny(address) external;
56     function can(address, address) external view returns (uint256);
57     function hope(address) external;
58     function nope(address) external;
59     function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
60     function urns(bytes32, address) external view returns (uint256, uint256);
61     function gem(bytes32, address) external view returns (uint256);
62     function dai(address) external view returns (uint256);
63     function sin(address) external view returns (uint256);
64     function debt() external view returns (uint256);
65     function vice() external view returns (uint256);
66     function Line() external view returns (uint256);
67     function live() external view returns (uint256);
68     function init(bytes32) external;
69     function file(bytes32, uint256) external;
70     function file(bytes32, bytes32, uint256) external;
71     function cage() external;
72     function slip(bytes32, address, int256) external;
73     function flux(bytes32, address, address, uint256) external;
74     function move(address, address, uint256) external;
75     function frob(bytes32, address, address, address, int256, int256) external;
76     function fork(bytes32, address, address, int256, int256) external;
77     function grab(bytes32, address, address, address, int256, int256) external;
78     function heal(uint256) external;
79     function suck(address, address, uint256) external;
80     function fold(bytes32, address, int256) external;
81 }
82 
83 
84 interface AuthGemJoinAbstract {
85     function dec() external view returns (uint256);
86     function vat() external view returns (address);
87     function ilk() external view returns (bytes32);
88     function join(address, uint256, address) external;
89     function exit(address, uint256) external;
90 }
91 
92 // Peg Stability Module
93 // Allows anyone to go between Dai and the Gem by pooling the liquidity
94 // An optional fee is charged for incoming and outgoing transfers
95 
96 contract DssPsm {
97 
98     // --- Auth ---
99     mapping (address => uint256) public wards;
100     function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
101     function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
102     modifier auth { require(wards[msg.sender] == 1); _; }
103 
104     VatAbstract immutable public vat;
105     AuthGemJoinAbstract immutable public gemJoin;
106     DaiAbstract immutable public dai;
107     DaiJoinAbstract immutable public daiJoin;
108     bytes32 immutable public ilk;
109     address immutable public vow;
110 
111     uint256 immutable internal to18ConversionFactor;
112 
113     uint256 public tin;         // toll in [wad]
114     uint256 public tout;        // toll out [wad]
115 
116     // --- Events ---
117     event Rely(address user);
118     event Deny(address user);
119     event File(bytes32 indexed what, uint256 data);
120     event SellGem(address indexed owner, uint256 value, uint256 fee);
121     event BuyGem(address indexed owner, uint256 value, uint256 fee);
122 
123     // --- Init ---
124     constructor(address gemJoin_, address daiJoin_, address vow_) public {
125         wards[msg.sender] = 1;
126         emit Rely(msg.sender);
127         AuthGemJoinAbstract gemJoin__ = gemJoin = AuthGemJoinAbstract(gemJoin_);
128         DaiJoinAbstract daiJoin__ = daiJoin = DaiJoinAbstract(daiJoin_);
129         VatAbstract vat__ = vat = VatAbstract(address(gemJoin__.vat()));
130         DaiAbstract dai__ = dai = DaiAbstract(address(daiJoin__.dai()));
131         ilk = gemJoin__.ilk();
132         vow = vow_;
133         to18ConversionFactor = 10 ** (18 - gemJoin__.dec());
134         dai__.approve(daiJoin_, uint256(-1));
135         vat__.hope(daiJoin_);
136     }
137 
138     // --- Math ---
139     uint256 constant WAD = 10 ** 18;
140     uint256 constant RAY = 10 ** 27;
141     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
142         require((z = x + y) >= x);
143     }
144     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
145         require((z = x - y) <= x);
146     }
147     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
148         require(y == 0 || (z = x * y) / y == x);
149     }
150 
151     // --- Administration ---
152     function file(bytes32 what, uint256 data) external auth {
153         if (what == "tin") tin = data;
154         else if (what == "tout") tout = data;
155         else revert("DssPsm/file-unrecognized-param");
156 
157         emit File(what, data);
158     }
159     function hope(address usr) external auth {
160         vat.hope(usr);
161     }
162     function nope(address usr) external auth {
163         vat.nope(usr);
164     }
165 
166     // --- Primary Functions ---
167     function sellGem(address usr, uint256 gemAmt) external {
168         uint256 gemAmt18 = mul(gemAmt, to18ConversionFactor);
169         uint256 fee = mul(gemAmt18, tin) / WAD;
170         uint256 daiAmt = sub(gemAmt18, fee);
171         gemJoin.join(address(this), gemAmt, msg.sender);
172         vat.frob(ilk, address(this), address(this), address(this), int256(gemAmt18), int256(gemAmt18));
173         vat.move(address(this), vow, mul(fee, RAY));
174         daiJoin.exit(usr, daiAmt);
175 
176         emit SellGem(usr, gemAmt, fee);
177     }
178 
179     function buyGem(address usr, uint256 gemAmt) external {
180         uint256 gemAmt18 = mul(gemAmt, to18ConversionFactor);
181         uint256 fee = mul(gemAmt18, tout) / WAD;
182         uint256 daiAmt = add(gemAmt18, fee);
183         require(dai.transferFrom(msg.sender, address(this), daiAmt), "DssPsm/failed-transfer");
184         daiJoin.join(address(this), daiAmt);
185         vat.frob(ilk, address(this), address(this), address(this), -int256(gemAmt18), -int256(gemAmt18));
186         gemJoin.exit(usr, gemAmt);
187         vat.move(address(this), vow, mul(fee, RAY));
188 
189         emit BuyGem(usr, gemAmt, fee);
190     }
191 
192 }