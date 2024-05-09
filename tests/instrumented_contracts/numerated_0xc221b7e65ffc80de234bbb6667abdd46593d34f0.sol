1 // Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico, lucasvo
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
16 pragma solidity >=0.5.15;
17 
18 contract ERC20 {
19     // --- Auth ---
20     mapping (address => uint) public wards;
21     function rely(address usr) public auth { wards[usr] = 1; }
22     function deny(address usr) public auth { wards[usr] = 0; }
23     modifier auth { require(wards[msg.sender] == 1); _; }
24 
25     // --- ERC20 Data ---
26     uint8   public constant decimals = 18;
27     string  public name;
28     string  public symbol;
29     string  public constant version = "1";
30     uint256 public totalSupply;
31 
32     bytes32 public DOMAIN_SEPARATOR;
33     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
34     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
35     mapping(address => uint) public nonces;
36 
37     mapping (address => uint)                      public balanceOf;
38     mapping (address => mapping (address => uint)) public allowance;
39 
40     event Approval(address indexed src, address indexed usr, uint wad);
41     event Transfer(address indexed src, address indexed dst, uint wad);
42 
43     // --- Math ---
44     function add(uint x, uint y) internal pure returns (uint z) {
45         require((z = x + y) >= x, "math-add-overflow");
46     }
47     function sub(uint x, uint y) internal pure returns (uint z) {
48         require((z = x - y) <= x, "math-sub-underflow");
49     }
50 
51     constructor(string memory symbol_, string memory name_) public {
52         wards[msg.sender] = 1;
53         symbol = symbol_;
54         name = name_;
55 
56         uint chainId;
57         assembly {
58             chainId := chainid()
59         }
60         DOMAIN_SEPARATOR = keccak256(
61             abi.encode(
62                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
63                 keccak256(bytes(name)),
64                 keccak256(bytes(version)),
65                 chainId,
66                 address(this)
67             )
68         );
69     }
70 
71     // --- ERC20 ---
72     function transfer(address dst, uint wad) external returns (bool) {
73         return transferFrom(msg.sender, dst, wad);
74     }
75     function transferFrom(address src, address dst, uint wad)
76         public returns (bool)
77     {
78         require(balanceOf[src] >= wad, "cent/insufficient-balance");
79         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
80             require(allowance[src][msg.sender] >= wad, "cent/insufficient-allowance");
81             allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
82         }
83         balanceOf[src] = sub(balanceOf[src], wad);
84         balanceOf[dst] = add(balanceOf[dst], wad);
85         emit Transfer(src, dst, wad);
86         return true;
87     }
88     function mint(address usr, uint wad) external auth {
89         balanceOf[usr] = add(balanceOf[usr], wad);
90         totalSupply    = add(totalSupply, wad);
91         emit Transfer(address(0), usr, wad);
92     }
93     function burn(address usr, uint wad) public {
94         require(balanceOf[usr] >= wad, "cent/insufficient-balance");
95         if (usr != msg.sender && allowance[usr][msg.sender] != uint(-1)) {
96             require(allowance[usr][msg.sender] >= wad, "cent/insufficient-allowance");
97             allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
98         }
99         balanceOf[usr] = sub(balanceOf[usr], wad);
100         totalSupply    = sub(totalSupply, wad);
101         emit Transfer(usr, address(0), wad);
102     }
103     function approve(address usr, uint wad) external returns (bool) {
104         allowance[msg.sender][usr] = wad;
105         emit Approval(msg.sender, usr, wad);
106         return true;
107     }
108 
109     // --- Alias ---
110     function push(address usr, uint wad) external {
111         transferFrom(msg.sender, usr, wad);
112     }
113     function pull(address usr, uint wad) external {
114         transferFrom(usr, msg.sender, wad);
115     }
116     function move(address src, address dst, uint wad) external {
117         transferFrom(src, dst, wad);
118     }
119     function burnFrom(address usr, uint wad) external {
120         burn(usr, wad);
121     }
122 
123     // --- Approve by signature ---
124     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
125         require(deadline >= block.timestamp, 'cent/past-deadline');
126         bytes32 digest = keccak256(
127             abi.encodePacked(
128                 '\x19\x01',
129                 DOMAIN_SEPARATOR,
130                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
131             )
132         );
133         address recoveredAddress = ecrecover(digest, v, r, s);
134         require(recoveredAddress != address(0) && recoveredAddress == owner, 'cent-erc20/invalid-sig');
135         allowance[owner][spender] = value;
136         emit Approval(owner, spender, value);
137     }
138 }