1 /*! vlp.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.18;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _; }
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         owner = newOwner;
46         OwnershipTransferred(owner, newOwner);
47     }
48 }
49 
50 contract Pausable is Ownable {
51     bool public paused = false;
52 
53     event Pause();
54     event Unpause();
55 
56     modifier whenNotPaused() { require(!paused); _; }
57     modifier whenPaused() { require(paused); _; }
58 
59     function pause() onlyOwner whenNotPaused public {
60         paused = true;
61         Pause();
62     }
63 
64     function unpause() onlyOwner whenPaused public {
65         paused = false;
66         Unpause();
67     }
68 }
69 
70 contract Withdrawable is Ownable {
71     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
72         require(_to != address(0));
73         require(this.balance >= _value);
74 
75         _to.transfer(_value);
76 
77         return true;
78     }
79 
80     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
81         require(_to != address(0));
82 
83         return _token.transfer(_to, _value);
84     }
85 }
86 
87 contract ERC20 {
88     uint256 public totalSupply;
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 
93     function balanceOf(address who) public view returns(uint256);
94     function transfer(address to, uint256 value) public returns(bool);
95     function transferFrom(address from, address to, uint256 value) public returns(bool);
96     function allowance(address owner, address spender) public view returns(uint256);
97     function approve(address spender, uint256 value) public returns(bool);
98 }
99 
100 contract StandardToken is ERC20 {
101     using SafeMath for uint256;
102 
103     string public name;
104     string public symbol;
105     uint8 public decimals;
106 
107     mapping(address => uint256) balances;
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
111         name = _name;
112         symbol = _symbol;
113         decimals = _decimals;
114     }
115 
116     function balanceOf(address _owner) public view returns(uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function transfer(address _to, uint256 _value) public returns(bool) {
121         require(_to != address(0));
122         require(_value <= balances[msg.sender]);
123 
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126 
127         Transfer(msg.sender, _to, _value);
128 
129         return true;
130     }
131     
132     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
133         require(_to.length == _value.length);
134 
135         for(uint i = 0; i < _to.length; i++) {
136             transfer(_to[i], _value[i]);
137         }
138 
139         return true;
140     }
141 
142     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
143         require(_to != address(0));
144         require(_value <= balances[_from]);
145         require(_value <= allowed[_from][msg.sender]);
146 
147         balances[_from] = balances[_from].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150 
151         Transfer(_from, _to, _value);
152 
153         return true;
154     }
155 
156     function allowance(address _owner, address _spender) public view returns(uint256) {
157         return allowed[_owner][_spender];
158     }
159 
160     function approve(address _spender, uint256 _value) public returns(bool) {
161         allowed[msg.sender][_spender] = _value;
162 
163         Approval(msg.sender, _spender, _value);
164 
165         return true;
166     }
167 
168     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170 
171         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172 
173         return true;
174     }
175 
176     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
177         uint oldValue = allowed[msg.sender][_spender];
178 
179         if(_subtractedValue > oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184 
185         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186 
187         return true;
188     }
189 }
190 
191 contract MintableToken is StandardToken, Ownable {
192     event Mint(address indexed to, uint256 amount);
193     event MintFinished();
194 
195     bool public mintingFinished = false;
196 
197     modifier canMint() { require(!mintingFinished); _; }
198 
199     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
200         totalSupply = totalSupply.add(_amount);
201         balances[_to] = balances[_to].add(_amount);
202 
203         Mint(_to, _amount);
204         Transfer(address(0), _to, _amount);
205 
206         return true;
207     }
208 
209     function finishMinting() onlyOwner canMint public returns(bool) {
210         mintingFinished = true;
211 
212         MintFinished();
213 
214         return true;
215     }
216 }
217 
218 contract CappedToken is MintableToken {
219     uint256 public cap;
220 
221     function CappedToken(uint256 _cap) public {
222         require(_cap > 0);
223         cap = _cap;
224     }
225 
226     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
227         require(totalSupply.add(_amount) <= cap);
228 
229         return super.mint(_to, _amount);
230     }
231 }
232 
233 contract BurnableToken is StandardToken {
234     event Burn(address indexed burner, uint256 value);
235 
236     function burn(uint256 _value) public {
237         require(_value <= balances[msg.sender]);
238 
239         address burner = msg.sender;
240 
241         balances[burner] = balances[burner].sub(_value);
242         totalSupply = totalSupply.sub(_value);
243 
244         Burn(burner, _value);
245     }
246 }
247 
248 /*
249     ICO Velper
250 */
251 contract Token is BurnableToken, CappedToken, Withdrawable {
252     function Token() CappedToken(1000000000 ether) StandardToken("Velper", "VLP", 18) public {
253         
254     }
255 
256     function transferOwner(address _from, address _to, uint256 _value) onlyOwner canMint public returns(bool) {
257         require(_to != address(0));
258         require(_value <= balances[_from]);
259 
260         balances[_from] = balances[_from].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262 
263         Transfer(_from, _to, _value);
264 
265         return true;
266     }
267 }
268 
269 contract Crowdsale is Withdrawable, Pausable {
270     using SafeMath for uint;
271 
272     struct Step {
273         uint priceTokenWei;
274         uint tokensForSale;
275         uint8[5] salesPercent;
276         uint bonusAmount;
277         uint bonusPercent;
278         uint tokensSold;
279         uint collectedWei;
280     }
281 
282     Token public token;
283     address public beneficiary = 0xe57AB27CA8b87a4e249EbeF7c4BdB17D5Ba2832b;
284     address public manager = 0xc5195F2Ee6FF2a9164272F62177e52fBCEF37C04;
285 
286     Step[] public steps;
287     uint8 public currentStep = 0;
288 
289     bool public crowdsaleClosed = false;
290 
291     mapping(address => mapping(uint8 => mapping(uint8 => uint256))) public canSell;
292 
293     event NewRate(uint256 rate);
294     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
295     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
296     event NextStep(uint8 step);
297     event CrowdsaleClose();
298 
299     function Crowdsale() public { }
300     
301     function init(address _token) {
302         token = Token(_token);
303 
304         token.mint(manager, 150000000 ether);                                    // 15%
305         token.mint(0x2c2ab894738F3b9026404cBeF2BBc2A896811a2C, 150000000 ether); // 15%
306         token.mint(0xc9DE5d617cfdfD7fd1F75AB012Bf711A44745fdF, 100000000 ether); // 10%
307         token.mint(0x7aF1e2F03086dcA69E821F51158cF2c0F899Fa6e, 50000000 ether); // 5%
308         token.mint(0xFa8d5d96E06d969306CCb76610dA20040656A27B, 30000000 ether); // 3%
309         token.mint(0x9a724eC84Ea194A33c91af37Edc6026BCB61CF21, 20000000 ether); // 5%
310 
311         steps.push(Step(100 szabo, 75000000 ether, [0, 20, 20, 15, 10], 100000 ether, 15, 0, 0));   // 7.5%
312         steps.push(Step(200 szabo, 100000000 ether, [0, 0, 20, 20, 20], 100000 ether, 15, 0, 0));   // 10%
313         steps.push(Step(400 szabo, 100000000 ether, [0, 0, 0, 20, 20], 100000 ether, 15, 0, 0));   // 10%
314         steps.push(Step(800 szabo, 100000000 ether, [0, 0, 0, 0, 35], 100000 ether, 15, 0, 0));   // 10%
315         steps.push(Step(2 finney, 125000000 ether, [0, 0, 0, 0, 0], 50000 ether, 10, 0, 0));   // 12.5%
316     }
317 
318     function() payable public {
319         purchase();
320     }
321 
322     function setTokenRate(uint _value) onlyOwner public {
323         require(!crowdsaleClosed);
324 
325         steps[currentStep].priceTokenWei = 1 ether / _value;
326 
327         NewRate(steps[currentStep].priceTokenWei);
328     }
329     
330     function purchase() whenNotPaused payable public {
331         require(!crowdsaleClosed);
332         require(msg.value >= 10 szabo);
333 
334         Step memory step = steps[currentStep];
335 
336         require(step.tokensSold < step.tokensForSale);
337 
338         uint sum = msg.value;
339         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
340         uint retSum = 0;
341 
342         if(amount > step.bonusAmount && step.tokensSold.add(amount) < step.tokensForSale) {
343             uint bonusAmount = amount.div(100).mul(step.bonusPercent);
344             if(step.tokensSold.add(amount).add(bonusAmount) >= step.tokensForSale) {
345                 bonusAmount = step.tokensForSale.sub(step.tokensSold.add(amount));
346             }
347             amount = amount.add(bonusAmount);
348         }
349         
350         if(step.tokensSold.add(amount) > step.tokensForSale) {
351             uint retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
352             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
353 
354             amount = amount.sub(retAmount);
355             sum = sum.sub(retSum);
356         }
357 
358         steps[currentStep].tokensSold = step.tokensSold.add(amount);
359         steps[currentStep].collectedWei = step.collectedWei.add(sum);
360 
361         token.mint(msg.sender, amount);
362 
363         for(uint8 i = 0; i < step.salesPercent.length; i++) {
364             canSell[msg.sender][currentStep][i] = canSell[msg.sender][currentStep][i].add(amount.div(100).mul(step.salesPercent[i]));
365         }
366 
367         if(retSum > 0) {
368             msg.sender.transfer(retSum);
369         }
370 
371         Purchase(msg.sender, amount, sum);
372     }
373 
374     /// @dev Salling: new Crowdsale()(0,4700000); new $0.token.Token(); $0.purchase()(100)[1]; $0.nextStep(); $0.sell(100000000000000000000000)[1]; $1.balanceOf(@1) == 1.05e+24
375     function sell(uint256 _value) whenNotPaused public {
376         require(!crowdsaleClosed);
377         require(currentStep > 0);
378 
379         require(canSell[msg.sender][currentStep - 1][currentStep] >= _value);
380         require(token.balanceOf(msg.sender) >= _value);
381 
382         canSell[msg.sender][currentStep - 1][currentStep] = canSell[msg.sender][currentStep - 1][currentStep].sub(_value);
383         token.transferOwner(msg.sender, beneficiary, _value);
384 
385         uint sum = _value.mul(steps[currentStep].priceTokenWei).div(1 ether);
386         msg.sender.transfer(sum);
387 
388         Sell(msg.sender, _value, sum);
389     }
390 
391     function nextStep() onlyOwner public {
392         require(!crowdsaleClosed);
393         require(steps.length - 1 > currentStep);
394         
395         currentStep += 1;
396 
397         NextStep(currentStep);
398     }
399 
400     function closeCrowdsale() onlyOwner public {
401         require(!crowdsaleClosed);
402         
403         beneficiary.transfer(this.balance);
404         token.mint(beneficiary, token.cap() - token.totalSupply());
405         token.finishMinting();
406         token.transferOwnership(beneficiary);
407 
408         crowdsaleClosed = true;
409 
410         CrowdsaleClose();
411     }
412 
413     /// @dev ManagerTransfer: new Crowdsale()(0,4700000); new $0.token.Token(); $0.purchase()(1000)[2]; $0.managerTransfer(@1,100000000000000000000000)[5]; $0.nextStep(); $0.sell(20000000000000000000000)[1]; $1.balanceOf(@1) == 8e+22
414     function managerTransfer(address _to, uint256 _value) public {
415         require(msg.sender == manager);
416 
417         for(uint8 i = 0; i < steps[currentStep].salesPercent.length; i++) {
418             canSell[_to][currentStep][i] = canSell[_to][currentStep][i].add(_value.div(100).mul(steps[currentStep].salesPercent[i]));
419         }
420         
421         token.transferOwner(msg.sender, _to, _value);
422     }
423 }