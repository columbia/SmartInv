1 pragma solidity ^0.4.24;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipRenounced(address indexed previousOwner);
52   event OwnershipTransferred(
53     address indexed previousOwner,
54     address indexed newOwner
55   );
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   constructor() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to relinquish control of the contract.
76    */
77   function renounceOwnership() public onlyOwner {
78     emit OwnershipRenounced(owner);
79     owner = address(0);
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address _newOwner) public onlyOwner {
87     _transferOwnership(_newOwner);
88   }
89 
90   /**
91    * @dev Transfers control of the contract to a newOwner.
92    * @param _newOwner The address to transfer ownership to.
93    */
94   function _transferOwnership(address _newOwner) internal {
95     require(_newOwner != address(0));
96     emit OwnershipTransferred(owner, _newOwner);
97     owner = _newOwner;
98   }
99 }
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender)
108     public view returns (uint256);
109 
110   function transferFrom(address from, address to, uint256 value)
111     public returns (bool);
112 
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(
115     address indexed owner,
116     address indexed spender,
117     uint256 value
118   );
119 }
120 contract DetailedERC20 is ERC20 {
121   string public name;
122   string public symbol;
123   uint8 public decimals;
124 
125   constructor(string _name, string _symbol, uint8 _decimals) public {
126     name = _name;
127     symbol = _symbol;
128     decimals = _decimals;
129   }
130 }
131 contract ListingsERC20 is Ownable {
132       using SafeMath for uint256;
133 
134     struct Listing {
135         address seller;
136         address tokenContractAddress;
137         uint256 price;
138         uint256 allowance;
139         uint256 dateStarts;
140         uint256 dateEnds;
141     }
142     event ListingCreated(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateStarts, uint256 dateEnds, address indexed seller);
143     event ListingCancelled(bytes32 indexed listingId, uint256 dateCancelled);
144     event ListingBought(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 amount, uint256 dateBought, address buyer);
145 
146     string constant public VERSION = "2.0.0";
147     uint16 constant public GAS_LIMIT = 4999;
148     uint256 public ownerPercentage;
149     mapping (bytes32 => Listing) public listings;
150     mapping (bytes32 => uint256) public sold;
151     constructor (uint256 percentage) public {
152         ownerPercentage = percentage;
153     }
154 
155     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
156         ownerPercentage = percentage;
157     }
158 
159     function withdrawBalance() onlyOwner external {
160         assert(owner.send(address(this).balance));
161     }
162     function approveToken(address token, uint256 amount) onlyOwner external {
163         assert(DetailedERC20(token).approve(owner, amount));
164     }
165 
166     function() external payable { }
167 
168     function getHash(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external view returns (bytes32) {
169         return getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
170     }
171 
172     function getHashInternal(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) internal view returns (bytes32) {
173         return keccak256(abi.encodePacked(msg.sender, tokenContractAddress, price, allowance, dateEnds, salt));
174     }
175     function getBalance(address tokenContract, address seller) internal returns (uint256) {
176         return DetailedERC20(tokenContract).balanceOf.gas(GAS_LIMIT)(seller);
177     }
178     function getAllowance(address tokenContract, address seller, address listingContract) internal returns (uint256) {
179         return DetailedERC20(tokenContract).allowance.gas(GAS_LIMIT)(seller, listingContract);
180     }
181     function getDecimals(address tokenContract) internal returns (uint256) {
182         return DetailedERC20(tokenContract).decimals.gas(GAS_LIMIT)();
183     }
184 
185     function createListing(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external {
186         require(price > 0, "price less than zero");
187         require(allowance > 0, "allowance less than zero");
188         require(dateEnds > 0, "dateEnds less than zero");
189         require(getBalance(tokenContractAddress, msg.sender) >= allowance, "balance less than allowance");
190         bytes32 listingId = getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
191         Listing memory listing = Listing(msg.sender, tokenContractAddress, price, allowance, now, dateEnds);
192         listings[listingId] = listing;
193         emit ListingCreated(listingId, tokenContractAddress, price, allowance, now, dateEnds, msg.sender);
194 
195     }
196 
197     function cancelListing(bytes32 listingId) external {
198         Listing storage listing = listings[listingId];
199         require(msg.sender == listing.seller);
200         delete listings[listingId];
201         emit ListingCancelled(listingId, now);
202     }
203     function buyListing(bytes32 listingId, uint256 amount) external payable {
204         Listing storage listing = listings[listingId];
205         address seller = listing.seller;
206         address contractAddress = listing.tokenContractAddress;
207         uint256 price = listing.price;
208         uint256 decimals = getDecimals(listing.tokenContractAddress);
209         uint256 factor = 10 ** decimals;
210         uint256 sale;
211         if (decimals > 0) {
212             sale = price.mul(amount).div(factor);
213         } else {
214             sale = price.mul(amount);
215         } 
216         uint256 allowance = listing.allowance;
217         //make sure listing is still available
218         require(now <= listing.dateEnds);
219         //make sure there are still enough to sell from this listing
220         require(allowance - sold[listingId] >= amount);
221         //make sure that the seller still has that amount to sell
222         require(getBalance(contractAddress, seller) >= amount);
223         //make sure that the seller still will allow that amount to be sold
224         require(getAllowance(contractAddress, seller, this) >= amount);
225         require(msg.value == sale);
226         DetailedERC20 tokenContract = DetailedERC20(contractAddress);
227         require(tokenContract.transferFrom(seller, msg.sender, amount));
228         if (ownerPercentage > 0) {
229             seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
230         } else {
231             seller.transfer(sale);
232         }
233         sold[listingId] = sold[listingId].add(amount);
234         emit ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
235     }
236 
237 }