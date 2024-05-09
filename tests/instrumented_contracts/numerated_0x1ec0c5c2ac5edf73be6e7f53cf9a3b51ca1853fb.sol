1 /*! age.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
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
218 contract BurnableToken is StandardToken {
219     event Burn(address indexed burner, uint256 value);
220 
221     function burn(uint256 _value) public {
222         require(_value <= balances[msg.sender]);
223 
224         address burner = msg.sender;
225 
226         balances[burner] = balances[burner].sub(_value);
227         totalSupply = totalSupply.sub(_value);
228 
229         Burn(burner, _value);
230     }
231 }
232 
233 /*
234     ADGEX Limited
235 */
236 contract Token is MintableToken, BurnableToken, Withdrawable {
237     function Token() StandardToken("ADGEX Limited", "AGE", 8) public {
238         
239     }
240 }
241 
242 contract Crowdsale is Withdrawable, Pausable {
243     using SafeMath for uint;
244 
245     struct Step {
246         uint priceTokenWei;
247         uint tokensForSale;
248         uint tokensSold;
249         uint collectedWei;
250     }
251 
252     Token public token;
253     address public beneficiary = 0x1d94940Df6deCB60a30ACd741a8c3a4C13E7A247;
254     address public beneficiary2 = 0xf75D691dbcA084794510A607132Fcb6a98023dd1;
255 
256     Step[] public steps;
257     uint8 public currentStep = 0;
258 
259     bool public crowdsaleClosed = false;
260 
261     event NewRate(uint256 rate);
262     event Purchase(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
263     event NextStep(uint8 step);
264     event CrowdsaleClose();
265 
266     function Crowdsale() public {
267         token = new Token();
268 
269         token.mint(0xa0E69d6A52d585624dca2311B9AD5fAb1272Fc99, 607083870 * 1e8);
270 
271         steps.push(Step(0.00125 ether, 500000000 * 1e8, 0, 0));
272         steps.push(Step(0.001 ether, 12866185000 * 1e8, 0, 0));
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
289         require(msg.value >= 0.0001 ether);
290 
291         Step memory step = steps[currentStep];
292 
293         require(step.tokensSold < step.tokensForSale);
294 
295         uint sum = msg.value;
296         uint amount = sum.mul(1 ether).div(step.priceTokenWei).div(1e10);
297         uint retSum = 0;
298         
299         if(step.tokensSold.add(amount) > step.tokensForSale) {
300             uint retAmount = step.tokensSold.add(amount).sub(step.tokensForSale);
301             retSum = retAmount.mul(step.priceTokenWei).mul(1e10).div(1 ether);
302 
303             amount = amount.sub(retAmount);
304             sum = sum.sub(retSum);
305         }
306 
307         steps[currentStep].tokensSold = step.tokensSold.add(amount);
308         steps[currentStep].collectedWei = step.collectedWei.add(sum);
309 
310         beneficiary.transfer(sum.div(100).mul(16));
311         beneficiary2.transfer(sum.sub(sum.div(100).mul(16)));
312         token.mint(msg.sender, amount);
313 
314         if(retSum > 0) {
315             msg.sender.transfer(retSum);
316         }
317 
318         Purchase(msg.sender, amount, sum);
319     }
320 
321     function nextStep() onlyOwner public {
322         require(!crowdsaleClosed);
323         require(steps.length - 1 > currentStep);
324         
325         currentStep += 1;
326 
327         NextStep(currentStep);
328     }
329 
330     function closeCrowdsale() onlyOwner public {
331         require(!crowdsaleClosed);
332         
333         token.transferOwnership(beneficiary);
334 
335         crowdsaleClosed = true;
336 
337         CrowdsaleClose();
338     }
339 }