1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
4 
5 
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 
15 
16 The above copyright notice and this permission notice shall be included in
17 all copies or substantial portions of the Software.
18 
19 
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 */
29 
30 pragma solidity ^0.4.0;
31 
32 contract OraclizeI {
33     address public cbAddress;
34     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
35     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
36     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
37     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
38     function getPrice(string _datasource) returns (uint _dsprice);
39     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
40     function useCoupon(string _coupon);
41     function setProofType(byte _proofType);
42     function setCustomGasPrice(uint _gasPrice);
43 }
44 contract OraclizeAddrResolverI {
45     function getAddress() returns (address _addr);
46 }
47 contract usingOraclize {
48     uint constant day = 60*60*24;
49     uint constant week = 60*60*24*7;
50     uint constant month = 60*60*24*30;
51     byte constant proofType_NONE = 0x00;
52     byte constant proofType_TLSNotary = 0x10;
53     byte constant proofStorage_IPFS = 0x01;
54     uint8 constant networkID_auto = 0;
55     uint8 constant networkID_mainnet = 1;
56     uint8 constant networkID_testnet = 2;
57     uint8 constant networkID_morden = 2;
58     uint8 constant networkID_consensys = 161;
59 
60     OraclizeAddrResolverI OAR;
61     
62     OraclizeI oraclize;
63     modifier oraclizeAPI {
64         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
65         oraclize = OraclizeI(OAR.getAddress());
66         _;
67     }
68     modifier coupon(string code){
69         oraclize = OraclizeI(OAR.getAddress());
70         oraclize.useCoupon(code);
71         _;
72     }
73 
74     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
75         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
76             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
77             return true;
78         }
79         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
80             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
81             return true;
82         }
83         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
84             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
85             return true;
86         }
87         if (getCodeSize(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60)>0){
88             OAR = OraclizeAddrResolverI(0x9a1d6e5c6c8d081ac45c6af98b74a42442afba60);
89             return true;
90         }
91         return false;
92     }
93     
94     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
95         uint price = oraclize.getPrice(datasource);
96         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
97         return oraclize.query.value(price)(0, datasource, arg);
98     }
99     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
100         uint price = oraclize.getPrice(datasource);
101         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
102         return oraclize.query.value(price)(timestamp, datasource, arg);
103     }
104     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
105         uint price = oraclize.getPrice(datasource, gaslimit);
106         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
107         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
108     }
109     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
110         uint price = oraclize.getPrice(datasource, gaslimit);
111         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
112         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
113     }
114     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
115         uint price = oraclize.getPrice(datasource);
116         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
117         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
118     }
119     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
120         uint price = oraclize.getPrice(datasource);
121         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
122         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
123     }
124     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
128     }
129     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource, gaslimit);
131         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
132         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
133     }
134     function oraclize_cbAddress() oraclizeAPI internal returns (address){
135         return oraclize.cbAddress();
136     }
137     function oraclize_setProof(byte proofP) oraclizeAPI internal {
138         return oraclize.setProofType(proofP);
139     }
140     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
141         return oraclize.setCustomGasPrice(gasPrice);
142     }    
143 
144     function getCodeSize(address _addr) constant internal returns(uint _size) {
145         assembly {
146             _size := extcodesize(_addr)
147         }
148     }
149 
150 
151     function parseAddr(string _a) internal returns (address){
152         bytes memory tmp = bytes(_a);
153         uint160 iaddr = 0;
154         uint160 b1;
155         uint160 b2;
156         for (uint i=2; i<2+2*20; i+=2){
157             iaddr *= 256;
158             b1 = uint160(tmp[i]);
159             b2 = uint160(tmp[i+1]);
160             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
161             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
162             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
163             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
164             iaddr += (b1*16+b2);
165         }
166         return address(iaddr);
167     }
168 
169 
170     function strCompare(string _a, string _b) internal returns (int) {
171         bytes memory a = bytes(_a);
172         bytes memory b = bytes(_b);
173         uint minLength = a.length;
174         if (b.length < minLength) minLength = b.length;
175         for (uint i = 0; i < minLength; i ++)
176             if (a[i] < b[i])
177                 return -1;
178             else if (a[i] > b[i])
179                 return 1;
180         if (a.length < b.length)
181             return -1;
182         else if (a.length > b.length)
183             return 1;
184         else
185             return 0;
186    } 
187 
188     function indexOf(string _haystack, string _needle) internal returns (int)
189     {
190         bytes memory h = bytes(_haystack);
191         bytes memory n = bytes(_needle);
192         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
193             return -1;
194         else if(h.length > (2**128 -1))
195             return -1;                                  
196         else
197         {
198             uint subindex = 0;
199             for (uint i = 0; i < h.length; i ++)
200             {
201                 if (h[i] == n[0])
202                 {
203                     subindex = 1;
204                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
205                     {
206                         subindex++;
207                     }   
208                     if(subindex == n.length)
209                         return int(i);
210                 }
211             }
212             return -1;
213         }   
214     }
215 
216     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
217         bytes memory _ba = bytes(_a);
218         bytes memory _bb = bytes(_b);
219         bytes memory _bc = bytes(_c);
220         bytes memory _bd = bytes(_d);
221         bytes memory _be = bytes(_e);
222         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
223         bytes memory babcde = bytes(abcde);
224         uint k = 0;
225         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
226         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
227         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
228         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
229         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
230         return string(babcde);
231     }
232     
233     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
234         return strConcat(_a, _b, _c, _d, "");
235     }
236 
237     function strConcat(string _a, string _b, string _c) internal returns (string) {
238         return strConcat(_a, _b, _c, "", "");
239     }
240 
241     function strConcat(string _a, string _b) internal returns (string) {
242         return strConcat(_a, _b, "", "", "");
243     }
244 
245     // parseInt
246     function parseInt(string _a) internal returns (uint) {
247         return parseInt(_a, 0);
248     }
249 
250     // parseInt(parseFloat*10^_b)
251     function parseInt(string _a, uint _b) internal returns (uint) {
252         bytes memory bresult = bytes(_a);
253         uint mint = 0;
254         bool decimals = false;
255         for (uint i=0; i<bresult.length; i++){
256             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
257                 if (decimals){
258                    if (_b == 0) break;
259                     else _b--;
260                 }
261                 mint *= 10;
262                 mint += uint(bresult[i]) - 48;
263             } else if (bresult[i] == 46) decimals = true;
264         }
265         if (_b > 0) mint *= 10**_b;
266         return mint;
267     }
268     
269 
270 }
271 // </ORACLIZE_API>
272 
273 
274 
275 
276 
277 
278 contract mortal {
279     address owner;
280 
281     function mortal() {
282         owner = msg.sender;
283     }
284 
285     function kill() {
286         if (msg.sender == owner) suicide(owner);
287     }
288 }
289 
290 
291 contract slot is mortal, usingOraclize {
292     /** which oraclize ID belong to which player address?**/
293     mapping (bytes32 => address) players; 
294     /** the amount of gas to be sent to oraclize**/
295     uint32 public oraclizeGas;
296     /** probabilities of the different results (absolute frequency out of 1.000.000 spins)**/
297     uint32[] public probabilities;
298     /** the prize per probability (shifted by two digits -> 375 is acutually 3.75)*/
299     uint32[] public prizes;
300     /** the amount of ether per bet **/
301     mapping (bytes32 => uint) bets;
302     /** tell the listeners the result
303     first value: type, second value: player address, third value: oraclize ID**/
304     event gameResult(uint, address);// 0-> %5; 1 -> 80%; 2 -> loss, 3->error in callback;
305 
306     
307     /** **/
308     function slot() payable{
309         probabilities.push(4);
310         probabilities.push(50);
311         probabilities.push(200);
312         probabilities.push(600);
313         probabilities.push(1000);
314         probabilities.push(2000);
315         probabilities.push(4000);
316         probabilities.push(30000);
317         probabilities.push(90000);
318         prizes.push(5000);
319         prizes.push(2500);
320         prizes.push(2000);
321         prizes.push(1900);
322         prizes.push(1800);
323         prizes.push(1700);
324         prizes.push(1600);
325         prizes.push(1500);
326         prizes.push(375);
327         oraclizeGas = 100000;
328     }
329     
330     /**
331      * If more than 0.1 ether and less than 1 ether is sent and the contracts holds enough to pay out the player in case of a win, a random number is asked from oraclize.
332      * */
333 
334     function() payable {
335         if(msg.sender!=owner){//owner should be able to send funds to the contract anytime
336             if(msg.value<100000000000000000||msg.value>1000000000000000000) throw;//bet has to lie between 0.1 and 1 ETH
337             if(address(this).balance < msg.value/100*prizes[0]) throw; //make sure the contract is able to pay out the player in case he wins
338             bytes32 oid = oraclize_query("URL","https://www.random.org/integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new", oraclizeGas);
339             bets[oid] = msg.value;
340             players[oid] = msg.sender;
341         }
342     }
343 
344     /**
345      * The random number from Oraclizes decides the game result.
346      * If Oraclize sends a message instead of the requested number, the bet is returned to the player.
347      * */
348     function __callback(bytes32 myid, string result) {
349         if (msg.sender != oraclize_cbAddress()) throw;
350         if (players[myid]==0x0) throw;
351         uint random = convertToInt(result);
352         if(random==0){//result not a number, return bet
353             if(!players[myid].send(bets[myid])) throw;
354             gameResult(101,players[myid]);
355             delete players[myid];
356             return;
357         }
358         uint range = 0;
359         for(uint i = 0; i<probabilities.length; i++){
360             range+=probabilities[i];
361             if(random<=range){
362                 if(!players[myid].send(bets[myid]/100*prizes[i])){
363                     gameResult(100,players[myid]);//100 -> error
364                     throw;
365                 } 
366                 gameResult(i, players[myid]);
367                 delete players[myid];
368                 return;
369             }
370         }
371 
372         //else player loses everything
373         gameResult(probabilities.length, players[myid]);
374         
375         delete players[myid];
376         
377     }
378     
379     /**
380      * sets the amount of gas to be sent to oraclize
381      * */
382     function setOraclizeGas(uint32 newGas){
383         if(!(msg.sender==owner)) throw;
384     	oraclizeGas = newGas;
385     }
386     
387     /** set the probabilities of the results (absolute frequencies out of 1.000.000 spins) **/
388     function setProbabilities(uint32[] probs){
389         if(!(msg.sender==owner)) throw;
390         probabilities=probs;
391     }
392     
393     /** set the prizes of the results (shifted by 2 digits -> 375 means 3.75)**/
394     function setPrizes(uint32[] priz){
395         if(!(msg.sender==owner)) throw;
396         prizes=priz;
397     }
398     
399     /**
400      * allows the owner to collect the accumulated losses
401      * */
402     function collectFees(uint amount){
403         if(!(msg.sender==owner)) throw;
404         if( address(this).balance < amount) throw;
405         if(!owner.send(amount)) throw;
406     }
407     
408     /**
409      * converts a string to an integer (there may only be digits)
410      * */
411     function convertToInt(string _a) internal returns (uint) {
412         bytes memory bresult = bytes(_a);
413         uint mint = 0;
414         for (uint i=0; i<bresult.length; i++){
415             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
416                 mint *= 10;
417                 mint += uint(bresult[i]) - 48;
418             } else if((bresult[i] >= 58)&&(bresult[i] <= 126)) return 0;//its a message, no pure int
419         }
420         return mint;
421     }
422 }