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
187 contract presale {
188     
189     Token public token;
190     uint256 public totalSupply;
191     uint256 public numberOfTokens;
192     uint256 public numberOfTokensLeft;
193     uint256 public pricePerToken;
194     uint256 public tokensFromPresale = 0;
195     
196     address public owner;
197     string public name;
198     string public symbol;
199     
200     address public finalAddress = 0x5904957d25D0c6213491882a64765967F88BCCC7;
201     
202     mapping (address => uint256) public balanceOf;
203     mapping (address => bool) public addressExists;
204     mapping (uint256 => address) public addresses;
205     mapping (address => uint256) public addressIndex;
206     uint256 public numberOfAddress = 0;
207     
208     mapping (uint256 => uint256) public dates;
209     mapping (uint256 => uint256) public percents;
210     uint256 public numberOfDates = 8;
211     
212     presale ps = presale(0xa67d97d75eE175e05BB1FB17529FD772eE8E9030);
213     
214     function presale(address tokenAddress, uint256 noOfTokens, uint256 prPerToken) {
215         dates[0] = 1505520000;
216         dates[1] = 1506038400;
217         dates[2] = 1506124800;
218         dates[3] = 1506816000;
219         dates[4] = 1507420800;
220         dates[5] = 1508112000;
221         dates[6] = 1508630400;
222         dates[7] = 1508803200;
223         percents[0] = 350;
224         percents[1] = 200;
225         percents[2] = 100;
226         percents[3] = 50;
227         percents[4] = 25;
228         percents[5] = 0;
229         percents[6] = 9001;
230         percents[7] = 9001;
231         token = Token(tokenAddress);
232         numberOfTokens = noOfTokens;
233         totalSupply = noOfTokens;
234         numberOfTokensLeft = noOfTokens;
235         pricePerToken = prPerToken;
236         owner = msg.sender;
237         name = "Autonio ICO";
238         symbol = "NIO";
239         updatePresaleNumbers();
240     }
241     
242     function addAddress (address addr) private {
243         if(!addressExists[addr]) {
244             addressIndex[addr] = numberOfAddress;
245             addresses[numberOfAddress++] = addr;
246             addressExists[addr] = true;
247         }
248     }
249     
250     function endPresale() {
251         if(msg.sender == owner) {
252             if(now > dates[numberOfDates-1]) {
253                 finish();
254             } else if(numberOfTokensLeft == 0) {
255                 finish();
256             } else {
257                 throw;
258             }
259         } else {
260             throw;
261         }
262     }
263     
264     function finish() private {
265         if(!finalAddress.send(this.balance)) {
266             throw;
267         }
268     }
269     
270     function updatePresaleNumbers() {
271         if(msg.sender == owner) {
272             uint256 prevTokensFromPresale = tokensFromPresale;
273             tokensFromPresale = ps.numberOfTokens() - ps.numberOfTokensLeft();
274             uint256 dif = tokensFromPresale - prevTokensFromPresale;
275             numberOfTokensLeft -= dif;
276         } else {
277             throw;
278         }
279     }
280     
281     function () payable {
282         uint256 prevTokensFromPresale = tokensFromPresale;
283         tokensFromPresale = ps.numberOfTokens() - ps.numberOfTokensLeft();
284         uint256 dif = tokensFromPresale - prevTokensFromPresale;
285         numberOfTokensLeft -= dif;
286         uint256 weiSent = msg.value;
287         if(weiSent==0) {
288             throw;
289         }
290         uint256 weiLeftOver = 0;
291         if(numberOfTokensLeft<=0 || now<dates[0] || now>dates[numberOfDates-1]) {
292             throw;
293         }
294         uint256 percent = 9001;
295         for(uint256 i=0;i<numberOfDates-1;i++) {
296             if(now>=dates[i] && now<=dates[i+1] ) {
297                 percent = percents[i];
298                 i=numberOfDates-1;
299             }
300         }
301         if(percent==9001) {
302             throw;
303         }
304         uint256 tokensToGive = weiSent / pricePerToken;
305         if(tokensToGive * pricePerToken > weiSent) tokensToGive--;
306         tokensToGive=(tokensToGive*(1000+percent))/1000;
307         if(tokensToGive>numberOfTokensLeft) {
308             weiLeftOver = (tokensToGive - numberOfTokensLeft) * pricePerToken;
309             tokensToGive = numberOfTokensLeft;
310         }
311         numberOfTokensLeft -= tokensToGive;
312         if(addressExists[msg.sender]) {
313             balanceOf[msg.sender] += tokensToGive;
314         } else {
315             addAddress(msg.sender);
316             balanceOf[msg.sender] = tokensToGive;
317         }
318         Transfer(0x0,msg.sender,tokensToGive);
319         if(weiLeftOver>0)msg.sender.send(weiLeftOver);
320     }
321     
322     event Transfer(address indexed _from, address indexed _to, uint256 _value);
323 }