1 pragma solidity ^ 0.4 .18;
2 
3 contract Token {
4     string public symbol = "";
5     string public name = "";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = 0;
8     uint256 _MaxDistribPublicSupply = 0;
9     uint256 _OwnerDistribSupply = 0;
10     uint256 _CurrentDistribPublicSupply = 0;
11     uint256 _FreeTokens = 0;
12     uint256 _Multiplier1 = 2;
13     uint256 _Multiplier2 = 3;
14     uint256 _LimitMultiplier1 = 4e15;
15     uint256 _LimitMultiplier2 = 8e15;
16     uint256 _HighDonateLimit = 5e16;
17     uint256 _BonusTokensPerETHdonated = 0;
18     address _DistribFundsReceiverAddress = 0;
19     address _remainingTokensReceiverAddress = 0;
20     address owner = 0;
21     bool setupDone = false;
22     bool IsDistribRunning = false;
23     bool DistribStarted = false;
24 
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28     event Burn(address indexed _owner, uint256 _value);
29 
30     mapping(address => uint256) balances;
31     mapping(address => mapping(address => uint256)) allowed;
32 	mapping(address => bool) public claimedAlready;
33 
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 	
39 	modifier notClaimed() {
40         require(claimedAlready[msg.sender] == false);
41         _;
42     }
43 
44 
45     function Token() public {
46         owner = msg.sender;
47     }
48 
49     function() public notClaimed payable {
50         if (IsDistribRunning) {
51             uint256 _amount;
52             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
53             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
54             _amount = _FreeTokens * 1e18;
55             _CurrentDistribPublicSupply += _amount;
56             balances[msg.sender] += _amount;
57             _totalSupply += _amount;
58             Transfer(this, msg.sender, _amount);
59             require(msg.value <= _HighDonateLimit);
60 
61             if (msg.value >= 1e15) {
62                 if (msg.value >= _LimitMultiplier2) {
63                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
64                 } else {
65                     if (msg.value >= _LimitMultiplier1) {
66                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
67                     } else {
68 
69                         _amount = msg.value * _BonusTokensPerETHdonated;
70 
71                     }
72 
73                 }
74 
75                 _CurrentDistribPublicSupply += _amount;
76                 balances[msg.sender] += _amount;
77                 _totalSupply += _amount;
78                 Transfer(this, msg.sender, _amount);
79 				claimedAlready[msg.sender]=true;
80             }
81 
82 
83 
84         } else {
85             revert();
86         }
87     }
88 
89     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
90         if (msg.sender == owner && !setupDone) {
91             symbol = tokenSymbol;
92             name = tokenName;
93             _FreeTokens = FreeTokens;
94             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
95             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
96             if (OwnerDistribSupply > 0) {
97                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
98                 _totalSupply = _OwnerDistribSupply;
99                 balances[owner] = _totalSupply;
100                 _CurrentDistribPublicSupply += _totalSupply;
101                 Transfer(this, owner, _totalSupply);
102             }
103             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
104             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
105             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
106 
107             setupDone = true;
108         }
109     }
110 
111     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
112         _Multiplier1 = Multiplier1inX;
113         _Multiplier2 = Multiplier2inX;
114         _LimitMultiplier1 = LimitMultiplier1inWei;
115         _LimitMultiplier2 = LimitMultiplier2inWei;
116         _HighDonateLimit = HighDonateLimitInWei;
117     }
118 
119     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
120         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
121     }
122 
123     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
124         _FreeTokens = FreeTokens;
125     }
126 
127     function StartDistrib() public returns(bool success) {
128         if (msg.sender == owner && !DistribStarted && setupDone) {
129             DistribStarted = true;
130             IsDistribRunning = true;
131         } else {
132             revert();
133         }
134         return true;
135     }
136 
137     function StopDistrib() public returns(bool success) {
138         if (msg.sender == owner && IsDistribRunning) {
139             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
140                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
141                 if (_remainingAmount > 0) {
142                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
143                     _totalSupply += _remainingAmount;
144                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
145                 }
146             }
147             DistribStarted = false;
148             IsDistribRunning = false;
149         } else {
150             revert();
151         }
152         return true;
153     }
154 
155     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
156 
157         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
158         require(addresses.length <= 255);
159         require(_amount <= _remainingAmount);
160         _amount = _amount * 1e18;
161 
162         for (uint i = 0; i < addresses.length; i++) {
163             require(_amount <= _remainingAmount);
164             _CurrentDistribPublicSupply += _amount;
165             balances[msg.sender] += _amount;
166             _totalSupply += _amount;
167             Transfer(this, addresses[i], _amount);
168 
169         }
170 
171         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
172             DistribStarted = false;
173             IsDistribRunning = false;
174         }
175     }
176 
177     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
178 
179         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
180         uint256 _amount;
181 
182         require(addresses.length <= 255);
183         require(addresses.length == amounts.length);
184 
185         for (uint8 i = 0; i < addresses.length; i++) {
186             _amount = amounts[i] * 1e18;
187             require(_amount <= _remainingAmount);
188             _CurrentDistribPublicSupply += _amount;
189             balances[msg.sender] += _amount;
190             _totalSupply += _amount;
191             Transfer(this, addresses[i], _amount);
192 
193 
194             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
195                 DistribStarted = false;
196                 IsDistribRunning = false;
197             }
198         }
199     }
200 
201     function BurnTokens(uint256 amountInWei) public returns(bool success) {
202         uint256 amount = amountInWei * 1e18;
203         if (balances[msg.sender] >= amount) {
204             balances[msg.sender] -= amount;
205             _totalSupply -= amount;
206             Burn(msg.sender, amount);
207             Transfer(msg.sender, 0, amount);
208         } else {
209             revert();
210         }
211         return true;
212     }
213 
214     function totalSupply() public constant returns(uint256 totalSupplyValue) {
215         return _totalSupply;
216     }
217 
218     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
219         return _MaxDistribPublicSupply;
220     }
221 
222     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
223         return _OwnerDistribSupply;
224     }
225 
226     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
227         return _CurrentDistribPublicSupply;
228     }
229 
230     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
231         return _remainingTokensReceiverAddress;
232     }
233 
234     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
235         return _DistribFundsReceiverAddress;
236     }
237 
238     function Owner() public constant returns(address ownerAddress) {
239         return owner;
240     }
241 
242     function SetupDone() public constant returns(bool setupDoneFlag) {
243         return setupDone;
244     }
245 
246     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
247         return IsDistribRunning;
248     }
249 
250     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
251         return DistribStarted;
252     }
253 
254     function balanceOf(address _owner) public constant returns(uint256 balance) {
255         return balances[_owner];
256     }
257 
258     function transfer(address _to, uint256 _amount) public returns(bool success) {
259         if (balances[msg.sender] >= _amount &&
260             _amount > 0 &&
261             balances[_to] + _amount > balances[_to]) {
262             balances[msg.sender] -= _amount;
263             balances[_to] += _amount;
264             Transfer(msg.sender, _to, _amount);
265             return true;
266         } else {
267             return false;
268         }
269     }
270 
271     function transferFrom(
272         address _from,
273         address _to,
274         uint256 _amount
275     ) public returns(bool success) {
276         if (balances[_from] >= _amount &&
277             allowed[_from][msg.sender] >= _amount &&
278             _amount > 0 &&
279             balances[_to] + _amount > balances[_to]) {
280             balances[_from] -= _amount;
281             allowed[_from][msg.sender] -= _amount;
282             balances[_to] += _amount;
283             Transfer(_from, _to, _amount);
284             return true;
285         } else {
286             return false;
287         }
288     }
289 
290     function approve(address _spender, uint256 _amount) public returns(bool success) {
291         allowed[msg.sender][_spender] = _amount;
292         Approval(msg.sender, _spender, _amount);
293         return true;
294     }
295 
296     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
297         return allowed[_owner][_spender];
298     }
299 }