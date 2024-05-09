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
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157   }
158 }
159 
160 interface AvatarService {
161   function updateAvatarInfo(address _owner, uint256 _tokenId, string _name, uint256 _dna) external;
162   function createAvatar(address _owner, string _name, uint256 _dna) external  returns(uint256);
163   function getMountedChildren(address _owner,uint256 _tokenId, address _childAddress) external view returns(uint256[]); 
164   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna);
165   function getOwnedAvatars(address _owner) external view returns(uint256[] _avatars);
166   function unmount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external;
167   function mount(address _owner, address _childContract, uint256[] _children, uint256 _avatarId) external;
168 }
169 
170 contract AvatarOperator is Ownable {
171 
172   // every user can own avatar count
173   uint8 public PER_USER_MAX_AVATAR_COUNT = 1;
174 
175   event AvatarCreate(address indexed _owner, uint256 tokenId);
176 
177   AvatarService internal avatarService;
178   address internal avatarAddress;
179 
180   modifier nameValid(string _name){
181     bytes memory nameBytes = bytes(_name);
182     require(nameBytes.length > 0);
183     require(nameBytes.length < 16);
184     for(uint8 i = 0; i < nameBytes.length; ++i) {
185       uint8 asc = uint8(nameBytes[i]);
186       require (
187         asc == 95 || (asc >= 48 && asc <= 57) || (asc >= 65 && asc <= 90) || (asc >= 97 && asc <= 122), "Invalid name"); 
188     }
189     _;
190   }
191 
192   function setMaxAvatarNumber(uint8 _maxNumber) external onlyOwner {
193     PER_USER_MAX_AVATAR_COUNT = _maxNumber;
194   }
195 
196   function injectAvatarService(address _addr) external onlyOwner {
197     avatarService = AvatarService(_addr);
198     avatarAddress = _addr;
199   }
200   
201   function updateAvatarInfo(uint256 _tokenId, string _name, uint256 _dna) external nameValid(_name){
202     avatarService.updateAvatarInfo(msg.sender, _tokenId, _name, _dna);
203   }
204 
205   function createAvatar(string _name, uint256 _dna) external nameValid(_name) returns (uint256 _tokenId){
206     require(ERC721(avatarAddress).balanceOf(msg.sender) < PER_USER_MAX_AVATAR_COUNT, "overflow");
207     _tokenId = avatarService.createAvatar(msg.sender, _name, _dna);
208     emit AvatarCreate(msg.sender, _tokenId);
209   }
210 
211   function getMountedChildren(uint256 _tokenId, address _avatarItemAddress) external view returns(uint256[]){
212     return avatarService.getMountedChildren(msg.sender, _tokenId, _avatarItemAddress);
213   }
214 
215   function getAvatarInfo(uint256 _tokenId) external view returns (string _name, uint256 _dna) {
216     return avatarService.getAvatarInfo(_tokenId);
217   }
218 
219   function getOwnedAvatars() external view returns(uint256[] _tokenIds) {
220     return avatarService.getOwnedAvatars(msg.sender);
221   }
222  
223   function handleChildren(
224 	address _childContract, 
225 	uint256[] _unmountChildren, // array of unmount child ids
226 	uint256[] _mountChildren,   // array of mount child ids
227 	uint256 _avatarId)           // above ids from which avatar 
228 	external {
229 	require(_childContract != address(0), "child address error");
230 	avatarService.unmount(msg.sender, _childContract, _unmountChildren, _avatarId);
231 	avatarService.mount(msg.sender, _childContract, _mountChildren, _avatarId);
232   }
233 }