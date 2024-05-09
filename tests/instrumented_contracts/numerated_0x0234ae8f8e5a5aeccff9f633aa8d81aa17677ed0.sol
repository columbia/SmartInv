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
175     event Whitelisted(address indexed participant, uint256 weiAmount);
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
205     /// and up to what amount.
206     mapping(address => uint256) public whitelisted;
207 
208     /// The amount of wei invested by each investor.
209     mapping(address => uint256) public deposited;
210 
211     /// An enumerable list of investors.
212     address[] public investors;
213 
214     /// Whether the sale is paused.
215     bool public paused = false;
216 
217     /// Whether the sale has finished, and when.
218     bool public finished = false;
219     uint256 public finishedAt;
220 
221     /// Whether we're accepting refunds.
222     bool public refunding = false;
223 
224     /// The total number of wei refunded.
225     uint256 public weiRefunded;
226 
227     modifier onlyOwner() {
228         require(msg.sender == owner);
229         _;
230     }
231 
232     modifier saleOpen() {
233         require(!finished);
234         require(!paused);
235         require(now >= startTime);
236         require(now <= endTime + timeExtension);
237         _;
238     }
239 
240     function PreSale(
241         uint256 _goal,
242         uint256 _startTime,
243         uint256 _endTime,
244         uint256 _rate,
245         address _wallet
246     )
247         public
248         payable
249     {
250         require(msg.value > 0);
251         require(_goal > 0);
252         require(_startTime >= now);
253         require(_endTime >= _startTime);
254         require(_rate > 0);
255         require(_wallet != 0x0);
256 
257         owner = msg.sender;
258         goal = _goal;
259         startTime = _startTime;
260         endTime = _endTime;
261         rate = _rate;
262         wallet = _wallet;
263         token = new PreSaleToken();
264 
265         wallet.transfer(msg.value);
266     }
267 
268     function () public payable {
269         buyTokens(msg.sender);
270     }
271 
272     function buyTokens(address _beneficiary) saleOpen public payable {
273         require(_beneficiary != address(0));
274         require(msg.value > 0);
275 
276         uint256 weiAmount = msg.value;
277         uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
278 
279         require(newDeposited <= whitelisted[_beneficiary]);
280 
281         uint256 tokens = weiAmount.mul(rate);
282 
283         deposited[_beneficiary] = newDeposited;
284         investors.push(_beneficiary);
285 
286         weiRaised = weiRaised.add(weiAmount);
287 
288         token.mint(_beneficiary, tokens);
289         TokenPurchase(
290             msg.sender,
291             _beneficiary,
292             weiAmount,
293             tokens
294         );
295     }
296 
297     function changeWallet(address _wallet) onlyOwner public payable {
298         require(_wallet != 0x0);
299         require(msg.value > 0);
300 
301         WalletChanged(wallet, _wallet);
302         wallet = _wallet;
303 
304         wallet.transfer(msg.value);
305     }
306 
307     function extendTime(uint256 _timeExtension) onlyOwner public {
308         require(!finished);
309         require(now < endTime + timeExtension);
310         require(_timeExtension > 0);
311 
312         timeExtension = timeExtension.add(_timeExtension);
313         require(timeExtension <= 7 days);
314 
315         Extended(endTime.add(timeExtension));
316     }
317 
318     function finish() onlyOwner public {
319         require(!finished);
320         require(now > endTime + timeExtension);
321 
322         finished = true;
323         finishedAt = now;
324         token.finishMinting();
325 
326         if (goalReached()) {
327             token.transferOwnership(owner);
328             withdraw();
329         } else {
330             refunding = true;
331             Refunding();
332         }
333 
334         Finalized();
335     }
336 
337     function pause() onlyOwner public {
338         require(!paused);
339         paused = true;
340         Pause();
341     }
342 
343     function refund(address _investor) public {
344         require(finished);
345         require(refunding);
346         require(deposited[_investor] > 0);
347 
348         uint256 weiAmount = deposited[_investor];
349         deposited[_investor] = 0;
350         weiRefunded = weiRefunded.add(weiAmount);
351         Refunded(_investor, weiAmount);
352 
353         _investor.transfer(weiAmount);
354     }
355 
356     function transferOwnership(address _to) onlyOwner public {
357         require(_to != address(0));
358         OwnershipTransferred(owner, _to);
359         owner = _to;
360     }
361 
362     function unpause() onlyOwner public {
363         require(paused);
364         paused = false;
365         Unpause();
366     }
367 
368     function whitelist(address _participant, uint256 _weiAmount) onlyOwner public {
369         require(_participant != 0x0);
370 
371         whitelisted[_participant] = _weiAmount;
372         Whitelisted(_participant, _weiAmount);
373     }
374 
375     function withdraw() onlyOwner public {
376         require(goalReached() || (finished && now > finishedAt + 14 days));
377 
378         uint256 weiAmount = this.balance;
379 
380         if (weiAmount > 0) {
381             wallet.transfer(weiAmount);
382             Withdrawal(wallet, weiAmount);
383         }
384     }
385 
386     function goalReached() public constant returns (bool) {
387         return weiRaised >= goal;
388     }
389 }