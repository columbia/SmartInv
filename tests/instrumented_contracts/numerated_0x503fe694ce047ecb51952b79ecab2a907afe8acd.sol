1 pragma solidity ^0.4.11;
2 
3 
4 contract MaptPricing {
5   // MAPT TOKEN PRICE:
6   uint256 constant MAPT_IN_ETH = 100; // 1 MAPT = 0.01 ETH
7 
8   uint256 constant FRACTIONAL_DIVIDER = 100;
9   uint256 constant DEFAULT_MULTIPLIER = 1 * FRACTIONAL_DIVIDER;
10 
11   uint constant MIN_ETH = 100 ether;
12 
13   uint256[4] prices;
14   uint256[3] dates;
15   mapping (uint256 => uint256[]) rules;
16 
17   function MaptPricing() {
18   }
19 
20   function createPricing() {
21     prices[0] = 3000 ether;
22     prices[1] = 1500 ether;
23     prices[2] = 300 ether;
24     prices[3] = 100 ether;
25 
26     dates[0] = 7 days;
27     dates[1] = 14 days;
28     dates[2] = 140 days;
29 
30     rules[0] = [200, 150, 130, 120];
31     rules[1] = [200, 145, 125, 115];
32     rules[2] = [200, 145, 125, 115];
33   }
34 
35   function calculatePrice(uint valueWei, uint256 timeSinceStart, uint decimals) public returns (uint tokenAmount) {
36     uint Z = 1231231;
37     uint m = 0;
38     uint ip = Z;
39     uint dp = Z;
40     uint tokens;
41 
42     require(valueWei >= MIN_ETH);
43 
44     if (valueWei >= prices[0]) ip = 0;
45     else for (uint i = 1; i < prices.length && ip == Z; i++) {
46       if (valueWei < prices[i-1] && valueWei >= prices[i]) ip = i;
47     }
48 
49     if (ip == Z) {
50       m = DEFAULT_MULTIPLIER;
51     } else {
52       if (timeSinceStart <= dates[0]) {
53         dp = 0;
54       } else {
55         for (i = 1; i < dates.length && dp == Z; i++) {
56           if (timeSinceStart > dates[i-1] && timeSinceStart < dates[i]) {
57             dp = i;
58           }
59         }
60         //later on
61         if (timeSinceStart > dates[dates.length-1]) {
62           dp = dates.length-1;
63         }
64       }
65 
66       if (dp == Z) {
67         m = DEFAULT_MULTIPLIER;
68       } else {
69         m = (rules[dp])[ip];
70       }
71     }
72 
73     tokens = valueWei * MAPT_IN_ETH;
74 
75     uint d = decimals;
76     d++;
77 
78     uint res = tokens * m / DEFAULT_MULTIPLIER;
79 
80     return res;
81   }
82 }
83 
84 contract MaptPresaleToken {
85 
86     uint constant MIN_TRANSACTION_AMOUNT_ETH = 100 ether;
87 
88     MaptPricing priceRules = new MaptPricing();
89     uint public PRESALE_START_DATE = 1503313200; //Mon Aug 21 12:00:00 +00 2017
90     uint public PRESALE_END_DATE = PRESALE_START_DATE + 30 days;
91 
92     function MaptPresaleToken(address _tokenManager, address _escrow) {
93         tokenManager = _tokenManager;
94         escrow = _escrow;
95         priceRules.createPricing();
96     }
97 
98     string public constant name = "MAT Presale Token";
99     string public constant symbol = "MAPT";
100     uint   public constant decimals = 18;
101 
102     uint public constant TOKEN_SUPPLY_LIMIT = 2800000 * 1 ether / 1 wei;
103 
104     enum Phase {
105         Created,
106         Running,
107         Paused,
108         Migrating,
109         Migrated
110     }
111 
112     Phase public currentPhase = Phase.Created;
113 
114     uint public totalSupply = 0;
115 
116     address public tokenManager;
117 
118     address public escrow;
119 
120     address public crowdsaleManager;
121 
122     mapping (address => uint256) private balanceTable;
123 
124     modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
125     modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }
126 
127     event LogBuy(address indexed owner, uint etherWeiIncoming, uint tokensSold);
128     event LogBuyForFiat(address indexed owner, uint tokensSold);
129     event LogBurn(address indexed owner, uint value);
130     event LogPhaseSwitch(Phase newPhase);
131     event LogEscrow(uint balance);
132     event LogEscrowReq(uint balance);
133     event LogStartDate(uint newdate, uint oldDate);
134 
135     function() payable {
136         buyTokens(msg.sender);
137     }
138 
139     function burnTokens(address _owner)
140         public
141         onlyCrowdsaleManager
142         returns (uint)
143     {
144         if(currentPhase != Phase.Migrating) return 1;
145 
146         uint tokens = balanceTable[_owner];
147         if(tokens == 0) return 2;
148         totalSupply -= tokens;
149         balanceTable[_owner] = 0;
150         LogBurn(_owner, tokens);
151 
152         if(totalSupply == 0) {
153             currentPhase = Phase.Migrated;
154             LogPhaseSwitch(Phase.Migrated);
155         }
156 
157         return 0;
158     }
159 
160     function balanceOf(address _owner) constant returns (uint256) {
161         return balanceTable[_owner];
162     }
163 
164     function setPresalePhaseUInt(uint phase)
165         public
166         onlyTokenManager
167     {
168       require( uint(Phase.Migrated) >= phase && phase >= 0 );
169       setPresalePhase(Phase(phase));
170     }
171 
172     function setPresalePhase(Phase _nextPhase)
173         public
174         onlyTokenManager
175     {
176       _setPresalePhase(_nextPhase);
177     }
178 
179     function _setPresalePhase(Phase _nextPhase)
180         private
181     {
182         bool canSwitchPhase
183             =  (currentPhase == Phase.Created && _nextPhase == Phase.Running)
184             || (currentPhase == Phase.Running && _nextPhase == Phase.Paused)
185             || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
186                 && _nextPhase == Phase.Migrating
187                 && crowdsaleManager != 0x0)
188             || (currentPhase == Phase.Paused && _nextPhase == Phase.Running)
189             || (currentPhase == Phase.Migrating && _nextPhase == Phase.Migrated
190                 && totalSupply == 0);
191 
192         if(!canSwitchPhase) throw;
193         currentPhase = _nextPhase;
194         LogPhaseSwitch(_nextPhase);
195     }
196 
197     function setCrowdsaleManager(address _mgr)
198         public
199         onlyTokenManager
200     {
201         if(currentPhase == Phase.Migrating) throw;
202         crowdsaleManager = _mgr;
203     }
204 
205     function setStartDate(uint _date)
206         public
207         onlyTokenManager
208     {
209         if(currentPhase != Phase.Created) throw;
210         LogStartDate(_date, PRESALE_START_DATE);
211         PRESALE_START_DATE = _date;
212         PRESALE_END_DATE = PRESALE_START_DATE + 30 days;
213     }
214 
215     function buyTokens(address _buyer)
216         public
217         payable
218     {
219         require(totalSupply < TOKEN_SUPPLY_LIMIT);
220         uint valueWei = msg.value;
221 
222         require(currentPhase == Phase.Running);
223         require(valueWei >= MIN_TRANSACTION_AMOUNT_ETH);
224         require(now >= PRESALE_START_DATE);
225         require(now <= PRESALE_END_DATE);
226 
227         uint timeSinceStart = now - PRESALE_START_DATE;
228         uint newTokens = priceRules.calculatePrice(valueWei, timeSinceStart, 18);
229 
230         require(newTokens > 0);
231         require(totalSupply + newTokens <= TOKEN_SUPPLY_LIMIT);
232 
233         totalSupply += newTokens;
234         balanceTable[_buyer] += newTokens;
235 
236         LogBuy(_buyer, valueWei, newTokens);
237     }
238 
239     function buyTokensForFiat(address _buyer, uint tokens)
240         public
241         onlyTokenManager
242     {
243       require(currentPhase == Phase.Running);
244       require(tokens > 0);
245 
246       uint newTokens = tokens;
247       require (totalSupply + newTokens <= TOKEN_SUPPLY_LIMIT);
248       totalSupply += newTokens;
249       balanceTable[_buyer] += newTokens;
250 
251       LogBuyForFiat(_buyer, newTokens);
252     }
253 
254     function withdrawEther(uint bal)
255         public
256         onlyTokenManager
257         returns (uint)
258     {
259         LogEscrowReq(bal);
260         if(this.balance >= bal) {
261             escrow.transfer(bal);
262             LogEscrow(bal);
263             return 0;
264         }
265         return 1;
266     }
267 }