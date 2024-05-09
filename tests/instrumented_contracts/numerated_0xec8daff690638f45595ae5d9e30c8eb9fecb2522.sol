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
27     bool locked;
28 
29     /*//////////////////////////////////////////////////////////////
30                               ERC20 STORAGE
31     //////////////////////////////////////////////////////////////*/
32 
33 
34     uint256 public totalSupply;
35 
36     mapping(address => uint256) public balanceOf;
37 
38     mapping(address => mapping(address => uint256)) public allowance;
39 
40     /*//////////////////////////////////////////////////////////////
41                             EIP-2612 STORAGE
42     //////////////////////////////////////////////////////////////*/
43 
44     uint256 internal immutable INITIAL_CHAIN_ID;
45 
46     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
47 
48     mapping(address => uint256) public nonces;
49 
50 
51     /*//////////////////////////////////////////////////////////////
52                                CONSTRUCTOR
53     //////////////////////////////////////////////////////////////*/
54 
55     constructor(
56         string memory _name,
57         string memory _symbol,
58         uint8 _decimals
59     ) {
60         name = _name;
61         symbol = _symbol;
62         decimals = _decimals;
63 
64         INITIAL_CHAIN_ID = block.chainid;
65         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
66     }
67 
68     /*//////////////////////////////////////////////////////////////
69                                ERC20 LOGIC
70     //////////////////////////////////////////////////////////////*/
71 
72     function approve(address spender, uint256 amount) public virtual returns (bool) {
73         allowance[msg.sender][spender] = amount;
74 
75         emit Approval(msg.sender, spender, amount);
76 
77         return true;
78     }
79 
80     function transfer(address to, uint256 amount) public virtual returns (bool) {
81         require(locked, "transfers locked");
82         balanceOf[msg.sender] -= amount;
83 
84         // Cannot overflow because the sum of all user
85         // balances can't exceed the max uint256 value.
86         unchecked {
87             balanceOf[to] += amount;
88         }
89 
90         emit Transfer(msg.sender, to, amount);
91 
92         return true;
93     }
94 
95     function transferFrom(
96         address from,
97         address to,
98         uint256 amount
99     ) public virtual returns (bool) {
100         require(locked, "transfers locked");
101         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
102 
103         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
104 
105         balanceOf[from] -= amount;
106 
107         // Cannot overflow because the sum of all user
108         // balances can't exceed the max uint256 value.
109         unchecked {
110             balanceOf[to] += amount;
111         }
112 
113         emit Transfer(from, to, amount);
114 
115         return true;
116     }
117 
118     /*//////////////////////////////////////////////////////////////
119                              EIP-2612 LOGIC
120     //////////////////////////////////////////////////////////////*/
121 
122     function permit(
123         address owner,
124         address spender,
125         uint256 value,
126         uint256 deadline,
127         uint8 v,
128         bytes32 r,
129         bytes32 s
130     ) public virtual {
131         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
132 
133         // Unchecked because the only math done is incrementing
134         // the owner's nonce which cannot realistically overflow.
135         unchecked {
136             address recoveredAddress = ecrecover(
137                 keccak256(
138                     abi.encodePacked(
139                         "\x19\x01",
140                         DOMAIN_SEPARATOR(),
141                         keccak256(
142                             abi.encode(
143                                 keccak256(
144                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
145                                 ),
146                                 owner,
147                                 spender,
148                                 value,
149                                 nonces[owner]++,
150                                 deadline
151                             )
152                         )
153                     )
154                 ),
155                 v,
156                 r,
157                 s
158             );
159 
160             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
161 
162             allowance[recoveredAddress][spender] = value;
163         }
164 
165         emit Approval(owner, spender, value);
166     }
167 
168     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
169         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
170     }
171 
172     function computeDomainSeparator() internal view virtual returns (bytes32) {
173         return
174             keccak256(
175                 abi.encode(
176                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
177                     keccak256(bytes(name)),
178                     keccak256("1"),
179                     block.chainid,
180                     address(this)
181                 )
182             );
183     }
184 
185     /*//////////////////////////////////////////////////////////////
186                         INTERNAL MINT/BURN LOGIC
187     //////////////////////////////////////////////////////////////*/
188 
189     function _mint(address to, uint256 amount) internal virtual {
190         totalSupply += amount;
191 
192         // Cannot overflow because the sum of all user
193         // balances can't exceed the max uint256 value.
194         unchecked {
195             balanceOf[to] += amount;
196         }
197 
198         emit Transfer(address(0), to, amount);
199     }
200 
201     function _burn(address from, uint256 amount) internal virtual {
202         balanceOf[from] -= amount;
203 
204         // Cannot underflow because a user's balance
205         // will never be larger than the total supply.
206         unchecked {
207             totalSupply -= amount;
208         }
209 
210         emit Transfer(from, address(0), amount);
211     }
212 }
213 
214 
215 contract GoySlop is ERC20 {
216     address owner;
217 
218     constructor() ERC20("GoySlop", "SLOP", 18) {
219         owner = msg.sender;
220     }
221 
222     function claim() public {
223         require(!locked, "claiming is locked");
224         _mint(msg.sender, 69000000e18);
225     }
226 
227     function setLocked(bool _locked) public {
228         require(msg.sender == owner);
229         locked = _locked;
230     }
231 
232 }