1 /* 
2 http://platform.dao.casino 
3 */
4 
5 pragma solidity ^0.4.8;
6 
7 //ide http://dapps.oraclize.it/browser-solidity/
8 
9 // <ORACLIZE_API>
10 /*
11 Copyright (c) 2015-2016 Oraclize SRL
12 Copyright (c) 2016 Oraclize LTD
13 
14 
15 
16 Permission is hereby granted, free of charge, to any person obtaining a copy
17 of this software and associated documentation files (the "Software"), to deal
18 in the Software without restriction, including without limitation the rights
19 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 copies of the Software, and to permit persons to whom the Software is
21 furnished to do so, subject to the following conditions:
22 
23 
24 
25 The above copyright notice and this permission notice shall be included in
26 all copies or substantial portions of the Software.
27 
28 
29 
30 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
33 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
36 THE SOFTWARE.
37 */
38 
39 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
40 
41 contract OraclizeI {
42     address public cbAddress;
43     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
44     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
45     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
46     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
47     function getPrice(string _datasource) returns (uint _dsprice);
48     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
49     function useCoupon(string _coupon);
50     function setProofType(byte _proofType);
51     function setConfig(bytes32 _config);
52     function setCustomGasPrice(uint _gasPrice);
53 }
54 contract OraclizeAddrResolverI {
55     function getAddress() returns (address _addr);
56 }
57 contract usingOraclize {
58     uint constant day = 60*60*24;
59     uint constant week = 60*60*24*7;
60     uint constant month = 60*60*24*30;
61     byte constant proofType_NONE = 0x00;
62     byte constant proofType_TLSNotary = 0x10;
63     byte constant proofStorage_IPFS = 0x01;
64     uint8 constant networkID_auto = 0;
65     uint8 constant networkID_mainnet = 1;
66     uint8 constant networkID_testnet = 2;
67     uint8 constant networkID_morden = 2;
68     uint8 constant networkID_consensys = 161;
69 
70     OraclizeAddrResolverI OAR;
71     
72     OraclizeI oraclize;
73     modifier oraclizeAPI {
74         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
75         oraclize = OraclizeI(OAR.getAddress());
76         _;
77     }
78     modifier coupon(string code){
79         oraclize = OraclizeI(OAR.getAddress());
80         oraclize.useCoupon(code);
81         _;
82     }
83 
84     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
85         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
86             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
87             return true;
88         }
89         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
90             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
91             return true;
92         }
93         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
94             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
95             return true;
96         }
97         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
98             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
99             return true;
100         }
101         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
102             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
103             return true;
104         }
105         return false;
106     }
107     
108     function __callback(bytes32 myid, string result) {
109         __callback(myid, result, new bytes(0));
110     }
111     function __callback(bytes32 myid, string result, bytes proof) {
112     }
113     
114     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
115         return oraclize.getPrice(datasource);
116     }
117     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
118         return oraclize.getPrice(datasource, gaslimit);
119     }
120     
121     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource);
123         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
124         return oraclize.query.value(price)(0, datasource, arg);
125     }
126     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource);
128         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
129         return oraclize.query.value(price)(timestamp, datasource, arg);
130     }
131     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource, gaslimit);
133         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
134         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
135     }
136     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource, gaslimit);
138         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
139         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
140     }
141     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource);
143         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
144         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
145     }
146     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource);
148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
149         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
150     }
151     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource, gaslimit);
153         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
154         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
155     }
156     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
157         uint price = oraclize.getPrice(datasource, gaslimit);
158         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
159         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
160     }
161     function oraclize_cbAddress() oraclizeAPI internal returns (address){
162         return oraclize.cbAddress();
163     }
164     function oraclize_setProof(byte proofP) oraclizeAPI internal {
165         return oraclize.setProofType(proofP);
166     }
167     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
168         return oraclize.setCustomGasPrice(gasPrice);
169     }    
170     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
171         return oraclize.setConfig(config);
172     }
173 
174     function getCodeSize(address _addr) constant internal returns(uint _size) {
175         assembly {
176             _size := extcodesize(_addr)
177         }
178     }
179 
180 
181     function parseAddr(string _a) internal returns (address){
182         bytes memory tmp = bytes(_a);
183         uint160 iaddr = 0;
184         uint160 b1;
185         uint160 b2;
186         for (uint i=2; i<2+2*20; i+=2){
187             iaddr *= 256;
188             b1 = uint160(tmp[i]);
189             b2 = uint160(tmp[i+1]);
190             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
191             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
192             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
193             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
194             iaddr += (b1*16+b2);
195         }
196         return address(iaddr);
197     }
198 
199 
200     function strCompare(string _a, string _b) internal returns (int) {
201         bytes memory a = bytes(_a);
202         bytes memory b = bytes(_b);
203         uint minLength = a.length;
204         if (b.length < minLength) minLength = b.length;
205         for (uint i = 0; i < minLength; i ++)
206             if (a[i] < b[i])
207                 return -1;
208             else if (a[i] > b[i])
209                 return 1;
210         if (a.length < b.length)
211             return -1;
212         else if (a.length > b.length)
213             return 1;
214         else
215             return 0;
216    } 
217 
218     function indexOf(string _haystack, string _needle) internal returns (int)
219     {
220         bytes memory h = bytes(_haystack);
221         bytes memory n = bytes(_needle);
222         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
223             return -1;
224         else if(h.length > (2**128 -1))
225             return -1;                                  
226         else
227         {
228             uint subindex = 0;
229             for (uint i = 0; i < h.length; i ++)
230             {
231                 if (h[i] == n[0])
232                 {
233                     subindex = 1;
234                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
235                     {
236                         subindex++;
237                     }   
238                     if(subindex == n.length)
239                         return int(i);
240                 }
241             }
242             return -1;
243         }   
244     }
245 
246     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
247         bytes memory _ba = bytes(_a);
248         bytes memory _bb = bytes(_b);
249         bytes memory _bc = bytes(_c);
250         bytes memory _bd = bytes(_d);
251         bytes memory _be = bytes(_e);
252         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
253         bytes memory babcde = bytes(abcde);
254         uint k = 0;
255         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
256         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
257         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
258         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
259         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
260         return string(babcde);
261     }
262     
263     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
264         return strConcat(_a, _b, _c, _d, "");
265     }
266 
267     function strConcat(string _a, string _b, string _c) internal returns (string) {
268         return strConcat(_a, _b, _c, "", "");
269     }
270 
271     function strConcat(string _a, string _b) internal returns (string) {
272         return strConcat(_a, _b, "", "", "");
273     }
274 
275     // parseInt
276     function parseInt(string _a) internal returns (uint) {
277         return parseInt(_a, 0);
278     }
279 
280     // parseInt(parseFloat*10^_b)
281     function parseInt(string _a, uint _b) internal returns (uint) {
282         bytes memory bresult = bytes(_a);
283         uint mint = 0;
284         bool decimals = false;
285         for (uint i=0; i<bresult.length; i++){
286             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
287                 if (decimals){
288                    if (_b == 0) break;
289                     else _b--;
290                 }
291                 mint *= 10;
292                 mint += uint(bresult[i]) - 48;
293             } else if (bresult[i] == 46) decimals = true;
294         }
295         if (_b > 0) mint *= 10**_b;
296         return mint;
297     }
298     
299     function uint2str(uint i) internal returns (string){
300         if (i == 0) return "0";
301         uint j = i;
302         uint len;
303         while (j != 0){
304             len++;
305             j /= 10;
306         }
307         bytes memory bstr = new bytes(len);
308         uint k = len - 1;
309         while (i != 0){
310             bstr[k--] = byte(48 + i % 10);
311             i /= 10;
312         }
313         return string(bstr);
314     }
315     
316     
317 
318 }
319 // </ORACLIZE_API>
320 
321 
322 
323 contract HackDao is usingOraclize {
324   
325    struct Game {
326 	    address player;
327 	    string results;
328 	    uint betsvalue;
329 	    uint betslevel;
330 	}
331 	
332   mapping (bytes32 => address) bets;
333   mapping (bytes32 => uint8) public results; 
334   mapping (bytes32 => uint) betsvalue;
335   mapping (bytes32 => uint) betslevel;
336   address public owner;
337   
338   
339     
340   function HackDao() {
341     
342     if (owner>0) throw;
343     owner = msg.sender;
344     //oraclize_setNetwork(networkID_consensys);
345     }
346   
347   modifier onlyOwner {
348         if (msg.sender != owner)
349             throw;
350         _;
351     }
352 	
353   event LogB(bytes32 h);
354   event LogS(string s);
355   event LogI(uint s);
356     
357   function game (uint level) payable returns (bytes32) {
358 	   
359 	   if (msg.value <= 0) throw;
360 	   if (level > 10) throw;
361 	   if (level < 1) throw;
362 	   
363 	   
364 	   //temprorary  disabled
365 	   /* 
366 	   if (level == 1 && msg.value < 0.99 ether) throw;
367 	   if (level == 2 && msg.value < 0.99 ether*1.09) throw;
368 	   if (level == 3 && msg.value < 0.99 ether*1.3298) throw;
369 	   if (level == 4 && msg.value < 0.99 ether*1.86172) throw;
370 	   if (level == 5 && msg.value < 0.99 ether*3.0346036) throw;
371 	   if (level == 6 && msg.value < 0.99 ether*5.947823056) throw;
372 	   if (level == 7 && msg.value < 0.99 ether*14.5721664872) throw;
373 	   if (level == 8 && msg.value < 0.99 ether*47.505262748272) throw;
374 	   if (level == 9 && msg.value < 0.99 ether*232.7757874665328) throw;
375 	   */
376 	  
377 	   
378 	   if (msg.value > 10 ether) throw;
379 	   
380   	   uint random_number;
381   	   
382 	   bytes32 myid = oraclize_query("WolframAlpha", "random integer number between 1 and 10");
383   	   
384   	   bets[myid] = msg.sender;
385   	   betsvalue[myid] = msg.value;
386   	   betslevel[myid] = level;
387   	  
388   	   LogB(myid);
389   	   
390   	   return myid;
391 	  }
392 	 
393 
394 	  
395 	   
396 	  function __callback(bytes32 myid, string result) {
397         LogS('callback');
398         
399         if (msg.sender != oraclize_cbAddress()) throw; //check this is oraclize ?
400         if (parseInt(result) > 10) throw;
401         
402 		if (results[myid] == 2 || results[myid] == 1) throw; //this game already run?
403 		
404         LogB(myid);
405          
406         
407         if (parseInt(result) > betslevel[myid]) {
408             LogS("win");
409             LogI(betslevel[myid]);
410             
411             uint koef;
412             if (betslevel[myid] == 1) koef = 109; //90
413             if (betslevel[myid] == 2) koef = 122; //80
414             if (betslevel[myid] == 3) koef = 140; //70
415             if (betslevel[myid] == 4) koef = 163; //
416             if (betslevel[myid] == 5) koef = 196;
417             if (betslevel[myid] == 6) koef = 245;
418             if (betslevel[myid] == 7) koef = 326;
419             if (betslevel[myid] == 8) koef = 490;
420             if (betslevel[myid] == 9) koef = 980;
421             results[myid]=2;
422             if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS("bug! bet to winner was not sent!");} else {
423                
424               }
425         } else {
426             results[myid]=1;
427             LogS("lose");
428         }
429         
430         delete bets[myid];
431         delete results[myid];
432         delete betslevel[myid];
433         delete betsvalue[myid];
434       }
435       
436       
437       function ownerDeposit() payable onlyOwner  {
438         
439       }
440       
441       function ownerWithdrawl(uint amount) onlyOwner  {
442         owner.send(amount);
443       }
444     
445 }