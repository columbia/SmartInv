1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 
48 
49 
50 
51 contract Beneficiary is Ownable {
52 
53     address public beneficiary;
54 
55     function Beneficiary() public {
56         beneficiary = msg.sender;
57     }
58 
59     function setBeneficiary(address _beneficiary) onlyOwner public {
60         beneficiary = _beneficiary;
61     }
62 
63 
64 }
65 
66 
67 /// @title Auction contract for any type of erc721 token
68 /// @author Fishbank
69 
70 contract ERC721 {
71 
72     function implementsERC721() public pure returns (bool);
73 
74     function totalSupply() public view returns (uint256 total);
75 
76     function balanceOf(address _owner) public view returns (uint256 balance);
77 
78     function ownerOf(uint256 _tokenId) public view returns (address owner);
79 
80     function approve(address _to, uint256 _tokenId) public;
81 
82     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool);
83 
84     function transfer(address _to, uint256 _tokenId) public returns (bool);
85 
86     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
87 
88     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
89 
90     // Optional
91     // function name() public view returns (string name);
92     // function symbol() public view returns (string symbol);
93     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
94     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
95 }
96 
97 
98 contract ERC721Auction is Beneficiary {
99 
100     struct Auction {
101         address seller;
102         uint256 tokenId;
103         uint64 auctionBegin;
104         uint64 auctionEnd;
105         uint256 startPrice;
106         uint256 endPrice;
107     }
108 
109     uint32 public auctionDuration = 7 days;
110 
111     ERC721 public ERC721Contract;
112     uint256 public fee = 45000; //in 1 10000th of a percent so 4.5% at the start
113     uint256 constant FEE_DIVIDER = 1000000;
114     mapping(uint256 => Auction) public auctions;
115 
116     event AuctionWon(uint256 indexed tokenId, address indexed winner, address indexed seller, uint256 price);
117 
118     event AuctionStarted(uint256 indexed tokenId, address indexed seller);
119 
120     event AuctionFinalized(uint256 indexed tokenId, address indexed seller);
121 
122 
123     function startAuction(uint256 _tokenId, uint256 _startPrice, uint256 _endPrice) external {
124         require(ERC721Contract.transferFrom(msg.sender, address(this), _tokenId));
125         //Prices must be in range from 0.01 Eth and 10 000 Eth
126         require(_startPrice <= 10000 ether && _endPrice <= 10000 ether);
127         require(_startPrice >= (1 ether / 100) && _endPrice >= (1 ether / 100));
128 
129         Auction memory auction;
130 
131         auction.seller = msg.sender;
132         auction.tokenId = _tokenId;
133         auction.auctionBegin = uint64(now);
134         auction.auctionEnd = uint64(now + auctionDuration);
135         require(auction.auctionEnd > auction.auctionBegin);
136         auction.startPrice = _startPrice;
137         auction.endPrice = _endPrice;
138 
139         auctions[_tokenId] = auction;
140 
141         AuctionStarted(_tokenId, msg.sender);
142     }
143 
144 
145     function buyAuction(uint256 _tokenId) payable external {
146         Auction storage auction = auctions[_tokenId];
147 
148         uint256 price = calculateBid(_tokenId);
149         uint256 totalFee = price * fee / FEE_DIVIDER; //safe math needed?
150 
151         require(price <= msg.value); //revert if not enough ether send
152 
153         if (price != msg.value) {//send back to much eth
154             msg.sender.transfer(msg.value - price);
155         }
156 
157         beneficiary.transfer(totalFee);
158 
159         auction.seller.transfer(price - totalFee);
160 
161         if (!ERC721Contract.transfer(msg.sender, _tokenId)) {
162             revert();
163             //can't complete transfer if this fails
164         }
165 
166         AuctionWon(_tokenId, msg.sender, auction.seller, price);
167 
168         delete auctions[_tokenId];
169         //deletes auction
170     }
171 
172     function saveToken(uint256 _tokenId) external {
173         require(auctions[_tokenId].auctionEnd < now);
174         //auction must have ended
175         require(ERC721Contract.transfer(auctions[_tokenId].seller, _tokenId));
176         //transfer fish back to seller
177 
178         AuctionFinalized(_tokenId, auctions[_tokenId].seller);
179 
180         delete auctions[_tokenId];
181         //delete auction
182     }
183 
184     function ERC721Auction(address _ERC721Contract) public {
185         ERC721Contract = ERC721(_ERC721Contract);
186     }
187 
188     function setFee(uint256 _fee) onlyOwner public {
189         if (_fee > fee) {
190             revert(); //fee can only be set to lower value to prevent attacks by owner
191         }
192         fee = _fee; // all is well set fee
193     }
194 
195     function calculateBid(uint256 _tokenId) public view returns (uint256) {
196         Auction storage auction = auctions[_tokenId];
197 
198         if (now >= auction.auctionEnd) {//if auction ended return auction end price
199             return auction.endPrice;
200         }
201         //get hours passed
202         uint256 hoursPassed = (now - auction.auctionBegin) / 1 hours;
203         uint256 currentPrice;
204         //get total hours
205         uint16 totalHours = uint16(auctionDuration /1 hours) - 1;
206 
207         if (auction.endPrice > auction.startPrice) {
208             currentPrice = auction.startPrice + (hoursPassed * (auction.endPrice - auction.startPrice))/ totalHours;
209         } else if(auction.endPrice < auction.startPrice) {
210             currentPrice = auction.startPrice - (hoursPassed * (auction.startPrice - auction.endPrice))/ totalHours;
211         } else {//start and end are the same
212             currentPrice = auction.endPrice;
213         }
214 
215         return uint256(currentPrice);
216         //return the price at this very moment
217     }
218 
219     /// return token if case when need to redeploy auction contract
220     function returnToken(uint256 _tokenId) onlyOwner public {
221         require(ERC721Contract.transfer(auctions[_tokenId].seller, _tokenId));
222         //transfer fish back to seller
223 
224         AuctionFinalized(_tokenId, auctions[_tokenId].seller);
225 
226         delete auctions[_tokenId];
227     }
228 }