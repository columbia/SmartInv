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
251 library SafeMath {
252   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253     if (a == 0) {
254       return 0;
255     }
256     uint256 c = a * b;
257     require(c / a == b);
258     return c;
259   }
260 
261   function div(uint256 a, uint256 b) internal pure returns (uint256) {
262     uint256 c = a / b;
263     return c;
264   }
265 
266   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267     require(b <= a);
268     return a - b;
269   }
270 
271   function add(uint256 a, uint256 b) internal pure returns (uint256) {
272     uint256 c = a + b;
273     require(c >= a);
274     return c;
275   }
276 }
277 
278 contract owned {
279     address public owner;
280 
281     function owned() public {
282         owner = msg.sender;
283     }
284 
285     modifier onlyOwner {
286         require(msg.sender == owner);
287         _;
288     }
289 }
290 
291 contract coinback is owned,usingOraclize {
292 
293     using SafeMath for uint256;
294     struct betInfo{
295         address srcAddress;
296         uint256 betValue;
297     }
298 
299     uint256 private POOL_AWARD;
300     uint256 constant FREE_PERCENT = 1;
301 
302     uint32 private oraclizeGas = 200000;
303     uint32 constant MAX_RANDOM_NUM = 1000000;
304     betInfo private overBetPlayer;
305     uint256 private betId;
306 
307     uint256 private turnId;
308     uint256 private beginTime;
309     uint256 private totalAward;
310     uint256 private realAward;
311 
312     bool public stopContract;
313     bool public stopBet;
314     bool private exitOverPlayer;
315     bool private generateRandom;
316     uint256 private randomBalance;
317     mapping(uint256=>betInfo) private betMap;
318     uint256 private randomNum;
319 
320     event LOG_NewTurn(uint256 turnNo,uint256 time,uint256 totalnum);
321     event LOG_PlayerBet(address srcAddress,uint256 betNum,uint256 turnNo,uint256 totalnum,uint256 time);
322     event LOG_LuckyPLayer(address luckyAddress,uint256 luckyNum,uint256 turnNo);
323     event LOG_Random(uint256 random);
324     modifier onlyOwner {
325         if (owner != msg.sender) throw;
326         _;
327     }
328 
329     modifier notStopContract {
330         if (stopContract) throw;
331         _;
332     }
333 
334     modifier notStopBet {
335         if (stopBet) throw;
336         _;
337     }
338 
339     modifier notBiger{
340         if(msg.value > POOL_AWARD) throw;
341         _;
342     }
343 
344     modifier onlyRandom{
345         if(!generateRandom) throw;
346         _;
347     }
348 
349     function coinback(uint256 initPool){
350         POOL_AWARD = initPool;
351         turnId = 0;
352         stopContract = false;
353         exitOverPlayer = false;
354         betId = 0;
355         generateRandom = false;
356         startNewTurn();
357     }
358 
359     function ()payable {
360         bet();
361     }
362 
363     function bet() payable
364         notStopContract
365         notStopBet
366         notBiger
367         {
368 
369         uint256 betValue = msg.value;
370         totalAward = address(this).balance;
371         if(totalAward > POOL_AWARD)
372             totalAward = POOL_AWARD;
373 
374         realAward = totalAward;
375 
376         if(address(this).balance >= POOL_AWARD)
377         {
378             uint256 overValue = address(this).balance.sub(POOL_AWARD);
379             if(overValue > 0)
380             {
381                 betValue = betValue.sub(overValue);
382                 overBetPlayer = betInfo({srcAddress:msg.sender,betValue:overValue});
383                 exitOverPlayer = true;
384             }
385             stopBet = true;
386         }
387         betMap[betId] = betInfo({srcAddress:msg.sender,betValue:betValue});
388         betId = betId.add(1);
389 
390         LOG_PlayerBet(msg.sender,betValue,turnId,totalAward,beginTime);
391 
392         if(stopBet)
393           closeThisTurn();
394     }
395 
396     function __callback(bytes32 myid, string result) {
397         if (msg.sender != oraclize_cbAddress()) throw;
398 
399         randomNum = parseInt(result);
400         generateRandom = true;
401         LOG_Random(randomNum);
402     }
403 
404     function afterCallBack() onlyOwner
405         onlyRandom{
406 
407         generateRandom = false;
408         totalAward = address(this).balance;
409         if(totalAward > POOL_AWARD)
410             totalAward = POOL_AWARD;
411 
412         randomBalance = totalAward.mul(randomNum).div(MAX_RANDOM_NUM);
413         uint256 index = getLunckyIndex();
414         uint256 winCoin = totalAward.mul(100-FREE_PERCENT).div(100);
415         uint256 waiterfree = totalAward.mul(FREE_PERCENT).div(100);
416 
417         LOG_LuckyPLayer(betMap[index].srcAddress,realAward,turnId);
418 
419         if(!betMap[index].srcAddress.send(winCoin)) throw;
420         if(!owner.send(waiterfree)) throw;
421 
422         startNewTurn();
423 
424     }
425     function getLunckyIndex() private returns(uint256){
426 
427         uint256 range = 0;
428         for(uint256 i =0; i< betId; i++)
429         {
430             range = range.add(betMap[i].betValue);
431             if(range >= randomBalance)
432             {
433                 return i;
434             }
435         }
436     }
437 
438     function startNewTurn() private{
439 
440         clearBetMap();
441         betId = 0;
442         turnId = turnId.add(1);
443         beginTime = now;
444         totalAward = address(this).balance;
445         stopBet = false;
446         if(exitOverPlayer)
447         {
448             betMap[betId] = overBetPlayer;
449             betId = betId.add(1);
450             exitOverPlayer = false;
451             LOG_PlayerBet(overBetPlayer.srcAddress,overBetPlayer.betValue,turnId,totalAward,beginTime);
452         }
453         LOG_NewTurn(turnId,beginTime,totalAward);
454     }
455 
456     function clearBetMap() private{
457         for(uint256 i=0;i<betId;i++){
458             delete betMap[i];
459         }
460     }
461 
462     function closeThisTurn() private{
463 
464         bytes32 oid = oraclize_query("URL","https://www.random.org/integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new",oraclizeGas);
465     }
466 
467     function closeTurnByHand(uint256 no) onlyOwner{
468         if(turnId != no) throw;
469         if(address(this).balance == 0) throw;
470         stopBet = true;
471         closeThisTurn();
472     }
473 
474     function killContract() onlyOwner {
475         selfdestruct(owner);
476     }
477 
478     function destroyContract() onlyOwner{
479         stopContract = true;
480     }
481 
482     function changeOwner(address newOwner) onlyOwner{
483         owner = newOwner;
484     }
485 
486     function resetState() onlyOwner{
487         stopBet = false;
488     }
489 }