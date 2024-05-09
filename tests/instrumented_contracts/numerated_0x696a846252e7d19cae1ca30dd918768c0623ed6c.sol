1 pragma solidity ^0.4.24;
2 
3 contract THESMP {   
4     string public constant name         = "THESMP";
5     string public constant symbol       = "SMP";
6     uint public constant decimals       = 18;
7     
8     uint256 smpEthRate                  = 10 ** decimals;
9     uint256 smpSupply                   = 10000000;
10     uint256 public totalSupply          = smpSupply * smpEthRate;
11     uint256 public freezeDuration       = 30 days;
12 
13     bool public running                 = true;  
14     
15     address owner;
16     mapping (address => mapping (address => uint256)) allowed;
17     mapping (address => bool) public whitelist;
18     mapping (address =>  uint256) whitelistLimit;
19 
20     struct BalanceInfo {
21         uint256 balance;
22         uint256[] freezeAmount;
23         uint256[] releaseTime;
24     }
25     mapping (address => BalanceInfo) balances;
26     
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29     event BeginRunning();
30     event PauseRunning();
31     event BeginSell();
32     event PauseSell();
33     event Burn(address indexed burner, uint256 val);
34     event Freeze(address indexed from, uint256 value);
35     
36     constructor () public{
37         owner = msg.sender;
38         balances[owner].balance = totalSupply;
39     }
40     
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45     
46     modifier onlyWhitelist() {
47         require(whitelist[msg.sender] == true);
48         _;
49     }
50     
51     modifier isRunning(){
52         require(running);
53         _;
54     }
55     modifier isNotRunning(){
56         require(!running);
57         _;
58     }
59 
60     // mitigates the ERC20 short address attack
61     modifier onlyPayloadSize(uint size) {
62         assert(msg.data.length >= size + 4);
63         _;
64     }
65 
66     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a * b;
68         assert(a == 0 || c / a == b);
69         return c;
70     }
71 
72     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
73         assert(b <= a);
74         return a - b;
75     }
76 
77     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 
83         
84     function transferOwnership(address _newOwner) onlyOwner public {
85         if (_newOwner !=    address(0)) {
86             owner = _newOwner;
87         }
88     }
89     
90     function pause() onlyOwner isRunning    public   {
91         running = false;
92         emit PauseRunning();
93     }
94     
95     function start() onlyOwner isNotRunning public   {
96         running = true;
97         emit BeginRunning();
98     }
99 
100     function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
101         require(owner != _to);
102         require(_amount > 0);
103         require(balances[owner].balance >= _amount);
104         
105         // take big number as wei
106         if(_amount < smpSupply){
107             _amount = _amount * smpEthRate;
108         }
109         balances[owner].balance = safeSub(balances[owner].balance, _amount);
110         balances[_to].balance = safeAdd(balances[_to].balance, _amount);
111         emit Transfer(owner, _to, _amount);
112     }
113     
114     
115     function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {
116         require(_addrs.length <=  255);
117         
118         for (uint8 i = 0; i < _addrs.length; i++)   {
119             airDeliver(_addrs[i],   _amount);
120         }
121     }
122     
123     function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {
124         require(_addrs.length <=  255);
125         require(_addrs.length ==     _amounts.length);
126         
127         for (uint8 i = 0; i < _addrs.length;    i++) {
128             airDeliver(_addrs[i],   _amounts[i]);
129         }
130     }
131 
132  
133     function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
134         require(owner != _to);
135         require(_freezeMonth > 0);
136         
137         uint average = _freezeAmount / _freezeMonth;
138         BalanceInfo storage bi = balances[_to];
139         uint[] memory fa = new uint[](_freezeMonth);
140         uint[] memory rt = new uint[](_freezeMonth);
141 
142         if(_amount < smpSupply){
143             _amount = _amount * smpEthRate;
144             average = average * smpEthRate;
145             _freezeAmount = _freezeAmount * smpEthRate;
146         }
147         require(balances[owner].balance > _amount);
148         uint remainAmount = _freezeAmount;
149         
150         if(_unfreezeBeginTime == 0)
151             _unfreezeBeginTime = now + freezeDuration;
152         for(uint i=0;i<_freezeMonth-1;i++){
153             fa[i] = average;
154             rt[i] = _unfreezeBeginTime;
155             _unfreezeBeginTime += freezeDuration;
156             remainAmount = safeSub(remainAmount, average);
157         }
158         fa[i] = remainAmount;
159         rt[i] = _unfreezeBeginTime;
160         
161         bi.balance = safeAdd(bi.balance, _amount);
162         bi.freezeAmount = fa;
163         bi.releaseTime = rt;
164         balances[owner].balance = safeSub(balances[owner].balance, _amount);
165         emit Transfer(owner, _to, _amount);
166         emit Freeze(_to, _freezeAmount);
167     }
168     
169     function  freezeDeliverMuti(address[] _addrs, uint _deliverAmount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
170         require(_addrs.length <=  255);
171         
172         for(uint i=0;i< _addrs.length;i++){
173             freezeDeliver(_addrs[i], _deliverAmount, _freezeAmount, _freezeMonth, _unfreezeBeginTime);
174         }
175     }
176 
177     function  freezeDeliverMultiStandalone(address[] _addrs, uint[] _deliverAmounts, uint[] _freezeAmounts, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
178         require(_addrs.length <=  255);
179         require(_addrs.length == _deliverAmounts.length);
180         require(_addrs.length == _freezeAmounts.length);
181         
182         for(uint i=0;i< _addrs.length;i++){
183             freezeDeliver(_addrs[i], _deliverAmounts[i], _freezeAmounts[i], _freezeMonth, _unfreezeBeginTime);
184         }
185     }
186     
187     function addWhitelist(address[] _addrs) public onlyOwner {
188         require(_addrs.length <=  255);
189 
190         for (uint8 i = 0; i < _addrs.length; i++) {
191             if (!whitelist[_addrs[i]]){
192                 whitelist[_addrs[i]] = true;
193             }
194         }
195     }
196 
197     function balanceOf(address _owner) constant public returns (uint256) {
198         return balances[_owner].balance;
199     }
200     
201     function freezeOf(address _owner) constant  public returns (uint256) {
202         BalanceInfo storage bi = balances[_owner];
203         uint freezeAmount = 0;
204         uint t = now;
205         
206         for(uint i=0;i< bi.freezeAmount.length;i++){
207             if(t < bi.releaseTime[i])
208                 freezeAmount += bi.freezeAmount[i];
209         }
210         return freezeAmount;
211     }
212     
213     function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {
214         require(_to != address(0));
215         uint freezeAmount = freezeOf(msg.sender);
216         uint256 _balance = safeSub(balances[msg.sender].balance, freezeAmount);
217         require(_amount <= _balance);
218         
219         balances[msg.sender].balance = safeSub(balances[msg.sender].balance,_amount);
220         balances[_to].balance = safeAdd(balances[_to].balance,_amount);
221         emit Transfer(msg.sender, _to, _amount);
222         return true;
223     }
224 
225     function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {
226         require(_from   != address(0) && _to != address(0));
227         require(_amount <= allowed[_from][msg.sender]);
228         uint freezeAmount = freezeOf(_from);
229         uint256 _balance = safeSub(balances[_from].balance, freezeAmount);
230         require(_amount <= _balance);
231         
232         balances[_from].balance = safeSub(balances[_from].balance,_amount);
233         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
234         balances[_to].balance = safeAdd(balances[_to].balance,_amount);
235         emit Transfer(_from, _to, _amount);
236         return true;
237     }
238 
239     function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {
240         if (_value != 0 && allowed[msg.sender][_spender] != 0) { 
241             return  false; 
242         }
243         allowed[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247     
248     function allowance(address _owner, address _spender) constant public returns (uint256) {
249         return allowed[_owner][_spender];
250     }
251     
252     function withdraw() onlyOwner public {
253         address myAddress = this;
254         require(myAddress.balance > 0);
255         owner.transfer(myAddress.balance);
256         emit Transfer(this, owner, myAddress.balance);    
257     }
258     
259     function burn(address burner, uint256 _value) onlyOwner public {
260         require(_value <= balances[msg.sender].balance);
261 
262         balances[burner].balance = safeSub(balances[burner].balance, _value);
263         totalSupply = safeSub(totalSupply, _value);
264         smpSupply = totalSupply / smpEthRate;
265         emit Burn(burner, _value);
266     }
267 }