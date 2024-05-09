1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public constant returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) public constant returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11   function approve(address spender, uint256 value) public returns (bool);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract BasicToken is ERC20Basic {
16   using SafeMath for uint256;
17 
18   mapping(address => uint256) balances;
19 
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22 
23     // SafeMath.sub will throw if there is not enough balance.
24     balances[msg.sender] = balances[msg.sender].sub(_value);
25     balances[_to] = balances[_to].add(_value);
26     Transfer(msg.sender, _to, _value);
27     return true;
28   }
29 
30   function balanceOf(address _owner) public constant returns (uint256 balance) {
31     return balances[_owner];
32   }
33 }
34 
35 contract StandardToken is ERC20, BasicToken {
36 
37   mapping (address => mapping (address => uint256)) internal allowed;
38 
39   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
40     require(_to != address(0));
41 
42     uint256 _allowance = allowed[_from][msg.sender];
43 
44     balances[_from] = balances[_from].sub(_value);
45     balances[_to] = balances[_to].add(_value);
46     allowed[_from][msg.sender] = _allowance.sub(_value);
47     Transfer(_from, _to, _value);
48     return true;
49   }
50 
51   function approve(address _spender, uint256 _value) public returns (bool) {
52     allowed[msg.sender][_spender] = _value;
53     Approval(msg.sender, _spender, _value);
54     return true;
55   }
56 
57   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
58     return allowed[_owner][_spender];
59   }
60 
61   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
62     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
63     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
64     return true;
65   }
66 
67   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
68     uint oldValue = allowed[msg.sender][_spender];
69     if (_subtractedValue > oldValue) {
70       allowed[msg.sender][_spender] = 0;
71     } else {
72       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
73     }
74     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
75     return true;
76   }
77 }
78 
79 contract Ownable {
80   
81   address public owner;
82 
83   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85   function Ownable() {
86     owner = msg.sender;
87   }
88 
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   function transferOwnership(address newOwner) onlyOwner {
95     require(newOwner != address(0));      
96     OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 }
100 
101 contract Pausable is Ownable {
102   event Pause();
103   event Unpause();
104 
105   bool public paused = true;
106 
107   modifier whenNotPaused() {
108     require(!paused);
109     _;
110   }
111 
112   modifier whenPaused() {
113     require(paused);
114     _;
115   }
116 
117   function pause() onlyOwner whenNotPaused {
118     paused = true;
119     Pause();
120   }
121 
122   function unpause() onlyOwner whenPaused {
123     paused = false;
124     Unpause();
125   }
126 }
127 
128 contract MintableToken is StandardToken, Ownable {
129   event Mint(address indexed to, uint256 amount);
130   event MintFinished();
131 
132   bool public mintingFinished = false;
133 
134 
135   modifier canMint() {
136     require(!mintingFinished);
137     _;
138   }
139 
140   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
141     totalSupply = totalSupply.add(_amount);
142     balances[_to] = balances[_to].add(_amount);
143     Mint(_to, _amount);
144     Transfer(0x0, _to, _amount);
145     return true;
146   }
147 
148   function finishMinting() onlyOwner public returns (bool) {
149     mintingFinished = true;
150     MintFinished();
151     return true;
152   }
153 }
154 
155 library SafeMath {
156   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
157     uint256 c = a * b;
158     assert(a == 0 || c / a == b);
159     return c;
160   }
161 
162   function div(uint256 a, uint256 b) internal constant returns (uint256) {
163     uint256 c = a / b;
164     return c;
165   }
166 
167   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   function add(uint256 a, uint256 b) internal constant returns (uint256) {
173     uint256 c = a + b;
174     assert(c >= a);
175     return c;
176   }
177 }
178 
179 contract Crowdsale {
180   using SafeMath for uint256;
181 
182   MintableToken public token;
183 
184   uint256 public startTime;
185   uint256 public endTime;
186 
187   address wallet;
188 
189   uint256 public rate;
190 
191   uint256 public weiRaised;
192 
193   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
194 
195   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
196     require(_startTime >= 0);
197     require(_endTime >= _startTime);
198     require(_rate > 0);
199     require(_wallet != 0x0);
200 
201     token = createTokenContract();
202     startTime = _startTime;
203     endTime = _endTime;
204     rate = _rate;
205     wallet = _wallet;
206   }
207 
208   function createTokenContract() internal returns (MintableToken) {
209     return new MintableToken();
210   }
211 
212   function () payable {
213     buyTokens(msg.sender);
214   }
215 
216   function buyTokens(address beneficiary) public payable {
217     require(beneficiary != 0x0);
218     require(validPurchase());
219 
220     uint256 weiAmount = msg.value;
221 
222     uint256 tokens = weiAmount.mul(rate);
223 
224     weiRaised = weiRaised.add(weiAmount);
225 
226     token.mint(beneficiary, tokens);
227     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
228 
229     forwardFunds();
230   }
231 
232   function forwardFunds() internal {
233     wallet.transfer(msg.value);
234   }
235 
236   function validPurchase() internal constant returns (bool) {
237     bool withinPeriod = now >= startTime && now <= endTime;
238     bool nonZeroPurchase = msg.value != 0;
239     return withinPeriod && nonZeroPurchase;
240   }
241 
242   function hasEnded() public constant returns (bool) {
243     return now > endTime;
244   }
245 }
246 
247 contract XulToken is MintableToken, Pausable {
248   string public constant name = "XULToken";
249   string public constant symbol = "XUL";
250   uint8 public constant decimals = 18;
251 
252   uint256 public preIcoEndDate = 1510704000;  
253 
254   function XulToken() {
255   }
256   
257   function mint(address _to, uint256 _amount) onlyOwner canMint whenNotPaused public returns (bool) {
258     uint256 goal = 300000000 * (10**18);
259 
260     if (isPreIcoDate()) {
261       uint256 sum = totalSupply.add(_amount);
262       require(sum <= goal);
263     }
264 
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     Mint(_to, _amount);
268     Transfer(0x0, _to, _amount);
269     if (totalSupply == goal && isPreIcoDate()) {
270       paused = true;
271     }
272     return true;    
273   }
274      
275   function superMint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     balances[_to] = balances[_to].add(_amount);
277     Mint(_to, _amount);
278     Transfer(0x0, _to, _amount);
279     return true;
280   }     
281   
282   function changePreIcoEndDate(uint256 _preIcoEndDate) onlyOwner public {
283     require(_preIcoEndDate > 0);
284     preIcoEndDate = _preIcoEndDate;
285   }  
286  
287   function isPreIcoDate() public returns(bool) {
288     return now <= preIcoEndDate;
289   }     
290 }
291 
292 contract XulCrowdsale is Crowdsale, Ownable {
293   XulToken public xultoken;
294     
295   function XulCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)
296     Crowdsale(_startTime, _endTime, _rate, _wallet)
297   {
298     
299   }
300   
301   function createTokenContract() internal returns (MintableToken) {
302      xultoken = new XulToken();
303      return xultoken;
304   }
305   
306   function changeRate(uint256 _rate) public onlyOwner returns (bool){
307       require(_rate > 0);
308       rate = _rate;
309   }
310     
311   function pauseToken() public onlyOwner returns(bool){
312       xultoken.pause();
313   }
314    
315   function unpauseToken() public onlyOwner returns(bool){
316       xultoken.unpause();
317   }
318 
319   function mintToken(address _to, uint256 _amount) public onlyOwner returns(bool){
320       xultoken.mint(_to, _amount * (10 ** 18));
321   }
322 
323   function mintBulk(address[] _receivers, uint256[] _amounts) onlyOwner public {
324     require(_receivers.length == _amounts.length);
325     for (uint i = 0; i < _receivers.length; i++) {
326         mintToken(_receivers[i], _amounts[i]);
327     }
328   } 
329   
330   function superMint(address _to, uint256 _amount) public onlyOwner returns(bool) {
331       xultoken.superMint(_to, _amount * (10 ** 18));
332   }
333   
334   function setStartTime(uint256 _startTime) public onlyOwner {
335       require(_startTime > 0);
336       startTime = _startTime;
337   }  
338 
339   function setEndTime(uint256 _endTime) public onlyOwner {
340       require(_endTime > 0);
341       endTime = _endTime;
342   }    
343 
344   function setPreIcoEndDate(uint256 _preIcoEndDate) public onlyOwner {
345     xultoken.changePreIcoEndDate(_preIcoEndDate);
346   }  
347 }