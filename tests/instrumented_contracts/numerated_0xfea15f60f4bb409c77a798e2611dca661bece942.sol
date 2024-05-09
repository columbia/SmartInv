1 pragma solidity ^0.4.0;
2 contract OraclizeI {
3     address public cbAddress;
4     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
5     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
6     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
7     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
8     function getPrice(string _datasource) returns (uint _dsprice);
9     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
10     function useCoupon(string _coupon);
11     function setProofType(byte _proofType);
12     function setCustomGasPrice(uint _gasPrice);
13 }
14 contract OraclizeAddrResolverI {
15     function getAddress() returns (address _addr);
16 }
17 contract usingOraclize {
18     uint constant day = 60*60*24;
19     uint constant week = 60*60*24*7;
20     uint constant month = 60*60*24*30;
21     byte constant proofType_NONE = 0x00;
22     byte constant proofType_TLSNotary = 0x10;
23     byte constant proofStorage_IPFS = 0x01;
24     uint8 constant networkID_auto = 0;
25     uint8 constant networkID_mainnet = 1;
26     uint8 constant networkID_testnet = 2;
27     uint8 constant networkID_morden = 2;
28     uint8 constant networkID_consensys = 161;
29 
30     OraclizeAddrResolverI OAR;
31 
32     OraclizeI oraclize;
33     modifier oraclizeAPI {
34         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
35         oraclize = OraclizeI(OAR.getAddress());
36         _;
37     }
38     modifier coupon(string code){
39         oraclize = OraclizeI(OAR.getAddress());
40         oraclize.useCoupon(code);
41         _;
42     }
43 
44     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
45         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
46             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
47             return true;
48         }
49         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
50             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
51             return true;
52         }
53         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
54             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
55             return true;
56         }
57         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
58             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
59             return true;
60         }
61         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
62             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
63             return true;
64         }
65         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
66             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
67             return true;
68         }
69         return false;
70     }
71 
72     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
73         uint price = oraclize.getPrice(datasource);
74         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
75         return oraclize.query.value(price)(0, datasource, arg);
76     }
77     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
78         uint price = oraclize.getPrice(datasource);
79         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
80         return oraclize.query.value(price)(timestamp, datasource, arg);
81     }
82     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
83         uint price = oraclize.getPrice(datasource, gaslimit);
84         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
85         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
86     }
87     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
88         uint price = oraclize.getPrice(datasource, gaslimit);
89         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
90         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
91     }
92     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
93         uint price = oraclize.getPrice(datasource);
94         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
95         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
96     }
97     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
98         uint price = oraclize.getPrice(datasource);
99         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
100         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
101     }
102     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
103         uint price = oraclize.getPrice(datasource, gaslimit);
104         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
105         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
106     }
107     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource, gaslimit);
109         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
110         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
111     }
112     function oraclize_cbAddress() oraclizeAPI internal returns (address){
113         return oraclize.cbAddress();
114     }
115     function oraclize_setProof(byte proofP) oraclizeAPI internal {
116         return oraclize.setProofType(proofP);
117     }
118     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
119         return oraclize.setCustomGasPrice(gasPrice);
120     }
121 
122     function getCodeSize(address _addr) constant internal returns(uint _size) {
123         assembly {
124             _size := extcodesize(_addr)
125         }
126     }
127 
128 
129     function parseAddr(string _a) internal returns (address){
130         bytes memory tmp = bytes(_a);
131         uint160 iaddr = 0;
132         uint160 b1;
133         uint160 b2;
134         for (uint i=2; i<2+2*20; i+=2){
135             iaddr *= 256;
136             b1 = uint160(tmp[i]);
137             b2 = uint160(tmp[i+1]);
138             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
139             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
140             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
141             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
142             iaddr += (b1*16+b2);
143         }
144         return address(iaddr);
145     }
146 
147 
148     function strCompare(string _a, string _b) internal returns (int) {
149         bytes memory a = bytes(_a);
150         bytes memory b = bytes(_b);
151         uint minLength = a.length;
152         if (b.length < minLength) minLength = b.length;
153         for (uint i = 0; i < minLength; i ++)
154             if (a[i] < b[i])
155                 return -1;
156             else if (a[i] > b[i])
157                 return 1;
158         if (a.length < b.length)
159             return -1;
160         else if (a.length > b.length)
161             return 1;
162         else
163             return 0;
164    }
165 
166     function indexOf(string _haystack, string _needle) internal returns (int)
167     {
168         bytes memory h = bytes(_haystack);
169         bytes memory n = bytes(_needle);
170         if(h.length < 1 || n.length < 1 || (n.length > h.length))
171             return -1;
172         else if(h.length > (2**128 -1))
173             return -1;
174         else
175         {
176             uint subindex = 0;
177             for (uint i = 0; i < h.length; i ++)
178             {
179                 if (h[i] == n[0])
180                 {
181                     subindex = 1;
182                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
183                     {
184                         subindex++;
185                     }
186                     if(subindex == n.length)
187                         return int(i);
188                 }
189             }
190             return -1;
191         }
192     }
193 
194     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
195         bytes memory _ba = bytes(_a);
196         bytes memory _bb = bytes(_b);
197         bytes memory _bc = bytes(_c);
198         bytes memory _bd = bytes(_d);
199         bytes memory _be = bytes(_e);
200         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
201         bytes memory babcde = bytes(abcde);
202         uint k = 0;
203         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
204         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
205         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
206         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
207         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
208         return string(babcde);
209     }
210 
211     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
212         return strConcat(_a, _b, _c, _d, "");
213     }
214 
215     function strConcat(string _a, string _b, string _c) internal returns (string) {
216         return strConcat(_a, _b, _c, "", "");
217     }
218 
219     function strConcat(string _a, string _b) internal returns (string) {
220         return strConcat(_a, _b, "", "", "");
221     }
222 
223     // parseInt
224     function parseInt(string _a) internal returns (uint) {
225         return parseInt(_a, 0);
226     }
227 
228     // parseInt(parseFloat*10^_b)
229     function parseInt(string _a, uint _b) internal returns (uint) {
230         bytes memory bresult = bytes(_a);
231         uint mint = 0;
232         bool decimals = false;
233         for (uint i=0; i<bresult.length; i++){
234             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
235                 if (decimals){
236                    if (_b == 0) break;
237                     else _b--;
238                 }
239                 mint *= 10;
240                 mint += uint(bresult[i]) - 48;
241             } else if (bresult[i] == 46) decimals = true;
242         }
243         if (_b > 0) mint *= 10**_b;
244         return mint;
245     }
246 
247 
248 }
249 // </ORACLIZE_API>
250 
251 contract coinback is usingOraclize {
252 
253     struct betInfo{
254         address srcAddress;
255         uint betValue;
256     }
257 
258     uint POOL_AWARD;                                          //奖池
259     uint constant FREE_PERCENT = 1;                          //服务费用比例1%
260 
261     uint32 public oraclizeGas = 200000;
262     uint32 constant MAX_RANDOM_NUM = 1000000;                 //最大随机数
263     betInfo overBetPlayer;                                    //超过奖池的玩家
264     uint32 betId;
265     uint32 luckyIndex;
266     uint32 public turnId;                                     //期数
267     uint   public beginTime;                                  //当期开始时间
268     uint   public totalAward;                                 //累计奖励
269 
270     bool public stopContract;                                 //停止合约
271     bool public stopBet;                                      //停止投注
272     bool public exitOverPlayer;
273     address owner;
274     mapping(uint32=>betInfo) betMap;
275 
276     event LOG_NewTurn(uint turnNo,uint time,uint totalnum);                                         //新一轮(期号,开始时间,奖池金额)
277     event LOG_PlayerBet(address srcAddress,uint betNum,uint turnNo,uint totalnum,uint time);        //投注事件(地址，金额，期号，奖池金额，本期开始时间)
278     event LOG_LuckyPLayer(address luckyAddress,uint luckyNum,uint turnNo);                         //中奖事件(中奖地址，奖池金额，期数)
279 
280     modifier onlyOwner {
281         if (owner != msg.sender) throw;
282         _;
283     }
284 
285     modifier notStopContract {
286         if (stopContract) throw;
287         _;
288     }
289 
290     modifier notStopBet {
291         if (stopBet) throw;
292         _;
293     }
294 
295     function coinback(uint initPool){
296 
297         owner = msg.sender;
298         POOL_AWARD = initPool;
299         turnId = 0;
300         stopContract = false;
301         exitOverPlayer = false;
302         betId = 0;
303         startNewTurn();
304     }
305 
306     function ()payable {
307         bet();
308     }
309 
310     function bet() payable
311         notStopContract
312         notStopBet{
313 
314         uint betValue = msg.value;
315         totalAward = address(this).balance;
316         if(totalAward > POOL_AWARD)
317             totalAward = POOL_AWARD;
318 
319         if(address(this).balance >= POOL_AWARD)
320         {
321             uint overValue = address(this).balance - POOL_AWARD;
322             if(overValue > 0)
323             {
324                 betValue = betValue - overValue;
325                 overBetPlayer = betInfo({srcAddress:msg.sender,betValue:overValue});
326             }
327             stopBet = true;
328         }
329         betMap[betId] = betInfo({srcAddress:msg.sender,betValue:betValue});
330         betId++;
331 
332         LOG_PlayerBet(msg.sender,msg.value,turnId,totalAward,beginTime);
333 
334         if(stopBet)
335           closeThisTurn();
336     }
337 
338     function __callback(bytes32 myid, string result) {
339         if (msg.sender != oraclize_cbAddress()) throw;
340 
341         uint randomNum = parseInt(result);
342         totalAward = address(this).balance;
343         if(totalAward > POOL_AWARD)
344             totalAward = POOL_AWARD;
345 
346         uint randomBalance = totalAward*randomNum/MAX_RANDOM_NUM;
347         uint32 index = 0;
348 
349         index = getLunckyIndex(randomBalance);
350         uint winCoin = totalAward*(100-FREE_PERCENT)/100;
351         uint waiterfree = totalAward*FREE_PERCENT/100;
352 
353         LOG_LuckyPLayer(betMap[index].srcAddress,totalAward,turnId);
354 
355         if(!betMap[index].srcAddress.send(winCoin)) throw;
356         if(!owner.send(waiterfree)) throw;
357 
358         startNewTurn();
359     }
360 
361     function getLunckyIndex(uint randomBalance) private returns(uint32){
362 
363         uint range = 0;
364         for(uint32 i =0; i< betId; i++)
365         {
366             range += betMap[i].betValue;
367             if(range >= randomBalance)
368             {
369                 luckyIndex = i;
370                 return i;
371             }
372         }
373     }
374 
375     function startNewTurn() private{
376 
377         clearBetMap();
378         betId = 0;
379         if(exitOverPlayer)
380         {
381             betMap[betId] = overBetPlayer;
382             betId++;
383             exitOverPlayer = false;
384         }
385         turnId++;
386         beginTime = now;
387         totalAward = address(this).balance;
388         stopBet = false;
389         LOG_NewTurn(turnId,beginTime,totalAward);
390     }
391 
392     function clearBetMap() private{
393         for(uint32 i=0;i<betId;i++){
394             delete betMap[i];
395         }
396     }
397 
398     function closeThisTurn() private{
399         bytes32 oid = oraclize_query("URL","https://www.random.org/integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new",oraclizeGas);
400     }
401 
402     function getLunckyInfo() returns(uint32,address,bool){
403         return (luckyIndex,betMap[luckyIndex].srcAddress,stopContract);
404     }
405 
406     function getOverPLayer() returns(address,uint){
407         return (overBetPlayer.srcAddress,overBetPlayer.betValue);
408     }
409     /***********操作合约**********/
410 
411     function closeTurnByHand(uint32 no) onlyOwner{
412         if(turnId != no) throw;
413         if(address(this).balance == 0) throw;
414         stopBet = true;
415         closeThisTurn();
416     }
417 
418     function killContract() onlyOwner {
419         selfdestruct(owner);
420     }
421 
422     function destroyContract() onlyOwner{
423         stopContract = true;
424     }
425 
426     function changeOwner(address newOwner) onlyOwner{
427         owner = newOwner;
428     }
429 }