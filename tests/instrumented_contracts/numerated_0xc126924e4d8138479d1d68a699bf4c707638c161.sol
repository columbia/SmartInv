1 pragma solidity 0.4.18;
2 
3 contract FuseaNetwork {
4 
5     string public symbol = "FSA";
6     string public name = "Fusea Network";
7     uint8 public constant decimals = 18;
8     uint256 _totalSupply = 0;	
9 	uint256 _MaxDistribPublicSupply = 400000000;
10 	uint256 _BonusTokensPerETHSended = 500000;
11     uint256 _OwnerDistribSupply = 0;
12     uint256 _CurrentDistribPublicSupply = 0;   
13 	address _DistribFundsReceiverAddress = 0;
14     address _remainingTokensReceiverAddress = 0;
15     address owner = 0;		
16     uint256 _ML1 = 2;
17     uint256 _ML2 = 2;
18 	uint256 _ML3 = 2;
19 	uint256 _ML4 = 2;
20     uint256 _LimitML1 = 4e15;
21     uint256 _LimitML2 = 6e15;
22 	uint256 _LimitML3 = 8e15;
23 	uint256 _LimitML4 = 12e15;	
24 
25 	
26 	
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
44     function FuseaNetwork() public {
45         owner = msg.sender;
46     }
47 
48         function() public payable {
49         if (IsDistribRunning) {
50             uint256 _amount;
51             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
52             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
53             
54             
55             	   if (msg.value >= 12e15) {
56             _amount = msg.value * _BonusTokensPerETHSended * 2;
57             } else {
58 		               if (msg.value >= 8e15) {
59             _amount = msg.value * _BonusTokensPerETHSended * 2;
60             } else {
61                 if (msg.value >= 6e15) {
62                     _amount = msg.value * _BonusTokensPerETHSended * 2;
63                 } else {
64                     if (msg.value >= 4e15) {
65                         _amount = msg.value * _BonusTokensPerETHSended * 2;
66                     } else {
67 
68                         _amount = msg.value * _BonusTokensPerETHSended;
69 
70                     }
71                  }    
72               }
73            }
74 			 
75 			 _CurrentDistribPublicSupply += _amount;
76                 balances[msg.sender] += _amount;
77                 _totalSupply += _amount;
78                 Transfer(this, msg.sender, _amount);
79         
80 
81 
82 
83         } else {
84             revert();
85         }
86     }
87 
88     function SetupFuseaNetwork(string tokenName, string tokenSymbol, uint256 BonusTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress) public {
89         if (msg.sender == owner && !setupDone) {
90             symbol = tokenSymbol;
91             name = tokenName;
92             _BonusTokensPerETHSended = BonusTokensPerETHSended;
93             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
94             if (OwnerDistribSupply > 0) {
95                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
96                 _totalSupply = _OwnerDistribSupply;
97                 balances[owner] = _totalSupply;
98                 _CurrentDistribPublicSupply += _totalSupply;
99                 Transfer(this, owner, _totalSupply);
100             }
101             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
102             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
103             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
104 
105             setupDone = true;
106         }
107     }
108 
109     function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {
110         _ML1 = ML1inX;
111         _ML2 = ML2inX;
112         _LimitML1 = LimitML1inWei;
113         _LimitML2 = LimitML2inWei;
114         
115     }
116 
117     function SetBonus(uint256 BonusTokensPerETHSended) onlyOwner public {
118         _BonusTokensPerETHSended = BonusTokensPerETHSended;
119     }
120 
121    
122     function StartFuseaNetworkDistribution() public returns(bool success) {
123         if (msg.sender == owner && !DistribStarted && setupDone) {
124             DistribStarted = true;
125             IsDistribRunning = true;
126         } else {
127             revert();
128         }
129         return true;
130     }
131 
132     function StopFuseaNetworkDistribution() public returns(bool success) {
133         if (msg.sender == owner && IsDistribRunning) {
134             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
135                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
136                 if (_remainingAmount > 0) {
137                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
138                     _totalSupply += _remainingAmount;
139                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
140                 }
141             }
142             DistribStarted = false;
143             IsDistribRunning = false;
144         } else {
145             revert();
146         }
147         return true;
148     }
149 
150     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
151 
152         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
153         require(addresses.length <= 255);
154         require(_amount <= _remainingAmount);
155         _amount = _amount * 1e18;
156 
157         for (uint i = 0; i < addresses.length; i++) {
158             require(_amount <= _remainingAmount);
159             _CurrentDistribPublicSupply += _amount;
160             balances[addresses[i]] += _amount;
161             _totalSupply += _amount;
162             Transfer(this, addresses[i], _amount);
163 
164         }
165 
166         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
167             DistribStarted = false;
168             IsDistribRunning = false;
169         }
170     }
171 
172     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
173 
174         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
175         uint256 _amount;
176 
177         require(addresses.length <= 255);
178         require(addresses.length == amounts.length);
179 
180         for (uint8 i = 0; i < addresses.length; i++) {
181             _amount = amounts[i] * 1e18;
182             require(_amount <= _remainingAmount);
183             _CurrentDistribPublicSupply += _amount;
184             balances[addresses[i]] += _amount;
185             _totalSupply += _amount;
186             Transfer(this, addresses[i], _amount);
187 
188 
189             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
190                 DistribStarted = false;
191                 IsDistribRunning = false;
192             }
193         }
194     }
195 
196     function BurnFSATokens(uint256 amount) public returns(bool success) {
197         uint256 _amount = amount * 1e18;
198         if (balances[msg.sender] >= _amount) {
199             balances[msg.sender] -= _amount;
200             _totalSupply -= _amount;
201             Burn(msg.sender, _amount);
202             Transfer(msg.sender, 0, _amount);
203         } else {
204             revert();
205         }
206         return true;
207     }
208 
209     function totalSupply() public constant returns(uint256 totalSupplyValue) {
210         return _totalSupply;
211     }
212 
213     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
214         return _MaxDistribPublicSupply;
215     }
216 
217     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
218         return _OwnerDistribSupply;
219     }
220 
221     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
222         return _CurrentDistribPublicSupply;
223     }
224 
225     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
226         return _remainingTokensReceiverAddress;
227     }
228 
229     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
230         return _DistribFundsReceiverAddress;
231     }
232 
233     function Owner() public constant returns(address ownerAddress) {
234         return owner;
235     }
236 
237     function SetupDone() public constant returns(bool setupDoneFlag) {
238         return setupDone;
239     }
240 
241     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
242         return IsDistribRunning;
243     }
244 
245     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
246         return DistribStarted;
247     }
248 
249     function balanceOf(address _owner) public constant returns(uint256 balance) {
250         return balances[_owner];
251     }
252 
253     function transfer(address _to, uint256 _amount) public returns(bool success) {
254         if (balances[msg.sender] >= _amount &&
255             _amount > 0 &&
256             balances[_to] + _amount > balances[_to]) {
257             balances[msg.sender] -= _amount;
258             balances[_to] += _amount;
259             Transfer(msg.sender, _to, _amount);
260             return true;
261         } else {
262             return false;
263         }
264     }
265 
266     function transferFrom(
267         address _from,
268         address _to,
269         uint256 _amount
270     ) public returns(bool success) {
271         if (balances[_from] >= _amount &&
272             allowed[_from][msg.sender] >= _amount &&
273             _amount > 0 &&
274             balances[_to] + _amount > balances[_to]) {
275             balances[_from] -= _amount;
276             allowed[_from][msg.sender] -= _amount;
277             balances[_to] += _amount;
278             Transfer(_from, _to, _amount);
279             return true;
280         } else {
281             return false;
282         }
283     }
284 
285     function approve(address _spender, uint256 _amount) public returns(bool success) {
286         allowed[msg.sender][_spender] = _amount;
287         Approval(msg.sender, _spender, _amount);
288         return true;
289     }
290 
291     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
292         return allowed[_owner][_spender];
293     }
294 }