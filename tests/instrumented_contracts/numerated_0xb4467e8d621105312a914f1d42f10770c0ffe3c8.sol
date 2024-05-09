1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
5 // Modified to include only the essentials
6 library SafeMath {
7     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
8         require((z = x + y) >= x, "MATH:ADD_OVERFLOW");
9     }
10 
11     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
12         require((z = x - y) <= x, "MATH:SUB_UNDERFLOW");
13     }
14 }
15 
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address account) external view returns (uint256);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 }
34 
35 interface IFlashMinter {
36     function executeOnFlashMint(bytes calldata data) external;
37 }
38 
39 // Lightweight token modelled after UNI-LP:
40 // https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
41 // Adds:
42 //   - An exposed `mint()` with minting role
43 //   - An exposed `burn()`
44 //   - ERC-3009 (`transferWithAuthorization()`)
45 //   - flashMint() - allows to flashMint an arbitrary amount of FLASH, with the
46 //     condition that it is burned before the end of the transaction.
47 contract FlashToken is IERC20 {
48     using SafeMath for uint256;
49 
50     // bytes32 private constant EIP712DOMAIN_HASH =
51     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
52     bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
53 
54     // bytes32 private constant NAME_HASH = keccak256("FLASH")
55     bytes32 private constant NAME_HASH = 0x345b72c36b14f1cee01efb8ac4b299dc7b8d873e28b4796034548a3d371a4d2f;
56 
57     // bytes32 private constant VERSION_HASH = keccak256("1")
58     bytes32 private constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
59 
60     // bytes32 public constant PERMIT_TYPEHASH =
61     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
62     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
63 
64     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
65     // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
66     bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
67 
68     string public constant name = "Flash Token";
69     string public constant symbol = "FLASH";
70     uint8 public constant decimals = 18;
71 
72     uint256 public override totalSupply;
73     uint256 public flashSupply;
74 
75     mapping(address => bool) public minters;
76 
77     mapping(address => uint256) public override balanceOf;
78     mapping(address => mapping(address => uint256)) public override allowance;
79 
80     // ERC-2612, ERC-3009 state
81     mapping(address => uint256) public nonces;
82     mapping(address => mapping(bytes32 => bool)) public authorizationState;
83 
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
87 
88     modifier onlyMinter {
89         require(minters[msg.sender] == true, "FlashToken:: NOT_MINTER");
90         _;
91     }
92 
93     constructor(address flashProtocol, address flashClaim) public {
94         minters[flashProtocol] = true;
95         minters[flashClaim] = true;
96     }
97 
98     function _validateSignedData(
99         address signer,
100         bytes32 encodeData,
101         uint8 v,
102         bytes32 r,
103         bytes32 s
104     ) internal view {
105         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
106         address recoveredAddress = ecrecover(digest, v, r, s);
107         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
108         require(recoveredAddress != address(0) && recoveredAddress == signer, "FlashToken:: INVALID_SIGNATURE");
109     }
110 
111     function _mint(address to, uint256 value) internal {
112         totalSupply = totalSupply.add(value);
113         balanceOf[to] = balanceOf[to].add(value);
114         emit Transfer(address(0), to, value);
115     }
116 
117     function _burn(address from, uint256 value) internal {
118         // Balance is implicitly checked with SafeMath's underflow protection
119         balanceOf[from] = balanceOf[from].sub(value);
120         totalSupply = totalSupply.sub(value);
121         emit Transfer(from, address(0), value);
122     }
123 
124     function _approve(
125         address owner,
126         address spender,
127         uint256 value
128     ) private {
129         allowance[owner][spender] = value;
130         emit Approval(owner, spender, value);
131     }
132 
133     function _transfer(
134         address from,
135         address to,
136         uint256 value
137     ) private {
138         require(to != address(this) && to != address(0), "FlashToken:: RECEIVER_IS_TOKEN_OR_ZERO");
139 
140         // Balance is implicitly checked with SafeMath's underflow protection
141         balanceOf[from] = balanceOf[from].sub(value);
142         balanceOf[to] = balanceOf[to].add(value);
143         emit Transfer(from, to, value);
144     }
145 
146     function getChainId() public pure returns (uint256 chainId) {
147         // solhint-disable-next-line no-inline-assembly
148         assembly {
149             chainId := chainid()
150         }
151     }
152 
153     function getDomainSeparator() public view returns (bytes32) {
154         return keccak256(abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this)));
155     }
156 
157     function mint(address to, uint256 value) external onlyMinter returns (bool) {
158         _mint(to, value);
159         return true;
160     }
161 
162     function burn(uint256 value) external returns (bool) {
163         _burn(msg.sender, value);
164         return true;
165     }
166 
167     function approve(address spender, uint256 value) external override returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     function transfer(address to, uint256 value) external override returns (bool) {
173         _transfer(msg.sender, to, value);
174         return true;
175     }
176 
177     function transferFrom(
178         address from,
179         address to,
180         uint256 value
181     ) external override returns (bool) {
182         uint256 fromAllowance = allowance[from][msg.sender];
183         if (fromAllowance != uint256(-1)) {
184             // Allowance is implicitly checked with SafeMath's underflow protection
185             allowance[from][msg.sender] = fromAllowance.sub(value);
186         }
187         _transfer(from, to, value);
188         return true;
189     }
190 
191     function permit(
192         address owner,
193         address spender,
194         uint256 value,
195         uint256 deadline,
196         uint8 v,
197         bytes32 r,
198         bytes32 s
199     ) external {
200         require(deadline >= block.timestamp, "FlashToken:: AUTH_EXPIRED");
201 
202         bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
203         nonces[owner] = nonces[owner].add(1);
204         _validateSignedData(owner, encodeData, v, r, s);
205 
206         _approve(owner, spender, value);
207     }
208 
209     function transferWithAuthorization(
210         address from,
211         address to,
212         uint256 value,
213         uint256 validAfter,
214         uint256 validBefore,
215         bytes32 nonce,
216         uint8 v,
217         bytes32 r,
218         bytes32 s
219     ) external {
220         require(block.timestamp > validAfter, "FlashToken:: AUTH_NOT_YET_VALID");
221         require(block.timestamp < validBefore, "FlashToken:: AUTH_EXPIRED");
222         require(!authorizationState[from][nonce], "FlashToken:: AUTH_ALREADY_USED");
223 
224         bytes32 encodeData = keccak256(abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce));
225         _validateSignedData(from, encodeData, v, r, s);
226 
227         authorizationState[from][nonce] = true;
228         emit AuthorizationUsed(from, nonce);
229 
230         _transfer(from, to, value);
231     }
232 
233     function flashMint(uint256 value, bytes calldata data) external {
234         flashSupply = flashSupply.add(value);
235         require(flashSupply <= type(uint112).max, "FlashToken:: SUPPLY_LIMIT_EXCEED");
236         balanceOf[msg.sender] = balanceOf[msg.sender].add(value);
237         emit Transfer(address(0), msg.sender, value);
238 
239         IFlashMinter(msg.sender).executeOnFlashMint(data);
240 
241         require(balanceOf[msg.sender] >= value, "FlashToken:: TRANSFER_EXCEED_BALANCE");
242         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
243         flashSupply = flashSupply.sub(value);
244         emit Transfer(msg.sender, address(0), value);
245     }
246 }