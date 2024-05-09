1 contract TradeBox {
2     string public symbol = "TBox";
3     string public name = "Trade Box";
4     uint8 public constant decimals = 18;
5     uint256 _totalSupply = 0;
6     uint256 _MaxDistribPublicSupply = 0;
7     uint256 _OwnerDistribSupply = 0;
8     uint256 _CurrentDistribPublicSupply = 0;
9     uint256 _FreeTokens = 0;
10     uint256 _Multiplier1 = 2;
11     uint256 _Multiplier2 = 3;
12     uint256 _LimitMultiplier1 = 4e15;
13     uint256 _LimitMultiplier2 = 8e15;
14     uint256 _HighDonateLimit = 5e16;
15     uint256 _BonusTokensPerETHdonated = 0;
16     address _DistribFundsReceiverAddress = 0;
17     address _remainingTokensReceiverAddress = 0;
18     address owner = 0;
19     bool setupDone = false;
20     bool IsDistribRunning = false;
21     bool DistribStarted = false;
22 
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     event Burn(address indexed _owner, uint256 _value);
26 
27     mapping(address => uint256) balances;
28     mapping(address => mapping(address => uint256)) allowed;
29     mapping(address => bool) public Claimed;
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     function TradeBox() public {
37         owner = msg.sender;
38     }
39 
40     function() public payable {
41         if (IsDistribRunning) {
42             uint256 _amount;
43             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
44             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
45             if (Claimed[msg.sender] == false) {
46                 _amount = _FreeTokens * 1e18;
47                 _CurrentDistribPublicSupply += _amount;
48                 balances[msg.sender] += _amount;
49                 _totalSupply += _amount;
50                 Transfer(this, msg.sender, _amount);
51                 Claimed[msg.sender] = true;
52             }
53 
54             require(msg.value <= _HighDonateLimit);
55 
56             if (msg.value >= 1e15) {
57                 if (msg.value >= _LimitMultiplier2) {
58                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
59                 } else {
60                     if (msg.value >= _LimitMultiplier1) {
61                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
62                     } else {
63 
64                         _amount = msg.value * _BonusTokensPerETHdonated;
65 
66                     }
67 
68                 }
69 
70                 _CurrentDistribPublicSupply += _amount;
71                 balances[msg.sender] += _amount;
72                 _totalSupply += _amount;
73                 Transfer(this, msg.sender, _amount);
74             }
75 
76 
77 
78         } else {
79             revert();
80         }
81     }
82 
83     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
84         if (msg.sender == owner && !setupDone) {
85             symbol = tokenSymbol;
86             name = tokenName;
87             _FreeTokens = FreeTokens;
88             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
89             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
90             if (OwnerDistribSupply > 0) {
91                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
92                 _totalSupply = _OwnerDistribSupply;
93                 balances[owner] = _totalSupply;
94                 _CurrentDistribPublicSupply += _totalSupply;
95                 Transfer(this, owner, _totalSupply);
96             }
97             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
98             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
99             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
100 
101             setupDone = true;
102         }
103     }
104 
105     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
106         _Multiplier1 = Multiplier1inX;
107         _Multiplier2 = Multiplier2inX;
108         _LimitMultiplier1 = LimitMultiplier1inWei;
109         _LimitMultiplier2 = LimitMultiplier2inWei;
110         _HighDonateLimit = HighDonateLimitInWei;
111     }
112 
113     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
114         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
115     }
116 
117     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
118         _FreeTokens = FreeTokens;
119     }
120 
121     function StartDistrib() public returns(bool success) {
122         if (msg.sender == owner && !DistribStarted && setupDone) {
123             DistribStarted = true;
124             IsDistribRunning = true;
125         } else {
126             revert();
127         }
128         return true;
129     }
130 
131     function StopDistrib() public returns(bool success) {
132         if (msg.sender == owner && IsDistribRunning) {
133             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
134                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
135                 if (_remainingAmount > 0) {
136                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
137                     _totalSupply += _remainingAmount;
138                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
139                 }
140             }
141             DistribStarted = false;
142             IsDistribRunning = false;
143         } else {
144             revert();
145         }
146         return true;
147     }
148 
149     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
150 
151         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
152         require(addresses.length <= 255);
153         require(_amount <= _remainingAmount);
154         _amount = _amount * 1e18;
155 
156         for (uint i = 0; i < addresses.length; i++) {
157             require(_amount <= _remainingAmount);
158             _CurrentDistribPublicSupply += _amount;
159             balances[addresses[i]] += _amount;
160             _totalSupply += _amount;
161             Transfer(this, addresses[i], _amount);
162 
163         }
164 
165         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
166             DistribStarted = false;
167             IsDistribRunning = false;
168         }
169     }
170 
171     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
172 
173         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
174         uint256 _amount;
175 
176         require(addresses.length <= 255);
177         require(addresses.length == amounts.length);
178 
179         for (uint8 i = 0; i < addresses.length; i++) {
180             _amount = amounts[i] * 1e18;
181             require(_amount <= _remainingAmount);
182             _CurrentDistribPublicSupply += _amount;
183             balances[addresses[i]] += _amount;
184             _totalSupply += _amount;
185             Transfer(this, addresses[i], _amount);
186 
187 
188             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
189                 DistribStarted = false;
190                 IsDistribRunning = false;
191             }
192         }
193     }
194 
195     function BurnTokens(uint256 amount) public returns(bool success) {
196         uint256 _amount = amount * 1e18;
197         if (balances[msg.sender] >= _amount) {
198             balances[msg.sender] -= _amount;
199             _totalSupply -= _amount;
200             Burn(msg.sender, _amount);
201             Transfer(msg.sender, 0, _amount);
202         } else {
203             revert();
204         }
205         return true;
206     }
207 
208     function totalSupply() public constant returns(uint256 totalSupplyValue) {
209         return _totalSupply;
210     }
211 
212     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
213         return _MaxDistribPublicSupply;
214     }
215 
216     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
217         return _OwnerDistribSupply;
218     }
219 
220     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
221         return _CurrentDistribPublicSupply;
222     }
223 
224     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
225         return _remainingTokensReceiverAddress;
226     }
227 
228     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
229         return _DistribFundsReceiverAddress;
230     }
231 
232     function Owner() public constant returns(address ownerAddress) {
233         return owner;
234     }
235 
236     function SetupDone() public constant returns(bool setupDoneFlag) {
237         return setupDone;
238     }
239 
240     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
241         return IsDistribRunning;
242     }
243 
244     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
245         return DistribStarted;
246     }
247 
248     function balanceOf(address _owner) public constant returns(uint256 balance) {
249         return balances[_owner];
250     }
251 
252     function transfer(address _to, uint256 _amount) public returns(bool success) {
253         if (balances[msg.sender] >= _amount &&
254             _amount > 0 &&
255             balances[_to] + _amount > balances[_to]) {
256             balances[msg.sender] -= _amount;
257             balances[_to] += _amount;
258             Transfer(msg.sender, _to, _amount);
259             return true;
260         } else {
261             return false;
262         }
263     }
264 
265     function transferFrom(
266         address _from,
267         address _to,
268         uint256 _amount
269     ) public returns(bool success) {
270         if (balances[_from] >= _amount &&
271             allowed[_from][msg.sender] >= _amount &&
272             _amount > 0 &&
273             balances[_to] + _amount > balances[_to]) {
274             balances[_from] -= _amount;
275             allowed[_from][msg.sender] -= _amount;
276             balances[_to] += _amount;
277             Transfer(_from, _to, _amount);
278             return true;
279         } else {
280             return false;
281         }
282     }
283 
284     function approve(address _spender, uint256 _amount) public returns(bool success) {
285         allowed[msg.sender][_spender] = _amount;
286         Approval(msg.sender, _spender, _amount);
287         return true;
288     }
289 
290     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
291         return allowed[_owner][_spender];
292     }
293 }