1 pragma solidity 0.4.18;
2 
3 
4 library SafeMath {
5 
6     /**
7     * Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     /**
29     * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract QPay {
47 
48     string public symbol="QPY";
49     string public name="QPay" ;
50     uint8 public constant decimals = 18;
51     uint256 _totalSupply = 0;	
52 	uint256 _FreeQPY = 1230;
53     uint256 _ML1 = 2;
54     uint256 _ML2 = 3;
55 	uint256 _ML3 = 4;
56     uint256 _LimitML1 = 3e15;
57     uint256 _LimitML2 = 6e15;
58 	uint256 _LimitML3 = 9e15;
59 	uint256 _MaxDistribPublicSupply = 950000000;
60     uint256 _OwnerDistribSupply = 0;
61     uint256 _CurrentDistribPublicSupply = 0;	
62     uint256 _ExtraTokensPerETHSended = 150000;
63     
64 	address _DistribFundsReceiverAddress = 0;
65     address _remainingTokensReceiverAddress = 0;
66     address owner = 0;
67 	
68 	
69     bool setupDone = false;
70     bool IsDistribRunning = false;
71     bool DistribStarted = false;
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75     event Burn(address indexed _owner, uint256 _value);
76 
77     mapping(address => uint256) balances;
78     mapping(address => mapping(address => uint256)) allowed;
79     mapping(address => bool) public Claimed;
80 
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function QPay() public {
87         owner = msg.sender;
88     }
89 
90     function() public payable {
91         if (IsDistribRunning) {
92             uint256 _amount;
93             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
94             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
95             if (Claimed[msg.sender] == false) {
96                 _amount = _FreeQPY * 1e18;
97                 _CurrentDistribPublicSupply += _amount;
98                 balances[msg.sender] += _amount;
99                 _totalSupply += _amount;
100                 Transfer(this, msg.sender, _amount);
101                 Claimed[msg.sender] = true;
102             }
103 
104            
105 
106             if (msg.value >= 9e15) {
107             _amount = msg.value * _ExtraTokensPerETHSended * 4;
108             } else {
109                 if (msg.value >= 6e15) {
110                     _amount = msg.value * _ExtraTokensPerETHSended * 3;
111                 } else {
112                     if (msg.value >= 3e15) {
113                         _amount = msg.value * _ExtraTokensPerETHSended * 2;
114                     } else {
115 
116                         _amount = msg.value * _ExtraTokensPerETHSended;
117 
118                     }
119 
120                 }
121             }
122 			 
123 			 _CurrentDistribPublicSupply += _amount;
124                 balances[msg.sender] += _amount;
125                 _totalSupply += _amount;
126                 Transfer(this, msg.sender, _amount);
127         
128 
129 
130 
131         } else {
132             revert();
133         }
134     }
135 
136     function SetupQPY(string tokenName, string tokenSymbol, uint256 ExtraTokensPerETHSended, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeQPY) public {
137         if (msg.sender == owner && !setupDone) {
138             symbol = tokenSymbol;
139             name = tokenName;
140             _FreeQPY = FreeQPY;
141             _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
142             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e18;
143             if (OwnerDistribSupply > 0) {
144                 _OwnerDistribSupply = OwnerDistribSupply * 1e18;
145                 _totalSupply = _OwnerDistribSupply;
146                 balances[owner] = _totalSupply;
147                 _CurrentDistribPublicSupply += _totalSupply;
148                 Transfer(this, owner, _totalSupply);
149             }
150             _DistribFundsReceiverAddress = DistribFundsReceiverAddress;
151             if (_DistribFundsReceiverAddress == 0) _DistribFundsReceiverAddress = owner;
152             _remainingTokensReceiverAddress = remainingTokensReceiverAddress;
153 
154             setupDone = true;
155         }
156     }
157 
158     function SetupML(uint256 ML1inX, uint256 ML2inX, uint256 LimitML1inWei, uint256 LimitML2inWei) onlyOwner public {
159         _ML1 = ML1inX;
160         _ML2 = ML2inX;
161         _LimitML1 = LimitML1inWei;
162         _LimitML2 = LimitML2inWei;
163         
164     }
165 
166     function SetExtra(uint256 ExtraTokensPerETHSended) onlyOwner public {
167         _ExtraTokensPerETHSended = ExtraTokensPerETHSended;
168     }
169 
170     function SetFreeQPY(uint256 FreeQPY) onlyOwner public {
171         _FreeQPY = FreeQPY;
172     }
173 
174     function StartDistrib() public returns(bool success) {
175         if (msg.sender == owner && !DistribStarted && setupDone) {
176             DistribStarted = true;
177             IsDistribRunning = true;
178         } else {
179             revert();
180         }
181         return true;
182     }
183 
184     function StopDistrib() public returns(bool success) {
185         if (msg.sender == owner && IsDistribRunning) {
186             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
187                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
188                 if (_remainingAmount > 0) {
189                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
190                     _totalSupply += _remainingAmount;
191                    Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
192                 }
193             }
194             DistribStarted = false;
195             IsDistribRunning = false;
196         } else {
197             revert();
198         }
199         return true;
200     }
201 
202     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
203 
204         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
205         require(addresses.length <= 255);
206         require(_amount <= _remainingAmount);
207         _amount = _amount * 1e18;
208 
209         for (uint i = 0; i < addresses.length; i++) {
210             require(_amount <= _remainingAmount);
211             _CurrentDistribPublicSupply += _amount;
212             balances[addresses[i]] += _amount;
213             _totalSupply += _amount;
214            Transfer(this, addresses[i], _amount);
215 
216         }
217 
218         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
219             DistribStarted = false;
220             IsDistribRunning = false;
221         }
222     }
223 
224     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
225 
226         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
227         uint256 _amount;
228 
229         require(addresses.length <= 255);
230         require(addresses.length == amounts.length);
231 
232         for (uint8 i = 0; i < addresses.length; i++) {
233             _amount = amounts[i] * 1e18;
234             require(_amount <= _remainingAmount);
235             _CurrentDistribPublicSupply += _amount;
236             balances[addresses[i]] += _amount;
237             _totalSupply += _amount;
238             Transfer(this, addresses[i], _amount);
239 
240 
241             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
242                 DistribStarted = false;
243                 IsDistribRunning = false;
244             }
245         }
246     }
247 
248     function BurnTokens(uint256 amount) public returns(bool success) {
249         uint256 _amount = amount * 1e18;
250         if (balances[msg.sender] >= _amount) {
251             balances[msg.sender] -= _amount;
252             _totalSupply -= _amount;
253              Burn(msg.sender, _amount);
254             Transfer(msg.sender, 0, _amount);
255         } else {
256             revert();
257         }
258         return true;
259     }
260 
261     function totalSupply() public constant returns(uint256 totalSupplyValue) {
262         return _totalSupply;
263     }
264 
265     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
266         return _MaxDistribPublicSupply;
267     }
268 
269     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
270         return _OwnerDistribSupply;
271     }
272 
273     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
274         return _CurrentDistribPublicSupply;
275     }
276 
277     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
278         return _remainingTokensReceiverAddress;
279     }
280 
281     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
282         return _DistribFundsReceiverAddress;
283     }
284 
285     function Owner() public constant returns(address ownerAddress) {
286         return owner;
287     }
288 
289     function SetupDone() public constant returns(bool setupDoneFlag) {
290         return setupDone;
291     }
292 
293     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
294         return IsDistribRunning;
295     }
296 
297     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
298         return DistribStarted;
299     }
300 
301     function balanceOf(address _owner) public constant returns(uint256 balance) {
302         return balances[_owner];
303     }
304 
305     function transfer(address _to, uint256 _amount) public returns(bool success) {
306         if (balances[msg.sender] >= _amount &&
307             _amount > 0 &&
308             balances[_to] + _amount > balances[_to]) {
309             balances[msg.sender] -= _amount;
310             balances[_to] += _amount;
311             Transfer(msg.sender, _to, _amount);
312             return true;
313         } else {
314             return false;
315         }
316     }
317 
318     function transferFrom(
319         address _from,
320         address _to,
321         uint256 _amount
322     ) public returns(bool success) {
323         if (balances[_from] >= _amount &&
324             allowed[_from][msg.sender] >= _amount &&
325             _amount > 0 &&
326             balances[_to] + _amount > balances[_to]) {
327             balances[_from] -= _amount;
328             allowed[_from][msg.sender] -= _amount;
329             balances[_to] += _amount;
330          Transfer(_from, _to, _amount);
331             return true;
332         } else {
333             return false;
334         }
335     }
336 
337     function approve(address _spender, uint256 _amount) public returns(bool success) {
338         allowed[msg.sender][_spender] = _amount;
339         Approval(msg.sender, _spender, _amount);
340         return true;
341     }
342 
343     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
344         return allowed[_owner][_spender];
345     }
346 }