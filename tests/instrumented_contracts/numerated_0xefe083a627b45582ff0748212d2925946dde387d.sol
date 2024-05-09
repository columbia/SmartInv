1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract PreSaleToken {
35     using SafeMath for uint256;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38     event AllowExchanger(address indexed exchanger);
39     event RevokeExchanger(address indexed exchanger);
40     event Mint(address indexed to, uint256 amount);
41     event MintFinished();
42     event Exchange(address indexed from, uint256 exchangedValue, string symbol, uint256 grantedValue);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /// The owner of the contract.
46     address public owner;
47 
48     /// The total number of minted tokens, excluding destroyed tokens.
49     uint256 public totalSupply;
50 
51     /// The token balance of each address.
52     mapping(address => uint256) balances;
53 
54     /// The full list of addresses we have minted tokens for, stored for
55     /// exchange purposes.
56     address[] public holders;
57 
58     /// Whether the token is still mintable.
59     bool public mintingFinished = false;
60 
61     /// Addresses allowed to exchange the presale tokens for the final
62     /// and/or intermediary tokens.
63     mapping(address => bool) public exchangers;
64 
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     modifier onlyExchanger() {
71         require(exchangers[msg.sender]);
72         _;
73     }
74 
75     function PreSaleToken() {
76         owner = msg.sender;
77     }
78 
79     function allowExchanger(address _exchanger) onlyOwner public {
80         require(mintingFinished);
81         require(_exchanger != 0x0);
82         require(!exchangers[_exchanger]);
83 
84         exchangers[_exchanger] = true;
85         AllowExchanger(_exchanger);
86     }
87 
88     function exchange(
89         address _from,
90         uint256 _amount,
91         string _symbol,
92         uint256 _grantedValue
93     )
94         onlyExchanger
95         public
96         returns (bool)
97     {
98         require(mintingFinished); // Always true due to exchangers requiring the same condition
99         require(_from != 0x0);
100         require(!exchangers[_from]);
101         require(_amount > 0);
102         require(_amount <= balances[_from]);
103 
104         balances[_from] = balances[_from].sub(_amount);
105         balances[msg.sender] = balances[msg.sender].add(_amount);
106         Exchange(
107             _from,
108             _amount,
109             _symbol,
110             _grantedValue
111         );
112         Transfer(_from, msg.sender, _amount);
113 
114         return true;
115     }
116 
117     function finishMinting() onlyOwner public returns (bool) {
118         require(!mintingFinished);
119 
120         mintingFinished = true;
121         MintFinished();
122 
123         return true;
124     }
125 
126     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
127         require(_to != 0x0);
128         require(!mintingFinished);
129         require(_amount > 0);
130 
131         totalSupply = totalSupply.add(_amount);
132         balances[_to] = balances[_to].add(_amount);
133         holders.push(_to);
134         Mint(_to, _amount);
135         Transfer(0x0, _to, _amount);
136 
137         return true;
138     }
139 
140     function revokeExchanger(address _exchanger) onlyOwner public {
141         require(mintingFinished);
142         require(_exchanger != 0x0);
143         require(exchangers[_exchanger]);
144 
145         delete exchangers[_exchanger];
146         RevokeExchanger(_exchanger);
147     }
148 
149     function transferOwnership(address _to) onlyOwner public {
150         require(_to != address(0));
151         OwnershipTransferred(owner, _to);
152         owner = _to;
153     }
154 
155     function balanceOf(address _owner) public constant returns (uint256) {
156         return balances[_owner];
157     }
158 }
159 
160 
161 contract PreSale {
162     using SafeMath for uint256;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
166     event Pause();
167     event Unpause();
168     event Withdrawal(address indexed wallet, uint256 weiAmount);
169     event Extended(uint256 until);
170     event Finalized();
171     event Refunding();
172     event Refunded(address indexed beneficiary, uint256 weiAmount);
173     event Whitelisted(address indexed participant, uint256 weiAmount);
174 
175     /// The owner of the contract.
176     address public owner;
177 
178     /// The token we're selling.
179     PreSaleToken public token;
180 
181     /// The minimum goal to reach. If the goal is not reached, finishing
182     /// the sale will enable refunds.
183     uint256 public goal;
184 
185     /// The sale period.
186     uint256 public startTime;
187     uint256 public endTime;
188     uint256 public timeExtension;
189 
190     /// The numnber of tokens to mint per wei.
191     uint256 public rate;
192 
193     /// The total number of wei raised. Note that the contract's balance may
194     /// differ from this value if someone has decided to forcefully send us
195     /// ether.
196     uint256 public weiRaised;
197 
198     /// The wallet that will receive the contract's balance once the sale
199     /// finishes and the minimum goal is met.
200     address public wallet;
201 
202     /// The list of addresses that are allowed to participate in the sale,
203     /// and up to what amount.
204     mapping(address => uint256) public whitelisted;
205 
206     /// The amount of wei invested by each investor.
207     mapping(address => uint256) public deposited;
208 
209     /// An enumerable list of investors.
210     address[] public investors;
211 
212     /// Whether the sale is paused.
213     bool public paused = false;
214 
215     /// Whether the sale has finished, and when.
216     bool public finished = false;
217     uint256 public finishedAt;
218 
219     /// Whether we're accepting refunds.
220     bool public refunding = false;
221 
222     /// The total number of wei refunded.
223     uint256 public weiRefunded;
224 
225     modifier onlyOwner() {
226         require(msg.sender == owner);
227         _;
228     }
229 
230     modifier saleOpen() {
231         require(!finished);
232         require(!paused);
233         require(now >= startTime);
234         require(now <= endTime + timeExtension);
235         _;
236     }
237 
238     function PreSale(
239         uint256 _goal,
240         uint256 _startTime,
241         uint256 _endTime,
242         uint256 _rate,
243         address _wallet
244     )
245         payable
246     {
247         require(msg.value > 0);
248         require(_goal > 0);
249         require(_startTime >= now);
250         require(_endTime >= _startTime);
251         require(_rate > 0);
252         require(_wallet != 0x0);
253 
254         owner = msg.sender;
255         goal = _goal;
256         startTime = _startTime;
257         endTime = _endTime;
258         rate = _rate;
259         wallet = _wallet;
260         token = new PreSaleToken();
261 
262         wallet.transfer(msg.value);
263     }
264 
265     function () payable {
266         buyTokens(msg.sender);
267     }
268 
269     function buyTokens(address _beneficiary) saleOpen public payable {
270         require(_beneficiary != address(0));
271         require(msg.value > 0);
272 
273         uint256 weiAmount = msg.value;
274         uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
275 
276         require(newDeposited <= whitelisted[_beneficiary]);
277 
278         uint256 tokens = weiAmount.mul(rate);
279 
280         deposited[_beneficiary] = newDeposited;
281         investors.push(_beneficiary);
282 
283         weiRaised = weiRaised.add(weiAmount);
284 
285         token.mint(_beneficiary, tokens);
286         TokenPurchase(
287             msg.sender,
288             _beneficiary,
289             weiAmount,
290             tokens
291         );
292     }
293 
294     function extendTime(uint256 _timeExtension) onlyOwner public {
295         require(!finished);
296         require(now < endTime + timeExtension);
297         require(_timeExtension > 0);
298 
299         timeExtension = timeExtension.add(_timeExtension);
300         require(timeExtension <= 7 days);
301 
302         Extended(endTime.add(timeExtension));
303     }
304 
305     function finish() onlyOwner public {
306         require(!finished);
307         require(now > endTime + timeExtension);
308 
309         finished = true;
310         finishedAt = now;
311         token.finishMinting();
312 
313         if (goalReached()) {
314             token.transferOwnership(owner);
315             withdraw();
316         } else {
317             refunding = true;
318             Refunding();
319         }
320 
321         Finalized();
322     }
323 
324     function pause() onlyOwner public {
325         require(!paused);
326         paused = true;
327         Pause();
328     }
329 
330     function refund(address _investor) public {
331         require(finished);
332         require(refunding);
333         require(deposited[_investor] > 0);
334 
335         uint256 weiAmount = deposited[_investor];
336         deposited[_investor] = 0;
337         weiRefunded = weiRefunded.add(weiAmount);
338 
339         // Work around a Solium linter bug by creating a variable that does
340         // not begin with an underscore. See [1] for more information.
341         //
342         // [1] https://github.com/duaraghav8/Solium/issues/116
343         address recipient = _investor;
344         recipient.transfer(weiAmount);
345 
346         Refunded(_investor, weiAmount);
347     }
348 
349     function transferOwnership(address _to) onlyOwner public {
350         require(_to != address(0));
351         OwnershipTransferred(owner, _to);
352         owner = _to;
353     }
354 
355     function unpause() onlyOwner public {
356         require(paused);
357         paused = false;
358         Unpause();
359     }
360 
361     function whitelist(address _participant, uint256 _weiAmount) onlyOwner public {
362         require(_participant != 0x0);
363 
364         whitelisted[_participant] = _weiAmount;
365         Whitelisted(_participant, _weiAmount);
366     }
367 
368     function withdraw() onlyOwner public {
369         require(goalReached() || (finished && now > finishedAt + 14 days));
370 
371         uint256 weiAmount = this.balance;
372 
373         if (weiAmount > 0) {
374             wallet.transfer(weiAmount);
375             Withdrawal(wallet, weiAmount);
376         }
377     }
378 
379     function goalReached() public constant returns (bool) {
380         return weiRaised >= goal;
381     }
382 }