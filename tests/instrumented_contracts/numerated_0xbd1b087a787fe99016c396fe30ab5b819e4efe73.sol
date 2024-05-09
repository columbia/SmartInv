1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4     
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract Ownable {
29     
30     address public owner;
31 
32     function Ownable() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 }
41 
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) constant public returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) constant public returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public  returns (bool);
52     function approve(address spender, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 contract BasicToken is ERC20Basic, Ownable {
57 
58     using SafeMath for uint256;
59 
60     mapping (address => uint256) balances;
61 
62     modifier onlyPayloadSize(uint size) {
63         if (msg.data.length < size + 4) {
64             revert();
65         }
66         _;
67     }
68 
69     function transfer(address _to, uint256 _amount) public onlyPayloadSize(2 * 32) returns (bool) {
70         require(balances[msg.sender] >= _amount);
71         balances[msg.sender] = balances[msg.sender].sub(_amount);
72         balances[_to] = balances[_to].add(_amount);
73         Transfer(msg.sender, _to, _amount);
74         return true;
75     }
76 
77     function balanceOf(address _addr) public constant returns (uint256) {
78         return balances[_addr];
79     }
80 }
81 
82 contract AdvancedToken is BasicToken, ERC20 {
83 
84     mapping (address => mapping (address => uint256)) allowances;
85 
86     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) returns (bool) {
87         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
88         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
89         balances[_from] = balances[_from].sub(_amount);
90         balances[_to] = balances[_to].add(_amount);
91         Transfer(_from, _to, _amount);
92         return true;
93     }
94 
95     function approve(address _spender, uint256 _amount) public returns (bool) {
96         allowances[msg.sender][_spender] = _amount;
97         Approval(msg.sender, _spender, _amount);
98         return true;
99     }
100 
101     function increaseApproval(address _spender, uint256 _amount) public returns (bool) {
102         allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_amount);
103         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
104         return true;
105     }
106 
107     function decreaseApproval(address _spender, uint256 _amount) public returns (bool) {
108         require(allowances[msg.sender][_spender] != 0);
109         if (_amount >= allowances[msg.sender][_spender]) {
110             allowances[msg.sender][_spender] = 0;
111         } else {
112             allowances[msg.sender][_spender] = allowances[msg.sender][_spender].sub(_amount);
113             Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
114         }
115     }
116 
117     function allowance(address _owner, address _spender) public constant returns (uint256) {
118         return allowances[_owner][_spender];
119     }
120 
121 }
122 
123 contract MintableToken is AdvancedToken {
124 
125     bool public mintingFinished;
126 
127     event TokensMinted(address indexed to, uint256 amount);
128     event MintingFinished();
129 
130     function mint(address _to, uint256 _amount) external onlyOwner onlyPayloadSize(2 * 32) returns (bool) {
131         require(_to != 0x0 && _amount > 0 && !mintingFinished);
132         balances[_to] = balances[_to].add(_amount);
133         totalSupply = totalSupply.add(_amount);
134         Transfer(0x0, _to, _amount);
135         TokensMinted(_to, _amount);
136         return true;
137     }
138 
139     function finishMinting() external onlyOwner {
140         require(!mintingFinished);
141         mintingFinished = true;
142         MintingFinished();
143     }
144 
145     function mintingFinished() public constant returns (bool) {
146         return mintingFinished;
147     }
148 }
149 
150 contract ACO is MintableToken {
151 
152     uint8 public decimals;
153     string public name;
154     string public symbol;
155 
156     function ACO() public {
157         totalSupply = 0;
158         decimals = 18;
159         name = "ACO";
160         symbol = "ACO";
161     }
162 }
163 
164 contract MultiOwnable {
165     
166     address[2] public owners;
167 
168     event OwnershipTransferred(address from, address to);
169     event OwnershipGranted(address to);
170 
171     function MultiOwnable() public {
172         owners[0] = 0x1d554c421182a94E2f4cBD833f24682BBe1eeFe8; 
173         owners[1] = 0x0D7a2716466332Fc5a256FF0d20555A44c099453; 
174     }
175 
176     modifier onlyOwners {
177         require(msg.sender == owners[0] || msg.sender == owners[1]);
178         _;
179     }
180 
181     function transferOwnership(address _newOwner) public onlyOwners {
182         require(_newOwner != 0x0 && _newOwner != owners[0] && _newOwner != owners[1]);
183         if (msg.sender == owners[0]) {
184             OwnershipTransferred(owners[0], _newOwner);
185             owners[0] = _newOwner;
186         } else {
187             OwnershipTransferred(owners[1], _newOwner);
188             owners[1] = _newOwner;
189         }
190     }
191 }
192 
193 contract Crowdsale is Ownable, MultiOwnable {
194 
195     using SafeMath for uint256;
196 
197     ACO public ACO_Token;
198 
199     address public constant MULTI_SIG = 0x3Ee28dA5eFe653402C5192054064F12a42EA709e;
200 
201     uint256 public rate;
202 
203     uint256 public tokensSold;
204     uint256 public startTime;
205     uint256 public endTime;
206     uint256 public softCap;
207     uint256 public hardCap;
208 
209     uint256[4] public bonusStages;
210 
211     mapping (address => uint256) investments;
212     mapping (address => bool) hasAuthorizedWithdrawal;
213 
214     event TokensPurchased(address indexed by, uint256 amount);
215     event RefundIssued(address indexed by, uint256 amount);
216     event FundsWithdrawn(address indexed by, uint256 amount);
217     event DurationAltered(uint256 newEndTime);
218     event NewSoftCap(uint256 newSoftCap);
219     event NewHardCap(uint256 newHardCap);
220     event NewRateSet(uint256 newRate);
221     event HardCapReached();
222     event SoftCapReached();
223 
224     function Crowdsale() public {
225         ACO_Token = new ACO();
226         softCap = 0; 
227         hardCap = 250000000e18; 
228         rate = 4000;
229         startTime = now;
230         endTime = startTime.add(365 days);
231         bonusStages[0] = startTime.add(6 weeks);
232 
233         for(uint i = 1; i < bonusStages.length; i++) {
234             bonusStages[i] = bonusStages[i - 1].add(6 weeks);
235         }
236     }
237 
238     function processOffchainPayment(address _beneficiary, uint256 _toMint) public onlyOwners {
239         require(_beneficiary != 0x0 && now <= endTime && tokensSold.add(_toMint) <= hardCap && _toMint > 0);
240         if(tokensSold.add(_toMint) == hardCap) { HardCapReached(); }
241         if(tokensSold.add(_toMint) >= softCap && !isSuccess()) { SoftCapReached(); }
242         ACO_Token.mint(_beneficiary, _toMint);
243         tokensSold = tokensSold.add(_toMint);
244         TokensPurchased(_beneficiary, _toMint);
245     }
246 
247     function() public payable {
248         buyTokens(msg.sender);
249     }
250 
251     function buyTokens(address _beneficiary) public payable {
252         require(_beneficiary != 0x0 && validPurchase() && tokensSold.add(calculateTokensToMint()) <= hardCap); 
253         if(tokensSold.add(calculateTokensToMint()) == hardCap) { HardCapReached(); }
254         if(tokensSold.add(calculateTokensToMint()) >= softCap && !isSuccess()) { SoftCapReached(); }
255         uint256 toMint = calculateTokensToMint();
256         ACO_Token.mint(_beneficiary, toMint);
257         tokensSold = tokensSold.add(toMint);
258         investments[_beneficiary] = investments[_beneficiary].add(msg.value);
259         TokensPurchased(_beneficiary, toMint); 
260     }
261 
262     function calculateTokensToMint() internal view returns(uint256 toMint) {
263         toMint = msg.value.mul(getCurrentRateWithBonus());
264     }
265 
266     function getCurrentRateWithBonus() public view returns (uint256 rateWithBonus) {
267         rateWithBonus = (rate.mul(getBonusPercentage()).div(100)).add(rate);
268     }
269 
270     function getBonusPercentage() internal view returns (uint256 bonusPercentage) {
271         uint256 timeStamp = now;
272         if (timeStamp > bonusStages[3]) {
273             bonusPercentage = 0;
274         } else { 
275             bonusPercentage = 25;
276             for (uint i = 0; i < bonusStages.length; i++) {
277                 if (timeStamp <= bonusStages[i]) {
278                     break;
279                 } else {
280                     bonusPercentage = bonusPercentage.sub(5);
281                 }
282             }
283         }
284         return bonusPercentage;
285     }
286 
287     function authorizeWithdrawal() public onlyOwners {
288         require(hasEnded() && isSuccess() && !hasAuthorizedWithdrawal[msg.sender]);
289         hasAuthorizedWithdrawal[msg.sender] = true;
290         if (hasAuthorizedWithdrawal[owners[0]] && hasAuthorizedWithdrawal[owners[1]]) {
291             FundsWithdrawn(owners[0], this.balance);
292             MULTI_SIG.transfer(this.balance);
293         }
294     }
295 
296     function issueBounty(address _to, uint256 _toMint) public onlyOwners {
297         require(_to != 0x0 && _toMint > 0 && tokensSold.add(_toMint) <= hardCap);
298         ACO_Token.mint(_to, _toMint);
299         tokensSold = tokensSold.add(_toMint);
300     }
301 
302     function finishMinting() public onlyOwners {
303         require(hasEnded());
304         ACO_Token.finishMinting();
305     }
306 
307     function getRefund(address _addr) public {
308         if(_addr == 0x0) { _addr = msg.sender; }
309         require(!isSuccess() && hasEnded() && investments[_addr] > 0);
310         uint256 toRefund = investments[_addr];
311         investments[_addr] = 0;
312         _addr.transfer(toRefund);
313         RefundIssued(_addr, toRefund);
314     }
315     
316     function giveRefund(address _addr) public onlyOwner {
317         require(_addr != 0x0 && investments[_addr] > 0);
318         uint256 toRefund = investments[_addr];
319         investments[_addr] = 0;
320         _addr.transfer(toRefund);
321         RefundIssued(_addr, toRefund);
322     }
323 
324     function isSuccess() public view returns(bool success) {
325         success = tokensSold >= softCap;
326     }
327 
328     function hasEnded() public view returns(bool ended) {
329         ended = now > endTime;
330     }
331 
332     function investmentOf(address _addr) public view returns(uint256 investment) {
333         investment = investments[_addr];
334     }
335 
336     function validPurchase() internal constant returns (bool) {
337         bool withinPeriod = now >= startTime && now <= endTime;
338         bool nonZeroPurchase = msg.value != 0;
339         return withinPeriod && nonZeroPurchase;
340     }
341 
342     function setEndTime(uint256 _numberOfDays) public onlyOwners {
343         require(_numberOfDays > 0);
344         endTime = now.add(_numberOfDays * 1 days);
345         DurationAltered(endTime);
346     }
347 
348     function changeSoftCap(uint256 _newSoftCap) public onlyOwners {
349         require(_newSoftCap > 0);
350         softCap = _newSoftCap;
351         NewSoftCap(softCap);
352     }
353 
354     function changeHardCap(uint256 _newHardCap) public onlyOwners {
355         assert(_newHardCap > 0);
356         hardCap = _newHardCap;
357         NewHardCap(hardCap);
358     }
359 
360     function changeRate(uint256 _newRate) public onlyOwners {
361         require(_newRate > 0);
362         rate = _newRate;
363         NewRateSet(rate);
364     }
365 }