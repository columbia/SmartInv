1 /*! iam.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.21;
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
50 contract Withdrawable is Ownable {
51     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
52         require(_to != address(0));
53         require(this.balance >= _value);
54 
55         _to.transfer(_value);
56 
57         return true;
58     }
59 
60     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
61         require(_to != address(0));
62 
63         return _token.transfer(_to, _value);
64     }
65 }
66 
67 contract Pausable is Ownable {
68     bool public paused = false;
69 
70     event Pause();
71     event Unpause();
72 
73     modifier whenNotPaused() { require(!paused); _; }
74     modifier whenPaused() { require(paused); _; }
75 
76     function pause() onlyOwner whenNotPaused public {
77         paused = true;
78         Pause();
79     }
80 
81     function unpause() onlyOwner whenPaused public {
82         paused = false;
83         Unpause();
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
249     ICO IAM
250 */
251 contract Token is CappedToken, BurnableToken, Withdrawable {
252     function Token() CappedToken(70000000 * 1 ether) StandardToken("IAM Aero", "IAM", 18) public {
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
269 contract Crowdsale is Pausable, Withdrawable {
270     using SafeMath for uint;
271 
272     struct Step {
273         uint priceTokenWei;
274         uint tokensForSale;
275         uint minInvestEth;
276         uint tokensSold;
277         uint collectedWei;
278 
279         bool transferBalance;
280         bool sale;
281         bool issue;
282     }
283 
284     Token public token;
285     address public beneficiary = 0x4ae7bdf9530cdB666FC14DF79C169e14504c621A;
286 
287     Step[] public steps;
288     uint8 public currentStep = 0;
289 
290     bool public crowdsaleClosed = false;
291 
292     mapping(address => uint256) public canSell;
293 
294     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
295     event Issue(address indexed holder, uint256 tokenAmount);
296     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
297     event NewRate(uint256 rate);
298     event NextStep(uint8 step);
299     event CrowdsaleClose();
300 
301     function Crowdsale() public {
302         token = new Token();
303 
304         steps.push(Step(1 ether / 1000, 1000000 * 1 ether, 0.01 ether, 0, 0, true, false, true));
305         steps.push(Step(1 ether / 1000, 1500000 * 1 ether, 0.01 ether, 0, 0, true, false, true));
306         steps.push(Step(1 ether / 1000, 3000000 * 1 ether, 0.01 ether, 0, 0, true, false, true));
307         steps.push(Step(1 ether / 1000, 9000000 * 1 ether, 0.01 ether, 0, 0, true, false, true));
308         steps.push(Step(1 ether / 1000, 35000000 * 1 ether, 0.01 ether, 0, 0, true, false, true));
309         steps.push(Step(1 ether / 1000, 20500000 * 1 ether, 0.01 ether, 0, 0, true, true, true));
310     }
311 
312     function() payable public {
313         purchase();
314     }
315 
316     function setTokenRate(uint _value) onlyOwner public {
317         require(!crowdsaleClosed);
318 
319         steps[currentStep].priceTokenWei = 1 ether / _value;
320 
321         NewRate(steps[currentStep].priceTokenWei);
322     }
323     
324     function purchase() whenNotPaused payable public {
325         require(!crowdsaleClosed);
326 
327         Step memory step = steps[currentStep];
328 
329         require(msg.value >= step.minInvestEth);
330         require(step.tokensSold < step.tokensForSale);
331 
332         uint sum = msg.value;
333         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
334         uint retSum = 0;
335         
336         if(step.tokensSold.add(amount) > step.tokensForSale) {
337             uint retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
338             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
339 
340             amount = amount.sub(retAmount);
341             sum = sum.sub(retSum);
342         }
343 
344         steps[currentStep].tokensSold = step.tokensSold.add(amount);
345         steps[currentStep].collectedWei = step.collectedWei.add(sum);
346 
347         if(currentStep == 0) {
348             canSell[msg.sender] = canSell[msg.sender].add(amount);
349         }
350 
351         if(step.transferBalance) {
352             uint p1 = sum.div(200);
353             (0xD8C7f2215f90463c158E91b92D81f0A1E3187C1B).transfer(p1.mul(3));
354             (0x8C8d80effb2c5C1E4D857e286822E0E641cA3836).transfer(p1.mul(3));
355             beneficiary.transfer(sum.sub(p1.mul(6)));
356         }
357         token.mint(msg.sender, amount);
358 
359         if(retSum > 0) {
360             msg.sender.transfer(retSum);
361         }
362 
363         Purchase(msg.sender, amount, sum);
364     }
365     
366     function issue(address _to, uint256 _value) onlyOwner whenNotPaused public {
367         require(!crowdsaleClosed);
368 
369         Step memory step = steps[currentStep];
370         
371         require(step.issue);
372         require(step.tokensSold.add(_value) <= step.tokensForSale);
373 
374         steps[currentStep].tokensSold = step.tokensSold.add(_value);
375 
376         if(currentStep == 0) {
377             canSell[_to] = canSell[_to].add(_value);
378         }
379 
380         token.mint(_to, _value);
381 
382         Issue(_to, _value);
383     }
384 
385     function sell(uint256 _value) whenNotPaused public {
386         require(!crowdsaleClosed);
387 
388         require(canSell[msg.sender] >= _value);
389         require(token.balanceOf(msg.sender) >= _value);
390 
391         Step memory step = steps[currentStep];
392         
393         require(step.sale);
394 
395         canSell[msg.sender] = canSell[msg.sender].sub(_value);
396         token.transferOwner(msg.sender, beneficiary, _value);
397 
398         uint sum = _value.mul(step.priceTokenWei).div(1 ether);
399 
400         msg.sender.transfer(sum);
401 
402         Sell(msg.sender, _value, sum);
403     }
404 
405     function nextStep(uint _value) onlyOwner public {
406         require(!crowdsaleClosed);
407         require(steps.length - 1 > currentStep);
408         
409         currentStep += 1;
410 
411         setTokenRate(_value);
412 
413         NextStep(currentStep);
414     }
415 
416     function closeCrowdsale() onlyOwner public {
417         require(!crowdsaleClosed);
418         
419         beneficiary.transfer(this.balance);
420         token.mint(beneficiary, token.cap().sub(token.totalSupply()));
421         token.finishMinting();
422         token.transferOwnership(beneficiary);
423 
424         crowdsaleClosed = true;
425 
426         CrowdsaleClose();
427     }
428 }