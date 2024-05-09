1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 interface Etheria {
5   function getOwner(uint8 col, uint8 row) external view returns(address);
6   function setOwner(uint8 col, uint8 row, address newOwner) external;
7 }
8 
9 interface MapElevationRetriever {
10   function getElevation(uint8 col, uint8 row) external view returns (uint8);
11 }
12 
13 contract EtheriaExchangeXL {
14 
15   address public owner;
16   address public pendingOwner;
17 
18   string public name = "EtheriaExchangeXL";
19 
20   Etheria public constant etheria = Etheria(address(0xB21f8684f23Dbb1008508B4DE91a0aaEDEbdB7E4));
21   MapElevationRetriever public constant mapElevationRetriever = MapElevationRetriever(address(0x68549D7Dbb7A956f955Ec1263F55494f05972A6b));
22 
23   uint128 public minBid = uint128(1 ether); // setting this to 10 finney throws compilation error for some reason
24   uint256 public feeRate = uint256(100);  // in basis points (100 is 1%)
25   uint256 public collectedFees;
26 
27   struct Bid {
28     uint128 amount;
29     uint8 minCol;        // shortened all of these for readability
30     uint8 maxCol;
31     uint8 minRow;
32     uint8 maxRow;
33     uint8 minEle;
34     uint8 maxEle;
35     uint8 minWat;
36     uint8 maxWat;
37     uint64 biddersIndex; // renamed from bidderIndex because it's the Index of the bidders array
38   }
39 
40   address[] public bidders;
41 
42   mapping (address => Bid) public bidOf;                                          // renamed these three to be ultra-descriptive
43   mapping (address => uint256) public pendingWithdrawalOf;
44   mapping (uint16 => uint128) public askFor;
45 
46   event OwnershipTransferInitiated(address indexed owner, address indexed pendingOwner);    // renamed some of these to conform to past tense verbs
47   event OwnershipTransferAccepted(address indexed oldOwner, address indexed newOwner);
48   event BidCreated(address indexed bidder, uint128 indexed amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
49   event BidAccepted(address indexed seller, address indexed bidder, uint16 indexed index, uint128 amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
50   event BidCancelled(address indexed bidder, uint128 indexed amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
51   event AskCreated(address indexed owner, uint256 indexed price, uint16 indexed index);
52   event AskRemoved(address indexed owner, uint256 indexed price, uint16 indexed index);
53   event WithdrawalProcessed(address indexed account, address indexed destination, uint256 indexed amount);
54   
55   constructor() {
56     owner = msg.sender;
57   }
58 
59   modifier onlyOwner() {
60     require(msg.sender == owner, "EEXL: Not owner");
61     _;
62   }
63 
64   function transferOwnership(address newOwner) external onlyOwner {
65     pendingOwner = newOwner;
66     emit OwnershipTransferInitiated(msg.sender, newOwner);
67   }
68 
69   function acceptOwnership() external {
70     require(msg.sender == pendingOwner, "EEXL: Not pending owner");
71     emit OwnershipTransferAccepted(owner, msg.sender);
72     owner = msg.sender;
73     pendingOwner = address(0);
74   }
75 
76   function _safeTransferETH(address recipient, uint256 amount) internal {
77     // Secure transfer of ETH that is much less likely to be broken by future gas-schedule EIPs
78     (bool success, ) = recipient.call{ value: amount }(""); // syntax: (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(encoded function and data)
79     require(success, "EEXL: ETH transfer failed");
80   }
81 
82   function collectFees() external onlyOwner {
83     uint256 amount = collectedFees;
84     collectedFees = uint256(0);
85     _safeTransferETH(msg.sender, amount);
86   }
87 
88   function setFeeRate(uint256 newFeeRate) external onlyOwner {
89     // Set the feeRate to newFeeRate, then validate it
90     require((feeRate = newFeeRate) <= uint256(500), "EEXL: Invalid feeRate"); // feeRate will revert if req fails
91   }
92 
93   function setMinBid(uint128 newMinBid) external onlyOwner {
94     minBid = newMinBid;                                                     // doubly beneficial because I could effectively kill new bids with a huge minBid 
95   }                                                                         // in the event of an exchange upgrade or unforseen problem
96 
97   function _getIndex(uint8 col, uint8 row) internal pure returns (uint16) {
98     require(_isValidColOrRow(col) && _isValidColOrRow(row), "EEXL: Invalid col and/or row");
99     return (uint16(col) * uint16(33)) + uint16(row);
100   }
101   
102   function _isValidColOrRow(uint8 value) internal pure returns (bool) {
103     return (value >= uint8(0)) && (value <= uint8(32));                    // while nobody should be checking, eg, getAsk when row/col=0/32, we do want to respond non-erroneously
104   }
105 
106   function _isValidElevation(uint8 value) internal pure returns (bool) {
107     return (value >= uint8(125)) && (value <= uint8(216));
108   }
109 
110   function _isWater(uint8 col, uint8 row) internal view returns (bool) {
111     return mapElevationRetriever.getElevation(col, row) < uint8(125);   
112   }
113 
114   function _boolToUint8(bool value) internal pure returns (uint8) {
115     return value ? uint8(1) : uint8(0);
116   }
117 
118   function _getSurroundingWaterCount(uint8 col, uint8 row) internal view returns (uint8 waterTiles) {  
119     require((col >= uint8(1)) && (col <= uint8(31)), "EEXL: Water counting requres col 1-31");
120     require((row >= uint8(1)) && (row <= uint8(31)), "EEXL: Water counting requres col 1-31");
121     if (row % uint8(2) == uint8(1)) {
122       waterTiles += _boolToUint8(_isWater(col + uint8(1), row + uint8(1)));  // northeast_hex
123       waterTiles += _boolToUint8(_isWater(col + uint8(1), row - uint8(1)));  // southeast_hex
124     } else {
125       waterTiles += _boolToUint8(_isWater(col - uint8(1), row - uint8(1)));  // southwest_hex
126       waterTiles += _boolToUint8(_isWater(col - uint8(1), row + uint8(1)));  // northwest_hex
127     }
128 
129     waterTiles += _boolToUint8(_isWater(col, row - uint8(1)));               // southwest_hex or southeast_hex
130     waterTiles += _boolToUint8(_isWater(col, row + uint8(1)));               // northwest_hex or northeast_hex
131     waterTiles += _boolToUint8(_isWater(col + uint8(1), row));               // east_hex
132     waterTiles += _boolToUint8(_isWater(col - uint8(1), row));               // west_hex
133   }
134 
135   function getBidders() public view returns (address[] memory) {
136     return bidders;
137   }
138 
139   function getAsk(uint8 col, uint8 row) public view returns (uint128) {
140     return askFor[_getIndex(col, row)];
141   }
142 
143   // we provide only the land tileIndices to minimize gas usage // should we have this function at all?
144 //   function getAsks(uint16[] calldata tileIndices) external view returns (uint128[] memory asks) {
145 //         uint256 length = tileIndices.length;
146 //         asks = new uint128[](length);
147 //         for (uint256 i; i < length; ++i) {
148 //             asks[i] = askAt(tileIndices[i]);
149 //         }
150 //   }
151 
152   function setAsk(uint8 col, uint8 row, uint128 price) external {
153     require(price > 0, "EEXL: removeAsk instead");
154     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not tile owner");
155     uint16 thisIndex = _getIndex(col, row);
156     emit AskCreated(msg.sender, askFor[thisIndex] = price, thisIndex);
157   }
158   
159   function removeAsk(uint8 col, uint8 row) external {
160     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not tile owner");
161     uint16 thisIndex = _getIndex(col, row);
162     uint128 price = askFor[thisIndex];
163     askFor[thisIndex] = 0;
164     emit AskRemoved(msg.sender, price, thisIndex); // price before it was zeroed
165   }
166 
167   function makeBid(uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat) external payable {
168     require(msg.sender == tx.origin, "EEXL: not EOA");  // (EOA = Externally owned account) // Etheria doesn't allow tile ownership by contracts, this check prevents black-holing
169     
170     require(msg.value <= type(uint128).max, "EEXL: value too high");
171     require(msg.value >= minBid, "EEXL: req bid amt >= minBid");              
172     require(msg.value >= 0, "EEXL: req bid amt >= 0");
173     
174     require(bidOf[msg.sender].amount == uint128(0), "EEXL: bid exists, cancel first");
175 
176     require(_isValidColOrRow(minCol), "EEXL: minCol OOB");
177     require(_isValidColOrRow(maxCol), "EEXL: maxCol OOB");
178     require(minCol <= maxCol, "EEXL: req minCol <= maxCol");
179 
180     require(_isValidColOrRow(minRow), "EEXL: minRow OOB");
181     require(_isValidColOrRow(maxRow), "EEXL: maxRow OOB");
182     require(minRow <= maxRow, "EEXL: req minRow <= maxRow");
183 
184     require(_isValidElevation(minEle), "EEXL: minEle OOB");   // these ele checks prevent water bidding, regardless of row/col
185     require(_isValidElevation(maxEle), "EEXL: maxEle OOB");
186     require(minEle <= maxEle, "EEXL: req minEle <= maxEle");
187 
188     require(minWat <= uint8(6), "EEXL: minWat OOB");
189     require(maxWat <= uint8(6), "EEXL: maxWat OOB");
190     require(minWat <= maxWat, "EEXL: req minWat <= maxWat");
191 
192     uint256 biddersArrayLength = bidders.length;                           
193     require(biddersArrayLength < type(uint64).max, "EEXL: too many bids"); 
194 
195     bidOf[msg.sender] = Bid({
196       amount: uint128(msg.value),
197       minCol: minCol,
198       maxCol: maxCol,
199       minRow: minRow,
200       maxRow: maxRow,
201       minEle: minEle,
202       maxEle: maxEle,
203       minWat: minWat,
204       maxWat: maxWat,
205       biddersIndex: uint64(biddersArrayLength)
206     });
207 
208     bidders.push(msg.sender);
209 
210     emit BidCreated(msg.sender, uint128(msg.value), minCol, maxCol, minRow, maxRow, minEle, maxEle, minWat, maxWat);
211   }
212 
213   function _deleteBid(address bidder, uint64 biddersIndex) internal { // used by cancelBid and acceptBid
214     address lastBidder = bidders[bidders.length - uint256(1)];
215 
216     // If bidder not last bidder, overwrite with last bidder 
217     if (bidder != lastBidder) {
218       bidders[biddersIndex] = lastBidder;            // Overwrite the bidder at the index with the last bidder
219       bidOf[lastBidder].biddersIndex = biddersIndex;  // Update the bidder index of the bid of the previously last bidder
220     }
221 
222     delete bidOf[bidder];
223     bidders.pop();
224   }
225 
226   function cancelBid() external {
227     // Cancels the bid, getting the bid's amount, which is then added account's pending withdrawal
228     Bid storage bid = bidOf[msg.sender];
229     uint128 amount = bid.amount;
230 
231     require(amount != uint128(0), "EEXL: No existing bid");
232 
233     emit BidCancelled(msg.sender, amount, bid.minCol, bid.maxCol, bid.minRow, bid.maxRow, bid.minEle, bid.maxEle, bid.minWat, bid.maxWat);
234 
235     _deleteBid(msg.sender, bid.biddersIndex);
236     pendingWithdrawalOf[msg.sender] += uint256(amount);
237   }
238 
239   function acceptBid(uint8 col, uint8 row, address bidder, uint256 minAmount) external {
240     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not owner"); // etheria.setOwner will fail below if not owner, making this check unnecessary, but I want this here anyway
241     
242     Bid storage bid = bidOf[bidder];
243     uint128 amount = bid.amount;
244 
245     require(
246       (amount >= minAmount) &&
247       (col >= bid.minCol) &&
248       (col <= bid.maxCol) &&
249       (row >= bid.minRow) &&
250       (row <= bid.maxRow) &&
251       (mapElevationRetriever.getElevation(col, row) >= bid.minEle) &&
252       (mapElevationRetriever.getElevation(col, row) <= bid.maxEle) &&
253       (_getSurroundingWaterCount(col, row) >= bid.minWat) &&
254       (_getSurroundingWaterCount(col, row) <= bid.maxWat),
255       "EEXL: tile doesn't meet bid reqs"
256     );
257 
258     emit BidAccepted(msg.sender, bidder, _getIndex(col, row), amount, bid.minCol, bid.maxCol, bid.minRow, bid.maxRow, bid.minEle, bid.maxEle, bid.minWat, bid.maxWat);
259                                                                                                                                                         
260     _deleteBid(bidder, bid.biddersIndex);
261 
262     etheria.setOwner(col, row, bidder);
263     require(etheria.getOwner(col, row) == bidder, "EEXL: failed setting tile owner"); // ok for require after event emission. Events are technically state changes and atomic as well.
264 
265     uint256 fee = (uint256(amount) * feeRate) / uint256(10_000);
266     collectedFees += fee;
267 
268     pendingWithdrawalOf[msg.sender] += (uint256(amount) - fee);
269 
270     delete askFor[_getIndex(col, row)]; // don't emit AskRemoved here. It's not really a removal
271   }
272 
273   function _withdraw(address account, address payable destination) internal {
274     uint256 amount = pendingWithdrawalOf[account];
275     require(amount > uint256(0), "EEXL: nothing pending");
276 
277     pendingWithdrawalOf[account] = uint256(0);
278     _safeTransferETH(destination, amount);
279 
280     emit WithdrawalProcessed(account, destination, amount);
281   }
282 
283   function withdraw(address payable destination) external {
284     _withdraw(msg.sender, destination);
285   }
286 
287   function withdraw() external {
288     _withdraw(msg.sender, payable(msg.sender));
289   }
290 
291 }