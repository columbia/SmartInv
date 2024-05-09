1 pragma solidity ^0.4.18;
2 
3 contract NFT {
4   function totalSupply() constant returns (uint);
5   function balanceOf(address) constant returns (uint);
6 
7   function tokenOfOwnerByIndex(address owner, uint index) constant returns (uint);
8   function ownerOf(uint tokenId) constant returns (address);
9 
10   function transfer(address to, uint tokenId);
11   function takeOwnership(uint tokenId);
12   function transferFrom(address from, address to, uint tokenId);
13   function approve(address beneficiary, uint tokenId);
14 
15   function metadata(uint tokenId) constant returns (string);
16 }
17 
18 contract NFTEvents {
19   event Created(uint tokenId, address owner, string metadata);
20   event Destroyed(uint tokenId, address owner);
21 
22   event Transferred(uint tokenId, address from, address to);
23   event Approval(address owner, address beneficiary, uint tokenId);
24 
25   event MetadataUpdated(uint tokenId, address owner, string data);
26 }
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40 
41   /**
42    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43    * account.
44    */
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 
72 
73 
74 
75 
76 contract BasicNFT is NFT, NFTEvents {
77 
78   uint public totalTokens;
79 
80   // Array of owned tokens for a user
81   mapping(address => uint[]) public ownedTokens;
82   mapping(address => uint) _virtualLength;
83   mapping(uint => uint) _tokenIndexInOwnerArray;
84 
85   // Mapping from token ID to owner
86   mapping(uint => address) public tokenOwner;
87 
88   // Allowed transfers for a token (only one at a time)
89   mapping(uint => address) public allowedTransfer;
90 
91   // Metadata associated with each token
92   mapping(uint => string) public _tokenMetadata;
93 
94   function totalSupply() public constant returns (uint) {
95     return totalTokens;
96   }
97 
98   function balanceOf(address owner) public constant returns (uint) {
99     return _virtualLength[owner];
100   }
101 
102   function tokenOfOwnerByIndex(address owner, uint index) public constant returns (uint) {
103     require(index >= 0 && index < balanceOf(owner));
104     return ownedTokens[owner][index];
105   }
106 
107   function getAllTokens(address owner) public constant returns (uint[]) {
108     uint size = _virtualLength[owner];
109     uint[] memory result = new uint[](size);
110     for (uint i = 0; i < size; i++) {
111       result[i] = ownedTokens[owner][i];
112     }
113     return result;
114   }
115 
116   function ownerOf(uint tokenId) public constant returns (address) {
117     return tokenOwner[tokenId];
118   }
119 
120   function transfer(address to, uint tokenId) public {
121     require(tokenOwner[tokenId] == msg.sender || allowedTransfer[tokenId] == msg.sender);
122     return _transfer(tokenOwner[tokenId], to, tokenId);
123   }
124 
125   function takeOwnership(uint tokenId) public {
126     require(allowedTransfer[tokenId] == msg.sender);
127     return _transfer(tokenOwner[tokenId], msg.sender, tokenId);
128   }
129 
130   function transferFrom(address from, address to, uint tokenId) public {
131     require(allowedTransfer[tokenId] == msg.sender);
132     return _transfer(tokenOwner[tokenId], to, tokenId);
133   }
134 
135   function approve(address beneficiary, uint tokenId) public {
136     require(msg.sender == tokenOwner[tokenId]);
137 
138     if (allowedTransfer[tokenId] != 0) {
139       allowedTransfer[tokenId] = 0;
140     }
141     allowedTransfer[tokenId] = beneficiary;
142     Approval(tokenOwner[tokenId], beneficiary, tokenId);
143   }
144 
145   function tokenMetadata(uint tokenId) constant public returns (string) {
146     return _tokenMetadata[tokenId];
147   }
148 
149   function metadata(uint tokenId) constant public returns (string) {
150     return _tokenMetadata[tokenId];
151   }
152 
153   function updateTokenMetadata(uint tokenId, string _metadata) public {
154     require(msg.sender == tokenOwner[tokenId]);
155     _tokenMetadata[tokenId] = _metadata;
156     MetadataUpdated(tokenId, msg.sender, _metadata);
157   }
158 
159   function _transfer(address from, address to, uint tokenId) internal {
160     _clearApproval(tokenId);
161     _removeTokenFrom(from, tokenId);
162     _addTokenTo(to, tokenId);
163     Transferred(tokenId, from, to);
164   }
165 
166   function _clearApproval(uint tokenId) internal {
167     allowedTransfer[tokenId] = 0;
168     Approval(tokenOwner[tokenId], 0, tokenId);
169   }
170 
171   function _removeTokenFrom(address from, uint tokenId) internal {
172     require(_virtualLength[from] > 0);
173 
174     uint length = _virtualLength[from];
175     uint index = _tokenIndexInOwnerArray[tokenId];
176     uint swapToken = ownedTokens[from][length - 1];
177 
178     ownedTokens[from][index] = swapToken;
179     _tokenIndexInOwnerArray[swapToken] = index;
180     _virtualLength[from]--;
181   }
182 
183   function _addTokenTo(address owner, uint tokenId) internal {
184     if (ownedTokens[owner].length == _virtualLength[owner]) {
185       ownedTokens[owner].push(tokenId);
186     } else {
187       ownedTokens[owner][_virtualLength[owner]] = tokenId;
188     }
189     tokenOwner[tokenId] = owner;
190     _tokenIndexInOwnerArray[tokenId] = _virtualLength[owner];
191     _virtualLength[owner]++;
192   }
193 }
194 
195 
196 
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that throw on error
200  */
201 library SafeMath {
202   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203     if (a == 0) {
204       return 0;
205     }
206     uint256 c = a * b;
207     assert(c / a == b);
208     return c;
209   }
210 
211   function div(uint256 a, uint256 b) internal pure returns (uint256) {
212     // assert(b > 0); // Solidity automatically throws when dividing by 0
213     uint256 c = a / b;
214     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215     return c;
216   }
217 
218   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219     assert(b <= a);
220     return a - b;
221   }
222 
223   function add(uint256 a, uint256 b) internal pure returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }
229 
230 contract GAZUAToken is Ownable, BasicNFT {
231     string public name = "Gazua";
232     string public symbol = "GAZ";
233     uint public limitation = 300;
234 
235     mapping (uint => string) public _message; //Personal Message;
236 
237     event MessageUpdated(uint tokenId, address owner, string data);
238 
239     using SafeMath for uint;
240 
241     function generateToken(address beneficiary, uint tokenId, string _metadata, string _personalMessage) public onlyOwner {
242         require(tokenOwner[tokenId] == 0);
243         require(totalSupply() <= limitation);
244         _generateToken(beneficiary, tokenId, _metadata, _personalMessage);
245     }
246 
247     function _generateToken(address beneficiary, uint tokenId, string _metadata, string _personalMessage) internal {
248         _addTokenTo(beneficiary, tokenId);
249         totalTokens++;
250         _tokenMetadata[tokenId] = _metadata;
251         _message[tokenId] = _personalMessage;
252         Created(tokenId, beneficiary, _metadata);
253     }
254 
255     // no one can update metadata
256     function updateTokenMetadata(uint tokenId, string _metadata) public {
257          throw; 
258     }
259 
260     function addLimitation(uint _quantity) public onlyOwner returns (bool) {
261         limitation = limitation.add(_quantity);
262         return true;
263     }
264 
265     function updateMessage(uint _tokenId, string _personalMessage) {
266         require(tokenOwner[_tokenId] == msg.sender);
267         _message[_tokenId] = _personalMessage;
268         MessageUpdated(_tokenId, msg.sender, _personalMessage);
269     }
270 
271     function getMessage(uint _tokenId) public constant returns (string) {
272         return _message[_tokenId];
273     }
274 
275 }