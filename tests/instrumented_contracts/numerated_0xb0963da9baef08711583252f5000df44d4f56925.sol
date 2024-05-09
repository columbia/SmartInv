1 pragma solidity 0.4.24;
2 /*
3     Copyright 2018, SECRET 56
4 
5     License:
6     https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode
7 */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) pure internal returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) pure internal returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50   function abs128(int128 a) internal pure returns (int128) {
51     return a < 0 ? a * -1 : a;
52   }
53 }
54 
55 // Provides basic authorization control, having an owner address
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     constructor() internal {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address newOwner) public onlyOwner {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74     }
75 }
76 
77 // Defines only the typical transfer function of ERC20 tokens
78 contract Token {
79     function transfer(address to, uint256 value) public returns (bool);
80     function balanceOf(address who) public view returns (uint256);
81 }
82 
83 // Can deposit and withdraw ETH and ERC20 tokens
84 contract Reclaimable is Ownable {
85 
86     // Allows payments in the constructor too
87     constructor() public payable {
88     }
89 
90     // Allows payments to this contract
91     function() public payable {
92     }
93 
94     // Withdraw ether from this contract
95     function reclaimEther() external onlyOwner {
96         owner.transfer(address(this).balance);
97     }
98 
99     // Withdraws any token with transfer function (ERC20 like)
100     function reclaimToken(address _token) public onlyOwner {
101         Token token = Token(_token);
102 
103         uint256 balance = token.balanceOf(this);
104         token.transfer(owner, balance);
105     }
106 }
107 
108 //////////////////////////////////////////////////////////////
109 //                                                          //
110 //                      Storage                             //
111 //                                                          //
112 //////////////////////////////////////////////////////////////
113 
114 
115 
116 contract Storage is Ownable, Reclaimable {
117     using SafeMath for uint256;
118 
119     uint256 maxGasPrice = 4000000000;
120     uint256 public gasrequest = 250000;
121 
122     uint256[] public time;
123     int256[] public amount;
124     address[] public investorsAddresses;
125 
126     int256 public aum; 
127     uint256 public decimals = 8;
128     mapping(uint256 => bool) public timeExists;
129     mapping (address => bool) public resellers;
130     mapping (address => bool) public investors;
131     mapping (address => mapping (address => bool)) resinv;
132 
133     mapping(address => uint256) public ntx;
134     mapping(address => uint256) public rtx;
135 
136     mapping ( address => mapping (uint256 => btcTransaction)) public fundTx;
137     mapping ( address => mapping (uint256 => btcTransactionRequest)) public reqWD;
138 
139     uint256 public btcPrice;
140     uint256 public fee1;
141     uint256 public fee2;
142     uint256 public fee3;
143 
144     // fund deposit address mapping and length
145     uint256 public fundDepositAddressesLength;
146     mapping (uint256 => string) public fundDepositAddresses;
147 
148 
149     uint256 public feeAddressesLength;
150     mapping (uint256 => string) public feeAddresses;
151 
152     // This can be a deposit or a withdraw transaction
153     struct btcTransaction {
154         string txId;
155         string pubKey;
156         string signature;
157         // Action here is 0 for deposit and 1 for withdraw
158         uint256 action;
159         uint256 timestamp;
160     }
161 
162     // This is only a request of a transaction
163  
164     struct btcTransactionRequest {
165         string txId;
166         string pubKey;
167         string signature;
168         uint256 action; // Is action needed here???
169         uint256 timestamp;
170         string referal;
171     }
172 
173 	constructor () public {
174 
175 	}
176     /** SET FUND BTC ADDRESS */
177 
178     function setfundDepositAddress(string bitcoinAddress) public onlyOwner {
179         // Add bitcoin address to index and increment index
180         fundDepositAddresses[fundDepositAddressesLength++] = bitcoinAddress;
181     }
182 
183     function setFeeAddress(string bitcoinAddress) public onlyOwner {
184         // Add bitcoin address to index and increment index
185         feeAddresses[feeAddressesLength++] = bitcoinAddress;
186     }
187 
188     /** DEPOSITS */
189 
190     function setRequestGas (uint256 _gasrequest) public onlyOwner{
191         gasrequest = _gasrequest;
192     }
193 
194     function setAum(int256 _aum) public onlyOwner{
195         aum = _aum;
196     }
197 
198 
199     function depositAdmin(address addr,string txid, string pubkey, string signature) public onlyOwner{
200         setInvestor(addr, true);
201         addTX (addr,txid, pubkey, signature, 0); 
202     
203         uint256 gasPrice = tx.gasprice;
204         uint256 repayal = gasPrice.mul(gasrequest);
205         addr.transfer(repayal);
206     }
207 
208     /** WITHDRAWS */
209 
210     // FIXME: bad naming, request with T
211     function requesWithdraw(address addr,string txid, string pubkey, string signature, string referal) public {
212         require(investors[msg.sender]==true);
213 
214         uint256 i =  rtx[addr];
215         reqWD[addr][i].txId=txid;
216         reqWD[addr][i].pubKey=pubkey;
217         reqWD[addr][i].signature=signature;
218         reqWD[addr][i].action=1;
219         reqWD[addr][i].timestamp = block.timestamp;
220         reqWD[addr][i].referal = referal;
221         ++rtx[addr];
222     }
223 
224     function returnInvestment(address addr,string txid, string pubkey, string signature) public onlyOwner {
225         // FIXME: Should check if its not returned already!!
226         addTX (addr,txid, pubkey, signature, 1);
227     }
228 
229     /** INVESTORS */
230 
231     function setInvestor(address _addr, bool _allowed) public onlyOwner {
232         investors[_addr] = _allowed;
233         if(_allowed != false){
234             uint256 hasTransactions= ntx[_addr];
235             if(hasTransactions == 0){
236                 investorsAddresses.push(_addr);
237             }
238         }
239     }
240 
241     function getAllInvestors() public view returns (address[]){
242         return investorsAddresses;
243     }
244 
245     /** RESELLER FUNCTIONALITY? */
246 
247     function setReseller(address _addr, bool _allowed) public onlyOwner {
248         resellers[_addr] = _allowed;
249     }
250 
251     function setResellerInvestor(address _res, address _inv, bool _allowed) public onlyOwner {
252         resinv[_res][_inv] = _allowed;
253     }
254 
255     /** UTILITIES */
256 
257     // Adds a new tx even if it exists already
258     function addTX (address addr,string txid, string pubkey, string signature, uint256 action) internal {
259         uint256 i =  ntx[addr];
260         fundTx[addr][i].txId = txid;
261         fundTx[addr][i].pubKey = pubkey;
262         fundTx[addr][i].signature = signature;
263         fundTx[addr][i].action = action;
264         fundTx[addr][i].timestamp = block.timestamp;
265         ++ntx[addr];
266     }
267 
268     function getTx (address addr, uint256 i) public view returns (string,string,string,uint256, uint256) {
269         return (fundTx[addr][i].txId,fundTx[addr][i].pubKey,fundTx[addr][i].signature,fundTx[addr][i].action, fundTx[addr][i].timestamp);
270     }
271 
272     function setData(uint256 t, int256 a) public onlyOwner{
273         require(timeExists[t] != true);
274         time.push(t);
275         amount.push(a);
276         timeExists[t] = true;
277     }
278 
279     function setDataBlock(int256 a) public onlyOwner{
280         require(timeExists[block.timestamp] != true);
281         time.push(block.timestamp);
282         amount.push(a);
283         timeExists[block.timestamp] = true;
284     }
285 
286     function getAll() public view returns(uint256[] t, int256[] a){
287         return (time, amount);
288     }
289 
290     function setBtcPrice(uint256 _price) public onlyOwner {
291         btcPrice = _price;
292     }
293 
294     
295     function setFee(uint256 _fee1,uint256 _fee2,uint256 _fee3) public onlyOwner {
296         fee1 = _fee1;
297         fee2 = _fee2;
298         fee3 = _fee3;
299     }
300 }