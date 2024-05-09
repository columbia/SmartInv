1 contract Partner {
2     function exchangeTokensFromOtherContract(address _source, address _recipient, uint256 _RequestedTokens);
3 }
4 
5 contract Target {
6     function transfer(address _to, uint _value);
7 }
8 
9 contract COE {
10 
11     string public name = "Coeval by Monkey Capital";
12     uint8 public decimals = 18;
13     string public symbol = "COE";
14 
15     address public owner;
16     address public devFeesAddr = 0xF772464393Ac87a1b7C628bF79090e014d931A23;
17     address public premine;
18     address tierController;
19 
20     uint256[] tierTokens = [
21         1000000000000000000000,
22         900000000000000000000,
23         800000000000000000000,
24         700000000000000000000,
25         2300000000000000000000,
26         6500000000000000000000,
27         2000000000000000000000,
28         1200000000000000000000,
29         4500000000000000000000,
30         75000000000000000000
31     ];
32 
33     // cost per token (cents *10^18) amounts for each tier.
34     uint256[] costPerToken = [
35         385000000000000000000000,
36         610000000000000000000000,
37         415000000000000000000000,
38         592000000000000000000000,
39         947000000000000000000000,
40         1100000000000000000000000,
41         1123000000000000000000000,
42         1115000000000000000000000,
43         1135000000000000000000000,
44         1013000000000000000000000
45     ];
46 
47     uint256 public totalSupply = 100000000000000000000000;
48     uint tierLevel = 0;
49     uint fiatPerEth = 385000000000000000000000;    // cents per ETH in this case (*10^18)
50     uint256 circulatingSupply = 0;
51     uint maxTier = 9;
52     uint256 devFees = 0;
53     uint256 fees = 10000;  // the calculation expects % * 100 (so 10% is 1000)
54 
55     // flags
56     bool public receiveEth = true;
57     bool payFees = true;
58     bool distributionDone = false;
59     bool canExchange = true;
60 
61     // Storage
62     mapping (address => uint256) public balances;
63     mapping (address => bool) public exchangePartners;
64 
65     // events
66     event Transfer(address indexed _from, address indexed _to, uint _value);
67 
68     function COE() {
69         owner = msg.sender;
70     }
71 
72     function premine() public {
73         require(msg.sender == owner);
74         balances[premine] = add(balances[premine],32664993546427000000000);
75         Transfer(this, premine, 32664993546427000000000);
76         circulatingSupply = add(circulatingSupply, 32664993546427000000000);
77         totalSupply = sub(totalSupply,32664993546427000000000);
78     }
79 
80     function () payable public {
81         require((msg.value > 0) && (receiveEth));
82 
83         if(payFees) {
84             devFees = add(devFees, ((msg.value * fees) / 10000));
85         }
86         allocateTokens(convertEthToCents(msg.value));
87     }
88 
89     function convertEthToCents(uint256 _incoming) internal returns (uint256) {
90         return mul(_incoming, fiatPerEth);
91     }
92 
93     function allocateTokens(uint256 _submitted) internal {
94         uint256 _availableInTier = mul(tierTokens[tierLevel], costPerToken[tierLevel]);
95         uint256 _allocation = 0;
96         // multiply _submitted by cost per token and see if that is greater than _availableInTier
97 
98         if(_submitted >= _availableInTier) {
99             _allocation = tierTokens[tierLevel];
100             tierTokens[tierLevel] = 0;
101             tierLevel++;
102             _submitted = sub(_submitted, _availableInTier);
103         }
104         else {
105             uint256 _tokens = div(div(mul(_submitted, 1 ether), costPerToken[tierLevel]), 1 ether);
106             _allocation = add(_allocation, _tokens);
107             tierTokens[tierLevel] = sub(tierTokens[tierLevel], _tokens);
108             _submitted = sub(_submitted, mul(_tokens, costPerToken[tierLevel]));
109         }
110 
111         // transfer tokens allocated so far to wallet address from contract
112         balances[msg.sender] = add(balances[msg.sender],_allocation);
113         circulatingSupply = add(circulatingSupply, _allocation);
114         totalSupply = sub(totalSupply, _allocation);
115 
116         if((_submitted != 0) && (tierLevel <= maxTier)) {
117             allocateTokens(_submitted);
118         }
119         else {
120             // emit transfer event
121             Transfer(this, msg.sender, balances[msg.sender]);
122         }
123     }
124 
125     function transfer(address _to, uint _value) public {
126         // sender must have enough tokens to transfer
127         require(balances[msg.sender] >= _value);
128         totalSupply = add(totalSupply, _value);
129         circulatingSupply = sub(circulatingSupply, _value);
130 
131         if(_to == address(this)) {
132             // WARNING: if you transfer tokens back to the contract you will lose them
133             // use the exchange function to exchange for tokens with approved partner contracts
134             balances[msg.sender] = sub(balanceOf(msg.sender), _value);
135             Transfer(msg.sender, _to, _value);
136         }
137         else {
138             uint codeLength;
139 
140             assembly {
141                 codeLength := extcodesize(_to)
142             }
143 
144             if(codeLength != 0) {
145                 if(exchangePartners[_to]) {
146                     if(canExchange == true) {
147                         exchange(_to, _value);
148                     }
149                     else revert();  // until MNY is ready to accept COE revert attempts to exchange
150                 }
151                 else {
152                     // WARNING: if you transfer to a contract that cannot handle incoming tokens you may lose them
153                     balances[msg.sender] = sub(balanceOf(msg.sender), _value);
154                     balances[_to] = add(balances[_to], _value);
155                     Transfer(msg.sender, _to, _value);
156                 }
157             }
158             else {
159                 balances[msg.sender] = sub(balanceOf(msg.sender), _value);
160                 balances[_to] = add(balances[_to], _value);
161                 Transfer(msg.sender, _to, _value);
162             }
163         }
164     }
165 
166     function exchange(address _partner, uint _amount) internal {
167         require(exchangePartners[_partner]);
168         require(requestTokensFromOtherContract(_partner, this, msg.sender, _amount));
169         balances[msg.sender] = sub(balanceOf(msg.sender), _amount);
170         circulatingSupply = sub(circulatingSupply, _amount);
171         totalSupply = add(totalSupply, _amount);
172         Transfer(msg.sender, this, _amount);
173     }
174 
175     function requestTokensFromOtherContract(address _targetContract, address _sourceContract, address _recipient, uint256 _value) internal returns (bool){
176         Partner p = Partner(_targetContract);
177         p.exchangeTokensFromOtherContract(_sourceContract, _recipient, _value);
178         return true;
179     }
180 
181     function balanceOf(address _receiver) public constant returns (uint256) {
182         return balances[_receiver];
183     }
184 
185     function balanceInTier() public constant returns (uint256) {
186         return tierTokens[tierLevel];
187     }
188 
189     function currentTier() public constant returns (uint256) {
190         return tierLevel;
191     }
192 
193     function setFiatPerEthRate(uint256 _newRate) {
194         require(msg.sender == owner);
195         fiatPerEth = _newRate;
196     }
197 
198     function addExchangePartnerTargetAddress(address _partner) public {
199         require(msg.sender == owner);
200         exchangePartners[_partner] = true;
201     }
202 
203     function canContractExchange(address _contract) public constant returns (bool) {
204         return exchangePartners[_contract];
205     }
206 
207     function removeExchangePartnerTargetAddress(address _partner) public {
208         require(msg.sender == owner);
209         exchangePartners[_partner] = false;
210     }
211 
212     function withdrawDevFees() public {
213         require(payFees);
214         devFeesAddr.transfer(devFees);
215         devFees = 0;
216     }
217 
218     function changeDevFees(address _devFees) public {
219         require(msg.sender == owner);
220         devFeesAddr = _devFees;
221     }
222 
223     function changePreMine(address _preMine) {
224         require(msg.sender == owner);
225         premine = _preMine;
226     }
227 
228     function payFeesToggle() {
229         require(msg.sender == owner);
230         if(payFees) {
231             payFees = false;
232         }
233         else {
234             payFees = true;
235         }
236     }
237 
238     function safeWithdrawal(address _receiver, uint256 _value) public {
239         require(msg.sender == owner);
240         // check balance before transferring
241         require(_value <= this.balance);
242         _receiver.transfer(_value);
243     }
244 
245     // enables fee update - must be between 0 and 100 (%)
246     function updateFeeAmount(uint _newFee) public {
247         require(msg.sender == owner);
248         require((_newFee >= 0) && (_newFee <= 100));
249         fees = _newFee * 100;
250     }
251 
252     function handleTokensFromOtherContracts(address _contract, address _recipient, uint256 _tokens) {
253         require(msg.sender == owner);
254         Target t;
255         t = Target(_contract);
256         t.transfer(_recipient, _tokens);
257     }
258 
259     function changeOwner(address _recipient) {
260         require(msg.sender == owner);
261         owner = _recipient;
262     }
263 
264     function changeTierController(address _controller) {
265         require(msg.sender == owner);
266         tierController = _controller;
267     }
268 
269     function setTokenAndRate(uint256 _tokens, uint256 _rate) {
270         require((msg.sender == owner) || (msg.sender == tierController));
271         maxTier++;
272         tierTokens[maxTier] = _tokens;
273         costPerToken[maxTier] = _rate;
274     }
275 
276     function setPreMineAddress(address _premine) {
277         require(msg.sender == owner);
278         premine = _premine;
279     }
280 
281     function toggleReceiveEth() {
282         require(msg.sender == owner);
283         if(receiveEth == true) {
284             receiveEth = false;
285         }
286         else receiveEth = true;
287     }
288 
289     function toggleTokenExchange() {
290         require(msg.sender == owner);
291         if(canExchange == true) {
292             canExchange = false;
293         }
294         else canExchange = true;
295     }
296 
297     function mul(uint a, uint b) internal pure returns (uint) {
298         uint c = a * b;
299         require(a == 0 || c / a == b);
300         return c;
301     }
302 
303     function div(uint a, uint b) internal pure returns (uint) {
304         // assert(b > 0); // Solidity automatically throws when dividing by 0
305         uint c = a / b;
306         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307         return c;
308     }
309 
310     function sub(uint a, uint b) internal pure returns (uint) {
311         require(b <= a);
312         return a - b;
313     }
314 
315     function add(uint a, uint b) internal pure returns (uint) {
316         uint c = a + b;
317         require(c >= a);
318         return c;
319     }
320 }