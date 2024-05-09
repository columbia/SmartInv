1 pragma solidity ^0.4.21;
2 
3 contract ERC721 {
4     // Required methods
5     function totalSupply() public view returns (uint256 total);
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function ownerOf(uint256 _tokenId) external view returns (address owner);
8     function approve(address _to, uint256 _tokenId) external;
9     function transfer(address _to, uint256 _tokenId) external;
10     function transferFrom(address _from, address _to, uint256 _tokenId) external;
11 
12     // Events
13     event Transfer(address from, address to, uint256 tokenId);
14     event Approval(address owner, address approved, uint256 tokenId);
15 
16     // Optional
17     // function name() public view returns (string name);
18     // function symbol() public view returns (string symbol);
19     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
20     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
21 
22     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
23     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address previousOwner, address newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract StorageBase is Ownable {
48 
49     function withdrawBalance() external onlyOwner returns (bool) {
50         // The owner has a method to withdraw balance from multiple contracts together,
51         // use send here to make sure even if one withdrawBalance fails the others will still work
52         bool res = msg.sender.send(address(this).balance);
53         return res;
54     }
55 }
56 
57 contract ClockAuctionStorage is StorageBase {
58 
59     // Represents an auction on an NFT
60     struct Auction {
61         // Current owner of NFT
62         address seller;
63         // Price (in wei) at beginning of auction
64         uint128 startingPrice;
65         // Price (in wei) at end of auction
66         uint128 endingPrice;
67         // Duration (in seconds) of auction
68         uint64 duration;
69         // Time when auction started
70         // NOTE: 0 if this auction has been concluded
71         uint64 startedAt;
72     }
73 
74     // Map from token ID to their corresponding auction.
75     mapping (uint256 => Auction) tokenIdToAuction;
76 
77     function addAuction(
78         uint256 _tokenId,
79         address _seller,
80         uint128 _startingPrice,
81         uint128 _endingPrice,
82         uint64 _duration,
83         uint64 _startedAt
84     )
85         external
86         onlyOwner
87     {
88         tokenIdToAuction[_tokenId] = Auction(
89             _seller,
90             _startingPrice,
91             _endingPrice,
92             _duration,
93             _startedAt
94         );
95     }
96 
97     function removeAuction(uint256 _tokenId) public onlyOwner {
98         delete tokenIdToAuction[_tokenId];
99     }
100 
101     function getAuction(uint256 _tokenId)
102         external
103         view
104         returns (
105             address seller,
106             uint128 startingPrice,
107             uint128 endingPrice,
108             uint64 duration,
109             uint64 startedAt
110         )
111     {
112         Auction storage auction = tokenIdToAuction[_tokenId];
113         return (
114             auction.seller,
115             auction.startingPrice,
116             auction.endingPrice,
117             auction.duration,
118             auction.startedAt
119         );
120     }
121 
122     function isOnAuction(uint256 _tokenId) external view returns (bool) {
123         return (tokenIdToAuction[_tokenId].startedAt > 0);
124     }
125 
126     function getSeller(uint256 _tokenId) external view returns (address) {
127         return tokenIdToAuction[_tokenId].seller;
128     }
129 
130     function transfer(ERC721 _nonFungibleContract, address _receiver, uint256 _tokenId) external onlyOwner {
131         // it will throw if transfer fails
132         _nonFungibleContract.transfer(_receiver, _tokenId);
133     }
134 }
135 
136 contract SiringClockAuctionStorage is ClockAuctionStorage {
137     bool public isSiringClockAuctionStorage = true;
138 }