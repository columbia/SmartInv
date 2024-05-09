1 pragma solidity ^0.4.24;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) external returns (bool);
5     function approve(address _spender, uint _value) external returns (bool);
6     function allowance(address _owner, address _spender) external view returns (uint);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 }
9 
10 interface ERC223 {
11     function transfer(address _to, uint _value, bytes _data) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
13 }
14 
15 contract ERC223ReceivingContract {
16     function tokenFallback(address _from, uint _value, bytes _data) public;
17 }
18 
19 contract Token {
20 
21     string internal _symbol;
22     string internal _name;
23 
24     uint8 internal _decimals;
25     uint internal _totalSupply;
26 
27     mapping (address => uint) internal _balanceOf;
28     mapping (address => mapping (address => uint)) internal _allowances;
29 
30     constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {
31         _symbol = symbol;
32         _name = name;
33         _decimals = decimals;
34         _totalSupply = totalSupply;
35     }
36 
37     function name()
38         public
39         view
40         returns (string) {
41         return _name;
42     }
43 
44     function symbol()
45         public
46         view
47         returns (string) {
48         return _symbol;
49     }
50 
51     function decimals()
52         public
53         view
54         returns (uint8) {
55         return _decimals;
56     }
57 
58     function totalSupply()
59         public
60         view
61         returns (uint) {
62         return _totalSupply;
63     }
64 
65     function balanceOf(address _addr) public view returns (uint);
66     function transfer(address _to, uint _value) public returns (bool);
67     event Transfer(address indexed _from, address indexed _to, uint _value);
68 }
69 
70 library SafeMath {
71     function sub(uint _base, uint _value)
72         internal
73         pure
74         returns (uint) {
75         assert(_value <= _base);
76         return _base - _value;
77     }
78 
79     function add(uint _base, uint _value)
80         internal
81         pure
82         returns (uint _ret) {
83         _ret = _base + _value;
84         assert(_ret >= _base);
85     }
86 
87     function div(uint _base, uint _value)
88         internal
89         pure
90         returns (uint) {
91         assert(_value > 0 && (_base % _value) == 0);
92         return _base / _value;
93     }
94 
95     function mul(uint _base, uint _value)
96         internal
97         pure
98         returns (uint _ret) {
99         _ret = _base * _value;
100         assert(0 == _base || _ret / _base == _value);
101     }
102 }
103 
104 library Addresses {
105     function isContract(address _base) internal view returns (bool) {
106         uint codeSize;
107             assembly {
108             codeSize := extcodesize(_base)
109             }
110         return codeSize > 0;
111     }
112 }
113 
114 contract MyToken is Token("LOCA", "Locanza", 8, 5000000000000000), ERC20, ERC223 {
115 
116     using SafeMath for uint;
117     using Addresses for address;
118 
119     address owner;
120 
121     struct lockDetail {
122         uint amount;
123         uint lockedDate;
124         uint daysLocked;
125         bool Locked;
126     }
127 
128 // to keep track of the minting stages
129 // The meaning of the 5 stages have yet to be determined
130 // minting will be done after 25 years or earlier when mining bounties are relevant
131 
132     enum Stages {
133         FirstLoyaltyProgram,
134         Stage1,
135         Stage2,
136         Stage3,
137         Stage4,
138         Stage5
139     }
140     Stages internal stage = Stages.FirstLoyaltyProgram;
141 
142 // Locked Balance + Balance = total _totalsupply
143     mapping(address=>lockDetail)  _Locked;
144 
145 //Lock event
146     event Locked(address indexed _locker, uint _amount);
147 // Unlock event
148     event Unlock(address indexed _receiver, uint _amount);
149 
150     modifier onlyOwner () {
151         require (owner == msg.sender);
152         _;
153     }
154 
155 //checked
156     constructor()
157         public {
158         owner = msg.sender;
159         _balanceOf[msg.sender] = _totalSupply;
160     }
161 
162 //checked
163     function balanceOf(address _addr)
164         public
165         view
166         returns (uint) {
167         return _balanceOf[_addr];
168     }
169 //checked
170     function transfer(address _to, uint _value)
171         public
172         returns (bool) {
173         return transfer(_to, _value, "");
174     }
175 //checked
176     function transfer(address _to, uint _value, bytes _data)
177         public
178         returns (bool) {
179         require (_value > 0 &&
180             _value <= _balanceOf[msg.sender]); 
181         
182         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
183         _balanceOf[_to] = _balanceOf[_to].add(_value);
184 
185         emit Transfer(msg.sender, _to, _value);
186 
187             if (_to.isContract()) {
188                 ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
189                 _contract.tokenFallback(msg.sender, _value, _data);
190             }
191   
192         
193 
194         return true;
195     }
196 //checked
197     function transferFrom(address _from, address _to, uint _value)
198         public
199         returns (bool) {
200         return transferFrom(_from, _to, _value, "");
201     }
202 
203 //checked
204     function transferFrom(address _from, address _to, uint _value, bytes _data)
205         public
206         returns (bool) {
207         require (_allowances[_from][msg.sender] > 0 && 
208             _value > 0 &&
209             _allowances[_from][msg.sender] >= _value &&
210             _balanceOf[_from] >= _value); 
211 
212         _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
213         _balanceOf[_from] = _balanceOf[_from].sub(_value);
214         _balanceOf[_to] = _balanceOf[_to].add(_value);
215 
216         emit Transfer(_from, _to, _value);
217 
218         if (_to.isContract()) {
219             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
220             _contract.tokenFallback(msg.sender, _value, _data);
221               }
222 
223         return true;
224         
225     }
226 // checked
227     function approve(address _spender, uint _value)
228         public
229         returns (bool) {
230         require (_balanceOf[msg.sender] >= _value && _value >= 0); 
231             _allowances[msg.sender][_spender] = _value;
232             emit Approval(msg.sender, _spender, _value);
233             return true;
234     }
235 // checked
236     function allowance(address _owner, address _spender)
237         public
238         view
239         returns (uint) {
240         
241         return _allowances[_owner][_spender];
242        
243     }
244 
245 // minting and locking functionality
246 
247 
248 // Minted coins are added to the total supply
249 // Minted coins have to be locked between 30 and 365 to protect tokenholders
250 // Only minting sets a new stage (first stage is the FirstLoyaltyProgram after initial token creation)
251 
252     function coinMinter (uint _amount, uint _days) public onlyOwner  returns (bool) {
253         require(_amount > 0);
254         // max 1 year lock only
255         require(_days > 30 && _days <= 365);
256     // this is where we eventualy set the total supply
257         require (_amount + _totalSupply <= 10000000000000000);
258         _totalSupply += _amount;
259         stage = Stages(uint(stage)+1);
260         lockAfterMinting(_amount, _days);
261         return true;
262     }
263 // Only one stage at a time can be minted
264 // Because of the internal call to lockAfterMinting
265 
266     function lockAfterMinting( uint _amount, uint _days) internal onlyOwner returns(bool) {
267      // only one token lock (per stage) is possible
268         require(_amount > 0);
269         require(_days > 30 && _days <= 365);
270         require(_Locked[msg.sender].Locked != true);
271         _Locked[msg.sender].amount = _amount;
272         _Locked[msg.sender].lockedDate = now;
273         _Locked[msg.sender].daysLocked = _days;
274         _Locked[msg.sender].Locked = true;
275         emit Locked(msg.sender, _amount);
276         return true;
277     }
278 
279     function lockOwnerBalance( uint _amount, uint _days) public onlyOwner returns(bool) {
280    // max 1 year lock only
281         require(_amount > 0);
282         require(_days > 30 && _days <= 365);
283         require(_balanceOf[msg.sender] >= _amount);
284    // only one token lock (per stage) is possible
285         require(_Locked[msg.sender].Locked != true);
286   // extract tokens from the owner balance
287         _balanceOf[msg.sender] -= _amount;
288 
289         _Locked[msg.sender].amount = _amount;
290         _Locked[msg.sender].lockedDate = now;
291         _Locked[msg.sender].daysLocked = _days;
292         _Locked[msg.sender].Locked = true;
293         emit Locked(msg.sender, _amount);
294         return true;
295     }
296 
297     function lockedBalance() public view returns(uint,uint,uint){
298         
299         return (_Locked[owner].amount,_Locked[owner].lockedDate,_Locked[owner].daysLocked) ;
300     }
301 
302 // This functions adds te locked tokens to the owner balance
303     function unlockOwnerBalance() public onlyOwner returns(bool){
304 
305         require(_Locked[msg.sender].Locked == true);
306 // require statement regarding the date time require for unlock
307 // for testing purposes only in seconds
308         require(now > _Locked[msg.sender].lockedDate + _Locked[msg.sender].daysLocked * 1 days);
309         _balanceOf[msg.sender] += _Locked[msg.sender].amount;
310         delete _Locked[msg.sender];
311 
312         emit Unlock(msg.sender, _Locked[msg.sender].amount);
313         return true;
314     }
315 
316     function getStage() public view returns(string){
317 
318         if (uint(stage)==0) {
319             return "FirstLoyalty";
320         } else if(uint(stage)==1){
321             return "Stage1";
322          } else if (uint(stage)==2){
323             return "Stage2";
324         }  else if(uint(stage)==3){
325             return "Stage3" ;
326         } else if(uint(stage)==4){
327             return "Stage4" ;
328         }else if(uint(stage)==5){
329             return "Stage5" ;
330         }
331     }
332 
333 }