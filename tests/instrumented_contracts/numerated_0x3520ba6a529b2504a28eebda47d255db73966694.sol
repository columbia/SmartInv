1 //compiler : 0.4.21+commit.dfe3193c.Emscripten.clang
2 
3 
4 
5 
6 pragma solidity 0.4.21;
7 
8 contract OmegaProtocol {
9 
10     string public symbol="OPL";
11     string public name="Omega Protocol" ;
12     uint8 public constant decimals = 18;
13     uint256 _totalSupply = 0;	
14 	uint256 _FreeQDA = 550;
15     uint256 _ML1 = 2;
16     uint256 _ML2 = 3;
17 	uint256 _ML3 = 4;
18     uint256 _LimitML1 = 3e15;
19     uint256 _LimitML2 = 6e15;
20 	uint256 _LimitML3 = 9e15;
21 	uint256 _MaxDistribPublicSupply = 250000000;
22     uint256 _OwnerDistribSupply = 0;
23     uint256 _CurrentDistribPublicSupply = 0;	
24     uint256 _ExtraTokensPerETHSended = 20000;
25     
26 	address _DistribFundsReceiverAddress = 0;
27     address _remainingTokensReceiverAddress = 0;
28     address owner = 0;
29 	
30 	
31     bool setupDone = false;
32     bool IsDistribRunning = false;
33     bool DistribStarted = false;
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     event Burn(address indexed _owner, uint256 _value);
38 
39     mapping(address => uint256) balances;
40     mapping(address => mapping(address => uint256)) allowed;
41     mapping(address => bool) public Claimed;
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function OmegaProtocol() public {
49         owner = msg.sender;
50     }
51 
52     function() public payable {
53         if (IsDistribRunning) {
54             uint256 _amount;
55             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
56             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
57             if (Claimed[msg.sender] == false) {
58                 _amount = _FreeQDA * 1e18;
59                 _CurrentDistribPublicSupply += _amount;
60                 balances[msg.sender] += _amount;
61                 _totalSupply += _amount;
62                 emit Transfer(this, msg.sender, _amount);
63                 Claimed[msg.sender] = true;
64             }
65 
66            
67 
68             if (msg.value >= 9e15) {
69             _amount = msg.value * _ExtraTokensPerETHSended * 4;
70             } else {
71                 if (msg.value >= 6e15) {
72                     _amount = msg.value * _ExtraTokensPerETHSended * 3;
73                 } else {
74                     if (msg.value >= 3e15) {
75                         _amount = msg.value * _ExtraTokensPerETHSended * 2;
76                     } else {
77 
78                         _amount = msg.value * _ExtraTokensPerETHSended;
79 
80                     }
81 
82                 }
83             }
84 			 
85 			 _CurrentDistribPublicSupply += _amount;
86                 balances[msg.sender] += _amount;
87                 _totalSupply += _amount;
88                 emit Transfer(this, msg.sender, _amount);
89         
90 
91 
92 
93         } else {
94             revert();
95         }
96     }
97 
98     function SetupQDA(string tokenName, string tokenSymbol, uint256 ExtraTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeQDA) public {
99         if (msg.sender == owner && !setupDone) {
100             symbol = tokenSymbol;
101             name = tokenName;
102             _FreeQDA = FreeQDA;
103             _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
104             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
105             if (OwnerDistribSupply > 0) {
106                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
107                 _totalSupply = _OwnerDistribSupply;
108                 balances[owner] = _totalSupply;
109                 _CurrentDistribPublicSupply += _totalSupply;
110                 emit Transfer(this, owner, _totalSupply);
111             }
112             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
113             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
114             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
115 
116             setupDone = true;
117         }
118     }
119 
120     function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {
121         _ML1 = ML1inX;
122         _ML2 = ML2inX;
123         _LimitML1 = LimitML1inWei;
124         _LimitML2 = LimitML2inWei;
125         
126     }
127 
128     function SetExtra(uint256 ExtraTokensPerETHSended) onlyOwner public {
129         _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
130     }
131 
132     function SetFreeQDA(uint256 FreeQDA) onlyOwner public {
133         _FreeQDA = FreeQDA;
134     }
135 
136     function StartDistrib() public returns(bool success) {
137         if (msg.sender == owner && !DistribStarted && setupDone) {
138             DistribStarted = true;
139             IsDistribRunning = true;
140         } else {
141             revert();
142         }
143         return true;
144     }
145 
146     function StopDistrib() public returns(bool success) {
147         if (msg.sender == owner && IsDistribRunning) {
148             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
149                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
150                 if (_remainingAmount > 0) {
151                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
152                     _totalSupply += _remainingAmount;
153                    emit Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
154                 }
155             }
156             DistribStarted = false;
157             IsDistribRunning = false;
158         } else {
159             revert();
160         }
161         return true;
162     }
163 
164     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
165 
166         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
167         require(addresses.length <= 255);
168         require(_amount <= _remainingAmount);
169         _amount = _amount * 1e18;
170 
171         for (uint i = 0; i < addresses.length; i++) {
172             require(_amount <= _remainingAmount);
173             _CurrentDistribPublicSupply += _amount;
174             balances[addresses[i]] += _amount;
175             _totalSupply += _amount;
176            emit Transfer(this, addresses[i], _amount);
177 
178         }
179 
180         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
181             DistribStarted = false;
182             IsDistribRunning = false;
183         }
184     }
185 
186     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
187 
188         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
189         uint256 _amount;
190 
191         require(addresses.length <= 255);
192         require(addresses.length == amounts.length);
193 
194         for (uint8 i = 0; i < addresses.length; i++) {
195             _amount = amounts[i] * 1e18;
196             require(_amount <= _remainingAmount);
197             _CurrentDistribPublicSupply += _amount;
198             balances[addresses[i]] += _amount;
199             _totalSupply += _amount;
200             emit Transfer(this, addresses[i], _amount);
201 
202 
203             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
204                 DistribStarted = false;
205                 IsDistribRunning = false;
206             }
207         }
208     }
209 
210     function BurnTokens(uint256 amount) public returns(bool success) {
211         uint256 _amount = amount * 1e18;
212         if (balances[msg.sender] >= _amount) {
213             balances[msg.sender] -= _amount;
214             _totalSupply -= _amount;
215             emit Burn(msg.sender, _amount);
216            emit Transfer(msg.sender, 0, _amount);
217         } else {
218             revert();
219         }
220         return true;
221     }
222 
223     function totalSupply() public constant returns(uint256 totalSupplyValue) {
224         return _totalSupply;
225     }
226 
227     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
228         return _MaxDistribPublicSupply;
229     }
230 
231     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
232         return _OwnerDistribSupply;
233     }
234 
235     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
236         return _CurrentDistribPublicSupply;
237     }
238 
239     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
240         return _remainingTokensReceiverAddress;
241     }
242 
243     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
244         return _DistribFundsReceiverAddress;
245     }
246 
247     function Owner() public constant returns(address ownerAddress) {
248         return owner;
249     }
250 
251     function SetupDone() public constant returns(bool setupDoneFlag) {
252         return setupDone;
253     }
254 
255     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
256         return IsDistribRunning;
257     }
258 
259     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
260         return DistribStarted;
261     }
262 
263     function balanceOf(address _owner) public constant returns(uint256 balance) {
264         return balances[_owner];
265     }
266 
267     function transfer(address _to, uint256 _amount) public returns(bool success) {
268         if (balances[msg.sender] >= _amount &&
269             _amount > 0 &&
270             balances[_to] + _amount > balances[_to]) {
271             balances[msg.sender] -= _amount;
272             balances[_to] += _amount;
273             emit Transfer(msg.sender, _to, _amount);
274             return true;
275         } else {
276             return false;
277         }
278     }
279 
280     function transferFrom(
281         address _from,
282         address _to,
283         uint256 _amount
284     ) public returns(bool success) {
285         if (balances[_from] >= _amount &&
286             allowed[_from][msg.sender] >= _amount &&
287             _amount > 0 &&
288             balances[_to] + _amount > balances[_to]) {
289             balances[_from] -= _amount;
290             allowed[_from][msg.sender] -= _amount;
291             balances[_to] += _amount;
292             emit Transfer(_from, _to, _amount);
293             return true;
294         } else {
295             return false;
296         }
297     }
298 
299     function approve(address _spender, uint256 _amount) public returns(bool success) {
300         allowed[msg.sender][_spender] = _amount;
301         emit Approval(msg.sender, _spender, _amount);
302         return true;
303     }
304 
305     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
306         return allowed[_owner][_spender];
307     }
308 }