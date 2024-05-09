1 // SPDX-License-Identifier: MIT
2 
3 
4 //   .d8888b.                    888 888 
5 //  d88P  Y88b                   888 888 
6 //  Y88b.                        888 888 
7 //   "Y888b.   88888b.   .d88b.  888 888 
8 //      "Y88b. 888 "88b d8P  Y8b 888 888 
9 //        "888 888  888 88888888 888 888 
10 //  Y88b  d88P 888 d88P Y8b.     888 888 
11 //   "Y8888P"  88888P"   "Y8888  888 888 
12 //             888                       
13 //             888                       
14 //             888                       
15 
16 // Special thanks to:
17 // @BoringCrypto for his great libraries @ https://github.com/boringcrypto/BoringSolidity
18 
19 pragma solidity 0.6.12;
20 
21 // Contract: BoringOwnable
22 // Audit on 5-Jan-2021 by Keno and BoringCrypto
23 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
24 // Edited by BoringCrypto
25 
26 contract BoringOwnableData {
27     address public owner;
28     address public pendingOwner;
29 }
30 
31 contract BoringOwnable is BoringOwnableData {
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /// @notice `owner` defaults to msg.sender on construction.
35     constructor() public {
36         owner = msg.sender;
37         emit OwnershipTransferred(address(0), msg.sender);
38     }
39 
40     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
41     /// Can only be invoked by the current `owner`.
42     /// @param newOwner Address of the new owner.
43     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
44     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
45     function transferOwnership(
46         address newOwner,
47         bool direct,
48         bool renounce
49     ) public onlyOwner {
50         if (direct) {
51             // Checks
52             require(newOwner != address(0) || renounce, "Ownable: zero address");
53 
54             // Effects
55             emit OwnershipTransferred(owner, newOwner);
56             owner = newOwner;
57             pendingOwner = address(0);
58         } else {
59             // Effects
60             pendingOwner = newOwner;
61         }
62     }
63 
64     /// @notice Needs to be called by `pendingOwner` to claim ownership.
65     function claimOwnership() public {
66         address _pendingOwner = pendingOwner;
67 
68         // Checks
69         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
70 
71         // Effects
72         emit OwnershipTransferred(owner, _pendingOwner);
73         owner = _pendingOwner;
74         pendingOwner = address(0);
75     }
76 
77     /// @notice Only allows the `owner` to execute the function.
78     modifier onlyOwner() {
79         require(msg.sender == owner, "Ownable: caller is not the owner");
80         _;
81     }
82 }
83 
84 contract Domain {
85     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
86     // See https://eips.ethereum.org/EIPS/eip-191
87     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
88 
89     // solhint-disable var-name-mixedcase
90     bytes32 private immutable _DOMAIN_SEPARATOR;
91     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;    
92 
93     /// @dev Calculate the DOMAIN_SEPARATOR
94     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
95         return keccak256(
96             abi.encode(
97                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
98                 chainId,
99                 address(this)
100             )
101         );
102     }
103 
104     constructor() public {
105         uint256 chainId; assembly {chainId := chainid()}
106         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
107     }
108 
109     /// @dev Return the DOMAIN_SEPARATOR
110     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
111     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
112     // solhint-disable-next-line func-name-mixedcase
113     function _domainSeparator() internal view returns (bytes32) {
114         uint256 chainId; assembly {chainId := chainid()}
115         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
116     }
117 
118     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
119         digest =
120             keccak256(
121                 abi.encodePacked(
122                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
123                     _domainSeparator(),
124                     dataHash
125                 )
126             );
127     }
128 }
129 
130 interface IERC20 {
131     function totalSupply() external view returns (uint256);
132 
133     function balanceOf(address account) external view returns (uint256);
134 
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140     event Approval(address indexed owner, address indexed spender, uint256 value);
141 
142     /// @notice EIP 2612
143     function permit(
144         address owner,
145         address spender,
146         uint256 value,
147         uint256 deadline,
148         uint8 v,
149         bytes32 r,
150         bytes32 s
151     ) external;
152 }
153 
154 // Data part taken out for building of contracts that receive delegate calls
155 contract ERC20Data {
156     /// @notice owner > balance mapping.
157     mapping(address => uint256) public balanceOf;
158     /// @notice owner > spender > allowance mapping.
159     mapping(address => mapping(address => uint256)) public allowance;
160     /// @notice owner > nonce mapping. Used in `permit`.
161     mapping(address => uint256) public nonces;
162 }
163 
164 abstract contract ERC20 is IERC20, Domain {
165     /// @notice owner > balance mapping.
166     mapping(address => uint256) public override balanceOf;
167     /// @notice owner > spender > allowance mapping.
168     mapping(address => mapping(address => uint256)) public override allowance;
169     /// @notice owner > nonce mapping. Used in `permit`.
170     mapping(address => uint256) public nonces;
171     
172     event Transfer(address indexed _from, address indexed _to, uint256 _value);
173     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
174 
175     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
176     /// @param to The address to move the tokens.
177     /// @param amount of the tokens to move.
178     /// @return (bool) Returns True if succeeded.
179     function transfer(address to, uint256 amount) public returns (bool) {
180         // If `amount` is 0, or `msg.sender` is `to` nothing happens
181         if (amount != 0 || msg.sender == to) {
182             uint256 srcBalance = balanceOf[msg.sender];
183             require(srcBalance >= amount, "ERC20: balance too low");
184             if (msg.sender != to) {
185                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
186 
187                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
188                 balanceOf[to] += amount;
189             }
190         }
191         emit Transfer(msg.sender, to, amount);
192         return true;
193     }
194 
195     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
196     /// @param from Address to draw tokens from.
197     /// @param to The address to move the tokens.
198     /// @param amount The token amount to move.
199     /// @return (bool) Returns True if succeeded.
200     function transferFrom(
201         address from,
202         address to,
203         uint256 amount
204     ) public returns (bool) {
205         // If `amount` is 0, or `from` is `to` nothing happens
206         if (amount != 0) {
207             uint256 srcBalance = balanceOf[from];
208             require(srcBalance >= amount, "ERC20: balance too low");
209 
210             if (from != to) {
211                 uint256 spenderAllowance = allowance[from][msg.sender];
212                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
213                 if (spenderAllowance != type(uint256).max) {
214                     require(spenderAllowance >= amount, "ERC20: allowance too low");
215                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
216                 }
217                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
218 
219                 balanceOf[from] = srcBalance - amount; // Underflow is checked
220                 balanceOf[to] += amount;
221             }
222         }
223         emit Transfer(from, to, amount);
224         return true;
225     }
226 
227     /// @notice Approves `amount` from sender to be spend by `spender`.
228     /// @param spender Address of the party that can draw from msg.sender's account.
229     /// @param amount The maximum collective amount that `spender` can draw.
230     /// @return (bool) Returns True if approved.
231     function approve(address spender, uint256 amount) public override returns (bool) {
232         allowance[msg.sender][spender] = amount;
233         emit Approval(msg.sender, spender, amount);
234         return true;
235     }
236 
237     // solhint-disable-next-line func-name-mixedcase
238     function DOMAIN_SEPARATOR() external view returns (bytes32) {
239         return _domainSeparator();
240     }
241 
242     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
243     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
244 
245     /// @notice Approves `value` from `owner_` to be spend by `spender`.
246     /// @param owner_ Address of the owner.
247     /// @param spender The address of the spender that gets approved to draw from `owner_`.
248     /// @param value The maximum collective amount that `spender` can draw.
249     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
250     function permit(
251         address owner_,
252         address spender,
253         uint256 value,
254         uint256 deadline,
255         uint8 v,
256         bytes32 r,
257         bytes32 s
258     ) external override {
259         require(owner_ != address(0), "ERC20: Owner cannot be 0");
260         require(block.timestamp < deadline, "ERC20: Expired");
261         require(
262             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
263                 owner_,
264             "ERC20: Invalid Signature"
265         );
266         allowance[owner_][spender] = value;
267         emit Approval(owner_, spender, value);
268     }
269 }
270 
271 // Contract: BoringMath
272 /// @notice A library for performing overflow-/underflow-safe math,
273 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
274 library BoringMath {
275     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
276         require((c = a + b) >= b, "BoringMath: Add Overflow");
277     }
278 
279     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
280         require((c = a - b) <= a, "BoringMath: Underflow");
281     }
282 
283     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
284         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
285     }
286 }
287 
288 /// @title Spell
289 /// @author 0xMerlin
290 /// @dev This contract spreads Magic.
291 contract Spell is ERC20, BoringOwnable {
292     using BoringMath for uint256;
293     // ERC20 'variables'
294     string public constant symbol = "SPELL";
295     string public constant name = "Spell Token";
296     uint8 public constant decimals = 18;
297     uint256 public override totalSupply;
298     uint256 public constant MAX_SUPPLY = 420 * 1e27;
299 
300     function mint(address to, uint256 amount) public onlyOwner {
301         require(to != address(0), "SPELL: no mint to zero address");
302         require(MAX_SUPPLY >= totalSupply.add(amount), "SPELL: Don't go over MAX");
303 
304         totalSupply = totalSupply + amount;
305         balanceOf[to] += amount;
306         emit Transfer(address(0), to, amount);
307     }
308 }