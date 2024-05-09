1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 pragma solidity ^0.4.18;
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint256 a, uint256 b) internal pure returns (uint256) {
75     uint256 c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 
82 
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   uint8 public decimals;
86   function balanceOf(address who) public view returns (uint256);
87   function transfer(address to, uint256 value) public returns (bool);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 contract ListingsERC20 is Ownable {
98       using SafeMath for uint256;
99 
100     struct Listing {
101         address seller;
102         address tokenContractAddress;
103         uint256 price;
104         uint256 allowance;
105         uint256 dateStarts;
106         uint256 dateEnds;
107     }
108     event ListingCreated(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateStarts, uint256 dateEnds, address indexed seller);
109     event ListingCancelled(bytes32 indexed listingId, uint256 dateCancelled);
110     event ListingBought(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 amount, uint256 dateBought, address buyer);
111 
112     string constant public VERSION = "1.0.1";
113     uint16 constant public GAS_LIMIT = 4999;
114     uint256 public ownerPercentage;
115     mapping (bytes32 => Listing) public listings;
116     mapping (bytes32 => uint256) public sold;
117     function ListingsERC20(uint256 percentage) public {
118         ownerPercentage = percentage;
119     }
120 
121     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
122         ownerPercentage = percentage;
123     }
124 
125     function withdrawBalance() onlyOwner external {
126         assert(owner.send(this.balance));
127     }
128     function approveToken(address token, uint256 amount) onlyOwner external {
129         assert(ERC20(token).approve(owner, amount));
130     }
131 
132     function() external payable { }
133 
134     function getHash(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external view returns (bytes32) {
135         return getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
136     }
137 
138     function getHashInternal(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) internal view returns (bytes32) {
139         return keccak256(msg.sender, tokenContractAddress, price, allowance, dateEnds, salt);
140     }
141     function getBalance(address tokenContract, address seller) internal constant returns (uint256) {
142         return ERC20(tokenContract).balanceOf.gas(GAS_LIMIT)(seller);
143     }
144     function getAllowance(address tokenContract, address seller, address listingContract) internal constant returns (uint256) {
145         return ERC20(tokenContract).allowance.gas(GAS_LIMIT)(seller, listingContract);
146     }
147     function getDecimals(address tokenContract) internal constant returns (uint256) {
148         return ERC20(tokenContract).decimals.gas(GAS_LIMIT)();
149     }
150 
151     function createListing(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external {
152         require(price > 0);
153         require(allowance > 0);
154         require(dateEnds > 0);
155         require(getBalance(tokenContractAddress, msg.sender) >= allowance);
156         bytes32 listingId = getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
157         Listing memory listing = Listing(msg.sender, tokenContractAddress, price, allowance, now, dateEnds);
158         listings[listingId] = listing;
159         ListingCreated(listingId, tokenContractAddress, price, allowance, now, dateEnds, msg.sender);
160 
161     }
162 
163     function cancelListing(bytes32 listingId) external {
164         Listing storage listing = listings[listingId];
165         require(msg.sender == listing.seller);
166         delete listings[listingId];
167         ListingCancelled(listingId, now);
168     }
169     function buyListing(bytes32 listingId, uint256 amount) external payable {
170         Listing storage listing = listings[listingId];
171         address seller = listing.seller;
172         address contractAddress = listing.tokenContractAddress;
173         uint256 price = listing.price;
174         uint256 decimals = getDecimals(listing.tokenContractAddress);
175         uint256 factor = 10 ** decimals;
176         uint256 sale;
177         if (decimals > 0) {
178             sale = price.mul(amount).div(factor);
179         } else {
180             sale = price.mul(amount);
181         } 
182         uint256 allowance = listing.allowance;
183         //make sure listing is still available
184         require(now <= listing.dateEnds);
185         //make sure there are still enough to sell from this listing
186         require(allowance - sold[listingId] >= amount);
187         //make sure that the seller still has that amount to sell
188         require(getBalance(contractAddress, seller) >= amount);
189         //make sure that the seller still will allow that amount to be sold
190         require(getAllowance(contractAddress, seller, this) >= amount);
191         require(msg.value == sale);
192         ERC20 tokenContract = ERC20(contractAddress);
193         require(tokenContract.transferFrom(seller, msg.sender, amount));
194         if (ownerPercentage > 0) {
195             seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
196         } else {
197             seller.transfer(sale);
198         }
199         sold[listingId] = sold[listingId].add(amount);
200         ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
201     }
202 
203 }