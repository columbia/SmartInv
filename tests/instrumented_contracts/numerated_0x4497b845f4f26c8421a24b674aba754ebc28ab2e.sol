1 /*
2 Website: http://shitcoin-cash.com
3 */
4 
5 pragma solidity 0.4.18;
6 
7 contract ShitcoinCash {
8     string public symbol = "$HIT";
9     string public name = "Shitcoin Cash";
10     uint8 public constant decimals = 18;
11 
12     uint256 _totalSupply = 0;
13     uint256 _MaxDistribPublicSupply = 950000000;
14     uint256 _OwnerDistribSupply = 0;
15     uint256 _CurrentDistribPublicSupply = 0;
16 
17     uint256 _FreeTokens = 125;
18 
19     uint256 _Multiplier1 = 2;
20     uint256 _Multiplier2 = 3;
21     uint256 _Multiplier3 = 4;
22 
23     uint256 _LimitMultiplier1 = 1e16;
24     uint256 _LimitMultiplier2 = 1e17;
25 	uint256 _LimitMultiplier3 = 1e18;
26 	
27     uint256 _HighDonateLimit = 100e18;
28 	
29     uint256 _BonusTokensPerETHdonated = 1000000;
30 	
31     address _DistribFundsReceiverAddress = 0;
32     address _remainingTokensReceiverAddress = 0;
33     address owner = 0;
34     bool setupDone = false;
35     bool IsDistribRunning = false;
36     bool DistribStarted = false;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40     event Burn(address indexed _owner, uint256 _value);
41 
42     mapping(address => uint256) balances;
43     mapping(address => mapping(address => uint256)) allowed;
44     mapping(address => bool) public Claimed;
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function ShitcoinCash() public {
52         owner = msg.sender;
53     }
54 
55     function() public payable {
56         if (IsDistribRunning) {
57             uint256 _amount;
58             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
59             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
60             if (Claimed[msg.sender] == false) {
61                 _amount = _FreeTokens * 1e18;
62                 _CurrentDistribPublicSupply += _amount;
63                 balances[msg.sender] += _amount;
64                 _totalSupply += _amount;
65                 Transfer(this, msg.sender, _amount);
66                 Claimed[msg.sender] = true;
67             }
68 
69             require(msg.value <= _HighDonateLimit);
70 
71             if (msg.value >= 1e15) {
72 				if (msg.value >= _LimitMultiplier3) {
73 					_amount = msg.value * _BonusTokensPerETHdonated * _Multiplier3;
74 				} else {
75 					if (msg.value >= _LimitMultiplier2) {
76 						_amount = msg.value * _BonusTokensPerETHdonated * _Multiplier2;
77 					} else {
78 						if (msg.value >= _LimitMultiplier1) {
79 							_amount = msg.value * _BonusTokensPerETHdonated * _Multiplier1;
80 						} else {
81 
82 							_amount = msg.value * _BonusTokensPerETHdonated;
83 
84 						}
85 
86 					}
87 					
88 				}
89 
90                 _CurrentDistribPublicSupply += _amount;
91                 balances[msg.sender] += _amount;
92                 _totalSupply += _amount;
93                 Transfer(this, msg.sender, _amount);
94             }
95 
96 
97 
98         } else {
99             revert();
100         }
101     }
102 
103     function SetupToken(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHdonated, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeTokens) public {
104         if (msg.sender == owner && !setupDone) {
105             symbol = tokenSymbol;
106             name = tokenName;
107             _FreeTokens = FreeTokens;
108             _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
109             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
110             if (OwnerDistribSupply > 0) {
111                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
112                 _totalSupply = _OwnerDistribSupply;
113                 balances[owner] = _totalSupply;
114                 _CurrentDistribPublicSupply += _totalSupply;
115                 Transfer(this, owner, _totalSupply);
116             }
117             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
118             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
119             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
120 
121             setupDone = true;
122         }
123     }
124 
125     function SetupMultipliers(uint256 Multiplier1inX, uint256 Multiplier2inX, uint256 Multiplier3inX, uint256 LimitMultiplier1inWei, uint256 LimitMultiplier2inWei, uint256 LimitMultiplier3inWei, uint256 HighDonateLimitInWei) onlyOwner public {
126         _Multiplier1 = Multiplier1inX;
127         _Multiplier2 = Multiplier2inX;
128 		_Multiplier3 = Multiplier3inX;
129         _LimitMultiplier1 = LimitMultiplier1inWei;
130         _LimitMultiplier2 = LimitMultiplier2inWei;
131 		_LimitMultiplier3 = LimitMultiplier3inWei;
132         _HighDonateLimit = HighDonateLimitInWei;
133     }
134 
135     function SetBonus(uint256 BonusTokensPerETHdonated) onlyOwner public {
136         _BonusTokensPerETHdonated = BonusTokensPerETHdonated;
137     }
138 
139     function SetFreeTokens(uint256 FreeTokens) onlyOwner public {
140         _FreeTokens = FreeTokens;
141     }
142 
143     function StartDistrib() public returns(bool success) {
144         if (msg.sender == owner && !DistribStarted && setupDone) {
145             DistribStarted = true;
146             IsDistribRunning = true;
147         } else {
148             revert();
149         }
150         return true;
151     }
152 
153     function StopDistrib() public returns(bool success) {
154         if (msg.sender == owner && IsDistribRunning) {
155             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
156                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
157                 if (_remainingAmount > 0) {
158                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
159                     _totalSupply += _remainingAmount;
160                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
161                 }
162             }
163             DistribStarted = false;
164             IsDistribRunning = false;
165         } else {
166             revert();
167         }
168         return true;
169     }
170 
171     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
172 
173         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
174         require(addresses.length <= 255);
175         require(_amount <= _remainingAmount);
176         _amount = _amount * 1e18;
177 
178         for (uint i = 0; i < addresses.length; i++) {
179             require(_amount <= _remainingAmount);
180             _CurrentDistribPublicSupply += _amount;
181             balances[addresses[i]] += _amount;
182             _totalSupply += _amount;
183             Transfer(this, addresses[i], _amount);
184 
185         }
186 
187         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
188             DistribStarted = false;
189             IsDistribRunning = false;
190         }
191     }
192 
193     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
194 
195         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
196         uint256 _amount;
197 
198         require(addresses.length <= 255);
199         require(addresses.length == amounts.length);
200 
201         for (uint8 i = 0; i < addresses.length; i++) {
202             _amount = amounts[i] * 1e18;
203             require(_amount <= _remainingAmount);
204             _CurrentDistribPublicSupply += _amount;
205             balances[addresses[i]] += _amount;
206             _totalSupply += _amount;
207             Transfer(this, addresses[i], _amount);
208 
209 
210             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
211                 DistribStarted = false;
212                 IsDistribRunning = false;
213             }
214         }
215     }
216 
217     function BurnTokens(uint256 amount) public returns(bool success) {
218         uint256 _amount = amount * 1e18;
219         if (balances[msg.sender] >= _amount) {
220             balances[msg.sender] -= _amount;
221             _totalSupply -= _amount;
222             Burn(msg.sender, _amount);
223             Transfer(msg.sender, 0, _amount);
224         } else {
225             revert();
226         }
227         return true;
228     }
229 
230     function totalSupply() public constant returns(uint256 totalSupplyValue) {
231         return _totalSupply;
232     }
233 
234     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
235         return _MaxDistribPublicSupply;
236     }
237 
238     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
239         return _OwnerDistribSupply;
240     }
241 
242     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
243         return _CurrentDistribPublicSupply;
244     }
245 
246     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
247         return _remainingTokensReceiverAddress;
248     }
249 
250     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
251         return _DistribFundsReceiverAddress;
252     }
253 
254     function Owner() public constant returns(address ownerAddress) {
255         return owner;
256     }
257 
258     function SetupDone() public constant returns(bool setupDoneFlag) {
259         return setupDone;
260     }
261 
262     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
263         return IsDistribRunning;
264     }
265 
266     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
267         return DistribStarted;
268     }
269 
270     function balanceOf(address _owner) public constant returns(uint256 balance) {
271         return balances[_owner];
272     }
273 
274     function transfer(address _to, uint256 _amount) public returns(bool success) {
275         if (balances[msg.sender] >= _amount &&
276             _amount > 0 &&
277             balances[_to] + _amount > balances[_to]) {
278             balances[msg.sender] -= _amount;
279             balances[_to] += _amount;
280             Transfer(msg.sender, _to, _amount);
281             return true;
282         } else {
283             return false;
284         }
285     }
286 
287     function transferFrom(
288         address _from,
289         address _to,
290         uint256 _amount
291     ) public returns(bool success) {
292         if (balances[_from] >= _amount &&
293             allowed[_from][msg.sender] >= _amount &&
294             _amount > 0 &&
295             balances[_to] + _amount > balances[_to]) {
296             balances[_from] -= _amount;
297             allowed[_from][msg.sender] -= _amount;
298             balances[_to] += _amount;
299             Transfer(_from, _to, _amount);
300             return true;
301         } else {
302             return false;
303         }
304     }
305 
306     function approve(address _spender, uint256 _amount) public returns(bool success) {
307         allowed[msg.sender][_spender] = _amount;
308         Approval(msg.sender, _spender, _amount);
309         return true;
310     }
311 
312     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
313         return allowed[_owner][_spender];
314     }
315 }