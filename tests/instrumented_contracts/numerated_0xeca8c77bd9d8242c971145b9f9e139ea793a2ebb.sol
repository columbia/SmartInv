1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     emit OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 }
23 
24 contract CryptoRomeControl is Ownable {
25 
26     bool public paused = false;
27 
28     modifier whenNotPaused() {
29         require(!paused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(paused);
35         _;
36     }
37 
38     function pause() external onlyOwner whenNotPaused {
39         paused = true;
40     }
41 
42     function unpause() public onlyOwner whenPaused {
43         paused = false;
44     }
45 }
46 
47 contract ERC721 {
48     function balanceOf(address _owner) public view returns (uint256 _balance);
49     function ownerOf(uint256 _tokenId) public view returns (address _owner);
50     function transfer(address _to, uint256 _tokenId) public;
51     function approve(address _to, uint256 _tokenId) public;
52     function takeOwnership(uint256 _tokenId) public;
53     function totalSupply() public view returns (uint256 total);
54 }
55 
56 contract CryptoRomeAuction is CryptoRomeControl {
57 
58     // Reference to contract tracking NFT ownership
59     ERC721 public nonFungibleContract;
60 
61     uint256 public auctionStart;
62     uint256 public startingPrice;
63     uint256 public endingPrice;
64     uint256 public auctionEnd;
65     uint256 public extensionTime;
66     uint256 public highestBid;
67     address public highestBidder;
68     bytes32 public highestBidderCC;
69     bool public highestBidIsCC;
70     address public paymentAddress;
71     uint256 public tokenId;
72     bool public ended;
73 
74     event Bid(address from, uint256 amount);
75     event AuctionEnded(address winnerMetamask, bytes32 winnerCC, uint256 amount);
76 
77     constructor(address _nftAddress) public {
78         nonFungibleContract = ERC721(_nftAddress);
79     }
80 
81     function createAuction(uint256 _startTime, uint256 _startingPrice, uint256 _duration, uint256 _extensionTime, address _wallet, uint256 _tokenId) public onlyOwner {
82         require(nonFungibleContract.ownerOf(_tokenId) == owner);
83         require(_wallet != address(0));
84         require(_duration > 0);
85         require(_duration >= _extensionTime);
86         auctionStart = _startTime;
87         startingPrice = _startingPrice;
88         auctionEnd = (SafeMath.add(auctionStart, _duration));
89         extensionTime = _extensionTime;
90         paymentAddress = _wallet;
91         tokenId = _tokenId;
92         highestBid = 0;
93         _escrow(_tokenId);
94     }
95 
96     function getAuctionData() public view returns(uint256, uint256, uint256, address, bytes32) {
97         return(auctionStart, auctionEnd, highestBid, highestBidder, highestBidderCC);
98     }
99 
100     function _isContract(address _user) internal view returns (bool) {
101         uint size;
102         assembly { size := extcodesize(_user) }
103         return size > 0;
104     }
105 
106     // Escrows the NFT, assigning ownership to this contract.
107     function _escrow(uint256 _tokenId) internal {
108         nonFungibleContract.takeOwnership(_tokenId);
109     }
110 
111     // Transfers an NFT owned by this contract to another address.
112     function _transfer(address _receiver, uint256 _tokenId) internal {
113         nonFungibleContract.transfer(_receiver, _tokenId);
114     }
115 
116     function auctionStarted() public view returns (bool) {
117         if (auctionStart != 0) {
118           return now > auctionStart;
119         } else {
120           return false;
121         }
122     }
123 
124     function auctionExpired() public view returns (bool) {
125         return now > auctionEnd;
126     }
127 
128     function bid() public payable {
129         require(!_isContract(msg.sender));
130         require(auctionStarted());
131         require(!auctionExpired());
132         require(msg.value >= (highestBid + 10000000000000000));
133 
134         if (highestBid != 0) {
135             if (!highestBidIsCC) {
136                 highestBidder.transfer(highestBid);
137             }
138         }
139 
140         if (now > SafeMath.sub(auctionEnd, extensionTime)) {
141             // If within extention time window, extend auction
142             auctionEnd = SafeMath.add(now,extensionTime);
143         }
144 
145         highestBidder = msg.sender;
146         highestBid = msg.value;
147         highestBidIsCC = false;
148         highestBidderCC = "";
149 
150         emit Bid(msg.sender, msg.value);
151     }
152 
153     function bidCC(uint256 value, bytes32 userId) onlyOwner public {
154         require(auctionStarted());
155         require(!auctionExpired());
156         require(value >= (highestBid + 10000000000000000));
157 
158         if (highestBid != 0) {
159             if (!highestBidIsCC) {
160                 highestBidder.transfer(highestBid);
161                 highestBidder = address(0);
162             }
163         }
164 
165         if (now > SafeMath.sub(auctionEnd, extensionTime)) {
166             // If within extention time window, extend auction
167             auctionEnd = SafeMath.add(now,extensionTime);
168         }
169 
170         highestBidderCC = userId;
171         highestBid = value;
172         highestBidIsCC = true;
173 
174         emit Bid(msg.sender, value);
175     }
176 
177     function endAuction() public onlyOwner {
178         require(auctionExpired());
179         require(!ended);
180         ended = true;
181         emit AuctionEnded(highestBidder, highestBidderCC, highestBid);
182         // Transfer the item to the buyer
183         if (!highestBidIsCC) {
184             _transfer(highestBidder, tokenId);
185             paymentAddress.transfer(address(this).balance);
186         }
187     }
188 
189     function approveTransfer(uint256 approved, address winnerAddress) public onlyOwner {
190         require(ended);
191         // Follow-up step for CC transfer that needs approval
192         if (approved > 0) {
193             _transfer(winnerAddress, tokenId);
194         } else {
195             _transfer(owner, tokenId);
196         }
197     }
198 }
199 
200 
201 library SafeMath {
202   /**
203   * @dev Multiplies two numbers, throws on overflow.
204   */
205   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206     if (a == 0) {
207       return 0;
208     }
209     uint256 c = a * b;
210     assert(c / a == b);
211     return c;
212   }
213 
214   /**
215   * @dev Integer division of two numbers, truncating the quotient.
216   */
217   function div(uint256 a, uint256 b) internal pure returns (uint256) {
218     // assert(b > 0); // Solidity automatically throws when dividing by 0
219     uint256 c = a / b;
220     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221     return c;
222   }
223   /**
224   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
225   */
226   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227     assert(b <= a);
228     return a - b;
229   }
230   /**
231   * @dev Adds two numbers, throws on overflow.
232   */
233   function add(uint256 a, uint256 b) internal pure returns (uint256) {
234     uint256 c = a + b;
235     assert(c >= a);
236     return c;
237   }
238 }