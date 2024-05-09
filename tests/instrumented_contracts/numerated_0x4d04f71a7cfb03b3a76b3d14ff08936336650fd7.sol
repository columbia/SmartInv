1 /*! lk.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
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
39 
40     event OwnershipRenounced(address indexed previousOwner);
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() { require(msg.sender == owner); _;  }
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     function _transferOwnership(address _newOwner) internal {
50         require(_newOwner != address(0));
51         emit OwnershipTransferred(owner, _newOwner);
52         owner = _newOwner;
53     }
54 
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipRenounced(owner);
57         owner = address(0);
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         _transferOwnership(_newOwner);
62     }
63 }
64 
65 contract ERC20 {
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69     function totalSupply() public view returns(uint256);
70     function balanceOf(address who) public view returns(uint256);
71     function transfer(address to, uint256 value) public returns(bool);
72     function transferFrom(address from, address to, uint256 value) public returns(bool);
73     function allowance(address owner, address spender) public view returns(uint256);
74     function approve(address spender, uint256 value) public returns(bool);
75 }
76 
77 contract StandardToken is ERC20 {
78     using SafeMath for uint256;
79 
80     uint256 internal totalSupply_;
81 
82     string public name;
83     string public symbol;
84     uint8 public decimals;
85 
86     mapping(address => uint256) public balances;
87     mapping(address => mapping(address => uint256)) internal allowed;
88 
89     constructor(string _name, string _symbol, uint8 _decimals) public {
90         name = _name;
91         symbol = _symbol;
92         decimals = _decimals;
93     }
94 
95     function totalSupply() public view returns(uint256) {
96         return totalSupply_;
97     }
98 
99     function balanceOf(address _owner) public view returns(uint256) {
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
110         emit Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
115         require(_to.length == _value.length);
116 
117         for(uint i = 0; i < _to.length; i++) {
118             transfer(_to[i], _value[i]);
119         }
120 
121         return true;
122     }
123 
124     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
125         require(_to != address(0));
126         require(_value <= balances[_from]);
127         require(_value <= allowed[_from][msg.sender]);
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132 
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns(uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     function approve(address _spender, uint256 _value) public returns(bool) {
142         require(_spender != address(0));
143         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
144 
145         allowed[msg.sender][_spender] = _value;
146 
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
152         require(_spender != address(0));
153         require(_addedValue > 0);
154 
155         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
156 
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158         return true;
159     }
160 
161     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
162         require(_spender != address(0));
163         require(_subtractedValue > 0);
164 
165         uint oldValue = allowed[msg.sender][_spender];
166 
167         if(_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         }
170         else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173 
174         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 }
178 
179 contract MintableToken is StandardToken, Ownable {
180     bool public mintingFinished = false;
181 
182     event Mint(address indexed to, uint256 amount);
183     event MintFinished();
184 
185     modifier canMint() { require(!mintingFinished); _; }
186     modifier hasMintPermission() { require(msg.sender == owner); _; }
187 
188     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
189         totalSupply_ = totalSupply_.add(_amount);
190         balances[_to] = balances[_to].add(_amount);
191 
192         emit Mint(_to, _amount);
193         emit Transfer(address(0), _to, _amount);
194         return true;
195     }
196 
197     function finishMinting() onlyOwner canMint public returns(bool) {
198         mintingFinished = true;
199 
200         emit MintFinished();
201         return true;
202     }
203 }
204 
205 contract CappedToken is MintableToken {
206     uint256 public cap;
207 
208     constructor(uint256 _cap) public {
209         require(_cap > 0);
210         cap = _cap;
211     }
212 
213     function mint(address _to, uint256 _amount) public returns(bool) {
214         require(totalSupply_.add(_amount) <= cap);
215 
216         return super.mint(_to, _amount);
217     }
218 }
219 
220 contract BurnableToken is StandardToken {
221     event Burn(address indexed burner, uint256 value);
222 
223     function _burn(address _who, uint256 _value) internal {
224         require(_value <= balances[_who]);
225 
226         balances[_who] = balances[_who].sub(_value);
227         totalSupply_ = totalSupply_.sub(_value);
228 
229         emit Burn(_who, _value);
230         emit Transfer(_who, address(0), _value);
231     }
232 
233     function burn(uint256 _value) public {
234         _burn(msg.sender, _value);
235     }
236 
237     function burnFrom(address _from, uint256 _value) public {
238         require(_value <= allowed[_from][msg.sender]);
239         
240         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241         _burn(_from, _value);
242     }
243 }
244 
245 contract Withdrawable is Ownable {
246     event WithdrawEther(address indexed to, uint value);
247 
248     function withdrawEther(address _to, uint _value) onlyOwner public {
249         require(_to != address(0));
250         require(address(this).balance >= _value);
251 
252         _to.transfer(_value);
253 
254         emit WithdrawEther(_to, _value);
255     }
256 
257     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
258         require(_token.transfer(_to, _value));
259     }
260 
261     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
262         require(_token.transferFrom(_from, _to, _value));
263     }
264 
265     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
266         require(_token.approve(_spender, _value));
267     }
268 }
269 
270 contract Pausable is Ownable {
271     bool public paused = false;
272 
273     event Pause();
274     event Unpause();
275 
276     modifier whenNotPaused() { require(!paused); _; }
277     modifier whenPaused() { require(paused); _; }
278 
279     function pause() onlyOwner whenNotPaused public {
280         paused = true;
281         emit Pause();
282     }
283 
284     function unpause() onlyOwner whenPaused public {
285         paused = false;
286         emit Unpause();
287     }
288 }
289 
290 contract Manageable is Ownable {
291     address[] public managers;
292 
293     event ManagerAdded(address indexed manager);
294     event ManagerRemoved(address indexed manager);
295 
296     modifier onlyManager() { require(isManager(msg.sender)); _; }
297 
298     function countManagers() view public returns(uint) {
299         return managers.length;
300     }
301 
302     function getManagers() view public returns(address[]) {
303         return managers;
304     }
305 
306     function isManager(address _manager) view public returns(bool) {
307         for(uint i = 0; i < managers.length; i++) {
308             if(managers[i] == _manager) {
309                 return true;
310             }
311         }
312         return false;
313     }
314 
315     function addManager(address _manager) onlyOwner public {
316         require(_manager != address(0));
317         require(!isManager(_manager));
318 
319         managers.push(_manager);
320 
321         emit ManagerAdded(_manager);
322     }
323 
324     function removeManager(address _manager) onlyOwner public {
325         uint index = managers.length;
326         for(uint i = 0; i < managers.length; i++) {
327             if(managers[i] == _manager) {
328                 index = i;
329             }
330         }
331 
332         if(index >= managers.length) revert();
333 
334         for(; index < managers.length - 1; index++) {
335             managers[index] = managers[index + 1];
336         }
337         
338         managers.length--;
339         emit ManagerRemoved(_manager);
340     }
341 }
342 
343 contract RewardToken is StandardToken, Ownable {
344     struct Payment {
345         uint time;
346         uint amount;
347     }
348 
349     Payment[] public repayments;
350     mapping(address => Payment[]) public rewards;
351 
352     event Repayment(address indexed from, uint256 amount);
353     event Reward(address indexed to, uint256 amount);
354 
355     function repayment() onlyOwner payable public {
356         require(msg.value >= 0.01 ether);
357 
358         repayments.push(Payment({time : block.timestamp, amount : msg.value}));
359 
360         emit Repayment(msg.sender, msg.value);
361     }
362 
363     function _reward(address _to) private returns(bool) {
364         if(rewards[_to].length < repayments.length) {
365             uint sum = 0;
366             for(uint i = rewards[_to].length; i < repayments.length; i++) {
367                 uint amount = balances[_to] > 0 ? (repayments[i].amount * balances[_to] / totalSupply_) : 0;
368                 rewards[_to].push(Payment({time : block.timestamp, amount : amount}));
369                 sum += amount;
370             }
371 
372             if(sum > 0) {
373                 _to.transfer(sum);
374                 emit Reward(_to, sum);
375             }
376 
377             return true;
378         }
379         return false;
380     }
381 
382     function reward() public returns(bool) {
383         return _reward(msg.sender);
384     }
385 
386     function transfer(address _to, uint256 _value) public returns(bool) {
387         _reward(msg.sender);
388         _reward(_to);
389         return super.transfer(_to, _value);
390     }
391 
392     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
393         _reward(_from);
394         _reward(_to);
395         return super.transferFrom(_from, _to, _value);
396     }
397 }
398 
399 contract Token is RewardToken, CappedToken, BurnableToken, Withdrawable {
400     constructor() CappedToken(100000000 * 1e8) StandardToken("AiS", "AiS", 8) public {
401         
402     }
403 }
404 
405 contract Crowdsale is Manageable, Withdrawable, Pausable {
406     using SafeMath for uint;
407 
408     Token public token;
409     bool public crowdsaleClosed = false;
410 
411     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
412     event CrowdsaleClose();
413    
414     constructor() public {
415         token = new Token();
416     }
417 
418     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager external {
419         require(!crowdsaleClosed);
420         require(_to != address(0));
421 
422         token.mint(_to, _tokens);
423         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
424     }
425 
426     function closeCrowdsale(address _newTokenOwner) onlyOwner external {
427         require(!crowdsaleClosed);
428         require(_newTokenOwner != address(0));
429 
430         token.finishMinting();
431         token.transferOwnership(_newTokenOwner);
432 
433         crowdsaleClosed = true;
434 
435         emit CrowdsaleClose();
436     }
437 }