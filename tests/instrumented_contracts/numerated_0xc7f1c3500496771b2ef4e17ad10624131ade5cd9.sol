1 pragma solidity ^0.4.21;
2 
3 contract Partner {
4     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
5 }
6 
7 contract COE {
8 
9     string public name = "CoEval";
10     uint8 public decimals = 18;
11     string public symbol = "COE";
12 
13     address public _owner;
14     address public _premine = 0x76D05E325973D7693Bb854ED258431aC7DBBeDc3;
15     address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
16     address public _devFeesAddr;
17     uint256 public _tokePerEth = 177000000000000000;
18     bool public _coldStorage = true;
19     bool public _receiveEth = true;
20     // fees vars - added for future extensibility purposes only
21     bool _feesEnabled = false;
22     bool _payFees = false;
23     uint256 _fees;  // the calculation expects % * 100 (so 10% is 1000)
24     uint256 _lifeVal = 0;
25     uint256 _feeLimit = 0;
26     uint256 _devFees = 0;
27 
28     uint256 public _totalSupply = 100000 * 1 ether;
29     uint256 public _circulatingSupply = 0;
30     uint256 public _frozenTokens = 0;
31 
32     event Transfer(address indexed _from, address indexed _to, uint _value);
33     event Exchanged(address indexed _from, address indexed _to, uint _value);
34     // Storage
35     mapping (address => uint256) public balances;
36 
37     // list of contract addresses that can request tokens
38     // use add/remove functions to update
39     mapping (address => bool) public exchangePartners;
40 
41     // permitted exch partners and associated token rates
42     // rate is X target tokens per Y incoming so newTokens = Tokens/Rate
43     mapping (address => uint256) public exchangeRates;
44 
45     function COE() {
46         _owner = msg.sender;
47         preMine();
48     }
49 
50     function preMine() internal {
51         balances[_premine] = 32664750000000000000000;
52         Transfer(this, _premine, 32664750000000000000000);
53         _totalSupply = sub(_totalSupply, 32664750000000000000000);
54         _circulatingSupply = add(_circulatingSupply, 32664750000000000000000);
55     }
56 
57     function transfer(address _to, uint _value, bytes _data) public {
58         // sender must have enough tokens to transfer
59         require(balances[msg.sender] >= _value);
60 
61         if(_to == address(this)) {
62             // WARNING: if you transfer tokens back to the contract you will lose them
63             _totalSupply = add(_totalSupply, _value);
64             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
65             Transfer(msg.sender, _to, _value);
66         }
67         else {
68             uint codeLength;
69 
70             assembly {
71                 codeLength := extcodesize(_to)
72             }
73 
74             if(codeLength != 0) {
75                 // only allow transfer to exchange partner contracts - this is handled by another function
76                 exchange(_to, _value);
77             }
78             else {
79                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
80                 balances[_to] = add(balances[_to], _value);
81 
82                 Transfer(msg.sender, _to, _value);
83             }
84         }
85     }
86 
87     function transfer(address _to, uint _value) public {
88         /// sender must have enough tokens to transfer
89         require(balances[msg.sender] >= _value);
90 
91         if(_to == address(this)) {
92             // WARNING: if you transfer tokens back to the contract you will lose them
93             // use the exchange function to exchange for tokens with approved partner contracts
94             _totalSupply = add(_totalSupply, _value);
95             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
96             Transfer(msg.sender, _to, _value);
97         }
98         else {
99             uint codeLength;
100 
101             assembly {
102                 codeLength := extcodesize(_to)
103             }
104 
105             if(codeLength != 0) {
106                 // only allow transfer to exchange partner contracts - this is handled by another function
107                 exchange(_to, _value);
108             }
109             else {
110                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
111                 balances[_to] = add(balances[_to], _value);
112 
113                 Transfer(msg.sender, _to, _value);
114             }
115         }
116     }
117 
118     function exchange(address _partner, uint _amount) internal {
119         require(exchangePartners[_partner]);
120         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
121 
122         if(_coldStorage) {
123             // put the tokens from this contract into cold storage if we need to
124             // (NB: if these are in reality to be burnt, we just never defrost them)
125             _frozenTokens = add(_frozenTokens, _amount);
126         }
127         else {
128             // or return them to the available supply if not
129             _totalSupply = add(_totalSupply, _amount);
130         }
131 
132         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
133         _circulatingSupply = sub(_circulatingSupply, _amount);
134         Exchanged(msg.sender, _partner, _amount);
135         Transfer(msg.sender, this, _amount);
136     }
137 
138     // fallback to receive ETH into contract and send tokens back based on current exchange rate
139     function () payable public {
140         require((msg.value > 0) && (_receiveEth));
141         uint256 _tokens = div(mul(msg.value,_tokePerEth), 1 ether);
142         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
143         _totalSupply = sub(_totalSupply, _tokens);
144         balances[msg.sender] = add(balances[msg.sender], _tokens);
145         _circulatingSupply = add(_circulatingSupply, _tokens);
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
167     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens) {
168         require(exchangeRates[msg.sender] > 0);
169         uint256 _exchanged = mul(_RequestedTokens, exchangeRates[_source]);
170         require(_exchanged <= _totalSupply);
171         balances[_recipient] = add(balances[_recipient],_exchanged);
172         _totalSupply = sub(_totalSupply, _exchanged);
173         _circulatingSupply = add(_circulatingSupply, _exchanged);
174         Exchanged(_source, _recipient, _exchanged);
175         Transfer(this, _recipient, _exchanged);
176     }
177 
178     function changePayRate(uint256 _newRate) public {
179         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
180         _tokePerEth = _newRate;
181     }
182 
183     function safeWithdrawal(address _receiver, uint256 _value) public {
184         require((msg.sender == _owner));
185         uint256 valueAsEth = mul(_value,1 ether);
186 
187         // if fees are enabled send the dev fees
188         if(_feesEnabled) {
189             if(_payFees) _devFeesAddr.transfer(_devFees);
190             _devFees = 0;
191         }
192 
193         // check balance before transferring
194         require(valueAsEth <= this.balance);
195         _receiver.transfer(valueAsEth);
196     }
197 
198     function balanceOf(address _receiver) public constant returns (uint balance) {
199         return balances[_receiver];
200     }
201 
202     function changeOwner(address _receiver) public {
203         require(msg.sender == _owner);
204         _dev = _receiver;
205     }
206 
207     function changeDev(address _receiver) public {
208         require(msg.sender == _dev);
209         _owner = _receiver;
210     }
211 
212     function changeDevFeesAddr(address _receiver) public {
213         require(msg.sender == _dev);
214         _devFeesAddr = _receiver;
215     }
216 
217     function toggleReceiveEth() public {
218         require((msg.sender == _dev) || (msg.sender == _owner));
219         if(!_receiveEth) {
220             _receiveEth = true;
221         }
222         else {
223             _receiveEth = false;
224         }
225     }
226 
227     function toggleFreezeTokensFlag() public {
228         require((msg.sender == _dev) || (msg.sender == _owner));
229         if(!_coldStorage) {
230             _coldStorage = true;
231         }
232         else {
233             _coldStorage = false;
234         }
235     }
236 
237     function defrostFrozenTokens() public {
238         require((msg.sender == _dev) || (msg.sender == _owner));
239         _totalSupply = add(_totalSupply, _frozenTokens);
240         _frozenTokens = 0;
241     }
242 
243     function addExchangePartnerAddressAndRate(address _partner, uint256 _rate) {
244         require((msg.sender == _dev) || (msg.sender == _owner));
245         uint codeLength;
246         assembly {
247             codeLength := extcodesize(_partner)
248         }
249         require(codeLength > 0);
250         exchangeRates[_partner] = _rate;
251     }
252 
253     function addExchangePartnerTargetAddress(address _partner) public {
254         require((msg.sender == _dev) || (msg.sender == _owner));
255         exchangePartners[_partner] = true;
256     }
257 
258     function removeExchangePartnerTargetAddress(address _partner) public {
259         require((msg.sender == _dev) || (msg.sender == _owner));
260         exchangePartners[_partner] = false;
261     }
262 
263     function canExchange(address _targetContract) public constant returns (bool) {
264         return exchangePartners[_targetContract];
265     }
266 
267     function contractExchangeRate(address _exchangingContract) public constant returns (uint256) {
268         return exchangeRates[_exchangingContract];
269     }
270 
271     function totalSupply() public constant returns (uint256) {
272         return _totalSupply;
273     }
274 
275     function getBalance() public constant returns (uint256) {
276         return this.balance;
277     }
278 
279     function getLifeVal() public constant returns (uint256) {
280         require((msg.sender == _owner) || (msg.sender == _dev));
281         return _lifeVal;
282     }
283 
284     function getCirculatingSupply() public constant returns (uint256) {
285         return _circulatingSupply;
286     }
287 
288     function payFeesToggle() {
289         require((msg.sender == _dev) || (msg.sender == _owner));
290         if(_payFees) {
291             _payFees = false;
292         }
293         else {
294             _payFees = true;
295         }
296     }
297 
298     // enables fee update - must be between 0 and 100 (%)
299     function updateFeeAmount(uint _newFee) public {
300         require((msg.sender == _dev) || (msg.sender == _owner));
301         require((_newFee >= 0) && (_newFee <= 100));
302         _fees = _newFee * 100;
303     }
304 
305     function withdrawDevFees() public {
306         require(_payFees);
307         _devFeesAddr.transfer(_devFees);
308         _devFees = 0;
309     }
310 
311     function mul(uint a, uint b) internal pure returns (uint) {
312         uint c = a * b;
313         require(a == 0 || c / a == b);
314         return c;
315     }
316 
317     function div(uint a, uint b) internal pure returns (uint) {
318         // assert(b > 0); // Solidity automatically throws when dividing by 0
319         uint c = a / b;
320         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
321         return c;
322     }
323 
324     function sub(uint a, uint b) internal pure returns (uint) {
325         require(b <= a);
326         return a - b;
327     }
328 
329     function add(uint a, uint b) internal pure returns (uint) {
330         uint c = a + b;
331         require(c >= a);
332         return c;
333     }
334 }