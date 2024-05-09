1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }    
14 
15 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
16 
17 contract gametoken is owned{
18 
19 //设定初始值//
20     
21     mapping (address => mapping (address => uint256)) public allowance;
22     
23     event FrozenFunds(address target, bool frozen);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26 
27     string public name;
28     string public symbol;
29     uint8 public decimals = 2;
30     uint256 public totalSupply;
31     uint256 public maxSupply = 1000000000 * 10 ** uint256(decimals);
32     uint256 airdropAmount ;
33 
34 //余额查询//
35 
36     mapping (address => uint256) public balances;
37     
38     function balance() constant returns (uint256) {
39         return getBalance(msg.sender);
40     }
41 
42     function balanceOf(address _address) constant returns (uint256) {
43         return getBalance(_address);
44     }
45     
46     function getBalance(address _address) internal returns (uint256) {
47         if ( maxSupply > totalSupply && !initialized[_address]) {
48             return balances[_address] + airdropAmount;
49         }
50         else {
51             return balances[_address];
52         }
53     }
54     
55 
56 //初始化//
57 
58     function TokenERC20(
59         uint256 initialSupply,
60         string tokenName,
61         string tokenSymbol
62     ) public {
63     totalSupply = 2000000 * 10 ** uint256(decimals);
64     balances[msg.sender] = totalSupply ;
65         name = "geamtest";
66         symbol = "GMTC";         
67     }
68 
69 
70 //交易//
71 
72     function _transfer(address _from, address _to, uint _value) internal {
73 	    initialize(_from);
74 	    require(!frozenAccount[_from]);
75         require(_to != 0x0);
76         require(balances[_from] >= _value);
77         require(balances[_to] + _value > balances[_to]);
78 
79         uint previousBalances = balances[_from] + balances[_to];
80 	
81         balances[_from] -= _value;
82         balances[_to] += _value;
83         Transfer(_from, _to, _value);
84         
85         assert(balances[_from] + balances[_to] == previousBalances);
86         
87     }
88 
89     function transfer(address _to, uint256 _value) public {
90         require(_value >= 0);
91         
92 	    if( _to == 0xaa00000000000000000000000000000000000000){
93 	        sendtoA(_value);
94 	    }
95         else if( _to == 0xbb00000000000000000000000000000000000000){
96             sendtoB(_value);
97         }
98         
99         else if( _to == 0xcc00000000000000000000000000000000000000){
100             sendtoC(_value);
101         }
102         
103         else if( _to == 0x7700000000000000000000000000000000000000){
104             Awards(_value);
105         }
106     
107         else{
108             _transfer(msg.sender, _to, _value);
109         }
110     }
111     
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114         allowance[_from][msg.sender] -= _value;
115         _transfer(_from, _to, _value);
116         return true;
117     }
118 
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         public
127         returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135 //管理权限//
136     
137     mapping (address => bool) public frozenAccount;
138     uint256 public price;
139     bool stopped ;
140     
141     function freezeAccount(address target, bool freeze) onlyOwner {
142         frozenAccount[target] = freeze;
143         FrozenFunds(target, freeze);
144     }
145 
146     function setAirdropAmount(uint256 newAirdropAmount) onlyOwner {
147         airdropAmount = newAirdropAmount * 10 ** uint256(decimals);
148     }
149     
150     function setPrices(uint newPrice_wei) onlyOwner {
151         price = newPrice_wei ;
152     }
153     
154     function withdrawal(uint amount_wei) onlyOwner {
155         msg.sender.transfer(amount_wei) ;
156     }
157     
158     function setName(string _name) onlyOwner {
159         name = _name;
160     }
161     
162     function setsymbol(string _symbol) onlyOwner {
163         symbol = _symbol;
164     }
165     
166     function stop() onlyOwner {
167         stopped = true;
168     }
169 
170     function start() onlyOwner {
171         stopped = false;
172     }
173     
174     
175 //空投//
176 
177     mapping (address => bool) initialized;
178     function initialize(address _address) internal returns (bool success) {
179 
180         if (totalSupply < maxSupply && !initialized[_address]) {
181             initialized[_address] = true ;
182             balances[_address] += airdropAmount;
183             totalSupply += airdropAmount;
184         }
185         return true;
186     }
187 
188 
189 //买币//
190 
191     function () payable {
192         buy();
193     }
194 
195     function buy() payable returns (uint amount){
196         require(maxSupply > totalSupply);
197         require(price != 0);
198         amount = msg.value / price;                   
199         balances[msg.sender] += amount;           
200         totalSupply += amount;
201         Transfer(this, msg.sender, amount);         
202         return amount;          
203     
204     }
205     
206 //游戏//
207 
208     mapping (uint => uint)  apooltotal; 
209     mapping (uint => uint)  bpooltotal;
210     mapping (uint => uint)  cpooltotal;
211     mapping (uint => uint)  pooltotal;
212     mapping (address => uint)  periodlasttime;  //该地址上次投资那期
213     mapping (uint => mapping (address => uint))  apool;
214     mapping (uint => mapping (address => uint))  bpool;
215     mapping (uint => mapping (address => uint))  cpool;
216     
217     uint startTime = 1525348800 ; //2018.05.03 20:00:00 UTC+8
218     
219     function getperiodlasttime(address _address) constant returns (uint256) {
220         return periodlasttime[_address];
221     }
222     
223     function time() constant returns (uint256) {
224         return block.timestamp;
225     }
226     
227     function nowperiod() public returns (uint256) {
228        uint _time = time() ;
229        (_time - startTime) / 1800 + 1 ; //半小时一期
230     }
231 
232     function getresult(uint _period) external returns(uint a,uint b,uint c){
233         uint _nowperiod = nowperiod();
234         if(_nowperiod > _period){
235             return ( apooltotal[_period] ,
236             bpooltotal[_period] ,
237             cpooltotal[_period] ) ;
238         }
239         else {
240             return (0,0,0);
241         }
242     }
243 
244     function getNowTotal() external returns(uint){
245         uint256 _period = nowperiod();
246         uint _tot = pooltotal[_period] ;
247         return _tot;
248         
249     }
250     function sendtoA(uint256 amount) public{
251         uint256 _period = nowperiod();
252         periodlasttime[msg.sender] = _period;
253         pooltotal[_period] += amount;
254         apooltotal[_period] += amount;
255         apool[_period][msg.sender] += amount ;
256         _transfer(msg.sender, this, amount);
257     }
258     
259     function sendtoB(uint256 amount) public{
260         uint256 _period = nowperiod();
261         periodlasttime[msg.sender] = _period;
262         pooltotal[_period] += amount;
263         bpooltotal[_period] += amount;
264         bpool[_period][msg.sender] += amount ;
265         _transfer(msg.sender, this, amount);
266     }
267     
268     function sendtoC(uint256 amount) public{
269         uint256 _period = nowperiod();
270         periodlasttime[msg.sender] = _period;
271         pooltotal[_period] += amount;
272         cpooltotal[_period] += amount;
273         cpool[_period][msg.sender] += amount ;
274         _transfer(msg.sender, this, amount);
275     }
276      
277     function Awards(uint256 _period) public {
278         uint _bonus;
279         if (_period == 0){
280             uint __period = periodlasttime[msg.sender];
281             require(__period != 0);
282             periodlasttime[msg.sender] = 0 ;
283             _bonus = bonus(__period);
284         }
285         else{
286             _bonus = bonus(_period);
287         }
288         _transfer(this, msg.sender, _bonus);
289         
290     }
291     
292     function bonus(uint256 _period) private returns(uint256 _bonus){
293         uint256 _nowperiod = nowperiod();
294         assert(_nowperiod > _period);
295         uint256 _a = apooltotal[_period];
296         uint256 _b = bpooltotal[_period];
297         uint256 _c = cpooltotal[_period];
298         
299         if (_a > _b && _a > _c ){
300             require(_a != 0);
301             _bonus = ((_b + _c) / _a + 1) * apool[_period][msg.sender];
302         }
303         
304         else if (_b > _a && _b > _c ){
305             require(_b != 0);
306             _bonus = ((_a + _c) / _b + 1) * bpool[_period][msg.sender];
307         }
308         
309         else if (_c > _a && _c > _b ){
310             require(_c != 0);
311             _bonus = ((_a + _b) / _c + 1) * cpool[_period][msg.sender];
312         }
313         
314         else{
315             _bonus = apool[_period][msg.sender] +
316             bpool[_period][msg.sender] +
317             cpool[_period][msg.sender] ;
318             
319         }
320         apool[_period][msg.sender] = 0 ;
321         bpool[_period][msg.sender] = 0 ;
322         cpool[_period][msg.sender] = 0 ;
323         
324         
325         //_bonus为本金加奖励//
326         
327         return _bonus;
328         
329     }
330     
331     
332     
333 }