1 pragma solidity ^0.4.24;
2 //
3 // Odin Browser Token
4 // Author: Odin browser group
5 // Contact: support@odinlink.com
6 // Home page: https://www.odinlink.com
7 // Telegram:  https://t.me/OdinChain666666
8 //
9 library SafeMath{
10 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 		uint256 c = a * b;
12 		assert(a == 0 || c / a == b);
13 		return c;
14 	}
15 
16 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
17 		uint256 c = a / b;
18 		return c;
19 	}
20 
21 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 		assert(b <= a);
23 		return a - b;
24 	}
25 
26 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
27 		uint256 c = a + b;
28 		assert(c >= a);
29 		return c;
30 	}
31 }
32 
33 contract OdinToken {
34 	using SafeMath for uint256;
35     string public constant name         = "OdinBrowser";
36     string public constant symbol       = "ODIN";
37     uint public constant decimals       = 18;
38     
39     uint256 OdinEthRate                  = 10 ** decimals;
40     uint256 OdinSupply                   = 15000000000;
41     uint256 public totalSupply          = OdinSupply * OdinEthRate;
42     uint256 public minInvEth            = 0.1 ether;
43     uint256 public maxInvEth            = 1000.0 ether;
44     uint256 public sellStartTime        = 1533052800;           // 2018/8/1
45     uint256 public sellDeadline1        = sellStartTime + 30 days;
46     uint256 public sellDeadline2        = sellDeadline1 + 30 days;
47     uint256 public freezeDuration       = 30 days;
48     uint256 public ethOdinRate1          = 3600;
49     uint256 public ethOdinRate2          = 3600;
50 
51     bool public running                 = true;
52     bool public buyable                 = true;
53     
54     address owner;
55     mapping (address => mapping (address => uint256)) allowed;
56     mapping (address => bool) public whitelist;
57     mapping (address =>  uint256) whitelistLimit;
58 
59     struct BalanceInfo {
60         uint256 balance;
61         uint256[] freezeAmount;
62         uint256[] releaseTime;
63     }
64     mapping (address => BalanceInfo) balances;
65     
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68     event BeginRunning();
69     event Pause();
70     event BeginSell();
71     event PauseSell();
72     event Burn(address indexed burner, uint256 val);
73     event Freeze(address indexed from, uint256 value);
74     
75     constructor () public{
76         owner = msg.sender;
77         balances[owner].balance = totalSupply;
78     }
79     
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     modifier onlyWhitelist() {
86         require(whitelist[msg.sender] == true);
87         _;
88     }
89     
90     modifier isRunning(){
91         require(running);
92         _;
93     }
94     modifier isNotRunning(){
95         require(!running);
96         _;
97     }
98     modifier isBuyable(){
99         require(buyable && now >= sellStartTime && now <= sellDeadline2);
100         _;
101     }
102     modifier isNotBuyable(){
103         require(!buyable || now < sellStartTime || now > sellDeadline2);
104         _;
105     }
106     // mitigates the ERC20 short address attack
107     modifier onlyPayloadSize(uint size) {
108         assert(msg.data.length >= size + 4);
109         _;
110     }
111 
112     // 1eth = newRate tokens
113     function setPublicOfferPrice(uint256 _rate1, uint256 _rate2) onlyOwner public {
114         ethOdinRate1 = _rate1;
115         ethOdinRate2 = _rate2;       
116     }
117 
118     //
119     function setPublicOfferLimit(uint256 _minVal, uint256 _maxVal) onlyOwner public {
120         minInvEth   = _minVal;
121         maxInvEth   = _maxVal;
122     }
123     
124     function setPublicOfferDate(uint256 _startTime, uint256 _deadLine1, uint256 _deadLine2) onlyOwner public {
125         sellStartTime = _startTime;
126         sellDeadline1   = _deadLine1;
127         sellDeadline2   = _deadLine2;
128     }
129         
130     function transferOwnership(address _newOwner) onlyOwner public {
131         if (_newOwner !=    address(0)) {
132             owner = _newOwner;
133         }
134     }
135     
136     function pause() onlyOwner isRunning    public   {
137         running = false;
138         emit Pause();
139     }
140     
141     function start() onlyOwner isNotRunning public   {
142         running = true;
143         emit BeginRunning();
144     }
145 
146     function pauseSell() onlyOwner  isBuyable isRunning public{
147         buyable = false;
148         emit PauseSell();
149     }
150     
151     function beginSell() onlyOwner  isNotBuyable isRunning  public{
152         buyable = true;
153         emit BeginSell();
154     }
155 
156     //
157     // _amount in Odin, 
158     //
159     function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
160         require(owner != _to);
161         require(_amount > 0);
162         require(balances[owner].balance >= _amount);
163         
164         // take big number as wei
165         if(_amount < OdinSupply){
166             _amount = _amount * OdinEthRate;
167         }
168         balances[owner].balance = balances[owner].balance.sub(_amount);
169         balances[_to].balance = balances[_to].balance.add(_amount);
170         emit Transfer(owner, _to, _amount);
171     }
172     
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
184         require(_addrs.length ==     _amounts.length);
185         
186         for (uint8 i = 0; i < _addrs.length;    i++) {
187             airDeliver(_addrs[i],   _amounts[i]);
188         }
189     }
190 
191     //
192     // _amount, _freezeAmount in Odin
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
203         if(_amount < OdinSupply){
204             _amount = _amount * OdinEthRate;
205             average = average * OdinEthRate;
206             _freezeAmount = _freezeAmount * OdinEthRate;
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
245             amount = msg.value.mul(ethOdinRate2);
246         else
247             amount = msg.value.mul(ethOdinRate1);   
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
333         OdinSupply = totalSupply / OdinEthRate;
334         emit Burn(burner, _value);
335     }
336 }