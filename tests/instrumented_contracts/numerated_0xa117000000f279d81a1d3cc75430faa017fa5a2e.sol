1 // File: contracts/interfaces/IERC20.sol
2 
3 pragma solidity ^0.5.17;
4 
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 }
14 
15 // File: contracts/libraries/SafeMath.sol
16 
17 pragma solidity ^0.5.17;
18 
19 
20 // A library for performing overflow-safe math, courtesy of DappHub: https://github.com/dapphub/ds-math/blob/d0ef6d6a5f/src/math.sol
21 // Modified to include only the essentials
22 library SafeMath {
23     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
24         require((z = x + y) >= x, "MATH:ADD_OVERFLOW");
25     }
26 
27     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
28         require((z = x - y) <= x, "MATH:SUB_UNDERFLOW");
29     }
30 }
31 
32 // File: contracts/ANTv2.sol
33 
34 pragma solidity 0.5.17;
35 
36 
37 
38 
39 // Lightweight token modelled after UNI-LP: https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
40 // Adds:
41 //   - An exposed `mint()` with minting role
42 //   - An exposed `burn()`
43 //   - ERC-3009 (`transferWithAuthorization()`)
44 contract ANTv2 is IERC20 {
45     using SafeMath for uint256;
46 
47     // bytes32 private constant EIP712DOMAIN_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
48     bytes32 private constant EIP712DOMAIN_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
49     // bytes32 private constant NAME_HASH = keccak256("Aragon Network Token")
50     bytes32 private constant NAME_HASH = 0x711a8013284a3c0046af6c0d6ed33e8bbc2c7a11d615cf4fdc8b1ac753bda618;
51     // bytes32 private constant VERSION_HASH = keccak256("1")
52     bytes32 private constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
53 
54     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
55     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
56     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
57     //     keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
58     bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH = 0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
59 
60     string public constant name = "Aragon Network Token";
61     string public constant symbol = "ANT";
62     uint8 public constant decimals = 18;
63 
64     address public minter;
65     uint256 public totalSupply;
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69     // ERC-2612, ERC-3009 state
70     mapping (address => uint256) public nonces;
71     mapping (address => mapping (bytes32 => bool)) public authorizationState;
72 
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
76     event ChangeMinter(address indexed minter);
77 
78     modifier onlyMinter {
79         require(msg.sender == minter, "ANTV2:NOT_MINTER");
80         _;
81     }
82 
83     constructor(address initialMinter) public {
84         _changeMinter(initialMinter);
85     }
86 
87     function _validateSignedData(address signer, bytes32 encodeData, uint8 v, bytes32 r, bytes32 s) internal view {
88         bytes32 digest = keccak256(
89             abi.encodePacked(
90                 "\x19\x01",
91                 getDomainSeparator(),
92                 encodeData
93             )
94         );
95         address recoveredAddress = ecrecover(digest, v, r, s);
96         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
97         require(recoveredAddress != address(0) && recoveredAddress == signer, "ANTV2:INVALID_SIGNATURE");
98     }
99 
100     function _changeMinter(address newMinter) internal {
101         minter = newMinter;
102         emit ChangeMinter(newMinter);
103     }
104 
105     function _mint(address to, uint256 value) internal {
106         totalSupply = totalSupply.add(value);
107         balanceOf[to] = balanceOf[to].add(value);
108         emit Transfer(address(0), to, value);
109     }
110 
111     function _burn(address from, uint value) internal {
112         // Balance is implicitly checked with SafeMath's underflow protection
113         balanceOf[from] = balanceOf[from].sub(value);
114         totalSupply = totalSupply.sub(value);
115         emit Transfer(from, address(0), value);
116     }
117 
118     function _approve(address owner, address spender, uint256 value) private {
119         allowance[owner][spender] = value;
120         emit Approval(owner, spender, value);
121     }
122 
123     function _transfer(address from, address to, uint256 value) private {
124         require(to != address(this) && to != address(0), "ANTV2:RECEIVER_IS_TOKEN_OR_ZERO");
125 
126         // Balance is implicitly checked with SafeMath's underflow protection
127         balanceOf[from] = balanceOf[from].sub(value);
128         balanceOf[to] = balanceOf[to].add(value);
129         emit Transfer(from, to, value);
130     }
131 
132     function getChainId() public pure returns (uint256 chainId) {
133         assembly { chainId := chainid() }
134     }
135 
136     function getDomainSeparator() public view returns (bytes32) {
137         return keccak256(
138             abi.encode(
139                 EIP712DOMAIN_HASH,
140                 NAME_HASH,
141                 VERSION_HASH,
142                 getChainId(),
143                 address(this)
144             )
145         );
146     }
147 
148     function mint(address to, uint256 value) external onlyMinter returns (bool) {
149         _mint(to, value);
150         return true;
151     }
152 
153     function changeMinter(address newMinter) external onlyMinter {
154         _changeMinter(newMinter);
155     }
156 
157     function burn(uint256 value) external returns (bool) {
158         _burn(msg.sender, value);
159         return true;
160     }
161 
162     function approve(address spender, uint256 value) external returns (bool) {
163         _approve(msg.sender, spender, value);
164         return true;
165     }
166 
167     function transfer(address to, uint256 value) external returns (bool) {
168         _transfer(msg.sender, to, value);
169         return true;
170     }
171 
172     function transferFrom(address from, address to, uint256 value) external returns (bool) {
173         uint256 fromAllowance = allowance[from][msg.sender];
174         if (fromAllowance != uint256(-1)) {
175             // Allowance is implicitly checked with SafeMath's underflow protection
176             allowance[from][msg.sender] = fromAllowance.sub(value);
177         }
178         _transfer(from, to, value);
179         return true;
180     }
181 
182     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
183         require(deadline >= block.timestamp, "ANTV2:AUTH_EXPIRED");
184 
185         bytes32 encodeData = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
186         _validateSignedData(owner, encodeData, v, r, s);
187 
188         _approve(owner, spender, value);
189     }
190 
191     function transferWithAuthorization(
192         address from,
193         address to,
194         uint256 value,
195         uint256 validAfter,
196         uint256 validBefore,
197         bytes32 nonce,
198         uint8 v,
199         bytes32 r,
200         bytes32 s
201     )
202         external
203     {
204         require(block.timestamp > validAfter, "ANTV2:AUTH_NOT_YET_VALID");
205         require(block.timestamp < validBefore, "ANTV2:AUTH_EXPIRED");
206         require(!authorizationState[from][nonce],  "ANTV2:AUTH_ALREADY_USED");
207 
208         bytes32 encodeData = keccak256(abi.encode(TRANSFER_WITH_AUTHORIZATION_TYPEHASH, from, to, value, validAfter, validBefore, nonce));
209         _validateSignedData(from, encodeData, v, r, s);
210 
211         authorizationState[from][nonce] = true;
212         emit AuthorizationUsed(from, nonce);
213 
214         _transfer(from, to, value);
215     }
216 }