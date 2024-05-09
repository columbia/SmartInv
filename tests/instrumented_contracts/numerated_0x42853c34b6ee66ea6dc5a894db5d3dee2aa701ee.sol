1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract ERC20 {
28     function totalSupply() constant returns (uint256 supply) {}
29     function balanceOf(address _owner) constant returns (uint256 balance) {}
30     function transfer(address _to, uint256 _value) returns (bool success) {}
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32     function approve(address _spender, uint256 _value) returns (bool success) {}
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract Ownable {
39     address public owner;
40     function Ownable() public {
41         owner =  msg.sender;
42     }
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 }
48 
49 contract RefundVault is Ownable {
50     using SafeMath for uint256;
51     enum State { Active, Refunding, Closed }
52     mapping (address => uint256) public deposited;
53     address public wallet;
54     State public state;
55     event Closed();
56     event RefundsEnabled();
57     event Refunded(address indexed beneficiary, uint256 weiAmount);
58     function RefundVault(address _wallet) public {
59         wallet = _wallet;
60         state = State.Active;
61     }
62     function deposit(address investor) onlyOwner public payable {
63         require(state == State.Active);
64         deposited[investor] = deposited[investor].add(msg.value);
65     }
66     function close() onlyOwner public {
67         require(state == State.Active);
68         state = State.Closed;
69         wallet.transfer(this.balance);
70         Closed();
71     }
72     function enableRefunds() onlyOwner public {
73         require(state == State.Active);
74         state = State.Refunding;
75         RefundsEnabled();
76     }
77     function refund(address investor) public {
78         require(state == State.Refunding);
79         uint256 depositedValue = deposited[investor];
80         deposited[investor] = 0;
81         investor.transfer(depositedValue);
82         Refunded(investor, depositedValue);
83     }
84 }
85 
86 contract Gryphon is ERC20, Ownable {
87 
88     using SafeMath for uint256;
89 
90     RefundVault public vault;
91 
92     mapping(address => uint256) balances;
93     mapping(address => uint256) vested;
94     mapping(address => uint256) total_vested;
95     mapping (address => mapping (address => uint256)) allowed;
96 
97     uint256 totalSupply_;
98 
99     string public name = 'Gryphon';
100     string public symbol = 'GXC';
101     uint256 public decimals = 4;
102     uint256 public initialSupply = 2000000000;
103 
104     uint256 public start;
105     uint256 public duration;
106 
107     uint256 public rateICO = 910000000000000;
108 
109     uint256 public preSaleMaxCapInWei = 10000 ether;
110     uint256 public preSaleRaised = 0;
111 
112     uint256 public icoSoftCapInWei = 102000 ether;
113     uint256 public icoHardCapInWei = 238100 ether;
114     uint256 public icoRaised = 0;
115 
116     uint256 public presaleStartTimestamp;
117     uint256 public presaleEndTimestamp;
118     uint256 public icoStartTimestamp;
119     uint256 public icoEndTimestamp;
120 
121     uint256 public presaleTokenLimit;
122     uint256 public icoTokenLimit;
123 
124     uint256 public investorCount;
125 
126     enum State {Unknown, Preparing, PreSale, ICO, Success, Failure, PresaleFinalized, ICOFinalized}
127 
128     State public crowdSaleState;
129 
130     modifier nonZero() {
131         require(msg.value > 0);
132         _;
133     }
134 
135     function Gryphon() public {
136 
137         owner = 0xf42B82D02b8f3E7983b3f7E1000cE28EC3F8C815;
138         vault = new RefundVault(0x6cD6B03D16E4BE08159412a7E290F1EA23446Bf2);
139 
140         totalSupply_ = initialSupply*(10**decimals);
141 
142         balances[owner] = totalSupply_;
143 
144         presaleStartTimestamp = 1523232000;
145         presaleEndTimestamp = presaleStartTimestamp + 50 * 1 days;
146 
147         icoStartTimestamp = presaleEndTimestamp + 1 days;
148         icoEndTimestamp = icoStartTimestamp + 60 * 1 days;
149 
150         crowdSaleState = State.Preparing;
151 
152         start = 1523232000;
153         duration = 23328000;
154     }
155 
156     function () nonZero payable {
157         enter();
158     }
159 
160     function enter() public nonZero payable {
161         if(isPreSalePeriod()) {
162 
163             if(crowdSaleState == State.Preparing) {
164                 crowdSaleState = State.PreSale;
165             }
166 
167             buyTokens(msg.sender, msg.value);
168         }
169         else if (isICOPeriod()) {
170             if(crowdSaleState == State.PresaleFinalized) {
171                 crowdSaleState = State.ICO;
172             }
173 
174             buyTokens(msg.sender, msg.value);
175         } else {
176 
177             revert();
178         }
179     }
180 
181     function buyTokens(address _recipient, uint256 _value) internal nonZero returns (bool success) {
182         uint256 boughtTokens = calculateTokens(_value);
183         require(boughtTokens != 0);
184         boughtTokens = boughtTokens*(10**decimals);
185 
186         if(balanceOf(_recipient) == 0) {
187             investorCount++;
188         }
189 
190         if(isCrowdSaleStatePreSale()) {
191             transferTokens(_recipient, boughtTokens);
192             vault.deposit.value(_value)(_recipient);
193             preSaleRaised = preSaleRaised.add(_value);
194             return true;
195         } else if (isCrowdSaleStateICO()) {
196             transferTokens(_recipient, boughtTokens);
197             vault.deposit.value(_value)(_recipient);
198             icoRaised = icoRaised.add(_value);
199             return true;
200         }
201     }
202 
203     function transferTokens(address _recipient, uint256 tokens_in_cents) internal returns (bool) {
204         require(
205             tokens_in_cents > 0
206             && _recipient != owner
207             && tokens_in_cents < balances[owner]
208         );
209 
210         balances[owner] = balances[owner].sub(tokens_in_cents);
211 
212         balances[_recipient] = balances[_recipient].add(tokens_in_cents);
213         getVested(_recipient);
214 
215         Transfer(owner, _recipient, tokens_in_cents);
216         return true;
217     }
218 
219     function getVested(address _beneficiary) public returns (uint256) {
220         require(balances[_beneficiary]>0);
221         if (_beneficiary == owner){
222 
223             vested[owner] = balances[owner];
224             total_vested[owner] = balances[owner];
225 
226         } else if (block.timestamp < start) {
227 
228             vested[_beneficiary] = 0;
229             total_vested[_beneficiary] = 0;
230 
231         } else if (block.timestamp >= start.add(duration)) {
232 
233             total_vested[_beneficiary] = balances[_beneficiary];
234             vested[_beneficiary] = balances[_beneficiary];
235 
236         } else {
237 
238             uint vested_now = balances[_beneficiary].mul(block.timestamp.sub(start)).div(duration);
239             if(total_vested[_beneficiary]==0){
240                 total_vested[_beneficiary] = vested_now;
241 
242             }
243             if(vested_now > total_vested[_beneficiary]){
244                 vested[_beneficiary] = vested[_beneficiary].add(vested_now.sub(total_vested[_beneficiary]));
245                 total_vested[_beneficiary] = vested_now;
246             }
247         }
248         return vested[_beneficiary];
249     }
250 
251     function transfer(address _to, uint256 _tokens_in_cents) public returns (bool) {
252         require(_tokens_in_cents > 0);
253         require(_to != msg.sender);
254         getVested(msg.sender);
255         require(balances[msg.sender] >= _tokens_in_cents);
256         require(vested[msg.sender] >= _tokens_in_cents);
257 
258         if(balanceOf(_to) == 0) {
259             investorCount++;
260         }
261 
262         balances[msg.sender] = balances[msg.sender].sub(_tokens_in_cents);
263         vested[msg.sender] = vested[msg.sender].sub(_tokens_in_cents);
264         balances[_to] = balances[_to].add(_tokens_in_cents);
265 
266         if(balanceOf(msg.sender) == 0) {
267             investorCount=investorCount-1;
268         }
269 
270         Transfer(msg.sender, _to, _tokens_in_cents);
271         return true;
272     }
273 
274     function transferFrom(address _from, address _to, uint256 _tokens_in_cents) public returns (bool success) {
275         require(_tokens_in_cents > 0);
276         require(_from != _to);
277         getVested(_from);
278         require(balances[_from] >= _tokens_in_cents);
279         require(vested[_from] >= _tokens_in_cents);
280         require(allowed[_from][msg.sender] >= _tokens_in_cents);
281 
282         if(balanceOf(_to) == 0) {
283             investorCount++;
284         }
285 
286         balances[_from] = balances[_from].sub(_tokens_in_cents);
287         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_tokens_in_cents);
288         vested[_from] = vested[_from].sub(_tokens_in_cents);
289 
290         balances[_to] = balances[_to].add(_tokens_in_cents);
291 
292         if(balanceOf(_from) == 0) {
293             investorCount=investorCount-1;
294         }
295 
296         Transfer(_from, _to, _tokens_in_cents);
297         return true;
298     }
299 
300     function approve(address _spender, uint256 _tokens_in_cents) returns (bool success) {
301         require(vested[msg.sender] >= _tokens_in_cents);
302         allowed[msg.sender][_spender] = _tokens_in_cents;
303         Approval(msg.sender, _spender, _tokens_in_cents);
304         return true;
305     }
306 
307     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
308         return allowed[_owner][_spender];
309     }
310 
311     function calculateTokens(uint256 _amount) internal returns (uint256 tokens){
312         if(crowdSaleState == State.Preparing && isPreSalePeriod()) {
313             crowdSaleState = State.PreSale;
314         }
315         if(isCrowdSaleStatePreSale()) {
316             tokens = _amount.div(rateICO);
317         } else if (isCrowdSaleStateICO()) {
318             tokens = _amount.div(rateICO);
319         } else {
320             tokens = 0;
321         }
322     }
323 
324     function getRefund(address _recipient) public returns (bool){
325         require(crowdSaleState == State.Failure);
326         require(refundedAmount(_recipient));
327         vault.refund(_recipient);
328         return true;
329     }
330 
331     function refundedAmount(address _recipient) internal returns (bool) {
332         require(balances[_recipient] != 0);
333         balances[_recipient] = 0;
334         return true;
335     }
336 
337     function totalSupply() public view returns (uint256) {
338         return totalSupply_;
339     }
340 
341     function balanceOf(address a) public view returns (uint256 balance) {
342         return balances[a];
343     }
344 
345     function isCrowdSaleStatePreSale() public constant returns (bool) {
346         return crowdSaleState == State.PreSale;
347     }
348 
349     function isCrowdSaleStateICO() public constant returns (bool) {
350         return crowdSaleState == State.ICO;
351     }
352 
353     function isPreSalePeriod() public constant returns (bool) {
354         if(preSaleRaised > preSaleMaxCapInWei || now >= presaleEndTimestamp) {
355             crowdSaleState = State.PresaleFinalized;
356             return false;
357         } else {
358             return now > presaleStartTimestamp;
359         }
360     }
361 
362     function isICOPeriod() public constant returns (bool) {
363         if (icoRaised > icoHardCapInWei || now >= icoEndTimestamp){
364             crowdSaleState = State.ICOFinalized;
365             return false;
366         } else {
367             return now > icoStartTimestamp;
368         }
369     }
370 
371     function endCrowdSale() public onlyOwner {
372         require(now >= icoEndTimestamp || icoRaised >= icoSoftCapInWei);
373         if(icoRaised >= icoSoftCapInWei){
374             crowdSaleState = State.Success;
375             vault.close();
376         } else {
377             crowdSaleState = State.Failure;
378             vault.enableRefunds();
379         }
380     }
381 
382 
383     function getInvestorCount() public constant returns (uint256) {
384         return investorCount;
385     }
386 
387     function getPresaleRaisedAmount() public constant returns (uint256) {
388         return preSaleRaised;
389     }
390 
391     function getICORaisedAmount() public constant returns (uint256) {
392         return icoRaised;
393     }
394 
395 }