1 pragma solidity ^0.4.24;
2 //
3 // BioX Token
4 //
5 //
6 library SafeMath{
7 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8 		uint256 c = a * b;
9 		assert(a == 0 || c / a == b);
10 		return c;
11 	}
12 
13 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
14 		uint256 c = a / b;
15 		return c;
16 	}
17 
18 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19 		assert(b <= a);
20 		return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
24 		uint256 c = a + b;
25 		assert(c >= a);
26 		return c;
27 	}
28 }
29 
30 contract BioXToken {
31 	using SafeMath for uint256;
32     string public constant name         = "BIOX";
33     string public constant symbol       = "BIOX";
34     uint public constant decimals       = 18;
35     
36     uint256 bioxEthRate                  = 10 ** decimals;
37     uint256 bioxSupply                   = 200000000000;
38     uint256 public totalSupply          = bioxSupply * bioxEthRate;
39     uint256 public minInvEth            = 0.1 ether;
40     uint256 public maxInvEth            = 9999999999999 ether;
41     uint256 public sellStartTime        = 1532861854;           //  7/29/2018
42     uint256 public sellDeadline1        = sellStartTime + 30 days;
43     uint256 public sellDeadline2        = sellDeadline1 + 360 days;
44     uint256 public freezeDuration       = 30 days;
45     uint256 public ethBioxRate1          = 35000;
46     uint256 public ethBioxRate2          = 35000;
47 
48     bool public running                 = true;
49     bool public buyable                 = true;
50     
51     address owner;
52     mapping (address => mapping (address => uint256)) allowed;
53     mapping (address => bool) public whitelist;
54     mapping (address =>  uint256) whitelistLimit;
55 
56     struct BalanceInfo {
57         uint256 balance;
58         uint256[] freezeAmount;
59         uint256[] releaseTime;
60     }
61     mapping (address => BalanceInfo) balances;
62     
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event BeginRunning();
66     event Pause();
67     event BeginSell();
68     event PauseSell();
69     event Burn(address indexed burner, uint256 val);
70     event Freeze(address indexed from, uint256 value);
71     
72     constructor () public{
73         owner = msg.sender;
74         balances[owner].balance = totalSupply;
75     }
76     
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81     
82     modifier onlyWhitelist() {
83         require(whitelist[msg.sender] == true);
84         _;
85     }
86     
87     modifier isRunning(){
88         require(running);
89         _;
90     }
91     modifier isNotRunning(){
92         require(!running);
93         _;
94     }
95     modifier isBuyable(){
96         require(buyable && now >= sellStartTime && now <= sellDeadline2);
97         _;
98     }
99     modifier isNotBuyable(){
100         require(!buyable || now < sellStartTime || now > sellDeadline2);
101         _;
102     }
103     // mitigates the ERC20 short address attack
104     modifier onlyPayloadSize(uint size) {
105         assert(msg.data.length >= size + 4);
106         _;
107     }
108 
109     // 1eth = newRate tokens
110     function setPublicOfferPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {
111         ethBioxRate1 = _rate1;
112         ethBioxRate2 = _rate2;       
113     }
114 
115     //
116     function setPublicOfferLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {
117         minInvEth   = _minVal;
118         maxInvEth   = _maxVal;
119     }
120     
121     function setPublicOfferDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {
122         sellStartTime = _startTime;
123         sellDeadline1   = _deadLine1;
124         sellDeadline2   = _deadLine2;
125     }
126         
127     function transferOwnership(address _newOwner) onlyOwner public {
128         if (_newOwner !=    address(0)) {
129             owner = _newOwner;
130         }
131     }
132     
133     function pause() onlyOwner isRunning    public   {
134         running = false;
135         emit Pause();
136     }
137     
138     function start() onlyOwner isNotRunning public   {
139         running = true;
140         emit BeginRunning();
141     }
142 
143     function pauseSell() onlyOwner  isBuyable isRunning public{
144         buyable = false;
145         emit PauseSell();
146     }
147     
148     function beginSell() onlyOwner  isNotBuyable isRunning  public{
149         buyable = true;
150         emit BeginSell();
151     }
152 
153     //
154     // 
155     // All air deliver related functions use counts insteads of wei
156     // _amount in BioX, not wei
157     //
158     function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
159         require(owner != _to);
160         require(_amount > 0);
161         require(balances[owner].balance >= _amount);
162         
163         // take big number as wei
164         if(_amount < bioxSupply){
165             _amount = _amount * bioxEthRate;
166         }
167         balances[owner].balance = balances[owner].balance.sub(_amount);
168         balances[_to].balance = balances[_to].balance.add(_amount);
169         emit Transfer(owner, _to, _amount);
170     }
171     
172     
173     function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {
174         require(_addrs.length <=  255);
175         
176         for (uint8 i = 0; i < _addrs.length; i++)   {
177             airDeliver(_addrs[i],   _amount);
178         }
179     }
180     
181     function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {
182         require(_addrs.length <=  255);
183         require(_addrs.length ==     _amounts.length);
184         
185         for (uint8 i = 0; i < _addrs.length;    i++) {
186             airDeliver(_addrs[i],   _amounts[i]);
187         }
188     }
189 
190     //
191     // _amount, _freezeAmount in BioX
192     //
193     function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
194         require(owner != _to);
195         require(_freezeMonth > 0);
196         
197         uint average = _freezeAmount / _freezeMonth;
198         BalanceInfo storage bi = balances[_to];
199         uint[] memory fa = new uint[](_freezeMonth);
200         uint[] memory rt = new uint[](_freezeMonth);
201 
202         if(_amount < bioxSupply){
203             _amount = _amount * bioxEthRate;
204             average = average * bioxEthRate;
205             _freezeAmount = _freezeAmount * bioxEthRate;
206         }
207         require(balances[owner].balance > _amount);
208         uint remainAmount = _freezeAmount;
209         
210         if(_unfreezeBeginTime == 0)
211             _unfreezeBeginTime = now + freezeDuration;
212         for(uint i=0;i<_freezeMonth-1;i++){
213             fa[i] = average;
214             rt[i] = _unfreezeBeginTime;
215             _unfreezeBeginTime += freezeDuration;
216             remainAmount = remainAmount.sub(average);
217         }
218         fa[i] = remainAmount;
219         rt[i] = _unfreezeBeginTime;
220         
221         bi.balance = bi.balance.add(_amount);
222         bi.freezeAmount = fa;
223         bi.releaseTime = rt;
224         balances[owner].balance = balances[owner].balance.sub(_amount);
225         emit Transfer(owner, _to, _amount);
226         emit Freeze(_to, _freezeAmount);
227     }
228     
229     
230     // buy tokens directly
231     function () external payable {
232         buyTokens();
233     }
234 
235     //
236     function buyTokens() payable isRunning isBuyable public {
237         uint256 weiVal = msg.value;
238         address investor = msg.sender;
239         require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);
240         require(weiVal.add(whitelistLimit[investor]) <= maxInvEth);
241         
242         uint256 amount = 0;
243         if(now > sellDeadline1)
244             amount = msg.value.mul(ethBioxRate2);
245         else
246             amount = msg.value.mul(ethBioxRate1);   
247 
248         whitelistLimit[investor] = weiVal.add(whitelistLimit[investor]);
249         
250         balances[owner].balance = balances[owner].balance.sub(amount);
251         balances[investor].balance = balances[investor].balance.add(amount);
252         emit Transfer(owner, investor, amount);
253     }
254 	//Use "" for adding whitelists.
255     function addWhiteListMulti(address[] _addrs) public onlyOwner {
256         require(_addrs.length <=  255);
257 
258         for (uint8 i = 0; i < _addrs.length; i++) {
259             if (!whitelist[_addrs[i]]){
260                 whitelist[_addrs[i]] = true;
261             }
262         }
263     }
264 
265     function balanceOf(address _owner) constant public returns (uint256) {
266         return balances[_owner].balance;
267     }
268     
269     function freezeOf(address _owner) constant  public returns (uint256) {
270         BalanceInfo storage bi = balances[_owner];
271         uint freezeAmount = 0;
272         uint t = now;
273         
274         for(uint i=0;i< bi.freezeAmount.length;i++){
275             if(t < bi.releaseTime[i])
276                 freezeAmount += bi.freezeAmount[i];
277         }
278         return freezeAmount;
279     }
280     
281     function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {
282         require(_to != address(0));
283         uint freezeAmount = freezeOf(msg.sender);
284         uint256 _balance = balances[msg.sender].balance.sub(freezeAmount);
285         require(_amount <= _balance);
286         
287         balances[msg.sender].balance = balances[msg.sender].balance.sub(_amount);
288         balances[_to].balance = balances[_to].balance.add(_amount);
289         emit Transfer(msg.sender, _to, _amount);
290         return true;
291     }
292 
293     function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {
294         require(_from   != address(0) && _to != address(0));
295         require(_amount <= allowed[_from][msg.sender]);
296         uint freezeAmount = freezeOf(_from);
297         uint256 _balance = balances[_from].balance.sub(freezeAmount);
298         require(_amount <= _balance);
299         
300         balances[_from].balance = balances[_from].balance.sub(_amount);
301         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
302         balances[_to].balance = balances[_to].balance.add(_amount);
303         emit Transfer(_from, _to, _amount);
304         return true;
305     }
306 
307     function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {
308         if (_value != 0 && allowed[msg.sender][_spender] != 0) { 
309             return  false; 
310         }
311         allowed[msg.sender][_spender] = _value;
312         emit Approval(msg.sender, _spender, _value);
313         return true;
314     }
315     
316     function allowance(address _owner, address _spender) constant public returns (uint256) {
317         return allowed[_owner][_spender];
318     }
319     
320     function withdraw() onlyOwner public {
321         address myAddress = this;
322         require(myAddress.balance > 0);
323         owner.transfer(myAddress.balance);
324         emit Transfer(this, owner, myAddress.balance);    
325     }
326     
327     function burn(address burner, uint256 _value) onlyOwner public {
328         require(_value <= balances[msg.sender].balance);
329 
330         balances[burner].balance = balances[burner].balance.sub(_value);
331         totalSupply = totalSupply.sub(_value);
332         bioxSupply = totalSupply / bioxEthRate;
333         emit Burn(burner, _value);
334     }
335 }