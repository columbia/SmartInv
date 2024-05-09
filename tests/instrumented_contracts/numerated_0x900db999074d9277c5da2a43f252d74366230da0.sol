1 // File: openzeppelin-contracts-v4/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 // File: contracts/Tokens/Token.sol
86 
87 
88 
89 pragma solidity 0.8.6;
90 
91 
92 // Lightweight token modelled after UNI-LP:
93 // https://github.com/Uniswap/uniswap-v2-core/blob/v1.0.1/contracts/UniswapV2ERC20.sol
94 // Adds:
95 //   - An exposed `burn()` and `mint()` with minting role
96 //   - ERC-3009 (`transferWithAuthorization()`)
97 //   - domainSeparator is computed inside `_validateSignedData` to avoid reply-attacks due to Hardforks
98 //   - to != address(this) && to != address(0); To avoid people sending tokens to this smartcontract and
99 //          to distinguish burn events from transfer
100 
101 contract GIV is IERC20 {
102     uint256 public initialBalance;
103 
104     // bytes32 public constant PERMIT_TYPEHASH =
105     //      keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
106     bytes32 public constant PERMIT_TYPEHASH =
107         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
108     // bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
109     //      keccak256("TransferWithAuthorization(address from,address to,uint256 value,uint256 validAfter,uint256 validBefore,bytes32 nonce)");
110     bytes32 public constant TRANSFER_WITH_AUTHORIZATION_TYPEHASH =
111         0x7c7c6cdb67a18743f49ec6fa9b35f50d52ed05cbed4cc592e13b44501c1a2267;
112     // bytes32 public constant EIP712DOMAIN_HASH =
113     //      keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
114     bytes32 public constant EIP712DOMAIN_HASH =
115         0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
116     // bytes32 public constant NAME_HASH =
117     //      keccak256("Giveth")
118     bytes32 public constant NAME_HASH =
119         0x33ef7d8509d7fc60c9fbe6cfb57a52ac1d91ca62f595d3b55c7cbdbb6372f902;
120     // bytes32 public constant VERSION_HASH =
121     //      keccak256("1")
122     bytes32 public constant VERSION_HASH =
123         0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
124 
125     string public constant name = "Giveth";
126     string public constant symbol = "GIV";
127     uint8 public constant decimals = 18;
128 
129     address public minter;
130     uint256 public override totalSupply;
131     mapping(address => uint256) public override balanceOf;
132     mapping(address => mapping(address => uint256)) public override allowance;
133 
134     // ERC-2612, ERC-3009 state
135     mapping(address => uint256) public nonces;
136     mapping(address => mapping(bytes32 => bool)) public authorizationState;
137 
138     event AuthorizationUsed(address indexed authorizer, bytes32 indexed nonce);
139     event ChangeMinter(address indexed minter);
140 
141     modifier onlyMinter() {
142         require(msg.sender == minter, "GIV:NOT_MINTER");
143         _;
144     }
145 
146     constructor(address initialMinter) {
147         _changeMinter(initialMinter);
148     }
149 
150     function _validateSignedData(
151         address signer,
152         bytes32 encodeData,
153         uint8 v,
154         bytes32 r,
155         bytes32 s
156     ) internal view {
157         bytes32 digest = keccak256(
158             abi.encodePacked("\x19\x01", getDomainSeparator(), encodeData)
159         );
160         address recoveredAddress = ecrecover(digest, v, r, s);
161         // Explicitly disallow authorizations for address(0) as ecrecover returns address(0) on malformed messages
162         require(
163             recoveredAddress != address(0) && recoveredAddress == signer,
164             "GIV:INVALID_SIGNATURE"
165         );
166     }
167 
168     function _changeMinter(address newMinter) internal {
169         minter = newMinter;
170         emit ChangeMinter(newMinter);
171     }
172 
173     function _mint(address to, uint256 value) internal {
174         totalSupply = totalSupply + value;
175         balanceOf[to] = balanceOf[to] + value;
176         emit Transfer(address(0), to, value);
177     }
178 
179     function _burn(address from, uint256 value) internal {
180         // Balance is implicitly checked with solidity underflow protection
181         balanceOf[from] = balanceOf[from] - value;
182         totalSupply = totalSupply - value;
183         emit Transfer(from, address(0), value);
184     }
185 
186     function _approve(
187         address owner,
188         address spender,
189         uint256 value
190     ) private {
191         allowance[owner][spender] = value;
192         emit Approval(owner, spender, value);
193     }
194 
195     function _transfer(
196         address from,
197         address to,
198         uint256 value
199     ) private {
200         require(
201             to != address(this) && to != address(0),
202             "GIV:NOT_VALID_TRANSFER"
203         );
204         // Balance is implicitly checked with SafeMath's underflow protection
205         balanceOf[from] = balanceOf[from] - value;
206         balanceOf[to] = balanceOf[to] + value;
207         emit Transfer(from, to, value);
208     }
209 
210     function getChainId() public view returns (uint256 chainId) {
211         assembly {
212             chainId := chainid()
213         }
214     }
215 
216     function getDomainSeparator() public view returns (bytes32) {
217         return
218             keccak256(
219                 abi.encode(
220                     EIP712DOMAIN_HASH,
221                     NAME_HASH,
222                     VERSION_HASH,
223                     getChainId(),
224                     address(this)
225                 )
226             );
227     }
228 
229     function mint(address to, uint256 value)
230         external
231         onlyMinter
232         returns (bool)
233     {
234         _mint(to, value);
235         return true;
236     }
237 
238     function changeMinter(address newMinter) external onlyMinter {
239         _changeMinter(newMinter);
240     }
241 
242     function burn(uint256 value) external returns (bool) {
243         _burn(msg.sender, value);
244         return true;
245     }
246 
247     function approve(address spender, uint256 value)
248         external
249         override
250         returns (bool)
251     {
252         _approve(msg.sender, spender, value);
253         return true;
254     }
255 
256     function transfer(address to, uint256 value)
257         external
258         override
259         returns (bool)
260     {
261         _transfer(msg.sender, to, value);
262         return true;
263     }
264 
265     function transferFrom(
266         address from,
267         address to,
268         uint256 value
269     ) external override returns (bool) {
270         uint256 fromAllowance = allowance[from][msg.sender];
271         if (fromAllowance != type(uint256).max) {
272             // Allowance is implicitly checked with solidity underflow protection
273             allowance[from][msg.sender] = fromAllowance - value;
274         }
275         _transfer(from, to, value);
276         return true;
277     }
278 
279     function permit(
280         address owner,
281         address spender,
282         uint256 value,
283         uint256 deadline,
284         uint8 v,
285         bytes32 r,
286         bytes32 s
287     ) external {
288         require(deadline >= block.timestamp, "GIV:AUTH_EXPIRED");
289         bytes32 encodeData = keccak256(
290             abi.encode(
291                 PERMIT_TYPEHASH,
292                 owner,
293                 spender,
294                 value,
295                 nonces[owner]++,
296                 deadline
297             )
298         );
299         _validateSignedData(owner, encodeData, v, r, s);
300         _approve(owner, spender, value);
301     }
302 
303     function transferWithAuthorization(
304         address from,
305         address to,
306         uint256 value,
307         uint256 validAfter,
308         uint256 validBefore,
309         bytes32 nonce,
310         uint8 v,
311         bytes32 r,
312         bytes32 s
313     ) external {
314         require(block.timestamp > validAfter, "GIV:AUTH_NOT_YET_VALID");
315         require(block.timestamp < validBefore, "GIV:AUTH_EXPIRED");
316         require(!authorizationState[from][nonce], "GIV:AUTH_ALREADY_USED");
317 
318         bytes32 encodeData = keccak256(
319             abi.encode(
320                 TRANSFER_WITH_AUTHORIZATION_TYPEHASH,
321                 from,
322                 to,
323                 value,
324                 validAfter,
325                 validBefore,
326                 nonce
327             )
328         );
329         _validateSignedData(from, encodeData, v, r, s);
330 
331         authorizationState[from][nonce] = true;
332         emit AuthorizationUsed(from, nonce);
333 
334         _transfer(from, to, value);
335     }
336 }