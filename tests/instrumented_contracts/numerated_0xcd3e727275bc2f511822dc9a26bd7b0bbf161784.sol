1 /* 
2 http://platform.dao.casino 
3 For questions contact noxon i448539@gmail.com
4 */
5 
6 pragma solidity ^0.4.8;
7 
8 //ide http://dapps.oraclize.it/browser-solidity/
9 
10 // <ORACLIZE_API>
11 /*
12 Copyright (c) 2015-2016 Oraclize SRL
13 Copyright (c) 2016 Oraclize LTD
14 
15 
16 
17 Permission is hereby granted, free of charge, to any person obtaining a copy
18 of this software and associated documentation files (the "Software"), to deal
19 in the Software without restriction, including without limitation the rights
20 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 copies of the Software, and to permit persons to whom the Software is
22 furnished to do so, subject to the following conditions:
23 
24 
25 
26 The above copyright notice and this permission notice shall be included in
27 all copies or substantial portions of the Software.
28 
29 
30 
31 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
32 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
33 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
34 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
35 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
36 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
37 THE SOFTWARE.
38 */
39 
40 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
41 
42 contract OraclizeI {
43     address public cbAddress;
44     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
45     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
46     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
47     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
48     function getPrice(string _datasource) returns (uint _dsprice);
49     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
50     function useCoupon(string _coupon);
51     function setProofType(byte _proofType);
52     function setConfig(bytes32 _config);
53     function setCustomGasPrice(uint _gasPrice);
54 }
55 contract OraclizeAddrResolverI {
56     function getAddress() returns (address _addr);
57 }
58 contract usingOraclize {
59     uint constant day = 60*60*24;
60     uint constant week = 60*60*24*7;
61     uint constant month = 60*60*24*30;
62     byte constant proofType_NONE = 0x00;
63     byte constant proofType_TLSNotary = 0x10;
64     byte constant proofStorage_IPFS = 0x01;
65     uint8 constant networkID_auto = 0;
66     uint8 constant networkID_mainnet = 1;
67     uint8 constant networkID_testnet = 2;
68     uint8 constant networkID_morden = 2;
69     uint8 constant networkID_consensys = 161;
70 
71     OraclizeAddrResolverI OAR;
72     
73     OraclizeI oraclize;
74     modifier oraclizeAPI {
75         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
76         oraclize = OraclizeI(OAR.getAddress());
77         _;
78     }
79     modifier coupon(string code){
80         oraclize = OraclizeI(OAR.getAddress());
81         oraclize.useCoupon(code);
82         _;
83     }
84 
85     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
86         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
87             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
88             return true;
89         }
90         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
91             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
92             return true;
93         }
94         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){ //ether.camp ide
95             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
96             return true;
97         }
98         if (getCodeSize(0x93bbbe5ce77034e3095f0479919962a903f898ad)>0){ //norsborg testnet
99             OAR = OraclizeAddrResolverI(0x93bbbe5ce77034e3095f0479919962a903f898ad);
100             return true;
101         }
102         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
103             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
104             return true;
105         }
106         return false;
107     }
108     
109     function __callback(bytes32 myid, string result) {
110         __callback(myid, result, new bytes(0));
111     }
112     function __callback(bytes32 myid, string result, bytes proof) {
113     }
114     
115     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
116         return oraclize.getPrice(datasource);
117     }
118     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
119         return oraclize.getPrice(datasource, gaslimit);
120     }
121     
122     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource);
124         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
125         return oraclize.query.value(price)(0, datasource, arg);
126     }
127     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query.value(price)(timestamp, datasource, arg);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource, gaslimit);
134         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
135         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
136     }
137     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
141     }
142     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource);
144         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
145         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
146     }
147     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
151     }
152     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
153         uint price = oraclize.getPrice(datasource, gaslimit);
154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
155         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
156     }
157     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource, gaslimit);
159         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
160         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
161     }
162     function oraclize_cbAddress() oraclizeAPI internal returns (address){
163         return oraclize.cbAddress();
164     }
165     function oraclize_setProof(byte proofP) oraclizeAPI internal {
166         return oraclize.setProofType(proofP);
167     }
168     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
169         return oraclize.setCustomGasPrice(gasPrice);
170     }    
171     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
172         return oraclize.setConfig(config);
173     }
174 
175     function getCodeSize(address _addr) constant internal returns(uint _size) {
176         assembly {
177             _size := extcodesize(_addr)
178         }
179     }
180 
181 
182     function parseAddr(string _a) internal returns (address){
183         bytes memory tmp = bytes(_a);
184         uint160 iaddr = 0;
185         uint160 b1;
186         uint160 b2;
187         for (uint i=2; i<2+2*20; i+=2){
188             iaddr *= 256;
189             b1 = uint160(tmp[i]);
190             b2 = uint160(tmp[i+1]);
191             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
192             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
193             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
194             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
195             iaddr += (b1*16+b2);
196         }
197         return address(iaddr);
198     }
199 
200 
201     function strCompare(string _a, string _b) internal returns (int) {
202         bytes memory a = bytes(_a);
203         bytes memory b = bytes(_b);
204         uint minLength = a.length;
205         if (b.length < minLength) minLength = b.length;
206         for (uint i = 0; i < minLength; i ++)
207             if (a[i] < b[i])
208                 return -1;
209             else if (a[i] > b[i])
210                 return 1;
211         if (a.length < b.length)
212             return -1;
213         else if (a.length > b.length)
214             return 1;
215         else
216             return 0;
217    } 
218 
219     function indexOf(string _haystack, string _needle) internal returns (int)
220     {
221         bytes memory h = bytes(_haystack);
222         bytes memory n = bytes(_needle);
223         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
224             return -1;
225         else if(h.length > (2**128 -1))
226             return -1;                                  
227         else
228         {
229             uint subindex = 0;
230             for (uint i = 0; i < h.length; i ++)
231             {
232                 if (h[i] == n[0])
233                 {
234                     subindex = 1;
235                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
236                     {
237                         subindex++;
238                     }   
239                     if(subindex == n.length)
240                         return int(i);
241                 }
242             }
243             return -1;
244         }   
245     }
246 
247     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
248         bytes memory _ba = bytes(_a);
249         bytes memory _bb = bytes(_b);
250         bytes memory _bc = bytes(_c);
251         bytes memory _bd = bytes(_d);
252         bytes memory _be = bytes(_e);
253         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
254         bytes memory babcde = bytes(abcde);
255         uint k = 0;
256         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
257         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
258         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
259         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
260         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
261         return string(babcde);
262     }
263     
264     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
265         return strConcat(_a, _b, _c, _d, "");
266     }
267 
268     function strConcat(string _a, string _b, string _c) internal returns (string) {
269         return strConcat(_a, _b, _c, "", "");
270     }
271 
272     function strConcat(string _a, string _b) internal returns (string) {
273         return strConcat(_a, _b, "", "", "");
274     }
275 
276     // parseInt
277     function parseInt(string _a) internal returns (uint) {
278         return parseInt(_a, 0);
279     }
280 
281     // parseInt(parseFloat*10^_b)
282     function parseInt(string _a, uint _b) internal returns (uint) {
283         bytes memory bresult = bytes(_a);
284         uint mint = 0;
285         bool decimals = false;
286         for (uint i=0; i<bresult.length; i++){
287             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
288                 if (decimals){
289                    if (_b == 0) break;
290                     else _b--;
291                 }
292                 mint *= 10;
293                 mint += uint(bresult[i]) - 48;
294             } else if (bresult[i] == 46) decimals = true;
295         }
296         if (_b > 0) mint *= 10**_b;
297         return mint;
298     }
299     
300     function uint2str(uint i) internal returns (string){
301         if (i == 0) return "0";
302         uint j = i;
303         uint len;
304         while (j != 0){
305             len++;
306             j /= 10;
307         }
308         bytes memory bstr = new bytes(len);
309         uint k = len - 1;
310         while (i != 0){
311             bstr[k--] = byte(48 + i % 10);
312             i /= 10;
313         }
314         return string(bstr);
315     }
316     
317     
318 
319 }
320 // </ORACLIZE_API>
321 
322 
323 
324 contract HackDao is usingOraclize {
325   
326    struct Game {
327 	    address player;
328 	    bool results;
329 	    uint betsvalue;
330 	    uint betslevel;
331 	}
332 	
333   mapping (bytes32 => address) bets;
334   mapping (bytes32 => bool) public results; 
335   mapping (bytes32 => uint) betsvalue;
336   mapping (bytes32 => uint) betslevel;
337   address public owner;
338   
339   
340     
341   function HackDao() {
342     
343     if (owner>0) throw;
344     owner = msg.sender;
345     //oraclize_setNetwork(networkID_consensys);
346     }
347   
348   modifier onlyOwner {
349         if (msg.sender != owner)
350             throw;
351         _;
352     }
353 	
354   event LogB(bytes32 h);
355   event LogS(string s);
356   event LogI(uint s);
357     
358 	  function game (uint level) payable returns (bytes32) {
359 	   
360 	   if (msg.value <= 0) throw;
361 	   if (level > 10) throw;
362 	   if (level < 1) throw;
363 	   
364 	   
365 	   //temprorary  disabled
366 	   /* 
367 	   if (level == 1 && msg.value < 0.99 ether) throw;
368 	   if (level == 2 && msg.value < 0.99 ether*1.09) throw;
369 	   if (level == 3 && msg.value < 0.99 ether*1.3298) throw;
370 	   if (level == 4 && msg.value < 0.99 ether*1.86172) throw;
371 	   if (level == 5 && msg.value < 0.99 ether*3.0346036) throw;
372 	   if (level == 6 && msg.value < 0.99 ether*5.947823056) throw;
373 	   if (level == 7 && msg.value < 0.99 ether*14.5721664872) throw;
374 	   if (level == 8 && msg.value < 0.99 ether*47.505262748272) throw;
375 	   if (level == 9 && msg.value < 0.99 ether*232.7757874665328) throw;
376 	   */
377 	  
378 	   
379 	   if (msg.value > 10 ether) throw;
380 	   
381   	   uint random_number;
382   	   
383 	   if (msg.value < 5 ether) {
384     	    myid = bytes32(keccak256(msg.sender, block.blockhash(block.number - 1)));
385     	    random_number = uint(block.blockhash(block.number-1))%10 + 1;
386 	   } else {
387 	        bytes32 myid = oraclize_query("WolframAlpha", "random integer number between 1 and 10");
388 	   }
389   	   
390   	   bets[myid] = msg.sender;
391   	   betsvalue[myid] = msg.value; //-10000000000000000 ставка за вычитом расходов на оракула ~0.01 eth
392   	   betslevel[myid] = level;
393   	   
394   	   if (random_number > 0) __callback(myid, uint2str(random_number),true);
395   	  
396   	   LogB(myid);
397   	   
398   	   
399   	   return myid;
400 	  }
401 	 
402 	  function get_return_by_level(uint level) {
403 	      
404 	  }
405 	  
406 
407 	  function __callback(bytes32 myid, string result) {
408 	      __callback(myid, result, false);
409 	  }
410 	   
411 	  function __callback(bytes32 myid, string result, bool ishashranodm) {
412         LogS('callback');
413         if (msg.sender != oraclize_cbAddress() && ishashranodm == false) throw;
414        
415         //log0(result);
416       
417         //TODO alex bash
418 
419         
420         LogB(myid);
421         
422         if (parseInt(result) > betslevel[myid]) {
423             LogS("win");
424             LogI(betslevel[myid]);
425             uint koef;
426             if (betslevel[myid] == 1) koef = 109; //90
427             if (betslevel[myid] == 2) koef = 122; //80
428             if (betslevel[myid] == 3) koef = 140; //70
429             if (betslevel[myid] == 4) koef = 163; //
430             if (betslevel[myid] == 5) koef = 196;
431             if (betslevel[myid] == 6) koef = 245;
432             if (betslevel[myid] == 7) koef = 326;
433             if (betslevel[myid] == 8) koef = 490;
434             if (betslevel[myid] == 9) koef = 980;
435             
436             if (!bets[myid].send(betsvalue[myid]*koef/100)) {LogS("bug! bet to winner was not sent!");} else {
437                 //LogI();
438               }
439             results[myid] = true;
440         } else {
441                 
442             LogS("lose");
443             results[myid] = false;
444         }
445         
446       }
447       
448       
449       function ownerDeposit() payable onlyOwner  {
450         
451       }
452       
453       function ownerWithdrawl() onlyOwner  {
454         owner.send(this.balance);
455       }
456     
457 }