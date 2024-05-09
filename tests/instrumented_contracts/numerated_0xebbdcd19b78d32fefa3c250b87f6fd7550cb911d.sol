1 /*
2 
3 Website: http://secret.foundation/
4 
5 */
6 
7 pragma solidity 0.4.18;
8 
9 contract SecretToken {
10     string public symbol = "SECRET";
11     string public name = "Secret Token";
12     uint8 public constant decimals = 18;
13     uint256 _totalSupply = 0;
14     uint256 _MaxDistribPublicSupply = 300000000;
15     uint256 _OwnerDistribSupply = 0;
16     uint256 _CurrentDistribPublicSupply = 0;
17     uint256 _FreeTokens = 200;
18     uint256 _Multiplier1 = 2;
19     uint256 _Multiplier2 = 3;
20     uint256 _LimitMultiplier1 = 5e15;
21     uint256 _LimitMultiplier2 = 14e15;
22     uint256 _HighDonateLimit = 1e18;
23     uint256 _BonusTokensPerETHdonated = 300000;
24     address _DistribFundsReceiverAddress = 0;
25     address _remainingTokensReceiverAddress = 0;
26     address owner = 0;
27     bool setupDone = false;
28     bool IsDistribRunning = false;
29     bool DistribStarted = false;
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33     event Burn(address indexed _owner, uint256 _value);
34 
35     mapping(address => uint256) balances;
36     mapping(address => mapping(address => uint256)) allowed;
37     mapping(address => bool) public Claimed;
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function SecretToken() public {
45         owner = msg.sender;
46     }
47 
48     function() public payable {
49         if (IsDistribRunning) {
50             uint256 _amount;
51             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
52             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
53             if (Claimed[msg.sender] == false) {
54                 _amount = _FreeTokens * 1e18;
55                 _CurrentDistribPublicSupply += _amount;
56                 balances[msg.sender] += _amount;
57                 _totalSupply += _amount;
58                 Transfer(this, msg.sender, _amount);
59                 Claimed[msg.sender] = true;
60             }
61 
62             require(msg.value <= _HighDonateLimit);
63 
64             if (msg.value >= 1e15) {
65                 if (msg.value >= _LimitMultiplier2) {
66                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
67                 } else {
68                     if (msg.value >= _LimitMultiplier1) {
69                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
70                     } else {
71 
72                         _amount = msg.value * _BonusTokensPerETHdonated;
73 
74                     }
75 
76                 }
77 
78                 _CurrentDistribPublicSupply += _amount;
79                 balances[msg.sender] += _amount;
80                 _totalSupply += _amount;
81                 Transfer(this, msg.sender, _amount);
82             }
83 
84 
85 
86         } else {
87             revert();
88         }
89     }
90 
91     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
92         if (msg.sender == owner && !setupDone) {
93             symbol = tokenSymbol;
94             name = tokenName;
95             _FreeTokens = FreeTokens;
96             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
97             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
98             if (OwnerDistribSupply > 0) {
99                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
100                 _totalSupply = _OwnerDistribSupply;
101                 balances[owner] = _totalSupply;
102                 _CurrentDistribPublicSupply += _totalSupply;
103                 Transfer(this, owner, _totalSupply);
104             }
105             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
106             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
107             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
108 
109             setupDone = true;
110         }
111     }
112 
113     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
114         _Multiplier1 = Multiplier1inX;
115         _Multiplier2 = Multiplier2inX;
116         _LimitMultiplier1 = LimitMultiplier1inWei;
117         _LimitMultiplier2 = LimitMultiplier2inWei;
118         _HighDonateLimit = HighDonateLimitInWei;
119     }
120 
121     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
122         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
123     }
124 
125     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
126         _FreeTokens = FreeTokens;
127     }
128 
129     function StartDistrib() public returns(bool success) {
130         if (msg.sender == owner && !DistribStarted && setupDone) {
131             DistribStarted = true;
132             IsDistribRunning = true;
133         } else {
134             revert();
135         }
136         return true;
137     }
138 
139     function StopDistrib() public returns(bool success) {
140         if (msg.sender == owner && IsDistribRunning) {
141             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
142                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
143                 if (_remainingAmount > 0) {
144                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
145                     _totalSupply += _remainingAmount;
146                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
147                 }
148             }
149             DistribStarted = false;
150             IsDistribRunning = false;
151         } else {
152             revert();
153         }
154         return true;
155     }
156 
157     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
158 
159         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
160         require(addresses.length <= 255);
161         require(_amount <= _remainingAmount);
162         _amount = _amount * 1e18;
163 
164         for (uint i = 0; i < addresses.length; i++) {
165             require(_amount <= _remainingAmount);
166             _CurrentDistribPublicSupply += _amount;
167             balances[addresses[i]] += _amount;
168             _totalSupply += _amount;
169             Transfer(this, addresses[i], _amount);
170 
171         }
172 
173         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
174             DistribStarted = false;
175             IsDistribRunning = false;
176         }
177     }
178 
179     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
180 
181         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
182         uint256 _amount;
183 
184         require(addresses.length <= 255);
185         require(addresses.length == amounts.length);
186 
187         for (uint8 i = 0; i < addresses.length; i++) {
188             _amount = amounts[i] * 1e18;
189             require(_amount <= _remainingAmount);
190             _CurrentDistribPublicSupply += _amount;
191             balances[addresses[i]] += _amount;
192             _totalSupply += _amount;
193             Transfer(this, addresses[i], _amount);
194 
195 
196             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
197                 DistribStarted = false;
198                 IsDistribRunning = false;
199             }
200         }
201     }
202 
203     function BurnTokens(uint256 amount) public returns(bool success) {
204         uint256 _amount = amount * 1e18;
205         if (balances[msg.sender] >= _amount) {
206             balances[msg.sender] -= _amount;
207             _totalSupply -= _amount;
208             Burn(msg.sender, _amount);
209             Transfer(msg.sender, 0, _amount);
210         } else {
211             revert();
212         }
213         return true;
214     }
215 
216     function totalSupply() public constant returns(uint256 totalSupplyValue) {
217         return _totalSupply;
218     }
219 
220     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
221         return _MaxDistribPublicSupply;
222     }
223 
224     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
225         return _OwnerDistribSupply;
226     }
227 
228     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
229         return _CurrentDistribPublicSupply;
230     }
231 
232     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
233         return _remainingTokensReceiverAddress;
234     }
235 
236     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
237         return _DistribFundsReceiverAddress;
238     }
239 
240     function Owner() public constant returns(address ownerAddress) {
241         return owner;
242     }
243 
244     function SetupDone() public constant returns(bool setupDoneFlag) {
245         return setupDone;
246     }
247 
248     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
249         return IsDistribRunning;
250     }
251 
252     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
253         return DistribStarted;
254     }
255 
256     function balanceOf(address _owner) public constant returns(uint256 balance) {
257         return balances[_owner];
258     }
259 
260     function transfer(address _to, uint256 _amount) public returns(bool success) {
261         if (balances[msg.sender] >= _amount &&
262             _amount > 0 &&
263             balances[_to] + _amount > balances[_to]) {
264             balances[msg.sender] -= _amount;
265             balances[_to] += _amount;
266             Transfer(msg.sender, _to, _amount);
267             return true;
268         } else {
269             return false;
270         }
271     }
272 
273     function transferFrom(
274         address _from,
275         address _to,
276         uint256 _amount
277     ) public returns(bool success) {
278         if (balances[_from] >= _amount &&
279             allowed[_from][msg.sender] >= _amount &&
280             _amount > 0 &&
281             balances[_to] + _amount > balances[_to]) {
282             balances[_from] -= _amount;
283             allowed[_from][msg.sender] -= _amount;
284             balances[_to] += _amount;
285             Transfer(_from, _to, _amount);
286             return true;
287         } else {
288             return false;
289         }
290     }
291 
292     function approve(address _spender, uint256 _amount) public returns(bool success) {
293         allowed[msg.sender][_spender] = _amount;
294         Approval(msg.sender, _spender, _amount);
295         return true;
296     }
297 
298     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
299         return allowed[_owner][_spender];
300     }
301 }