1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract MNY {
6     string public name = "Monkey";
7     uint8 public decimals = 18;
8     string public symbol = "MNY";
9 
10     address public _owner;
11     address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
12     address public _devFeesAddr;
13     uint256 public _tokePerEth = 4877000000000000000000;
14     bool public _coldStorage = true;
15     bool public _receiveEth = false;
16 
17     // fees vars - added for future extensibility purposes only
18     bool _feesEnabled = false;
19     bool _payFees = false;
20     uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)
21     uint256 _lifeVal = 0;
22     uint256 _feeLimit = 0;
23     uint256 _devFees = 0;
24 
25     uint256 public _totalSupply = 1000000928 * 1 ether;
26     uint256 public _circulatingSupply = 0;
27     uint256 public _frozenTokens = 0;
28     event Transfer(address indexed _from, address indexed _to, uint _value);
29     event Exchanged(address indexed _from, address indexed _to, uint _value);
30 
31     // Storage
32     mapping (address => uint256) public balances;
33 
34     // list of contract addresses that this contract can request tokens from
35     // use add/remove functions
36     mapping (address => bool) public exchangePartners;
37 
38     // permitted exch partners and associated token rates
39     // rate is X target tokens per Y incoming so newTokens = Tokens/Rate
40     mapping (address => uint256) public exchangeRates;
41 
42     function MNY() {
43         _owner = msg.sender;
44         preMine();
45     }
46 
47     function preMine() internal {
48 
49     }
50 
51     function transfer(address _to, uint _value, bytes _data) public {
52         // sender must have enough tokens to transfer
53         require(balances[msg.sender] >= _value);
54 
55         if(_to == address(this)) {
56             // WARNING: if you transfer tokens back to the contract you will lose them
57             // use the exchange function to exchange with approved partner contracts
58             _totalSupply = add(_totalSupply, _value);
59             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
60             Transfer(msg.sender, _to, _value);
61         }
62         else {
63             uint codeLength;
64 
65             assembly {
66                 codeLength := extcodesize(_to)
67             }
68 
69             if(codeLength != 0) {
70                 // only allow transfer to exchange partner contracts - this is handled by another function
71             exchange(_to, _value);
72             }
73             else {
74                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
75                 balances[_to] = add(balances[_to], _value);
76 
77                 Transfer(msg.sender, _to, _value);
78             }
79         }
80     }
81 
82     function transfer(address _to, uint _value) public {
83         // sender must have enough tokens to transfer
84         require(balances[msg.sender] >= _value);
85 
86         if(_to == address(this)) {
87             // WARNING: if you transfer tokens back to the contract you will lose them
88             // use the exchange function to exchange for tokens with approved partner contracts
89             _totalSupply = add(_totalSupply, _value);
90             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
91             Transfer(msg.sender, _to, _value);
92         }
93         else {
94             uint codeLength;
95 
96             assembly {
97                 codeLength := extcodesize(_to)
98             }
99 
100             if(codeLength != 0) {
101                 // only allow transfer to exchange partner contracts - this is handled by another function
102             exchange(_to, _value);
103             }
104             else {
105                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
106                 balances[_to] = add(balances[_to], _value);
107 
108                 Transfer(msg.sender, _to, _value);
109             }
110         }
111     }
112 
113     function exchange(address _partner, uint _amount) internal {
114         require(exchangePartners[_partner]);
115         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
116 
117         if(_coldStorage) {
118             // put the tokens from this contract into cold storage if we need to
119             // (NB: if these are in reality to be burnt, we just never defrost them)
120             _frozenTokens = add(_frozenTokens, _amount);
121         }
122         else {
123             // or return them to the available supply if not
124             _totalSupply = add(_totalSupply, _amount);
125         }
126 
127         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
128         _circulatingSupply = sub(_circulatingSupply, _amount);
129         Exchanged(msg.sender, _partner, _amount);
130         Transfer(msg.sender, this, _amount);
131     }
132 
133     // fallback to receive ETH into contract and send tokens back based on current exchange rate
134     function () payable public {
135         require((msg.value > 0) && (_receiveEth));
136         uint256 _tokens = div(mul(msg.value,_tokePerEth), 1 ether);
137         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
138         _totalSupply = sub(_totalSupply, _tokens);
139         balances[msg.sender] = add(balances[msg.sender], _tokens);
140         _circulatingSupply = add(_circulatingSupply, _tokens);
141         Transfer(this, msg.sender, _tokens);
142         _lifeVal = add(_lifeVal, msg.value);
143 
144         if(_feesEnabled) {
145             if(!_payFees) {
146                 // then check whether fees are due and set _payFees accordingly
147                 if(_lifeVal >= _feeLimit) _payFees = true;
148             }
149 
150             if(_payFees) {
151                 _devFees = add(_devFees, ((msg.value * _fees) / 10000));
152             }
153         }
154     }
155 
156     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
157         Partner p = Partner(_targetContract);
158         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
159         return true;
160     }
161 
162     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _incomingTokens) public {
163         require(exchangeRates[msg.sender] > 0);
164         uint256 _exchanged = mul(_incomingTokens, exchangeRates[_source]);
165         require(_exchanged <= _totalSupply);
166         balances[_recipient] = add(balances[_recipient],_exchanged);
167         _totalSupply = sub(_totalSupply, _exchanged);
168         _circulatingSupply = add(_circulatingSupply, _exchanged);
169         Exchanged(_source, _recipient, _exchanged);
170         Transfer(this, _recipient, _exchanged);
171     }
172 
173     function changePayRate(uint256 _newRate) public {
174         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
175         _tokePerEth = _newRate;
176     }
177 
178     function safeWithdrawal(address _receiver, uint256 _value) public {
179         require((msg.sender == _owner));
180 
181         // if fees are enabled send the dev fees
182         if(_feesEnabled) {
183             if(_payFees) _devFeesAddr.transfer(_devFees);
184             _devFees = 0;
185         }
186 
187         // check balance before transferring
188         require(_value <= this.balance);
189         _receiver.transfer(_value);
190     }
191 
192     function balanceOf(address _receiver) public constant returns (uint balance) {
193         return balances[_receiver];
194     }
195 
196     function changeOwner(address _receiver) public {
197         require(msg.sender == _owner);
198         _dev = _receiver;
199     }
200 
201     function changeDev(address _receiver) public {
202         require(msg.sender == _dev);
203         _owner = _receiver;
204     }
205 
206     function changeDevFeesAddr(address _receiver) public {
207         require(msg.sender == _dev);
208         _devFeesAddr = _receiver;
209     }
210 
211     function toggleReceiveEth() public {
212         require((msg.sender == _dev) || (msg.sender == _owner));
213         if(!_receiveEth) {
214             _receiveEth = true;
215         }
216         else {
217             _receiveEth = false;
218         }
219     }
220 
221     function toggleFreezeTokensFlag() public {
222         require((msg.sender == _dev) || (msg.sender == _owner));
223         if(!_coldStorage) {
224             _coldStorage = true;
225         }
226         else {
227             _coldStorage = false;
228         }
229     }
230 
231     function defrostFrozenTokens() public {
232         require((msg.sender == _dev) || (msg.sender == _owner));
233         _totalSupply = add(_totalSupply, _frozenTokens);
234         _frozenTokens = 0;
235     }
236 
237     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
238         require((msg.sender == _dev) || (msg.sender == _owner));
239         // check that _partner is a contract address
240         uint codeLength;
241         assembly {
242             codeLength := extcodesize(_partner)
243         }
244         require(codeLength > 0);
245         exchangeRates[_partner] = _rate;
246     }
247 
248     function addExchangePartnerTargetAddress(address _partner) public {
249         require((msg.sender == _dev) || (msg.sender == _owner));
250         exchangePartners[_partner] = true;
251     }
252 
253     function removeExchangePartnerTargetAddress(address _partner) public {
254         require((msg.sender == _dev) || (msg.sender == _owner));
255         exchangePartners[_partner] = false;
256     }
257 
258     function canExchange(address _targetContract) public constant returns (bool) {
259         return exchangePartners[_targetContract];
260     }
261 
262     function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {
263         return exchangeRates[_exchangingContract];
264     }
265 
266     function totalSupply() public constant returns (uint256) {
267         return _totalSupply;
268     }
269 
270     function getBalance() public constant returns (uint256) {
271         return this.balance;
272     }
273 
274     function getLifeVal() public constant returns (uint256) {
275         require((msg.sender == _owner) || (msg.sender == _dev));
276         return _lifeVal;
277     }
278 
279     function getCirculatingSupply() public constant returns (uint256) {
280         return _circulatingSupply;
281     }
282 
283     function payFeesToggle() {
284         require((msg.sender == _dev) || (msg.sender == _owner));
285         if(_payFees) {
286             _payFees = false;
287         }
288         else {
289             _payFees = true;
290         }
291     }
292 
293     // enables fee update - must be between 0 and 100 (%)
294     function updateFeeAmount(uint _newFee) public {
295         require((msg.sender == _dev) || (msg.sender == _owner));
296         require((_newFee >= 0) && (_newFee <= 100));
297         _fees = _newFee * 100;
298     }
299 
300     function withdrawDevFees() public {
301         require(_payFees);
302         _devFeesAddr.transfer(_devFees);
303         _devFees = 0;
304     }
305 
306     function mul(uint a, uint b) internal pure returns (uint) {
307         uint c = a * b;
308         require(a == 0 || c / a == b);
309         return c;
310     }
311 
312     function div(uint a, uint b) internal pure returns (uint) {
313         // assert(b > 0); // Solidity automatically throws when dividing by 0
314         uint c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316         return c;
317     }
318 
319     function sub(uint a, uint b) internal pure returns (uint) {
320         require(b <= a);
321         return a - b;
322     }
323 
324     function add(uint a, uint b) internal pure returns (uint) {
325         uint c = a + b;
326         require(c >= a);
327         return c;
328     }
329 }