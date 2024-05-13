1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {IBridgeToken} from "../../interfaces/bridge/IBridgeToken.sol";
6 import {ERC20} from "./vendored/OZERC20.sol";
7 import {BridgeMessage} from "./BridgeMessage.sol";
8 // ============ External Imports ============
9 import {Version0} from "@nomad-xyz/nomad-core-sol/contracts/Version0.sol";
10 import {TypeCasts} from "@nomad-xyz/nomad-core-sol/contracts/XAppConnectionManager.sol";
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
98         bool _isFirstDetails = bytes(token.name).length == 0;
99         // 0 case is the initial deploy. We allow the deploying registry to set
100         // these once. After the first transfer is made, detailsHash will be
101         // set, allowing anyone to supply correct name/symbols/decimals
102         require(
103             _isFirstDetails ||
104                 BridgeMessage.getDetailsHash(
105                     _newName,
106                     _newSymbol,
107                     _newDecimals
108                 ) ==
109                 detailsHash,
110             "!committed details"
111         );
112         // careful with naming convention change here
113         token.name = _newName;
114         token.symbol = _newSymbol;
115         token.decimals = _newDecimals;
116         if (!_isFirstDetails) {
117             emit UpdateDetails(_newName, _newSymbol, _newDecimals);
118         }
119     }
120 
121     /**
122      * @notice Sets approval from owner to spender to value
123      * as long as deadline has not passed
124      * by submitting a valid signature from owner
125      * Uses EIP 712 structured data hashing & signing
126      * https://eips.ethereum.org/EIPS/eip-712
127      * @param _owner The account setting approval & signing the message
128      * @param _spender The account receiving approval to spend owner's tokens
129      * @param _value The amount to set approval for
130      * @param _deadline The timestamp before which the signature must be submitted
131      * @param _v ECDSA signature v
132      * @param _r ECDSA signature r
133      * @param _s ECDSA signature s
134      */
135     function permit(
136         address _owner,
137         address _spender,
138         uint256 _value,
139         uint256 _deadline,
140         uint8 _v,
141         bytes32 _r,
142         bytes32 _s
143     ) external {
144         require(block.timestamp <= _deadline, "ERC20Permit: expired deadline");
145         require(_owner != address(0), "ERC20Permit: owner zero address");
146         uint256 _nonce = nonces[_owner];
147         bytes32 _hashStruct = keccak256(
148             abi.encode(
149                 _PERMIT_TYPEHASH,
150                 _owner,
151                 _spender,
152                 _value,
153                 _nonce,
154                 _deadline
155             )
156         );
157         bytes32 _digest = keccak256(
158             abi.encodePacked(
159                 _EIP712_PREFIX_AND_VERSION,
160                 domainSeparator(),
161                 _hashStruct
162             )
163         );
164         address _signer = ecrecover(_digest, _v, _r, _s);
165         require(_signer == _owner, "ERC20Permit: invalid signature");
166         nonces[_owner] = _nonce + 1;
167         _approve(_owner, _spender, _value);
168     }
169 
170     // ============ Public Functions ============
171 
172     /**
173      * @dev silence the compiler being dumb
174      */
175     function balanceOf(address _account)
176         public
177         view
178         override(IBridgeToken, ERC20)
179         returns (uint256)
180     {
181         return ERC20.balanceOf(_account);
182     }
183 
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() public view override returns (string memory) {
188         return token.name;
189     }
190 
191     /**
192      * @dev Returns the symbol of the token, usually a shorter version of the
193      * name.
194      */
195     function symbol() public view override returns (string memory) {
196         return token.symbol;
197     }
198 
199     /**
200      * @dev Returns the number of decimals used to get its user representation.
201      * For example, if `decimals` equals `2`, a balance of `505` tokens should
202      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
205      * called.
206      * NOTE: This information is only used for _display_ purposes: it in
207      * no way affects any of the arithmetic of the contract, including
208      * {IERC20-balanceOf} and {IERC20-transfer}.
209      */
210     function decimals() public view override returns (uint8) {
211         return token.decimals;
212     }
213 
214     /**
215      * @dev This is ALWAYS calculated at runtime
216      * because the token name may change
217      */
218     function domainSeparator() public view returns (bytes32) {
219         uint256 _chainId;
220         assembly {
221             _chainId := chainid()
222         }
223         return
224             keccak256(
225                 abi.encode(
226                     keccak256(
227                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
228                     ),
229                     keccak256(bytes(token.name)),
230                     _EIP712_STRUCTURED_DATA_VERSION,
231                     _chainId,
232                     address(this)
233                 )
234             );
235     }
236 
237     // required for solidity inheritance
238     function transferOwnership(address _newOwner)
239         public
240         override(IBridgeToken, OwnableUpgradeable)
241         onlyOwner
242     {
243         OwnableUpgradeable.transferOwnership(_newOwner);
244     }
245 }
