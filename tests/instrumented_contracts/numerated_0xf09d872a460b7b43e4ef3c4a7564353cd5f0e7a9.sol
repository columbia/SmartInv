1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address _who) public view returns (uint256);
6   function transfer(address _to, uint256 _value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address _owner, address _spender)
12     public view returns (uint256);
13 
14   function transferFrom(address _from, address _to, uint256 _value)
15     public returns (bool);
16 
17   function approve(address _spender, uint256 _value) public returns (bool);
18   event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22   );
23 }
24 
25 contract MultistageCrowdsale {
26   using SafeMath for uint256;
27 
28   /**
29    * Event for token purchase logging
30    * @param purchaser who paid for the tokens
31    * @param affiliate address, if any
32    * @param value weis paid for purchase
33    * @param amount amount of tokens purchased
34    * @param orderID to be used with fiat payments
35    */
36   event TokenPurchase(address indexed purchaser, address indexed affiliate, uint256 value, uint256 amount, bytes4 indexed orderID);
37 
38   struct Stage {
39     uint32 time;
40     uint64 rate;
41   }
42 
43   Stage[] stages;
44 
45   address wallet;
46   address token;
47   address signer;
48   uint32 saleEndTime;
49 
50   /**
51    * @dev The constructor that takes all parameters
52    * @param _timesAndRates An array that defines the stages of the contract. the first entry being the start time of the sale, followed by pairs of rates ond close times of consequitive stages.
53    *       Example 1: [10000, 99, 12000]
54    *         A single stage sale that starts at unix time 10000 and ends 2000 seconds later.
55    *         This sale gives 99 tokens for each Gwei invested.
56    *       Example 2: [10000, 99, 12000, 88, 14000]
57    *         A 2 stage sale that starts at unix time 10000 and ends 4000 seconds later.
58    *         The sale reduces the rate at mid time
59    *         This sale gives 99 tokens for each Gwei invested in first stage.
60    *         The sale gives 88 tokens for each Gwei invested in second stage.
61    * @param _wallet The address of the wallet where invested Ether will be send to
62    * @param _token The tokens that the investor will receive
63    * @param _signer The address of the key that whitelists investor (operator key)
64    */
65   constructor(
66     uint256[] _timesAndRates,
67     address _wallet,
68     address _token,
69     address _signer
70   )
71     public
72   {
73     require(_wallet != address(0));
74     require(_token != address(0));
75 
76     storeStages(_timesAndRates);
77 
78     saleEndTime = uint32(_timesAndRates[_timesAndRates.length - 1]);
79     // check sale ends after last stage opening time
80     require(saleEndTime > stages[stages.length - 1].time);
81 
82     wallet = _wallet;
83     token = _token;
84     signer = _signer;
85   }
86 
87   /**
88    * @dev called by investors to purchase tokens
89    * @param _r part of receipt signature
90    * @param _s part of receipt signature
91    * @param _a first payload of signed receipt.
92    * @param _b second payload of signed receipt.
93    *   The receipt commits to the follwing inputs:
94    *     56 bits - sale contract address, to prevent replay of receipt
95    *     32 bits - orderID for fiat payments
96    *     160 bits - beneficiary address - address whitelisted to receive tokens
97    *     32 bits - time - when receipt was signed
98    *     64 bits - oobpa - out of band payment amount, for fiat investments
99    *     160 bits - affiliate address
100    */
101 
102   function invest(bytes32 _r, bytes32 _s, bytes32 _a, bytes32 _b) public payable {
103     // parse inputs
104     uint32 time = uint32(_b >> 224);
105     address beneficiary = address(_a);
106     uint256 oobpa = uint64(_b >> 160);
107     address affiliate = address(_b);
108     // verify inputs
109     require(uint56(_a >> 192) == uint56(this));
110     if (oobpa == 0) {
111       oobpa = msg.value;
112     }
113     bytes4 orderID = bytes4(uint32(_a >> 160));
114     /* solium-disable-next-line arg-overflow */
115     require(ecrecover(keccak256(abi.encodePacked(uint8(0), uint248(_a), _b)), uint8(_a >> 248), _r, _s) == signer);
116     require(beneficiary != address(0));
117 
118     // calculate token amount to be created
119     uint256 rate = getRateAt(now); // solium-disable-line security/no-block-members
120     // at the time of signing the receipt the rate should have been the same as now
121     require(rate == getRateAt(time));
122     // multiply rate with Gwei of investment
123     uint256 tokens = rate.mul(oobpa).div(1000000000);
124     // check that msg.value > 0
125     require(tokens > 0);
126 
127     // pocket Ether
128     if (msg.value > 0) {
129       wallet.transfer(oobpa);
130     }
131 
132     // do token transfer
133     ERC20(token).transferFrom(wallet, beneficiary, tokens);
134     emit TokenPurchase(beneficiary, affiliate, oobpa, tokens, orderID);
135   }
136 
137   function getParams() view public returns (uint256[] _times, uint256[] _rates, address _wallet, address _token, address _signer) {
138     _times = new uint256[](stages.length + 1);
139     _rates = new uint256[](stages.length);
140     for (uint256 i = 0; i < stages.length; i++) {
141       _times[i] = stages[i].time;
142       _rates[i] = stages[i].rate;
143     }
144     _times[stages.length] = saleEndTime;
145     _wallet = wallet;
146     _token = token;
147     _signer = signer;
148   }
149 
150   function storeStages(uint256[] _timesAndRates) internal {
151     // check odd amount of array elements, tuples of rate and time + saleEndTime
152     require(_timesAndRates.length % 2 == 1);
153     // check that at least 1 stage provided
154     require(_timesAndRates.length >= 3);
155 
156     for (uint256 i = 0; i < _timesAndRates.length / 2; i++) {
157       stages.push(Stage(uint32(_timesAndRates[i * 2]), uint64(_timesAndRates[(i * 2) + 1])));
158       if (i > 0) {
159         // check that each time higher than previous time
160         require(stages[i-1].time < stages[i].time);
161         // check that each rate is lower than previous rate
162         require(stages[i-1].rate > stages[i].rate);
163       }
164     }
165 
166     // check that opening time in the future
167     require(stages[0].time > now); // solium-disable-line security/no-block-members
168 
169     // check final rate > 0
170     require(stages[stages.length - 1].rate > 0);
171   }
172 
173   function getRateAt(uint256 _now) view internal returns (uint256 rate) {
174     // if before first stage, return 0
175     if (_now < stages[0].time) {
176       return 0;
177     }
178 
179     for (uint i = 1; i < stages.length; i++) {
180       if (_now < stages[i].time)
181         return stages[i - 1].rate;
182     }
183 
184     // handle last stage
185     if (_now < saleEndTime)
186       return stages[stages.length - 1].rate;
187 
188     // sale already closed
189     return 0;
190   }
191 
192 }
193 
194 library SafeMath {
195 
196   /**
197   * @dev Multiplies two numbers, throws on overflow.
198   */
199   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
200     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
201     // benefit is lost if 'b' is also tested.
202     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
203     if (_a == 0) {
204       return 0;
205     }
206 
207     c = _a * _b;
208     assert(c / _a == _b);
209     return c;
210   }
211 
212   /**
213   * @dev Integer division of two numbers, truncating the quotient.
214   */
215   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
216     // assert(_b > 0); // Solidity automatically throws when dividing by 0
217     // uint256 c = _a / _b;
218     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
219     return _a / _b;
220   }
221 
222   /**
223   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
224   */
225   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
226     assert(_b <= _a);
227     return _a - _b;
228   }
229 
230   /**
231   * @dev Adds two numbers, throws on overflow.
232   */
233   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
234     c = _a + _b;
235     assert(c >= _a);
236     return c;
237   }
238 }