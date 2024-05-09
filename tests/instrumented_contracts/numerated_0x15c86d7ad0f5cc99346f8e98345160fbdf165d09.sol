1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     
5     mapping (address => uint256) public balanceOf;
6     mapping (uint256 => address) public addresses;
7     mapping (address => bool) public addressExists;
8     mapping (address => uint256) public addressIndex;
9     uint256 public numberOfAddress = 0;
10     
11     string public physicalString;
12     string public cryptoString;
13     
14     bool public isSecured;
15     string public name;
16     string public symbol;
17     uint256 public totalSupply;
18     bool public canMintBurn;
19     uint256 public txnTax;
20     uint256 public holdingTax;
21     //In Weeks, on Fridays
22     uint256 public holdingTaxInterval;
23     uint256 public lastHoldingTax;
24     uint256 public holdingTaxDecimals = 2;
25     bool public isPrivate;
26     
27     address public owner;
28     
29     function Token(string n, string a, uint256 totalSupplyToUse, bool isSecured, bool cMB, string physical, string crypto, uint256 txnTaxToUse, uint256 holdingTaxToUse, uint256 holdingTaxIntervalToUse, bool isPrivateToUse) {
30         name = n;
31         symbol = a;
32         totalSupply = totalSupplyToUse;
33         balanceOf[msg.sender] = totalSupplyToUse;
34         isSecured = isSecured;
35         physicalString = physical;
36         cryptoString = crypto;
37         canMintBurn = cMB;
38         owner = msg.sender;
39         txnTax = txnTaxToUse;
40         holdingTax = holdingTaxToUse;
41         holdingTaxInterval = holdingTaxIntervalToUse;
42         if(holdingTaxInterval!=0) {
43             lastHoldingTax = now;
44             while(getHour(lastHoldingTax)!=21) {
45                 lastHoldingTax -= 1 hours;
46             }
47             while(getWeekday(lastHoldingTax)!=5) {
48                 lastHoldingTax -= 1 days;
49             }
50             lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);
51         }
52         isPrivate = isPrivateToUse;
53         
54         addAddress(owner);
55     }
56     
57     function transfer(address _to, uint256 _value) payable {
58         chargeHoldingTax();
59         if (balanceOf[msg.sender] < _value) throw;
60         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
61         if (msg.sender != owner && _to != owner && txnTax != 0) {
62             if(!owner.send(txnTax)) {
63                 throw;
64             }
65         }
66         if(isPrivate && msg.sender != owner && !addressExists[_to]) {
67             throw;
68         }
69         balanceOf[msg.sender] -= _value;
70         balanceOf[_to] += _value;
71         addAddress(_to);
72         Transfer(msg.sender, _to, _value);
73     }
74     
75     function changeTxnTax(uint256 _newValue) {
76         if(msg.sender != owner) throw;
77         txnTax = _newValue;
78     }
79     
80     function mint(uint256 _value) {
81         if(canMintBurn && msg.sender == owner) {
82             if (balanceOf[msg.sender] + _value < balanceOf[msg.sender]) throw;
83             balanceOf[msg.sender] += _value;
84             totalSupply += _value;
85             Transfer(0, msg.sender, _value);
86         }
87     }
88     
89     function burn(uint256 _value) {
90         if(canMintBurn && msg.sender == owner) {
91             if (balanceOf[msg.sender] < _value) throw;
92             balanceOf[msg.sender] -= _value;
93             totalSupply -= _value;
94             Transfer(msg.sender, 0, _value);
95         }
96     }
97     
98     function chargeHoldingTax() {
99         if(holdingTaxInterval!=0) {
100             uint256 dateDif = now - lastHoldingTax;
101             bool changed = false;
102             while(dateDif >= holdingTaxInterval * (1 weeks)) {
103                 changed=true;
104                 dateDif -= holdingTaxInterval * (1 weeks);
105                 for(uint256 i = 0;i<numberOfAddress;i++) {
106                     if(addresses[i]!=owner) {
107                         uint256 amtOfTaxToPay = ((balanceOf[addresses[i]]) * holdingTax)  / (10**holdingTaxDecimals)/ (10**holdingTaxDecimals);
108                         balanceOf[addresses[i]] -= amtOfTaxToPay;
109                         balanceOf[owner] += amtOfTaxToPay;
110                     }
111                 }
112             }
113             if(changed) {
114                 lastHoldingTax = now;
115                 while(getHour(lastHoldingTax)!=21) {
116                     lastHoldingTax -= 1 hours;
117                 }
118                 while(getWeekday(lastHoldingTax)!=5) {
119                     lastHoldingTax -= 1 days;
120                 }
121                 lastHoldingTax -= getMinute(lastHoldingTax) * (1 minutes) + getSecond(lastHoldingTax) * (1 seconds);
122             }
123         }
124     }
125     
126     function changeHoldingTax(uint256 _newValue) {
127         if(msg.sender != owner) throw;
128         holdingTax = _newValue;
129     }
130     
131     function changeHoldingTaxInterval(uint256 _newValue) {
132         if(msg.sender != owner) throw;
133         holdingTaxInterval = _newValue;
134     }
135     
136     function addAddress (address addr) private {
137         if(!addressExists[addr]) {
138             addressIndex[addr] = numberOfAddress;
139             addresses[numberOfAddress++] = addr;
140             addressExists[addr] = true;
141         }
142     }
143     
144     function addAddressManual (address addr) {
145         if(msg.sender == owner && isPrivate) {
146             addAddress(addr);
147         } else {
148             throw;
149         }
150     }
151     
152     function removeAddress (address addr) private {
153         if(addressExists[addr]) {
154             numberOfAddress--;
155             addresses[addressIndex[addr]] = 0x0;
156             addressExists[addr] = false;
157         }
158     }
159     
160     function removeAddressManual (address addr) {
161         if(msg.sender == owner && isPrivate) {
162             removeAddress(addr);
163         } else {
164             throw;
165         }
166     }
167     
168     function getWeekday(uint timestamp) returns (uint8) {
169             return uint8((timestamp / 86400 + 4) % 7);
170     }
171     
172     function getHour(uint timestamp) returns (uint8) {
173             return uint8((timestamp / 60 / 60) % 24);
174     }
175 
176     function getMinute(uint timestamp) returns (uint8) {
177             return uint8((timestamp / 60) % 60);
178     }
179 
180     function getSecond(uint timestamp) returns (uint8) {
181             return uint8(timestamp % 60);
182     }
183 
184     event Transfer(address indexed _from, address indexed _to, uint256 _value);
185 }
186 
187 contract tokensale {
188     
189     Token public token;
190     uint256 public totalSupply;
191     uint256 public numberOfTokens;
192     uint256 public numberOfTokensLeft;
193     uint256 public pricePerToken;
194     uint256 public tokensFromPresale = 0;
195     uint256 public tokensFromPreviousTokensale = 0;
196     uint8 public decimals = 2;
197     uint256 public withdrawLimit = 200000000000000000000;
198     
199     address public owner;
200     string public name;
201     string public symbol;
202     
203     address public finalAddress = 0x5904957d25D0c6213491882a64765967F88BCCC7;
204     
205     mapping (address => uint256) public balanceOf;
206     mapping (address => bool) public addressExists;
207     mapping (uint256 => address) public addresses;
208     mapping (address => uint256) public addressIndex;
209     uint256 public numberOfAddress = 0;
210     
211     mapping (uint256 => uint256) public dates;
212     mapping (uint256 => uint256) public percents;
213     uint256 public numberOfDates = 8;
214     
215     tokensale ps = tokensale(0xa67d97d75eE175e05BB1FB17529FD772eE8E9030);
216     tokensale pts = tokensale(0xED6c0654cD61De5b1355Ae4e9d9C786005e9D5BD);
217     
218     function tokensale(address tokenAddress, uint256 noOfTokens, uint256 prPerToken) {
219         dates[0] = 1505520000;
220         dates[1] = 1506038400;
221         dates[2] = 1506124800;
222         dates[3] = 1506816000;
223         dates[4] = 1507420800;
224         dates[5] = 1508112000;
225         dates[6] = 1508630400;
226         dates[7] = 1508803200;
227         percents[0] = 35000;
228         percents[1] = 20000;
229         percents[2] = 10000;
230         percents[3] = 5000;
231         percents[4] = 2500;
232         percents[5] = 0;
233         percents[6] = 9001;
234         percents[7] = 9001;
235         token = Token(tokenAddress);
236         numberOfTokens = noOfTokens * 100;
237         totalSupply = noOfTokens * 100;
238         numberOfTokensLeft = noOfTokens * 100;
239         pricePerToken = prPerToken;
240         owner = msg.sender;
241         name = "Autonio ICO";
242         symbol = "NIO";
243         updatePresaleNumbers();
244     }
245     
246     function addAddress (address addr) private {
247         if(!addressExists[addr]) {
248             addressIndex[addr] = numberOfAddress;
249             addresses[numberOfAddress++] = addr;
250             addressExists[addr] = true;
251         }
252     }
253     
254     function endPresale() {
255         if(msg.sender == owner) {
256             if(now > dates[numberOfDates-1]) {
257                 finish();
258             } else if(numberOfTokensLeft == 0) {
259                 finish();
260             } else {
261                 throw;
262             }
263         } else {
264             throw;
265         }
266     }
267     
268     function finish() private {
269         if(!finalAddress.send(this.balance)) {
270             throw;
271         }
272     }
273     
274     function withdraw(uint256 amount) {
275         if(msg.sender == owner) {
276             if(amount <= withdrawLimit) {
277                 withdrawLimit-=amount;
278                 if(!finalAddress.send(amount)) {
279                     throw;
280                 }
281             } else {
282                 throw;
283             }
284         } else {
285             throw;
286         }
287     }
288     
289     function updatePresaleNumbers() {
290         if(msg.sender == owner) {
291             uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;
292             tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();
293             uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;
294             numberOfTokensLeft -= diff;
295         } else {
296             throw;
297         }
298     }
299     
300     function () payable {
301         uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;
302         tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();
303         uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;
304         numberOfTokensLeft -= diff;
305         
306         uint256 weiSent = msg.value * 100;
307         if(weiSent==0) {
308             throw;
309         }
310         uint256 weiLeftOver = 0;
311         if(numberOfTokensLeft<=0 || now<dates[0] || now>dates[numberOfDates-1]) {
312             throw;
313         }
314         uint256 percent = 9001;
315         for(uint256 i=0;i<numberOfDates-1;i++) {
316             if(now>=dates[i] && now<=dates[i+1] ) {
317                 percent = percents[i];
318                 i=numberOfDates-1;
319             }
320         }
321         if(percent==9001) {
322             throw;
323         }
324         uint256 tokensToGive = weiSent / pricePerToken;
325         if(tokensToGive * pricePerToken > weiSent) tokensToGive--;
326         tokensToGive=(tokensToGive*(100000+percent))/100000;
327         if(tokensToGive>numberOfTokensLeft) {
328             weiLeftOver = (tokensToGive - numberOfTokensLeft) * pricePerToken;
329             tokensToGive = numberOfTokensLeft;
330         }
331         numberOfTokensLeft -= tokensToGive;
332         if(addressExists[msg.sender]) {
333             balanceOf[msg.sender] += tokensToGive;
334         } else {
335             addAddress(msg.sender);
336             balanceOf[msg.sender] = tokensToGive;
337         }
338         Transfer(0x0,msg.sender,tokensToGive);
339         if(weiLeftOver>0)msg.sender.send(weiLeftOver);
340     }
341     
342     event Transfer(address indexed _from, address indexed _to, uint256 _value);
343 }