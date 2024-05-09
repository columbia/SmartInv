1 /*
2 
3 Youdeum Token Contract
4 
5 Youdeum – Is a Public Assets
6 Public assets used as a means of running ecosystem operations.
7 We believe that public assets will be able to bring together the interests of fund managers, investors, developers and traders.
8 Public assets as the solution and key to success of community-driven ecosystems.
9 
10 */
11 
12 pragma solidity 0.4.18;
13 
14 contract Youdeum {
15 
16     string public symbol = "YOU";
17     string public name = "Youdeum";
18     uint8 public constant decimals = 6;
19     uint256 _totalSupply = 0;
20 	uint256 _FreeToken = 500;
21 	uint256 _MaxDistribPublicSupply = 1000000000000000;
22     uint256 _OwnerDistribSupply = 0;
23     uint256 _CurrentDistribPublicSupply = 0;
24     uint256 _TokensPerETH = 1250000000000;
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
48     function Youdeum() public {
49         owner = msg.sender;
50     }
51 
52     function() public payable {
53         if (IsDistribRunning) {
54             uint256 _amount;
55             if (((_CurrentDistribPublicSupply + _amount) > _MaxDistribPublicSupply) && _MaxDistribPublicSupply > 0) revert();
56             if (!_DistribFundsReceiverAddress.send(msg.value)) revert();
57             if (Claimed[msg.sender] == false) {
58                 _amount = _FreeToken * 1e6;
59                 _CurrentDistribPublicSupply += _amount;
60                 balances[msg.sender] += _amount;
61                 _totalSupply += _amount;
62                 Transfer(this, msg.sender, _amount);
63                 Claimed[msg.sender] = true;
64             }
65 
66 
67 
68             if (msg.value >= 1e18) {
69             _amount = msg.value / 1e12 * _TokensPerETH * 2 ;
70             } else {
71                 if (msg.value >= 5e17) {
72                     _amount = msg.value / 1e12 * _TokensPerETH * 175 / 100;
73                 } else {
74                     if (msg.value >= 1e17) {
75                         _amount = msg.value / 1e12 * _TokensPerETH * 150 / 100;
76                     } else {
77                         if (msg.value >= 5e16) {
78                             _amount = msg.value / 1e12 * _TokensPerETH * 120 / 100;
79                         } else {
80 
81                             _amount = msg.value / 1e12 * _TokensPerETH;
82 
83                         }
84 
85                     }
86 
87                 }
88             }
89 
90 			 _CurrentDistribPublicSupply += _amount;
91                 balances[msg.sender] += _amount;
92                 _totalSupply += _amount;
93                 Transfer(this, msg.sender, _amount);
94 
95 
96 
97 
98         } else {
99             revert();
100         }
101     }
102 
103     function SetupToken(string tokenName, string tokenSymbol, uint256 TokensPerETH, uint256 MaxDistribPublicSupply, uint256 OwnerDistribSupply, address remainingTokensReceiverAddress, address DistribFundsReceiverAddress, uint256 FreeToken) public {
104         if (msg.sender == owner && !setupDone) {
105             symbol = tokenSymbol;
106             name = tokenName;
107             _FreeToken = FreeToken;
108             _TokensPerETH = TokensPerETH;
109             _MaxDistribPublicSupply = MaxDistribPublicSupply * 1e6;
110             if (OwnerDistribSupply > 0) {
111                 _OwnerDistribSupply = OwnerDistribSupply * 1e6;
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
125     function SetExtra(uint256 TokensPerETH) onlyOwner public {
126         _TokensPerETH = TokensPerETH;
127     }
128 
129     function SetFreeToken(uint256 FreeToken) onlyOwner public {
130         _FreeToken= FreeToken;
131     }
132 
133     function StartDistrib() public returns(bool success) {
134         if (msg.sender == owner && !DistribStarted && setupDone) {
135             DistribStarted = true;
136             IsDistribRunning = true;
137         } else {
138             revert();
139         }
140         return true;
141     }
142 
143     function StopDistrib() public returns(bool success) {
144         if (msg.sender == owner && IsDistribRunning) {
145             if (_remainingTokensReceiverAddress != 0 && _MaxDistribPublicSupply > 0) {
146                 uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
147                 if (_remainingAmount > 0) {
148                     balances[_remainingTokensReceiverAddress] += _remainingAmount;
149                     _totalSupply += _remainingAmount;
150                     Transfer(this, _remainingTokensReceiverAddress, _remainingAmount);
151                 }
152             }
153             DistribStarted = false;
154             IsDistribRunning = false;
155         } else {
156             revert();
157         }
158         return true;
159     }
160 
161     function distribution(address[] addresses, uint256 _amount) onlyOwner public {
162 
163         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
164         require(addresses.length <= 255);
165         require(_amount <= _remainingAmount);
166         _amount = _amount * 1e6;
167 
168         for (uint i = 0; i < addresses.length; i++) {
169             require(_amount <= _remainingAmount);
170             _CurrentDistribPublicSupply += _amount;
171             balances[addresses[i]] += _amount;
172             _totalSupply += _amount;
173             Transfer(this, addresses[i], _amount);
174 
175         }
176 
177         if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
178             DistribStarted = false;
179             IsDistribRunning = false;
180         }
181     }
182 
183     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
184 
185         uint256 _remainingAmount = _MaxDistribPublicSupply - _CurrentDistribPublicSupply;
186         uint256 _amount;
187 
188         require(addresses.length <= 255);
189         require(addresses.length == amounts.length);
190 
191         for (uint8 i = 0; i < addresses.length; i++) {
192             _amount = amounts[i] * 1e6;
193             require(_amount <= _remainingAmount);
194             _CurrentDistribPublicSupply += _amount;
195             balances[addresses[i]] += _amount;
196             _totalSupply += _amount;
197             Transfer(this, addresses[i], _amount);
198 
199 
200             if (_CurrentDistribPublicSupply >= _MaxDistribPublicSupply) {
201                 DistribStarted = false;
202                 IsDistribRunning = false;
203             }
204         }
205     }
206 
207     function BurnTokens(uint256 amount) public returns(bool success) {
208         uint256 _amount = amount * 1e6;
209         if (balances[msg.sender] >= _amount) {
210             balances[msg.sender] -= _amount;
211             _totalSupply -= _amount;
212             Burn(msg.sender, _amount);
213             Transfer(msg.sender, 0, _amount);
214         } else {
215             revert();
216         }
217         return true;
218     }
219 
220     function totalSupply() public constant returns(uint256 totalSupplyValue) {
221         return _totalSupply;
222     }
223 
224     function MaxDistribPublicSupply_() public constant returns(uint256 MaxDistribPublicSupply) {
225         return _MaxDistribPublicSupply;
226     }
227 
228     function OwnerDistribSupply_() public constant returns(uint256 OwnerDistribSupply) {
229         return _OwnerDistribSupply;
230     }
231 
232     function CurrentDistribPublicSupply_() public constant returns(uint256 CurrentDistribPublicSupply) {
233         return _CurrentDistribPublicSupply;
234     }
235 
236     function RemainingTokensReceiverAddress() public constant returns(address remainingTokensReceiverAddress) {
237         return _remainingTokensReceiverAddress;
238     }
239 
240     function DistribFundsReceiverAddress() public constant returns(address DistribfundsReceiver) {
241         return _DistribFundsReceiverAddress;
242     }
243 
244     function Owner() public constant returns(address ownerAddress) {
245         return owner;
246     }
247 
248     function SetupDone() public constant returns(bool setupDoneFlag) {
249         return setupDone;
250     }
251 
252     function IsDistribRunningFalg_() public constant returns(bool IsDistribRunningFalg) {
253         return IsDistribRunning;
254     }
255 
256     function IsDistribStarted() public constant returns(bool IsDistribStartedFlag) {
257         return DistribStarted;
258     }
259 
260     function balanceOf(address _owner) public constant returns(uint256 balance) {
261         return balances[_owner];
262     }
263 
264     function transfer(address _to, uint256 _amount) public returns(bool success) {
265         if (balances[msg.sender] >= _amount &&
266             _amount > 0 &&
267             balances[_to] + _amount > balances[_to]) {
268             balances[msg.sender] -= _amount;
269             balances[_to] += _amount;
270             Transfer(msg.sender, _to, _amount);
271             return true;
272         } else {
273             return false;
274         }
275     }
276 
277     function transferFrom(
278         address _from,
279         address _to,
280         uint256 _amount
281     ) public returns(bool success) {
282         if (balances[_from] >= _amount &&
283             allowed[_from][msg.sender] >= _amount &&
284             _amount > 0 &&
285             balances[_to] + _amount > balances[_to]) {
286             balances[_from] -= _amount;
287             allowed[_from][msg.sender] -= _amount;
288             balances[_to] += _amount;
289             Transfer(_from, _to, _amount);
290             return true;
291         } else {
292             return false;
293         }
294     }
295 
296     function approve(address _spender, uint256 _amount) public returns(bool success) {
297         allowed[msg.sender][_spender] = _amount;
298         Approval(msg.sender, _spender, _amount);
299         return true;
300     }
301 
302     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
303         return allowed[_owner][_spender];
304     }
305 }