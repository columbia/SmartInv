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
16 pragma solidity 0.6.7;
17 
18 contract Coin {
19     // --- Auth ---
20     mapping (address => uint256) public authorizedAccounts;
21     function addAuthorization(address account) external isAuthorized {
22         authorizedAccounts[account] = 1;
23         emit AddAuthorization(account);
24     }
25     function removeAuthorization(address account) external isAuthorized {
26         authorizedAccounts[account] = 0;
27         emit RemoveAuthorization(account);
28     }
29     modifier isAuthorized {
30         require(authorizedAccounts[msg.sender] == 1, "Coin/account-not-authorized");
31         _;
32     }
33 
34     // --- ERC20 Data ---
35     string  public name;
36     string  public symbol;
37     string  public version = "1";
38 
39     uint8   public constant decimals = 18;
40 
41     uint256 public chainId;
42     uint256 public totalSupply;
43 
44     mapping (address => uint256)                      public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46     mapping (address => uint256)                      public nonces;
47 
48     // --- Events ---
49     event AddAuthorization(address account);
50     event RemoveAuthorization(address account);
51     event Approval(address indexed src, address indexed guy, uint256 amount);
52     event Transfer(address indexed src, address indexed dst, uint256 amount);
53 
54     // --- Math ---
55     function addition(uint256 x, uint256 y) internal pure returns (uint256 z) {
56         require((z = x + y) >= x, "Coin/add-overflow");
57     }
58     function subtract(uint256 x, uint256 y) internal pure returns (uint256 z) {
59         require((z = x - y) <= x, "Coin/sub-underflow");
60     }
61 
62     // --- EIP712 niceties ---
63     bytes32 public DOMAIN_SEPARATOR;
64     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
65     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
66 
67     constructor(
68         string memory name_,
69         string memory symbol_,
70         uint256 chainId_
71       ) public {
72         authorizedAccounts[msg.sender] = 1;
73         name          = name_;
74         symbol        = symbol_;
75         chainId       = chainId_;
76         DOMAIN_SEPARATOR = keccak256(abi.encode(
77             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
78             keccak256(bytes(name)),
79             keccak256(bytes(version)),
80             chainId_,
81             address(this)
82         ));
83         emit AddAuthorization(msg.sender);
84     }
85 
86     // --- Token ---
87     function transfer(address dst, uint256 amount) external returns (bool) {
88         return transferFrom(msg.sender, dst, amount);
89     }
90     function transferFrom(address src, address dst, uint256 amount)
91         public returns (bool)
92     {
93         require(dst != address(0), "Coin/null-dst");
94         require(dst != address(this), "Coin/dst-cannot-be-this-contract");
95         require(balanceOf[src] >= amount, "Coin/insufficient-balance");
96         if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
97             require(allowance[src][msg.sender] >= amount, "Coin/insufficient-allowance");
98             allowance[src][msg.sender] = subtract(allowance[src][msg.sender], amount);
99         }
100         balanceOf[src] = subtract(balanceOf[src], amount);
101         balanceOf[dst] = addition(balanceOf[dst], amount);
102         emit Transfer(src, dst, amount);
103         return true;
104     }
105     function mint(address usr, uint256 amount) external isAuthorized {
106         balanceOf[usr] = addition(balanceOf[usr], amount);
107         totalSupply    = addition(totalSupply, amount);
108         emit Transfer(address(0), usr, amount);
109     }
110     function burn(address usr, uint256 amount) external {
111         require(balanceOf[usr] >= amount, "Coin/insufficient-balance");
112         if (usr != msg.sender && allowance[usr][msg.sender] != uint256(-1)) {
113             require(allowance[usr][msg.sender] >= amount, "Coin/insufficient-allowance");
114             allowance[usr][msg.sender] = subtract(allowance[usr][msg.sender], amount);
115         }
116         balanceOf[usr] = subtract(balanceOf[usr], amount);
117         totalSupply    = subtract(totalSupply, amount);
118         emit Transfer(usr, address(0), amount);
119     }
120     function approve(address usr, uint256 amount) external returns (bool) {
121         allowance[msg.sender][usr] = amount;
122         emit Approval(msg.sender, usr, amount);
123         return true;
124     }
125 
126     // --- Alias ---
127     function push(address usr, uint256 amount) external {
128         transferFrom(msg.sender, usr, amount);
129     }
130     function pull(address usr, uint256 amount) external {
131         transferFrom(usr, msg.sender, amount);
132     }
133     function move(address src, address dst, uint256 amount) external {
134         transferFrom(src, dst, amount);
135     }
136 
137     // --- Approve by signature ---
138     function permit(
139         address holder,
140         address spender,
141         uint256 nonce,
142         uint256 expiry,
143         bool allowed,
144         uint8 v,
145         bytes32 r,
146         bytes32 s
147     ) external
148     {
149         bytes32 digest =
150             keccak256(abi.encodePacked(
151                 "\x19\x01",
152                 DOMAIN_SEPARATOR,
153                 keccak256(abi.encode(PERMIT_TYPEHASH,
154                                      holder,
155                                      spender,
156                                      nonce,
157                                      expiry,
158                                      allowed))
159         ));
160 
161         require(holder != address(0), "Coin/invalid-address-0");
162         require(holder == ecrecover(digest, v, r, s), "Coin/invalid-permit");
163         require(expiry == 0 || now <= expiry, "Coin/permit-expired");
164         require(nonce == nonces[holder]++, "Coin/invalid-nonce");
165         uint256 wad = allowed ? uint256(-1) : 0;
166         allowance[holder][spender] = wad;
167         emit Approval(holder, spender, wad);
168     }
169 }