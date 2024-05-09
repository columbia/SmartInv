1 /*
2 
3 The Neodium Network is a global decentralized patent ecosystem. Our technology simplifies the process of submitting patents and allows for the voice of the community to be heard through a consensus system. Patents will be stored on the blockchain, making them immutable and secure. Licensing patents will be done through smart contracts, ensuring that all parties meet the agreed upon terms.
4 
5 Website: https://neodium.network/
6 
7 */
8 
9 pragma solidity 0.4.18;
10 
11 contract NeodiumNetwork {
12     string public symbol = "NN";
13     string public name = "Neodium Network";
14     uint8 public constant decimals = 18;
15     uint256 _totalSupply = 0;
16     uint256 _MaxDistribPublicSupply = 0;
17     uint256 _OwnerDistribSupply = 0;
18     uint256 _CurrentDistribPublicSupply = 0;
19     uint256 _FreeTokens = 0;
20     uint256 _Multiplier1 = 2;
21     uint256 _Multiplier2 = 3;
22     uint256 _LimitMultiplier1 = 4e15;
23     uint256 _LimitMultiplier2 = 8e15;
24     uint256 _HighDonateLimit = 5e16;
25     uint256 _BonusTokensPerETHdonated = 0;
26     address _DistribFundsReceiverAddress = 0;
27     address _remainingTokensReceiverAddress = 0;
28     address owner = 0;
29     bool setupDone = false;
30     bool IsDistribRunning = false;
31     bool DistribStarted = false;
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     event Burn(address indexed _owner, uint256 _value);
36 
37     mapping(address => uint256) balances;
38     mapping(address => mapping(address => uint256)) allowed;
39     mapping(address => bool) public Claimed;
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function NeodiumNetwork() public {
47         owner = msg.sender;
48     }
49 
50     function() public payable {
51         if (IsDistribRunning) {
52             uint256 _amount;
53             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
54             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
55             if (Claimed[msg.sender] == false) {
56                 _amount = _FreeTokens * 1e18;
57                 _CurrentDistribPublicSupply += _amount;
58                 balances[msg.sender] += _amount;
59                 _totalSupply += _amount;
60                 Transfer(this, msg.sender, _amount);
61                 Claimed[msg.sender] = true;
62             }
63 
64             require(msg.value <= _HighDonateLimit);
65 
66             if (msg.value >= 1e15) {
67                 if (msg.value >= _LimitMultiplier2) {
68                     _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
69                 } else {
70                     if (msg.value >= _LimitMultiplier1) {
71                         _amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
72                     } else {
73 
74                         _amount = msg.value * _BonusTokensPerETHdonated;
75 
76                     }
77 
78                 }
79 
80                 _CurrentDistribPublicSupply += _amount;
81                 balances[msg.sender] += _amount;
82                 _totalSupply += _amount;
83                 Transfer(this, msg.sender, _amount);
84             }
85 
86 
87 
88         } else {
89             revert();
90         }
91     }
92 
93     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
94         if (msg.sender == owner && !setupDone) {
95             symbol = tokenSymbol;
96             name = tokenName;
97             _FreeTokens = FreeTokens;
98             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
99             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
100             if (OwnerDistribSupply > 0) {
101                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
102                 _totalSupply = _OwnerDistribSupply;
103                 balances[owner] = _totalSupply;
104                 _CurrentDistribPublicSupply += _totalSupply;
105                 Transfer(this, owner, _totalSupply);
106             }
107             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
108             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
109             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
110 
111             setupDone = true;
112         }
113     }
114 
115     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 HighDonateLimitInWei) onlyOwner public {
116         _Multiplier1 = Multiplier1inX;
117         _Multiplier2 = Multiplier2inX;
118         _LimitMultiplier1 = LimitMultiplier1inWei;
119         _LimitMultiplier2 = LimitMultiplier2inWei;
120         _HighDonateLimit = HighDonateLimitInWei;
121     }
122 
123     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
124         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
125     }
126 
127     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
128         _FreeTokens = FreeTokens;
129     }
130 
131     function StartDistrib() public returns(bool success) {
132         if (msg.sender == owner && !DistribStarted && setupDone) {
133             DistribStarted = true;
134             IsDistribRunning = true;
135         } else {
136             revert();
137         }
138         return true;
139     }
140 
141     function StopDistrib() public returns(bool success) {
142         if (msg.sender == owner && IsDistribRunning) {
143             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
144                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
145                 if (_remainingAmount > 0) {
146                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
147                     _totalSupply += _remainingAmount;
148                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
149                 }
150             }
151             DistribStarted = false;
152             IsDistribRunning = false;
153         } else {
154             revert();
155         }
156         return true;
157     }
158 
159     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
160 
161         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
162         require(addresses.length <= 255);
163         require(_amount <= _remainingAmount);
164         _amount = _amount * 1e18;
165 
166         for (uint i = 0; i < addresses.length; i++) {
167             require(_amount <= _remainingAmount);
168             _CurrentDistribPublicSupply += _amount;
169             balances[addresses[i]] += _amount;
170             _totalSupply += _amount;
171             Transfer(this, addresses[i], _amount);
172 
173         }
174 
175         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
176             DistribStarted = false;
177             IsDistribRunning = false;
178         }
179     }
180 
181     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
182 
183         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
184         uint256 _amount;
185 
186         require(addresses.length <= 255);
187         require(addresses.length == amounts.length);
188 
189         for (uint8 i = 0; i < addresses.length; i++) {
190             _amount = amounts[i] * 1e18;
191             require(_amount <= _remainingAmount);
192             _CurrentDistribPublicSupply += _amount;
193             balances[addresses[i]] += _amount;
194             _totalSupply += _amount;
195             Transfer(this, addresses[i], _amount);
196 
197 
198             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
199                 DistribStarted = false;
200                 IsDistribRunning = false;
201             }
202         }
203     }
204 
205     function BurnTokens(uint256 amount) public returns(bool success) {
206         uint256 _amount = amount * 1e18;
207         if (balances[msg.sender] >= _amount) {
208             balances[msg.sender] -= _amount;
209             _totalSupply -= _amount;
210             Burn(msg.sender, _amount);
211             Transfer(msg.sender, 0, _amount);
212         } else {
213             revert();
214         }
215         return true;
216     }
217 
218     function totalSupply() public constant returns(uint256 totalSupplyValue) {
219         return _totalSupply;
220     }
221 
222     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
223         return _MaxDistribPublicSupply;
224     }
225 
226     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
227         return _OwnerDistribSupply;
228     }
229 
230     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
231         return _CurrentDistribPublicSupply;
232     }
233 
234     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
235         return _remainingTokensReceiverAddress;
236     }
237 
238     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
239         return _DistribFundsReceiverAddress;
240     }
241 
242     function Owner() public constant returns(address ownerAddress) {
243         return owner;
244     }
245 
246     function SetupDone() public constant returns(bool setupDoneFlag) {
247         return setupDone;
248     }
249 
250     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
251         return IsDistribRunning;
252     }
253 
254     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
255         return DistribStarted;
256     }
257 
258     function balanceOf(address _owner) public constant returns(uint256 balance) {
259         return balances[_owner];
260     }
261 
262     function transfer(address _to, uint256 _amount) public returns(bool success) {
263         if (balances[msg.sender] >= _amount &&
264             _amount > 0 &&
265             balances[_to] + _amount > balances[_to]) {
266             balances[msg.sender] -= _amount;
267             balances[_to] += _amount;
268             Transfer(msg.sender, _to, _amount);
269             return true;
270         } else {
271             return false;
272         }
273     }
274 
275     function transferFrom(
276         address _from,
277         address _to,
278         uint256 _amount
279     ) public returns(bool success) {
280         if (balances[_from] >= _amount &&
281             allowed[_from][msg.sender] >= _amount &&
282             _amount > 0 &&
283             balances[_to] + _amount > balances[_to]) {
284             balances[_from] -= _amount;
285             allowed[_from][msg.sender] -= _amount;
286             balances[_to] += _amount;
287             Transfer(_from, _to, _amount);
288             return true;
289         } else {
290             return false;
291         }
292     }
293 
294     function approve(address _spender, uint256 _amount) public returns(bool success) {
295         allowed[msg.sender][_spender] = _amount;
296         Approval(msg.sender, _spender, _amount);
297         return true;
298     }
299 
300     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
301         return allowed[_owner][_spender];
302     }
303 }