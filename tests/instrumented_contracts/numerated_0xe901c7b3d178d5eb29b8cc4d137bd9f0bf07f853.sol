1 pragma solidity ^0.4.24;
2 
3 // File: contracts/libraries/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: contracts/standards/Ownable.sol
70 
71 contract Ownable {
72   address public owner;
73 
74   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/ItemBase.sol
94 
95 contract ItemBase is Ownable {
96     using SafeMath for uint;
97 
98     struct Item {
99         string name;
100         string itemType;
101         string size;
102         string color;
103         // price (in wei) of item
104         uint128 price;
105     }
106 
107     uint128 MAX_ITEMS = 1;
108     // array of items
109     Item[] items;
110 
111     // @dev A mapping of item ids to the address that owns them
112     mapping(uint => address) public itemIndexToOwner;
113 
114     // @dev A mapping from owner address to count of tokens that address owns.
115     //  Used internally inside balanceOf() to resolve ownership count.
116     mapping (address => uint) public ownershipTokenCount;
117 
118     // @dev A mapping from item ids to an address that has been approved to call
119     //  transferFrom(). Each item can only have one approved address for transfer
120     //  at any time. A zero value means no approval is outstanding.
121     mapping (uint => address) public itemIndexToApproved;
122 
123 
124     function getItem( uint _itemId ) public view returns(string name, string itemType, string size, string color, uint128 price) {
125         Item memory _item = items[_itemId];
126 
127         name = _item.name;
128         itemType = _item.itemType;
129         size = _item.size;
130         color = _item.color;
131         price = _item.price;
132     }
133 }
134 
135 // File: contracts/standards/ERC721.sol
136 
137 /// @title ERC-721 Non-Fungible Token Standard
138 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
139 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
140 contract ERC721 {
141     function totalSupply() public view returns (uint256);
142     function balanceOf(address _owner) external view returns (uint256);
143     function ownerOf(uint256 _tokenId) external view returns (address);
144     function approve(address _approved, uint256 _tokenId) external;
145     function transfer(address _to, uint256 _tokenId) external;
146     function transferFrom(address _from, address _to, uint256 _tokenId) external;
147     // function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
148 
149     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
150     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
151 }
152 
153 // File: contracts/SatoshiZero.sol
154 
155 contract SatoshiZero is ItemBase, ERC721 {
156     string public constant name = "Satoshis Closet";
157     string public constant symbol = "STCL";
158     string public constant tokenName = "Tom's Shirt / The Proof of Concept";
159 
160     /// @dev Purchase event is fired after a purchase has been completed
161     event Purchase(address owner, uint itemId);
162 
163     // Internal utility functions: These functions all assume that their input arguments are valid
164     // We leave it to public methods to sanitize their inputs and follow the required logic.
165 
166     // @dev Checks if a given address is the current owner of a particular item.
167     // @param _claimant the address we are validating against.
168     // @param _tokenId item id, only valid when > 0
169     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
170         return itemIndexToOwner[_tokenId] == _claimant;
171     }
172 
173     // @dev Checks if a given address currently has transferApproval for a particular item.
174     // @param _claimant the address we are confirming item is approved for.
175     // @param _tokenId item id, only valid when > 0
176     function _approvedFor(address _claimant, uint _tokenId) internal view returns (bool) {
177         return itemIndexToApproved[_tokenId] == _claimant;
178     }
179 
180     // @dev Marks an address as being approved for transferFrom(), overwriting any previous approval
181     //  Setting _approved to address(0) clears all transfer approval.
182     //  NOTE: _approve() does NOT send the Approval event (IS THIS RIGHT?)
183     function _approve(uint _tokenId, address _approved) internal {
184         itemIndexToApproved[_tokenId] = _approved;
185     }
186 
187     function balanceOf(address _owner) external view returns (uint) {
188         return ownershipTokenCount[_owner];
189     }
190 
191     function tokenMetadata(uint256 _tokenId) public view returns (string) {
192         return 'https://satoshiscloset.com/SatoshiZero.json';
193     }
194 
195     // @dev function to transfer item from one user to another
196     //  this will become useful when reselling is implemented
197     function transfer(address _to, uint _tokenId) external {
198         // Safety check to prevent against an unexpected 0x0 default.
199         require(_to != address(0));
200         // You can only send your own item
201         require(_owns(msg.sender, _tokenId));
202         // Reassign ownership, clear pending approvals, emit Transfer event.
203         _transfer(msg.sender, _to, _tokenId);
204     }
205 
206     /// @notice Grant another address the right to transfer a specific item via
207     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
208     /// @param _to The address to be granted transfer approval. Pass address(0) to
209     ///  clear all approvals.
210     /// @param _tokenId The ID of the item that can be transferred if this call succeeds.
211     /// @dev Required for ERC-721 compliance.
212     function approve(address _to, uint _tokenId) external {
213         // Only an owner can grant transfer approval.
214         require(_owns(msg.sender, _tokenId));
215 
216         // Register the approval (replacing any previous approval).
217         _approve(_tokenId, _to);
218 
219         // Emit approval event.
220         emit Approval(msg.sender, _to, _tokenId);
221     }
222 
223     /// @notice Transfer an item owned by another address, for which the calling address
224     ///  has previously been granted transfer approval by the owner.
225     /// @param _from The address that owns the item to be transfered.
226     /// @param _to The address that should take ownership of the item. Can be any address,
227     ///  including the caller.
228     /// @param _tokenId The ID of the item to be transferred.
229     /// @dev Required for ERC-721 compliance.
230     function transferFrom(address _from, address _to, uint256 _tokenId) external {
231         // Safety check to prevent against an unexpected 0x0 default.
232         require(_to != address(0));
233         // Check for approval and valid ownership
234         require(_approvedFor(msg.sender, _tokenId));
235         require(_owns(_from, _tokenId));
236 
237         // Reassign ownership (also clears pending approvals and emits Transfer event).
238         _transfer(_from, _to, _tokenId);
239     }
240 
241     /// @notice Returns the total number of items currently in existence.
242     /// @dev Required for ERC-721 compliance.
243     function totalSupply() public view returns (uint) {
244         return items.length;
245     }
246 
247     /// @notice Returns the address currently assigned ownership of a given item.
248     /// @dev Required for ERC-721 compliance.
249     function ownerOf(uint _tokenId) external view returns (address) {
250         owner = itemIndexToOwner[_tokenId];
251         require(owner != address(0));
252     }
253 
254     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
255         uint256 tokenCount = ownershipTokenCount[_owner];
256 
257         if (tokenCount == 0) {
258             // Return an empty array
259             return new uint256[](0);
260         } else {
261             uint256[] memory result = new uint256[](tokenCount);
262             uint256 totalItems = totalSupply();
263             uint256 resultIndex = 0;
264 
265             // We count on the fact that all items have IDs starting at 1 and increasing
266             // sequentially up to the totalItems count.
267             uint256 itemId;
268 
269             for (itemId = 1; itemId <= totalItems; itemId++) {
270                 if (itemIndexToOwner[itemId] == _owner) {
271                     result[resultIndex] = itemId;
272                     resultIndex++;
273                 }
274             }
275 
276             return result;
277         }
278     }
279 
280     function _purchase(string _name, string _type, string _size, string _color, uint128 _price) internal returns (uint) {
281         Item memory _item = Item({ name: _name, itemType: _type, size: _size, color: _color, price: _price });
282         uint itemId = items.push(_item);
283 
284         // emit purchase event
285         emit Purchase(msg.sender, itemId);
286 
287         // This will assign ownership, and also emit the Transfer event as
288         // per ERC721 draft
289         _transfer(0, owner, itemId);
290 
291         return itemId;
292     }
293 
294     // @dev Assigns ownership of a specific item to an address.
295     function _transfer(address _from, address _to, uint _tokenId) internal {
296         ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
297         // transfer ownership
298         itemIndexToOwner[_tokenId] = _to;
299         // When creating new items _from is 0x0, but we can't account that address.
300         if (_from != address(0)) {
301             ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
302             // clear any previously approved ownership exchange
303             delete itemIndexToApproved[_tokenId];
304         }
305         // Emit the transfer event.
306         emit Transfer(_from, _to, _tokenId);
307     }
308 
309     function createItem( string _name, string _itemType, string _size, string _color, uint128 _price) external onlyOwner returns (uint) {
310         require(MAX_ITEMS > totalSupply());
311 
312         Item memory _item = Item({
313             name: _name,
314             itemType: _itemType,
315             size: _size,
316             color: _color,
317             price: _price
318         });
319         uint itemId = items.push(_item);
320 
321         _transfer(0, owner, itemId);
322 
323         return itemId;
324     }
325 }