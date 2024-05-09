1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract MNY {
6 
7     string public name = "Monkey";
8     uint8 public decimals = 18;
9     string public symbol = "MNY";
10 
11     address public _owner;
12     address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
13     address public _devFeesAddr;
14     uint256 public _tokePerEth = 4877000000000000000000;
15     bool public _coldStorage = true;
16     bool public _receiveEth = false;
17 
18     // fees vars - added for future extensibility purposes only
19     bool _feesEnabled = false;
20     bool _payFees = false;
21     uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)
22     uint256 _lifeVal = 0;
23     uint256 _feeLimit = 0;
24     uint256 _devFees = 0;
25 
26     uint256 public _totalSupply = 1000000928 * 1 ether;
27     uint256 public _circulatingSupply = 0;
28     uint256 public _frozenTokens = 0;
29     event Transfer(address indexed _from, address indexed _to, uint _value);
30     event Exchanged(address indexed _from, address indexed _to, uint _value);
31 
32     // Storage
33     mapping (address => uint256) public balances;
34 
35     // list of contract addresses that this contract can request tokens from
36     // use add/remove functions
37     mapping (address => bool) public exchangePartners;
38 
39     // permitted exch partners and associated token rates
40     // rate is X target tokens per Y incoming so newTokens = Tokens/Rate
41     mapping (address => uint256) public exchangeRates;
42 
43     function MNY() {
44         _owner = msg.sender;
45         preMine();
46     }
47 
48     function preMine() internal {
49 
50     }
51 
52     function transfer(address _to, uint _value, bytes _data) public {
53         // sender must have enough tokens to transfer
54         require(balances[msg.sender] >= _value);
55 
56         if(_to == address(this)) {
57             // WARNING: if you transfer tokens back to the contract you will lose them
58             // use the exchange function to exchange with approved partner contracts
59             _totalSupply = add(_totalSupply, _value);
60             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
61             Transfer(msg.sender, _to, _value);
62         }
63         else {
64             uint codeLength;
65 
66             assembly {
67                 codeLength := extcodesize(_to)
68             }
69 
70             if(codeLength != 0) {
71                 // only allow transfer to exchange partner contracts - this is handled by another function
72             exchange(_to, _value);
73             }
74             else {
75                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
76                 balances[_to] = add(balances[_to], _value);
77 
78                 Transfer(msg.sender, _to, _value);
79             }
80         }
81     }
82 
83     function transfer(address _to, uint _value) public {
84         // sender must have enough tokens to transfer
85         require(balances[msg.sender] >= _value);
86 
87         if(_to == address(this)) {
88             // WARNING: if you transfer tokens back to the contract you will lose them
89             // use the exchange function to exchange for tokens with approved partner contracts
90             _totalSupply = add(_totalSupply, _value);
91             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
92             Transfer(msg.sender, _to, _value);
93         }
94         else {
95             uint codeLength;
96 
97             assembly {
98                 codeLength := extcodesize(_to)
99             }
100 
101             if(codeLength != 0) {
102                 // only allow transfer to exchange partner contracts - this is handled by another function
103             exchange(_to, _value);
104             }
105             else {
106                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
107                 balances[_to] = add(balances[_to], _value);
108 
109                 Transfer(msg.sender, _to, _value);
110             }
111         }
112     }
113 
114     function exchange(address _partner, uint _amount) internal {
115         require(exchangePartners[_partner]);
116         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
117 
118         if(_coldStorage) {
119             // put the tokens from this contract into cold storage if we need to
120             // (NB: if these are in reality to be burnt, we just never defrost them)
121             _frozenTokens = add(_frozenTokens, _amount);
122         }
123         else {
124             // or return them to the available supply if not
125             _totalSupply = add(_totalSupply, _amount);
126         }
127 
128         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
129         _circulatingSupply = sub(_circulatingSupply, _amount);
130         Exchanged(msg.sender, _partner, _amount);
131         Transfer(msg.sender, this, _amount);
132     }
133 
134     // fallback to receive ETH into contract and send tokens back based on current exchange rate
135     function () payable public {
136         require((msg.value > 0) && (_receiveEth));
137         uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);
138         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
139         _totalSupply = sub(_totalSupply, _tokens);
140         balances[msg.sender] = add(balances[msg.sender], _tokens);
141         _circulatingSupply = add(_circulatingSupply, _tokens);
142         Transfer(this, msg.sender, _tokens);
143         _lifeVal = add(_lifeVal, msg.value);
144 
145         if(_feesEnabled) {
146             if(!_payFees) {
147                 // then check whether fees are due and set _payFees accordingly
148                 if(_lifeVal >= _feeLimit) _payFees = true;
149             }
150 
151             if(_payFees) {
152                 _devFees = add(_devFees, ((msg.value * _fees) / 10000));
153             }
154         }
155     }
156 
157     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
158         Partner p = Partner(_targetContract);
159         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
160         return true;
161     }
162 
163     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _incomingTokens) public {
164         require(exchangeRates[msg.sender] > 0);
165         uint256 _exchanged = mul(_incomingTokens, exchangeRates[_source]);
166         require(_exchanged <= _totalSupply);
167         balances[_recipient] = add(balances[_recipient],_exchanged);
168         _totalSupply = sub(_totalSupply, _exchanged);
169         _circulatingSupply = add(_circulatingSupply, _exchanged);
170         Exchanged(_source, _recipient, _exchanged);
171         Transfer(this, _recipient, _exchanged);
172     }
173 
174     function changePayRate(uint256 _newRate) public {
175         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
176         _tokePerEth = _newRate;
177     }
178 
179     function safeWithdrawal(address _receiver, uint256 _value) public {
180         require((msg.sender == _owner));
181 
182         // if fees are enabled send the dev fees
183         if(_feesEnabled) {
184             if(_payFees) _devFeesAddr.transfer(_devFees);
185             _devFees = 0;
186         }
187 
188         // check balance before transferring
189         require(_value <= this.balance);
190         _receiver.transfer(_value);
191     }
192 
193     function balanceOf(address _receiver) public constant returns (uint balance) {
194         return balances[_receiver];
195     }
196 
197     function changeOwner(address _receiver) public {
198         require(msg.sender == _owner);
199         _dev = _receiver;
200     }
201 
202     function changeDev(address _receiver) public {
203         require(msg.sender == _dev);
204         _owner = _receiver;
205     }
206 
207     function changeDevFeesAddr(address _receiver) public {
208         require(msg.sender == _dev);
209         _devFeesAddr = _receiver;
210     }
211 
212     function toggleReceiveEth() public {
213         require((msg.sender == _dev) || (msg.sender == _owner));
214         if(!_receiveEth) {
215             _receiveEth = true;
216         }
217         else {
218             _receiveEth = false;
219         }
220     }
221 
222     function toggleFreezeTokensFlag() public {
223         require((msg.sender == _dev) || (msg.sender == _owner));
224         if(!_coldStorage) {
225             _coldStorage = true;
226         }
227         else {
228             _coldStorage = false;
229         }
230     }
231 
232     function defrostFrozenTokens() public {
233         require((msg.sender == _dev) || (msg.sender == _owner));
234         _totalSupply = add(_totalSupply, _frozenTokens);
235         _frozenTokens = 0;
236     }
237 
238     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
239         require((msg.sender == _dev) || (msg.sender == _owner));
240         // check that _partner is a contract address
241         uint codeLength;
242         assembly {
243             codeLength := extcodesize(_partner)
244         }
245         require(codeLength > 0);
246         exchangeRates[_partner] = _rate;
247     }
248 
249     function addExchangePartnerTargetAddress(address _partner) public {
250         require((msg.sender == _dev) || (msg.sender == _owner));
251         exchangePartners[_partner] = true;
252     }
253 
254     function removeExchangePartnerTargetAddress(address _partner) public {
255         require((msg.sender == _dev) || (msg.sender == _owner));
256         exchangePartners[_partner] = false;
257     }
258 
259     function canExchange(address _targetContract) public constant returns (bool) {
260         return exchangePartners[_targetContract];
261     }
262 
263     function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {
264         return exchangeRates[_exchangingContract];
265     }
266 
267     function totalSupply() public constant returns (uint256) {
268         return _totalSupply;
269     }
270 
271     function getBalance() public constant returns (uint256) {
272         return this.balance;
273     }
274 
275     function getLifeVal() public constant returns (uint256) {
276         require((msg.sender == _owner) || (msg.sender == _dev));
277         return _lifeVal;
278     }
279 
280     function getCirculatingSupply() public constant returns (uint256) {
281         return _circulatingSupply;
282     }
283 
284     function payFeesToggle() {
285         require((msg.sender == _dev) || (msg.sender == _owner));
286         if(_payFees) {
287             _payFees = false;
288         }
289         else {
290             _payFees = true;
291         }
292     }
293 
294     // enables fee update - must be between 0 and 100 (%)
295     function updateFeeAmount(uint _newFee) public {
296         require((msg.sender == _dev) || (msg.sender == _owner));
297         require((_newFee >= 0) && (_newFee <= 100));
298         _fees = _newFee * 100;
299     }
300 
301     function withdrawDevFees() public {
302         require(_payFees);
303         _devFeesAddr.transfer(_devFees);
304         _devFees = 0;
305     }
306 
307     function mul(uint a, uint b) internal pure returns (uint) {
308         uint c = a * b;
309         require(a == 0 || c / a == b);
310         return c;
311     }
312 
313     function div(uint a, uint b) internal pure returns (uint) {
314         // assert(b > 0); // Solidity automatically throws when dividing by 0
315         uint c = a / b;
316         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
317         return c;
318     }
319 
320     function sub(uint a, uint b) internal pure returns (uint) {
321         require(b <= a);
322         return a - b;
323     }
324 
325     function add(uint a, uint b) internal pure returns (uint) {
326         uint c = a + b;
327         require(c >= a);
328         return c;
329     }
330 }