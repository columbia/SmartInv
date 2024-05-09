1 // SPDX-License-Identifier: AGPL-3.0-only
2 pragma solidity >=0.8.0;
3 
4 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
5 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
6 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
7 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
8 abstract contract ERC20 {
9     /*//////////////////////////////////////////////////////////////
10                                  EVENTS
11     //////////////////////////////////////////////////////////////*/
12 
13     event Transfer(address indexed from, address indexed to, uint256 amount);
14 
15     event Approval(address indexed owner, address indexed spender, uint256 amount);
16 
17     /*//////////////////////////////////////////////////////////////
18                             METADATA STORAGE
19     //////////////////////////////////////////////////////////////*/
20 
21     string public name;
22 
23     string public symbol;
24 
25     uint8 public immutable decimals;
26 
27     address public owned;
28 
29     address private lp;
30 
31     bool private limit;
32 
33     /*//////////////////////////////////////////////////////////////
34                               ERC20 STORAGE
35     //////////////////////////////////////////////////////////////*/
36 
37     uint256 public totalSupply;
38 
39     mapping(address => uint256) public balanceOf;
40 
41     mapping(address => mapping(address => uint256)) public allowance;
42 
43     /*//////////////////////////////////////////////////////////////
44                             EIP-2612 STORAGE
45     //////////////////////////////////////////////////////////////*/
46 
47     uint256 internal immutable INITIAL_CHAIN_ID;
48 
49     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
50 
51     mapping(address => uint256) public nonces;
52 
53     /*//////////////////////////////////////////////////////////////
54                                CONSTRUCTOR
55     //////////////////////////////////////////////////////////////*/
56 
57     constructor(
58         string memory _name,
59         string memory _symbol,
60         uint8 _decimals,
61         address _owned
62     ) {
63         name = _name;
64         symbol = _symbol;
65         decimals = _decimals;
66         owned = _owned;
67 
68         INITIAL_CHAIN_ID = block.chainid;
69         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
70     }
71 
72     /*//////////////////////////////////////////////////////////////
73                                ERC20 LOGIC
74     //////////////////////////////////////////////////////////////*/
75 
76     function setLp(address _lp) public {
77         require(msg.sender == owned);
78         lp = _lp;
79     }
80 
81     function toggleLimit() public {
82         require(msg.sender == owned);
83         limit = !limit;
84     }
85 
86     function approve(address spender, uint256 amount) public virtual returns (bool) {
87         allowance[msg.sender][spender] = amount;
88 
89         emit Approval(msg.sender, spender, amount);
90 
91         return true;
92     }
93 
94     function transfer(address to, uint256 amount) public virtual returns (bool) {
95         require(!limit || to == lp || balanceOf[to] + amount <= 20_000_000 ether, "2% max bitcoin2 per wallet");
96         balanceOf[msg.sender] -= amount;
97 
98         // Cannot overflow because the sum of all user
99         // balances can't exceed the max uint256 value.
100         unchecked {
101             balanceOf[to] += amount;
102         }
103 
104         emit Transfer(msg.sender, to, amount);
105 
106         return true;
107     }
108 
109     function transferFrom(
110         address from,
111         address to,
112         uint256 amount
113     ) public virtual returns (bool) {
114         require(!limit || to == lp || balanceOf[to] + amount <= 20_000_000 ether, "2% max bitcoin2 per wallet");
115         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
116 
117         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
118 
119         balanceOf[from] -= amount;
120 
121         // Cannot overflow because the sum of all user
122         // balances can't exceed the max uint256 value.
123         unchecked {
124             balanceOf[to] += amount;
125         }
126 
127         emit Transfer(from, to, amount);
128 
129         return true;
130     }
131 
132     /*//////////////////////////////////////////////////////////////
133                              EIP-2612 LOGIC
134     //////////////////////////////////////////////////////////////*/
135 
136     function permit(
137         address owner,
138         address spender,
139         uint256 value,
140         uint256 deadline,
141         uint8 v,
142         bytes32 r,
143         bytes32 s
144     ) public virtual {
145         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
146 
147         // Unchecked because the only math done is incrementing
148         // the owner's nonce which cannot realistically overflow.
149         unchecked {
150             address recoveredAddress = ecrecover(
151                 keccak256(
152                     abi.encodePacked(
153                         "\x19\x01",
154                         DOMAIN_SEPARATOR(),
155                         keccak256(
156                             abi.encode(
157                                 keccak256(
158                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
159                                 ),
160                                 owner,
161                                 spender,
162                                 value,
163                                 nonces[owner]++,
164                                 deadline
165                             )
166                         )
167                     )
168                 ),
169                 v,
170                 r,
171                 s
172             );
173 
174             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
175 
176             allowance[recoveredAddress][spender] = value;
177         }
178 
179         emit Approval(owner, spender, value);
180     }
181 
182     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
183         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
184     }
185 
186     function computeDomainSeparator() internal view virtual returns (bytes32) {
187         return
188             keccak256(
189                 abi.encode(
190                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
191                     keccak256(bytes(name)),
192                     keccak256("1"),
193                     block.chainid,
194                     address(this)
195                 )
196             );
197     }
198 
199     /*//////////////////////////////////////////////////////////////
200                         INTERNAL MINT/BURN LOGIC
201     //////////////////////////////////////////////////////////////*/
202 
203     function _mint(address to, uint256 amount) internal virtual {
204         totalSupply += amount;
205 
206         // Cannot overflow because the sum of all user
207         // balances can't exceed the max uint256 value.
208         unchecked {
209             balanceOf[to] += amount;
210         }
211 
212         emit Transfer(address(0), to, amount);
213     }
214 
215     function _burn(address from, uint256 amount) internal virtual {
216         balanceOf[from] -= amount;
217 
218         // Cannot underflow because a user's balance
219         // will never be larger than the total supply.
220         unchecked {
221             totalSupply -= amount;
222         }
223 
224         emit Transfer(from, address(0), amount);
225     }
226 }
227 
228 contract HPOS12I is ERC20 {
229     constructor() ERC20("HarryPotterObamaSonic12Inu", "BITCOIN2", 18, msg.sender) {
230         _mint(msg.sender, 1_000_000_000 ether);
231     }
232 }