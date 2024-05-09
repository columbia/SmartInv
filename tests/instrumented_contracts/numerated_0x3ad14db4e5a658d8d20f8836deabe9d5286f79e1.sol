1 /*
2   Become the Block King when the last digit of your payment block number
3   matches the randaom number received from Oraclize.it.
4   The Block King receives 50% of the incoming payments of the warriors who
5   fail to push the Block King from the throne.
6   Block Kings who paid  1 ether when they
7   ascended to the throne get 75% of the incoming payments.
8   If the Block King holds their position for more than 2000 blocks
9   they receive 90% of the incoming payments.
10 */
11 
12 
13 // <ORACLIZE_API>
14 /*
15 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
16 
17 
18 
19 Permission is hereby granted, free of charge, to any person obtaining a copy
20 of this software and associated documentation files (the "Software"), to deal
21 in the Software without restriction, including without limitation the rights
22 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23 copies of the Software, and to permit persons to whom the Software is
24 furnished to do so, subject to the following conditions:
25 
26 
27 
28 The above copyright notice and this permission notice shall be included in
29 all copies or substantial portions of the Software.
30 
31 
32 
33 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
36 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
39 THE SOFTWARE.
40 */
41 
42 contract OraclizeI {
43     address public cbAddress;
44     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
45     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
46     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
47     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
48     function getPrice(string _datasource) returns (uint _dsprice);
49     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
50     function useCoupon(string _coupon);
51     function setProofType(byte _proofType);
52 }
53 contract OraclizeAddrResolverI {
54     function getAddress() returns (address _addr);
55 }
56 contract usingOraclize {
57     uint constant day = 60*60*24;
58     uint constant week = 60*60*24*7;
59     uint constant month = 60*60*24*30;
60     byte constant proofType_NONE = 0x00;
61     byte constant proofType_TLSNotary = 0x10;
62     byte constant proofStorage_IPFS = 0x01;
63     uint8 constant networkID_mainnet = 1;
64     uint8 constant networkID_testnet = 2;
65     uint8 constant networkID_morden = 2;
66     uint8 constant networkID_consensys = 161;
67     
68     OraclizeAddrResolverI OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
69     
70     OraclizeI oraclize;
71     modifier oraclizeAPI {
72         oraclize = OraclizeI(OAR.getAddress());
73         _
74     }
75     modifier coupon(string code){
76         oraclize = OraclizeI(OAR.getAddress());
77         oraclize.useCoupon(code);
78         _
79     }
80     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
81         if (networkID == networkID_mainnet) OAR = OraclizeAddrResolverI(0x1d11e5eae3112dbd44f99266872ff1d07c77dce8);
82         else if (networkID == networkID_testnet) OAR = OraclizeAddrResolverI(0x0ae06d5934fd75d214951eb96633fbd7f9262a7c);
83         else if (networkID == networkID_consensys) OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
84         else return false;
85         return true;
86     }
87     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
88         uint price = oraclize.getPrice(datasource);
89         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
90         return oraclize.query.value(price)(0, datasource, arg);
91     }
92     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
93         uint price = oraclize.getPrice(datasource);
94         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
95         return oraclize.query.value(price)(timestamp, datasource, arg);
96     }
97     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
98         uint price = oraclize.getPrice(datasource, gaslimit);
99         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
100         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
101     }
102     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
103         uint price = oraclize.getPrice(datasource, gaslimit);
104         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
105         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
106     }
107     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource);
109         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
110         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
111     }
112     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
113         uint price = oraclize.getPrice(datasource);
114         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
115         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
116     }
117     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
118         uint price = oraclize.getPrice(datasource, gaslimit);
119         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
120         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
121     }
122     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource, gaslimit);
124         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
125         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
126     }
127     function oraclize_cbAddress() oraclizeAPI internal returns (address){
128         return oraclize.cbAddress();
129     }
130     function oraclize_setProof(byte proofP) oraclizeAPI internal {
131         return oraclize.setProofType(proofP);
132     }
133 
134 
135 
136     function parseAddr(string _a) internal returns (address){
137         bytes memory tmp = bytes(_a);
138         uint160 iaddr = 0;
139         uint160 b1;
140         uint160 b2;
141         for (uint i=2; i<2+2*20; i+=2){
142             iaddr *= 256;
143             b1 = uint160(tmp[i]);
144             b2 = uint160(tmp[i+1]);
145             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
146             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
147             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
148             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
149             iaddr += (b1*16+b2);
150         }
151         return address(iaddr);
152     }
153 
154 
155     function strCompare(string _a, string _b) internal returns (int) {
156         bytes memory a = bytes(_a);
157         bytes memory b = bytes(_b);
158         uint minLength = a.length;
159         if (b.length < minLength) minLength = b.length;
160         for (uint i = 0; i < minLength; i ++)
161             if (a[i] < b[i])
162                 return -1;
163             else if (a[i] > b[i])
164                 return 1;
165         if (a.length < b.length)
166             return -1;
167         else if (a.length > b.length)
168             return 1;
169         else
170             return 0;
171    } 
172 
173     function indexOf(string _haystack, string _needle) internal returns (int)
174     {
175     	bytes memory h = bytes(_haystack);
176     	bytes memory n = bytes(_needle);
177     	if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
178     		return -1;
179     	else if(h.length > (2**128 -1))
180     		return -1;									
181     	else
182     	{
183     		uint subindex = 0;
184     		for (uint i = 0; i < h.length; i ++)
185     		{
186     			if (h[i] == n[0])
187     			{
188     				subindex = 1;
189     				while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
190     				{
191     					subindex++;
192     				}	
193     				if(subindex == n.length)
194     					return int(i);
195     			}
196     		}
197     		return -1;
198     	}	
199     }
200 
201     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
202         bytes memory _ba = bytes(_a);
203         bytes memory _bb = bytes(_b);
204         bytes memory _bc = bytes(_c);
205         bytes memory _bd = bytes(_d);
206         bytes memory _be = bytes(_e);
207         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
208         bytes memory babcde = bytes(abcde);
209         uint k = 0;
210         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
211         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
212         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
213         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
214         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
215         return string(babcde);
216     }
217     
218     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
219         return strConcat(_a, _b, _c, _d, "");
220     }
221 
222     function strConcat(string _a, string _b, string _c) internal returns (string) {
223         return strConcat(_a, _b, _c, "", "");
224     }
225 
226     function strConcat(string _a, string _b) internal returns (string) {
227         return strConcat(_a, _b, "", "", "");
228     }
229 
230     // parseInt
231     function parseInt(string _a) internal returns (uint) {
232         return parseInt(_a, 0);
233     }
234 
235     // parseInt(parseFloat*10^_b)
236     function parseInt(string _a, uint _b) internal returns (uint) {
237         bytes memory bresult = bytes(_a);
238         uint mint = 0;
239         bool decimals = false;
240         for (uint i=0; i<bresult.length; i++){
241             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
242                 if (decimals){
243                    if (_b == 0) break;
244                     else _b--;
245                 }
246                 mint *= 10;
247                 mint += uint(bresult[i]) - 48;
248             } else if (bresult[i] == 46) decimals = true;
249         }
250         return mint;
251     }
252     
253 
254 
255 }
256 // </ORACLIZE_API>
257 
258 contract BlockKing is usingOraclize{
259 
260   address public owner;
261   address public king;
262   address public warrior;
263   address public contractAddress;
264   uint public rewardPercent;
265   uint public kingBlock;
266   uint public warriorBlock;
267   uint public randomNumber;
268   uint public singleDigitBlock;
269   uint public warriorGold;
270 
271   // this function is executed at initialization
272   function BlockKing() {
273     owner = msg.sender;
274     king = msg.sender;
275     warrior = msg.sender;
276     contractAddress = this;
277     rewardPercent = 50;
278     kingBlock = block.number;
279     warriorBlock = block.number;
280     randomNumber = 0;
281     singleDigitBlock = 0;
282     warriorGold = 0;
283   }
284 
285   // fallback function - simple transactions trigger this
286   function() {
287     enter();
288   }
289   
290   function enter() {
291     // 100 finney = .05 ether minimum payment otherwise refund payment and stop contract
292     if (msg.value < 50 finney) {
293       msg.sender.send(msg.value);
294       return;
295     }
296     warrior = msg.sender;
297     warriorGold = msg.value;
298     warriorBlock = block.number;
299     bytes32 myid = oraclize_query(0, "WolframAlpha", "random number between 1 and 9");
300   }
301 
302   function __callback(bytes32 myid, string result) {
303     if (msg.sender != oraclize_cbAddress()) throw;
304     randomNumber = uint(bytes(result)[0]) - 48;
305     process_payment();
306   }
307   
308   function process_payment() {
309     // Check if there is a new Block King
310     // by comparing the last digit of the block number
311     // against the Oraclize.it random number.
312     uint singleDigit = warriorBlock;
313 	while (singleDigit > 1000000) {
314 		singleDigit -= 1000000;
315 	} 
316 	while (singleDigit > 100000) {
317 		singleDigit -= 100000;
318 	} 
319 	while (singleDigit > 10000) {
320 		singleDigit -= 10000;
321 	} 
322 	while (singleDigit > 1000) {
323 		singleDigit -= 1000;
324 	} 
325 	while (singleDigit > 100) {
326 		singleDigit -= 100;
327 	} 
328 	while (singleDigit > 10) {
329 		singleDigit -= 10;
330 	} 
331     // Free round for the king
332 	if (singleDigit == 10) {
333 		singleDigit = 0;
334 	} 
335 	singleDigitBlock = singleDigit;
336 	if (singleDigitBlock == randomNumber) {
337       rewardPercent = 50;
338       // If the payment was more than .999 ether then increase reward percentage
339       if (warriorGold > 999 finney) {
340 	  	rewardPercent = 75;
341 	  }	
342       king = warrior;
343       kingBlock = warriorBlock;
344     }
345 
346 	uint calculatedBlockDifference = kingBlock - warriorBlock;
347 	uint payoutPercentage = rewardPercent;
348 	// If the Block King has held the position for more
349 	// than 2000 blocks then increase the payout percentage.
350 	if (calculatedBlockDifference > 2000) {
351 	  	payoutPercentage = 90;		
352 	}
353 
354     // pay reward to BlockKing
355     uint reward = (contractAddress.balance * payoutPercentage)/100;  
356     king.send(reward);
357     	
358     // collect fee
359     owner.send(contractAddress.balance);
360   }
361   function kill() { if (msg.sender == owner) suicide(owner); }
362 }