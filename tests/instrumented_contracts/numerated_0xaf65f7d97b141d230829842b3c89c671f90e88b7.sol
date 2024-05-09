1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract PreSaleToken {
36     using SafeMath for uint256;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     event AllowExchanger(address indexed exchanger);
40     event RevokeExchanger(address indexed exchanger);
41     event Mint(address indexed to, uint256 amount);
42     event MintFinished();
43     event Exchange(address indexed from, uint256 exchangedValue, string symbol, uint256 grantedValue);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 
46     /// The owner of the contract.
47     address public owner;
48 
49     /// The total number of minted tokens, excluding destroyed tokens.
50     uint256 public totalSupply;
51 
52     /// The token balance of each address.
53     mapping(address => uint256) balances;
54 
55     /// The full list of addresses we have minted tokens for, stored for
56     /// exchange purposes.
57     address[] public holders;
58 
59     /// Whether the token is still mintable.
60     bool public mintingFinished = false;
61 
62     /// Addresses allowed to exchange the presale tokens for the final
63     /// and/or intermediary tokens.
64     mapping(address => bool) public exchangers;
65 
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     modifier onlyExchanger() {
72         require(exchangers[msg.sender]);
73         _;
74     }
75 
76     function PreSaleToken() public {
77         owner = msg.sender;
78     }
79 
80     function allowExchanger(address _exchanger) onlyOwner public {
81         require(mintingFinished);
82         require(_exchanger != 0x0);
83         require(!exchangers[_exchanger]);
84 
85         exchangers[_exchanger] = true;
86         AllowExchanger(_exchanger);
87     }
88 
89     function exchange(
90         address _from,
91         uint256 _amount,
92         string _symbol,
93         uint256 _grantedValue
94     )
95         onlyExchanger
96         public
97         returns (bool)
98     {
99         require(mintingFinished); // Always true due to exchangers requiring the same condition
100         require(_from != 0x0);
101         require(!exchangers[_from]);
102         require(_amount > 0);
103         require(_amount <= balances[_from]);
104 
105         balances[_from] = balances[_from].sub(_amount);
106         balances[msg.sender] = balances[msg.sender].add(_amount);
107         Exchange(
108             _from,
109             _amount,
110             _symbol,
111             _grantedValue
112         );
113         Transfer(_from, msg.sender, _amount);
114 
115         return true;
116     }
117 
118     function finishMinting() onlyOwner public returns (bool) {
119         require(!mintingFinished);
120 
121         mintingFinished = true;
122         MintFinished();
123 
124         return true;
125     }
126 
127     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
128         require(_to != 0x0);
129         require(!mintingFinished);
130         require(_amount > 0);
131 
132         totalSupply = totalSupply.add(_amount);
133         balances[_to] = balances[_to].add(_amount);
134         holders.push(_to);
135         Mint(_to, _amount);
136         Transfer(0x0, _to, _amount);
137 
138         return true;
139     }
140 
141     function revokeExchanger(address _exchanger) onlyOwner public {
142         require(mintingFinished);
143         require(_exchanger != 0x0);
144         require(exchangers[_exchanger]);
145 
146         delete exchangers[_exchanger];
147         RevokeExchanger(_exchanger);
148     }
149 
150     function transferOwnership(address _to) onlyOwner public {
151         require(_to != address(0));
152         OwnershipTransferred(owner, _to);
153         owner = _to;
154     }
155 
156     function balanceOf(address _owner) public constant returns (uint256) {
157         return balances[_owner];
158     }
159 }
160 
161 
162 contract PreSale {
163     using SafeMath for uint256;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166     event WalletChanged(address indexed previousWallet, address indexed newWallet);
167     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
168     event Pause();
169     event Unpause();
170     event Withdrawal(address indexed wallet, uint256 weiAmount);
171     event Extended(uint256 until);
172     event Finalized();
173     event Refunding();
174     event Refunded(address indexed beneficiary, uint256 weiAmount);
175     event Whitelisted(address indexed participant, uint256 weiAmount, uint32 bonusRate);
176 
177     /// The owner of the contract.
178     address public owner;
179 
180     /// The token we're selling.
181     PreSaleToken public token;
182 
183     /// The minimum goal to reach. If the goal is not reached, finishing
184     /// the sale will enable refunds.
185     uint256 public goal;
186 
187     /// The sale period.
188     uint256 public startTime;
189     uint256 public endTime;
190     uint256 public timeExtension;
191 
192     /// The numnber of tokens to mint per wei.
193     uint256 public rate;
194 
195     /// The total number of wei raised. Note that the contract's balance may
196     /// differ from this value if someone has decided to forcefully send us
197     /// ether.
198     uint256 public weiRaised;
199 
200     /// The wallet that will receive the contract's balance once the sale
201     /// finishes and the minimum goal is met.
202     address public wallet;
203 
204     /// The list of addresses that are allowed to participate in the sale,
205     /// up to what amount, and any special rate they may have.
206     mapping(address => uint256) public whitelisted;
207     mapping(address => uint32) public bonusRates;
208 
209     /// The amount of wei invested by each investor.
210     mapping(address => uint256) public deposited;
211 
212     /// An enumerable list of investors.
213     address[] public investors;
214 
215     /// Whether the sale is paused.
216     bool public paused = false;
217 
218     /// Whether the sale has finished, and when.
219     bool public finished = false;
220     uint256 public finishedAt;
221 
222     /// Whether we're accepting refunds.
223     bool public refunding = false;
224 
225     /// The total number of wei refunded.
226     uint256 public weiRefunded;
227 
228     modifier onlyOwner() {
229         require(msg.sender == owner);
230         _;
231     }
232 
233     modifier saleOpen() {
234         require(!finished);
235         require(!paused);
236         require(now >= startTime);
237         require(now <= endTime + timeExtension);
238         _;
239     }
240 
241     function PreSale(
242         uint256 _goal,
243         uint256 _startTime,
244         uint256 _endTime,
245         uint256 _rate,
246         address _wallet
247     )
248         public
249         payable
250     {
251         require(msg.value > 0);
252         require(_goal > 0);
253         require(_startTime >= now);
254         require(_endTime >= _startTime);
255         require(_rate > 0);
256         require(_wallet != 0x0);
257 
258         owner = msg.sender;
259         goal = _goal;
260         startTime = _startTime;
261         endTime = _endTime;
262         rate = _rate;
263         wallet = _wallet;
264         token = new PreSaleToken();
265 
266         wallet.transfer(msg.value);
267     }
268 
269     function () public payable {
270         buyTokens(msg.sender);
271     }
272 
273     function buyTokens(address _beneficiary) saleOpen public payable {
274         require(_beneficiary != address(0));
275         require(msg.value > 0);
276 
277         uint256 weiAmount = msg.value;
278         uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
279 
280         require(newDeposited <= whitelisted[_beneficiary]);
281 
282         uint32 bonusRate = bonusRates[_beneficiary];
283         uint256 tokens = weiAmount.mul(rate).mul(1000 + bonusRate).div(1000);
284 
285         deposited[_beneficiary] = newDeposited;
286         investors.push(_beneficiary);
287 
288         weiRaised = weiRaised.add(weiAmount);
289 
290         token.mint(_beneficiary, tokens);
291         TokenPurchase(
292             msg.sender,
293             _beneficiary,
294             weiAmount,
295             tokens
296         );
297     }
298 
299     function changeWallet(address _wallet) onlyOwner public payable {
300         require(_wallet != 0x0);
301         require(msg.value > 0);
302 
303         WalletChanged(wallet, _wallet);
304         wallet = _wallet;
305 
306         wallet.transfer(msg.value);
307     }
308 
309     function extendTime(uint256 _timeExtension) onlyOwner public {
310         require(!finished);
311         require(now < endTime + timeExtension);
312         require(_timeExtension > 0);
313 
314         timeExtension = timeExtension.add(_timeExtension);
315         require(timeExtension <= 7 days);
316 
317         Extended(endTime.add(timeExtension));
318     }
319 
320     function finish() onlyOwner public {
321         require(!finished);
322         require(now > endTime + timeExtension);
323 
324         finished = true;
325         finishedAt = now;
326         token.finishMinting();
327 
328         if (goalReached()) {
329             token.transferOwnership(owner);
330             withdraw();
331         } else {
332             refunding = true;
333             Refunding();
334         }
335 
336         Finalized();
337     }
338 
339     function pause() onlyOwner public {
340         require(!paused);
341         paused = true;
342         Pause();
343     }
344 
345     function refund(address _investor) public {
346         require(finished);
347         require(refunding);
348         require(deposited[_investor] > 0);
349 
350         uint256 weiAmount = deposited[_investor];
351         deposited[_investor] = 0;
352         weiRefunded = weiRefunded.add(weiAmount);
353         Refunded(_investor, weiAmount);
354 
355         _investor.transfer(weiAmount);
356     }
357 
358     function transferOwnership(address _to) onlyOwner public {
359         require(_to != address(0));
360         OwnershipTransferred(owner, _to);
361         owner = _to;
362     }
363 
364     function unpause() onlyOwner public {
365         require(paused);
366         paused = false;
367         Unpause();
368     }
369 
370     function whitelist(
371         address _participant,
372         uint256 _weiAmount,
373         uint32 _bonusRate
374     )
375         onlyOwner
376         public
377     {
378         require(_participant != 0x0);
379         require(_bonusRate <= 1000);
380 
381         whitelisted[_participant] = _weiAmount;
382         bonusRates[_participant] = _bonusRate;
383         Whitelisted(_participant, _weiAmount, _bonusRate);
384     }
385 
386     function withdraw() onlyOwner public {
387         require(goalReached() || (finished && now > finishedAt + 14 days));
388 
389         uint256 weiAmount = this.balance;
390 
391         if (weiAmount > 0) {
392             wallet.transfer(weiAmount);
393             Withdrawal(wallet, weiAmount);
394         }
395     }
396 
397     function goalReached() public constant returns (bool) {
398         return weiRaised >= goal;
399     }
400 }