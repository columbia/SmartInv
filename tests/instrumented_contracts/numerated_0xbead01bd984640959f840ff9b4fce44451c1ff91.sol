1 pragma solidity ^0.4.24;
2 
3 interface ERC721 /* is ERC165 */ {
4     /// @dev This emits when ownership of any NFT changes by any mechanism.
5     ///  This event emits when NFTs are created (`from` == 0) and destroyed
6     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
7     ///  may be created and assigned without emitting Transfer. At the time of
8     ///  any transfer, the approved address for that NFT (if any) is reset to none.
9     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
10 
11     /// @dev This emits when the approved address for an NFT is changed or
12     ///  reaffirmed. The zero address indicates there is no approved address.
13     ///  When a Transfer event emits, this also indicates that the approved
14     ///  address for that NFT (if any) is reset to none.
15     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
16 
17     /// @dev This emits when an operator is enabled or disabled for an owner.
18     ///  The operator can manage all NFTs of the owner.
19     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
20 
21     /// @notice Count all NFTs assigned to an owner
22     /// @dev NFTs assigned to the zero address are considered invalid, and this
23     ///  function throws for queries about the zero address.
24     /// @param _owner An address for whom to query the balance
25     /// @return The number of NFTs owned by `_owner`, possibly zero
26     function balanceOf(address _owner) external view returns (uint256);
27 
28     /// @notice Find the owner of an NFT
29     /// @dev NFTs assigned to zero address are considered invalid, and queries
30     ///  about them do throw.
31     /// @param _tokenId The identifier for an NFT
32     /// @return The address of the owner of the NFT
33     function ownerOf(uint256 _tokenId) external view returns (address);
34 
35     /// @notice Transfers the ownership of an NFT from one address to another address
36     /// @dev Throws unless `msg.sender` is the current owner, an authorized
37     ///  operator, or the approved address for this NFT. Throws if `_from` is
38     ///  not the current owner. Throws if `_to` is the zero address. Throws if
39     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
40     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
41     ///  `onERC721Received` on `_to` and throws if the return value is not
42     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
43     /// @param _from The current owner of the NFT
44     /// @param _to The new owner
45     /// @param _tokenId The NFT to transfer
46     /// @param data Additional data with no specified format, sent in call to `_to`
47     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
48 
49     /// @notice Transfers the ownership of an NFT from one address to another address
50     /// @dev This works identically to the other function with an extra data parameter,
51     ///  except this function just sets data to "".
52     /// @param _from The current owner of the NFT
53     /// @param _to The new owner
54     /// @param _tokenId The NFT to transfer
55     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
56 
57     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
58     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
59     ///  THEY MAY BE PERMANENTLY LOST
60     /// @dev Throws unless `msg.sender` is the current owner, an authorized
61     ///  operator, or the approved address for this NFT. Throws if `_from` is
62     ///  not the current owner. Throws if `_to` is the zero address. Throws if
63     ///  `_tokenId` is not a valid NFT.
64     /// @param _from The current owner of the NFT
65     /// @param _to The new owner
66     /// @param _tokenId The NFT to transfer
67     function transferFrom(address _from, address _to, uint256 _tokenId) external;
68 
69     /// @notice Change or reaffirm the approved address for an NFT
70     /// @dev The zero address indicates there is no approved address.
71     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
72     ///  operator of the current owner.
73     /// @param _approved The new approved NFT controller
74     /// @param _tokenId The NFT to approve
75     function approve(address _approved, uint256 _tokenId) external;
76 
77     /// @notice Enable or disable approval for a third party ("operator") to manage
78     ///  all of `msg.sender`'s assets
79     /// @dev Emits the ApprovalForAll event. The contract MUST allow
80     ///  multiple operators per owner.
81     /// @param _operator Address to add to the set of authorized operators
82     /// @param _approved True if the operator is approved, false to revoke approval
83     function setApprovalForAll(address _operator, bool _approved) external;
84 
85     /// @notice Get the approved address for a single NFT
86     /// @dev Throws if `_tokenId` is not a valid NFT.
87     /// @param _tokenId The NFT to find the approved address for
88     /// @return The approved address for this NFT, or the zero address if there is none
89     function getApproved(uint256 _tokenId) external view returns (address);
90 
91     /// @notice Query if an address is an authorized operator for another address
92     /// @param _owner The address that owns the NFTs
93     /// @param _operator The address that acts on behalf of the owner
94     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
95     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
96 }
97 
98 interface AvatarService {
99   function updateAvatarInfo(address _owner, uint256 _tokenId, string _name, uint256 _dna) external;
100   function createAvatar(address _owner, string _name, uint256 _dna) external  returns(uint256);
101   function getMountTokenIds(address _owner,uint256 _tokenId, address _avatarItemAddress) external view returns(uint256[]); 
102   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna);
103   function getOwnedTokenIds(address _owner) external view returns(uint256[] _tokenIds);
104 }
105 
106 
107 /**
108  * @title BitGuildAccessAdmin
109  * @dev Allow two roles: 'owner' or 'operator'
110  *      - owner: admin/superuser (e.g. with financial rights)
111  *      - operator: can update configurations
112  */
113 contract BitGuildAccessAdmin {
114   address public owner;
115   address[] public operators;
116 
117   uint public MAX_OPS = 20; // Default maximum number of operators allowed
118 
119   mapping(address => bool) public isOperator;
120 
121   event OwnershipTransferred(
122       address indexed previousOwner,
123       address indexed newOwner
124   );
125   event OperatorAdded(address operator);
126   event OperatorRemoved(address operator);
127 
128   // @dev The BitGuildAccessAdmin constructor: sets owner to the sender account
129   constructor() public {
130     owner = msg.sender;
131   }
132 
133   // @dev Throws if called by any account other than the owner.
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139   // @dev Throws if called by any non-operator account. Owner has all ops rights.
140   modifier onlyOperator {
141     require(
142       isOperator[msg.sender] || msg.sender == owner,
143       "Permission denied. Must be an operator or the owner.");
144     _;
145   }
146 
147   /**
148     * @dev Allows the current owner to transfer control of the contract to a newOwner.
149     * @param _newOwner The address to transfer ownership to.
150     */
151   function transferOwnership(address _newOwner) public onlyOwner {
152     require(
153       _newOwner != address(0),
154       "Invalid new owner address."
155     );
156     emit OwnershipTransferred(owner, _newOwner);
157     owner = _newOwner;
158   }
159 
160   /**
161     * @dev Allows the current owner or operators to add operators
162     * @param _newOperator New operator address
163     */
164   function addOperator(address _newOperator) public onlyOwner {
165     require(
166       _newOperator != address(0),
167       "Invalid new operator address."
168     );
169 
170     // Make sure no dups
171     require(
172       !isOperator[_newOperator],
173       "New operator exists."
174     );
175 
176     // Only allow so many ops
177     require(
178       operators.length < MAX_OPS,
179       "Overflow."
180     );
181 
182     operators.push(_newOperator);
183     isOperator[_newOperator] = true;
184 
185     emit OperatorAdded(_newOperator);
186   }
187 
188   /**
189     * @dev Allows the current owner or operators to remove operator
190     * @param _operator Address of the operator to be removed
191     */
192   function removeOperator(address _operator) public onlyOwner {
193     // Make sure operators array is not empty
194     require(
195       operators.length > 0,
196       "No operator."
197     );
198 
199     // Make sure the operator exists
200     require(
201       isOperator[_operator],
202       "Not an operator."
203     );
204 
205     // Manual array manipulation:
206     // - replace the _operator with last operator in array
207     // - remove the last item from array
208     address lastOperator = operators[operators.length - 1];
209     for (uint i = 0; i < operators.length; i++) {
210       if (operators[i] == _operator) {
211         operators[i] = lastOperator;
212       }
213     }
214     operators.length -= 1; // remove the last element
215 
216     isOperator[_operator] = false;
217     emit OperatorRemoved(_operator);
218   }
219 
220   // @dev Remove ALL operators
221   function removeAllOps() public onlyOwner {
222     for (uint i = 0; i < operators.length; i++) {
223       isOperator[operators[i]] = false;
224     }
225     operators.length = 0;
226   } 
227 
228 }
229 
230 contract AvatarOperator is BitGuildAccessAdmin {
231 
232   // every user can own avatar count
233   uint8 public PER_USER_MAX_AVATAR_COUNT = 1;
234 
235   event AvatarCreateSuccess(address indexed _owner, uint256 tokenId);
236 
237   AvatarService internal avatarService;
238   address internal avatarAddress;
239 
240   modifier nameValid(string _name){
241     bytes memory nameBytes = bytes(_name);
242     require(nameBytes.length > 0);
243     require(nameBytes.length < 16);
244     for(uint8 i = 0; i < nameBytes.length; ++i) {
245       uint8 asc = uint8(nameBytes[i]);
246       require (
247         asc == 95 || (asc >= 48 && asc <= 57) || (asc >= 65 && asc <= 90) || (asc >= 97 && asc <= 122), "Invalid name"); 
248     }
249     _;
250   }
251 
252   function setMaxAvatarNumber(uint8 _maxNumber) external onlyOwner {
253     PER_USER_MAX_AVATAR_COUNT = _maxNumber;
254   }
255 
256   function injectAvatarService(address _addr) external onlyOwner {
257     avatarService = AvatarService(_addr);
258     avatarAddress = _addr;
259   }
260   
261   function updateAvatarInfo(uint256 _tokenId, string _name, uint256 _dna) external nameValid(_name){
262     avatarService.updateAvatarInfo(msg.sender, _tokenId, _name, _dna);
263   }
264 
265   function createAvatar(string _name, uint256 _dna) external nameValid(_name) returns (uint256 _tokenId){
266     require(ERC721(avatarAddress).balanceOf(msg.sender) < PER_USER_MAX_AVATAR_COUNT);
267     _tokenId = avatarService.createAvatar(msg.sender, _name, _dna);
268     emit AvatarCreateSuccess(msg.sender, _tokenId);
269   }
270 
271   function getMountTokenIds(uint256 _tokenId, address _avatarItemAddress) external view returns(uint256[]){
272     return avatarService.getMountTokenIds(msg.sender, _tokenId, _avatarItemAddress);
273   }
274 
275   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna) {
276     return avatarService.getAvatarInfo(_tokenId);
277   }
278 
279   function getOwnedTokenIds() external view returns(uint256[] _tokenIds) {
280     return avatarService.getOwnedTokenIds(msg.sender);
281   }
282   
283 }