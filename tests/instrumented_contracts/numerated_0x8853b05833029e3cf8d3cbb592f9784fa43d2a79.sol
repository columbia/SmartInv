1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC165/ERC165.sol
4 
5 /**
6  * @dev A standard for detecting smart contract interfaces.
7  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
8  */
9 contract ERC165 {
10 
11   // bytes4(keccak256('supportsInterface(bytes4)'));
12   bytes4 constant INTERFACE_ERC165 = 0x01ffc9a7;
13 
14   /**
15    * @dev Checks if the smart contract includes a specific interface.
16    * @param _interfaceID The interface identifier, as specified in ERC-165.
17    */
18   function supportsInterface(bytes4 _interfaceID) public pure returns (bool) {
19     return _interfaceID == INTERFACE_ERC165;
20   }
21 }
22 
23 // File: contracts/ERC721/ERC721Basic.sol
24 
25 /**
26  * @title ERC721 Non-Fungible Token Standard basic interface
27  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
28  */
29 contract ERC721Basic {
30   // bytes4(keccak256('balanceOf(address)')) ^
31   // bytes4(keccak256('ownerOf(uint256)')) ^
32   // bytes4(keccak256('approve(address,uint256)')) ^
33   // bytes4(keccak256('getApproved(uint256)')) ^
34   // bytes4(keccak256('setApprovalForAll(address,bool)')) ^
35   // bytes4(keccak256('isApprovedForAll(address,address)')) ^
36   // bytes4(keccak256('transferFrom(address,address,uint256)')) ^
37   // bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
38   // bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'));
39   bytes4 constant INTERFACE_ERC721 = 0x80ac58cd;
40 
41   event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
42   event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
43   event ApprovalForAll(address indexed _owner, address indexed _operator, bool indexed _approved);
44 
45   function balanceOf(address _owner) public view returns (uint256 _balance);
46   function ownerOf(uint256 _tokenId) public view returns (address _owner);
47 
48   // Note: This is not in the official ERC-721 standard so it's not included in the interface hash
49   function exists(uint256 _tokenId) public view returns (bool _exists);
50 
51   function approve(address _to, uint256 _tokenId) public;
52   function getApproved(uint256 _tokenId) public view returns (address _operator);
53 
54   function setApprovalForAll(address _operator, bool _approved) public;
55   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
56 
57   function transferFrom(
58     address _from,
59     address _to,
60     uint256 _tokenId) public;
61 
62   function safeTransferFrom(
63     address _from,
64     address _to,
65     uint256 _tokenId) public;
66 
67   function safeTransferFrom(
68     address _from,
69     address _to,
70     uint256 _tokenId,
71     bytes _data) public;
72 }
73 
74 // File: contracts/ERC721/ERC721.sol
75 
76 /**
77  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
78  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
79  */
80 contract ERC721Enumerable is ERC721Basic {
81   // bytes4(keccak256('totalSupply()')) ^
82   // bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
83   // bytes4(keccak256('tokenByIndex(uint256)'));
84   bytes4 constant INTERFACE_ERC721_ENUMERABLE = 0x780e9d63;
85 
86   function totalSupply() public view returns (uint256);
87   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
88   function tokenByIndex(uint256 _index) public view returns (uint256);
89 }
90 
91 
92 /**
93  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
94  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
95  */
96 contract ERC721Metadata is ERC721Basic {
97   // bytes4(keccak256('name()')) ^
98   // bytes4(keccak256('symbol()')) ^
99   // bytes4(keccak256('tokenURI(uint256)'));
100   bytes4 constant INTERFACE_ERC721_METADATA = 0x5b5e139f;
101 
102   function name() public view returns (string _name);
103   function symbol() public view returns (string _symbol);
104   function tokenURI(uint256 _tokenId) public view returns (string);
105 }
106 
107 
108 /**
109  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
110  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
111  */
112 /* solium-disable-next-line no-empty-blocks */
113 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
114 }
115 
116 // File: contracts/library/ProxyOwnable.sol
117 
118 /**
119  * @title ProxyOwnable
120  * @dev Essentially the Ownable contract, renamed for the purposes of separating it from the
121  *  DelayedOwnable contract (the owner of the token contract).
122  */
123 contract ProxyOwnable {
124   address public proxyOwner;
125 
126   event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128   /**
129    * @dev The Ownable constructor sets the original `proxyOwner` of the contract to the sender
130    * account.
131    */
132   constructor() public {
133     proxyOwner = msg.sender;
134   }
135 
136   /**
137    * @dev Throws if called by any account other than the owner.
138    */
139   modifier onlyOwner() {
140     require(msg.sender == proxyOwner);
141     _;
142   }
143 
144   /**
145    * @dev Allows the current owner to transfer control of the contract to a newOwner.
146    * @param _newOwner The address to transfer ownership to.
147    */
148   function transferProxyOwnership(address _newOwner) public onlyOwner {
149     require(_newOwner != address(0));
150 
151     emit ProxyOwnershipTransferred(proxyOwner, _newOwner);
152 
153     proxyOwner = _newOwner;
154   }
155 }
156 
157 // File: contracts/CodexRecordProxy.sol
158 
159 /**
160  * @title CodexRecordProxy, a proxy contract for token storage
161  * @dev This allows the token owner to optionally upgrade the token in the future
162  *  if there are changes needed in the business logic. See the upgradeTo function
163  *  for caveats.
164  * Based on MIT licensed code from
165  *  https://github.com/zeppelinos/labs/tree/master/upgradeability_using_inherited_storage
166  */
167 contract CodexRecordProxy is ProxyOwnable {
168   event Upgraded(string version, address indexed implementation);
169 
170   string public version;
171   address public implementation;
172 
173   constructor(address _implementation) public {
174     upgradeTo("1", _implementation);
175   }
176 
177   /**
178    * @dev Fallback function. Any transaction sent to this contract that doesn't match the
179    *  upgradeTo signature will fallback to this function, which in turn will use
180    *  DELEGATECALL to delegate the transaction data to the implementation.
181    */
182   function () payable public {
183     address _implementation = implementation;
184 
185     // solium-disable-next-line security/no-inline-assembly
186     assembly {
187       let ptr := mload(0x40)
188       calldatacopy(ptr, 0, calldatasize)
189       let result := delegatecall(gas, _implementation, ptr, calldatasize, 0, 0)
190       let size := returndatasize
191       returndatacopy(ptr, 0, size)
192 
193       switch result
194       case 0 { revert(ptr, size) }
195       default { return(ptr, size) }
196     }
197   }
198 
199   /**
200    * @dev Since name is passed into the ERC721 token constructor, it's not stored in the CodexRecordProxy
201    *  contract. Thus, we call into the contract directly to retrieve its value.
202    * @return string The name of the token
203    */
204   function name() external view returns (string) {
205     ERC721Metadata tokenMetadata = ERC721Metadata(implementation);
206 
207     return tokenMetadata.name();
208   }
209 
210   /**
211    * @dev Since symbol is passed into the ERC721 token constructor, it's not stored in the CodexRecordProxy
212    *  contract. Thus, we call into the contract directly to retrieve its value.
213    * @return string The symbol of token
214    */
215   function symbol() external view returns (string) {
216     ERC721Metadata tokenMetadata = ERC721Metadata(implementation);
217 
218     return tokenMetadata.symbol();
219   }
220 
221   /**
222    * @dev Upgrades the CodexRecordProxy to point at a new implementation. Only callable by the owner.
223    *  Only upgrade the token after extensive testing has been done. The storage is append only.
224    *  The new token must inherit from the previous token so the shape of the storage is maintained.
225    * @param _version The version of the token
226    * @param _implementation The address at which the implementation is available
227    */
228   function upgradeTo(string _version, address _implementation) public onlyOwner {
229     require(
230       keccak256(abi.encodePacked(_version)) != keccak256(abi.encodePacked(version)),
231       "The version cannot be the same");
232 
233     require(
234       _implementation != implementation,
235       "The implementation cannot be the same");
236 
237     require(
238       _implementation != address(0),
239       "The implementation cannot be the 0 address");
240 
241     version = _version;
242     implementation = _implementation;
243 
244     emit Upgraded(version, implementation);
245   }
246 }