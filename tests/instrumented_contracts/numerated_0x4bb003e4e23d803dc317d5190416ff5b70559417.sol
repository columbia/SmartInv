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
12     function getTokenDetails(uint256 index) external view returns (uint32 aType, uint32 customDetails, uint32 lastTx, uint32 lastPayment, uint256 initialvalue, string memory coin);
13     function ownerOf(uint256 tokenId) external view returns (address owner);
14     function balanceOf(address _owner) external view returns (uint256);
15 }
16 
17 library Address {
18 
19     function isContract(address account) internal view returns (bool) {
20         // This method relies on extcodesize, which returns 0 for contracts in
21         // construction, since the code is only stored at the end of the
22         // constructor execution.
23 
24         uint256 size;
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 
30 
31     function sendValue(address payable recipient, uint256 amount) internal {
32         require(address(this).balance >= amount, "Address: insufficient balance");
33 
34         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
35         (bool success, ) = recipient.call{ value: amount }("");
36         require(success, "Address: unable to send value, recipient may have reverted");
37     }
38 
39    
40     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
41       return functionCall(target, data, "Address: low-level call failed");
42     }
43 
44     
45     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
46         return functionCallWithValue(target, data, 0, errorMessage);
47     }
48 
49     
50     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
51         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
52     }
53 
54     
55     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
56         require(address(this).balance >= value, "Address: insufficient balance for call");
57         require(isContract(target), "Address: call to non-contract");
58 
59         // solhint-disable-next-line avoid-low-level-calls
60         (bool success, bytes memory returndata) = target.call{ value: value }(data);
61         return _verifyCallResult(success, returndata, errorMessage);
62     }
63 
64    
65     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
66         return functionStaticCall(target, data, "Address: low-level static call failed");
67     }
68 
69     
70     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
71         require(isContract(target), "Address: static call to non-contract");
72 
73         // solhint-disable-next-line avoid-low-level-calls
74         (bool success, bytes memory returndata) = target.staticcall(data);
75         return _verifyCallResult(success, returndata, errorMessage);
76     }
77 
78    
79     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
80         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
81     }
82 
83   
84     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
85         require(isContract(target), "Address: delegate call to non-contract");
86 
87         // solhint-disable-next-line avoid-low-level-calls
88         (bool success, bytes memory returndata) = target.delegatecall(data);
89         return _verifyCallResult(success, returndata, errorMessage);
90     }
91 
92     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
93         if (success) {
94             return returndata;
95         } else {
96             // Look for revert reason and bubble it up if present
97             if (returndata.length > 0) {
98                 // The easiest way to bubble the revert reason is using memory via assembly
99 
100                 // solhint-disable-next-line no-inline-assembly
101                 assembly {
102                     let returndata_size := mload(returndata)
103                     revert(add(32, returndata), returndata_size)
104                 }
105             } else {
106                 revert(errorMessage);
107             }
108         }
109     }
110 }
111 
112 contract Ownable {
113 
114     address private owner;
115     
116     event OwnerSet(address indexed oldOwner, address indexed newOwner);
117     
118     modifier onlyOwner() {
119         require(msg.sender == owner, "Caller is not owner");
120         _;
121     }
122 
123     constructor() {
124         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
125         emit OwnerSet(address(0), owner);
126     }
127 
128 
129     function changeOwner(address newOwner) public onlyOwner {
130         emit OwnerSet(owner, newOwner);
131         owner = newOwner;
132     }
133 
134     function getOwner() external view returns (address) {
135         return owner;
136     }
137 }
138 
139 contract PolkaProfitContract is Ownable {
140     
141     event Payment(address indexed to, uint256 amount, uint8 network, uint256 gasFee);
142     
143     bool public paused;
144 
145     struct Claim {
146         address account;
147         uint8 dNetwork;  // 1= Ethereum   2= BSC
148         uint256 assetId;
149         uint256 amount;
150         uint256 date;
151     }
152     
153     Claim[] public payments;
154     
155     mapping (address => bool) public blackListed;
156     mapping (uint256 => uint256) public weeklyByType;
157     address public nftAddress = 0xB20217bf3d89667Fa15907971866acD6CcD570C8;
158     address public tokenAddress = 0xaA8330FB2B4D5D07ABFE7A72262752a8505C6B37;
159     address payable public walletAddress;
160     uint256 public gasFee = 1000000000000000;
161     mapping (uint256 => uint256) public bankWithdraws;
162     uint256 public bankEarnings;
163     address bridgeContract;
164     
165 
166     uint256 wUnit = 1 weeks;
167     
168     constructor() {
169         weeklyByType[20] = 18 ether;
170         weeklyByType[22] = 4 ether;
171         weeklyByType[23] = 3 ether;
172         weeklyByType[25] = 1041 ether;
173         weeklyByType[26] = 44 ether;
174         weeklyByType[29] = 3125 ether;
175         weeklyByType[30] = 29 ether;
176         weeklyByType[31] = 5 ether;
177         weeklyByType[32] = 20 ether;
178         weeklyByType[34] = 10 ether;
179         weeklyByType[36] = 70 ether;
180         weeklyByType[37] = 105 ether;
181         weeklyByType[38] = 150 ether;
182         weeklyByType[39] = 600 ether;
183         weeklyByType[40] = 20 ether;
184         
185         walletAddress = payable(0xAD334543437EF71642Ee59285bAf2F4DAcBA613F);
186         bridgeContract = 0x0A0b052D93EaA7C67F498fb3F8D9f4f56456BA51;
187     }
188     
189     function profitsPayment(uint256 _assetId) public returns (bool success) {
190         require(paused == false, "Contract is paused");
191         IERC721 nft = IERC721(nftAddress);
192         address assetOwner = nft.ownerOf(_assetId);
193         require(assetOwner == msg.sender, "Only asset owner can claim profits");
194         require(blackListed[assetOwner] == false, "This address cannot claim profits");
195         (uint256 totalPayment, ) = calcProfit(_assetId);
196         require (totalPayment > 0, "You need to wait at least 1 week to claim");
197         nft.setPaymentDate(_assetId);
198         IERC20Token token = IERC20Token(tokenAddress);
199         require(token.transferFrom(walletAddress, assetOwner, totalPayment), "ERC20 transfer fail");
200         Claim memory thisclaim = Claim(msg.sender, 1, _assetId, totalPayment, block.timestamp);
201         payments.push(thisclaim);
202         emit Payment(msg.sender, totalPayment, 1, 0);
203         return true;
204     }
205     
206     function profitsPaymentBSC(uint256 _assetId) public payable returns (bool success) {
207         require(paused == false, "Contract is paused");
208         require(msg.value >= gasFee, "Gas fee too low");
209         IERC721 nft = IERC721(nftAddress);
210         address assetOwner = nft.ownerOf(_assetId);
211         require(assetOwner == msg.sender, "Only asset owner can claim profits");
212         require(blackListed[assetOwner] == false, "This address cannot claim profits");
213         (uint256 totalPayment, ) = calcProfit(_assetId);
214         require (totalPayment > 0, "You need to wait at least 1 week to claim");
215         nft.setPaymentDate(_assetId);
216         Address.sendValue(walletAddress, msg.value);
217         Claim memory thisclaim = Claim(msg.sender, 2, _assetId, totalPayment, block.timestamp);
218         payments.push(thisclaim);
219         emit Payment(msg.sender, totalPayment, 2, msg.value);
220         return true;
221     }
222     
223     function calcProfit(uint256 _assetId) public view returns (uint256 _profit, uint256 _lastPayment) {
224         IERC721 nft = IERC721(nftAddress);
225         (uint32 assetType,, uint32 lastTransfer, uint32 lastPayment,, ) = nft.getTokenDetails(_assetId);
226         uint256 cTime = block.timestamp - lastTransfer;
227         uint256 dTime = 0;
228         if (lastTransfer < lastPayment) {
229             dTime = lastPayment - lastTransfer;
230         }
231         if ((cTime) < wUnit) { 
232             return (0, lastTransfer);
233         } else {
234              uint256 weekCount;  
235             if (dTime == 0) {
236                 weekCount = ((cTime)/(wUnit));
237             } else {
238                 weekCount = ((cTime)/(wUnit)) - (dTime)/(wUnit);
239             }
240             if (weekCount < 1) {
241                 return (0, lastPayment);
242             } else {
243                 uint256 totalPayment;
244                 totalPayment = ((weekCount * weeklyByType[assetType]));
245                 return (totalPayment, lastPayment);  
246                 
247             }
248         }
249     }
250     
251     function calcTotalEarnings(uint256 _assetId) public view returns (uint256 _profit, uint256 _lastPayment) {
252         IERC721 nft = IERC721(nftAddress);
253         (uint32 assetType,, uint32 lastTransfer,,, ) = nft.getTokenDetails(_assetId);
254         uint256 timeFrame = block.timestamp - lastTransfer;
255         if (timeFrame < wUnit) {  
256             return (0, lastTransfer);
257         } else {
258             uint256 weekCount = timeFrame/(wUnit); 
259             uint256 totalPayment;
260             totalPayment = ((weekCount * weeklyByType[assetType]));
261             return (totalPayment, lastTransfer);    
262         }
263 
264     }
265     
266 
267     function pauseContract(bool _paused) public onlyOwner {
268         paused = _paused;
269     }
270     
271     function blackList(address _wallet, bool _blacklist) public onlyOwner {
272         blackListed[_wallet] = _blacklist;
273     }
274 
275     function paymentCount() public view returns (uint256 _paymentCount) {
276         return payments.length;
277     }
278     
279     function paymentDetail(uint256 _paymentIndex) public view returns (address _to, uint8 _network, uint256 assetId, uint256 _amount, uint256 _date) {
280         Claim memory thisPayment = payments[_paymentIndex];
281         return (thisPayment.account, thisPayment.dNetwork, thisPayment.assetId, thisPayment.amount, thisPayment.date);
282     }
283     
284     function addType(uint256 _aType, uint256 _weekly) public onlyOwner {
285         weeklyByType[_aType] = _weekly;
286     }
287     
288     function setGasFee(uint256 _gasFee) public onlyOwner {
289         gasFee = _gasFee;
290     }
291     
292     function setWalletAddress(address _wallet) public onlyOwner {
293         walletAddress = payable(_wallet);
294     }
295     
296     function setBridgeContract(address _contract) public onlyOwner {
297         bridgeContract = _contract;
298     }
299     
300     function addBankEarnings(uint256 _amount) public {
301         require(msg.sender == bridgeContract, "Not Allowed");
302         bankEarnings += _amount;
303     }
304     
305     function claimBankEarnings(uint256 _assetId) public {
306         IERC721 nft = IERC721(nftAddress);
307         (uint32 assetType,,,,, ) = nft.getTokenDetails(_assetId);
308         address assetOwner = nft.ownerOf(_assetId);
309         require(assetType == 33, "Invalid asset");
310         uint256 toPay = bankEarnings - bankWithdraws[_assetId];
311         if (toPay > 0) {
312             bankWithdraws[_assetId] = bankEarnings;
313             IERC20Token token = IERC20Token(tokenAddress);
314             require(token.transferFrom(walletAddress, assetOwner, toPay), "ERC20 transfer fail");
315             emit Payment(assetOwner, toPay, 2, 0);
316         }
317     }
318     
319     function claimBankEarningsBSC(uint256 _assetId) public payable {
320         IERC721 nft = IERC721(nftAddress);
321         (uint32 assetType,,,,, ) = nft.getTokenDetails(_assetId);
322         address assetOwner = nft.ownerOf(_assetId);
323         require(assetType == 33, "Invalid asset");
324         uint256 toPay = bankEarnings - bankWithdraws[_assetId];
325         if (toPay > 0) {
326             bankWithdraws[_assetId] = bankEarnings;
327             Claim memory thisclaim = Claim(assetOwner, 2, _assetId, toPay, block.timestamp);
328             payments.push(thisclaim);
329             emit Payment(assetOwner, toPay, 2, msg.value);
330         }
331 
332     }
333     
334 
335 
336     
337 }