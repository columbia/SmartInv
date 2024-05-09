1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/dai.sol
2 pragma solidity =0.5.12;
3 
4 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/lib.sol
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
18 /* pragma solidity 0.5.12; */
19 
20 contract LibNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  usr,
24         bytes32  indexed  arg1,
25         bytes32  indexed  arg2,
26         bytes             data
27     ) anonymous;
28 
29     modifier note {
30         _;
31         assembly {
32             // log an 'anonymous' event with a constant 6 words of calldata
33             // and four indexed topics: selector, caller, arg1 and arg2
34             let mark := msize                         // end of memory ensures zero
35             mstore(0x40, add(mark, 288))              // update free memory pointer
36             mstore(mark, 0x20)                        // bytes type data offset
37             mstore(add(mark, 0x20), 224)              // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
39             log4(mark, 288,                           // calldata
40                  shl(224, shr(224, calldataload(0))), // msg.sig
41                  caller,                              // msg.sender
42                  calldataload(4),                     // arg1
43                  calldataload(36)                     // arg2
44                 )
45         }
46     }
47 }
48 
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/dai.sol
50 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico
51 
52 // This program is free software: you can redistribute it and/or modify
53 // it under the terms of the GNU Affero General Public License as published by
54 // the Free Software Foundation, either version 3 of the License, or
55 // (at your option) any later version.
56 //
57 // This program is distributed in the hope that it will be useful,
58 // but WITHOUT ANY WARRANTY; without even the implied warranty of
59 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
60 // GNU Affero General Public License for more details.
61 //
62 // You should have received a copy of the GNU Affero General Public License
63 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
64 
65 /* pragma solidity 0.5.12; */
66 
67 /* import "./lib.sol"; */
68 
69 contract Dai is LibNote {
70     // --- Auth ---
71     mapping (address => uint) public wards;
72     function rely(address guy) external note auth { wards[guy] = 1; }
73     function deny(address guy) external note auth { wards[guy] = 0; }
74     modifier auth {
75         require(wards[msg.sender] == 1, "Dai/not-authorized");
76         _;
77     }
78 
79     // --- ERC20 Data ---
80     string  public constant name     = "Dai Stablecoin";
81     string  public constant symbol   = "DAI";
82     string  public constant version  = "1";
83     uint8   public constant decimals = 18;
84     uint256 public totalSupply;
85 
86     mapping (address => uint)                      public balanceOf;
87     mapping (address => mapping (address => uint)) public allowance;
88     mapping (address => uint)                      public nonces;
89 
90     event Approval(address indexed src, address indexed guy, uint wad);
91     event Transfer(address indexed src, address indexed dst, uint wad);
92 
93     // --- Math ---
94     function add(uint x, uint y) internal pure returns (uint z) {
95         require((z = x + y) >= x);
96     }
97     function sub(uint x, uint y) internal pure returns (uint z) {
98         require((z = x - y) <= x);
99     }
100 
101     // --- EIP712 niceties ---
102     bytes32 public DOMAIN_SEPARATOR;
103     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
104     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
105 
106     constructor(uint256 chainId_) public {
107         wards[msg.sender] = 1;
108         DOMAIN_SEPARATOR = keccak256(abi.encode(
109             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
110             keccak256(bytes(name)),
111             keccak256(bytes(version)),
112             chainId_,
113             address(this)
114         ));
115     }
116 
117     // --- Token ---
118     function transfer(address dst, uint wad) external returns (bool) {
119         return transferFrom(msg.sender, dst, wad);
120     }
121     function transferFrom(address src, address dst, uint wad)
122         public returns (bool)
123     {
124         require(balanceOf[src] >= wad, "Dai/insufficient-balance");
125         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
126             require(allowance[src][msg.sender] >= wad, "Dai/insufficient-allowance");
127             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
128         }
129         balanceOf[src] = sub(balanceOf[src], wad);
130         balanceOf[dst] = add(balanceOf[dst], wad);
131         emit Transfer(src, dst, wad);
132         return true;
133     }
134     function mint(address usr, uint wad) external auth {
135         balanceOf[usr] = add(balanceOf[usr], wad);
136         totalSupply    = add(totalSupply, wad);
137         emit Transfer(address(0), usr, wad);
138     }
139     function burn(address usr, uint wad) external {
140         require(balanceOf[usr] >= wad, "Dai/insufficient-balance");
141         if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
142             require(allowance[usr][msg.sender] >= wad, "Dai/insufficient-allowance");
143             allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
144         }
145         balanceOf[usr] = sub(balanceOf[usr], wad);
146         totalSupply    = sub(totalSupply, wad);
147         emit Transfer(usr, address(0), wad);
148     }
149     function approve(address usr, uint wad) external returns (bool) {
150         allowance[msg.sender][usr] = wad;
151         emit Approval(msg.sender, usr, wad);
152         return true;
153     }
154 
155     // --- Alias ---
156     function push(address usr, uint wad) external {
157         transferFrom(msg.sender, usr, wad);
158     }
159     function pull(address usr, uint wad) external {
160         transferFrom(usr, msg.sender, wad);
161     }
162     function move(address src, address dst, uint wad) external {
163         transferFrom(src, dst, wad);
164     }
165 
166     // --- Approve by signature ---
167     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
168                     bool allowed, uint8 v, bytes32 r, bytes32 s) external
169     {
170         bytes32 digest =
171             keccak256(abi.encodePacked(
172                 "\x19\x01",
173                 DOMAIN_SEPARATOR,
174                 keccak256(abi.encode(PERMIT_TYPEHASH,
175                                      holder,
176                                      spender,
177                                      nonce,
178                                      expiry,
179                                      allowed))
180         ));
181 
182         require(holder != address(0), "Dai/invalid-address-0");
183         require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
184         require(expiry == 0 || now <= expiry, "Dai/permit-expired");
185         require(nonce == nonces[holder]++, "Dai/invalid-nonce");
186         uint wad = allowed ? uint(-1) : 0;
187         allowance[holder][spender] = wad;
188         emit Approval(holder, spender, wad);
189     }
190 }