1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract COE {
6 
7     string public name = "CoEval";
8     uint8 public decimals = 18;
9     string public symbol = "COE";
10 
11 
12     address public _owner;
13     address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
14     address public _devFeesAddr;
15     uint256 public _tokePerEth = 177000000000000000;
16     bool public _coldStorage = true;
17     bool public _receiveEth = true;
18 
19     // fees vars - added for future extensibility purposes only
20     bool _feesEnabled = false;
21     bool _payFees = false;
22     uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)
23     uint256 _lifeVal = 0;
24     uint256 _feeLimit = 0;
25     uint256 _devFees = 0;
26 
27     uint256 public _totalSupply = 100000 * 1 ether;
28     uint256 public _circulatingSupply = 0;
29     uint256 public _frozenTokens = 0;
30 
31     event Transfer(address indexed _from, address indexed _to, uint _value);
32     event Exchanged(address indexed _from, address indexed _to, uint _value);
33     // Storage
34     mapping (address => uint256) public balances;
35 
36     // list of contract addresses that can request tokens
37     // use add/remove functions to update
38     mapping (address => bool) public exchangePartners;
39 
40     // permitted exch partners and associated token rates
41     // rate is X target tokens per Y incoming so newTokens = Tokens/Rate
42     mapping (address => uint256) public exchangeRates;
43 
44     function COE() {
45         _owner = msg.sender;
46         preMine();
47     }
48 
49     function preMine() internal {
50         balances[_owner] = 32664750000000000000000;
51         Transfer(this, _owner, 32664750000000000000000);
52         _totalSupply = sub(_totalSupply, 32664750000000000000000);
53         _circulatingSupply = add(_circulatingSupply, 32664750000000000000000);
54     }
55 
56     function transfer(address _to, uint _value, bytes _data) public {
57         // sender must have enough tokens to transfer
58         require(balances[msg.sender] >= _value);
59 
60         if(_to == address(this)) {
61             // WARNING: if you transfer tokens back to the contract you will lose them
62             _totalSupply = add(_totalSupply, _value);
63             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
64             Transfer(msg.sender, _to, _value);
65         }
66         else {
67             uint codeLength;
68 
69             assembly {
70                 codeLength := extcodesize(_to)
71             }
72 
73             if(codeLength != 0) {
74                 // only allow transfer to exchange partner contracts - this is handled by another function
75                 exchange(_to, _value);
76             }
77             else {
78                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
79                 balances[_to] = add(balances[_to], _value);
80 
81                 Transfer(msg.sender, _to, _value);
82             }
83         }
84     }
85 
86     function transfer(address _to, uint _value) public {
87         /// sender must have enough tokens to transfer
88         require(balances[msg.sender] >= _value);
89 
90         if(_to == address(this)) {
91             // WARNING: if you transfer tokens back to the contract you will lose them
92             // use the exchange function to exchange for tokens with approved partner contracts
93             _totalSupply = add(_totalSupply, _value);
94             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
95             Transfer(msg.sender, _to, _value);
96         }
97         else {
98             uint codeLength;
99 
100             assembly {
101                 codeLength := extcodesize(_to)
102             }
103 
104             if(codeLength != 0) {
105                 // only allow transfer to exchange partner contracts - this is handled by another function
106                 exchange(_to, _value);
107             }
108             else {
109                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
110                 balances[_to] = add(balances[_to], _value);
111 
112                 Transfer(msg.sender, _to, _value);
113             }
114         }
115     }
116 
117     function exchange(address _partner, uint _amount) internal {
118         require(exchangePartners[_partner]);
119         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
120 
121         if(_coldStorage) {
122             // put the tokens from this contract into cold storage if we need to
123             // (NB: if these are in reality to be burnt, we just never defrost them)
124             _frozenTokens = add(_frozenTokens, _amount);
125         }
126         else {
127             // or return them to the available supply if not
128             _totalSupply = add(_totalSupply, _amount);
129         }
130 
131         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
132         _circulatingSupply = sub(_circulatingSupply, _amount);
133         Exchanged(msg.sender, _partner, _amount);
134         Transfer(msg.sender, this, _amount);
135     }
136 
137     // fallback to receive ETH into contract and send tokens back based on current exchange rate
138     function () payable public {
139         require((msg.value > 0) && (_receiveEth));
140         uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);
141         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
142         _totalSupply = sub(_totalSupply, _tokens);
143         balances[msg.sender] = add(balances[msg.sender], _tokens);
144         _circulatingSupply = add(_circulatingSupply, _tokens);
145         Transfer(this, msg.sender, _tokens);
146         _lifeVal = add(_lifeVal, msg.value);
147 
148         if(_feesEnabled) {
149             if(!_payFees) {
150                 // then check whether fees are due and set _payFees accordingly
151                 if(_lifeVal >= _feeLimit) _payFees = true;
152             }
153 
154             if(_payFees) {
155                 _devFees = add(_devFees, ((msg.value * _fees) / 10000));
156             }
157         }
158     }
159 
160     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
161         Partner p = Partner(_targetContract);
162         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
163         return true;
164     }
165 
166     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens) {
167         require(exchangeRates[msg.sender] > 0);
168         uint256 _exchanged = mul(_RequestedTokens, exchangeRates[_source]);
169         require(_exchanged <= _totalSupply);
170         balances[_recipient] = add(balances[_recipient],_exchanged);
171         _totalSupply = sub(_totalSupply, _exchanged);
172         _circulatingSupply = add(_circulatingSupply, _exchanged);
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
184         uint256 valueAsEth = mul(_value,1 ether);
185 
186         // if fees are enabled send the dev fees
187         if(_feesEnabled) {
188             if(_payFees) _devFeesAddr.transfer(_devFees);
189             _devFees = 0;
190         }
191 
192         // check balance before transferring
193         require(valueAsEth <= this.balance);
194         _receiver.transfer(valueAsEth);
195     }
196 
197     function balanceOf(address _receiver) public constant returns (uint balance) {
198         return balances[_receiver];
199     }
200 
201     function changeOwner(address _receiver) public {
202         require(msg.sender == _owner);
203         _dev = _receiver;
204     }
205 
206     function changeDev(address _receiver) public {
207         require(msg.sender == _dev);
208         _owner = _receiver;
209     }
210 
211     function changeDevFeesAddr(address _receiver) public {
212         require(msg.sender == _dev);
213         _devFeesAddr = _receiver;
214     }
215 
216     function toggleReceiveEth() public {
217         require((msg.sender == _dev) || (msg.sender == _owner));
218         if(!_receiveEth) {
219             _receiveEth = true;
220         }
221         else {
222             _receiveEth = false;
223         }
224     }
225 
226     function toggleFreezeTokensFlag() public {
227         require((msg.sender == _dev) || (msg.sender == _owner));
228         if(!_coldStorage) {
229             _coldStorage = true;
230         }
231         else {
232             _coldStorage = false;
233         }
234     }
235 
236     function defrostFrozenTokens() public {
237         require((msg.sender == _dev) || (msg.sender == _owner));
238         _totalSupply = add(_totalSupply, _frozenTokens);
239         _frozenTokens = 0;
240     }
241 
242     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
243         require((msg.sender == _dev) || (msg.sender == _owner));
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
274     function getBalance() public constant returns (uint256) {
275         return this.balance;
276     }
277 
278     function getLifeVal() public constant returns (uint256) {
279         require((msg.sender == _owner) || (msg.sender == _dev));
280         return _lifeVal;
281     }
282 
283     function getCirculatingSupply() public constant returns (uint256) {
284         return _circulatingSupply;
285     }
286 
287     function payFeesToggle() {
288         require((msg.sender == _dev) || (msg.sender == _owner));
289         if(_payFees) {
290             _payFees = false;
291         }
292         else {
293             _payFees = true;
294         }
295     }
296 
297     // enables fee update - must be between 0 and 100 (%)
298     function updateFeeAmount(uint _newFee) public {
299         require((msg.sender == _dev) || (msg.sender == _owner));
300         require((_newFee >= 0) && (_newFee <= 100));
301         _fees = _newFee * 100;
302     }
303 
304     function withdrawDevFees() public {
305         require(_payFees);
306         _devFeesAddr.transfer(_devFees);
307         _devFees = 0;
308     }
309 
310     function mul(uint a, uint b) internal pure returns (uint) {
311         uint c = a * b;
312         require(a == 0 || c / a == b);
313         return c;
314     }
315 
316     function div(uint a, uint b) internal pure returns (uint) {
317         // assert(b > 0); // Solidity automatically throws when dividing by 0
318         uint c = a / b;
319         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
320         return c;
321     }
322 
323     function sub(uint a, uint b) internal pure returns (uint) {
324         require(b <= a);
325         return a - b;
326     }
327 
328     function add(uint a, uint b) internal pure returns (uint) {
329         uint c = a + b;
330         require(c >= a);
331         return c;
332     }
333 }