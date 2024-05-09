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
131 contract ListingsERC20NoDecimal is Ownable {
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
181 
182 
183     function createListing(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external {
184         require(price > 0, "price less than zero");
185         require(allowance > 0, "allowance less than zero");
186         require(dateEnds > 0, "dateEnds less than zero");
187         require(getBalance(tokenContractAddress, msg.sender) >= allowance, "balance less than allowance");
188         bytes32 listingId = getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
189         Listing memory listing = Listing(msg.sender, tokenContractAddress, price, allowance, now, dateEnds);
190         listings[listingId] = listing;
191         emit ListingCreated(listingId, tokenContractAddress, price, allowance, now, dateEnds, msg.sender);
192 
193     }
194 
195     function cancelListing(bytes32 listingId) external {
196         Listing storage listing = listings[listingId];
197         require(msg.sender == listing.seller);
198         delete listings[listingId];
199         emit ListingCancelled(listingId, now);
200     }
201     function buyListing(bytes32 listingId, uint256 amount) external payable {
202         Listing storage listing = listings[listingId];
203         address seller = listing.seller;
204         address contractAddress = listing.tokenContractAddress;
205         uint256 price = listing.price;
206         
207         
208         uint256 sale;
209        
210         sale = price.mul(amount);
211         
212         uint256 allowance = listing.allowance;
213         //make sure listing is still available
214         require(now <= listing.dateEnds);
215         //make sure there are still enough to sell from this listing
216         require(allowance - sold[listingId] >= amount);
217         //make sure that the seller still has that amount to sell
218         require(getBalance(contractAddress, seller) >= amount);
219         //make sure that the seller still will allow that amount to be sold
220         require(getAllowance(contractAddress, seller, this) >= amount);
221         require(msg.value == sale);
222         DetailedERC20 tokenContract = DetailedERC20(contractAddress);
223         require(tokenContract.transferFrom(seller, msg.sender, amount));
224         if (ownerPercentage > 0) {
225             seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
226         } else {
227             seller.transfer(sale);
228         }
229         sold[listingId] = sold[listingId].add(amount);
230         emit ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
231     }
232 
233 }