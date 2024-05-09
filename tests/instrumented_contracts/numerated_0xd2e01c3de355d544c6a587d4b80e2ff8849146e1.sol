1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 abstract contract ERC20 {
5     /*//////////////////////////////////////////////////////////////
6                                  EVENTS
7     //////////////////////////////////////////////////////////////*/
8 
9     event Transfer(address indexed from, address indexed to, uint256 amount);
10 
11     event Approval(address indexed owner, address indexed spender, uint256 amount);
12 
13     /*//////////////////////////////////////////////////////////////
14                             METADATA STORAGE
15     //////////////////////////////////////////////////////////////*/
16 
17     string public name;
18 
19     string public symbol;
20 
21     uint8 public immutable decimals;
22 
23     /*//////////////////////////////////////////////////////////////
24                               ERC20 STORAGE
25     //////////////////////////////////////////////////////////////*/
26 
27     uint256 public totalSupply;
28 
29     mapping(address => uint256) public balanceOf;
30 
31     mapping(address => mapping(address => uint256)) public allowance;
32 
33     /*//////////////////////////////////////////////////////////////
34                             EIP-2612 STORAGE
35     //////////////////////////////////////////////////////////////*/
36 
37     uint256 internal immutable INITIAL_CHAIN_ID;
38 
39     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
40 
41     mapping(address => uint256) public nonces;
42 
43     /*//////////////////////////////////////////////////////////////
44                                CONSTRUCTOR
45     //////////////////////////////////////////////////////////////*/
46 
47     constructor(
48         string memory _name,
49         string memory _symbol,
50         uint8 _decimals
51     ) {
52         name = _name;
53         symbol = _symbol;
54         decimals = _decimals;
55 
56         INITIAL_CHAIN_ID = block.chainid;
57         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
58     }
59 
60     /*//////////////////////////////////////////////////////////////
61                                ERC20 LOGIC
62     //////////////////////////////////////////////////////////////*/
63 
64     function approve(address spender, uint256 amount) public virtual returns (bool) {
65         allowance[msg.sender][spender] = amount;
66 
67         emit Approval(msg.sender, spender, amount);
68 
69         return true;
70     }
71 
72     function transfer(address to, uint256 amount) public virtual returns (bool) {
73         balanceOf[msg.sender] -= amount;
74 
75         // Cannot overflow because the sum of all user
76         // balances can't exceed the max uint256 value.
77         unchecked {
78             balanceOf[to] += amount;
79         }
80 
81         emit Transfer(msg.sender, to, amount);
82 
83         return true;
84     }
85 
86     function transferFrom(
87         address from,
88         address to,
89         uint256 amount
90     ) public virtual returns (bool) {
91         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
92 
93         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
94 
95         balanceOf[from] -= amount;
96 
97         // Cannot overflow because the sum of all user
98         // balances can't exceed the max uint256 value.
99         unchecked {
100             balanceOf[to] += amount;
101         }
102 
103         emit Transfer(from, to, amount);
104 
105         return true;
106     }
107 
108     /*//////////////////////////////////////////////////////////////
109                              EIP-2612 LOGIC
110     //////////////////////////////////////////////////////////////*/
111 
112     function permit(
113         address owner,
114         address spender,
115         uint256 value,
116         uint256 deadline,
117         uint8 v,
118         bytes32 r,
119         bytes32 s
120     ) public virtual {
121         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
122 
123         // Unchecked because the only math done is incrementing
124         // the owner's nonce which cannot realistically overflow.
125         unchecked {
126             address recoveredAddress = ecrecover(
127                 keccak256(
128                     abi.encodePacked(
129                         "\x19\x01",
130                         DOMAIN_SEPARATOR(),
131                         keccak256(
132                             abi.encode(
133                                 keccak256(
134                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
135                                 ),
136                                 owner,
137                                 spender,
138                                 value,
139                                 nonces[owner]++,
140                                 deadline
141                             )
142                         )
143                     )
144                 ),
145                 v,
146                 r,
147                 s
148             );
149 
150             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
151 
152             allowance[recoveredAddress][spender] = value;
153         }
154 
155         emit Approval(owner, spender, value);
156     }
157 
158     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
159         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
160     }
161 
162     function computeDomainSeparator() internal view virtual returns (bytes32) {
163         return
164             keccak256(
165                 abi.encode(
166                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
167                     keccak256(bytes(name)),
168                     keccak256("1"),
169                     block.chainid,
170                     address(this)
171                 )
172             );
173     }
174 
175     /*//////////////////////////////////////////////////////////////
176                         INTERNAL MINT/BURN LOGIC
177     //////////////////////////////////////////////////////////////*/
178 
179     function _mint(address to, uint256 amount) internal virtual {
180         totalSupply += amount;
181 
182         // Cannot overflow because the sum of all user
183         // balances can't exceed the max uint256 value.
184         unchecked {
185             balanceOf[to] += amount;
186         }
187 
188         emit Transfer(address(0), to, amount);
189     }
190 
191     function _burn(address from, uint256 amount) internal virtual {
192         balanceOf[from] -= amount;
193 
194         // Cannot underflow because a user's balance
195         // will never be larger than the total supply.
196         unchecked {
197             totalSupply -= amount;
198         }
199 
200         emit Transfer(from, address(0), amount);
201     }
202 }
203 
204 contract NOTHING is ERC20("The Nothing", "UNDREAM", 8) {
205     constructor() {
206         _mint(msg.sender, 100_000_000_000_000_000_000_000e8);
207     }
208 }
209 
210 // (_)_ __  
211 // | | '_ \ 
212 // | | | | |
213 // |_|_| |_|
214 //                                             
215 // _ __ ___   ___ _ __ ___   ___  _ __ _   _ 
216 // | '_ ` _ \ / _ \ '_ ` _ \ / _ \| '__| | | |
217 // | | | | | |  __/ | | | | | (_) | |  | |_| |
218 // |_| |_| |_|\___|_| |_| |_|\___/|_|   \__, |
219 //                                     |___/ 
220 //         __   _   _          
221 //   ___  / _| | |_| |__   ___ 
222 //  / _ \| |_  | __| '_ \ / _ \
223 // | (_) |  _| | |_| | | |  __/
224 // \___/|_|    \__|_| |_|\___|                          
225 //        _                    _   
226 //   __ _| |__  ___  ___ _ __ | |_ 
227 //  / _` | '_ \/ __|/ _ \ '_ \| __|
228 // | (_| | |_) \__ \  __/ | | | |_ 
229 //  \__,_|_.__/|___/\___|_| |_|\__|