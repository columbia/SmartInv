1 pragma solidity >=0.8.0 <0.9.0;
2 
3 interface Etheria {
4   function getOwner(uint8 col, uint8 row) external view returns(address);
5   function setOwner(uint8 col, uint8 row, address newOwner) external;
6 }
7 
8 interface MapElevationRetriever {
9   function getElevation(uint8 col, uint8 row) external view returns (uint8);
10 }
11 
12 contract EtheriaExchangeXL_v1pt1 {
13 
14   address public owner;
15   address public pendingOwner;
16 
17   string public name = "EtheriaExchangeXL_v1pt1";
18 
19   Etheria public constant etheria = Etheria(address(0x169332Ae7D143E4B5c6baEdb2FEF77BFBdDB4011));
20   MapElevationRetriever public constant mapElevationRetriever = MapElevationRetriever(address(0x68549D7Dbb7A956f955Ec1263F55494f05972A6b));
21 
22   uint128 public minBid = uint128(1 ether); // setting this to 10 finney throws compilation error for some reason
23   uint256 public feeRate = uint256(100);  // in basis points (100 is 1%)
24   uint256 public collectedFees;
25 
26   struct Bid {
27     uint128 amount;
28     uint8 minCol;        // shortened all of these for readability
29     uint8 maxCol;
30     uint8 minRow;
31     uint8 maxRow;
32     uint8 minEle;
33     uint8 maxEle;
34     uint8 minWat;
35     uint8 maxWat;
36     uint64 biddersIndex; // renamed from bidderIndex because it's the Index of the bidders array
37   }
38 
39   address[] public bidders;
40 
41   mapping (address => Bid) public bidOf;                                          // renamed these three to be ultra-descriptive
42   mapping (address => uint256) public pendingWithdrawalOf;
43   mapping (uint16 => uint128) public askFor;
44 
45   event OwnershipTransferInitiated(address indexed owner, address indexed pendingOwner);    // renamed some of these to conform to past tense verbs
46   event OwnershipTransferAccepted(address indexed oldOwner, address indexed newOwner);
47   event BidCreated(address indexed bidder, uint128 indexed amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
48   event BidAccepted(address indexed seller, address indexed bidder, uint16 indexed index, uint128 amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
49   event BidCancelled(address indexed bidder, uint128 indexed amount, uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat);
50   event AskCreated(address indexed owner, uint256 indexed price, uint16 indexed index);
51   event AskRemoved(address indexed owner, uint256 indexed price, uint16 indexed index);
52   event WithdrawalProcessed(address indexed account, address indexed destination, uint256 indexed amount);
53   
54   constructor() {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner() {
59     require(msg.sender == owner, "EEXL: Not owner");
60     _;
61   }
62 
63   function transferOwnership(address newOwner) external onlyOwner {
64     pendingOwner = newOwner;
65     emit OwnershipTransferInitiated(msg.sender, newOwner);
66   }
67 
68   function acceptOwnership() external {
69     require(msg.sender == pendingOwner, "EEXL: Not pending owner");
70     emit OwnershipTransferAccepted(owner, msg.sender);
71     owner = msg.sender;
72     pendingOwner = address(0);
73   }
74 
75   function _safeTransferETH(address recipient, uint256 amount) internal {
76     // Secure transfer of ETH that is much less likely to be broken by future gas-schedule EIPs
77     (bool success, ) = recipient.call{ value: amount }(""); // syntax: (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(encoded function and data)
78     require(success, "EEXL: ETH transfer failed");
79   }
80 
81   function collectFees() external onlyOwner {
82     uint256 amount = collectedFees;
83     collectedFees = uint256(0);
84     _safeTransferETH(msg.sender, amount);
85   }
86 
87   function setFeeRate(uint256 newFeeRate) external onlyOwner {
88     // Set the feeRate to newFeeRate, then validate it
89     require((feeRate = newFeeRate) <= uint256(500), "EEXL: Invalid feeRate"); // feeRate will revert if req fails
90   }
91 
92   function setMinBid(uint128 newMinBid) external onlyOwner {
93     minBid = newMinBid;                                                     // doubly beneficial because I could effectively kill new bids with a huge minBid 
94   }                                                                         // in the event of an exchange upgrade or unforseen problem
95 
96   function _getIndex(uint8 col, uint8 row) internal pure returns (uint16) {
97     require(_isValidColOrRow(col) && _isValidColOrRow(row), "EEXL: Invalid col and/or row");
98     return (uint16(col) * uint16(33)) + uint16(row);
99   }
100   
101   function _isValidColOrRow(uint8 value) internal pure returns (bool) {
102     return (value >= uint8(0)) && (value <= uint8(32));                    // while nobody should be checking, eg, getAsk when row/col=0/32, we do want to respond non-erroneously
103   }
104 
105   function _isValidElevation(uint8 value) internal pure returns (bool) {
106     return (value >= uint8(125)) && (value <= uint8(216));
107   }
108 
109   function _isWater(uint8 col, uint8 row) internal view returns (bool) {
110     return mapElevationRetriever.getElevation(col, row) < uint8(125);   
111   }
112 
113   function _boolToUint8(bool value) internal pure returns (uint8) {
114     return value ? uint8(1) : uint8(0);
115   }
116 
117   function _getSurroundingWaterCount(uint8 col, uint8 row) internal view returns (uint8 waterTiles) {  
118     require((col >= uint8(1)) && (col <= uint8(31)), "EEXL: Water counting requres col 1-31");
119     require((row >= uint8(1)) && (row <= uint8(31)), "EEXL: Water counting requres col 1-31");
120     if (row % uint8(2) == uint8(1)) {
121       waterTiles += _boolToUint8(_isWater(col + uint8(1), row + uint8(1)));  // northeast_hex
122       waterTiles += _boolToUint8(_isWater(col + uint8(1), row - uint8(1)));  // southeast_hex
123     } else {
124       waterTiles += _boolToUint8(_isWater(col - uint8(1), row - uint8(1)));  // southwest_hex
125       waterTiles += _boolToUint8(_isWater(col - uint8(1), row + uint8(1)));  // northwest_hex
126     }
127 
128     waterTiles += _boolToUint8(_isWater(col, row - uint8(1)));               // southwest_hex or southeast_hex
129     waterTiles += _boolToUint8(_isWater(col, row + uint8(1)));               // northwest_hex or northeast_hex
130     waterTiles += _boolToUint8(_isWater(col + uint8(1), row));               // east_hex
131     waterTiles += _boolToUint8(_isWater(col - uint8(1), row));               // west_hex
132   }
133 
134   function getBidders() public view returns (address[] memory) {
135     return bidders;
136   }
137 
138   function getAsk(uint8 col, uint8 row) public view returns (uint128) {
139     return askFor[_getIndex(col, row)];
140   }
141 
142   // we provide only the land tileIndices to minimize gas usage // should we have this function at all?
143 //   function getAsks(uint16[] calldata tileIndices) external view returns (uint128[] memory asks) {
144 //         uint256 length = tileIndices.length;
145 //         asks = new uint128[](length);
146 //         for (uint256 i; i < length; ++i) {
147 //             asks[i] = askAt(tileIndices[i]);
148 //         }
149 //   }
150 
151   function setAsk(uint8 col, uint8 row, uint128 price) external {
152     require(price > 0, "EEXL: removeAsk instead");
153     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not tile owner");
154     uint16 thisIndex = _getIndex(col, row);
155     emit AskCreated(msg.sender, askFor[thisIndex] = price, thisIndex);
156   }
157   
158   function removeAsk(uint8 col, uint8 row) external {
159     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not tile owner");
160     uint16 thisIndex = _getIndex(col, row);
161     uint128 price = askFor[thisIndex];
162     askFor[thisIndex] = 0;
163     emit AskRemoved(msg.sender, price, thisIndex); // price before it was zeroed
164   }
165 
166   function makeBid(uint8 minCol, uint8 maxCol, uint8 minRow, uint8 maxRow, uint8 minEle, uint8 maxEle, uint8 minWat, uint8 maxWat) external payable {
167     require(msg.sender == tx.origin, "EEXL: not EOA");  // (EOA = Externally owned account) // Etheria doesn't allow tile ownership by contracts, this check prevents black-holing
168     
169     require(msg.value <= type(uint128).max, "EEXL: value too high");
170     require(msg.value >= minBid, "EEXL: req bid amt >= minBid");              
171     require(msg.value >= 0, "EEXL: req bid amt >= 0");
172     
173     require(bidOf[msg.sender].amount == uint128(0), "EEXL: bid exists, cancel first");
174 
175     require(_isValidColOrRow(minCol), "EEXL: minCol OOB");
176     require(_isValidColOrRow(maxCol), "EEXL: maxCol OOB");
177     require(minCol <= maxCol, "EEXL: req minCol <= maxCol");
178 
179     require(_isValidColOrRow(minRow), "EEXL: minRow OOB");
180     require(_isValidColOrRow(maxRow), "EEXL: maxRow OOB");
181     require(minRow <= maxRow, "EEXL: req minRow <= maxRow");
182 
183     require(_isValidElevation(minEle), "EEXL: minEle OOB");   // these ele checks prevent water bidding, regardless of row/col
184     require(_isValidElevation(maxEle), "EEXL: maxEle OOB");
185     require(minEle <= maxEle, "EEXL: req minEle <= maxEle");
186 
187     require(minWat <= uint8(6), "EEXL: minWat OOB");
188     require(maxWat <= uint8(6), "EEXL: maxWat OOB");
189     require(minWat <= maxWat, "EEXL: req minWat <= maxWat");
190 
191     uint256 biddersArrayLength = bidders.length;                           
192     require(biddersArrayLength < type(uint64).max, "EEXL: too many bids"); 
193 
194     bidOf[msg.sender] = Bid({
195       amount: uint128(msg.value),
196       minCol: minCol,
197       maxCol: maxCol,
198       minRow: minRow,
199       maxRow: maxRow,
200       minEle: minEle,
201       maxEle: maxEle,
202       minWat: minWat,
203       maxWat: maxWat,
204       biddersIndex: uint64(biddersArrayLength)
205     });
206 
207     bidders.push(msg.sender);
208 
209     emit BidCreated(msg.sender, uint128(msg.value), minCol, maxCol, minRow, maxRow, minEle, maxEle, minWat, maxWat);
210   }
211 
212   function _deleteBid(address bidder, uint64 biddersIndex) internal { // used by cancelBid and acceptBid
213     address lastBidder = bidders[bidders.length - uint256(1)];
214 
215     // If bidder not last bidder, overwrite with last bidder 
216     if (bidder != lastBidder) {
217       bidders[biddersIndex] = lastBidder;            // Overwrite the bidder at the index with the last bidder
218       bidOf[lastBidder].biddersIndex = biddersIndex;  // Update the bidder index of the bid of the previously last bidder
219     }
220 
221     delete bidOf[bidder];
222     bidders.pop();
223   }
224 
225   function cancelBid() external {
226     // Cancels the bid, getting the bid's amount, which is then added account's pending withdrawal
227     Bid storage bid = bidOf[msg.sender];
228     uint128 amount = bid.amount;
229 
230     require(amount != uint128(0), "EEXL: No existing bid");
231 
232     emit BidCancelled(msg.sender, amount, bid.minCol, bid.maxCol, bid.minRow, bid.maxRow, bid.minEle, bid.maxEle, bid.minWat, bid.maxWat);
233 
234     _deleteBid(msg.sender, bid.biddersIndex);
235     pendingWithdrawalOf[msg.sender] += uint256(amount);
236   }
237 
238   function acceptBid(uint8 col, uint8 row, address bidder, uint256 minAmount) external {
239     require(etheria.getOwner(col, row) == msg.sender, "EEXL: Not owner"); // etheria.setOwner will fail below if not owner, making this check unnecessary, but I want this here anyway
240     
241     Bid storage bid = bidOf[bidder];
242     uint128 amount = bid.amount;
243 
244     require(
245       (amount >= minAmount) &&
246       (col >= bid.minCol) &&
247       (col <= bid.maxCol) &&
248       (row >= bid.minRow) &&
249       (row <= bid.maxRow) &&
250       (mapElevationRetriever.getElevation(col, row) >= bid.minEle) &&
251       (mapElevationRetriever.getElevation(col, row) <= bid.maxEle) &&
252       (_getSurroundingWaterCount(col, row) >= bid.minWat) &&
253       (_getSurroundingWaterCount(col, row) <= bid.maxWat),
254       "EEXL: tile doesn't meet bid reqs"
255     );
256 
257     emit BidAccepted(msg.sender, bidder, _getIndex(col, row), amount, bid.minCol, bid.maxCol, bid.minRow, bid.maxRow, bid.minEle, bid.maxEle, bid.minWat, bid.maxWat);
258                                                                                                                                                         
259     _deleteBid(bidder, bid.biddersIndex);
260 
261     etheria.setOwner(col, row, bidder);
262     require(etheria.getOwner(col, row) == bidder, "EEXL: failed setting tile owner"); // ok for require after event emission. Events are technically state changes and atomic as well.
263 
264     uint256 fee = (uint256(amount) * feeRate) / uint256(10_000);
265     collectedFees += fee;
266 
267     pendingWithdrawalOf[msg.sender] += (uint256(amount) - fee);
268 
269     delete askFor[_getIndex(col, row)]; // don't emit AskRemoved here. It's not really a removal
270   }
271 
272   function _withdraw(address account, address payable destination) internal {
273     uint256 amount = pendingWithdrawalOf[account];
274     require(amount > uint256(0), "EEXL: nothing pending");
275 
276     pendingWithdrawalOf[account] = uint256(0);
277     _safeTransferETH(destination, amount);
278 
279     emit WithdrawalProcessed(account, destination, amount);
280   }
281 
282   function withdraw(address payable destination) external {
283     _withdraw(msg.sender, destination);
284   }
285 
286   function withdraw() external {
287     _withdraw(msg.sender, payable(msg.sender));
288   }
289 
290 }