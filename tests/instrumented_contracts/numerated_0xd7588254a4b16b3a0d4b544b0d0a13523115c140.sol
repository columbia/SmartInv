1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.2;
4 
5 interface IERC20Token {
6     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
7 }
8 
9 interface IERC721 {
10 
11     function setPaymentDate(uint256 _asset) external;
12     function getTokenDetails(uint256 index) external view returns (uint128 lastvalue, uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment);
13     function polkaCitizens() external view returns(uint256 _citizens);
14     function assetsByType(uint256 _assetType) external view returns (uint64 maxAmount, uint64 mintedAmount, uint128 baseValue);
15     function ownerOf(uint256 tokenId) external view returns (address owner);
16     function balanceOf(address _owner) external view returns (uint256);
17 }
18 
19 library Address {
20 
21     function isContract(address account) internal view returns (bool) {
22         // This method relies on extcodesize, which returns 0 for contracts in
23         // construction, since the code is only stored at the end of the
24         // constructor execution.
25 
26         uint256 size;
27         // solhint-disable-next-line no-inline-assembly
28         assembly { size := extcodesize(account) }
29         return size > 0;
30     }
31 
32 
33     function sendValue(address payable recipient, uint256 amount) internal {
34         require(address(this).balance >= amount, "Address: insufficient balance");
35 
36         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
37         (bool success, ) = recipient.call{ value: amount }("");
38         require(success, "Address: unable to send value, recipient may have reverted");
39     }
40 
41    
42     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
43       return functionCall(target, data, "Address: low-level call failed");
44     }
45 
46     
47     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
48         return functionCallWithValue(target, data, 0, errorMessage);
49     }
50 
51     
52     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
53         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
54     }
55 
56     
57     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
58         require(address(this).balance >= value, "Address: insufficient balance for call");
59         require(isContract(target), "Address: call to non-contract");
60 
61         // solhint-disable-next-line avoid-low-level-calls
62         (bool success, bytes memory returndata) = target.call{ value: value }(data);
63         return _verifyCallResult(success, returndata, errorMessage);
64     }
65 
66    
67     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
68         return functionStaticCall(target, data, "Address: low-level static call failed");
69     }
70 
71     
72     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
73         require(isContract(target), "Address: static call to non-contract");
74 
75         // solhint-disable-next-line avoid-low-level-calls
76         (bool success, bytes memory returndata) = target.staticcall(data);
77         return _verifyCallResult(success, returndata, errorMessage);
78     }
79 
80    
81     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
82         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
83     }
84 
85   
86     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
87         require(isContract(target), "Address: delegate call to non-contract");
88 
89         // solhint-disable-next-line avoid-low-level-calls
90         (bool success, bytes memory returndata) = target.delegatecall(data);
91         return _verifyCallResult(success, returndata, errorMessage);
92     }
93 
94     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
95         if (success) {
96             return returndata;
97         } else {
98             // Look for revert reason and bubble it up if present
99             if (returndata.length > 0) {
100                 // The easiest way to bubble the revert reason is using memory via assembly
101 
102                 // solhint-disable-next-line no-inline-assembly
103                 assembly {
104                     let returndata_size := mload(returndata)
105                     revert(add(32, returndata), returndata_size)
106                 }
107             } else {
108                 revert(errorMessage);
109             }
110         }
111     }
112 }
113 
114 contract Ownable {
115 
116     address private owner;
117     
118     event OwnerSet(address indexed oldOwner, address indexed newOwner);
119     
120     modifier onlyOwner() {
121         require(msg.sender == owner, "Caller is not owner");
122         _;
123     }
124 
125     constructor() {
126         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
127         emit OwnerSet(address(0), owner);
128     }
129 
130 
131     function changeOwner(address newOwner) public onlyOwner {
132         emit OwnerSet(owner, newOwner);
133         owner = newOwner;
134     }
135 
136     function getOwner() external view returns (address) {
137         return owner;
138     }
139 }
140 
141 contract PolkaProfitContract is Ownable {
142     
143     event Payment(address indexed to, uint256 amount, uint8 network, uint256 gasFee);
144     
145     bool public paused;
146 
147     struct paymentByType {
148         uint256 weeklyPayment;
149         uint256 variantFactor; 
150         uint256 basePriceFactor;
151     }
152     
153     struct Claim {
154         address account;
155         uint8 dNetwork;  // 1= Ethereum   2= BSC
156         uint256 assetId;
157         uint256 amount;
158         uint256 date;
159     }
160     
161     Claim[] public payments;
162     
163     mapping (address => bool) public blackListed;
164     mapping (uint256 => paymentByType) public paymentAmount;
165     address public nftAddress = 0x57E9a39aE8eC404C08f88740A9e6E306f50c937f;
166     address public tokenAddress = 0xaA8330FB2B4D5D07ABFE7A72262752a8505C6B37;
167     address payable public walletAddress;
168     uint256 public gasFee = 1000000000000000;
169     
170 
171     uint256 wUnit = 1 weeks;
172     
173     constructor() {
174         fillPayments(1,    60000000000000000000, 10, 15000000000000);
175         fillPayments(2,   135000000000000000000, 10, 30000000000000);
176         fillPayments(3,   375000000000000000000, 10, 75000000000000);
177         fillPayments(4,   550000000000000000000, 10, 100000000000000);
178         fillPayments(5,   937500000000000000000, 10, 150000000000000);
179         fillPayments(6,  8250000000000000000000, 10, 750000000000000);
180         fillPayments(7,  6500000000000000000000, 10, 655000000000000);
181         fillPayments(8,  3000000000000000000000, 20, 400000000000000);
182         fillPayments(9, 10800000000000000000000, 50, 900000000000000);
183         fillPayments(10, 5225000000000000000000, 30, 550000000000000);
184         fillPayments(11,13125000000000000000000, 20, 1050000000000000);
185         fillPayments(12, 4500000000000000000000, 10, 500000000000000);
186         fillPayments(13, 1500000000000000000000, 10, 225000000000000);
187         fillPayments(14, 2100000000000000000000, 15, 300000000000000);
188         fillPayments(15, 3750000000000000000000, 10, 450000000000000);
189         
190         walletAddress = payable(0xAD334543437EF71642Ee59285bAf2F4DAcBA613F);
191 
192     }
193     
194     function fillPayments(uint256 _assetId, uint256 _weeklyPayment, uint256 _variantFactor, uint256 _basePriceFactor) private {
195         paymentAmount[_assetId].weeklyPayment = _weeklyPayment;
196         paymentAmount[_assetId].variantFactor = _variantFactor;
197         paymentAmount[_assetId].basePriceFactor = _basePriceFactor;
198     }
199     
200     function profitsPayment(uint256 _assetId) public returns (bool success) {
201         require(paused == false, "Contract is paused");
202         IERC721 nft = IERC721(nftAddress);
203         address assetOwner = nft.ownerOf(_assetId);
204         require(assetOwner == msg.sender, "Only asset owner can claim profits");
205         require(blackListed[assetOwner] == false, "This address cannot claim profits");
206         (uint256 totalPayment, ) = calcProfit(_assetId);
207         require (totalPayment > 0, "You need to wait at least 1 week to claim");
208         nft.setPaymentDate(_assetId);
209         IERC20Token token = IERC20Token(tokenAddress);
210         require(token.transferFrom(walletAddress, assetOwner, totalPayment), "ERC20 transfer fail");
211         Claim memory thisclaim = Claim(msg.sender, 1,  _assetId, totalPayment, block.timestamp);
212         payments.push(thisclaim);
213         emit Payment(msg.sender, totalPayment, 1, 0);
214         return true;
215     }
216     
217     function profitsPaymentBSC(uint256 _assetId) public payable  returns (bool success) {
218         require(paused == false, "Contract is paused");
219         require(msg.value >= gasFee, "Gas fee too low");
220         IERC721 nft = IERC721(nftAddress);
221         address assetOwner = nft.ownerOf(_assetId);
222         require(assetOwner == msg.sender, "Only asset owner can claim profits");
223         require(blackListed[assetOwner] == false, "This address cannot claim profits");
224         (uint256 totalPayment, ) = calcProfit(_assetId);
225         require (totalPayment > 0, "You need to wait at least 1 week to claim");
226         nft.setPaymentDate(_assetId);
227         Address.sendValue(walletAddress, msg.value);
228         Claim memory thisclaim = Claim(msg.sender, 2, _assetId, totalPayment, block.timestamp);
229         payments.push(thisclaim);
230         emit Payment(msg.sender, totalPayment, 2, msg.value);
231         return true;
232     }
233     
234     function calcProfit(uint256 _assetId) public view returns (uint256 _profit, uint256 _lastPayment) {
235         IERC721 nft = IERC721(nftAddress);
236         ( , uint32 assetType,, uint32 lastTransfer, uint32 lastPayment ) = nft.getTokenDetails(_assetId);
237         uint256 cTime = block.timestamp - lastTransfer;
238         uint256 dTime = 0;
239         if (lastTransfer < lastPayment) {
240             dTime = lastPayment - lastTransfer;
241         }
242         if ((cTime) < wUnit) { 
243             return (0, lastTransfer);
244         } else {
245              uint256 weekCount;  
246             if (dTime == 0) {
247                 weekCount = ((cTime)/(wUnit));
248             } else {
249                 weekCount = ((cTime)/(wUnit)) - (dTime)/(wUnit);
250             }
251             if (weekCount < 1) {
252                 return (0, lastPayment);
253             } else {
254                 uint256 daysCount = weekCount * 7; //  
255                 uint256 variantCount;
256                 if (assetType == 8 || assetType == 15) {
257                     variantCount = countTaxis();
258                 } else {
259                     variantCount = nft.polkaCitizens();
260                 }
261                 uint256 totalPayment;
262                 paymentByType memory thisPayment = paymentAmount[uint256(assetType)];
263                 uint256 dailyProfit = ((thisPayment.basePriceFactor*(variantCount*thisPayment.variantFactor))/30)*daysCount;
264                 totalPayment = ((weekCount * thisPayment.weeklyPayment) + dailyProfit);
265                 return (totalPayment, lastPayment);  
266                 
267             }
268         }
269     }
270     
271     function calcTotalEarnings(uint256 _assetId) public view returns (uint256 _profit, uint256 _lastPayment) {
272         IERC721 nft = IERC721(nftAddress);
273         ( , uint32 assetType,, uint32 lastTransfer, ) = nft.getTokenDetails(_assetId);
274         uint256 timeFrame = block.timestamp - lastTransfer;
275         if (timeFrame < wUnit) {  
276             return (0, lastTransfer);
277         } else {
278             uint256 weekCount = timeFrame/(wUnit); 
279             uint256 daysCount = weekCount * 7;  
280             uint256 variantCount;
281             if (assetType == 8 || assetType == 15) {
282                 variantCount = countTaxis();
283             } else {
284                 variantCount = nft.polkaCitizens();
285             }
286             uint256 totalPayment;
287             paymentByType memory thisPayment = paymentAmount[uint256(assetType)];
288             uint256 dailyProfit = ((thisPayment.basePriceFactor*(variantCount*thisPayment.variantFactor))/30)*daysCount;
289             totalPayment = ((weekCount * thisPayment.weeklyPayment) + dailyProfit);
290             return (totalPayment, lastTransfer);    
291         }
292 
293     }
294     
295 
296     function countTaxis() private view returns (uint256 taxis) {
297         uint256 taxiCount = 0;
298         uint64 assetMinted;
299         IERC721 nft = IERC721(nftAddress);
300         (, assetMinted,) = nft.assetsByType(1);
301         taxiCount += uint256(assetMinted);
302         (, assetMinted,) = nft.assetsByType(2);
303         taxiCount += uint256(assetMinted);
304         (, assetMinted,) = nft.assetsByType(3);
305         taxiCount += uint256(assetMinted);
306         (, assetMinted,) = nft.assetsByType(4);
307         taxiCount += assetMinted;
308         (, assetMinted,) = nft.assetsByType(5);
309         taxiCount += uint256(assetMinted);
310         return taxiCount;
311     }
312 
313     
314     function pauseContract(bool _paused) public onlyOwner {
315         paused = _paused;
316     }
317     
318     function blackList(address _wallet, bool _blacklist) public onlyOwner {
319         blackListed[_wallet] = _blacklist;
320     }
321 
322     function paymentCount() public view returns (uint256 _paymentCount) {
323         return payments.length;
324     }
325     
326     function paymentDetail(uint256 _paymentIndex) public view returns (address _to, uint8 _network, uint256 assetId, uint256 _amount, uint256 _date) {
327         Claim memory thisPayment = payments[_paymentIndex];
328         return (thisPayment.account, thisPayment.dNetwork, thisPayment.assetId, thisPayment.amount, thisPayment.date);
329     }
330     
331     function setGasFee(uint256 _gasFee) public onlyOwner {
332         gasFee = _gasFee;
333     }
334     
335     function setWalletAddress(address _wallet) public onlyOwner {
336         walletAddress = payable(_wallet);
337     }
338     
339     
340 }