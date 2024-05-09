1 pragma solidity ^0.4.24;
2 
3 //
4 // MeshX Token
5 //
6 library SafeMath {
7 	
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     	if (a == 0) {
10     	return 0;
11     	}
12 
13     	c = a * b;
14     	assert(c / a == b);
15     	return c;
16   	}
17 
18 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
19 		return a / b;
20 	}
21 
22 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     	assert(b <= a);
24     	return a - b;
25 	}
26 
27 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     	c = a + b;
29     	assert(c >= a);
30     	return c;
31 	}
32 }
33 
34 contract MeshXToken {
35 	using SafeMath for uint256;
36     string public constant name         = "MeshX";
37     string public constant symbol       = "MSX";
38     uint public constant decimals       = 18;
39     
40     uint256 EthRate                  = 10 ** decimals;
41     uint256 Supply                   = 3000000000;
42     uint256 public totalSupply          = Supply * EthRate;
43     uint256 public minInvEth            = 2 ether;
44     uint256 public maxInvEth            = 2000.0 ether;
45     uint256 public sellStartTime        = 1533052800;           // 2018/8/1
46     uint256 public sellDeadline1        = sellStartTime + 60 days;
47     uint256 public sellDeadline2        = sellDeadline1 + 60 days;
48     uint256 public freezeDuration       = 180 days;
49     uint256 public ethRate1          = 3600;
50     uint256 public ethRate2          = 3000;
51 
52     bool public running                 = true;
53     bool public buyable                 = true;
54     
55     address owner;
56     mapping (address => mapping (address => uint256)) allowed;
57     mapping (address => bool) public whitelist;
58     mapping (address => uint256) whitelistLimit;
59 
60     struct BalanceInfo {
61         uint256 balance;
62         uint256[] freezeAmount;
63         uint256[] releaseTime;
64     }
65     mapping (address => BalanceInfo) balances;
66     
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     event BeginRunning();
70     event Pause();
71     event BeginSell();
72     event PauseSell();
73     event Burn(address indexed burner, uint256 val);
74     event Freeze(address indexed from, uint256 value);
75     
76     constructor () public{
77         owner = msg.sender;
78         balances[owner].balance = totalSupply;
79     }
80     
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85     
86     modifier onlyWhitelist() {
87         require(whitelist[msg.sender] == true);
88         _;
89     }
90     
91     modifier isRunning(){
92         require(running);
93         _;
94     }
95     modifier isNotRunning(){
96         require(!running);
97         _;
98     }
99     modifier isBuyable(){
100         require(buyable && now >= sellStartTime && now <= sellDeadline2);
101         _;
102     }
103     modifier isNotBuyable(){
104         require(!buyable || now < sellStartTime || now > sellDeadline2);
105         _;
106     }
107     // mitigates the ERC20 short address attack
108     modifier onlyPayloadSize(uint size) {
109         assert(msg.data.length >= size + 4);
110         _;
111     }
112 
113     // 1eth = newRate tokens
114     function setPublicOfferPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {
115         ethRate1 = _rate1;
116         ethRate2 = _rate2;       
117     }
118 
119     //
120     function setPublicOfferLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {
121         minInvEth   = _minVal;
122         maxInvEth   = _maxVal;
123     }
124     
125     function setPublicOfferDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {
126         sellStartTime = _startTime;
127         sellDeadline1 = _deadLine1;
128         sellDeadline2 = _deadLine2;
129     }
130         
131     function transferOwnership(address _newOwner) onlyOwner public {
132         if (_newOwner !=    address(0)) {
133             owner = _newOwner;
134         }
135     }
136     
137     function pause() onlyOwner isRunning    public   {
138         running = false;
139         emit Pause();
140     }
141     
142     function start() onlyOwner isNotRunning public   {
143         running = true;
144         emit BeginRunning();
145     }
146 
147     function pauseSell() onlyOwner  isBuyable isRunning public{
148         buyable = false;
149         emit PauseSell();
150     }
151     
152     function beginSell() onlyOwner  isNotBuyable isRunning  public{
153         buyable = true;
154         emit BeginSell();
155     }
156 
157     //
158     // _amount in MeshX, 
159     //
160     function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
161         require(owner != _to);
162         require(_amount > 0);
163         require(balances[owner].balance >= _amount);
164         
165         // take big number as wei
166         if(_amount < Supply){
167             _amount = _amount * EthRate;
168         }
169         balances[owner].balance = balances[owner].balance.sub(_amount);
170         balances[_to].balance = balances[_to].balance.add(_amount);
171         emit Transfer(owner, _to, _amount);
172     }
173     
174     function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {
175         require(_addrs.length <=  255);
176         
177         for (uint8 i = 0; i < _addrs.length; i++)   {
178             airDeliver(_addrs[i],   _amount);
179         }
180     }
181     
182     function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {
183         require(_addrs.length <=  255);
184         require(_addrs.length ==  _amounts.length);
185         
186         for (uint8 i = 0; i < _addrs.length;    i++) {
187             airDeliver(_addrs[i],   _amounts[i]);
188         }
189     }
190 
191     //
192     // _amount, _freezeAmount in MeshX
193     //
194     function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
195         require(owner != _to);
196         require(_freezeMonth > 0);
197         
198         uint average = _freezeAmount / _freezeMonth;
199         BalanceInfo storage bi = balances[_to];
200         uint[] memory fa = new uint[](_freezeMonth);
201         uint[] memory rt = new uint[](_freezeMonth);
202 
203         if(_amount < Supply){
204             _amount = _amount * EthRate;
205             average = average * EthRate;
206             _freezeAmount = _freezeAmount * EthRate;
207         }
208         require(balances[owner].balance > _amount);
209         uint remainAmount = _freezeAmount;
210         
211         if(_unfreezeBeginTime == 0)
212             _unfreezeBeginTime = now + freezeDuration;
213         for(uint i=0;i<_freezeMonth-1;i++){
214             fa[i] = average;
215             rt[i] = _unfreezeBeginTime;
216             _unfreezeBeginTime += freezeDuration;
217             remainAmount = remainAmount.sub(average);
218         }
219         fa[i] = remainAmount;
220         rt[i] = _unfreezeBeginTime;
221         
222         bi.balance = bi.balance.add(_amount);
223         bi.freezeAmount = fa;
224         bi.releaseTime = rt;
225         balances[owner].balance = balances[owner].balance.sub(_amount);
226         emit Transfer(owner, _to, _amount);
227         emit Freeze(_to, _freezeAmount);
228     }
229     
230     
231     // buy tokens directly
232     function () external payable {
233         buyTokens();
234     }
235 
236     //
237     function buyTokens() payable isRunning isBuyable onlyWhitelist  public {
238         uint256 weiVal = msg.value;
239         address investor = msg.sender;
240         require(investor != address(0) && weiVal >= minInvEth && weiVal <= maxInvEth);
241         require(weiVal.add(whitelistLimit[investor]) <= maxInvEth);
242         
243         uint256 amount = 0;
244         if(now > sellDeadline1)
245             amount = msg.value.mul(ethRate2);
246         else
247             amount = msg.value.mul(ethRate1);   
248 
249         whitelistLimit[investor] = weiVal.add(whitelistLimit[investor]);
250         
251         balances[owner].balance = balances[owner].balance.sub(amount);
252         balances[investor].balance = balances[investor].balance.add(amount);
253         emit Transfer(owner, investor, amount);
254     }
255 
256     function addWhitelist(address[] _addrs) public onlyOwner {
257         require(_addrs.length <=  255);
258 
259         for (uint8 i = 0; i < _addrs.length; i++) {
260             if (!whitelist[_addrs[i]]){
261                 whitelist[_addrs[i]] = true;
262             }
263         }
264     }
265 
266     function balanceOf(address _owner) constant public returns (uint256) {
267         return balances[_owner].balance;
268     }
269     
270     function freezeOf(address _owner) constant  public returns (uint256) {
271         BalanceInfo storage bi = balances[_owner];
272         uint freezeAmount = 0;
273         uint t = now;
274         
275         for(uint i=0;i< bi.freezeAmount.length;i++){
276             if(t < bi.releaseTime[i])
277                 freezeAmount += bi.freezeAmount[i];
278         }
279         return freezeAmount;
280     }
281     
282     function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {
283         require(_to != address(0));
284         uint freezeAmount = freezeOf(msg.sender);
285         uint256 _balance = balances[msg.sender].balance.sub(freezeAmount);
286         require(_amount <= _balance);
287         
288         balances[msg.sender].balance = balances[msg.sender].balance.sub(_amount);
289         balances[_to].balance = balances[_to].balance.add(_amount);
290         emit Transfer(msg.sender, _to, _amount);
291         return true;
292     }
293 
294     function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {
295         require(_from   != address(0) && _to != address(0));
296         require(_amount <= allowed[_from][msg.sender]);
297         uint freezeAmount = freezeOf(_from);
298         uint256 _balance = balances[_from].balance.sub(freezeAmount);
299         require(_amount <= _balance);
300         
301         balances[_from].balance = balances[_from].balance.sub(_amount);
302         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
303         balances[_to].balance = balances[_to].balance.add(_amount);
304         emit Transfer(_from, _to, _amount);
305         return true;
306     }
307 
308     function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {
309         if (_value != 0 && allowed[msg.sender][_spender] != 0) { 
310             return  false; 
311         }
312         allowed[msg.sender][_spender] = _value;
313         emit Approval(msg.sender, _spender, _value);
314         return true;
315     }
316     
317     function allowance(address _owner, address _spender) constant public returns (uint256) {
318         return allowed[_owner][_spender];
319     }
320     
321     function withdraw() onlyOwner public {
322         address myAddress = this;
323         require(myAddress.balance > 0);
324         owner.transfer(myAddress.balance);
325         emit Transfer(this, owner, myAddress.balance);    
326     }
327     
328     function burn(address burner, uint256 _value) onlyOwner public {
329         require(_value <= balances[msg.sender].balance);
330 
331         balances[burner].balance = balances[burner].balance.sub(_value);
332         totalSupply = totalSupply.sub(_value);
333         Supply = totalSupply / EthRate;
334         emit Burn(burner, _value);
335     }
336 }