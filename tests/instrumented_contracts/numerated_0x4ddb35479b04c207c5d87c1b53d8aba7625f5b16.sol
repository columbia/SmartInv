1 pragma solidity ^0.4.18;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 
34     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a >= b ? a : b;
36     }
37 
38     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a < b ? a : b;
40     }
41 }
42 
43 contract ERC20Token {
44     uint256 public totalSupply;
45     function balanceOf(address _owner) public view  returns (uint256 balance);
46     function transfer(address _to, uint256 _value) public returns  (bool );
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 }
50 
51 contract HHLCTOKEN is ERC20Token {
52     using SafeMath for uint256;
53 
54     address public manager;
55     modifier onlyManager() {
56         require(msg.sender == manager);
57         _;
58     }
59     
60     mapping(address => uint256) public balances;
61     mapping (address => mapping (address => uint256 )) allowed;
62 
63     uint256 exchangeTimestamp;
64 
65     uint256[] public privateTimes;
66     uint256[] public airdropTimes;
67 
68     uint256[] public privateRates=[50,60,70,80,90,100];
69     uint256[] public airdropRates=[5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100];
70 
71     struct LockRuler {
72         uint256 utype;
73         uint256 money;
74     }
75 
76     mapping (address => LockRuler[]) public  mapLockRulers;
77 
78     function transfer( address _to, uint256 _value )
79     public 
80     returns (bool success)
81     {
82 
83         if( mapLockRulers[msg.sender].length > 0 ){
84 
85             require (exchangeTimestamp > 0);
86 
87             uint256 _lockMoney = 0;
88             uint256 _preMoney = 0;
89             uint256 _idx = 0;
90             uint256 _idx2 = 0;
91             uint256 _rate = 0;
92             uint256 _hundred = 100;
93             uint256 _var1 = 0;
94             uint256 _var2 = 0;
95             uint256 _var3 = 0;
96 
97             for( _idx = 0; _idx < mapLockRulers[msg.sender].length; _idx++ ){
98 
99 
100                 if( mapLockRulers[msg.sender][_idx].utype == 0){
101 
102                     for( _idx2 = 0; _idx2 < privateTimes.length -1; _idx2++ ){
103 
104                         if(privateTimes[_idx2]<=block.timestamp && block.timestamp < privateTimes[_idx2+1]){
105                             _rate = privateRates[_idx2];
106 
107                             _var1 = _hundred.sub(_rate);
108                             _var2 = _var1.mul(mapLockRulers[msg.sender][_idx].money);
109                             _var3 = _var2.div(_hundred);
110 
111                             _lockMoney = _lockMoney.add(_var3 );
112                             break;
113 
114                         }else if( block.timestamp > privateTimes[privateTimes.length -1] ){
115 
116                             _lockMoney = _lockMoney.add(0);
117                             break;
118 
119                         }else if(block.timestamp<privateTimes[0]){
120 
121                             _lockMoney = _lockMoney.add(mapLockRulers[msg.sender][_idx].money);
122                             break;
123 
124                         }
125                     }
126 
127                 }
128 
129                 if(mapLockRulers[msg.sender][_idx].utype == 1){
130 
131                     for( _idx2 = 0; _idx2 < airdropTimes.length -1; _idx2++ ){
132 
133                         if(airdropTimes[_idx2] <= block.timestamp && block.timestamp <= airdropTimes[_idx2+1]){
134                             _rate = airdropRates[_idx2];
135 
136                             _var1 = _hundred.sub(_rate);
137                             _var2 = _var1.mul(mapLockRulers[msg.sender][_idx].money);
138                             _var3 = _var2.div(_hundred);
139 
140                             _lockMoney = _lockMoney.add(_var3 );
141                             break;
142 
143                         }else if( block.timestamp > airdropTimes[airdropTimes.length -1] ){
144 
145                             _lockMoney = _lockMoney.add(0);
146                             break;
147 
148                         }else if(block.timestamp < airdropTimes[0]){
149 
150                             _lockMoney = _lockMoney.add(mapLockRulers[msg.sender][_idx].money);
151                             break;
152 
153                         }
154 
155                     }
156 
157                 }
158             }
159 
160             _preMoney = _value.add(_lockMoney);
161 
162             require ( _preMoney <= balances[msg.sender] );
163             return _transfer(_to, _value);
164 
165         }else{
166 
167             return _transfer(_to, _value);
168 
169         }
170     }
171 
172     function _transfer(address _to, uint256 _value)
173     internal returns (bool success){
174 
175         require(_to != 0x0);
176         require(_value > 0);
177         require(balances[msg.sender] >= _value);
178 
179         uint256 previousBalances = balances[msg.sender] + balances[_to];
180         balances[msg.sender] = balances[msg.sender].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         emit Transfer(msg.sender, _to, _value);
183         assert(balances[msg.sender] + balances[_to] == previousBalances);
184         return true;
185     }
186 
187     function balanceOf(address _owner)
188     public
189     view
190     returns (uint balance) {
191         return balances[_owner];
192     }
193 
194 
195     function allowance(address _owner, address _spender)
196     public
197     view
198     returns (uint256){
199         return allowed[_owner][_spender];
200     }
201 
202     event NewToken(uint256 indexed _decimals, uint256  _totalSupply, string  _tokenName, string  _tokenSymbol);
203 
204     string public name;
205     string public symbol;
206     uint256 public decimals;
207 
208 
209     constructor(
210         uint256 _initialAmount,
211         uint256 _decimals,
212         string _tokenName,
213         string _tokenSymbol
214     )public{
215 
216         require (_decimals > 0);
217         require (_initialAmount > 0);
218         require (bytes(_tokenName).length>0);
219         require (bytes(_tokenSymbol).length>0);
220 
221         manager = msg.sender;
222 
223         decimals = _decimals;
224         totalSupply = _initialAmount * (10 ** uint256(decimals));
225         balances[manager] = totalSupply;
226         name = _tokenName;
227         symbol = _tokenSymbol;
228 
229 
230         exchangeTimestamp = 0;
231 
232 
233         emit NewToken(_decimals, totalSupply, name, symbol);
234     }
235 
236 
237     function addAirdropUsers( address[] _accounts, uint256[] _moneys )
238     onlyManager
239     public{
240 
241         require (_accounts.length > 0);
242         require (_accounts.length == _moneys.length);
243 
244         uint256 _totalMoney = 0;
245         uint256 _idx = 0;
246 
247         for(_idx = 0; _idx < _moneys.length; _idx++){
248             _totalMoney += _moneys[_idx];
249         }
250 
251         require ( _totalMoney <= balances[manager] );
252 
253 
254         for( _idx = 0; _idx < _accounts.length; _idx++ ){
255 
256             LockRuler memory _lockRuler = LockRuler({
257                 money:_moneys[_idx],
258                 utype:1
259             });
260 
261             mapLockRulers[_accounts[_idx]].push(_lockRuler);
262             _transfer(_accounts[_idx], _moneys[_idx]);
263         }
264 
265     }
266 
267 
268     function addPrivateUsers( address[] _accounts, uint256[] _moneys )
269     onlyManager
270     public{
271 
272         require (_accounts.length > 0);
273         require (_accounts.length == _moneys.length);
274 
275         uint256 _totalMoney = 0;
276         uint256 _idx = 0;
277 
278         for(_idx = 0; _idx < _moneys.length; _idx++){
279             _totalMoney = _totalMoney.add(_moneys[_idx]) ;
280         }
281 
282         require ( _totalMoney <= balances[manager] );
283 
284 
285         for( _idx = 0; _idx < _accounts.length; _idx++ ){
286 
287             LockRuler memory _lockRuler = LockRuler({
288                 money:_moneys[_idx],
289                 utype:0
290             });
291 
292             mapLockRulers[_accounts[_idx]].push(_lockRuler);
293             _transfer(_accounts[_idx], _moneys[_idx]);
294 
295         }
296 
297     }
298 
299 
300     function addExchangeTime( uint256 _time )
301     onlyManager
302     public{
303         require (_time > 0);
304         require (privateTimes.length == 0);
305         require (airdropTimes.length == 0);
306 
307 
308         exchangeTimestamp = _time;
309 
310         uint256 _idx = 0;
311         for(_idx = 0; _idx < privateRates.length; _idx++){
312             privateTimes.push( _getDate(_time, _idx) );
313         }
314 
315 
316 
317         for(_idx = 0; _idx < airdropRates.length; _idx++){
318             airdropTimes.push( _getDate(_time, _idx) );
319         }
320 
321     }
322 
323     function _getDate(uint256 start, uint256 daysAfter)
324     internal
325     pure
326     returns (uint256){
327         daysAfter = daysAfter.mul(60);
328         return start + daysAfter * 1 days;
329     }  
330 }