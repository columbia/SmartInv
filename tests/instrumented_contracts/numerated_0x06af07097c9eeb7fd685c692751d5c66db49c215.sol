1 // chai.sol -- a dai savings token
2 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico, lucasvo, livnev
3 
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU Affero General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 //
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU Affero General Public License for more details.
13 //
14 // You should have received a copy of the GNU Affero General Public License
15 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
16 
17 pragma solidity 0.5.12;
18 
19 contract VatLike {
20     function hope(address) external;
21 }
22 
23 contract PotLike {
24     function chi() external returns (uint256);
25     function rho() external returns (uint256);
26     function drip() external returns (uint256);
27     function join(uint256) external;
28     function exit(uint256) external;
29 }
30 
31 contract JoinLike {
32     function join(address, uint) external;
33     function exit(address, uint) external;
34 }
35 
36 contract GemLike {
37     function transferFrom(address,address,uint) external returns (bool);
38     function approve(address,uint) external returns (bool);
39 }
40 
41 contract Chai {
42     // --- Data ---
43     VatLike  public vat = VatLike(0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B);
44     PotLike  public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
45     JoinLike public daiJoin = JoinLike(0x9759A6Ac90977b93B58547b4A71c78317f391A28);
46     GemLike  public daiToken = GemLike(0x6B175474E89094C44Da98b954EedeAC495271d0F);
47 
48     // --- ERC20 Data ---
49     string  public constant name     = "Chai";
50     string  public constant symbol   = "CHAI";
51     string  public constant version  = "1";
52     uint8   public constant decimals = 18;
53     uint256 public totalSupply;
54 
55     mapping (address => uint)                      public balanceOf;
56     mapping (address => mapping (address => uint)) public allowance;
57     mapping (address => uint)                      public nonces;
58 
59     event Approval(address indexed src, address indexed guy, uint wad);
60     event Transfer(address indexed src, address indexed dst, uint wad);
61 
62     // --- Math ---
63     uint constant RAY = 10 ** 27;
64     function add(uint x, uint y) internal pure returns (uint z) {
65         require((z = x + y) >= x);
66     }
67     function sub(uint x, uint y) internal pure returns (uint z) {
68         require((z = x - y) <= x);
69     }
70     function mul(uint x, uint y) internal pure returns (uint z) {
71         require(y == 0 || (z = x * y) / y == x);
72     }
73     function rmul(uint x, uint y) internal pure returns (uint z) {
74         // always rounds down
75         z = mul(x, y) / RAY;
76     }
77     function rdiv(uint x, uint y) internal pure returns (uint z) {
78         // always rounds down
79         z = mul(x, RAY) / y;
80     }
81     function rdivup(uint x, uint y) internal pure returns (uint z) {
82         // always rounds up
83         z = add(mul(x, RAY), sub(y, 1)) / y;
84     }
85 
86     // --- EIP712 niceties ---
87     bytes32 public constant DOMAIN_SEPARATOR = 0x0b50407de9fa158c2cba01a99633329490dfd22989a150c20e8c7b4c1fb0fcc3;
88     // keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)"));
89     bytes32 public constant PERMIT_TYPEHASH  = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
90 
91     constructor() public {
92         assert (DOMAIN_SEPARATOR ==
93           keccak256(abi.encode(
94             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
95             keccak256(bytes(name)), keccak256(bytes(version)), 1, address(this)))
96         );
97 
98         vat.hope(address(daiJoin));
99         vat.hope(address(pot));
100 
101         daiToken.approve(address(daiJoin), uint(-1));
102     }
103 
104     // --- Token ---
105     function transfer(address dst, uint wad) external returns (bool) {
106         return transferFrom(msg.sender, dst, wad);
107     }
108     // like transferFrom but dai-denominated
109     function move(address src, address dst, uint wad) external returns (bool) {
110         uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
111         // rounding up ensures dst gets at least wad dai
112         return transferFrom(src, dst, rdivup(wad, chi));
113     }
114     function transferFrom(address src, address dst, uint wad)
115         public returns (bool)
116     {
117         require(balanceOf[src] >= wad, "chai/insufficient-balance");
118         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
119             require(allowance[src][msg.sender] >= wad, "chai/insufficient-allowance");
120             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
121         }
122         balanceOf[src] = sub(balanceOf[src], wad);
123         balanceOf[dst] = add(balanceOf[dst], wad);
124         emit Transfer(src, dst, wad);
125         return true;
126     }
127     function approve(address usr, uint wad) external returns (bool) {
128         allowance[msg.sender][usr] = wad;
129         emit Approval(msg.sender, usr, wad);
130         return true;
131     }
132 
133     // --- Approve by signature ---
134     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external
135     {
136         bytes32 digest = keccak256(abi.encodePacked(
137             "\x19\x01",
138             DOMAIN_SEPARATOR,
139             keccak256(abi.encode(PERMIT_TYPEHASH,
140                                  holder,
141                                  spender,
142                                  nonce,
143                                  expiry,
144                                  allowed))));
145         require(holder != address(0), "chai/invalid holder");
146         require(holder == ecrecover(digest, v, r, s), "chai/invalid-permit");
147         require(expiry == 0 || now <= expiry, "chai/permit-expired");
148         require(nonce == nonces[holder]++, "chai/invalid-nonce");
149 
150         uint can = allowed ? uint(-1) : 0;
151         allowance[holder][spender] = can;
152         emit Approval(holder, spender, can);
153     }
154 
155     function dai(address usr) external returns (uint wad) {
156         uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
157         wad = rmul(chi, balanceOf[usr]);
158     }
159     // wad is denominated in dai
160     function join(address dst, uint wad) external {
161         uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
162         uint pie = rdiv(wad, chi);
163         balanceOf[dst] = add(balanceOf[dst], pie);
164         totalSupply    = add(totalSupply, pie);
165 
166         daiToken.transferFrom(msg.sender, address(this), wad);
167         daiJoin.join(address(this), wad);
168         pot.join(pie);
169         emit Transfer(address(0), dst, pie);
170     }
171 
172     // wad is denominated in (1/chi) * dai
173     function exit(address src, uint wad) public {
174         require(balanceOf[src] >= wad, "chai/insufficient-balance");
175         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
176             require(allowance[src][msg.sender] >= wad, "chai/insufficient-allowance");
177             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
178         }
179         balanceOf[src] = sub(balanceOf[src], wad);
180         totalSupply    = sub(totalSupply, wad);
181 
182         uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
183         pot.exit(wad);
184         daiJoin.exit(msg.sender, rmul(chi, wad));
185         emit Transfer(src, address(0), wad);
186     }
187 
188     // wad is denominated in dai
189     function draw(address src, uint wad) external {
190         uint chi = (now > pot.rho()) ? pot.drip() : pot.chi();
191         // rounding up ensures usr gets at least wad dai
192         exit(src, rdivup(wad, chi));
193     }
194 }