1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5   address public ceoWallet;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   constructor() public {
10     owner = msg.sender;
11     ceoWallet = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     require(msg.sender == owner);
16     _;
17   }
18 
19   function transferOwnership(address newOwner) public onlyOwner {
20     require(newOwner != address(0));
21     emit OwnershipTransferred(owner, newOwner);
22     owner = newOwner;
23   }
24 }
25 
26 // Interface for contracts conforming to ERC-721: Non-Fungible Tokens
27 contract ERC721 {
28   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
29   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
30 
31   function balanceOf(address _owner) public view returns (uint256 _balance);
32   function ownerOf(uint256 _tokenId) public view returns (address _owner);
33   function transfer(address _to, uint256 _tokenId) public;
34   function approve(address _to, uint256 _tokenId) public;
35   function takeOwnership(uint256 _tokenId) public;
36   function totalSupply() public view returns (uint256 total);
37 }
38 
39 
40 contract CryptoRomeControl is Ownable {
41 
42     bool public paused = false;
43 
44     modifier whenNotPaused() {
45         require(!paused);
46         _;
47     }
48 
49     modifier whenPaused {
50         require(paused);
51         _;
52     }
53     
54     function transferWalletOwnership(address newWalletAddress) onlyOwner public {
55       require(newWalletAddress != address(0));
56       ceoWallet = newWalletAddress;
57     }
58 
59     function pause() external onlyOwner whenNotPaused {
60         paused = true;
61     }
62 
63     function unpause() public onlyOwner whenPaused {
64         paused = false;
65     }
66 }
67 
68 contract CryptoRomeAuction is CryptoRomeControl {
69 
70     address public WonderOwnershipAdd;
71     uint256 public auctionStart;
72     uint256 public startingBid;
73     uint256 public auctionDuration;
74     address public highestBidder;
75     uint256 public highestBid;
76     address public paymentAddress;
77     uint256 public wonderId;
78     bool public ended;
79 
80     event Bid(address from, uint256 amount);
81     event AuctionEnded(address winner, uint256 amount);
82 
83     constructor(uint256 _startTime, uint256 _startingBid, uint256 _duration, address wallet, uint256 _wonderId, address developer) public {
84         WonderOwnershipAdd = msg.sender;
85         auctionStart = _startTime;
86         startingBid = _startingBid;
87         auctionDuration = _duration;
88         paymentAddress = wallet;
89         wonderId = _wonderId;
90         transferOwnership(developer);
91     }
92     
93     function getAuctionData() public view returns(uint256, uint256, uint256, address) {
94         return(auctionStart, auctionDuration, highestBid, highestBidder);
95     }
96 
97     function _isContract(address _user) internal view returns (bool) {
98         uint size;
99         assembly { size := extcodesize(_user) }
100         return size > 0;
101     }
102 
103     function auctionExpired() public view returns (bool) {
104         return now > (SafeMath.add(auctionStart, auctionDuration));
105     }
106 
107     function bidOnWonder() public payable {
108         require(!_isContract(msg.sender));
109         require(!auctionExpired());
110         require(msg.value >= (highestBid + 10000000000000000));
111 
112         if (highestBid != 0) {
113             highestBidder.transfer(highestBid);
114         }
115 
116         highestBidder = msg.sender;
117         highestBid = msg.value;
118 
119         emit Bid(msg.sender, msg.value);
120     }
121 
122     function endAuction() public onlyOwner {
123         require(auctionExpired());
124         require(!ended);
125         ended = true;
126         emit AuctionEnded(highestBidder, highestBid);
127         // Transfer the item to the buyer
128         Wonder(WonderOwnershipAdd).transfer(highestBidder, wonderId);
129 
130         paymentAddress.transfer(address(this).balance);
131     }
132 }
133 
134 contract Wonder is ERC721, CryptoRomeControl {
135     
136     // Name and symbol of the non fungible token, as defined in ERC721.
137     string public constant name = "CryptoRomeWonder";
138     string public constant symbol = "CROMEW";
139 
140     uint256[] internal allWonderTokens;
141 
142     mapping(uint256 => string) internal tokenURIs;
143     address public originalAuction;
144     mapping (uint256 => bool) public wonderForSale;
145     mapping (uint256 => uint256) public askingPrice;
146 
147     // Map of Wonder to the owner
148     mapping (uint256 => address) public wonderIndexToOwner;
149     mapping (address => uint256) ownershipTokenCount;
150     mapping (uint256 => address) wonderIndexToApproved;
151     
152     modifier onlyOwnerOf(uint256 _tokenId) {
153         require(wonderIndexToOwner[_tokenId] == msg.sender);
154         _;
155     }
156 
157     function updateTokenUri(uint256 _tokenId, string _tokenURI) public whenNotPaused onlyOwner {
158         _setTokenURI(_tokenId, _tokenURI);
159     }
160 
161     function startWonderAuction(string _tokenURI, address wallet) public whenNotPaused onlyOwner {
162         uint256 finalId = _createWonder(msg.sender);
163         _setTokenURI(finalId, _tokenURI);
164         //Starting auction
165         originalAuction = new CryptoRomeAuction(now, 10 finney, 1 weeks, wallet, finalId, msg.sender);
166         _transfer(msg.sender, originalAuction, finalId);
167     }
168     
169     function createWonderNotAuction(string _tokenURI) public whenNotPaused onlyOwner returns (uint256) {
170         uint256 finalId = _createWonder(msg.sender);
171         _setTokenURI(finalId, _tokenURI);
172         return finalId;
173     }
174     
175     function sellWonder(uint256 _wonderId, uint256 _askingPrice) onlyOwnerOf(_wonderId) whenNotPaused public {
176         wonderForSale[_wonderId] = true;
177         askingPrice[_wonderId] = _askingPrice;
178     }
179     
180     function cancelWonderSale(uint256 _wonderId) onlyOwnerOf(_wonderId) whenNotPaused public {
181         wonderForSale[_wonderId] = false;
182         askingPrice[_wonderId] = 0;
183     }
184     
185     function purchaseWonder(uint256 _wonderId) whenNotPaused public payable {
186         require(wonderForSale[_wonderId]);
187         require(msg.value >= askingPrice[_wonderId]);
188         wonderForSale[_wonderId] = false;
189         uint256 fee = devFee(msg.value);
190         ceoWallet.transfer(fee);
191         wonderIndexToOwner[_wonderId].transfer(SafeMath.sub(address(this).balance, fee));
192         _transfer(wonderIndexToOwner[_wonderId], msg.sender, _wonderId);
193     }
194     
195     function _transfer(address _from, address _to, uint256 _tokenId) internal {
196         ownershipTokenCount[_to] = SafeMath.add(ownershipTokenCount[_to], 1);
197         wonderIndexToOwner[_tokenId] = _to;
198         if (_from != address(0)) {
199             // clear any previously approved ownership exchange
200             ownershipTokenCount[_from] = SafeMath.sub(ownershipTokenCount[_from], 1);
201             delete wonderIndexToApproved[_tokenId];
202         }
203     }
204 
205     function _createWonder(address _owner) internal returns (uint) {
206         uint256 newWonderId = allWonderTokens.push(allWonderTokens.length) - 1;
207         wonderForSale[newWonderId] = false;
208 
209         // Only 8 wonders should ever exist (0-7)
210         require(newWonderId < 8);
211         _transfer(0, _owner, newWonderId);
212         return newWonderId;
213     }
214     
215     function devFee(uint256 amount) internal pure returns(uint256){
216         return SafeMath.div(SafeMath.mul(amount, 3), 100);
217     }
218     
219     // Functions for ERC721 Below:
220 
221     // Check is address has approval to transfer wonder.
222     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
223         return wonderIndexToApproved[_tokenId] == _claimant;
224     }
225 
226     function exists(uint256 _tokenId) public view returns (bool) {
227         address owner = wonderIndexToOwner[_tokenId];
228         return owner != address(0);
229     }
230 
231     function tokenURI(uint256 _tokenId) public view returns (string) {
232         require(exists(_tokenId));
233         return tokenURIs[_tokenId];
234     }
235 
236     function _setTokenURI(uint256 _tokenId, string _uri) internal {
237         require(exists(_tokenId));
238         tokenURIs[_tokenId] = _uri;
239     }
240 
241     // Sets a wonder as approved for transfer to another address.
242     function _approve(uint256 _tokenId, address _approved) internal {
243         wonderIndexToApproved[_tokenId] = _approved;
244     }
245 
246     // Returns the number of Wonders owned by a specific address.
247     function balanceOf(address _owner) public view returns (uint256 count) {
248         return ownershipTokenCount[_owner];
249     }
250 
251     // Transfers a Wonder to another address. If transferring to a smart
252     // contract ensure that it is aware of ERC-721.
253     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
254         require(_to != address(0));
255         require(_to != address(this));
256 
257         _transfer(msg.sender, _to, _tokenId);
258         emit Transfer(msg.sender, _to, _tokenId);
259     }
260 
261     //  Permit another address the right to transfer a specific Wonder via
262     //  transferFrom(). 
263     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
264         _approve(_tokenId, _to);
265 
266         emit Approval(msg.sender, _to, _tokenId);
267     }
268 
269     // Transfer a Wonder owned by another address, for which the calling address
270     // has previously been granted transfer approval by the owner.
271     function takeOwnership(uint256 _tokenId) public {
272 
273     require(wonderIndexToApproved[_tokenId] == msg.sender);
274     address owner = ownerOf(_tokenId);
275     _transfer(owner, msg.sender, _tokenId);
276     emit Transfer(owner, msg.sender, _tokenId);
277 
278   }
279 
280     // Eight Wonders will ever exist
281     function totalSupply() public view returns (uint) {
282         return 8;
283     }
284 
285     function ownerOf(uint256 _tokenId) public view returns (address owner)
286     {
287         owner = wonderIndexToOwner[_tokenId];
288         require(owner != address(0));
289     }
290 
291     // List of all Wonder IDs assigned to an address.
292     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
293         uint256 tokenCount = balanceOf(_owner);
294 
295         if (tokenCount == 0) {
296             return new uint256[](0);
297         } else {
298             uint256[] memory result = new uint256[](tokenCount);
299             uint256 totalWonders = totalSupply();
300             uint256 resultIndex = 0;
301             uint256 wonderId;
302 
303             for (wonderId = 0; wonderId < totalWonders; wonderId++) {
304                 if (wonderIndexToOwner[wonderId] == _owner) {
305                     result[resultIndex] = wonderId;
306                     resultIndex++;
307                 }
308             }
309             return result;
310         }
311     }
312 }
313 
314 library SafeMath {
315   /**
316   * @dev Multiplies two numbers, throws on overflow.
317   */
318   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319     if (a == 0) {
320       return 0;
321     }
322     uint256 c = a * b;
323     assert(c / a == b);
324     return c;
325   }
326 
327   /**
328   * @dev Integer division of two numbers, truncating the quotient.
329   */
330   function div(uint256 a, uint256 b) internal pure returns (uint256) {
331     // assert(b > 0); // Solidity automatically throws when dividing by 0
332     uint256 c = a / b;
333     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
334     return c;
335   }
336   /**
337   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
338   */
339   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340     assert(b <= a);
341     return a - b;
342   }
343   /**
344   * @dev Adds two numbers, throws on overflow.
345   */
346   function add(uint256 a, uint256 b) internal pure returns (uint256) {
347     uint256 c = a + b;
348     assert(c >= a);
349     return c;
350   }
351 }