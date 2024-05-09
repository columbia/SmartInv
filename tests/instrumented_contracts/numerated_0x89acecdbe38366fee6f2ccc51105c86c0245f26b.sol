1 contract ERC20Basic {
2   function totalSupply() public view returns (uint256);
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) public view returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11   function approve(address spender, uint256 value) public returns (bool);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract MultistageCrowdsale {
16   using SafeMath for uint256;
17 
18   /**
19    * Event for token purchase logging
20    * @param purchaser who paid for the tokens
21    * @param value weis paid for purchase
22    * @param amount amount of tokens purchased
23    */
24   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
25 
26   struct Stage {
27     uint32 time;
28     uint64 rate;
29   }
30 
31   Stage[] stages;
32 
33   address wallet;
34   address token;
35   address signer;
36   uint32 saleEndTime;
37 
38   /**
39    * @dev The constructor that takes all parameters
40    * @param _timesAndRates An array that defines the stages of the contract. the first entry being the start time of the sale, followed by pairs of rates ond close times of consequitive stages.
41    *       Example 1: [10000, 99, 12000]
42    *         A single stage sale that starts at unix time 10000 and ends 2000 seconds later.
43    *         This sale gives 99 tokens for each Gwei invested.
44    *       Example 2: [10000, 99, 12000, 88, 14000]
45    *         A 2 stage sale that starts at unix time 10000 and ends 4000 seconds later.
46    *         The sale reduces the rate at mid time
47    *         This sale gives 99 tokens for each Gwei invested in first stage.
48    *         The sale gives 88 tokens for each Gwei invested in second stage.
49    * @param _wallet The address of the wallet where invested Ether will be send to
50    * @param _token The tokens that the investor will receive
51    * @param _signer The address of the key that whitelists investor (operator key)
52    */
53   constructor(
54     uint256[] _timesAndRates,
55     address _wallet,
56     address _token,
57     address _signer
58   )
59     public
60   {
61     require(_wallet != address(0));
62     require(_token != address(0));
63 
64     storeStages(_timesAndRates);
65 
66     saleEndTime = uint32(_timesAndRates[_timesAndRates.length - 1]);
67     // check sale ends after last stage opening time
68     require(saleEndTime > stages[stages.length - 1].time);
69 
70     wallet = _wallet;
71     token = _token;
72     signer = _signer;
73   }
74 
75   /**
76    * @dev called by investors to purchase tokens
77    * @param _r part of receipt signature
78    * @param _s part of receipt signature
79    * @param _payload payload of signed receipt.
80    *   The receipt commits to the follwing inputs:
81    *     160 bits - beneficiary address - address whitelisted to receive tokens
82    *     32 bits - time - when receipt was signed
83    *     56 bits - sale contract address, to prevent replay of receipt
84    *     8 bits - v-part of receipt signature
85    */
86   function purchase(bytes32 _r, bytes32 _s, bytes32 _payload) public payable {
87     // parse inputs
88     uint32 time = uint32(_payload >> 160);
89     address beneficiary = address(_payload);
90     // verify inputs
91     require(uint56(_payload >> 192) == uint56(this));
92     /* solium-disable-next-line arg-overflow */
93     require(ecrecover(keccak256(uint8(0), uint56(_payload >> 192), time, beneficiary), uint8(_payload >> 248), _r, _s) == signer);
94     require(beneficiary != address(0));
95 
96     // calculate token amount to be created
97     uint256 rate = getRateAt(now); // solium-disable-line security/no-block-members
98     // at the time of signing the receipt the rate should have been the same as now
99     require(rate == getRateAt(time));
100     // multiply rate with Gwei of investment
101     uint256 tokens = rate.mul(msg.value).div(1000000000);
102     // check that msg.value > 0
103     require(tokens > 0);
104 
105     // pocket Ether
106     wallet.transfer(msg.value);
107 
108     // do token transfer
109     ERC20(token).transferFrom(wallet, beneficiary, tokens);
110     emit TokenPurchase(beneficiary, msg.value, tokens);
111   }
112 
113   function getParams() view public returns (uint256[] _times, uint256[] _rates, address _wallet, address _token, address _signer) {
114     _times = new uint256[](stages.length + 1);
115     _rates = new uint256[](stages.length);
116     for (uint256 i = 0; i < stages.length; i++) {
117       _times[i] = stages[i].time;
118       _rates[i] = stages[i].rate;
119     }
120     _times[stages.length] = saleEndTime;
121     _wallet = wallet;
122     _token = token;
123     _signer = signer;
124   }
125 
126   function storeStages(uint256[] _timesAndRates) internal {
127     // check odd amount of array elements, tuples of rate and time + saleEndTime
128     require(_timesAndRates.length % 2 == 1);
129     // check that at least 1 stage provided
130     require(_timesAndRates.length >= 3);
131 
132     for (uint256 i = 0; i < _timesAndRates.length / 2; i++) {
133       stages.push(Stage(uint32(_timesAndRates[i * 2]), uint64(_timesAndRates[(i * 2) + 1])));
134       if (i > 0) {
135         // check that each time higher than previous time
136         require(stages[i-1].time < stages[i].time);
137         // check that each rate is lower than previous rate
138         require(stages[i-1].rate > stages[i].rate);
139       }
140     }
141 
142     // check that opening time in the future
143     require(stages[0].time > now); // solium-disable-line security/no-block-members
144 
145     // check final rate > 0
146     require(stages[stages.length - 1].rate > 0);
147   }
148 
149   function getRateAt(uint256 _now) view internal returns (uint256 rate) {
150     // if before first stage, return 0
151     if (_now < stages[0].time) {
152       return 0;
153     }
154 
155     for (uint i = 1; i < stages.length; i++) {
156       if (_now < stages[i].time)
157         return stages[i - 1].rate;
158     }
159 
160     // handle last stage
161     if (_now < saleEndTime)
162       return stages[stages.length - 1].rate;
163 
164     // sale already closed
165     return 0;
166   }
167 
168 }
169 
170 library SafeMath {
171 
172   /**
173   * @dev Multiplies two numbers, throws on overflow.
174   */
175   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
176     if (a == 0) {
177       return 0;
178     }
179     c = a * b;
180     assert(c / a == b);
181     return c;
182   }
183 
184   /**
185   * @dev Integer division of two numbers, truncating the quotient.
186   */
187   function div(uint256 a, uint256 b) internal pure returns (uint256) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     // uint256 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return a / b;
192   }
193 
194   /**
195   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
196   */
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     assert(b <= a);
199     return a - b;
200   }
201 
202   /**
203   * @dev Adds two numbers, throws on overflow.
204   */
205   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
206     c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }