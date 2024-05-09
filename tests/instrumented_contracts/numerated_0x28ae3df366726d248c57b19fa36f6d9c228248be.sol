1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/Beneficiary.sol
68 
69 // solhint-disable-next-line
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /** @title Beneficiary */
75 contract Beneficiary is Ownable {
76     address public beneficiary;
77 
78     constructor() public {
79         beneficiary = msg.sender;
80     }
81 
82     /**
83      * @dev Change the beneficiary address
84      * @param _beneficiary Address of the new beneficiary
85      */
86     function setBeneficiary(address _beneficiary) public onlyOwner {
87         beneficiary = _beneficiary;
88     }
89 }
90 
91 // File: contracts/Affiliate.sol
92 
93 // solhint-disable-next-line
94 pragma solidity ^0.4.25;
95 
96 
97 
98 /** @title Affiliate */
99 contract Affiliate is Ownable {
100     mapping(address => bool) public canSetAffiliate;
101     mapping(address => address) public userToAffiliate;
102 
103     /** @dev Allows an address to set the affiliate address for a user
104       * @param _setter The address that should be allowed
105       */
106     function setAffiliateSetter(address _setter) public onlyOwner {
107         canSetAffiliate[_setter] = true;
108     }
109 
110     /**
111      * @dev Set the affiliate of a user
112      * @param _user user to set affiliate for
113      * @param _affiliate address to set
114      */
115     function setAffiliate(address _user, address _affiliate) public {
116         require(canSetAffiliate[msg.sender]);
117         if (userToAffiliate[_user] == address(0)) {
118             userToAffiliate[_user] = _affiliate;
119         }
120     }
121 
122 }
123 
124 // File: contracts/interfaces/ERC721.sol
125 
126 contract ERC721 {
127     function implementsERC721() public pure returns (bool);
128     function totalSupply() public view returns (uint256 total);
129     function balanceOf(address _owner) public view returns (uint256 balance);
130     function ownerOf(uint256 _tokenId) public view returns (address owner);
131     function approve(address _to, uint256 _tokenId) public;
132     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) ;
133     function transfer(address _to, uint256 _tokenId) public returns (bool);
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     // Optional
138     // function name() public view returns (string name);
139     // function symbol() public view returns (string symbol);
140     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
141     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
142 }
143 
144 // File: contracts/interfaces/PepeInterface.sol
145 
146 contract PepeInterface is ERC721{
147     function cozyTime(uint256 _mother, uint256 _father, address _pepeReceiver) public returns (bool);
148     function getCozyAgain(uint256 _pepeId) public view returns(uint64);
149 }
150 
151 // File: contracts/AuctionBase.sol
152 
153 // solhint-disable-next-line
154 pragma solidity ^0.4.24;
155 
156 
157 
158 
159 
160 /** @title AuctionBase */
161 contract AuctionBase is Beneficiary {
162     mapping(uint256 => PepeAuction) public auctions;//maps pepes to auctions
163     PepeInterface public pepeContract;
164     Affiliate public affiliateContract;
165     uint256 public fee = 37500; //in 1 10000th of a percent so 3.75% at the start
166     uint256 public constant FEE_DIVIDER = 1000000; //Perhaps needs better name?
167 
168     struct PepeAuction {
169         address seller;
170         uint256 pepeId;
171         uint64 auctionBegin;
172         uint64 auctionEnd;
173         uint256 beginPrice;
174         uint256 endPrice;
175     }
176 
177     event AuctionWon(uint256 indexed pepe, address indexed winner, address indexed seller);
178     event AuctionStarted(uint256 indexed pepe, address indexed seller);
179     event AuctionFinalized(uint256 indexed pepe, address indexed seller);
180 
181     constructor(address _pepeContract, address _affiliateContract) public {
182         pepeContract = PepeInterface(_pepeContract);
183         affiliateContract = Affiliate(_affiliateContract);
184     }
185 
186     /**
187      * @dev Return a pepe from a auction that has passed
188      * @param  _pepeId the id of the pepe to save
189      */
190     function savePepe(uint256 _pepeId) external {
191         // solhint-disable-next-line not-rely-on-time
192         require(auctions[_pepeId].auctionEnd < now);//auction must have ended
193         require(pepeContract.transfer(auctions[_pepeId].seller, _pepeId));//transfer pepe back to seller
194 
195         emit AuctionFinalized(_pepeId, auctions[_pepeId].seller);
196 
197         delete auctions[_pepeId];//delete auction
198     }
199 
200     /**
201      * @dev change the fee on pepe sales. Can only be lowerred
202      * @param _fee The new fee to set. Must be lower than current fee
203      */
204     function changeFee(uint256 _fee) external onlyOwner {
205         require(_fee < fee);//fee can not be raised
206         fee = _fee;
207     }
208 
209     /**
210      * @dev Start a auction
211      * @param  _pepeId Pepe to sell
212      * @param  _beginPrice Price at which the auction starts
213      * @param  _endPrice Ending price of the auction
214      * @param  _duration How long the auction should take
215      */
216     function startAuction(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public {
217         require(pepeContract.transferFrom(msg.sender, address(this), _pepeId));
218         // solhint-disable-next-line not-rely-on-time
219         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
220 
221         PepeAuction memory auction;
222 
223         auction.seller = msg.sender;
224         auction.pepeId = _pepeId;
225         // solhint-disable-next-line not-rely-on-time
226         auction.auctionBegin = uint64(now);
227         // solhint-disable-next-line not-rely-on-time
228         auction.auctionEnd = uint64(now) + _duration;
229         require(auction.auctionEnd > auction.auctionBegin);
230         auction.beginPrice = _beginPrice;
231         auction.endPrice = _endPrice;
232 
233         auctions[_pepeId] = auction;
234 
235         emit AuctionStarted(_pepeId, msg.sender);
236     }
237 
238     /**
239      * @dev directly start a auction from the PepeBase contract
240      * @param  _pepeId Pepe to put on auction
241      * @param  _beginPrice Price at which the auction starts
242      * @param  _endPrice Ending price of the auction
243      * @param  _duration How long the auction should take
244      * @param  _seller The address selling the pepe
245      */
246     // solhint-disable-next-line max-line-length
247     function startAuctionDirect(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration, address _seller) public {
248         require(msg.sender == address(pepeContract)); //can only be called by pepeContract
249         //solhint-disable-next-line not-rely-on-time
250         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
251 
252         PepeAuction memory auction;
253 
254         auction.seller = _seller;
255         auction.pepeId = _pepeId;
256         // solhint-disable-next-line not-rely-on-time
257         auction.auctionBegin = uint64(now);
258         // solhint-disable-next-line not-rely-on-time
259         auction.auctionEnd = uint64(now) + _duration;
260         require(auction.auctionEnd > auction.auctionBegin);
261         auction.beginPrice = _beginPrice;
262         auction.endPrice = _endPrice;
263 
264         auctions[_pepeId] = auction;
265 
266         emit AuctionStarted(_pepeId, _seller);
267     }
268 
269   /**
270    * @dev Calculate the current price of a auction
271    * @param  _pepeId the pepeID to calculate the current price for
272    * @return currentBid the current price for the auction
273    */
274     function calculateBid(uint256 _pepeId) public view returns(uint256 currentBid) {
275         PepeAuction storage auction = auctions[_pepeId];
276         // solhint-disable-next-line not-rely-on-time
277         uint256 timePassed = now - auctions[_pepeId].auctionBegin;
278 
279         // If auction ended return auction end price.
280         // solhint-disable-next-line not-rely-on-time
281         if (now >= auction.auctionEnd) {
282             return auction.endPrice;
283         } else {
284             // Can be negative
285             int256 priceDifference = int256(auction.endPrice) - int256(auction.beginPrice);
286             // Always positive
287             int256 duration = int256(auction.auctionEnd) - int256(auction.auctionBegin);
288 
289             // As already proven in practice by CryptoKitties:
290             //  timePassed -> 64 bits at most
291             //  priceDifference -> 128 bits at most
292             //  timePassed * priceDifference -> 64 + 128 bits at most
293             int256 priceChange = priceDifference * int256(timePassed) / duration;
294 
295             // Will be positive, both operands are less than 256 bits
296             int256 price = int256(auction.beginPrice) + priceChange;
297 
298             return uint256(price);
299         }
300     }
301 
302   /**
303    * @dev collect the fees from the auction
304    */
305     function getFees() public {
306         beneficiary.transfer(address(this).balance);
307     }
308 
309 
310 }
311 
312 // File: contracts/PepeAuctionSale.sol
313 
314 // solhint-disable-next-line
315 pragma solidity ^0.4.19;
316 
317 
318 
319 //Most functionality is in the AuctionBase contract.
320 //This contract is to buy pepes on the auction.
321 contract PepeAuctionSale is AuctionBase {
322   // solhint-disable-next-line
323     constructor(address _pepeContract, address _affiliateContract) AuctionBase(_pepeContract, _affiliateContract) public {
324 
325     }
326 
327     /**
328      * @dev Buy a pepe from the auction
329      * @param  _pepeId The id of the pepe to buy
330      */
331     function buyPepe(uint256 _pepeId) public payable {
332         PepeAuction storage auction = auctions[_pepeId];
333 
334         // solhint-disable-next-line not-rely-on-time
335         require(now < auction.auctionEnd);// auction must be still going
336 
337         uint256 price = calculateBid(_pepeId);
338         require(msg.value >= price); //must send enough ether
339         uint256 totalFee = price * fee / FEE_DIVIDER; //safe math needed?
340 
341         //Send ETH to seller
342         auction.seller.transfer(price - totalFee);
343         //send ETH to beneficiary
344 
345         // solhint-disable-next-line
346         if(affiliateContract.userToAffiliate(msg.sender) != address(0) && affiliateContract.userToAffiliate(msg.sender).send(totalFee / 2)) { //if user has affiliate
347             //nothing to do here. Just to suppress warning
348         }
349         //Send pepe to buyer
350         if (!pepeContract.transfer(msg.sender, _pepeId)) {
351             revert(); //can't complete transfer if this fails
352         }
353 
354         emit AuctionWon(_pepeId, msg.sender, auction.seller);
355 
356         if (msg.value > price) { //return ether send to much
357             msg.sender.transfer(msg.value - price);
358         }
359 
360         delete auctions[_pepeId];//deletes auction
361     }
362 
363     /**
364      * @dev Buy a pepe and send along affiliate address
365      * @param  _pepeId The id of the pepe to buy
366      * @param  _affiliate address of the affiliate to set
367      */
368     // solhint-disable-next-line func-order
369     function buyPepeAffiliated(uint256 _pepeId, address _affiliate) external payable {
370         affiliateContract.setAffiliate(msg.sender, _affiliate);
371         buyPepe(_pepeId);
372     }
373 
374 }