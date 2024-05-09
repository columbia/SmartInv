1 /*! lk2.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20         require(b <= a);
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 
31     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
32         require(b != 0);
33         return a % b;
34     }
35 }
36 
37 contract Ownable {
38     address public owner;
39     address public new_owner;
40 
41     event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     modifier onlyOwner() { require(msg.sender == owner); _;  }
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     function _transferOwnership(address _to) internal {
51         require(_to != address(0));
52 
53         new_owner = _to;
54 
55         emit OwnershipTransfer(owner, _to);
56     }
57 
58     function acceptOwnership() public {
59         require(new_owner != address(0) && msg.sender == new_owner);
60 
61         emit OwnershipTransferred(owner, new_owner);
62 
63         owner = new_owner;
64         new_owner = address(0);
65     }
66 
67     function transferOwnership(address _to) public onlyOwner {
68         _transferOwnership(_to);
69     }
70 }
71 
72 contract ERC20 {
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 
76     function totalSupply() public view returns(uint256);
77     function balanceOf(address who) public view returns(uint256);
78     function transfer(address to, uint256 value) public returns(bool);
79     function transferFrom(address from, address to, uint256 value) public returns(bool);
80     function allowance(address owner, address spender) public view returns(uint256);
81     function approve(address spender, uint256 value) public returns(bool);
82 }
83 
84 contract StandardToken is ERC20 {
85     using SafeMath for uint256;
86 
87     uint256 internal totalSupply_;
88 
89     string public name;
90     string public symbol;
91     uint8 public decimals;
92 
93     mapping(address => uint256) public balances;
94     mapping(address => mapping(address => uint256)) internal allowed;
95 
96     constructor(string _name, string _symbol, uint8 _decimals) public {
97         name = _name;
98         symbol = _symbol;
99         decimals = _decimals;
100     }
101 
102     function totalSupply() public view returns(uint256) {
103         return totalSupply_;
104     }
105 
106     function balanceOf(address _owner) public view returns(uint256) {
107         return balances[_owner];
108     }
109 
110     function transfer(address _to, uint256 _value) public returns(bool) {
111         require(_to != address(0));
112         require(_value <= balances[msg.sender]);
113 
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         
117         emit Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
122         require(_to.length == _value.length);
123 
124         for(uint i = 0; i < _to.length; i++) {
125             transfer(_to[i], _value[i]);
126         }
127 
128         return true;
129     }
130 
131     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
132         require(_to != address(0));
133         require(_value <= balances[_from]);
134         require(_value <= allowed[_from][msg.sender]);
135 
136         balances[_from] = balances[_from].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139 
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) public view returns(uint256) {
145         return allowed[_owner][_spender];
146     }
147 
148     function approve(address _spender, uint256 _value) public returns(bool) {
149         require(_spender != address(0));
150         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
151 
152         allowed[msg.sender][_spender] = _value;
153 
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
159         require(_spender != address(0));
160         require(_addedValue > 0);
161 
162         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
163 
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
169         require(_spender != address(0));
170         require(_subtractedValue > 0);
171 
172         uint oldValue = allowed[msg.sender][_spender];
173 
174         if(_subtractedValue > oldValue) {
175             allowed[msg.sender][_spender] = 0;
176         }
177         else {
178             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179         }
180 
181         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182         return true;
183     }
184 }
185 
186 contract MintableToken is StandardToken, Ownable {
187     bool public mintingFinished = false;
188 
189     event Mint(address indexed to, uint256 amount);
190     event MintFinished();
191 
192     modifier canMint() { require(!mintingFinished); _; }
193     modifier hasMintPermission() { require(msg.sender == owner); _; }
194 
195     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
196         totalSupply_ = totalSupply_.add(_amount);
197         balances[_to] = balances[_to].add(_amount);
198 
199         emit Mint(_to, _amount);
200         emit Transfer(address(0), _to, _amount);
201         return true;
202     }
203 
204     function finishMinting() onlyOwner canMint public returns(bool) {
205         mintingFinished = true;
206 
207         emit MintFinished();
208         return true;
209     }
210 }
211 
212 contract CappedToken is MintableToken {
213     uint256 public cap;
214 
215     constructor(uint256 _cap) public {
216         require(_cap > 0);
217         cap = _cap;
218     }
219 
220     function mint(address _to, uint256 _amount) public returns(bool) {
221         require(totalSupply_.add(_amount) <= cap);
222 
223         return super.mint(_to, _amount);
224     }
225 }
226 
227 contract BurnableToken is StandardToken {
228     event Burn(address indexed burner, uint256 value);
229 
230     function _burn(address _who, uint256 _value) internal {
231         require(_value <= balances[_who]);
232 
233         balances[_who] = balances[_who].sub(_value);
234         totalSupply_ = totalSupply_.sub(_value);
235 
236         emit Burn(_who, _value);
237         emit Transfer(_who, address(0), _value);
238     }
239 
240     function burn(uint256 _value) public {
241         _burn(msg.sender, _value);
242     }
243 
244     function burnFrom(address _from, uint256 _value) public {
245         require(_value <= allowed[_from][msg.sender]);
246         
247         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248         _burn(_from, _value);
249     }
250 }
251 
252 contract Withdrawable is Ownable {
253     event WithdrawEther(address indexed to, uint value);
254 
255     function withdrawEther(address _to, uint _value) onlyOwner public {
256         require(_to != address(0));
257         require(address(this).balance >= _value);
258 
259         _to.transfer(_value);
260 
261         emit WithdrawEther(_to, _value);
262     }
263 
264     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
265         require(_token.transfer(_to, _value));
266     }
267 
268     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
269         require(_token.transferFrom(_from, _to, _value));
270     }
271 
272     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
273         require(_token.approve(_spender, _value));
274     }
275 }
276 
277 contract Pausable is Ownable {
278     bool public paused = false;
279 
280     event Pause();
281     event Unpause();
282 
283     modifier whenNotPaused() { require(!paused); _; }
284     modifier whenPaused() { require(paused); _; }
285 
286     function pause() onlyOwner whenNotPaused public {
287         paused = true;
288         emit Pause();
289     }
290 
291     function unpause() onlyOwner whenPaused public {
292         paused = false;
293         emit Unpause();
294     }
295 }
296 
297 contract Manageable is Ownable {
298     address[] public managers;
299 
300     event ManagerAdded(address indexed manager);
301     event ManagerRemoved(address indexed manager);
302 
303     modifier onlyManager() { require(isManager(msg.sender)); _; }
304 
305     function countManagers() view public returns(uint) {
306         return managers.length;
307     }
308 
309     function getManagers() view public returns(address[]) {
310         return managers;
311     }
312 
313     function isManager(address _manager) view public returns(bool) {
314         for(uint i = 0; i < managers.length; i++) {
315             if(managers[i] == _manager) {
316                 return true;
317             }
318         }
319         return false;
320     }
321 
322     function addManager(address _manager) onlyOwner public {
323         require(_manager != address(0));
324         require(!isManager(_manager));
325 
326         managers.push(_manager);
327 
328         emit ManagerAdded(_manager);
329     }
330 
331     function removeManager(address _manager) onlyOwner public {
332         uint index = managers.length;
333         for(uint i = 0; i < managers.length; i++) {
334             if(managers[i] == _manager) {
335                 index = i;
336             }
337         }
338 
339         if(index >= managers.length) revert();
340 
341         for(; index < managers.length - 1; index++) {
342             managers[index] = managers[index + 1];
343         }
344         
345         managers.length--;
346         emit ManagerRemoved(_manager);
347     }
348 }
349 
350 contract RewardToken is StandardToken, Ownable {
351     struct Payment {
352         uint time;
353         uint amount;
354     }
355 
356     Payment[] public repayments;
357     mapping(address => Payment[]) public rewards;
358 
359     event Repayment(address indexed from, uint256 amount);
360     event Reward(address indexed to, uint256 amount);
361 
362     function repayment() onlyOwner payable public {
363         require(msg.value >= 0.01 ether);
364 
365         repayments.push(Payment({time : block.timestamp, amount : msg.value}));
366 
367         emit Repayment(msg.sender, msg.value);
368     }
369 
370     function _reward(address _to) private returns(bool) {
371         if(rewards[_to].length < repayments.length) {
372             uint sum = 0;
373             for(uint i = rewards[_to].length; i < repayments.length; i++) {
374                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply_) : 0;
375                 rewards[_to].push(Payment({time : block.timestamp, amount : amount}));
376                 sum += amount;
377             }
378 
379             if(sum > 0) {
380                 _to.transfer(sum);
381                 emit Reward(_to, sum);
382             }
383 
384             return true;
385         }
386         return false;
387     }
388 
389     function reward() public returns(bool) {
390         return _reward(msg.sender);
391     }
392 
393     function transfer(address _to, uint256 _value) public returns(bool) {
394         _reward(msg.sender);
395         _reward(_to);
396         return super.transfer(_to, _value);
397     }
398 
399     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
400         _reward(_from);
401         _reward(_to);
402         return super.transferFrom(_from, _to, _value);
403     }
404 }
405 
406 
407 contract Token is RewardToken, CappedToken, BurnableToken, Withdrawable {
408     constructor() CappedToken(2000000000 * 1e8) StandardToken("TLS Token", "TLS", 8) public {
409         
410     }
411 }
412 
413 contract Crowdsale is Manageable, Withdrawable, Pausable {
414     using SafeMath for uint;
415 
416     Token public token;
417     bool public crowdsaleClosed = false;
418 
419     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
420     event CrowdsaleClose();
421    
422     constructor() public {
423         token = new Token();
424         addManager(0x3a75fedC58bc0a5B10F5FCcC6c0a24470C34a0e8);
425         addManager(0x66F6aE2B20DF5a07bDc9b92fF80aEb77e3d81B11);
426     }
427 
428     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager external {
429         require(!crowdsaleClosed);
430         require(_to != address(0));
431 
432         token.mint(_to, _tokens);
433         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
434     }
435 
436     function closeCrowdsale(address _newTokenOwner) onlyOwner external {
437         require(!crowdsaleClosed);
438         require(_newTokenOwner != address(0));
439 
440         token.finishMinting();
441         token.transferOwnership(_newTokenOwner);
442 
443         crowdsaleClosed = true;
444 
445         emit CrowdsaleClose();
446     }
447     
448     function transferTokenOwnership(address _to) onlyOwner external {
449         require(crowdsaleClosed);
450         require(_to != address(0));
451 
452         token.transferOwnership(_to);
453     }
454 }