1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.4;
3 
4 library SafeMath {
5     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
6         require((z = x + y) >= x, "MATH:ADD_OVERFLOW");
7     }
8 
9     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
10         require((z = x - y) <= x, "MATH:SUB_UNDERFLOW");
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address account) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30 }
31 
32 // Lightweight token modelled after UNI-LP:
33 // https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
34 // Adds:
35 //   - An exposed `mint()` with minting role
36 //   - An exposed `burn()`
37 //   - ERC-3009 (`transferWithAuthorization()`)
38 contract FlashToken is IERC20 {
39     using SafeMath for uint256;
40 
41     // bytes32 private constant EIP712DOMAIN_HASH =
42     // keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
43     bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
44 
45     // bytes32 private constant NAME_HASH = keccak256("FLASH")
46     bytes32 private constant NAME_HASH = 0x345b72c36b14f1cee01efb8ac4b299dc7b8d873e28b4796034548a3d371a4d2f;
47 
48     // bytes32 private constant VERSION_HASH = keccak256("2")
49     bytes32 private constant VERSION_HASH = 0xad7c5bef027816a800da1736444fb58a807ef4c9603b7848673f7e3a68eb14a5;
50 
51     // bytes32 public constant PERMIT_TYPEHASH =
52     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
53     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
54 
55     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
56     // keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
57     bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
58 
59     string public constant name = "Flashstake";
60     string public constant symbol = "FLASH";
61     uint8 public constant decimals = 18;
62 
63     address public constant FLASH_PROTOCOL = 0x15EB0c763581329C921C8398556EcFf85Cc48275;
64     address public constant FLASH_CLAIM = 0xf2319b6D2aB252d8D80D8CEC34DaF0079222A624;
65 
66     uint256 public override totalSupply;
67 
68     mapping(address => uint256) public override balanceOf;
69     mapping(address => mapping(address => uint256)) public override allowance;
70 
71     // ERC-2612, ERC-3009 state
72     mapping(address => uint256) public nonces;
73     mapping(address => mapping(bytes32 => bool)) public authorizationState;
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
78 
79     modifier onlyMinter {
80         require(msg.sender == FLASH_PROTOCOL || msg.sender == FLASH_CLAIM, "FlashToken:: NOT_MINTER");
81         _;
82     }
83 
84     constructor() {
85         // BlockZero Labs: Foundation Fund
86         _mint(0x842f8f6fB524996d0b660621DA895166E1ceA691, 1200746000000000000000000);
87         _mint(0x0945d9033147F27aDDFd3e7532ECD2100cb91032, 1000000000000000000000000);
88     }
89 
90     function _validateSignedData(
91         address signer,
92         bytes32 encodeData,
93         uint8 v,
94         bytes32 r,
95         bytes32 s
96     ) internal view {
97         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData));
98         address recoveredAddress = ecrecover(digest, v, r, s);
99         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
100         require(recoveredAddress != address(0) && recoveredAddress == signer, "FlashToken:: INVALID_SIGNATURE");
101     }
102 
103     function _mint(address to, uint256 value) internal {
104         totalSupply = totalSupply.add(value);
105         balanceOf[to] = balanceOf[to].add(value);
106         emit Transfer(address(0), to, value);
107     }
108 
109     function _burn(address from, uint256 value) internal {
110         // Balance is implicitly checked with SafeMath's underflow protection
111         balanceOf[from] = balanceOf[from].sub(value);
112         totalSupply = totalSupply.sub(value);
113         emit Transfer(from, address(0), value);
114     }
115 
116     function _approve(
117         address owner,
118         address spender,
119         uint256 value
120     ) private {
121         allowance[owner][spender] = value;
122         emit Approval(owner, spender, value);
123     }
124 
125     function _transfer(
126         address from,
127         address to,
128         uint256 value
129     ) private {
130         require(to != address(this) && to != address(0), "FlashToken:: RECEIVER_IS_TOKEN_OR_ZERO");
131 
132         // Balance is implicitly checked with SafeMath's underflow protection
133         balanceOf[from] = balanceOf[from].sub(value);
134         balanceOf[to] = balanceOf[to].add(value);
135         emit Transfer(from, to, value);
136     }
137 
138     function getChainId() public pure returns (uint256 chainId) {
139         // solhint-disable-next-line no-inline-assembly
140         assembly {
141             chainId := chainid()
142         }
143     }
144 
145     function getDomainSeparator() public view returns (bytes32) {
146         return keccak256(abi.encode(EIP712DOMAIN_HASH, NAME_HASH, VERSION_HASH, getChainId(), address(this)));
147     }
148 
149     function mint(address to, uint256 value) external onlyMinter returns (bool) {
150         _mint(to, value);
151         return true;
152     }
153 
154     function burn(uint256 value) external returns (bool) {
155         _burn(msg.sender, value);
156         return true;
157     }
158 
159     function approve(address spender, uint256 value) external override returns (bool) {
160         _approve(msg.sender, spender, value);
161         return true;
162     }
163 
164     function transfer(address to, uint256 value) external override returns (bool) {
165         _transfer(msg.sender, to, value);
166         return true;
167     }
168 
169     function transferFrom(
170         address from,
171         address to,
172         uint256 value
173     ) external override returns (bool) {
174         uint256 fromAllowance = allowance[from][msg.sender];
175         if (fromAllowance != uint256(-1)) {
176             // Allowance is implicitly checked with SafeMath's underflow protection
177             allowance[from][msg.sender] = fromAllowance.sub(value);
178         }
179         _transfer(from, to, value);
180         return true;
181     }
182 
183     function permit(
184         address owner,
185         address spender,
186         uint256 value,
187         uint256 deadline,
188         uint8 v,
189         bytes32 r,
190         bytes32 s
191     ) external {
192         require(deadline >= block.timestamp, "FlashToken:: AUTH_EXPIRED");
193 
194         bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner], deadline));
195         nonces[owner] = nonces[owner].add(1);
196         _validateSignedData(owner, encodeData, v, r, s);
197 
198         _approve(owner, spender, value);
199     }
200 
201     function transferWithAuthorization(
202         address from,
203         address to,
204         uint256 value,
205         uint256 validAfter,
206         uint256 validBefore,
207         bytes32 nonce,
208         uint8 v,
209         bytes32 r,
210         bytes32 s
211     ) external {
212         require(block.timestamp > validAfter, "FlashToken:: AUTH_NOT_YET_VALID");
213         require(block.timestamp < validBefore, "FlashToken:: AUTH_EXPIRED");
214         require(!authorizationState[from][nonce], "FlashToken:: AUTH_ALREADY_USED");
215 
216         bytes32 encodeData = keccak256(abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce));
217         _validateSignedData(from, encodeData, v, r, s);
218 
219         authorizationState[from][nonce] = true;
220         emit AuthorizationUsed(from, nonce);
221 
222         _transfer(from, to, value);
223     }
224 }