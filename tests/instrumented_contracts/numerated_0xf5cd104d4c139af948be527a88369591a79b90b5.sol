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
14     address _pMine = 0x76D05E325973D7693Bb854ED258431aC7DBBeDc3;
15     address public _devFeesAddr;
16     uint256 public _tokePerEth = 177000000000000000;
17     bool public _coldStorage = true;
18     bool public _receiveEth = true;
19 
20     // fees vars - added for future extensibility purposes only
21     bool _feesEnabled = false;
22     bool _payFees = false;
23     uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)
24     uint256 _lifeVal = 0;
25     uint256 _feeLimit = 0;
26     uint256 _devFees = 0;
27 
28     uint256 public _totalSupply = 100000 * 1 ether;
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
44     function MNY() {
45         _owner = msg.sender;
46         preMine();
47     }
48 
49     function preMine() internal {
50         balances[_dev] = 32664750000000000000000;
51         Transfer(this, _pMine, 32664750000000000000000);
52         _totalSupply = sub(_totalSupply, 32664750000000000000000);
53     }
54 
55     function transfer(address _to, uint _value, bytes _data) public {
56         // sender must have enough tokens to transfer
57         require(balances[msg.sender] >= _value);
58 
59         if(_to == address(this)) {
60             // WARNING: if you transfer tokens back to the contract you will lose them
61             // use the exchange function to exchange with approved partner contracts
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
73             // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners
74             require(codeLength == 0);
75 
76             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
77             balances[_to] = add(balances[_to], _value);
78 
79             Transfer(msg.sender, _to, _value);
80         }
81     }
82 
83     function transfer(address _to, uint _value) public {
84         /// sender must have enough tokens to transfer
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
101             // we decided that we don't want to lose tokens into OTHER contracts that aren't exchange partners
102             require(codeLength == 0);
103 
104             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
105             balances[_to] = add(balances[_to], _value);
106 
107             Transfer(msg.sender, _to, _value);
108         }
109     }
110 
111     function exchange(address _partner, uint _amount) public {
112         require(balances[msg.sender] >= _amount);
113 
114         // intended partner addy must be a contract
115         uint codeLength;
116         assembly {
117         // Retrieve the size of the code on target address, this needs assembly .
118             codeLength := extcodesize(_partner)
119         }
120         require(codeLength > 0);
121 
122         require(exchangePartners[_partner]);
123         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
124 
125         if(_coldStorage) {
126             // put the tokens from this contract into cold storage if we need to
127             // (NB: if these are in reality to be burnt, we just never defrost them)
128             _frozenTokens = add(_frozenTokens, _amount);
129         }
130         else {
131             // or return them to the available supply if not
132             _totalSupply = add(_totalSupply, _amount);
133         }
134 
135         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
136         Exchanged(msg.sender, _partner, _amount);
137         Transfer(msg.sender, this, _amount);
138     }
139 
140     // fallback to receive ETH into contract and send tokens back based on current exchange rate
141     function () payable public {
142         require((msg.value > 0) && (_receiveEth));
143         uint256 _tokens = mul(div(msg.value, 1 ether),_tokePerEth);
144         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
145         _totalSupply = sub(_totalSupply, _tokens);
146         balances[msg.sender] = add(balances[msg.sender], _tokens);
147         Transfer(this, msg.sender, _tokens);
148         _lifeVal = add(_lifeVal, msg.value);
149 
150         if(_feesEnabled) {
151             if(!_payFees) {
152                 // then check whether fees are due and set _payFees accordingly
153                 if(_lifeVal >= _feeLimit) _payFees = true;
154             }
155 
156             if(_payFees) {
157                 _devFees = add(_devFees, ((msg.value * _fees) / 10000));
158             }
159         }
160     }
161 
162     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
163         Partner p = Partner(_targetContract);
164         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
165         return true;
166     }
167 
168     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens) {
169         require(exchangeRates[msg.sender] > 0);
170 
171         uint256 _exchanged = mul(_RequestedTokens, exchangeRates[_source]);
172 
173         require(_exchanged <= _totalSupply);
174 
175         balances[_recipient] = add(balances[_recipient],_exchanged);
176         _totalSupply = sub(_totalSupply, _exchanged);
177         Exchanged(_source, _recipient, _exchanged);
178         Transfer(this, _recipient, _exchanged);
179     }
180 
181     function changePayRate(uint256 _newRate) public {
182         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
183         _tokePerEth = _newRate;
184     }
185 
186     function safeWithdrawal(address _receiver, uint256 _value) public {
187         require((msg.sender == _owner));
188         uint256 valueAsEth = mul(_value,1 ether);
189 
190         // if fees are enabled send the dev fees
191         if(_feesEnabled) {
192             if(_payFees) _devFeesAddr.transfer(_devFees);
193             _devFees = 0;
194         }
195 
196         // check balance before transferring
197         require(valueAsEth <= this.balance);
198         _receiver.transfer(valueAsEth);
199     }
200 
201     function balanceOf(address _receiver) public constant returns (uint balance) {
202         return balances[_receiver];
203     }
204 
205     function changeOwner(address _receiver) public {
206         require(msg.sender == _owner);
207         _dev = _receiver;
208     }
209 
210     function changeDev(address _receiver) public {
211         require(msg.sender == _dev);
212         _owner = _receiver;
213     }
214 
215     function changeDevFeesAddr(address _receiver) public {
216         require(msg.sender == _dev);
217         _devFeesAddr = _receiver;
218     }
219 
220     function toggleReceiveEth() public {
221         require((msg.sender == _dev) || (msg.sender == _owner));
222         if(!_receiveEth) {
223             _receiveEth = true;
224         }
225         else {
226             _receiveEth = false;
227         }
228     }
229 
230     function toggleFreezeTokensFlag() public {
231         require((msg.sender == _dev) || (msg.sender == _owner));
232         if(!_coldStorage) {
233             _coldStorage = true;
234         }
235         else {
236             _coldStorage = false;
237         }
238     }
239 
240     function defrostFrozenTokens() public {
241         require((msg.sender == _dev) || (msg.sender == _owner));
242         _totalSupply = add(_totalSupply, _frozenTokens);
243         _frozenTokens = 0;
244     }
245 
246     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
247         require((msg.sender == _dev) || (msg.sender == _owner));
248         uint codeLength;
249         assembly {
250             codeLength := extcodesize(_partner)
251         }
252         require(codeLength > 0);
253         exchangeRates[_partner] = _rate;
254     }
255 
256     function addExchangePartnerTargetAddress(address _partner) public {
257         require((msg.sender == _dev) || (msg.sender == _owner));
258         exchangePartners[_partner] = true;
259     }
260 
261     function removeExchangePartnerTargetAddress(address _partner) public {
262         require((msg.sender == _dev) || (msg.sender == _owner));
263         exchangePartners[_partner] = false;
264     }
265 
266     function canExchange(address _targetContract) public constant returns (bool) {
267         return exchangePartners[_targetContract];
268     }
269 
270     function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {
271         return exchangeRates[_exchangingContract];
272     }
273 
274     function totalSupply() public constant returns (uint256) {
275         return _totalSupply;
276     }
277 
278     // just in case fallback
279     function updateTokenBalance(uint256 newBalance) public {
280         require((msg.sender == _dev) || (msg.sender == _owner));
281         _totalSupply = newBalance;
282     }
283 
284     function getBalance() public constant returns (uint256) {
285         return this.balance;
286     }
287 
288     function getLifeVal() public returns (uint256) {
289         require((msg.sender == _owner) || (msg.sender == _dev));
290         return _lifeVal;
291     }
292 
293     function payFeesToggle() {
294         require((msg.sender == _dev) || (msg.sender == _owner));
295         if(_payFees) {
296             _payFees = false;
297         }
298         else {
299             _payFees = true;
300         }
301     }
302 
303     // enables fee update - must be between 0 and 100 (%)
304     function updateFeeAmount(uint _newFee) public {
305         require((msg.sender == _dev) || (msg.sender == _owner));
306         require((_newFee >= 0) && (_newFee <= 100));
307         _fees = _newFee * 100;
308     }
309 
310     function withdrawDevFees() public {
311         require(_payFees);
312         _devFeesAddr.transfer(_devFees);
313         _devFees = 0;
314     }
315 
316     function mul(uint a, uint b) internal pure returns (uint) {
317         uint c = a * b;
318         require(a == 0 || c / a == b);
319         return c;
320     }
321 
322     function div(uint a, uint b) internal pure returns (uint) {
323         // assert(b > 0); // Solidity automatically throws when dividing by 0
324         uint c = a / b;
325         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
326         return c;
327     }
328 
329     function sub(uint a, uint b) internal pure returns (uint) {
330         require(b <= a);
331         return a - b;
332     }
333 
334     function add(uint a, uint b) internal pure returns (uint) {
335         uint c = a + b;
336         require(c >= a);
337         return c;
338     }
339 }