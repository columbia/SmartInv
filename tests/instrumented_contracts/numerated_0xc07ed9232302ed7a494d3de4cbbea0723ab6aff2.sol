1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender)
12     public view returns (uint256);
13 
14   function transferFrom(address from, address to, uint256 value)
15     public returns (bool);
16 
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract BouncyCoinIco {
26 
27   event TokensSold(address buyer, uint256 tokensAmount, uint256 ethAmount);
28 
29   struct PriceThreshold {
30     uint256 tokenCount;
31     uint256 price;
32     uint256 tokensSold;
33   }
34 
35   uint256 public constant PRE_ICO_TOKENS = 10000000 * 10**18;
36   uint256 public constant PRE_ICO_PRICE = 0.00010 * 10**18;
37 
38   uint256 public constant PRE_ICO_MINIMUM_CONTRIBUTION = 5 ether;
39   uint256 public constant ICO_MINIMUM_CONTRIBUTION = 0.1 ether;
40 
41   uint256 public maxPreIcoDuration;
42   uint256 public maxIcoDuration;
43 
44   address public owner;
45 
46   address public wallet;
47 
48   ERC20 public bouncyCoinToken;
49 
50   uint256 public startBlock;
51   uint256 public preIcoEndBlock;
52   uint256 public icoEndBlock;
53 
54   uint256 public preIcoTokensSold;
55   PriceThreshold[2] public icoPriceThresholds;
56 
57   /* Current stage */
58   Stages public stage;
59 
60   enum Stages {
61     Deployed,
62     SetUp,
63     StartScheduled,
64     PreIcoStarted,
65     IcoStarted,
66     Ended
67   }
68 
69   /* Modifiers */
70 
71   modifier atStage(Stages _stage) {
72     require(stage == _stage);
73     _;
74   }
75 
76   modifier isOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   modifier isValidPayload() {
82     require(msg.data.length == 0 || msg.data.length == 4);
83     _;
84   }
85 
86   modifier timedTransitions() {
87     if (stage == Stages.StartScheduled && block.number >= startBlock) {
88       startPreIco();
89     }
90     if (stage == Stages.PreIcoStarted && block.number >= preIcoEndBlock) {
91       startIco();
92     }
93     if (stage == Stages.IcoStarted && block.number >= icoEndBlock) {
94       finalize();
95     }
96     _;
97   }
98 
99   /* Constructor */
100 
101   constructor(address _wallet)
102     public {
103     require(_wallet != 0x0);
104 
105     owner = msg.sender;
106     wallet = _wallet;
107     stage = Stages.Deployed;
108   }
109 
110   /* Public functions */
111 
112   function()
113     public
114     payable
115     timedTransitions {
116     if (stage == Stages.PreIcoStarted) {
117       buyPreIcoTokens();
118     } else if (stage == Stages.IcoStarted) {
119       buyIcoTokens();
120     } else {
121       revert();
122     }
123   }
124 
125   function setup(address _bouncyCoinToken, uint256 _maxPreIcoDuration, uint256 _maxIcoDuration)
126     public
127     isOwner
128     atStage(Stages.Deployed) {
129     require(_bouncyCoinToken != 0x0);
130     require(_maxPreIcoDuration > 0);
131     require(_maxIcoDuration > 0);
132 
133     icoPriceThresholds[0] = PriceThreshold(20000000 * 10**18, 0.00020 * 10**18, 0);
134     icoPriceThresholds[1] = PriceThreshold(50000000 * 10**18, 0.00025 * 10**18, 0);
135 
136     bouncyCoinToken = ERC20(_bouncyCoinToken);
137     maxPreIcoDuration = _maxPreIcoDuration;
138     maxIcoDuration = _maxIcoDuration;
139 
140     // validate token balance
141     uint256 tokensRequired = PRE_ICO_TOKENS + maxIcoTokensSold();
142     assert(bouncyCoinToken.balanceOf(this) == tokensRequired);
143 
144     stage = Stages.SetUp;
145   }
146 
147   function maxIcoTokensSold()
148     public
149     constant
150     returns (uint256) {
151     uint256 total = 0;
152     for (uint8 i = 0; i < icoPriceThresholds.length; i++) {
153       total += icoPriceThresholds[i].tokenCount;
154     }
155     return total;
156   }
157 
158   function totalIcoTokensSold()
159     public
160     constant
161     returns (uint256) {
162     uint256 total = 0;
163     for (uint8 i = 0; i < icoPriceThresholds.length; i++) {
164       total += icoPriceThresholds[i].tokensSold;
165     }
166     return total;
167   }
168 
169   /* Schedules the start */
170   function scheduleStart(uint256 _startBlock)
171     public
172     isOwner
173     atStage(Stages.SetUp) {
174     startBlock = _startBlock;
175     preIcoEndBlock = startBlock + maxPreIcoDuration;
176     stage = Stages.StartScheduled;
177   }
178 
179   function updateStage()
180     public
181     timedTransitions
182     returns (Stages) {
183     return stage;
184   }
185 
186   function buyPreIcoTokens()
187     public
188     payable
189     isValidPayload
190     timedTransitions
191     atStage(Stages.PreIcoStarted) {
192     require(msg.value >= PRE_ICO_MINIMUM_CONTRIBUTION);
193 
194     uint256 amountRemaining = msg.value;
195 
196     uint256 tokensAvailable = PRE_ICO_TOKENS - preIcoTokensSold;
197     uint256 maxTokensByAmount = amountRemaining * 10**18 / PRE_ICO_PRICE;
198 
199     uint256 tokensToReceive = 0;
200     if (maxTokensByAmount > tokensAvailable) {
201       tokensToReceive = tokensAvailable;
202       amountRemaining -= (PRE_ICO_PRICE * tokensToReceive) / 10**18;
203     } else {
204       tokensToReceive = maxTokensByAmount;
205       amountRemaining = 0;
206     }
207     preIcoTokensSold += tokensToReceive;
208 
209     assert(tokensToReceive > 0);
210 
211     if (amountRemaining != 0) {
212       msg.sender.transfer(amountRemaining);
213     }
214 
215     uint256 amountAccepted = msg.value - amountRemaining;
216     wallet.transfer(amountAccepted);
217 
218     if (preIcoTokensSold == PRE_ICO_TOKENS) {
219       startIco();
220     }
221 
222     emit TokensSold(msg.sender, tokensToReceive, amountAccepted);
223   }
224 
225   function buyIcoTokens()
226     public
227     payable
228     isValidPayload
229     timedTransitions
230     atStage(Stages.IcoStarted) {
231     require(msg.value >= ICO_MINIMUM_CONTRIBUTION);
232 
233     uint256 amountRemaining = msg.value;
234     uint256 tokensToReceive = 0;
235 
236     for (uint8 i = 0; i < icoPriceThresholds.length; i++) {
237       uint256 tokensAvailable = icoPriceThresholds[i].tokenCount - icoPriceThresholds[i].tokensSold;
238       uint256 maxTokensByAmount = amountRemaining * 10**18 / icoPriceThresholds[i].price;
239 
240       uint256 tokens;
241       if (maxTokensByAmount > tokensAvailable) {
242         tokens = tokensAvailable;
243         amountRemaining -= (icoPriceThresholds[i].price * tokens) / 10**18;
244       } else {
245         tokens = maxTokensByAmount;
246         amountRemaining = 0;
247       }
248       icoPriceThresholds[i].tokensSold += tokens;
249       tokensToReceive += tokens;
250     }
251 
252     assert(tokensToReceive > 0);
253 
254     if (amountRemaining != 0) {
255       msg.sender.transfer(amountRemaining);
256     }
257 
258     uint256 amountAccepted = msg.value - amountRemaining;
259     wallet.transfer(amountAccepted);
260 
261     if (totalIcoTokensSold() == maxIcoTokensSold()) {
262       finalize();
263     }
264 
265     emit TokensSold(msg.sender, tokensToReceive, amountAccepted);
266   }
267 
268   function stop()
269     public
270     isOwner {
271     finalize();
272   }
273 
274   function finishPreIcoAndStartIco()
275     public
276     isOwner
277     timedTransitions
278     atStage(Stages.PreIcoStarted) {
279     startIco();
280   }
281 
282   /* Private functions */
283 
284   function startPreIco()
285     private {
286     stage = Stages.PreIcoStarted;
287   }
288 
289   function startIco()
290     private {
291     stage = Stages.IcoStarted;
292     icoEndBlock = block.number + maxIcoDuration;
293   }
294 
295   function finalize()
296     private {
297     stage = Stages.Ended;
298   }
299 
300   // In case of accidental ether lock on contract
301   function withdraw()
302     public
303     isOwner {
304     owner.transfer(address(this).balance);
305   }
306 
307   // In case of accidental token transfer to this address, owner can transfer it elsewhere
308   function transferERC20Token(address _tokenAddress, address _to, uint256 _value)
309     public
310     isOwner {
311     ERC20 token = ERC20(_tokenAddress);
312     assert(token.transfer(_to, _value));
313   }
314 
315 }