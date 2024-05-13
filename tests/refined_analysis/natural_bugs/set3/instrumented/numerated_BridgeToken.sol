1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {BridgeMessage} from "./BridgeMessage.sol";
6 import {IBridgeToken} from "./interfaces/IBridgeToken.sol";
7 import {ERC20} from "./vendored/OZERC20.sol";
8 // ============ External Imports ============
9 import {Version0} from "@nomad-xyz/contracts-core/contracts/Version0.sol";
10 import {TypeCasts} from "@nomad-xyz/contracts-core/contracts/XAppConnectionManager.sol";
11 import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
12 
13 contract BridgeToken is Version0, IBridgeToken, OwnableUpgradeable, ERC20 {
14     // ============ Immutables ============
15 
16     // Immutables used in EIP 712 structured data hashing & signing
17     // https://eips.ethereum.org/EIPS/eip-712
18     bytes32 public immutable _PERMIT_TYPEHASH =
19         keccak256(
20             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
21         );
22     bytes32 private immutable _EIP712_STRUCTURED_DATA_VERSION =
23         keccak256(bytes("1"));
24     uint16 private immutable _EIP712_PREFIX_AND_VERSION = uint16(0x1901);
25 
26     // ============ Public Storage ============
27 
28     mapping(address => uint256) public nonces;
29     /// @dev hash commitment to the name/symbol/decimals
30     bytes32 public override detailsHash;
31 
32     // ============ Upgrade Gap ============
33 
34     uint256[48] private __GAP; // gap for upgrade safety
35 
36     // ============ Initializer ============
37 
38     function initialize() public override initializer {
39         __Ownable_init();
40     }
41 
42     // ============ Events ============
43 
44     event UpdateDetails(
45         string indexed name,
46         string indexed symbol,
47         uint8 indexed decimals
48     );
49 
50     // ============ External Functions ============
51 
52     /**
53      * @notice Destroys `_amnt` tokens from `_from`, reducing the
54      * total supply.
55      * @dev Emits a {Transfer} event with `to` set to the zero address.
56      * Requirements:
57      * - `_from` cannot be the zero address.
58      * - `_from` must have at least `_amnt` tokens.
59      * @param _from The address from which to destroy the tokens
60      * @param _amnt The amount of tokens to be destroyed
61      */
62     function burn(address _from, uint256 _amnt) external override onlyOwner {
63         _burn(_from, _amnt);
64     }
65 
66     /** @notice Creates `_amnt` tokens and assigns them to `_to`, increasing
67      * the total supply.
68      * @dev Emits a {Transfer} event with `from` set to the zero address.
69      * Requirements:
70      * - `to` cannot be the zero address.
71      * @param _to The destination address
72      * @param _amnt The amount of tokens to be minted
73      */
74     function mint(address _to, uint256 _amnt) external override onlyOwner {
75         _mint(_to, _amnt);
76     }
77 
78     /** @notice allows the owner to set the details hash commitment.
79      * @param _detailsHash the new details hash.
80      */
81     function setDetailsHash(bytes32 _detailsHash) external override onlyOwner {
82         if (detailsHash != _detailsHash) {
83             detailsHash = _detailsHash;
84         }
85     }
86 
87     /**
88      * @notice Set the details of a token
89      * @param _newName The new name
90      * @param _newSymbol The new symbol
91      * @param _newDecimals The new decimals
92      */
93     function setDetails(
94         string calldata _newName,
95         string calldata _newSymbol,
96         uint8 _newDecimals
97     ) external override {
98         bool _isFirstDetails = bytes(token.name).length == 0 &&
99             bytes(token.symbol).length == 0 &&
100             token.decimals == 0;
101         // 0 case is the initial deploy. We allow the deploying registry to set
102         // these once. After the first transfer is made, detailsHash will be
103         // set, allowing anyone to supply correct name/symbols/decimals
104         require(
105             _isFirstDetails ||
106                 BridgeMessage.getDetailsHash(
107                     _newName,
108                     _newSymbol,
109                     _newDecimals
110                 ) ==
111                 detailsHash,
112             "!committed details"
113         );
114         // careful with naming convention change here
115         token.name = _newName;
116         token.symbol = _newSymbol;
117         token.decimals = _newDecimals;
118         if (!_isFirstDetails) {
119             emit UpdateDetails(_newName, _newSymbol, _newDecimals);
120         }
121     }
122 
123     /**
124      * @notice Sets approval from owner to spender to value
125      * as long as deadline has not passed
126      * by submitting a valid signature from owner
127      * Uses EIP 712 structured data hashing & signing
128      * https://eips.ethereum.org/EIPS/eip-712
129      * @param _owner The account setting approval & signing the message
130      * @param _spender The account receiving approval to spend owner's tokens
131      * @param _value The amount to set approval for
132      * @param _deadline The timestamp before which the signature must be submitted
133      * @param _v ECDSA signature v
134      * @param _r ECDSA signature r
135      * @param _s ECDSA signature s
136      */
137     function permit(
138         address _owner,
139         address _spender,
140         uint256 _value,
141         uint256 _deadline,
142         uint8 _v,
143         bytes32 _r,
144         bytes32 _s
145     ) external {
146         require(block.timestamp <= _deadline, "ERC20Permit: expired deadline");
147         require(_owner != address(0), "ERC20Permit: owner zero address");
148         uint256 _nonce = nonces[_owner];
149         bytes32 _hashStruct = keccak256(
150             abi.encode(
151                 _PERMIT_TYPEHASH,
152                 _owner,
153                 _spender,
154                 _value,
155                 _nonce,
156                 _deadline
157             )
158         );
159         bytes32 _digest = keccak256(
160             abi.encodePacked(
161                 _EIP712_PREFIX_AND_VERSION,
162                 domainSeparator(),
163                 _hashStruct
164             )
165         );
166         address _signer = ecrecover(_digest, _v, _r, _s);
167         require(_signer == _owner, "ERC20Permit: invalid signature");
168         nonces[_owner] = _nonce + 1;
169         _approve(_owner, _spender, _value);
170     }
171 
172     // ============ Public Functions ============
173 
174     /**
175      * @dev silence the compiler being dumb
176      */
177     function balanceOf(address _account)
178         public
179         view
180         override(IBridgeToken, ERC20)
181         returns (uint256)
182     {
183         return ERC20.balanceOf(_account);
184     }
185 
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() public view override returns (string memory) {
190         return token.name;
191     }
192 
193     /**
194      * @dev Returns the symbol of the token, usually a shorter version of the
195      * name.
196      */
197     function symbol() public view override returns (string memory) {
198         return token.symbol;
199     }
200 
201     /**
202      * @dev Returns the number of decimals used to get its user representation.
203      * For example, if `decimals` equals `2`, a balance of `505` tokens should
204      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
205      * Tokens usually opt for a value of 18, imitating the relationship between
206      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
207      * called.
208      * NOTE: This information is only used for _display_ purposes: it in
209      * no way affects any of the arithmetic of the contract, including
210      * {IERC20-balanceOf} and {IERC20-transfer}.
211      */
212     function decimals() public view override returns (uint8) {
213         return token.decimals;
214     }
215 
216     /**
217      * @dev This is ALWAYS calculated at runtime
218      * because the token name may change
219      */
220     function domainSeparator() public view returns (bytes32) {
221         uint256 _chainId;
222         assembly {
223             _chainId := chainid()
224         }
225         return
226             keccak256(
227                 abi.encode(
228                     keccak256(
229                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
230                     ),
231                     keccak256(bytes(token.name)),
232                     _EIP712_STRUCTURED_DATA_VERSION,
233                     _chainId,
234                     address(this)
235                 )
236             );
237     }
238 
239     // required for solidity inheritance
240     function transferOwnership(address _newOwner)
241         public
242         override(IBridgeToken, OwnableUpgradeable)
243         onlyOwner
244     {
245         OwnableUpgradeable.transferOwnership(_newOwner);
246     }
247 
248     /**
249      * @dev should be impossible to renounce ownership;
250      * we override OpenZeppelin OwnableUpgradeable's
251      * implementation of renounceOwnership to make it a no-op
252      */
253     function renounceOwnership() public override onlyOwner {
254         // do nothing
255     }
256 }
