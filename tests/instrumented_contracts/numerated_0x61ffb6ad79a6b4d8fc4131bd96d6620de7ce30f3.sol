1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-27
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-09-27
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2019-09-24
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2019-09-24
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2019-09-20
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2019-09-20
23 */
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2019-09-11
27 */
28 
29 /**
30  *Submitted for verification at Etherscan.io on 2019-09-11
31 */
32 
33 pragma solidity ^0.5.11;
34 
35 contract Token {
36   function transfer(address to, uint256 value) public returns (bool success);
37   function transferFrom(address from, address to, uint256 value) public returns (bool success);
38      function balanceOf(address account) external view returns(uint256);
39      function allowance(address _owner, address _spender)external view returns(uint256);
40 }
41 
42 library SafeMath{
43       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
44     {
45         if (a == 0) {
46         return 0;}
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) 
53     {
54         uint256 c = a / b;
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
59     {
60         assert(b <= a);
61         return a - b;
62     }
63 
64     function add(uint256 a, uint256 b) internal pure returns (uint256) 
65     {
66         uint256 c = a + b;
67         assert(c >= a);
68         return c;
69     }
70 
71 }
72 
73 contract StableDEX {
74     using SafeMath for uint256;
75     
76     event DepositandWithdraw(address from,address tokenAddress,uint256 amount,uint256 type_); //Type = 0-deposit 1- withdraw , Token address = address(0) - eth , address - token address;
77     
78     address payable admin;
79     
80     address public feeAddress;
81     
82     bool public dexStatus;   
83       
84     uint256 public tokenId=0;
85       
86     struct orders{
87         address userAddress;
88         address tokenAddress;
89         uint256 type_;
90         uint256 price;
91         uint256 total;
92         uint256 _decimal;
93         uint256 tradeTotal;
94         uint256 amount;
95         uint256 tradeAmount;
96         uint256 pairOrderID;
97         uint256 status; 
98     }
99     
100     struct tokens{
101         address tokenAddress;
102         string tokenSymbol;
103         uint256 decimals;
104         bool status;
105     }
106     
107     
108     constructor(address payable _admin,address feeAddress_) public{
109         admin = _admin;
110         feeAddress = feeAddress_;
111         dexStatus = true;
112     }
113 
114     
115     mapping(uint256=>orders) public Order; //place order by passing userID and orderID as argument;
116     
117     mapping(address=>mapping(address=>uint256))public userDetails;  // trader token balance;
118     
119     mapping(address=>mapping(address=>uint256))public feeAmount;
120     
121      mapping(address=>uint256) public withdrawfee;
122      
123      mapping(uint256=>mapping(uint256=>bool)) public orderPairStatus;
124      
125      mapping(address=>tokens) public tokendetails;
126     
127     modifier dexstatuscheck(){
128        require(dexStatus==true);
129        _;
130     }
131     
132     function setDexStatus(bool status_) public returns(bool){
133         require(msg.sender == admin);
134         dexStatus = status_;
135         return true;
136     }   
137     
138     function addToken(address tokenAddress,string memory tokenSymbol,uint256 decimal_) public returns(bool){
139         require(msg.sender == feeAddress && tokendetails[tokenAddress].status==false);
140         tokendetails[tokenAddress].tokenSymbol=tokenSymbol;
141         tokendetails[tokenAddress].decimals=decimal_;
142         tokendetails[tokenAddress].status=true;
143         return true;
144     }
145     
146     function deposit() dexstatuscheck public payable returns(bool) {
147         require(msg.value > 0);
148         userDetails[msg.sender][address(0)]=userDetails[msg.sender][address(0)].add(msg.value);
149         emit DepositandWithdraw( msg.sender, address(0),msg.value,0);
150         return true;
151     }
152     
153     function tokenDeposit(address tokenaddr,uint256 tokenAmount) dexstatuscheck public returns(bool)
154     {
155         require(tokenAmount > 0 && tokendetails[tokenaddr].status==true);
156         require(tokenallowance(tokenaddr,msg.sender) > 0);
157         userDetails[msg.sender][tokenaddr] = userDetails[msg.sender][tokenaddr].add(tokenAmount);
158         Token(tokenaddr).transferFrom(msg.sender,address(this), tokenAmount);
159         emit DepositandWithdraw( msg.sender,tokenaddr,tokenAmount,0);
160         return true;
161         
162     }
163   
164     function withdraw(uint8 type_,address tokenaddr,uint256 amount) dexstatuscheck public returns(bool) {
165         require(type_ ==0 || type_ == 1);
166          if(type_==0){ // withdraw ether
167          require(tokenaddr == address(0));
168          require(amount>0 && amount <= userDetails[msg.sender][address(0)] && withdrawfee[address(0)]<amount);
169          require(amount<=address(this).balance);
170                 msg.sender.transfer(amount.sub(withdrawfee[address(0)]));    
171                 userDetails[msg.sender][address(0)] = userDetails[msg.sender][address(0)].sub(amount);
172                 feeAmount[admin][address(0)] = feeAmount[admin][address(0)].add(withdrawfee[address(0)]);
173                 
174         }
175         else{ //withdraw token
176         require(tokenaddr != address(0) && tokendetails[tokenaddr].status==true);
177         require(amount>0 && amount <= userDetails[msg.sender][tokenaddr] && withdrawfee[tokenaddr]<amount);
178               Token(tokenaddr).transfer(msg.sender, (amount.sub(withdrawfee[tokenaddr])));
179               userDetails[msg.sender][tokenaddr] = userDetails[msg.sender][tokenaddr].sub(amount);
180               feeAmount[admin][tokenaddr] = feeAmount[admin][tokenaddr].add(withdrawfee[tokenaddr]);
181         }
182         emit DepositandWithdraw( msg.sender,tokenaddr,amount,1);
183         return true;
184     }
185 
186      function adminProfitWithdraw(uint8 type_,address tokenAddr)public returns(bool){ //  tokenAddr = type 0 - address(0),  type 1 - token address;
187        require(msg.sender == admin);
188        require(type_ ==0 || type_ == 1);
189          if(type_==0){ // withdraw ether
190             admin.transfer(feeAmount[admin][address(0)]);
191             feeAmount[admin][address(0)]=0;
192                 
193         }
194         else{ //withdraw token
195             require(tokenAddr != address(0)) ;
196             Token(tokenAddr).transfer(admin, feeAmount[admin][tokenAddr]);
197             feeAmount[admin][tokenAddr]=0;
198         }
199            
200           
201             return true;
202         }
203         
204         
205     function setwithdrawfee(address[] memory addr,uint256[] memory feeamount)public returns(bool)
206         {
207           require(msg.sender==admin);
208           //array length should be within 10.
209           require(addr.length <10 && feeamount.length < 10 && addr.length==feeamount.length);
210           for(uint8 i=0;i<addr.length;i++){
211             withdrawfee[addr[i]]=feeamount[i];    
212           }
213            return true;
214         }
215     
216 
217     
218     function verify(string memory  message, uint8 v, bytes32 r, bytes32 s) private pure returns (address signer) {
219         string memory header = "\x19Ethereum Signed Message:\n000000";
220         uint256 lengthOffset;
221         uint256 length;
222         assembly {
223             length := mload(message)
224             lengthOffset := add(header, 57)
225         }
226         require(length <= 999999);
227         uint256 lengthLength = 0;
228         uint256 divisor = 100000; 
229         while (divisor != 0) {
230             uint256 digit = length.div(divisor);
231             if (digit == 0) {
232              
233                 if (lengthLength == 0) {
234                       divisor = divisor.div(10);
235                       continue;
236                     }
237             }
238             lengthLength++;
239             length = length.sub(digit.mul(divisor));
240             divisor = divisor.div(10);
241             digit = digit.add(0x30);
242             lengthOffset++;
243             assembly {
244                 mstore8(lengthOffset, digit)
245             }
246         }  
247         if (lengthLength == 0) {
248             lengthLength = 1 + 0x19 + 1;
249         } else {
250             lengthLength = lengthLength.add(1 + 0x19);
251         }
252         assembly {
253             mstore(header, lengthLength)
254         }
255         bytes32 check = keccak256(abi.encodePacked(header, message));
256         return ecrecover(check, v, r, s);
257     }
258             
259         
260     
261     function makeOrder(uint256[9] memory tradeDetails,address[2] memory traderAddresses,string memory message,uint8  v,bytes32 r,bytes32 s)public returns(bool){
262       require(msg.sender == feeAddress);
263        require(verify((message),v,r,s)==traderAddresses[1]);
264     
265       
266     // First array (tradeDetails)
267       // 0- orderid
268       // 1- amount
269       // 2- price
270       // 3- total
271       // 4- buyerFee
272       // 5 - sellerFee
273       // 6 - type
274       // 7- decimal
275       // 8 - pairOrderID
276 
277  
278     // Second  array (traderAddresses)
279       // 0- tokenAddress
280       // 1- userAddress
281     
282     
283       uint256 amount__;
284        
285         uint256 orderiD = tradeDetails[0];
286         if(Order[orderiD].status==0){   // if status code = 0 - new order, will store order details.
287             if(tradeDetails[6] == 0){
288                 amount__ = tradeDetails[3];
289             }
290             else if(tradeDetails[6] ==1){
291                 amount__ = tradeDetails[1];
292             }
293            require(amount__ > 0 && amount__ <= userDetails[traderAddresses[1]][traderAddresses[0]]);
294                 // stores placed order details
295                 Order[orderiD].userAddress = traderAddresses[1];
296                 Order[orderiD].type_ = tradeDetails[6];
297                 Order[orderiD].price = tradeDetails[2];
298                 Order[orderiD].amount  = tradeDetails[1];
299                 Order[orderiD].total  = tradeDetails[3];
300                 Order[orderiD].tradeTotal  = tradeDetails[3];
301                 Order[orderiD]._decimal  = tradeDetails[7];
302                 Order[orderiD].tokenAddress = traderAddresses[0];       
303                 // freeze trade amount;
304                 userDetails[traderAddresses[1]][traderAddresses[0]]-=amount__;
305                 // store total trade count
306                 Order[orderiD].tradeAmount=tradeDetails[1];
307                 Order[orderiD].status=1;
308             
309             
310         }
311         else if(Order[orderiD].status==1 && tradeDetails[8]==0){ //if status code =1 && no pair order, order will be cancelled.
312             cancelOrder(orderiD);
313         }
314         if(Order[orderiD].status==1 && tradeDetails[1] > 0 && tradeDetails[8]>0 && Order[tradeDetails[8]].status==1 && tradeDetails[3]>0){ //order mapping
315               require(Order[orderiD].tradeAmount >= tradeDetails[1] && Order[tradeDetails[8]].tradeAmount >= tradeDetails[1] && Order[tradeDetails[8]].price <= Order[orderiD].price);
316                 Order[orderiD].tradeAmount -=tradeDetails[1];
317                 Order[tradeDetails[8]].tradeAmount -=tradeDetails[1];
318                 if(tradeDetails[2]>0){
319                     userDetails[Order[orderiD].userAddress][Order[orderiD].tokenAddress]+=tradeDetails[2];
320                 }
321                 Order[orderiD].tradeTotal -=((tradeDetails[1] * Order[orderiD].price) / Order[orderiD]._decimal);
322                 Order[tradeDetails[8]].tradeTotal -=((tradeDetails[1] * Order[tradeDetails[8]].price) / Order[tradeDetails[8]]._decimal);
323                 
324                
325                     if(tradeDetails[6] == 1 || tradeDetails[6]==3)
326                     {
327                         userDetails[Order[orderiD].userAddress][Order[tradeDetails[8]].tokenAddress]+=tradeDetails[1];
328                         userDetails[Order[orderiD].userAddress][traderAddresses[0]]-= tradeDetails[4]; 
329                           feeAmount[admin][Order[tradeDetails[8]].tokenAddress]+= tradeDetails[4];
330                     }
331                     else
332                     {
333                          userDetails[Order[orderiD].userAddress][Order[tradeDetails[8]].tokenAddress]+=(tradeDetails[1]-tradeDetails[4]);
334                             feeAmount[admin][Order[tradeDetails[8]].tokenAddress]+= tradeDetails[4];
335                     }
336                     if(tradeDetails[6] == 2 || tradeDetails[6]==3)
337                     {
338                         userDetails[Order[tradeDetails[8]].userAddress][Order[orderiD].tokenAddress]+=tradeDetails[3];
339                         userDetails[Order[tradeDetails[8]].userAddress][traderAddresses[0]]-= tradeDetails[5];
340                           feeAmount[admin][Order[orderiD].tokenAddress]+= tradeDetails[5];
341                     }
342                     else
343                     {
344                          userDetails[Order[tradeDetails[8]].userAddress][Order[orderiD].tokenAddress]+=(tradeDetails[3]-tradeDetails[5]);
345                          feeAmount[admin][Order[orderiD].tokenAddress]+= tradeDetails[5];
346                     }
347               
348                 
349                 if(Order[tradeDetails[8]].tradeAmount==0){
350                     Order[tradeDetails[8]].status=2;    
351                 }
352                 if(Order[orderiD].tradeAmount==0){
353                     Order[orderiD].status=2;    
354                 }
355                   orderPairStatus[orderiD][tradeDetails[8]] = true;
356             }
357 
358         return true; 
359     }
360 
361     function cancelOrder(uint256 orderid)internal returns(bool){
362         if(Order[orderid].status==1){
363             if(Order[orderid].type_ == 0){
364             userDetails[ Order[orderid].userAddress][Order[orderid].tokenAddress]=userDetails[ Order[orderid].userAddress][Order[orderid].tokenAddress].add(Order[orderid].tradeTotal);        
365             }
366             else{
367                 userDetails[ Order[orderid].userAddress][Order[orderid].tokenAddress]=userDetails[ Order[orderid].userAddress][Order[orderid].tokenAddress].add(Order[orderid].tradeAmount);
368             }
369             Order[orderid].status=3;    // cancelled
370         }
371         return true;
372 }
373     
374     
375      function viewTokenBalance(address tokenAddr,address baladdr)public view returns(uint256){
376         return Token(tokenAddr).balanceOf(baladdr);
377     }
378     
379     function tokenallowance(address tokenAddr,address owner) public view returns(uint256){
380         return Token(tokenAddr).allowance(owner,address(this));
381     }
382     
383 }