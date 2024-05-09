1 /*! mlmc.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
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
70 contract ERC20 {
71     uint256 public totalSupply;
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 
76     function balanceOf(address who) public view returns(uint256);
77     function transfer(address to, uint256 value) public returns(bool);
78     function transferFrom(address from, address to, uint256 value) public returns(bool);
79     function allowance(address owner, address spender) public view returns(uint256);
80     function approve(address spender, uint256 value) public returns(bool);
81 }
82 
83 contract StandardToken is ERC20 {
84     using SafeMath for uint256;
85 
86     string public name;
87     string public symbol;
88     uint8 public decimals;
89 
90     mapping(address => uint256) balances;
91     mapping (address => mapping (address => uint256)) internal allowed;
92 
93     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
94         name = _name;
95         symbol = _symbol;
96         decimals = _decimals;
97     }
98 
99     function balanceOf(address _owner) public view returns(uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function transfer(address _to, uint256 _value) public returns(bool) {
104         require(_to != address(0));
105         require(_value <= balances[msg.sender]);
106 
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109 
110         Transfer(msg.sender, _to, _value);
111 
112         return true;
113     }
114     
115     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
116         require(_to.length == _value.length);
117 
118         for(uint i = 0; i < _to.length; i++) {
119             transfer(_to[i], _value[i]);
120         }
121 
122         return true;
123     }
124 
125     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133 
134         Transfer(_from, _to, _value);
135 
136         return true;
137     }
138 
139     function allowance(address _owner, address _spender) public view returns(uint256) {
140         return allowed[_owner][_spender];
141     }
142 
143     function approve(address _spender, uint256 _value) public returns(bool) {
144         allowed[msg.sender][_spender] = _value;
145 
146         Approval(msg.sender, _spender, _value);
147 
148         return true;
149     }
150 
151     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
152         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153 
154         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155 
156         return true;
157     }
158 
159     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
160         uint oldValue = allowed[msg.sender][_spender];
161 
162         if(_subtractedValue > oldValue) {
163             allowed[msg.sender][_spender] = 0;
164         } else {
165             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166         }
167 
168         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169 
170         return true;
171     }
172 }
173 
174 contract MintableToken is StandardToken, Ownable {
175     event Mint(address indexed to, uint256 amount);
176     event MintFinished();
177 
178     bool public mintingFinished = false;
179 
180     modifier canMint() { require(!mintingFinished); _; }
181 
182     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
183         totalSupply = totalSupply.add(_amount);
184         balances[_to] = balances[_to].add(_amount);
185 
186         Mint(_to, _amount);
187         Transfer(address(0), _to, _amount);
188 
189         return true;
190     }
191 
192     function finishMinting() onlyOwner canMint public returns(bool) {
193         mintingFinished = true;
194 
195         MintFinished();
196 
197         return true;
198     }
199 }
200 
201 contract CappedToken is MintableToken {
202     uint256 public cap;
203 
204     function CappedToken(uint256 _cap) public {
205         require(_cap > 0);
206         cap = _cap;
207     }
208 
209     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
210         require(totalSupply.add(_amount) <= cap);
211 
212         return super.mint(_to, _amount);
213     }
214 }
215 
216 contract BurnableToken is StandardToken {
217     event Burn(address indexed burner, uint256 value);
218 
219     function burn(uint256 _value) public {
220         require(_value <= balances[msg.sender]);
221 
222         address burner = msg.sender;
223 
224         balances[burner] = balances[burner].sub(_value);
225         totalSupply = totalSupply.sub(_value);
226 
227         Burn(burner, _value);
228     }
229 }
230 
231 /*
232     ICO Multi level marketing coin
233 */
234 contract Token is CappedToken, BurnableToken {
235     function Token() CappedToken(1000000000 * 1 ether) StandardToken("World Online Sports Coin", "WOSC", 18) public {
236         
237     }
238 }
239 
240 contract Crowdsale is Pausable {
241     using SafeMath for uint;
242 
243     struct Step {
244         uint priceTokenWei;
245         uint tokensForSale;
246         uint tokensSold;
247         uint collectedWei;
248 
249         bool purchase;
250         bool issue;
251     }
252 
253     Token public token;
254     address public beneficiary = 0x7cE9A678A78Dca8555269bA39036098aeA68b819;
255 
256     Step[] public steps;
257     uint8 public currentStep = 0;
258 
259     bool public crowdsaleClosed = false;
260 
261     event NewRate(uint256 rate);
262     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
263     event Issue(address indexed holder, uint256 tokenAmount);
264     event NextStep(uint8 step);
265     event CrowdsaleClose();
266 
267     function Crowdsale() public {
268         token = new Token();
269 
270         steps.push(Step(1e14, 200000000 ether, 0, 0, true, true));
271         steps.push(Step(1e14, 300000000 ether, 0, 0, true, true));
272         steps.push(Step(1e14, 400000000 ether, 0, 0, true, true));
273     }
274 
275     function() payable public {
276         purchase();
277     }
278 
279     function setTokenRate(uint _value) onlyOwner public {
280         require(!crowdsaleClosed);
281         
282         steps[currentStep].priceTokenWei = 1 ether / _value;
283 
284         NewRate(steps[currentStep].priceTokenWei);
285     }
286     
287     function purchase() whenNotPaused payable public {
288         require(!crowdsaleClosed);
289         require(msg.value >= 0.001 ether);
290 
291         Step memory step = steps[currentStep];
292 
293         require(step.purchase);
294         require(step.tokensSold < step.tokensForSale);
295 
296         uint sum = msg.value;
297         uint amount = sum.mul(1 ether).div(step.priceTokenWei);
298         uint retSum = 0;
299         
300         if(step.tokensSold.add(amount) > step.tokensForSale) {
301             uint retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
302             retSum = retAmount.mul(step.priceTokenWei).div(1 ether);
303 
304             amount = amount.sub(retAmount);
305             sum = sum.sub(retSum);
306         }
307 
308         steps[currentStep].tokensSold = step.tokensSold.add(amount);
309         steps[currentStep].collectedWei = step.collectedWei.add(sum);
310 
311         beneficiary.transfer(sum);
312         token.mint(msg.sender, amount);
313 
314         if(retSum > 0) {
315             msg.sender.transfer(retSum);
316         }
317 
318         Purchase(msg.sender, amount, sum);
319     }
320 
321     function issue(address _to, uint256 _value) onlyOwner whenNotPaused public {
322         require(!crowdsaleClosed);
323 
324         Step memory step = steps[currentStep];
325         
326         require(step.issue);
327         require(step.tokensSold.add(_value) <= step.tokensForSale);
328 
329         steps[currentStep].tokensSold = step.tokensSold.add(_value);
330 
331         token.mint(_to, _value);
332 
333         Issue(_to, _value);
334     }
335 
336     function nextStep() onlyOwner public {
337         require(!crowdsaleClosed);
338         require(steps.length - 1 > currentStep);
339         
340         currentStep += 1;
341 
342         NextStep(currentStep);
343     }
344 
345     function closeCrowdsale() onlyOwner public {
346         require(!crowdsaleClosed);
347         
348         token.mint(this, 100000000 ether);
349         token.transferOwnership(beneficiary);
350 
351         crowdsaleClosed = true;
352 
353         CrowdsaleClose();
354     }
355 
356     function withdrawTokens() onlyOwner public {
357         require(crowdsaleClosed);
358         require(now >= 1548990000); // 2019-02-01T00:00:00+00:00
359 
360         token.transfer(beneficiary, token.balanceOf(this));
361     }
362 }