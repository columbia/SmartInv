1 pragma solidity >0.4.24 <0.5.0;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
7     // benefit is lost if 'b' is also tested.
8     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
9     if (a == 0) {
10       return 0;
11     }
12 
13     uint256 c = a * b;
14     require(c / a == b);
15 
16     return c;
17   }
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     require(b > 0); // Solidity only automatically asserts when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     require(b <= a);
26     uint256 c = a - b;
27 
28     return c;
29   }
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     require(c >= a);
33 
34     return c;
35   }
36   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b != 0);
38     return a % b;
39   }
40 }
41 
42 library Address {
43   function isContract(address account) internal view returns (bool) {
44     uint256 size;
45     assembly { size := extcodesize(account) }
46     return size > 0;
47   }
48 }
49 
50 
51 contract IERC165{
52     function supportsInterface(bytes4 interfaceID) external view returns (bool);
53 }
54 
55 contract ERC165 is IERC165{
56     mapping(bytes4 => bool) internal _supportedInterfaces;
57     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
58     constructor() public {
59         _registerInterface(_InterfaceId_ERC165);
60     }
61     function supportsInterface(bytes4 interfaceID) external view returns (bool){
62         return _supportedInterfaces[interfaceID];
63     }
64     function _registerInterface(bytes4 interfaceId) internal {
65         require(interfaceId != 0xffffffff);
66         _supportedInterfaces[interfaceId] = true;
67     }
68 }
69 
70 contract IERC721 {
71     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
72     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
73     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
74     function balanceOf(address _owner) public view returns (uint256);
75     function ownerOf(uint256 _tokenId) public view returns (address);
76     function approve(address _approved, uint256 _tokenId) public payable;
77     function getApproved(uint256 _tokenId) public view returns (address);
78     function setApprovalForAll(address _operator, bool _approved) public;
79     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
80     function transferFrom(address _from, address _to, uint256 _tokenId) public payable;
81     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable;
82     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) public payable;    
83 
84 }
85 
86 contract IERC721Receiver {
87     bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
88     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
89 }
90 
91 contract ERC721Receiver is IERC721Receiver {
92     function onERC721Received(address _operator, address _from,uint256 _tokenId, bytes _data) public returns(bytes4) {
93         return ERC721_RECEIVED;
94     }
95 }
96 
97 contract ERC721 is IERC721,ERC165 {
98     
99     using SafeMath for uint256;
100     using Address for address;
101     
102     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
103     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
104     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
105     // Mapping from token ID to owner
106     mapping (uint256 => address) public _tokenOwner;
107     // Mapping from token ID to approved address
108     mapping (uint256 => address) public _tokenApprovals;
109     // Mapping from owner to number of owned token
110     mapping (address => uint256) public _ownedTokensCount;
111     // Mapping from owner to operator approvals
112     mapping (address => mapping (address => bool)) public _operatorApprovals;
113     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
114     /*
115      * 0x80ac58cd ===
116      *   bytes4(keccak256('balanceOf(address)')) ^
117      *   bytes4(keccak256('ownerOf(uint256)')) ^
118      *   bytes4(keccak256('approve(address,uint256)')) ^
119      *   bytes4(keccak256('getApproved(uint256)')) ^
120      *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
121      *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
122      *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
123      *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
124      *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
125     */
126     constructor() public {
127         _registerInterface(_InterfaceId_ERC721);
128     }
129     function balanceOf(address _owner) public view returns (uint256){
130         require(_owner != address(0));
131         return _ownedTokensCount[_owner];
132     }
133     function ownerOf(uint256 tokenId) public view returns (address) {
134         address owner = _tokenOwner[tokenId];
135         require(owner != address(0));
136         return owner;
137     }
138     function approve(address to, uint256 tokenId) public payable {
139         address owner = ownerOf(tokenId);
140         require(to != owner);
141         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
142 
143         _tokenApprovals[tokenId] = to;
144         emit Approval(owner, to, tokenId);
145     }
146     function getApproved(uint256 tokenId) public view returns (address) {
147         require(_exists(tokenId));
148         return _tokenApprovals[tokenId];
149     }
150     function setApprovalForAll(address to, bool approved) public {
151         require(to != msg.sender);
152         _operatorApprovals[msg.sender][to] = approved;
153         emit ApprovalForAll(msg.sender, to, approved);
154     }
155     function isApprovedForAll(address owner, address operator) public view returns (bool) {
156         return _operatorApprovals[owner][operator];
157     }
158     function transferFrom(address from, address to, uint256 tokenId) public payable {
159         require(_isApprovedOrOwner(msg.sender, tokenId));
160         require(to != address(0));
161 
162         _clearApproval(from, tokenId);
163         _removeTokenFrom(from, tokenId);
164         _addTokenTo(to, tokenId);
165 
166         emit Transfer(from, to, tokenId);
167     }
168     function safeTransferFrom(address from, address to, uint256 tokenId) public payable {
169         // solium-disable-next-line arg-overflow
170         safeTransferFrom(from, to, tokenId, "");
171     }
172     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public payable {
173         transferFrom(from, to, tokenId);
174         // solium-disable-next-line arg-overflow
175         require(_checkOnERC721Received(from, to, tokenId, _data));
176     }
177     function _exists(uint256 tokenId) internal view returns (bool) {
178         address owner = _tokenOwner[tokenId];
179         return owner != address(0);
180     }
181     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
182         address owner = ownerOf(tokenId);
183         // Disable solium check because of
184         // https://github.com/duaraghav8/Solium/issues/175
185         // solium-disable-next-line operator-whitespace
186         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
187     }
188     function _addTokenTo(address to, uint256 tokenId) internal {
189         require(_tokenOwner[tokenId] == address(0));
190         _tokenOwner[tokenId] = to;
191         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
192     }
193     function _removeTokenFrom(address from, uint256 tokenId) internal {
194         require(ownerOf(tokenId) == from);
195         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
196         _tokenOwner[tokenId] = address(0);
197     }
198     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) internal returns (bool) {
199         if (!to.isContract()) {
200             return true;
201         }
202         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
203         return (retval == _ERC721_RECEIVED);
204     }
205     function _clearApproval(address owner, uint256 tokenId) private {
206         require(ownerOf(tokenId) == owner);
207         if (_tokenApprovals[tokenId] != address(0)) {
208             _tokenApprovals[tokenId] = address(0);
209         }
210     }
211     
212 }
213 
214 contract BTCCtoken is ERC721{
215     
216     
217     // Set in case the core contract is broken and an upgrade is required
218     address public ooo;
219     address public newContractAddress;
220     uint256 public totalSupply= 1000000000 ether;
221     string public constant name = "btcc";
222     string public constant symbol = "btcc";
223     
224     constructor() public{
225         address _owner = msg.sender;
226         _tokenOwner[1] = _owner;
227         _ownedTokensCount[_owner] = _ownedTokensCount[_owner]+1;
228     }
229     
230    
231     
232     
233     
234     }