1 //SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.6.8;
3 pragma experimental ABIEncoderV2;
4 
5 interface IMirrorWriteToken {
6     function register(string calldata label, address owner) external;
7 
8     function registrationCost() external view returns (uint256);
9 
10     // ============ ERC20 Interface ============
11 
12     event Approval(
13         address indexed owner,
14         address indexed spender,
15         uint256 value
16     );
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     function name() external view returns (string memory);
20 
21     function symbol() external view returns (string memory);
22 
23     function decimals() external view returns (uint8);
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address owner) external view returns (uint256);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
33 
34     function approve(address spender, uint256 value) external returns (bool);
35 
36     function transfer(address to, uint256 value) external returns (bool);
37 
38     function transferFrom(
39         address from,
40         address to,
41         uint256 value
42     ) external returns (bool);
43 
44     function permit(
45         address owner,
46         address spender,
47         uint256 value,
48         uint256 deadline,
49         uint8 v,
50         bytes32 r,
51         bytes32 s
52     ) external;
53 
54     function nonces(address owner) external view returns (uint256);
55 
56     function DOMAIN_SEPARATOR() external view returns (bytes32);
57 }
58 
59 /**
60  * @title MirrorWriteToken
61  * @author MirrorXYZ
62  *
63  *  An ERC20 that grants access to the ENS namespace through a
64  *  burn-and-register model.
65  */
66 contract MirrorWriteToken is IMirrorWriteToken {
67     using SafeMath for uint256;
68 
69     // ============ Immutable ERC20 Attributes ============
70 
71     string public constant override symbol = "WRITE";
72     string public constant override name = "Mirror Write Token";
73     uint8 public constant override decimals = 18;
74 
75     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
76     bytes32 public constant PERMIT_TYPEHASH =
77         0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
78     bytes32 public immutable override DOMAIN_SEPARATOR;
79 
80     // ============ Immutable Registration Configuration ============
81 
82     uint256 internal constant REGISTRATION_COST = 1e18;
83 
84     // ============ Mutable Ownership Configuration ============
85 
86     address private _owner;
87     /**
88      * @dev Allows for two-step ownership transfer, whereby the next owner
89      * needs to accept the ownership transfer explicitly.
90      */
91     address private _nextOwner;
92 
93     // ============ Mutable Registration Configuration ============
94 
95     bool public registrable = true;
96     address public ensRegistrar;
97 
98     // ============ Mutable ERC20 Attributes ============
99 
100     uint256 public override totalSupply;
101     mapping(address => uint256) public override balanceOf;
102     mapping(address => mapping(address => uint256)) public override allowance;
103     mapping(address => uint256) public override nonces;
104 
105     // ============ Events ============
106 
107     event Registered(string label, address owner);
108     event Mint(address indexed to, uint256 amount);
109     event Approval(
110         address indexed owner,
111         address indexed spender,
112         uint256 value
113     );
114     event Transfer(address indexed from, address indexed to, uint256 value);
115     event OwnershipTransferred(
116         address indexed previousOwner,
117         address indexed newOwner
118     );
119 
120     // ============ Modifiers ============
121 
122     modifier canRegister() {
123         require(registrable, "MirrorWriteToken: registration is closed.");
124         _;
125     }
126 
127     modifier onlyOwner() {
128         require(isOwner(), "MirrorWriteToken: caller is not the owner.");
129         _;
130     }
131 
132     modifier onlyNextOwner() {
133         require(
134             isNextOwner(),
135             "MirrorWriteToken: current owner must set caller as next owner."
136         );
137         _;
138     }
139 
140     // ============ Constructor ============
141 
142     constructor() public {
143         uint256 chainId = _getChainId();
144 
145         DOMAIN_SEPARATOR = keccak256(
146             abi.encode(
147                 keccak256(
148                     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
149                 ),
150                 keccak256(bytes(name)),
151                 keccak256(bytes("1")),
152                 chainId,
153                 address(this)
154             )
155         );
156 
157         _owner = tx.origin;
158         emit OwnershipTransferred(address(0), _owner);
159     }
160 
161     // ============ Minting ============
162 
163     /**
164      * @dev Function to mint tokens
165      * @param to The address that will receive the minted tokens.
166      * @param amount The amount of tokens to mint.
167      */
168     function mint(address to, uint256 amount) external onlyOwner {
169         _mint(to, amount);
170 
171         emit Mint(to, amount);
172     }
173 
174     // ============ Registration ============
175 
176     /**
177      * @dev Returns the cost of registration in tokens with full decimals.
178      */
179     function registrationCost() external view override returns (uint256) {
180         return REGISTRATION_COST;
181     }
182 
183     /**
184      * Burns the sender's invite tokens and registers an ENS given label to a given address.
185      * @param label The user's ENS label, e.g. "dev" for dev.mirror.xyz.
186      * @param owner The address that should own the label.
187      */
188     function register(string calldata label, address owner)
189         external
190         override
191         canRegister
192     {
193         _burn(msg.sender, REGISTRATION_COST);
194 
195         emit Registered(label, owner);
196 
197         IMirrorENSRegistrar(ensRegistrar).register(label, owner);
198     }
199 
200     // ============ Ownership ============
201 
202     /**
203      * @dev Returns true if the caller is the current owner.
204      */
205     function isOwner() public view returns (bool) {
206         return msg.sender == _owner;
207     }
208 
209     /**
210      * @dev Returns true if the caller is the next owner.
211      */
212     function isNextOwner() public view returns (bool) {
213         return msg.sender == _nextOwner;
214     }
215 
216     /**
217      * @dev Allows a new account (`newOwner`) to accept ownership.
218      * Can only be called by the current owner.
219      */
220     function transferOwnership(address nextOwner_) external onlyOwner {
221         require(
222             nextOwner_ != address(0),
223             "MirrorWriteToken: next owner is the zero address."
224         );
225 
226         _nextOwner = nextOwner_;
227     }
228 
229     /**
230      * @dev Cancel a transfer of ownership to a new account.
231      * Can only be called by the current owner.
232      */
233     function cancelOwnershipTransfer() external onlyOwner {
234         delete _nextOwner;
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to the caller.
239      * Can only be called by a new potential owner set by the current owner.
240      */
241     function acceptOwnership() external onlyNextOwner {
242         delete _nextOwner;
243 
244         emit OwnershipTransferred(_owner, msg.sender);
245 
246         _owner = msg.sender;
247     }
248 
249     /**
250      * @dev Leaves the contract without owner. It will not be possible to call
251      * `onlyOwner` functions anymore. Can only be called by the current owner.
252      *
253      * NOTE: Renouncing ownership will leave the contract without an owner,
254      * thereby removing any functionality that is only available to the owner.
255      */
256     function renounceOwnership() external onlyOwner {
257         emit OwnershipTransferred(_owner, address(0));
258         _owner = address(0);
259     }
260 
261     // ============ Configuration Management ============
262 
263     /**
264      * Allows the owner to change the ENS Registrar address.
265      */
266     function setENSRegistrar(address ensRegistrar_) external onlyOwner {
267         ensRegistrar = ensRegistrar_;
268     }
269 
270     /**
271      * Allows the owner to pause registration.
272      */
273     function setRegistrable(bool registrable_) external onlyOwner {
274         registrable = registrable_;
275     }
276 
277     // ============ ERC20 Spec ============
278 
279     function _mint(address to, uint256 value) internal {
280         totalSupply = totalSupply.add(value);
281         balanceOf[to] = balanceOf[to].add(value);
282         emit Transfer(address(0), to, value);
283     }
284 
285     function _burn(address from, uint256 value) internal {
286         balanceOf[from] = balanceOf[from].sub(value);
287         totalSupply = totalSupply.sub(value);
288         emit Transfer(from, address(0), value);
289     }
290 
291     function _approve(
292         address owner,
293         address spender,
294         uint256 value
295     ) private {
296         allowance[owner][spender] = value;
297         emit Approval(owner, spender, value);
298     }
299 
300     function _transfer(
301         address from,
302         address to,
303         uint256 value
304     ) private {
305         balanceOf[from] = balanceOf[from].sub(value);
306         balanceOf[to] = balanceOf[to].add(value);
307         emit Transfer(from, to, value);
308     }
309 
310     function approve(address spender, uint256 value)
311         external
312         override
313         returns (bool)
314     {
315         _approve(msg.sender, spender, value);
316         return true;
317     }
318 
319     function transfer(address to, uint256 value)
320         external
321         override
322         returns (bool)
323     {
324         _transfer(msg.sender, to, value);
325         return true;
326     }
327 
328     function transferFrom(
329         address from,
330         address to,
331         uint256 value
332     ) external override returns (bool) {
333         if (allowance[from][msg.sender] != uint256(-1)) {
334             allowance[from][msg.sender] = allowance[from][msg.sender].sub(
335                 value
336             );
337         }
338         _transfer(from, to, value);
339         return true;
340     }
341 
342     function permit(
343         address owner,
344         address spender,
345         uint256 value,
346         uint256 deadline,
347         uint8 v,
348         bytes32 r,
349         bytes32 s
350     ) external override {
351         require(deadline >= block.timestamp, "MirrorWriteToken: EXPIRED");
352         bytes32 digest =
353             keccak256(
354                 abi.encodePacked(
355                     "\x19\x01",
356                     DOMAIN_SEPARATOR,
357                     keccak256(
358                         abi.encode(
359                             PERMIT_TYPEHASH,
360                             owner,
361                             spender,
362                             value,
363                             nonces[owner]++,
364                             deadline
365                         )
366                     )
367                 )
368             );
369         address recoveredAddress = ecrecover(digest, v, r, s);
370         require(
371             recoveredAddress != address(0) && recoveredAddress == owner,
372             "MirrorWriteToken: INVALID_SIGNATURE"
373         );
374         _approve(owner, spender, value);
375     }
376 
377     function _getChainId() private pure returns (uint256 chainId) {
378         assembly {
379             chainId := chainid()
380         }
381     }
382 }
383 
384 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
385 
386 library SafeMath {
387     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
388         require((z = x + y) >= x, "ds-math-add-overflow");
389     }
390 
391     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
392         require((z = x - y) <= x, "ds-math-sub-underflow");
393     }
394 
395     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
396         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
397     }
398 }
399 
400 interface IENSReverseRegistrar {
401     function claim(address _owner) external returns (bytes32);
402 
403     function claimWithResolver(address _owner, address _resolver)
404         external
405         returns (bytes32);
406 
407     function setName(string calldata _name) external returns (bytes32);
408 
409     function node(address _addr) external pure returns (bytes32);
410 }
411 
412 interface IMirrorENSRegistrar {
413     function changeRootNodeOwner(address newOwner_) external;
414 
415     function register(string calldata label_, address owner_) external;
416 
417     function updateENSReverseRegistrar() external;
418 }