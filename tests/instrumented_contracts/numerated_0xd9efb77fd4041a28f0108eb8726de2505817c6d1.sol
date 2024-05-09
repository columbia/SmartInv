1 pragma solidity ^0.4.11;
2 /**
3     ERC20 Interface
4     @author DongOk Peter Ryu - <odin@yggdrash.io>
5 */
6 contract ERC20 {
7     function totalSupply() public constant returns (uint supply);
8     function balanceOf( address who ) public constant returns (uint value);
9     function allowance( address owner, address spender ) public constant returns (uint _allowance);
10 
11     function transfer( address to, uint value) public returns (bool ok);
12     function transferFrom( address from, address to, uint value) public returns (bool ok);
13     function approve( address spender, uint value ) public returns (bool ok);
14 
15     event Transfer( address indexed from, address indexed to, uint value);
16     event Approval( address indexed owner, address indexed spender, uint value);
17 }
18 
19 library SafeMath {
20   function mul(uint a, uint b) internal returns (uint) {
21     uint c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint a, uint b) internal returns (uint) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint a, uint b) internal returns (uint) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint a, uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 
44   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a >= b ? a : b;
46   }
47 
48   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a < b ? a : b;
50   }
51 
52   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a >= b ? a : b;
54   }
55 
56   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a < b ? a : b;
58   }
59 
60 }
61 /**
62     YGGDRASH SmartContract
63     @author Peter Ryu - <odin@yggdrash.io>
64 */
65 contract YggdrashCrowd {
66     using SafeMath for uint;
67     ERC20 public yeedToken;
68     Stages stage;
69     address public wallet;
70     address public owner;
71     address public tokenOwner;
72     uint public totalAmount;    // Contruibute Token amount
73     uint public priceFactor; // ratio
74     uint public startBlock;
75     uint public totalReceived;
76     uint public endTime;
77 
78     uint public maxValue; // max ETH
79     uint public minValue;
80 
81     uint public maxGasPrice; // Max gasPrice
82 
83     // collect log
84     event FundTransfer (address sender, uint amount);
85 
86     struct ContributeAddress {
87         bool exists; // set to true
88         address account; // sending account
89         uint amount; // sending amount
90         uint balance; // token value
91         bytes data; // sending data
92     }
93 
94     mapping(address => ContributeAddress) public _contributeInfo;
95     mapping(bytes => ContributeAddress) _contruibuteData;
96 
97     /*
98         Check is owner address
99     */
100     modifier isOwner() {
101         // Only owner is allowed to proceed
102         require (msg.sender == owner);
103         _;
104     }
105 
106     /**
107         Check Valid Payload
108     */
109     modifier isValidPayload() {
110         // check Max
111         if(maxValue != 0){
112             require(msg.value < maxValue + 1);
113         }
114         // Check Min
115         if(minValue != 0){
116             require(msg.value > minValue - 1);
117         }
118         require(wallet != msg.sender);
119         // check data value
120         require(msg.data.length != 0);
121         _;
122 
123     }
124 
125     /*
126         Check exists Contribute list
127     */
128     modifier isExists() {
129         require(_contruibuteData[msg.data].exists == false);
130         require(_contributeInfo[msg.sender].amount == 0);
131         _;
132     }
133 
134     /*
135      *  Modifiers Stage
136      */
137     modifier atStage(Stages _stage) {
138         require(stage == _stage);
139         _;
140     }
141 
142 
143     /*
144      *  Enums Stage Status
145      */
146     enum Stages {
147     Deployed,
148     SetUp,
149     Started,
150     Ended
151     }
152 
153 
154     /// init
155     /// @param _token token address
156     /// @param _tokenOwner token owner wallet address
157     /// @param _wallet Send ETH wallet
158     /// @param _amount token total value
159     /// @param _priceFactor token and ETH ratio
160     /// @param _maxValue maximum ETH balance
161     /// @param _minValue minimum ETH balance
162 
163     function YggdrashCrowd(address _token, address _tokenOwner, address _wallet, uint _amount, uint _priceFactor, uint _maxValue, uint _minValue)
164     public
165     {
166         require (_tokenOwner != 0 && _wallet != 0 && _amount != 0 && _priceFactor != 0);
167         tokenOwner = _tokenOwner;
168         owner = msg.sender;
169         wallet = _wallet;
170         totalAmount = _amount;
171         priceFactor = _priceFactor;
172         maxValue = _maxValue;
173         minValue = _minValue;
174         stage = Stages.Deployed;
175 
176         if(_token != 0){ // setup token
177             yeedToken = ERC20(_token);
178             stage = Stages.SetUp;
179         }
180         // Max Gas Price is unlimited
181         maxGasPrice = 0;
182     }
183 
184     // setupToken
185     function setupToken(address _token)
186     public
187     isOwner
188     {
189         require(_token != 0);
190         yeedToken = ERC20(_token);
191         stage = Stages.SetUp;
192     }
193 
194     /// @dev Start Contruibute
195     function startContruibute()
196     public
197     isOwner
198     atStage(Stages.SetUp)
199     {
200         stage = Stages.Started;
201         startBlock = block.number;
202     }
203 
204 
205     /**
206         Contributer send to ETH
207         Payload Check
208         Exist Check
209         GasPrice Check
210         Stage Check
211     */
212     function()
213     public
214     isValidPayload
215     isExists
216     atStage(Stages.Started)
217     payable
218     {
219         uint amount = msg.value;
220         uint maxAmount = totalAmount.div(priceFactor);
221         // refund
222         if (amount > maxAmount){
223             uint refund = amount.sub(maxAmount);
224             assert(msg.sender.send(refund));
225             amount = maxAmount;
226         }
227         //  NO MORE GAS WAR!!!
228         if(maxGasPrice != 0){
229             assert(tx.gasprice < maxGasPrice + 1);
230         }
231         totalReceived = totalReceived.add(amount);
232         // calculate token
233         uint token = amount.mul(priceFactor);
234         totalAmount = totalAmount.sub(token);
235 
236         // give token to sender
237         yeedToken.transferFrom(tokenOwner, msg.sender, token);
238         FundTransfer(msg.sender, token);
239 
240         // Set Contribute Account
241         ContributeAddress crowdData = _contributeInfo[msg.sender];
242         crowdData.exists = true;
243         crowdData.account = msg.sender;
244         crowdData.data = msg.data;
245         crowdData.amount = amount;
246         crowdData.balance = token;
247         // add contruibuteData
248         _contruibuteData[msg.data] = crowdData;
249         _contributeInfo[msg.sender] = crowdData;
250         // send to wallet
251         wallet.transfer(amount);
252 
253         // token sold out
254         if (amount == maxAmount)
255             finalizeContruibute();
256     }
257 
258     /// @dev Changes auction totalAmount and start price factor before auction is started.
259     /// @param _totalAmount Updated auction totalAmount.
260     /// @param _priceFactor Updated start price factor.
261     /// @param _maxValue Maximum balance of ETH
262     /// @param _minValue Minimum balance of ETH
263     function changeSettings(uint _totalAmount, uint _priceFactor, uint _maxValue, uint _minValue, uint _maxGasPrice)
264     public
265     isOwner
266     {
267         require(_totalAmount != 0 && _priceFactor != 0);
268         totalAmount = _totalAmount;
269         priceFactor = _priceFactor;
270         maxValue = _maxValue;
271         minValue = _minValue;
272         maxGasPrice = _maxGasPrice;
273     }
274     /**
275         Set Max Gas Price by Admin
276     */
277     function setMaxGasPrice(uint _maxGasPrice)
278     public
279     isOwner
280     {
281         maxGasPrice = _maxGasPrice;
282     }
283 
284 
285     // token balance
286     // @param src sender wallet address
287     function balanceOf(address src) public constant returns (uint256)
288     {
289         return _contributeInfo[src].balance;
290     }
291 
292     // amount ETH value
293     // @param src sender wallet address
294     function amountOf(address src) public constant returns(uint256)
295     {
296         return _contributeInfo[src].amount;
297     }
298 
299     // contruibute data
300     // @param src Yggdrash uuid
301     function contruibuteData(bytes src) public constant returns(address)
302     {
303         return _contruibuteData[src].account;
304     }
305 
306     // Check contruibute is open
307     function isContruibuteOpen() public constant returns (bool)
308     {
309         return stage == Stages.Started;
310     }
311 
312     // Smartcontract halt
313     function halt()
314     public
315     isOwner
316     {
317         finalizeContruibute();
318     }
319 
320     // END of this Contruibute
321     function finalizeContruibute()
322     private
323     {
324         stage = Stages.Ended;
325         // remain token send to owner
326         totalAmount = 0;
327         endTime = now;
328     }
329 }