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
16     bool public _receiveEth = true;
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
69             // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners
70             require(codeLength == 0);
71 
72             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
73             balances[_to] = add(balances[_to], _value);
74 
75             Transfer(msg.sender, _to, _value);
76         }
77     }
78 
79     function transfer(address _to, uint _value) public {
80         // sender must have enough tokens to transfer
81         require(balances[msg.sender] >= _value);
82 
83         if(_to == address(this)) {
84             // WARNING: if you transfer tokens back to the contract you will lose them
85             // use the exchange function to exchange for tokens with approved partner contracts
86             _totalSupply = add(_totalSupply, _value);
87             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
88             Transfer(msg.sender, _to, _value);
89         }
90         else {
91             uint codeLength;
92 
93             assembly {
94                 codeLength := extcodesize(_to)
95             }
96 
97             // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners
98             require(codeLength == 0);
99 
100             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
101             balances[_to] = add(balances[_to], _value);
102 
103             Transfer(msg.sender, _to, _value);
104         }
105     }
106 
107     function exchange(address _partner, uint _amount) public {
108         // msg.sender must have enough tokens to transfer
109         require(balances[msg.sender] >= _amount);
110 
111         // intended partner addy must be a contract
112         uint codeLength;
113         assembly {
114         // Retrieve the size of the code on target address, this needs assembly .
115             codeLength := extcodesize(_partner)
116         }
117         require(codeLength > 0);
118 
119         // contract must be able to exchange with the partner
120         require(exchangePartners[_partner]);
121         // require the transaction to be successful before we adjust the senders balance
122         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
123 
124         if(_coldStorage) {
125             // put the tokens from this contract into cold storage if we need to
126             // (NB: if these are in reality to be burnt, we just never defrost them)
127             _frozenTokens = add(_frozenTokens, _amount);
128         }
129         else {
130             // or return them to the available supply if not
131             _totalSupply = add(_totalSupply, _amount);
132         }
133 
134         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
135         Exchanged(msg.sender, _partner, _amount);
136         Transfer(msg.sender, this, _amount);
137     }
138 
139     // fallback to receive ETH into contract and send tokens back based on current exchange rate
140     function () payable public {
141         require((msg.value > 0) && (_receiveEth));
142         uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);
143         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
144         _totalSupply = sub(_totalSupply, _tokens);
145         balances[msg.sender] = add(balances[msg.sender], _tokens);
146         Transfer(this, msg.sender, _tokens);
147         _lifeVal = add(_lifeVal, msg.value);
148 
149         if(_feesEnabled) {
150             if(!_payFees) {
151                 // then check whether fees are due and set _payFees accordingly
152                 if(_lifeVal >= _feeLimit) _payFees = true;
153             }
154 
155             if(_payFees) {
156                 _devFees = add(_devFees, ((msg.value * _fees) / 10000));
157             }
158         }
159     }
160 
161     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
162         Partner p = Partner(_targetContract);
163         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
164         return true;
165     }
166 
167     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _incomingTokens) public {
168         require(exchangeRates[msg.sender] > 0);
169         uint256 _exchanged = mul(_incomingTokens, exchangeRates[_source]);
170         require(_exchanged <= _totalSupply);
171         balances[_recipient] = add(balances[_recipient],_exchanged);
172         _totalSupply = sub(_totalSupply, _exchanged);
173         Exchanged(_source, _recipient, _exchanged);
174         Transfer(this, _recipient, _exchanged);
175     }
176 
177     function changePayRate(uint256 _newRate) public {
178         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
179         _tokePerEth = _newRate;
180     }
181 
182     function safeWithdrawal(address _receiver, uint256 _value) public {
183         require((msg.sender == _owner));
184 
185         // if fees are enabled send the dev fees
186         if(_feesEnabled) {
187             if(_payFees) _devFeesAddr.transfer(_devFees);
188             _devFees = 0;
189         }
190 
191         // check balance before transferring
192         require(_value <= this.balance);
193         _receiver.transfer(_value);
194     }
195 
196     function balanceOf(address _receiver) public constant returns (uint balance) {
197         return balances[_receiver];
198     }
199 
200     function changeOwner(address _receiver) public {
201         require(msg.sender == _owner);
202         _dev = _receiver;
203     }
204 
205     function changeDev(address _receiver) public {
206         require(msg.sender == _dev);
207         _owner = _receiver;
208     }
209 
210     function changeDevFeesAddr(address _receiver) public {
211         require(msg.sender == _dev);
212         _devFeesAddr = _receiver;
213     }
214 
215     function toggleReceiveEth() public {
216         require((msg.sender == _dev) || (msg.sender == _owner));
217         if(!_receiveEth) {
218             _receiveEth = true;
219         }
220         else {
221             _receiveEth = false;
222         }
223     }
224 
225     function toggleFreezeTokensFlag() public {
226         require((msg.sender == _dev) || (msg.sender == _owner));
227         if(!_coldStorage) {
228             _coldStorage = true;
229         }
230         else {
231             _coldStorage = false;
232         }
233     }
234 
235     function defrostFrozenTokens() public {
236         require((msg.sender == _dev) || (msg.sender == _owner));
237         _totalSupply = add(_totalSupply, _frozenTokens);
238         _frozenTokens = 0;
239     }
240 
241     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
242         require((msg.sender == _dev) || (msg.sender == _owner));
243         // check that _partner is a contract address
244         uint codeLength;
245         assembly {
246             codeLength := extcodesize(_partner)
247         }
248         require(codeLength > 0);
249         exchangeRates[_partner] = _rate;
250     }
251 
252     function addExchangePartnerTargetAddress(address _partner) public {
253         require((msg.sender == _dev) || (msg.sender == _owner));
254         exchangePartners[_partner] = true;
255     }
256 
257     function removeExchangePartnerTargetAddress(address _partner) public {
258         require((msg.sender == _dev) || (msg.sender == _owner));
259         exchangePartners[_partner] = false;
260     }
261 
262     function canExchange(address _targetContract) public constant returns (bool) {
263         return exchangePartners[_targetContract];
264     }
265 
266     function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {
267         return exchangeRates[_exchangingContract];
268     }
269 
270     function totalSupply() public constant returns (uint256) {
271         return _totalSupply;
272     }
273 
274     // just in case fallback
275     function updateTokenBalance(uint256 newBalance) public {
276         require((msg.sender == _dev) || (msg.sender == _owner));
277         _totalSupply = newBalance;
278     }
279 
280     function getBalance() public constant returns (uint256) {
281         return this.balance;
282     }
283 
284     function getLifeVal() public returns (uint256) {
285         require((msg.sender == _owner) || (msg.sender == _dev));
286         return _lifeVal;
287     }
288 
289     function payFeesToggle() {
290         require((msg.sender == _dev) || (msg.sender == _owner));
291         if(_payFees) {
292             _payFees = false;
293         }
294         else {
295             _payFees = true;
296         }
297     }
298 
299     // enables fee update - must be between 0 and 100 (%)
300     function updateFeeAmount(uint _newFee) public {
301         require((msg.sender == _dev) || (msg.sender == _owner));
302         require((_newFee >= 0) && (_newFee <= 100));
303         _fees = _newFee * 100;
304     }
305 
306     function withdrawDevFees() public {
307         require(_payFees);
308         _devFeesAddr.transfer(_devFees);
309         _devFees = 0;
310     }
311 
312     function mul(uint a, uint b) internal pure returns (uint) {
313         uint c = a * b;
314         require(a == 0 || c / a == b);
315         return c;
316     }
317 
318     function div(uint a, uint b) internal pure returns (uint) {
319         // assert(b > 0); // Solidity automatically throws when dividing by 0
320         uint c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322         return c;
323     }
324 
325     function sub(uint a, uint b) internal pure returns (uint) {
326         require(b <= a);
327         return a - b;
328     }
329 
330     function add(uint a, uint b) internal pure returns (uint) {
331         uint c = a + b;
332         require(c >= a);
333         return c;
334     }
335 }