1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public view returns (uint256);
48   function transferFrom(address from, address to, uint256 value) public returns (bool);
49   function approve(address spender, uint256 value) public returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
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
80 contract ListingsERC20 is Ownable {
81       using SafeMath for uint256;
82 
83     struct Listing {
84         address seller;
85         address tokenContractAddress;
86         uint256 price;
87         uint256 allowance;
88         uint256 dateStarts;
89         uint256 dateEnds;
90     }
91     event ListingCreated(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateStarts, uint256 dateEnds, address indexed seller);
92     event ListingCancelled(bytes32 indexed listingId, uint256 dateCancelled);
93     event ListingBought(bytes32 indexed listingId, address tokenContractAddress, uint256 price, uint256 amount, uint256 dateBought, address buyer);
94 
95     string constant public VERSION = "1.0.1";
96     uint16 constant public GAS_LIMIT = 4999;
97     uint256 public ownerPercentage;
98     mapping (bytes32 => Listing) public listings;
99     mapping (bytes32 => uint256) public sold;
100     function ListingsERC20(uint256 percentage) public {
101         ownerPercentage = percentage;
102     }
103 
104     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
105         ownerPercentage = percentage;
106     }
107 
108     function withdrawBalance() onlyOwner external {
109         assert(owner.send(this.balance));
110     }
111     function approveToken(address token, uint256 amount) onlyOwner external {
112         assert(ERC20(token).approve(owner, amount));
113     }
114 
115     function() external payable { }
116 
117     function getHash(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external view returns (bytes32) {
118         return getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
119     }
120 
121     function getHashInternal(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) internal view returns (bytes32) {
122         return keccak256(msg.sender, tokenContractAddress, price, allowance, dateEnds, salt);
123     }
124     function getBalance(address tokenContract, address seller) internal constant returns (uint256) {
125         return ERC20(tokenContract).balanceOf.gas(GAS_LIMIT)(seller);
126     }
127     function getAllowance(address tokenContract, address seller, address listingContract) internal constant returns (uint256) {
128         return ERC20(tokenContract).allowance.gas(GAS_LIMIT)(seller, listingContract);
129     }
130 
131     function createListing(address tokenContractAddress, uint256 price, uint256 allowance, uint256 dateEnds, uint256 salt) external {
132         require(price > 0);
133         require(allowance > 0);
134         require(dateEnds > 0);
135         require(getBalance(tokenContractAddress, msg.sender) >= allowance);
136         bytes32 listingId = getHashInternal(tokenContractAddress, price, allowance, dateEnds, salt);
137         Listing memory listing = Listing(msg.sender, tokenContractAddress, price, allowance, now, dateEnds);
138         listings[listingId] = listing;
139         ListingCreated(listingId, tokenContractAddress, price, allowance, now, dateEnds, msg.sender);
140 
141     }
142 
143     function cancelListing(bytes32 listingId) external {
144         Listing storage listing = listings[listingId];
145         require(msg.sender == listing.seller);
146         delete listings[listingId];
147         ListingCancelled(listingId, now);
148     }
149     function buyListing(bytes32 listingId, uint256 amount) external payable {
150         Listing storage listing = listings[listingId];
151         address seller = listing.seller;
152         address contractAddress = listing.tokenContractAddress;
153         uint256 price = listing.price;
154         uint256 sale = price.mul(amount);
155         uint256 allowance = listing.allowance;
156         require(now <= listing.dateEnds);
157         //make sure there are still enough to sell from this listing
158         require(allowance - sold[listingId] >= amount);
159         //make sure that the seller still has that amount to sell
160         require(getBalance(contractAddress, seller) >= amount);
161         //make sure that the seller still will allow that amount to be sold
162         require(getAllowance(contractAddress, seller, this) >= amount);
163         require(msg.value == sale);
164         ERC20 tokenContract = ERC20(contractAddress);
165         require(tokenContract.transferFrom(seller, msg.sender, amount));
166         seller.transfer(sale - (sale.mul(ownerPercentage).div(10000)));
167         sold[listingId] = allowance.sub(amount);
168         ListingBought(listingId, contractAddress, price, amount, now, msg.sender);
169     }
170 
171 }