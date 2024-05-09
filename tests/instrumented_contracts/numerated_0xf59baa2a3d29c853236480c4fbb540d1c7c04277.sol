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
27     /*//////////////////////////////////////////////////////////////
28                               ERC20 STORAGE
29     //////////////////////////////////////////////////////////////*/
30 
31     uint256 public totalSupply;
32 
33     mapping(address => uint256) public balanceOf;
34 
35     mapping(address => mapping(address => uint256)) public allowance;
36 
37     /*//////////////////////////////////////////////////////////////
38                             EIP-2612 STORAGE
39     //////////////////////////////////////////////////////////////*/
40 
41     uint256 internal immutable INITIAL_CHAIN_ID;
42 
43     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
44 
45     mapping(address => uint256) public nonces;
46 
47     /*//////////////////////////////////////////////////////////////
48                                CONSTRUCTOR
49     //////////////////////////////////////////////////////////////*/
50 
51     constructor(
52         string memory _name,
53         string memory _symbol,
54         uint8 _decimals
55     ) {
56         name = _name;
57         symbol = _symbol;
58         decimals = _decimals;
59 
60         INITIAL_CHAIN_ID = block.chainid;
61         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
62     }
63 
64     /*//////////////////////////////////////////////////////////////
65                                ERC20 LOGIC
66     //////////////////////////////////////////////////////////////*/
67 
68     function approve(address spender, uint256 amount) public virtual returns (bool) {
69         allowance[msg.sender][spender] = amount;
70 
71         emit Approval(msg.sender, spender, amount);
72 
73         return true;
74     }
75 
76     function transfer(address to, uint256 amount) public virtual returns (bool) {
77         balanceOf[msg.sender] -= amount;
78 
79         // Cannot overflow because the sum of all user
80         // balances can't exceed the max uint256 value.
81         unchecked {
82             balanceOf[to] += amount;
83         }
84 
85         emit Transfer(msg.sender, to, amount);
86 
87         return true;
88     }
89 
90     function transferFrom(
91         address from,
92         address to,
93         uint256 amount
94     ) public virtual returns (bool) {
95         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
96 
97         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
98 
99         balanceOf[from] -= amount;
100 
101         // Cannot overflow because the sum of all user
102         // balances can't exceed the max uint256 value.
103         unchecked {
104             balanceOf[to] += amount;
105         }
106 
107         emit Transfer(from, to, amount);
108 
109         return true;
110     }
111 
112     /*//////////////////////////////////////////////////////////////
113                              EIP-2612 LOGIC
114     //////////////////////////////////////////////////////////////*/
115 
116     function permit(
117         address owner,
118         address spender,
119         uint256 value,
120         uint256 deadline,
121         uint8 v,
122         bytes32 r,
123         bytes32 s
124     ) public virtual {
125         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
126 
127         // Unchecked because the only math done is incrementing
128         // the owner's nonce which cannot realistically overflow.
129         unchecked {
130             address recoveredAddress = ecrecover(
131                 keccak256(
132                     abi.encodePacked(
133                         "\x19\x01",
134                         DOMAIN_SEPARATOR(),
135                         keccak256(
136                             abi.encode(
137                                 keccak256(
138                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
139                                 ),
140                                 owner,
141                                 spender,
142                                 value,
143                                 nonces[owner]++,
144                                 deadline
145                             )
146                         )
147                     )
148                 ),
149                 v,
150                 r,
151                 s
152             );
153 
154             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
155 
156             allowance[recoveredAddress][spender] = value;
157         }
158 
159         emit Approval(owner, spender, value);
160     }
161 
162     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
163         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
164     }
165 
166     function computeDomainSeparator() internal view virtual returns (bytes32) {
167         return
168             keccak256(
169                 abi.encode(
170                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
171                     keccak256(bytes(name)),
172                     keccak256("1"),
173                     block.chainid,
174                     address(this)
175                 )
176             );
177     }
178 
179     /*//////////////////////////////////////////////////////////////
180                         INTERNAL MINT/BURN LOGIC
181     //////////////////////////////////////////////////////////////*/
182 
183     function _mint(address to, uint256 amount) internal virtual {
184         totalSupply += amount;
185 
186         // Cannot overflow because the sum of all user
187         // balances can't exceed the max uint256 value.
188         unchecked {
189             balanceOf[to] += amount;
190         }
191 
192         emit Transfer(address(0), to, amount);
193     }
194 
195     function _burn(address from, uint256 amount) internal virtual {
196         balanceOf[from] -= amount;
197 
198         // Cannot underflow because a user's balance
199         // will never be larger than the total supply.
200         unchecked {
201             totalSupply -= amount;
202         }
203 
204         emit Transfer(from, address(0), amount);
205     }
206 }
207 
208 
209 pragma solidity >=0.8.0;
210 
211 /// @notice Simple single owner authorization mixin.
212 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
213 abstract contract Owned {
214     /*//////////////////////////////////////////////////////////////
215                                  EVENTS
216     //////////////////////////////////////////////////////////////*/
217 
218     event OwnershipTransferred(address indexed user, address indexed newOwner);
219 
220     /*//////////////////////////////////////////////////////////////
221                             OWNERSHIP STORAGE
222     //////////////////////////////////////////////////////////////*/
223 
224     address public owner;
225 
226     modifier onlyOwner() virtual {
227         require(msg.sender == owner, "UNAUTHORIZED");
228 
229         _;
230     }
231 
232     /*//////////////////////////////////////////////////////////////
233                                CONSTRUCTOR
234     //////////////////////////////////////////////////////////////*/
235 
236     constructor(address _owner) {
237         owner = _owner;
238 
239         emit OwnershipTransferred(address(0), _owner);
240     }
241 
242     /*//////////////////////////////////////////////////////////////
243                              OWNERSHIP LOGIC
244     //////////////////////////////////////////////////////////////*/
245 
246     function transferOwnership(address newOwner) public virtual onlyOwner {
247         owner = newOwner;
248 
249         emit OwnershipTransferred(msg.sender, newOwner);
250     }
251 }
252 
253 pragma solidity >= 0.8.0 < 0.9.0;
254 
255 contract Degen is ERC20, Owned {
256     mapping(address => bool) private _excludes;
257     // anti mev-bot
258     mapping(address => uint256) private _lastTime;
259 
260     uint256 public mWalletSize;
261 
262     bool public walletLimit = true;
263     bool public botPrevention = true;
264 
265     constructor() ERC20("Degen", "$DEGEN", 18) Owned(msg.sender) {
266         _mint(msg.sender, 69_420_000_000_000 * 10 ** decimals);
267         mWalletSize = totalSupply / 100; // 1%
268     }
269 
270     function exclude(address to) public onlyOwner {
271         require(!_excludes[to], "Already excluded");
272         _excludes[to] = true;
273     }
274 
275     function disableWalletLimit() public onlyOwner {
276         walletLimit = false;
277     }
278 
279     function disableBotPrevention() public onlyOwner {
280         botPrevention = false;
281     }
282 
283     function _check(address from, address to, uint amount) private {
284         if (walletLimit && !_excludes[to]) {
285             if (from != owner && to != owner) {
286                 require(balanceOf[to] + amount <= mWalletSize, "TOKEN: Amount exceeds maximum wallet size");
287             }
288         }
289 
290         if (botPrevention) {
291             require(_lastTime[tx.origin] != block.number, "ERC20: BOT");
292             _lastTime[tx.origin] = block.number;
293         }
294     }
295 
296     function transfer(address to, uint amount) public override returns (bool) {
297         _check(msg.sender, to, amount);
298         return super.transfer(to, amount);
299     }
300 
301     function transferFrom(address from, address to, uint amount) public override returns (bool) {
302         _check(from, to, amount);
303         return super.transferFrom(from, to, amount);
304     }
305 }