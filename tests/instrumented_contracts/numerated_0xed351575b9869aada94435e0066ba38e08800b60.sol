1 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU Affero General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 //
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU Affero General Public License for more details.
12 //
13 // You should have received a copy of the GNU Affero General Public License
14 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.5.12;
17 
18 contract LibNote {
19     event LogNote(
20         bytes4   indexed  sig,
21         address  indexed  usr,
22         bytes32  indexed  arg1,
23         bytes32  indexed  arg2,
24         bytes             data
25     ) anonymous;
26 
27     modifier note {
28         _;
29         assembly {
30             // log an 'anonymous' event with a constant 6 words of calldata
31             // and four indexed topics: selector, caller, arg1 and arg2
32             let mark := msize                         // end of memory ensures zero
33             mstore(0x40, add(mark, 288))              // update free memory pointer
34             mstore(mark, 0x20)                        // bytes type data offset
35             mstore(add(mark, 0x20), 224)              // bytes size (padded)
36             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
37             log4(mark, 288,                           // calldata
38                  shl(224, shr(224, calldataload(0))), // msg.sig
39                  caller,                              // msg.sender
40                  calldataload(4),                     // arg1
41                  calldataload(36)                     // arg2
42                 )
43         }
44     }
45 }
46 
47 contract Dai is LibNote {
48     // --- Auth ---
49     mapping (address => uint) public wards;
50     function rely(address guy) external note auth { wards[guy] = 1; }
51     function deny(address guy) external note auth { wards[guy] = 0; }
52     modifier auth {
53         require(wards[msg.sender] == 1, "Mcr/not-authorized");
54         _;
55     }
56 
57     // --- ERC20 Data ---
58     string  public constant name     = "Mcr Stablecoin";
59     string  public constant symbol   = "MCR";
60     string  public constant version  = "1";
61     uint8   public constant decimals = 18;
62     uint256 public totalSupply;
63 
64     mapping (address => uint)                      public balanceOf;
65     mapping (address => mapping (address => uint)) public allowance;
66     mapping (address => uint)                      public nonces;
67 
68     event Approval(address indexed src, address indexed guy, uint wad);
69     event Transfer(address indexed src, address indexed dst, uint wad);
70 
71     // --- Math ---
72     function add(uint x, uint y) internal pure returns (uint z) {
73         require((z = x + y) >= x);
74     }
75     function sub(uint x, uint y) internal pure returns (uint z) {
76         require((z = x - y) <= x);
77     }
78 
79     // --- EIP712 niceties ---
80     bytes32 public DOMAIN_SEPARATOR;
81     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
82     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
83 
84     constructor(uint256 chainId_) public {
85         wards[msg.sender] = 1;
86         DOMAIN_SEPARATOR = keccak256(abi.encode(
87             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
88             keccak256(bytes(name)),
89             keccak256(bytes(version)),
90             chainId_,
91             address(this)
92         ));
93     }
94 
95     // --- Token ---
96     function transfer(address dst, uint wad) external returns (bool) {
97         return transferFrom(msg.sender, dst, wad);
98     }
99     function transferFrom(address src, address dst, uint wad)
100         public returns (bool)
101     {
102         require(balanceOf[src] >= wad, "Mcr/insufficient-balance");
103         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
104             require(allowance[src][msg.sender] >= wad, "Mcr/insufficient-allowance");
105             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
106         }
107         balanceOf[src] = sub(balanceOf[src], wad);
108         balanceOf[dst] = add(balanceOf[dst], wad);
109         emit Transfer(src, dst, wad);
110         return true;
111     }
112     function mint(address usr, uint wad) external auth {
113         balanceOf[usr] = add(balanceOf[usr], wad);
114         totalSupply    = add(totalSupply, wad);
115         emit Transfer(address(0), usr, wad);
116     }
117     function burn(address usr, uint wad) external {
118         require(balanceOf[usr] >= wad, "Mcr/insufficient-balance");
119         if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
120             require(allowance[usr][msg.sender] >= wad, "Mcr/insufficient-allowance");
121             allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
122         }
123         balanceOf[usr] = sub(balanceOf[usr], wad);
124         totalSupply    = sub(totalSupply, wad);
125         emit Transfer(usr, address(0), wad);
126     }
127     function approve(address usr, uint wad) external returns (bool) {
128         allowance[msg.sender][usr] = wad;
129         emit Approval(msg.sender, usr, wad);
130         return true;
131     }
132 
133     // --- Alias ---
134     function push(address usr, uint wad) external {
135         transferFrom(msg.sender, usr, wad);
136     }
137     function pull(address usr, uint wad) external {
138         transferFrom(usr, msg.sender, wad);
139     }
140     function move(address src, address dst, uint wad) external {
141         transferFrom(src, dst, wad);
142     }
143 
144     // --- Approve by signature ---
145     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
146                     bool allowed, uint8 v, bytes32 r, bytes32 s) external
147     {
148         bytes32 digest =
149             keccak256(abi.encodePacked(
150                 "\x19\x01",
151                 DOMAIN_SEPARATOR,
152                 keccak256(abi.encode(PERMIT_TYPEHASH,
153                                      holder,
154                                      spender,
155                                      nonce,
156                                      expiry,
157                                      allowed))
158         ));
159 
160         require(holder != address(0), "Mcr/invalid-address-0");
161         require(holder == ecrecover(digest, v, r, s), "Mcr/invalid-permit");
162         require(expiry == 0 || now <= expiry, "Mcr/permit-expired");
163         require(nonce == nonces[holder]++, "Mcr/invalid-nonce");
164         uint wad = allowed ? uint(-1) : 0;
165         allowance[holder][spender] = wad;
166         emit Approval(holder, spender, wad);
167     }
168 }