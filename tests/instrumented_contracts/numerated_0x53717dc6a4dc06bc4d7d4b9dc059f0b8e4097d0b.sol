1 contract mortal {
2     /* Define variable owner of the type address*/
3     address owner;
4 
5     /* this function is executed at initialization and sets the owner of the contract */
6     function mortal() { owner = msg.sender; }
7 
8     /* Function to recover the funds on the contract */
9     function kill() { if (msg.sender == owner) suicide(owner); }
10 }
11 // <ORACLIZE_API>
12 /*
13 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
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
40 contract OraclizeI {
41     address public cbAddress;
42     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
43     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
44     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
45     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
46     function getPrice(string _datasource) returns (uint _dsprice);
47     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
48     function useCoupon(string _coupon);
49     function setProofType(byte _proofType);
50     function setCustomGasPrice(uint _gasPrice);
51 }
52 contract OraclizeAddrResolverI {
53     function getAddress() returns (address _addr);
54 }
55 contract usingOraclize {
56     uint constant day = 60*60*24;
57     uint constant week = 60*60*24*7;
58     uint constant month = 60*60*24*30;
59     byte constant proofType_NONE = 0x00;
60     byte constant proofType_TLSNotary = 0x10;
61     byte constant proofStorage_IPFS = 0x01;
62     uint8 constant networkID_auto = 0;
63     uint8 constant networkID_mainnet = 1;
64     uint8 constant networkID_testnet = 2;
65     uint8 constant networkID_morden = 2;
66     uint8 constant networkID_consensys = 161;
67 
68     OraclizeAddrResolverI OAR;
69     
70     OraclizeI oraclize;
71     modifier oraclizeAPI {
72         address oraclizeAddr = OAR.getAddress();
73         if (oraclizeAddr == 0){
74             oraclize_setNetwork(networkID_auto);
75             oraclizeAddr = OAR.getAddress();
76         }
77         oraclize = OraclizeI(oraclizeAddr);
78         _
79     }
80     modifier coupon(string code){
81         oraclize = OraclizeI(OAR.getAddress());
82         oraclize.useCoupon(code);
83         _
84     }
85 
86     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
87         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
88             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
89             return true;
90         }
91         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
92             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
93             return true;
94         }
95         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
96             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
97             return true;
98         }
99         return false;
100     }
101     
102     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
103         uint price = oraclize.getPrice(datasource);
104         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
105         return oraclize.query.value(price)(0, datasource, arg);
106     }
107     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource);
109         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
110         return oraclize.query.value(price)(timestamp, datasource, arg);
111     }
112     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
113         uint price = oraclize.getPrice(datasource, gaslimit);
114         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
115         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
116     }
117     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
118         uint price = oraclize.getPrice(datasource, gaslimit);
119         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
120         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
121     }
122     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource);
124         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
125         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
126     }
127     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource, gaslimit);
134         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
135         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
136     }
137     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
141     }
142     function oraclize_cbAddress() oraclizeAPI internal returns (address){
143         return oraclize.cbAddress();
144     }
145     function oraclize_setProof(byte proofP) oraclizeAPI internal {
146         return oraclize.setProofType(proofP);
147     }
148     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
149         return oraclize.setCustomGasPrice(gasPrice);
150     }    
151 
152     function getCodeSize(address _addr) constant internal returns(uint _size) {
153         assembly {
154             _size := extcodesize(_addr)
155         }
156     }
157 
158 
159     function parseAddr(string _a) internal returns (address){
160         bytes memory tmp = bytes(_a);
161         uint160 iaddr = 0;
162         uint160 b1;
163         uint160 b2;
164         for (uint i=2; i<2+2*20; i+=2){
165             iaddr *= 256;
166             b1 = uint160(tmp[i]);
167             b2 = uint160(tmp[i+1]);
168             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
169             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
170             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
171             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
172             iaddr += (b1*16+b2);
173         }
174         return address(iaddr);
175     }
176 
177 
178     function strCompare(string _a, string _b) internal returns (int) {
179         bytes memory a = bytes(_a);
180         bytes memory b = bytes(_b);
181         uint minLength = a.length;
182         if (b.length < minLength) minLength = b.length;
183         for (uint i = 0; i < minLength; i ++)
184             if (a[i] < b[i])
185                 return -1;
186             else if (a[i] > b[i])
187                 return 1;
188         if (a.length < b.length)
189             return -1;
190         else if (a.length > b.length)
191             return 1;
192         else
193             return 0;
194    } 
195 
196     function indexOf(string _haystack, string _needle) internal returns (int)
197     {
198         bytes memory h = bytes(_haystack);
199         bytes memory n = bytes(_needle);
200         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
201             return -1;
202         else if(h.length > (2**128 -1))
203             return -1;                                  
204         else
205         {
206             uint subindex = 0;
207             for (uint i = 0; i < h.length; i ++)
208             {
209                 if (h[i] == n[0])
210                 {
211                     subindex = 1;
212                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
213                     {
214                         subindex++;
215                     }   
216                     if(subindex == n.length)
217                         return int(i);
218                 }
219             }
220             return -1;
221         }   
222     }
223 
224     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
225         bytes memory _ba = bytes(_a);
226         bytes memory _bb = bytes(_b);
227         bytes memory _bc = bytes(_c);
228         bytes memory _bd = bytes(_d);
229         bytes memory _be = bytes(_e);
230         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
231         bytes memory babcde = bytes(abcde);
232         uint k = 0;
233         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
234         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
235         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
236         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
237         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
238         return string(babcde);
239     }
240     
241     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
242         return strConcat(_a, _b, _c, _d, "");
243     }
244 
245     function strConcat(string _a, string _b, string _c) internal returns (string) {
246         return strConcat(_a, _b, _c, "", "");
247     }
248 
249     function strConcat(string _a, string _b) internal returns (string) {
250         return strConcat(_a, _b, "", "", "");
251     }
252 
253     // parseInt
254     function parseInt(string _a) internal returns (uint) {
255         return parseInt(_a, 0);
256     }
257 
258     // parseInt(parseFloat*10^_b)
259     function parseInt(string _a, uint _b) internal returns (uint) {
260         bytes memory bresult = bytes(_a);
261         uint mint = 0;
262         bool decimals = false;
263         for (uint i=0; i<bresult.length; i++){
264             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
265                 if (decimals){
266                    if (_b == 0) break;
267                     else _b--;
268                 }
269                 mint *= 10;
270                 mint += uint(bresult[i]) - 48;
271             } else if (bresult[i] == 46) decimals = true;
272         }
273         if (_b > 0) mint *= 10**_b;
274         return mint;
275     }
276     
277 
278 }
279 // </ORACLIZE_API>
280 
281 contract GitHubBounty is usingOraclize, mortal {
282     
283     enum QueryType { IssueState, IssueAssignee, UserAddress }
284     
285     struct Bounty {
286         string issueUrl;
287         uint prize;
288         uint balance;
289         uint queriesDelay;
290         string closedAt;
291         string assigneeLogin;
292         address assigneeAddress;
293     }
294  
295     mapping (bytes32 => bytes32) queriesKey;
296     mapping (bytes32 => QueryType) queriesType;
297     mapping (bytes32 => Bounty) public bounties;
298     bytes32[] public bountiesKey;
299     mapping (address => bool) public sponsors;
300     
301     uint contractBalance;
302     
303     event SponsorAdded(address sponsorAddr);
304     event BountyAdded(bytes32 bountyKey, string issueUrl);
305     event IssueStateLoaded(bytes32 bountyKey, string closedAt);
306     event IssueAssigneeLoaded(bytes32 bountyKey, string login);
307     event UserAddressLoaded(bytes32 bountyKey, string ethAddress);
308     event SendingBounty(bytes32 bountyKey, uint prize);
309     event BountySent(bytes32 bountyKey);
310     
311     uint oraclizeGasLimit = 1000000;
312 
313     function GitHubBounty() {
314     }
315     
316     function addSponsor(address sponsorAddr)
317     {
318         if (msg.sender != owner) throw;
319         sponsors[sponsorAddr] = true;
320         SponsorAdded(sponsorAddr);
321     }
322     
323     // issueUrl: full API url of github issue, e.g. https://api.github.com/repos/polybioz/hello-world/issues/6
324     // queriesDelay: oraclize queries delay in minutes, e.g. 60*24 for one day, min 1 minute
325     function addIssueBounty(string issueUrl, uint queriesDelay){
326         
327         if (!sponsors[msg.sender]) throw;
328         if (bytes(issueUrl).length==0) throw;
329         if (msg.value == 0) throw;
330         if (queriesDelay == 0) throw;
331         
332         bytes32 bountyKey = sha3(issueUrl);
333         
334         bounties[bountyKey].issueUrl = issueUrl;
335         bounties[bountyKey].prize = msg.value;
336         bounties[bountyKey].balance = msg.value;
337         bounties[bountyKey].queriesDelay = queriesDelay;
338         
339         bountiesKey.push(bountyKey);
340         
341         BountyAdded(bountyKey, issueUrl);
342  
343         getIssueState(queriesDelay, bountyKey);
344     }
345      
346     function getIssueState(uint delay, bytes32 bountyKey) internal {
347         contractBalance = this.balance;
348         
349         string issueUrl = bounties[bountyKey].issueUrl;
350         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",issueUrl,").closed_at"), oraclizeGasLimit);
351         queriesKey[myid] = bountyKey;
352         queriesType[myid] = QueryType.IssueState;
353         
354         bounties[bountyKey].balance -= contractBalance - this.balance;
355     }
356     
357     function getIssueAssignee(uint delay, bytes32 bountyKey) internal {
358         contractBalance = this.balance;
359         
360         string issueUrl = bounties[bountyKey].issueUrl;
361         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",issueUrl,").assignee.login"), oraclizeGasLimit);
362         queriesKey[myid] = bountyKey;
363         queriesType[myid] = QueryType.IssueAssignee;
364         
365         bounties[bountyKey].balance -= contractBalance - this.balance;
366     }
367     
368     function getUserAddress(uint delay, bytes32 bountyKey) internal {
369         contractBalance = this.balance;
370         
371         string login = bounties[bountyKey].assigneeLogin;
372         string memory url = strConcat("https://api.github.com/users/", login);
373         bytes32 myid = oraclize_query(delay, "URL", strConcat("json(",url,").location"), oraclizeGasLimit);
374         queriesKey[myid] = bountyKey;
375         queriesType[myid] = QueryType.UserAddress;
376         
377         bounties[bountyKey].balance -= contractBalance - this.balance;
378     }
379     
380     function sendBounty(bytes32 bountyKey) internal {
381         string issueUrl = bounties[bountyKey].issueUrl;
382         
383         SendingBounty(bountyKey, bounties[bountyKey].balance);
384         if(bounties[bountyKey].balance > 0) {
385             if (bounties[bountyKey].assigneeAddress.send(bounties[bountyKey].balance)) {
386                 bounties[bountyKey].balance = 0;
387                 BountySent(bountyKey);
388             }
389         }
390     }
391 
392     function __callback(bytes32 myid, string result) {
393         if (msg.sender != oraclize_cbAddress()) throw;
394  
395         bytes32 bountyKey = queriesKey[myid];
396         QueryType queryType = queriesType[myid];
397         uint queriesDelay = bounties[bountyKey].queriesDelay;
398         
399         if(queryType == QueryType.IssueState) {
400             IssueStateLoaded(bountyKey, result);
401             if(bytes(result).length <= 4) { // oraclize returns "None" instead of null
402                 getIssueState(queriesDelay, bountyKey);
403             }
404             else{
405                 bounties[bountyKey].closedAt = result;
406                 getIssueAssignee(0, bountyKey);
407             }
408         } 
409         else if(queryType == QueryType.IssueAssignee) {
410             IssueAssigneeLoaded(bountyKey, result);
411             if(bytes(result).length <= 4) { // oraclize returns "None" instead of null
412                 getIssueAssignee(queriesDelay, bountyKey);
413             }
414             else {
415                 bounties[bountyKey].assigneeLogin = result;
416                 getUserAddress(0, bountyKey);
417             }
418         } 
419         else if(queryType == QueryType.UserAddress) {
420             UserAddressLoaded(bountyKey, result);
421             if(bytes(result).length <= 4) { // oraclize returns "None" instead of null
422                 getUserAddress(queriesDelay, bountyKey);
423             }
424             else {
425                 bounties[bountyKey].assigneeAddress = parseAddr(result);
426                 sendBounty(bountyKey);
427             }
428         } 
429         
430         delete queriesType[myid];
431         delete queriesKey[myid];
432     }
433 }