1 /*! iam.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
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
100 contract ERC223 is ERC20 {
101     function transfer(address to, uint256 value, bytes data) public returns(bool);
102 }
103 
104 contract ERC223Receiving {
105     function tokenFallback(address from, uint256 value, bytes data) external;
106 }
107 
108 contract StandardToken is ERC223 {
109     using SafeMath for uint256;
110 
111     string public name;
112     string public symbol;
113     uint8 public decimals;
114 
115     mapping(address => uint256) balances;
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
119         name = _name;
120         symbol = _symbol;
121         decimals = _decimals;
122     }
123 
124     function balanceOf(address _owner) public view returns(uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function _transfer(address _to, uint256 _value, bytes _data) private returns(bool) {
129         require(_to != address(0));
130         require(_value <= balances[msg.sender]);
131 
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         
135         bool is_contract = false;
136         assembly {
137             is_contract := not(iszero(extcodesize(_to)))
138         }
139 
140         if(is_contract) {
141             ERC223Receiving receiver = ERC223Receiving(_to);
142             receiver.tokenFallback(msg.sender, _value, _data);
143         }
144 
145         Transfer(msg.sender, _to, _value);
146 
147         return true;
148     }
149 
150     function transfer(address _to, uint256 _value) public returns(bool) {
151         bytes memory empty;
152         return _transfer(_to, _value, empty);
153     }
154 
155     function transfer(address _to, uint256 _value, bytes _data) public returns(bool) {
156         return _transfer(_to, _value, _data);
157     }
158     
159     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
160         require(_to.length == _value.length);
161 
162         for(uint i = 0; i < _to.length; i++) {
163             transfer(_to[i], _value[i]);
164         }
165 
166         return true;
167     }
168 
169     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
170         require(_to != address(0));
171         require(_value <= balances[_from]);
172         require(_value <= allowed[_from][msg.sender]);
173 
174         balances[_from] = balances[_from].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177 
178         Transfer(_from, _to, _value);
179 
180         return true;
181     }
182 
183     function allowance(address _owner, address _spender) public view returns(uint256) {
184         return allowed[_owner][_spender];
185     }
186 
187     function approve(address _spender, uint256 _value) public returns(bool) {
188         allowed[msg.sender][_spender] = _value;
189 
190         Approval(msg.sender, _spender, _value);
191 
192         return true;
193     }
194 
195     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
196         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197 
198         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199 
200         return true;
201     }
202 
203     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
204         uint oldValue = allowed[msg.sender][_spender];
205 
206         if(_subtractedValue > oldValue) {
207             allowed[msg.sender][_spender] = 0;
208         } else {
209             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210         }
211 
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213 
214         return true;
215     }
216 }
217 
218 contract MintableToken is StandardToken, Ownable {
219     event Mint(address indexed to, uint256 amount);
220     event MintFinished();
221 
222     bool public mintingFinished = false;
223 
224     modifier canMint() { require(!mintingFinished); _; }
225 
226     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
227         totalSupply = totalSupply.add(_amount);
228         balances[_to] = balances[_to].add(_amount);
229 
230         Mint(_to, _amount);
231         Transfer(address(0), _to, _amount);
232 
233         return true;
234     }
235 
236     function finishMinting() onlyOwner canMint public returns(bool) {
237         mintingFinished = true;
238 
239         MintFinished();
240 
241         return true;
242     }
243 }
244 
245 contract CappedToken is MintableToken {
246     uint256 public cap;
247 
248     function CappedToken(uint256 _cap) public {
249         require(_cap > 0);
250         cap = _cap;
251     }
252 
253     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
254         require(totalSupply.add(_amount) <= cap);
255 
256         return super.mint(_to, _amount);
257     }
258 }
259 
260 contract BurnableToken is StandardToken {
261     event Burn(address indexed burner, uint256 value);
262 
263     function burn(uint256 _value) public {
264         require(_value <= balances[msg.sender]);
265 
266         address burner = msg.sender;
267 
268         balances[burner] = balances[burner].sub(_value);
269         totalSupply = totalSupply.sub(_value);
270 
271         Burn(burner, _value);
272     }
273 }
274 
275 /*
276     ICO IAM
277 */
278 contract Token is CappedToken, BurnableToken, Withdrawable {
279     function Token() CappedToken(70000000 * 1 ether) StandardToken("IAM Aero", "IAM", 18) public {
280         
281     }
282 
283     function tokenFallback(address _from, uint256 _value, bytes _data) external {
284         require(false);
285     }
286 }
287 
288 contract Crowdsale is Pausable, Withdrawable, ERC223Receiving {
289     using SafeMath for uint;
290 
291     struct Step {
292         uint priceTokenWei;
293         uint tokensForSale;
294         uint minInvestEth;
295         uint tokensSold;
296         uint collectedWei;
297 
298         bool transferBalance;
299         bool sale;
300     }
301 
302     Token public token;
303     address public beneficiary = 0x4ae7bdf9530cdB666FC14DF79C169e14504c621A;
304 
305     Step[] public steps;
306     uint8 public currentStep = 0;
307 
308     bool public crowdsaleClosed = false;
309 
310     mapping(address => uint256) public canSell;
311 
312     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
313     event Sell(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
314     event NewRate(uint256 rate);
315     event NextStep(uint8 step);
316     event CrowdsaleClose();
317 
318     function Crowdsale() public {
319         token = new Token();
320 
321         steps.push(Step(1 ether / 1000, 1000000 * 1 ether, 2 ether, 0, 0, true, false));
322         steps.push(Step(1 ether / 1000, 1500000 * 1 ether, 1 ether, 0, 0, true, false));
323         steps.push(Step(1 ether / 1000, 3000000 * 1 ether, 0.5 ether, 0, 0, true, false));
324         steps.push(Step(1 ether / 1000, 9000000 * 1 ether, 0.25 ether, 0, 0, true, false));
325         steps.push(Step(1 ether / 1000, 35000000 * 1 ether, 0.1 ether, 0, 0, true, false));
326         steps.push(Step(1 ether / 1000, 20500000 * 1 ether, 0.01 ether, 0, 0, true, true));
327     }
328 
329     function() payable public {
330         purchase();
331     }
332 
333     function tokenFallback(address _from, uint256 _value, bytes _data) external {
334         sell(_value);
335     }
336 
337     function setTokenRate(uint _value) onlyOwner public {
338         require(!crowdsaleClosed);
339 
340         steps[currentStep].priceTokenWei = 1 ether / _value;
341 
342         NewRate(steps[currentStep].priceTokenWei);
343     }
344     
345     function purchase() whenNotPaused payable public {
346         require(!crowdsaleClosed);
347 
348         Step memory step = steps[currentStep];
349 
350         require(msg.value >= step.minInvestEth);
351         require(step.tokensSold < step.tokensForSale);
352 
353         uint sum = msg.value;
354         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
355         uint retSum = 0;
356         
357         if(step.tokensSold.add(amount) > step.tokensForSale) {
358             uint retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
359             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
360 
361             amount = amount.sub(retAmount);
362             sum = sum.sub(retSum);
363         }
364 
365         steps[currentStep].tokensSold = step.tokensSold.add(amount);
366         steps[currentStep].collectedWei = step.collectedWei.add(sum);
367 
368         if(currentStep == 0) {
369             canSell[msg.sender] = canSell[msg.sender].add(amount);
370         }
371 
372         if(step.transferBalance) {
373             uint p1 = sum.div(200);
374             (0x27c1D3ECD24C13C6b5362dA1136215fa929de010).transfer(p1.mul(3));
375             (0x8C8d80effb2c5C1E4D857e286822E0E641cA3836).transfer(p1.mul(3));
376             beneficiary.transfer(sum.sub(p1.mul(6)));
377         }
378         token.mint(msg.sender, amount);
379 
380         if(retSum > 0) {
381             msg.sender.transfer(retSum);
382         }
383 
384         Purchase(msg.sender, amount, sum);
385     }
386 
387     function sell(uint256 _value) whenNotPaused public {
388         require(!crowdsaleClosed);
389 
390         require(canSell[msg.sender] >= _value);
391         require(token.balanceOf(msg.sender) >= _value);
392 
393         Step memory step = steps[currentStep];
394         
395         require(step.sale);
396 
397         canSell[msg.sender] = canSell[msg.sender].sub(_value);
398         token.call('transfer', beneficiary, _value);
399 
400         uint sum = _value.mul(step.priceTokenWei).div(1 ether);
401 
402         msg.sender.transfer(sum);
403 
404         Sell(msg.sender, _value, sum);
405     }
406 
407     function nextStep(uint _value) onlyOwner public {
408         require(!crowdsaleClosed);
409         require(steps.length - 1 > currentStep);
410         
411         currentStep += 1;
412 
413         setTokenRate(_value);
414 
415         NextStep(currentStep);
416     }
417 
418     function closeCrowdsale() onlyOwner public {
419         require(!crowdsaleClosed);
420         
421         beneficiary.transfer(this.balance);
422         token.mint(beneficiary, token.cap().sub(token.totalSupply()));
423         token.transferOwnership(beneficiary);
424 
425         crowdsaleClosed = true;
426 
427         CrowdsaleClose();
428     }
429 }