1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract FueldToken{
24     using SafeMath for uint256;
25 // ownable
26     address public multisig;
27     address public multisigPreICO;
28     address public owner;
29     address public extOwner;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     function transferOwnership(address newOwner) onlyOwner public {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43     event MultisigsChanged(address _multisig, address _multisigPreICO);
44     function changeMultisigs(address _multisig, address _multisigPreICO) onlyOwner public {
45         require(_multisig != address(0));
46         require(_multisigPreICO != address(0));
47         multisig = _multisig;
48         multisigPreICO = _multisigPreICO;
49         MultisigsChanged(multisig, multisigPreICO);
50     }
51 
52 // self transfer
53     mapping(address => uint256) balances;
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     function transfer(address _to, uint256 _value) public returns (bool) {
56         require(_to != address(0));
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66 // allowed transfer
67     mapping (address => mapping (address => uint256)) allowed;
68     event Approval(address indexed owner_, address indexed spender, uint256 value);
69     function approve(address _spender, uint256 _value) public returns (bool) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         uint256 _allowance = allowed[_from][msg.sender];
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = _allowance.sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
87         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
88         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
89         return true;
90     }
91     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
92         uint oldValue = allowed[msg.sender][_spender];
93         if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0; } 
94         else {allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue); }
95         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96         return true;
97     }
98 
99 // mintable
100     uint256 public totalSupply = 200000000; // minting in constructor
101 // sale
102     mapping (address => uint256) public privatePreICOdepositors;
103     mapping (address => uint256) public preICOdepositors;
104     mapping (address => uint256) public ICOdepositors;
105     mapping (address => uint256) public ICObalances;
106     
107     uint256 constant public softCap = 6700 ether;
108     uint256 constant public hardCap = 67000 ether;
109     uint256 constant public price = 456000000000000 wei; // 0.000000456 ETH * 10**18
110     
111     uint256 constant public maxPreICOSupply = 13500000; // including free bonus tokens
112     uint256 constant public maxPreICOandICOSupply = 150000000;
113 
114     uint256 constant public privatePreICOFreeBonusPercent = 35;
115     uint256 constant public preICOFreeBonusPercent = 30;
116     
117     uint256 constant public privatePreICOBonusPercent = 0;
118     uint256 constant public preICOBonusPercent = 0;
119     uint256 constant public ICOBonusPercent1week = 15;
120     uint256 constant public ICOBonusPercent2week = 10;
121     uint256 constant public ICOBonusPercent3week = 5;
122     uint256 constant public restrictedPercent = 25;
123 
124     uint256 public startTimePrivatePreICO = 0;
125     uint256 public startTimePreICO = 0;
126     uint256 public startTimeICO = 0;
127     uint256 public soldTokenCount = 0;
128     uint256 public cap = 0;
129     uint256 public capPreICO = 0;
130     uint256 public capPreICOTrasferred = 0;
131     uint256 public capFiat = 0;
132     uint256 public capFiatAndETH = 0;
133     bool public capReached = false;
134 
135     // sale
136     event SaleStatus(string indexed status, uint256 indexed _date);
137 
138     function startPrivatePreICO() onlyOwner public {
139         require(startTimeICO == 0 && startTimePreICO == 0);
140         startTimePreICO = now;
141         startTimePrivatePreICO = startTimePreICO;
142         SaleStatus('Private Pre ICO started', startTimePreICO);
143     }
144     
145     function startPreICO() onlyOwner public {
146         require(startTimeICO == 0 && startTimePreICO == 0);
147         startTimePreICO = now;
148         SaleStatus('Public Pre ICO started', startTimePreICO);
149     }
150 
151     function startICO() onlyOwner public {
152         require(startTimeICO == 0 && startTimePreICO == 0);
153         startTimeICO = now;
154         SaleStatus('start ICO', startTimePreICO);
155     }
156 
157     function stopSale() onlyOwner public {
158         require(startTimeICO > 0 || startTimePreICO > 0);
159         if (startTimeICO > 0){
160             SaleStatus('ICO stopped', now);
161         }
162         else{
163             multisigPreICO.transfer(capPreICO);
164             capPreICOTrasferred = capPreICOTrasferred.add(capPreICO);
165             capPreICO = 0;
166             SaleStatus('Pre ICO stopped', now);
167         }
168         startTimeICO = 0;
169         startTimePreICO = 0;
170         startTimePrivatePreICO = 0;
171     }
172 
173     function currentBonusPercent() public constant returns(uint256 bonus_percent) {
174         require(startTimeICO > 0 || startTimePreICO > 0);
175         uint256 current_date = now;
176         uint256 bonusPercent = 0;
177         if (startTimeICO > 0){
178             if (current_date > startTimeICO && current_date <= (startTimeICO.add(1 weeks))){ bonusPercent = ICOBonusPercent1week; }
179             else{
180                 if (current_date > startTimeICO && current_date <= (startTimeICO.add(2 weeks))){ bonusPercent = ICOBonusPercent2week; }
181                 else{
182                     if (current_date > startTimeICO && current_date <= (startTimeICO.add(3 weeks))){ bonusPercent = ICOBonusPercent3week; }
183                 }
184             }
185         }
186         else{
187             if(startTimePrivatePreICO > 0) {
188                 bonusPercent = privatePreICOBonusPercent;
189             }
190             else {
191                 bonusPercent = preICOBonusPercent;
192             }
193         }
194         return bonusPercent;
195     }
196 
197     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
198     function() payable public { 
199         require(startTimeICO > 0 || startTimePreICO > 0);
200         require(msg.sender != address(0));
201         require(msg.value > 0);
202         require(cap < hardCap);
203         uint256 bonusPercent = currentBonusPercent();
204         uint256 currentPrice = price.mul(100 - bonusPercent).div(100);
205         address depositor = msg.sender;
206         uint256 deposit = msg.value;
207         uint256 tokens = deposit/currentPrice;
208         if (startTimeICO > 0){
209             require(soldTokenCount.add(tokens) <= maxPreICOandICOSupply);
210         }
211         else{
212             if(startTimePrivatePreICO > 0) {
213                 tokens = (tokens * (100 + privatePreICOFreeBonusPercent)) / 100;
214             }
215             else {
216                 tokens = (tokens * (100 + preICOFreeBonusPercent)) / 100;
217             }
218             require(soldTokenCount.add(tokens) <= maxPreICOSupply);
219         }
220 
221         balances[owner] = balances[owner].sub(tokens);
222         balances[depositor] = balances[depositor].add(tokens);
223         soldTokenCount = soldTokenCount.add(tokens);
224         if (startTimeICO > 0){
225             ICObalances[depositor] = ICObalances[depositor].add(tokens);
226         }
227 
228         if (startTimeICO > 0){
229             ICOdepositors[depositor] = ICOdepositors[depositor].add(deposit);
230         }
231         else{
232             if(startTimePrivatePreICO > 0) {
233                 privatePreICOdepositors[depositor] = privatePreICOdepositors[depositor].add(deposit);
234             }
235             else {
236                 preICOdepositors[depositor] = preICOdepositors[depositor].add(deposit);
237             }
238         }
239         cap = cap.add(deposit);
240         if(startTimePreICO > 0) {
241             capPreICO = capPreICO.add(deposit);
242         }
243 
244         capFiatAndETH = capFiat.add(cap);
245         if(capFiatAndETH >= softCap) {
246             capReached = true;
247         }
248         TokenPurchase(owner, depositor, deposit, tokens);
249     }
250 
251     event ExtTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 amount);
252     function extBuyTokens(address beneficiary_, uint256 tokensAmount_, uint256 amountETH_) public { 
253         require(startTimeICO > 0 || startTimePreICO > 0);
254         require(msg.sender != address(0));
255         require(msg.sender == extOwner);
256         address depositor = beneficiary_;
257         uint256 tokens = tokensAmount_;
258         uint256 amountETH = amountETH_;
259 
260         balances[owner] = balances[owner].sub(tokens);
261         balances[depositor] = balances[depositor].add(tokens);
262         soldTokenCount = soldTokenCount.add(tokens);
263 
264         capFiat = capFiat.add(amountETH);
265         capFiatAndETH = capFiat.add(cap);
266         if(capFiatAndETH >= softCap) {
267             capReached = true;
268         }
269 
270         ExtTokenPurchase(owner, depositor, tokens);
271     }
272 
273     function transferExtOwnership(address newOwner_) onlyOwner public {
274         extOwner = newOwner_;
275     }
276 
277 // refund
278     bool public refundCompleted = false;
279     uint256 public startTimeRefund = 0;
280 
281     function startRefund() onlyOwner public {
282         require(startTimeICO == 0 && startTimePreICO == 0);
283         startTimeRefund = now;
284         SaleStatus('Refund started', startTimeRefund);
285     }
286 
287     function stopRefund() onlyOwner public {
288         require(startTimeRefund > 0);
289         startTimeRefund = 0;
290         refundCompleted = true;
291         SaleStatus('Refund stopped', now);
292     }
293 
294     event Refunded(address indexed depositor, uint256 indexed deposit, uint256 indexed tokens);
295     function refund() public {
296         require(capFiatAndETH < softCap);
297         require(startTimeRefund > 0);
298         address depositor = msg.sender;
299         uint256 deposit = ICOdepositors[depositor];
300         uint256 tokens = ICObalances[depositor];    
301         ICOdepositors[depositor] = 0;
302         ICObalances[depositor] = 0;
303         balances[depositor] = balances[depositor].sub(tokens);
304         depositor.transfer(deposit);
305         balances[owner] = balances[owner].add(tokens);
306         cap = cap.sub(deposit);
307         capFiatAndETH = capFiatAndETH.sub(deposit);
308         soldTokenCount = soldTokenCount.sub(tokens);
309         Refunded(depositor, deposit, tokens);
310     }
311 
312     bool public fixSaleCompleted = false;
313     function fixSale() onlyOwner public {
314         require(refundCompleted == true);
315         require(startTimeICO == 0 && startTimePreICO == 0 && startTimeRefund == 0);
316         require(multisig != address(0));
317         uint256 restrictedTokens = soldTokenCount * (totalSupply - maxPreICOandICOSupply) / maxPreICOandICOSupply;
318         transfer(multisig, restrictedTokens);
319         multisig.transfer(cap.sub(capPreICOTrasferred));
320         soldTokenCount = 0;
321         fixSaleCompleted = true;
322     }
323 
324 // burnable
325     event Burn(address indexed burner, uint indexed value);
326     function burn(uint _value) onlyOwner public {
327         require(fixSaleCompleted == true);
328         require(_value > 0);
329         address burner = msg.sender;
330         balances[burner] = balances[burner].sub(_value);
331         totalSupply = totalSupply.sub(_value);
332         refundCompleted = false;
333         fixSaleCompleted = false;
334         Burn(burner, _value);
335     }
336 
337 // constructor
338     string constant public name = "FUELD";
339     string constant public symbol = "FLD";
340     uint32 constant public decimals = 18;
341 
342     function FueldToken() public {
343         owner = msg.sender;
344         balances[owner] = totalSupply;
345     }
346 }