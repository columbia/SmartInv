1 // SPDX-License-Identifier: WTFPL
2 pragma solidity >=0.8;
3 
4 /**
5      ██████╗ ██████╗ ███╗   ██╗ ██████╗ █████╗ ██╗   ██╗██████╗
6     ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║   ██║╚════██╗
7     ██║     ██║   ██║██╔██╗ ██║██║     ███████║██║   ██║ █████╔╝
8     ██║     ██║   ██║██║╚██╗██║██║     ██╔══██║╚██╗ ██╔╝ ╚═══██╗
9     ╚██████╗╚██████╔╝██║ ╚████║╚██████╗██║  ██║ ╚████╔╝ ██████╔╝
10      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝  ╚═══╝  ╚═════╝
11     Concave
12 */
13 
14 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
15 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
16 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
17 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
18 abstract contract ERC20 {
19     /*///////////////////////////////////////////////////////////////
20                                   EVENTS
21     //////////////////////////////////////////////////////////////*/
22 
23     event Transfer(address indexed from, address indexed to, uint256 amount);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 amount);
26 
27     /*///////////////////////////////////////////////////////////////
28                              METADATA STORAGE
29     //////////////////////////////////////////////////////////////*/
30 
31     string public name;
32 
33     string public symbol;
34 
35     uint8 public immutable decimals;
36 
37     /*///////////////////////////////////////////////////////////////
38                               ERC20 STORAGE
39     //////////////////////////////////////////////////////////////*/
40 
41     uint256 public totalSupply;
42 
43     mapping(address => uint256) public balanceOf;
44 
45     mapping(address => mapping(address => uint256)) public allowance;
46 
47     /*///////////////////////////////////////////////////////////////
48                              EIP-2612 STORAGE
49     //////////////////////////////////////////////////////////////*/
50 
51     bytes32 public constant PERMIT_TYPEHASH =
52         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
53 
54     uint256 internal immutable INITIAL_CHAIN_ID;
55 
56     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
57 
58     mapping(address => uint256) public nonces;
59 
60     /*///////////////////////////////////////////////////////////////
61                                CONSTRUCTOR
62     //////////////////////////////////////////////////////////////*/
63 
64     constructor(
65         string memory _name,
66         string memory _symbol,
67         uint8 _decimals
68     ) {
69         name = _name;
70         symbol = _symbol;
71         decimals = _decimals;
72 
73         INITIAL_CHAIN_ID = block.chainid;
74         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
75     }
76 
77     /*///////////////////////////////////////////////////////////////
78                               ERC20 LOGIC
79     //////////////////////////////////////////////////////////////*/
80 
81     function approve(address spender, uint256 amount) public virtual returns (bool) {
82         allowance[msg.sender][spender] = amount;
83 
84         emit Approval(msg.sender, spender, amount);
85 
86         return true;
87     }
88 
89     function transfer(address to, uint256 amount) public virtual returns (bool) {
90         balanceOf[msg.sender] -= amount;
91 
92         // Cannot overflow because the sum of all user
93         // balances can't exceed the max uint256 value.
94         unchecked {
95             balanceOf[to] += amount;
96         }
97 
98         emit Transfer(msg.sender, to, amount);
99 
100         return true;
101     }
102 
103     function transferFrom(
104         address from,
105         address to,
106         uint256 amount
107     ) public virtual returns (bool) {
108         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
109 
110         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
111 
112         balanceOf[from] -= amount;
113 
114         // Cannot overflow because the sum of all user
115         // balances can't exceed the max uint256 value.
116         unchecked {
117             balanceOf[to] += amount;
118         }
119 
120         emit Transfer(from, to, amount);
121 
122         return true;
123     }
124 
125     /*///////////////////////////////////////////////////////////////
126                               EIP-2612 LOGIC
127     //////////////////////////////////////////////////////////////*/
128 
129     function permit(
130         address owner,
131         address spender,
132         uint256 value,
133         uint256 deadline,
134         uint8 v,
135         bytes32 r,
136         bytes32 s
137     ) public virtual {
138         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
139 
140         // Unchecked because the only math done is incrementing
141         // the owner's nonce which cannot realistically overflow.
142         unchecked {
143             bytes32 digest = keccak256(
144                 abi.encodePacked(
145                     "\x19\x01",
146                     DOMAIN_SEPARATOR(),
147                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
148                 )
149             );
150 
151             address recoveredAddress = ecrecover(digest, v, r, s);
152 
153             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
154 
155             allowance[recoveredAddress][spender] = value;
156         }
157 
158         emit Approval(owner, spender, value);
159     }
160 
161     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
162         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
163     }
164 
165     function computeDomainSeparator() internal view virtual returns (bytes32) {
166         return
167             keccak256(
168                 abi.encode(
169                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
170                     keccak256(bytes(name)),
171                     keccak256("1"),
172                     block.chainid,
173                     address(this)
174                 )
175             );
176     }
177 
178     /*///////////////////////////////////////////////////////////////
179                        INTERNAL MINT/BURN LOGIC
180     //////////////////////////////////////////////////////////////*/
181 
182     function _mint(address to, uint256 amount) internal virtual {
183         totalSupply += amount;
184 
185         // Cannot overflow because the sum of all user
186         // balances can't exceed the max uint256 value.
187         unchecked {
188             balanceOf[to] += amount;
189         }
190 
191         emit Transfer(address(0), to, amount);
192     }
193 
194     function _burn(address from, uint256 amount) internal virtual {
195         balanceOf[from] -= amount;
196 
197         // Cannot underflow because a user's balance
198         // will never be larger than the total supply.
199         unchecked {
200             totalSupply -= amount;
201         }
202 
203         emit Transfer(from, address(0), amount);
204     }
205 }
206 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
207 
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
211 
212 
213 
214 /**
215  * @dev Provides information about the current execution context, including the
216  * sender of the transaction and its data. While these are generally available
217  * via msg.sender and msg.data, they should not be accessed in such a direct
218  * manner, since when dealing with meta-transactions the account sending and
219  * paying for execution may not be the actual sender (as far as an application
220  * is concerned).
221  *
222  * This contract is only required for intermediate, library-like contracts.
223  */
224 abstract contract Context {
225     function _msgSender() internal view virtual returns (address) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view virtual returns (bytes calldata) {
230         return msg.data;
231     }
232 }
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor() {
255         _transferOwnership(_msgSender());
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 contract ConcaveToken is Ownable, ERC20("Concave", "CNV", 18) {
305 
306     /* -------------------------------------------------------------------------- */
307     /*                                   EVENTS                                   */
308     /* -------------------------------------------------------------------------- */
309 
310     event MinterSet(address indexed caller, address indexed who, bool indexed canMint);
311 
312 
313     mapping(address => bool) public isMinter;
314 
315     address[] public minters;
316 
317     /* -------------------------------------------------------------------------- */
318     /*                              ACCESS CONTROLLED                             */
319     /* -------------------------------------------------------------------------- */
320 
321     function mint(
322         address account,
323         uint256 amount
324     ) external {
325 
326         require(isMinter[msg.sender], "!MINTER");
327 
328         _mint(account, amount);
329     }
330 
331     function burn(
332         address account,
333         uint256 amount
334     ) external {
335 
336         require(isMinter[msg.sender], "!MINTER");
337 
338         _burn(account, amount);
339     }
340 
341     function setMinter(
342         address who,
343         bool canMint
344     ) external onlyOwner {
345 
346         if (canMint == true && isMinter[who] == false ) minters.push(who);
347 
348         isMinter[who] = canMint;
349 
350         emit MinterSet(msg.sender, who, canMint);
351     }
352 
353     function mintersLength() external view returns(uint256) {
354         return minters.length;
355     }
356 }
357 
358 
359 /**
360     "someone spent a lot of computational power and time to bruteforce that contract address
361     so basically to have that many leading zeros
362     you can't just create a contract and get that, the odds are 1 in trillions to get something like that
363     there's a way to guess which contract address you will get, using a script.. and you have to bruteforce for a very long time to get that many leading 0's
364     fun fact, the more leading 0's a contract has, the cheaper gas will be for users to interact with the contract"
365         - some solidity dev
366     © 2022 WTFPL – Do What the Fuck You Want to Public License.
367 */