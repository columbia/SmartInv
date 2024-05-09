1 pragma solidity ^0.4.21;
2 
3 contract Math 
4 {
5     /*
6     standard uint256 functions
7      */
8 
9     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
10         assert((z = x + y) >= x);
11     }
12 
13     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
14         assert((z = x - y) <= x);
15     }
16 
17     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         assert((z = x * y) >= x);
19     }
20 
21     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
22         z = x / y;
23     }
24 
25     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
26         return x <= y ? x : y;
27     }
28     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         return x >= y ? x : y;
30     }
31 }
32 
33 contract Grass is Math
34 {
35   uint256 public availableTokens;
36   uint256 currentTokenPriceInDollar;
37 
38   uint256 public lastUpdateEtherPrice;
39   uint256 public etherPriceInDollarIn;
40   uint256 public etherPriceInDollarOut;
41 
42   function getCurrentTokenPrice() public constant returns (uint256)
43   {
44       uint256 today = getToday();
45       return (tokenPriceHistory[today] == 0)?currentTokenPriceInDollar:tokenPriceHistory[today];
46   }
47 
48   mapping(uint256 => uint256) public tokenPriceHistory;
49   struct ExtraTokensInfo
50   {
51     uint256 timestamp;
52     uint256 extraTokens;
53     string  proofLink;
54     uint256 videoFileHash;
55   }
56 
57   ExtraTokensInfo[] public extraTokens;
58 
59   struct TokenInfo 
60   {    
61     uint256 amount;
62     bool isReturnedInPool;    
63   }
64 
65   event Transfer(address indexed _from, address indexed _to, uint256 _value); 
66 
67   // address => day => amount  
68   mapping(address => mapping(uint256 => TokenInfo)) timeTable;
69   mapping(address => mapping(uint256 => uint256)) bonuses;
70   mapping (address => uint256) public balances;  
71   uint256 public totalSupply;
72 
73   string public name;
74   uint8 public decimals;
75   string public symbol;
76   
77   bool isCanBuy = true;
78 
79   modifier canBuy()
80   {
81       assert(isCanBuy);
82       _;
83   }
84 
85   function changeState(bool bNewState) public onlyAdmin
86   {
87       isCanBuy = bNewState;
88   }
89   
90   address owner;
91   mapping(address => bool) admins;
92   modifier onlyAdmin()
93   {
94       assert(admins[msg.sender] == true || msg.sender == owner);
95       _;
96   }
97 
98   modifier onlyOwner()
99   {
100       assert(msg.sender == owner);
101       _;
102   }
103   function addAdmin(address addr) public onlyOwner
104   {
105       admins[addr] = true;
106   }
107   function removeAdmin(address addr) public onlyOwner
108   {
109       admins[addr] = false;
110   }
111     
112   function Grass() public
113   {   
114     // startTime = block.timestamp;
115     owner = msg.sender;
116     admins[msg.sender] = true;
117     totalSupply = 0;                        
118     name = 'GRASS Token';                   
119     decimals = 18;                          
120     symbol = 'GRASS';
121     availableTokens = 800 * 10**18;
122     currentTokenPriceInDollar = 35 * 100; // 35.00$ (price may change) 
123 
124     etherPriceInDollarIn = 530 * 100;  // 550.00 $  (price may change)
125     etherPriceInDollarOut = 530 * 100; // 550.00 $  (price may change)
126     lastUpdateEtherPrice = block.timestamp;
127   }
128 
129   function increaseMaxAvailableTokens(uint256 amount, string link, uint256 videoFileHash) onlyAdmin public
130   {
131     extraTokens.push(ExtraTokensInfo(block.timestamp, amount, link, videoFileHash));
132     availableTokens = add(availableTokens, amount);
133   }
134   
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136       return balances[_owner];
137   }
138 
139   function updateEtherPrice (uint256 newPriceIn, uint256 newPriceOut) onlyAdmin public 
140   {   
141     etherPriceInDollarIn = newPriceIn;
142     etherPriceInDollarOut = newPriceOut;
143     lastUpdateEtherPrice = block.timestamp;
144   }
145 
146   modifier isEtherPriceUpdated() 
147   {
148       require(now - lastUpdateEtherPrice < 24 hours);
149       _;
150   }
151 
152   function updateTokenPrice (uint256 newPrice) onlyAdmin public 
153   {   
154     currentTokenPriceInDollar = newPrice;   
155   }
156   
157   function getToday() public constant returns (uint256)
158   {
159       return block.timestamp / 24 hours;
160   }
161 
162   function() isEtherPriceUpdated canBuy payable public
163   {
164       buyInternal(msg.sender);
165   }
166 
167   function buyFor(address addr) isEtherPriceUpdated canBuy payable public
168   {
169       buyInternal(addr);
170       // 
171       if (addr.balance == 0) addr.transfer(1 finney);
172   }
173 
174   function buy() isEtherPriceUpdated canBuy payable public
175   {
176     buyInternal(msg.sender);
177   }
178   
179   function getPartnerBalance (address addr) public view returns(uint256)  
180   {
181     return partners[addr];
182   }
183 
184   function partnerWithdraw () public 
185   {
186     assert (partners[msg.sender] > 0);
187     uint256 ethToWidthdraw = partners[msg.sender];
188     partners[msg.sender] = 0;
189     msg.sender.transfer(ethToWidthdraw);
190   }  
191   
192   mapping(address => uint256) partners;
193   // refferal => partner
194   mapping(address => address) referrals;
195 
196   function takeEther(address dest, uint256 amount) onlyAdmin public
197   {
198       dest.transfer(amount);
199   }
200   
201   function addEther() payable onlyAdmin public
202   {
203   }
204 
205   function buyWithPromo(address partner) isEtherPriceUpdated canBuy payable public
206   {
207       if (referrals[msg.sender] == 0 && partner != msg.sender)
208       {
209         referrals[msg.sender] = partner;
210       }
211 
212       buyInternal(msg.sender);
213   }
214   
215   function buyInternal(address addr) internal
216   {
217     if (referrals[addr] != 0)
218     {
219         partners[referrals[addr]] += msg.value / 100; // 1% to partner
220     }  
221       
222     // проверка lastUpdateEtherPrice
223     uint256 today = getToday();
224     if (tokenPriceHistory[today] == 0) tokenPriceHistory[today] = currentTokenPriceInDollar;
225 
226     // timeTable
227     uint256 amount = msg.value * etherPriceInDollarIn / tokenPriceHistory[today] ;
228     if (amount > availableTokens)
229     {
230        addr.transfer((amount - availableTokens) * tokenPriceHistory[today] / etherPriceInDollarIn);
231        amount = availableTokens;
232     }
233       
234     assert(amount > 0);
235       
236     availableTokens = sub(availableTokens, amount);
237 
238     // is new day ?
239     if (timeTable[addr][today].amount == 0)
240     {
241       timeTable[addr][today] = TokenInfo(amount, false);
242     }
243     else
244     {
245       timeTable[addr][today].amount += amount;
246     }
247 
248     //                  < 30.03.2018
249     if (block.timestamp < 1522357200 && bonuses[addr][today] == 0)
250     {
251       bonuses[addr][today] = 1;
252     }
253 
254     balances[addr] = add(balances[addr], amount);
255     totalSupply = add(totalSupply, amount);
256     emit Transfer(0, addr, amount);
257   }
258 
259   function calculateProfit (uint256 day) public constant returns(int256) 
260   {
261     uint256 today = getToday();
262     assert(today >= day);
263     uint256 daysLeft = today - day;
264     int256 extraProfit = 0;
265 
266     // is referral ?
267     if (referrals[msg.sender] != 0) extraProfit++;
268     // participant until March 30
269     if (bonuses[msg.sender][day] > 0) extraProfit++;
270 
271     if (daysLeft <= 7) return -10;
272     if (daysLeft <= 14) return -5;
273     if (daysLeft <= 21) return 1 + extraProfit;
274     if (daysLeft <= 28) return 3 + extraProfit;
275     if (daysLeft <= 60) return 5 + extraProfit;
276     if (daysLeft <= 90) return 12 + extraProfit;
277     return 18 + extraProfit;  
278   }
279   
280   function getTokensPerDay(uint256 _day) public view returns (uint256)
281   {
282       return timeTable[msg.sender][_day].amount;
283   }
284 
285   // returns amount, ether  
286   function getProfitForDay(uint256 day, uint256 amount) isEtherPriceUpdated public constant returns(uint256, uint256)
287   {      
288     assert (day <= getToday());
289     
290     uint256 tokenPrice = tokenPriceHistory[day];
291     if (timeTable[msg.sender][day].amount < amount) amount = timeTable[msg.sender][day].amount;    
292 
293     assert (amount > 0);
294           
295     return (amount, amount * tokenPrice * uint256(100 + calculateProfit(day)) / 100 / etherPriceInDollarOut);
296   }
297 
298   function returnTokensInPool (address[] addr, uint256[] _days) public
299   {
300     assert (addr.length == _days.length);
301     
302     TokenInfo storage info; 
303     for(uint256 i = 0; i < addr.length;i++)
304     {
305       assert(_days[i] + 92 < getToday() && info.amount > 0);
306       info = timeTable[addr[i]][_days[i]];
307       info.isReturnedInPool = true;
308       availableTokens = add(availableTokens, info.amount);      
309     }
310   }
311 
312   function getInfo(address addr, uint256 start, uint256 end) public constant returns (uint256[30] _days, uint256[30] _amounts, int256[30] _profits, uint256[30] _etherAmounts)
313   {
314       if (addr == 0) addr = msg.sender;
315 
316       uint256 j = 0;
317       for(uint256 iDay = start; iDay < end; iDay++)
318       {
319         if (timeTable[addr][iDay].amount > 0)
320         {
321           _days[j] = iDay;
322           _profits[j] = calculateProfit(iDay);
323           _amounts[j] = timeTable[addr][iDay].amount;
324           (_amounts[j], _etherAmounts[j]) = getProfitForDay(iDay, _amounts[j]);
325           j++;
326           if (j == 30) break;
327         }
328       }
329   }
330   
331   function returnTokensForDay(uint256 day, uint256 userTokensAmount) public 
332   {
333     uint256 tokensAmount;
334     uint256 etherAmount;
335     (tokensAmount, etherAmount) = getProfitForDay(day, userTokensAmount);
336 
337     require(day > 0);
338     require(balances[msg.sender] >= tokensAmount);
339     
340     balances[msg.sender] = sub(balances[msg.sender], tokensAmount);
341     totalSupply = sub(totalSupply, tokensAmount);
342     timeTable[msg.sender][day].amount = sub(timeTable[msg.sender][day].amount, tokensAmount);
343     
344     if (!timeTable[msg.sender][day].isReturnedInPool)
345     {
346       availableTokens = add(availableTokens, tokensAmount);      
347     }
348 
349     msg.sender.transfer(etherAmount);
350     emit Transfer(msg.sender, 0, tokensAmount);
351   }
352   
353 }