1 // hevm: flattened sources of src/usdfl.sol
2 pragma solidity >0.4.13 >=0.4.23 >=0.5.12 >=0.5.0 <0.6.0 >=0.5.10 <0.6.0 >=0.5.12 <0.6.0;
3 
4 ////// src/lib.sol
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 /* pragma solidity >=0.5.12; */
19 
20 contract LibNote {
21     event LogNote(
22         bytes4 indexed sig,
23         address indexed usr,
24         bytes32 indexed arg1,
25         bytes32 indexed arg2,
26         bytes data
27     ) anonymous;
28 
29     modifier note {
30         _;
31         assembly {
32             // log an 'anonymous' event with a constant 6 words of calldata
33             // and four indexed topics: selector, caller, arg1 and arg2
34             let mark := msize() // end of memory ensures zero
35             mstore(0x40, add(mark, 288)) // update free memory pointer
36             mstore(mark, 0x20) // bytes type data offset
37             mstore(add(mark, 0x20), 224) // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224) // bytes payload
39             log4(
40                 mark,
41                 288, // calldata
42                 shl(224, shr(224, calldataload(0))), // msg.sig
43                 caller(), // msg.sender
44                 calldataload(4), // arg1
45                 calldataload(36) // arg2
46             )
47         }
48     }
49 }
50 
51 contract Auth is LibNote {
52     mapping(address => uint256) public wards;
53     address public deployer;
54 
55     function rely(address usr) external note auth {
56         wards[usr] = 1;
57     }
58 
59     function deny(address usr) external note auth {
60         wards[usr] = 0;
61     }
62 
63     modifier auth {
64         require(wards[msg.sender] == 1 || deployer == msg.sender, "Auth/not-authorized");
65         _;
66     }
67 }
68 
69 ////// src/usdfl.sol
70 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico
71 
72 // This program is free software: you can redistribute it and/or modify
73 // it under the terms of the GNU Affero General Public License as published by
74 // the Free Software Foundation, either version 3 of the License, or
75 // (at your option) any later version.
76 //
77 // This program is distributed in the hope that it will be useful,
78 // but WITHOUT ANY WARRANTY; without even the implied warranty of
79 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
80 // GNU Affero General Public License for more details.
81 //
82 // You should have received a copy of the GNU Affero General Public License
83 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
84 
85 /* pragma solidity >=0.5.12; */
86 
87 /* import "./lib.sol"; */
88 
89 contract USDFL is LibNote {
90     // --- Auth ---
91     mapping (address => uint) public wards;
92     function rely(address guy) external note auth { wards[guy] = 1; }
93     function deny(address guy) external note auth { wards[guy] = 0; }
94     modifier auth {
95         require(wards[msg.sender] == 1, "Dai/not-authorized");
96         _;
97     }
98 
99     // --- ERC20 Data ---
100     string  public constant name     = "USDFreeLiquidity";
101     string  public constant symbol   = "USDFL";
102     string  public constant version  = "1";
103     uint8   public constant decimals = 18;
104     uint256 public totalSupply;
105 
106     mapping (address => uint)                      public balanceOf;
107     mapping (address => mapping (address => uint)) public allowance;
108     mapping (address => uint)                      public nonces;
109 
110     event Approval(address indexed src, address indexed guy, uint wad);
111     event Transfer(address indexed src, address indexed dst, uint wad);
112 
113     // --- Math ---
114     function add(uint x, uint y) internal pure returns (uint z) {
115         require((z = x + y) >= x);
116     }
117     function sub(uint x, uint y) internal pure returns (uint z) {
118         require((z = x - y) <= x);
119     }
120 
121     // --- EIP712 niceties ---
122     bytes32 public DOMAIN_SEPARATOR;
123     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
124     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
125 
126     constructor(uint256 chainId_) public {
127         wards[msg.sender] = 1;
128         DOMAIN_SEPARATOR = keccak256(abi.encode(
129             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
130             keccak256(bytes(name)),
131             keccak256(bytes(version)),
132             chainId_,
133             address(this)
134         ));
135     }
136 
137     // --- Token ---
138     function transfer(address dst, uint wad) external returns (bool) {
139         return transferFrom(msg.sender, dst, wad);
140     }
141     function transferFrom(address src, address dst, uint wad)
142         public returns (bool)
143     {
144         require(balanceOf[src] >= wad, "Dai/insufficient-balance");
145         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
146             require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
147             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
148         }
149         balanceOf[src] = sub(balanceOf[src], wad);
150         balanceOf[dst] = add(balanceOf[dst], wad);
151         emit Transfer(src, dst, wad);
152         return true;
153     }
154     function mint(address usr, uint wad) external auth {
155         balanceOf[usr] = add(balanceOf[usr], wad);
156         totalSupply    = add(totalSupply, wad);
157         emit Transfer(address(0), usr, wad);
158     }
159     function burn(address usr, uint wad) external {
160         require(balanceOf[usr] >= wad, "Dai/insufficient-balance");
161         if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
162             require(allowance[usr][msg.sender] >= wad, "Dai/insufficient-allowance");
163             allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
164         }
165         balanceOf[usr] = sub(balanceOf[usr], wad);
166         totalSupply    = sub(totalSupply, wad);
167         emit Transfer(usr, address(0), wad);
168     }
169     function approve(address usr, uint wad) external returns (bool) {
170         allowance[msg.sender][usr] = wad;
171         emit Approval(msg.sender, usr, wad);
172         return true;
173     }
174 
175     // --- Alias ---
176     function push(address usr, uint wad) external {
177         transferFrom(msg.sender, usr, wad);
178     }
179     function pull(address usr, uint wad) external {
180         transferFrom(usr, msg.sender, wad);
181     }
182     function move(address src, address dst, uint wad) external {
183         transferFrom(src, dst, wad);
184     }
185 
186     // --- Approve by signature ---
187     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
188                     bool allowed, uint8 v, bytes32 r, bytes32 s) external
189     {
190         bytes32 digest =
191             keccak256(abi.encodePacked(
192                 "\x19\x01",
193                 DOMAIN_SEPARATOR,
194                 keccak256(abi.encode(PERMIT_TYPEHASH,
195                                      holder,
196                                      spender,
197                                      nonce,
198                                      expiry,
199                                      allowed))
200         ));
201 
202         require(holder != address(0), "Dai/invalid-address-0");
203         require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
204         require(expiry == 0 || now <= expiry, "Dai/permit-expired");
205         require(nonce == nonces[holder]++, "Dai/invalid-nonce");
206         uint wad = allowed ? uint(-1) : 0;
207         allowance[holder][spender] = wad;
208         emit Approval(holder, spender, wad);
209     }
210 }
211 
212 
213 contract USDFLFab {
214     function newDai(uint chainId) public returns (USDFL dai) {
215         dai = new USDFL(chainId);
216         dai.rely(msg.sender);
217         dai.deny(address(this));
218     }
219 }
