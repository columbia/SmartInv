1 pragma solidity ^0.4.13;
2 contract Token {
3 
4     function totalSupply() constant returns (uint supply) {}
5     function balanceOf(address _owner) constant returns (uint balance) {}
6     function transfer(address _to, uint _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
8     function approve(address _spender, uint _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 contract Mooncat {
52         function giveCat(bytes5 catId, address to) public;
53         function catOwners(bytes5 catId) constant returns (address catOwner);
54 
55 }
56 contract MooncatListing is Ownable {
57     struct Listing {
58         address seller;
59         uint256 price;
60         uint256 dateStarts;
61         uint256 dateEnds;
62     }
63     Mooncat public sourceContract;
64     uint256 public ownerPercentage;
65     mapping (bytes5 => Listing) public tokenIdToListing;
66 
67     string constant public VERSION = "1.0.0";
68     event ListingCreated(bytes5 indexed tokenId, uint256 price, uint256 dateStarts, uint256 dateEnds, address indexed seller);
69     event ListingCancelled(bytes5 indexed tokenId, uint256 dateCancelled);
70     event ListingBought(bytes5 indexed tokenId, uint256 price, uint256 dateBought, address buyer);
71 
72     function MooncatListing(address targetContract, uint256 percentage) public {
73         ownerPercentage = percentage;
74         Mooncat contractPassed = Mooncat(targetContract);
75         sourceContract = contractPassed;
76     }
77 
78     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
79         ownerPercentage = percentage;
80     }
81 
82     function withdrawBalance() onlyOwner external {
83         assert(owner.send(this.balance));
84     }
85     function approveToken(address token, uint256 amount) onlyOwner external {
86         assert(Token(token).approve(owner, amount));
87     }
88 
89     function() external payable { }
90 
91     function createListing(bytes5 tokenId, uint256 price, uint256 dateEnds) external {
92         require(price > 0);
93         tokenIdToListing[tokenId] = Listing(msg.sender, price, now, dateEnds);
94         ListingCreated(tokenId, price, now, dateEnds, msg.sender);
95     }
96 
97     function getListing(bytes5 tokenId) external view returns (address seller, uint256 price, uint256 dateStarts, uint256 dateEnds) {
98         Listing storage listing = tokenIdToListing[tokenId];
99         return (listing.seller, listing.price, listing.dateStarts, listing.dateEnds);
100     }
101 
102     function buyListing(bytes5 tokenId) external payable {
103         Listing storage listing = tokenIdToListing[tokenId];
104         require(msg.value == listing.price);
105         require(now <= listing.dateEnds);
106         address seller = listing.seller;
107         uint256 currentPrice = listing.price;
108         delete tokenIdToListing[tokenId];
109         sourceContract.giveCat(tokenId, msg.sender);
110         seller.transfer(currentPrice - (currentPrice * ownerPercentage / 10000));
111         ListingBought(tokenId, listing.price, now, msg.sender);
112 
113     }
114 
115     function cancelListing(bytes5 tokenId) external {
116         Listing storage listing = tokenIdToListing[tokenId];
117         require(msg.sender == listing.seller || msg.sender == owner);
118         sourceContract.giveCat(tokenId, listing.seller);
119         delete tokenIdToListing[tokenId];
120         ListingCancelled(tokenId, now);
121     }
122 }