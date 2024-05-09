1 /*
2 
3 Quadrant Assets Official Token Contract 
4 
5 QuadrantAssets – it is an open ecosystem for more effective interaction the ICO with funds, investors, experts, and traders.
6 We believe in this crypto-community, now divided into 4 large groups: ICO projects, investors, traders and experts. 
7 These 4 groups we want to connect in one service, for faster and more effective interaction between them. 
8 
9 Website: https://quadrantassets.solutons/
10 
11 (c) by Chang Lee & Qing Han and Mei Zhen / Experts in blockchain technology and asset management, analysts RUNetSoft.
12 
13 */
14 
15 pragma solidity 0.4.18;
16 
17 contract QuadrantAssets {
18 
19     string public symbol = "QDA";
20     string public name = "Quadrant Assets";
21     uint8 public constant decimals = 18;
22     uint256 _totalSupply = 0;	
23 	uint256 _FreeQDA = 250;
24     uint256 _ML1 = 2;
25     uint256 _ML2 = 3;
26 	uint256 _ML3 = 4;
27     uint256 _LimitML1 = 3e15;
28     uint256 _LimitML2 = 6e15;
29 	uint256 _LimitML3 = 9e15;
30 	uint256 _MaxDistribPublicSupply = 1000000000;
31     uint256 _OwnerDistribSupply = 0;
32     uint256 _CurrentDistribPublicSupply = 0;	
33     uint256 _ExtraTokensPerETHSended = 2500000;
34     
35 	address _DistribFundsReceiverAddress = 0;
36     address _remainingTokensReceiverAddress = 0;
37     address owner = 0;
38 	
39 	
40     bool setupDone = false;
41     bool IsDistribRunning = false;
42     bool DistribStarted = false;
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     event Burn(address indexed _owner, uint256 _value);
47 
48     mapping(address => uint256) balances;
49     mapping(address => mapping(address => uint256)) allowed;
50     mapping(address => bool) public Claimed;
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function QuadrantAssets() public {
58         owner = msg.sender;
59     }
60 
61     function() public payable {
62         if (IsDistribRunning) {
63             uint256 _amount;
64             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
65             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
66             if (Claimed[msg.sender] == false) {
67                 _amount = _FreeQDA * 1e18;
68                 _CurrentDistribPublicSupply += _amount;
69                 balances[msg.sender] += _amount;
70                 _totalSupply += _amount;
71                 Transfer(this, msg.sender, _amount);
72                 Claimed[msg.sender] = true;
73             }
74 
75            
76 
77             if (msg.value >= 9e15) {
78             _amount = msg.value * _ExtraTokensPerETHSended * 4;
79             } else {
80                 if (msg.value >= 6e15) {
81                     _amount = msg.value * _ExtraTokensPerETHSended * 3;
82                 } else {
83                     if (msg.value >= 3e15) {
84                         _amount = msg.value * _ExtraTokensPerETHSended * 2;
85                     } else {
86 
87                         _amount = msg.value * _ExtraTokensPerETHSended;
88 
89                     }
90 
91                 }
92             }
93 			 
94 			 _CurrentDistribPublicSupply += _amount;
95                 balances[msg.sender] += _amount;
96                 _totalSupply += _amount;
97                 Transfer(this, msg.sender, _amount);
98         
99 
100 
101 
102         } else {
103             revert();
104         }
105     }
106 
107     function SetupQDA(string tokenName, string tokenSymbol, uint256 ExtraTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeQDA) public {
108         if (msg.sender == owner && !setupDone) {
109             symbol = tokenSymbol;
110             name = tokenName;
111             _FreeQDA = FreeQDA;
112             _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
113             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
114             if (OwnerDistribSupply > 0) {
115                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
116                 _totalSupply = _OwnerDistribSupply;
117                 balances[owner] = _totalSupply;
118                 _CurrentDistribPublicSupply += _totalSupply;
119                 Transfer(this, owner, _totalSupply);
120             }
121             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
122             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
123             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
124 
125             setupDone = true;
126         }
127     }
128 
129     function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {
130         _ML1 = ML1inX;
131         _ML2 = ML2inX;
132         _LimitML1 = LimitML1inWei;
133         _LimitML2 = LimitML2inWei;
134         
135     }
136 
137     function SetExtra(uint256 ExtraTokensPerETHSended) onlyOwner public {
138         _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
139     }
140 
141     function SetFreeQDA(uint256 FreeQDA) onlyOwner public {
142         _FreeQDA = FreeQDA;
143     }
144 
145     function StartDistrib() public returns(bool success) {
146         if (msg.sender == owner && !DistribStarted && setupDone) {
147             DistribStarted = true;
148             IsDistribRunning = true;
149         } else {
150             revert();
151         }
152         return true;
153     }
154 
155     function StopDistrib() public returns(bool success) {
156         if (msg.sender == owner && IsDistribRunning) {
157             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
158                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
159                 if (_remainingAmount > 0) {
160                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
161                     _totalSupply += _remainingAmount;
162                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
163                 }
164             }
165             DistribStarted = false;
166             IsDistribRunning = false;
167         } else {
168             revert();
169         }
170         return true;
171     }
172 
173     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
174 
175         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
176         require(addresses.length <= 255);
177         require(_amount <= _remainingAmount);
178         _amount = _amount * 1e18;
179 
180         for (uint i = 0; i < addresses.length; i++) {
181             require(_amount <= _remainingAmount);
182             _CurrentDistribPublicSupply += _amount;
183             balances[addresses[i]] += _amount;
184             _totalSupply += _amount;
185             Transfer(this, addresses[i], _amount);
186 
187         }
188 
189         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
190             DistribStarted = false;
191             IsDistribRunning = false;
192         }
193     }
194 
195     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
196 
197         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
198         uint256 _amount;
199 
200         require(addresses.length <= 255);
201         require(addresses.length == amounts.length);
202 
203         for (uint8 i = 0; i < addresses.length; i++) {
204             _amount = amounts[i] * 1e18;
205             require(_amount <= _remainingAmount);
206             _CurrentDistribPublicSupply += _amount;
207             balances[addresses[i]] += _amount;
208             _totalSupply += _amount;
209             Transfer(this, addresses[i], _amount);
210 
211 
212             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
213                 DistribStarted = false;
214                 IsDistribRunning = false;
215             }
216         }
217     }
218 
219     function BurnTokens(uint256 amount) public returns(bool success) {
220         uint256 _amount = amount * 1e18;
221         if (balances[msg.sender] >= _amount) {
222             balances[msg.sender] -= _amount;
223             _totalSupply -= _amount;
224             Burn(msg.sender, _amount);
225             Transfer(msg.sender, 0, _amount);
226         } else {
227             revert();
228         }
229         return true;
230     }
231 
232     function totalSupply() public constant returns(uint256 totalSupplyValue) {
233         return _totalSupply;
234     }
235 
236     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
237         return _MaxDistribPublicSupply;
238     }
239 
240     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
241         return _OwnerDistribSupply;
242     }
243 
244     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
245         return _CurrentDistribPublicSupply;
246     }
247 
248     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
249         return _remainingTokensReceiverAddress;
250     }
251 
252     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
253         return _DistribFundsReceiverAddress;
254     }
255 
256     function Owner() public constant returns(address ownerAddress) {
257         return owner;
258     }
259 
260     function SetupDone() public constant returns(bool setupDoneFlag) {
261         return setupDone;
262     }
263 
264     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
265         return IsDistribRunning;
266     }
267 
268     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
269         return DistribStarted;
270     }
271 
272     function balanceOf(address _owner) public constant returns(uint256 balance) {
273         return balances[_owner];
274     }
275 
276     function transfer(address _to, uint256 _amount) public returns(bool success) {
277         if (balances[msg.sender] >= _amount &&
278             _amount > 0 &&
279             balances[_to] + _amount > balances[_to]) {
280             balances[msg.sender] -= _amount;
281             balances[_to] += _amount;
282             Transfer(msg.sender, _to, _amount);
283             return true;
284         } else {
285             return false;
286         }
287     }
288 
289     function transferFrom(
290         address _from,
291         address _to,
292         uint256 _amount
293     ) public returns(bool success) {
294         if (balances[_from] >= _amount &&
295             allowed[_from][msg.sender] >= _amount &&
296             _amount > 0 &&
297             balances[_to] + _amount > balances[_to]) {
298             balances[_from] -= _amount;
299             allowed[_from][msg.sender] -= _amount;
300             balances[_to] += _amount;
301             Transfer(_from, _to, _amount);
302             return true;
303         } else {
304             return false;
305         }
306     }
307 
308     function approve(address _spender, uint256 _amount) public returns(bool success) {
309         allowed[msg.sender][_spender] = _amount;
310         Approval(msg.sender, _spender, _amount);
311         return true;
312     }
313 
314     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
315         return allowed[_owner][_spender];
316     }
317 }