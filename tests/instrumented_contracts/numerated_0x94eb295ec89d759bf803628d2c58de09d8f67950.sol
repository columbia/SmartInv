1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint supply) {}
6     function balanceOf(address _owner) constant returns (uint balance) {}
7     function transfer(address _to, uint _value) returns (bool success) {}
8     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
9     function approve(address _spender, uint _value) returns (bool success) {}
10     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 contract ERC721 {
52     function totalSupply() public view returns (uint256 total);
53     function balanceOf(address _owner) public view returns (uint256 balance);
54     function ownerOf(uint256 _tokenId) public view returns (address owner);
55     function approve(address _to, uint256 _tokenId) public;
56     function transferFrom(address _from, address _to, uint256 _tokenId) public;
57     function transfer(address _to, uint256 _tokenId) public;
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
60 
61     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
62 }
63 
64 contract ERC721BuyListing is Ownable {
65     struct Listing {
66         address seller;
67         uint256 price;
68         uint256 dateStarts;
69         uint256 dateEnds;
70     }
71     ERC721 public sourceContract;
72     uint256 public ownerPercentage;
73     mapping (uint256 => Listing) tokenIdToListing;
74 
75     string constant public version = "1.0.0";
76     event ListingCreated(uint256 indexed tokenId, uint256 price, uint256 dateStarts, uint256 dateEnds, address indexed seller);
77     event ListingCancelled(uint256 indexed tokenId, uint256 dateCancelled);
78     event ListingBought(uint256 indexed tokenId, uint256 price, uint256 dateBought, address buyer);
79 
80     function ERC721BuyListing(address targetContract, uint256 percentage) public {
81         ownerPercentage = percentage;
82         ERC721 contractPassed = ERC721(targetContract);
83         sourceContract = contractPassed;
84     }
85     function owns(address claimant, uint256 tokenId) internal view returns (bool) {
86         return (sourceContract.ownerOf(tokenId) == claimant);
87     }
88 
89     function updateOwnerPercentage(uint256 percentage) external onlyOwner {
90         ownerPercentage = percentage;
91     }
92 
93     function withdrawBalance() onlyOwner external {
94         assert(owner.send(this.balance));
95     }
96     function approveToken(address token, uint256 amount) onlyOwner external {
97         assert(Token(token).approve(owner, amount));
98     }
99 
100     function() external payable { }
101 
102     function createListing(uint256 tokenId, uint256 price, uint256 dateEnds) external {
103         require(owns(msg.sender, tokenId));
104         require(price > 0);
105         Listing memory listing = Listing(msg.sender, price, now, dateEnds);
106         tokenIdToListing[tokenId] = listing;
107         ListingCreated(tokenId, listing.price, now, dateEnds, listing.seller);
108     }
109 
110     function buyListing(uint256 tokenId) external payable {
111         Listing storage listing = tokenIdToListing[tokenId];
112         require(msg.value == listing.price);
113         require(now <= listing.dateEnds);
114         address seller = listing.seller;
115         uint256 currentPrice = listing.price;
116         delete tokenIdToListing[tokenId];
117         sourceContract.transferFrom(seller, msg.sender, tokenId);
118         seller.transfer(currentPrice - (currentPrice * ownerPercentage / 10000));
119         ListingBought(tokenId, listing.price, now, msg.sender);
120 
121     }
122 
123     function cancelListing(uint256 tokenId) external {
124         Listing storage listing = tokenIdToListing[tokenId];
125         require(msg.sender == listing.seller || msg.sender == owner);
126         delete tokenIdToListing[tokenId];
127         ListingCancelled(tokenId, now);
128     }
129 }