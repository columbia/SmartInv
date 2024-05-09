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
215     tokensale pts = tokensale(0xED6c0654cD61De5b1355Ae4e9d9C786005e9D5BD);
216     
217     function tokensale(address tokenAddress, uint256 noOfTokens, uint256 prPerToken) {
218         dates[0] = 1505520000;
219         dates[1] = 1506038400;
220         dates[2] = 1506124800;
221         dates[3] = 1506816000;
222         dates[4] = 1507420800;
223         dates[5] = 1508112000;
224         dates[6] = 1508630400;
225         dates[7] = 1508803200;
226         percents[0] = 70000;
227         percents[1] = 40000;
228         percents[2] = 20000;
229         percents[3] = 10000;
230         percents[4] = 5000;
231         percents[5] = 0;
232         percents[6] = 9001;
233         percents[7] = 9001;
234         token = Token(tokenAddress);
235         numberOfTokens = noOfTokens * 100;
236         totalSupply = noOfTokens * 100;
237         numberOfTokensLeft = noOfTokens * 100;
238         pricePerToken = prPerToken;
239         owner = msg.sender;
240         name = "Autonio ICO";
241         symbol = "NIO";
242         updatePresaleNumbers();
243     }
244     
245     function addAddress (address addr) private {
246         if(!addressExists[addr]) {
247             addressIndex[addr] = numberOfAddress;
248             addresses[numberOfAddress++] = addr;
249             addressExists[addr] = true;
250         }
251     }
252     
253     function endPresale() {
254         if(msg.sender == owner) {
255             if(now > dates[numberOfDates-1]) {
256                 finish();
257             } else if(numberOfTokensLeft == 0) {
258                 finish();
259             } else {
260                 throw;
261             }
262         } else {
263             throw;
264         }
265     }
266     
267     function finish() private {
268         if(!finalAddress.send(this.balance)) {
269             throw;
270         }
271     }
272     
273     function withdraw(uint256 amount) {
274         if(msg.sender == owner) {
275             if(amount <= withdrawLimit) {
276                 withdrawLimit-=amount;
277                 if(!finalAddress.send(amount)) {
278                     throw;
279                 }
280             } else {
281                 throw;
282             }
283         } else {
284             throw;
285         }
286     }
287     
288     function updatePresaleNumbers() {
289         if(msg.sender == owner) {
290             uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;
291             tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();
292             uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;
293             numberOfTokensLeft -= diff * 2;
294         } else {
295             throw;
296         }
297     }
298     
299     function () payable {
300         uint256 prevTokensFromPreviousTokensale = tokensFromPreviousTokensale;
301         tokensFromPreviousTokensale = pts.numberOfTokens() - pts.numberOfTokensLeft();
302         uint256 diff = tokensFromPreviousTokensale - prevTokensFromPreviousTokensale;
303         numberOfTokensLeft -= diff * 2;
304         
305         uint256 weiSent = msg.value * 100;
306         if(weiSent==0) {
307             throw;
308         }
309         uint256 weiLeftOver = 0;
310         if(numberOfTokensLeft<=0 || now<dates[0] || now>dates[numberOfDates-1]) {
311             throw;
312         }
313         uint256 percent = 9001;
314         for(uint256 i=0;i<numberOfDates-1;i++) {
315             if(now>=dates[i] && now<=dates[i+1] ) {
316                 percent = percents[i];
317                 i=numberOfDates-1;
318             }
319         }
320         if(percent==9001) {
321             throw;
322         }
323         uint256 tokensToGive = weiSent / pricePerToken;
324         if(tokensToGive * pricePerToken > weiSent) tokensToGive--;
325         tokensToGive=(tokensToGive*(100000+percent))/100000;
326         if(tokensToGive>numberOfTokensLeft) {
327             weiLeftOver = (tokensToGive - numberOfTokensLeft) * pricePerToken;
328             tokensToGive = numberOfTokensLeft;
329         }
330         numberOfTokensLeft -= tokensToGive;
331         if(addressExists[msg.sender]) {
332             balanceOf[msg.sender] += tokensToGive;
333         } else {
334             addAddress(msg.sender);
335             balanceOf[msg.sender] = tokensToGive;
336         }
337         Transfer(0x0,msg.sender,tokensToGive);
338         if(weiLeftOver>0)msg.sender.send(weiLeftOver);
339     }
340     
341     event Transfer(address indexed _from, address indexed _to, uint256 _value);
342 }