1 pragma solidity 0.4.19;
2 
3 contract Chende {
4     string public symbol = "CW";
5     string public name = "Chende World";
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
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     event Burn(address indexed _owner, uint256 _value);
28 
29     mapping(address => uint256) balances;
30     mapping(address => mapping(address => uint256)) allowed;
31     mapping(address => bool) public Claimed;
32 
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     function Chende() public {
39         owner = msg.sender;
40     }
41 
42     function() public payable {
43         if (IsDistribRunning) {
44             uint256 _amount;
45             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
46             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
47             if (Claimed[msg.sender] == false) {
48                 _amount = _FreeTokens * 1e18;
49                 _CurrentDistribPublicSupply += _amount;
50                 balances[msg.sender] += _amount;
51                 _totalSupply += _amount;
52                 Transfer(this, msg.sender, _amount);
53                 Claimed[msg.sender] = true;
54             }
55 
56             require(msg.value <= _HighDonateLimit);
57 
58             if (msg.value >= 1e15) {
59                 if (msg.value >= _LimitMultiplier2) {
60                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
61                 } else {
62                     if (msg.value >= _LimitMultiplier1) {
63                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
64                     } else {
65 
66                         _amount = msg.value * _BonusTokensPerETHdonated;
67 
68                     }
69 
70                 }
71 
72                 _CurrentDistribPublicSupply += _amount;
73                 balances[msg.sender] += _amount;
74                 _totalSupply += _amount;
75                 Transfer(this, msg.sender, _amount);
76             }
77 
78 
79 
80         } else {
81             revert();
82         }
83     }
84 
85     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
86         if (msg.sender == owner && !setupDone) {
87             symbol = tokenSymbol;
88             name = tokenName;
89             _FreeTokens = FreeTokens;
90             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
91             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
92             if (OwnerDistribSupply > 0) {
93                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
94                 _totalSupply = _OwnerDistribSupply;
95                 balances[owner] = _totalSupply;
96                 _CurrentDistribPublicSupply += _totalSupply;
97                 Transfer(this, owner, _totalSupply);
98             }
99             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
100             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
101             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
102 
103             setupDone = true;
104         }
105     }
106 
107     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
108         _Multiplier1 = Multiplier1inX;
109         _Multiplier2 = Multiplier2inX;
110         _LimitMultiplier1 = LimitMultiplier1inWei;
111         _LimitMultiplier2 = LimitMultiplier2inWei;
112         _HighDonateLimit = HighDonateLimitInWei;
113     }
114 
115     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
116         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
117     }
118 
119     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
120         _FreeTokens = FreeTokens;
121     }
122 
123     function StartDistrib() public returns(bool success) {
124         if (msg.sender == owner && !DistribStarted && setupDone) {
125             DistribStarted = true;
126             IsDistribRunning = true;
127         } else {
128             revert();
129         }
130         return true;
131     }
132 
133     function StopDistrib() public returns(bool success) {
134         if (msg.sender == owner && IsDistribRunning) {
135             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
136                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
137                 if (_remainingAmount > 0) {
138                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
139                     _totalSupply += _remainingAmount;
140                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
141                 }
142             }
143             DistribStarted = false;
144             IsDistribRunning = false;
145         } else {
146             revert();
147         }
148         return true;
149     }
150 
151     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
152 
153         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
154         require(addresses.length <= 255);
155         require(_amount <= _remainingAmount);
156         _amount = _amount * 1e18;
157 
158         for (uint i = 0; i < addresses.length; i++) {
159             require(_amount <= _remainingAmount);
160             _CurrentDistribPublicSupply += _amount;
161             balances[addresses[i]] += _amount;
162             _totalSupply += _amount;
163             Transfer(this, addresses[i], _amount);
164 
165         }
166 
167         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
168             DistribStarted = false;
169             IsDistribRunning = false;
170         }
171     }
172 
173     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
174 
175         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
176         uint256 _amount;
177 
178         require(addresses.length <= 255);
179         require(addresses.length == amounts.length);
180 
181         for (uint8 i = 0; i < addresses.length; i++) {
182             _amount = amounts[i] * 1e18;
183             require(_amount <= _remainingAmount);
184             _CurrentDistribPublicSupply += _amount;
185             balances[addresses[i]] += _amount;
186             _totalSupply += _amount;
187             Transfer(this, addresses[i], _amount);
188 
189 
190             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
191                 DistribStarted = false;
192                 IsDistribRunning = false;
193             }
194         }
195     }
196 
197     function BurnTokens(uint256 amount) public returns(bool success) {
198         uint256 _amount = amount * 1e18;
199         if (balances[msg.sender] >= _amount) {
200             balances[msg.sender] -= _amount;
201             _totalSupply -= _amount;
202             Burn(msg.sender, _amount);
203             Transfer(msg.sender, 0, _amount);
204         } else {
205             revert();
206         }
207         return true;
208     }
209 
210     function totalSupply() public constant returns(uint256 totalSupplyValue) {
211         return _totalSupply;
212     }
213 
214     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
215         return _MaxDistribPublicSupply;
216     }
217 
218     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
219         return _OwnerDistribSupply;
220     }
221 
222     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
223         return _CurrentDistribPublicSupply;
224     }
225 
226     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
227         return _remainingTokensReceiverAddress;
228     }
229 
230     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
231         return _DistribFundsReceiverAddress;
232     }
233 
234     function Owner() public constant returns(address ownerAddress) {
235         return owner;
236     }
237 
238     function SetupDone() public constant returns(bool setupDoneFlag) {
239         return setupDone;
240     }
241 
242     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
243         return IsDistribRunning;
244     }
245 
246     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
247         return DistribStarted;
248     }
249 
250     function balanceOf(address _owner) public constant returns(uint256 balance) {
251         return balances[_owner];
252     }
253 
254     function transfer(address _to, uint256 _amount) public returns(bool success) {
255         if (balances[msg.sender] >= _amount &&
256             _amount > 0 &&
257             balances[_to] + _amount > balances[_to]) {
258             balances[msg.sender] -= _amount;
259             balances[_to] += _amount;
260             Transfer(msg.sender, _to, _amount);
261             return true;
262         } else {
263             return false;
264         }
265     }
266 
267     function transferFrom(
268         address _from,
269         address _to,
270         uint256 _amount
271     ) public returns(bool success) {
272         if (balances[_from] >= _amount &&
273             allowed[_from][msg.sender] >= _amount &&
274             _amount > 0 &&
275             balances[_to] + _amount > balances[_to]) {
276             balances[_from] -= _amount;
277             allowed[_from][msg.sender] -= _amount;
278             balances[_to] += _amount;
279             Transfer(_from, _to, _amount);
280             return true;
281         } else {
282             return false;
283         }
284     }
285 
286     function approve(address _spender, uint256 _amount) public returns(bool success) {
287         allowed[msg.sender][_spender] = _amount;
288         Approval(msg.sender, _spender, _amount);
289         return true;
290     }
291 
292     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
293         return allowed[_owner][_spender];
294     }
295 }