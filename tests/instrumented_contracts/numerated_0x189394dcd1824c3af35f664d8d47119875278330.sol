1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-22
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 contract yolecoin {   
8     string public constant name         = "yolecoin";
9     string public constant symbol       = "yole";
10     uint public constant decimals       = 18;
11     
12     uint256 yoleEthRate                  = 10 ** decimals;
13     uint256 yoleSupply                   = 1000000000;
14     uint256 public totalSupply           = yoleSupply * yoleEthRate;
15     uint256 public freezeDuration        = 30 days;
16 
17     bool public running                 = true;  
18     
19     address owner;
20     mapping (address => mapping (address => uint256)) allowed;
21     mapping (address => bool) public whitelist;
22     mapping (address =>  uint256) whitelistLimit;
23 
24     struct BalanceInfo {
25         uint256 balance;
26         uint256[] freezeAmount;
27         uint256[] releaseTime;
28     }
29     mapping (address => BalanceInfo) balances;
30     
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33     event BeginRunning();
34     event PauseRunning();
35     event BeginSell();
36     event PauseSell();
37     event Burn(address indexed burner, uint256 val);
38     event Freeze(address indexed from, uint256 value);
39     
40     constructor () public{
41         owner = msg.sender;
42         balances[owner].balance = totalSupply;
43     }
44     
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     
50     modifier onlyWhitelist() {
51         require(whitelist[msg.sender] == true);
52         _;
53     }
54     
55     modifier isRunning(){
56         require(running);
57         _;
58     }
59     modifier isNotRunning(){
60         require(!running);
61         _;
62     }
63 
64     // mitigates the ERC20 short address attack
65     modifier onlyPayloadSize(uint size) {
66         assert(msg.data.length >= size + 4);
67         _;
68     }
69 
70     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a * b;
72         assert(a == 0 || c / a == b);
73         return c;
74     }
75 
76     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
77         assert(b <= a);
78         return a - b;
79     }
80 
81     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 
87         
88     function transferOwnership(address _newOwner) onlyOwner public {
89         if (_newOwner !=    address(0)) {
90             owner = _newOwner;
91         }
92     }
93     
94     function pause() onlyOwner isRunning    public   {
95         running = false;
96         emit PauseRunning();
97     }
98     
99     function start() onlyOwner isNotRunning public   {
100         running = true;
101         emit BeginRunning();
102     }
103 
104     function airDeliver(address _to,    uint256 _amount)  onlyOwner public {
105         require(owner != _to);
106         require(_amount > 0);
107         require(balances[owner].balance >= _amount);
108         
109         // take big number as wei
110         if(_amount < yoleSupply){
111             _amount = _amount * yoleEthRate;
112         }
113         balances[owner].balance = safeSub(balances[owner].balance, _amount);
114         balances[_to].balance = safeAdd(balances[_to].balance, _amount);
115         emit Transfer(owner, _to, _amount);
116     }
117     
118     
119     function airDeliverMulti(address[]  _addrs, uint256 _amount) onlyOwner public {
120         require(_addrs.length <=  255);
121         
122         for (uint8 i = 0; i < _addrs.length; i++)   {
123             airDeliver(_addrs[i],   _amount);
124         }
125     }
126     
127     function airDeliverStandalone(address[] _addrs, uint256[] _amounts) onlyOwner public {
128         require(_addrs.length <=  255);
129         require(_addrs.length ==     _amounts.length);
130         
131         for (uint8 i = 0; i < _addrs.length;    i++) {
132             airDeliver(_addrs[i],   _amounts[i]);
133         }
134     }
135 
136  
137     function  freezeDeliver(address _to, uint _amount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
138         require(owner != _to);
139         require(_freezeMonth > 0);
140         
141         uint average = _freezeAmount / _freezeMonth;
142         BalanceInfo storage bi = balances[_to];
143         uint[] memory fa = new uint[](_freezeMonth);
144         uint[] memory rt = new uint[](_freezeMonth);
145 
146         if(_amount < yoleSupply){
147             _amount = _amount * yoleEthRate;
148             average = average * yoleEthRate;
149             _freezeAmount = _freezeAmount * yoleEthRate;
150         }
151         require(balances[owner].balance > _amount);
152         uint remainAmount = _freezeAmount;
153         
154         if(_unfreezeBeginTime == 0)
155             _unfreezeBeginTime = now + freezeDuration;
156         for(uint i=0;i<_freezeMonth-1;i++){
157             fa[i] = average;
158             rt[i] = _unfreezeBeginTime;
159             _unfreezeBeginTime += freezeDuration;
160             remainAmount = safeSub(remainAmount, average);
161         }
162         fa[i] = remainAmount;
163         rt[i] = _unfreezeBeginTime;
164         
165         bi.balance = safeAdd(bi.balance, _amount);
166         bi.freezeAmount = fa;
167         bi.releaseTime = rt;
168         balances[owner].balance = safeSub(balances[owner].balance, _amount);
169         emit Transfer(owner, _to, _amount);
170         emit Freeze(_to, _freezeAmount);
171     }
172     
173     function  freezeDeliverMuti(address[] _addrs, uint _deliverAmount, uint _freezeAmount, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
174         require(_addrs.length <=  255);
175         
176         for(uint i=0;i< _addrs.length;i++){
177             freezeDeliver(_addrs[i], _deliverAmount, _freezeAmount, _freezeMonth, _unfreezeBeginTime);
178         }
179     }
180 
181     function  freezeDeliverMultiStandalone(address[] _addrs, uint[] _deliverAmounts, uint[] _freezeAmounts, uint _freezeMonth, uint _unfreezeBeginTime ) onlyOwner public {
182         require(_addrs.length <=  255);
183         require(_addrs.length == _deliverAmounts.length);
184         require(_addrs.length == _freezeAmounts.length);
185         
186         for(uint i=0;i< _addrs.length;i++){
187             freezeDeliver(_addrs[i], _deliverAmounts[i], _freezeAmounts[i], _freezeMonth, _unfreezeBeginTime);
188         }
189     }
190     
191     function addWhitelist(address[] _addrs) public onlyOwner {
192         require(_addrs.length <=  255);
193 
194         for (uint8 i = 0; i < _addrs.length; i++) {
195             if (!whitelist[_addrs[i]]){
196                 whitelist[_addrs[i]] = true;
197             }
198         }
199     }
200 
201     function balanceOf(address _owner) constant public returns (uint256) {
202         return balances[_owner].balance;
203     }
204     
205     function freezeOf(address _owner) constant  public returns (uint256) {
206         BalanceInfo storage bi = balances[_owner];
207         uint freezeAmount = 0;
208         uint t = now;
209         
210         for(uint i=0;i< bi.freezeAmount.length;i++){
211             if(t < bi.releaseTime[i])
212                 freezeAmount += bi.freezeAmount[i];
213         }
214         return freezeAmount;
215     }
216     
217     function transfer(address _to, uint256 _amount)  isRunning onlyPayloadSize(2 *  32) public returns (bool success) {
218         require(_to != address(0));
219         uint freezeAmount = freezeOf(msg.sender);
220         uint256 _balance = safeSub(balances[msg.sender].balance, freezeAmount);
221         require(_amount <= _balance);
222         
223         balances[msg.sender].balance = safeSub(balances[msg.sender].balance,_amount);
224         balances[_to].balance = safeAdd(balances[_to].balance,_amount);
225         emit Transfer(msg.sender, _to, _amount);
226         return true;
227     }
228 
229     function transferFrom(address _from, address _to, uint256 _amount) isRunning onlyPayloadSize(3 * 32) public returns (bool   success) {
230         require(_from   != address(0) && _to != address(0));
231         require(_amount <= allowed[_from][msg.sender]);
232         uint freezeAmount = freezeOf(_from);
233         uint256 _balance = safeSub(balances[_from].balance, freezeAmount);
234         require(_amount <= _balance);
235         
236         balances[_from].balance = safeSub(balances[_from].balance,_amount);
237         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_amount);
238         balances[_to].balance = safeAdd(balances[_to].balance,_amount);
239         emit Transfer(_from, _to, _amount);
240         return true;
241     }
242 
243     function approve(address _spender, uint256 _value) isRunning public returns (bool   success) {
244         if (_value != 0 && allowed[msg.sender][_spender] != 0) { 
245             return  false; 
246         }
247         allowed[msg.sender][_spender] = _value;
248         emit Approval(msg.sender, _spender, _value);
249         return true;
250     }
251     
252     function allowance(address _owner, address _spender) constant public returns (uint256) {
253         return allowed[_owner][_spender];
254     }
255     
256     function withdraw() onlyOwner public {
257         address myAddress = this;
258         require(myAddress.balance > 0);
259         owner.transfer(myAddress.balance);
260         emit Transfer(this, owner, myAddress.balance);    
261     }
262     
263     function burn(address burner, uint256 _value) onlyOwner public {
264         require(_value <= balances[msg.sender].balance);
265 
266         balances[burner].balance = safeSub(balances[burner].balance, _value);
267         totalSupply = safeSub(totalSupply, _value);
268         yoleSupply = totalSupply / yoleEthRate;
269         emit Burn(burner, _value);
270     }
271 }