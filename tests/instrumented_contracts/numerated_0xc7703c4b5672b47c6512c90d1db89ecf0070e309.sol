1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender)
24     public view returns (uint256);
25 
26   function transferFrom(address from, address to, uint256 value)
27     public returns (bool);
28 
29   function approve(address spender, uint256 value) public returns (bool);
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 /**
39  * @title ERC721 Non-Fungible Token Standard basic interface
40  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
41  */
42 contract ERC721Basic {
43   event Transfer(
44     address indexed _from,
45     address indexed _to,
46     uint256 _tokenId
47   );
48   event Approval(
49     address indexed _owner,
50     address indexed _approved,
51     uint256 _tokenId
52   );
53   event ApprovalForAll(
54     address indexed _owner,
55     address indexed _operator,
56     bool _approved
57   );
58 
59   function balanceOf(address _owner) public view returns (uint256 _balance);
60   function ownerOf(uint256 _tokenId) public view returns (address _owner);
61   function exists(uint256 _tokenId) public view returns (bool _exists);
62 
63   function approve(address _to, uint256 _tokenId) public;
64   function getApproved(uint256 _tokenId)
65     public view returns (address _operator);
66 
67   function setApprovalForAll(address _operator, bool _approved) public;
68   function isApprovedForAll(address _owner, address _operator)
69     public view returns (bool);
70 
71   function transferFrom(address _from, address _to, uint256 _tokenId) public;
72   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
73     public;
74 
75   function safeTransferFrom(
76     address _from,
77     address _to,
78     uint256 _tokenId,
79     bytes _data
80   )
81     public;
82 }
83 
84 /**
85  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
86  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
87  */
88 contract ERC721Enumerable is ERC721Basic {
89   function totalSupply() public view returns (uint256);
90   function tokenOfOwnerByIndex(
91     address _owner,
92     uint256 _index
93   )
94     public
95     view
96     returns (uint256 _tokenId);
97 
98   function tokenByIndex(uint256 _index) public view returns (uint256);
99 }
100 
101 
102 /**
103  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
104  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
105  */
106 contract ERC721Metadata is ERC721Basic {
107   function name() public view returns (string _name);
108   function symbol() public view returns (string _symbol);
109   function tokenURI(uint256 _tokenId) public view returns (string);
110 }
111 
112 
113 /**
114  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
115  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
116  */
117 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
118 }
119 
120 
121 contract Ownable {
122   address public owner;
123 
124 
125   event OwnershipRenounced(address indexed previousOwner);
126   event OwnershipTransferred(
127     address indexed previousOwner,
128     address indexed newOwner
129   );
130 
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   constructor() public {
137     owner = msg.sender;
138   }
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148   /**
149    * @dev Allows the current owner to relinquish control of the contract.
150    */
151   function renounceOwnership() public onlyOwner {
152     emit OwnershipRenounced(owner);
153     owner = address(0);
154   }
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param _newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address _newOwner) public onlyOwner {
161     _transferOwnership(_newOwner);
162   }
163 
164   /**
165    * @dev Transfers control of the contract to a newOwner.
166    * @param _newOwner The address to transfer ownership to.
167    */
168   function _transferOwnership(address _newOwner) internal {
169     require(_newOwner != address(0));
170     emit OwnershipTransferred(owner, _newOwner);
171     owner = _newOwner;
172   }
173 }
174 
175 library SafeMath {
176   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
177     if (a == 0) {
178       return 0;
179     }
180 
181     c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187   * @dev Integer division of two numbers, truncating the quotient.
188   */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     // uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return a / b;
194   }
195 
196   /**
197   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198   */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205   * @dev Adds two numbers, throws on overflow.
206   */
207   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
208     c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 
215 contract ListingsERC721 is Ownable {
216     using SafeMath for uint256;
217 
218     struct Listing {
219         address seller;
220         address tokenContractAddress;
221         uint256 price;
222         uint256 allowance;
223         uint256 dateStarts;
224         uint256 dateEnds;
225     }
226     
227     event ListingCreated(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateStarts, uint256 dateEnds, address indexed seller);
228     event ListingCancelled(bytes32 indexed listingId, uint256 dateCancelled);
229     event ListingBought(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 amount, uint256 dateBought, address buyer);
230 
231     string constant public VERSION = "1.0.1";
232     uint16 constant public GAS_LIMIT = 4999;
233     uint256 public ownerPercentage;
234     mapping (bytes32 => Listing) public listings;
235 
236     constructor (uint256 percentage) public {
237         ownerPercentage = percentage;
238     }
239 
240     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
241         ownerPercentage = percentage;
242     }
243 
244     function withdrawBalance() onlyOwner external {
245         assert(owner.send(address(this).balance));
246     }
247     function approveToken(address token, uint256 amount) onlyOwner external {
248         assert(ERC20(token).approve(owner, amount));
249     }
250 
251     function() external payable { }
252 
253     function getHash(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external view returns (bytes32) {
254         return getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
255     }
256 
257     function getHashInternal(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) internal view returns (bytes32) {
258         return keccak256(abi.encodePacked(msg.sender, tokenContractAddress, price, allowance, dateEnds, salt));
259     }
260 
261     function createListing(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external {
262         require(price > 0, "price less than zero");
263         require(allowance > 0, "allowance less than zero");
264         require(dateEnds > 0, "dateEnds less than zero");
265         require(ERC721(tokenContractAddress).ownerOf(allowance) == msg.sender, "user doesn't own this token");
266         bytes32 listingId = getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
267         Listing memory listing = Listing(msg.sender, tokenContractAddress, price, allowance, now, dateEnds);
268         listings[listingId] = listing;
269         emit ListingCreated(listingId, tokenContractAddress, price, allowance, now, dateEnds, msg.sender);
270 
271     }
272     function cancelListing(bytes32 listingId) external {
273         Listing storage listing = listings[listingId];
274         require(msg.sender == listing.seller);
275         delete listings[listingId];
276         emit ListingCancelled(listingId, now);
277     }
278 
279     function buyListing(bytes32 listingId, uint256 amount) external payable {
280         Listing storage listing = listings[listingId];
281         address seller = listing.seller;
282         address contractAddress = listing.tokenContractAddress;
283         uint256 price = listing.price;
284         uint256 tokenId = listing.allowance;
285         ERC721 tokenContract = ERC721(contractAddress);
286         //make sure listing is still available
287         require(now <= listing.dateEnds);
288         //make sure that the seller still has that amount to sell
289         require(tokenContract.ownerOf(tokenId) == seller, "user doesn't own this token");
290         require(msg.value == price);
291         tokenContract.transferFrom(seller, msg.sender, tokenId);
292         if (ownerPercentage > 0) {
293             seller.transfer(price - (listing.price.mul(ownerPercentage).div(10000)));
294         } else {
295             seller.transfer(price);
296         }
297         emit ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
298     }
299 
300 
301 }