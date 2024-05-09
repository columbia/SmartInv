1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 pragma solidity ^0.4.11;
7 
8 /**
9  * ERC 20 token
10  *
11  * https://github.com/ethereum/EIPs/issues/20
12  */
13 contract ZeePinToken  {
14     function balanceOf(address _owner) constant returns (uint256 balance) {
15         return balances[_owner];
16     }
17 
18     function approve(address _spender, uint256 _value) returns (bool success) {
19         allowed[msg.sender][_spender] = _value;
20         Approval(msg.sender, _spender, _value);
21         return true;
22     }
23 
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
25       return allowed[_owner][_spender];
26     }
27 
28     mapping(address => uint256) balances;
29 
30     mapping (address => mapping (address => uint256)) allowed;
31 
32     uint256 public totalSupply;
33 
34 
35     string public name = "ZeePin Token";
36     string public symbol = "ZPT";
37     uint public decimals = 18;
38 
39     uint public startTime; //crowdsale start time (set in constructor)
40     uint public endTime; //crowdsale end time (set in constructor)
41     uint public startEarlyBird;  //crowdsale end time (set in constructor)
42     uint public endEarlyBird;  //crowdsale end time (set in constructor)
43     uint public startPeTime;  //pe start time (set in constructor)
44     uint public endPeTime; //pe end time (set in constructor)
45     uint public endFirstWeek;
46     uint public endSecondWeek;
47     uint public endThirdWeek;
48     uint public endFourthWeek;
49     uint public endFifthWeek;
50 
51 
52     // Initial founder address (set in constructor)
53     // All deposited ETH will be instantly forwarded to this address.
54     address public founder = 0x0;
55 
56     // signer address (for clickwrap agreement)
57     // see function() {} for comments
58     address public signer = 0x0;
59 
60     // price is defined by time
61     uint256 public pePrice = 6160;
62     uint256 public earlyBirdPrice = 5720;
63     uint256 public firstWeekTokenPrice = 4840;
64     uint256 public secondWeekTokenPrice = 4752;
65     uint256 public thirdWeekTokenPrice = 4620;
66     uint256 public fourthWeekTokenPrice = 4532;
67     uint256 public fifthWeekTokenPrice = 4400;
68 
69     uint256 public etherCap = 90909 * 10**decimals; //max amount raised during crowdsale, which represents 5,100,000,000 ZPTs
70     uint256 public totalMintedToken = 1000000000;
71     uint256 public etherLowLimit = 16500 * 10**decimals;
72     uint256 public earlyBirdCap = 6119 * 10**decimals;
73     uint256 public earlyBirdMinPerPerson = 5 * 10**decimals;
74     uint256 public earlyBirdMaxPerPerson = 200 * 10**decimals;
75     uint256 public peCap = 2700 * 10**decimals;
76     uint256 public peMinPerPerson = 150 * 10**decimals;
77     uint256 public peMaxPerPerson = 450 * 10**decimals;
78     uint256 public regularMinPerPerson = 1 * 10**17;
79     uint256 public regularMaxPerPerson = 200 * 10**decimals;
80 
81     uint public transferLockup = 15 days ; //transfers are locked for this time period after
82 
83     uint public founderLockup = 2 weeks; //founder allocation cannot be created until this time period after endTime
84     
85 
86     uint256 public founderAllocation = 100 * 10**16; //100% of token supply allocated post-crowdsale for the founder/operation allocation
87 
88 
89     bool public founderAllocated = false; //this will change to true when the founder fund is allocated
90 
91     uint256 public saleTokenSupply = 0; //this will keep track of the token supply created during the crowdsale
92     uint256 public saleEtherRaised = 0; //this will keep track of the Ether raised during the crowdsale
93     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency
94 
95     event Buy(uint256 eth, uint256 fbt);
96     event AllocateFounderTokens(address indexed sender);
97     event Transfer(address indexed _from, address indexed _to, uint256 _value);
98     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99     event print(bytes32 msg);
100 
101     //constructor
102     function ZeePinToken(address founderInput, address signerInput, uint startTimeInput, uint endTimeInput, uint startEarlyBirdInput, uint endEarlyBirdInput, uint startPeInput, uint endPeInput) {
103         founder = founderInput;
104         signer = signerInput;
105         startTime = startTimeInput;
106         endTime = endTimeInput;
107         startEarlyBird = startEarlyBirdInput;
108         endEarlyBird = endEarlyBirdInput;
109         startPeTime = startPeInput;
110         endPeTime = endPeInput;
111         
112         endFirstWeek = startTime + 1 weeks;
113         endSecondWeek = startTime + 2 weeks;
114         endThirdWeek = startTime + 3 weeks;
115         endFourthWeek = startTime + 4 weeks;
116         endFifthWeek = startTime + 5 weeks;
117     }
118 
119     //price based on current token supply
120     function price() constant returns(uint256) {
121         if (now <= endEarlyBird && now >= startEarlyBird) return earlyBirdPrice;
122         if (now <= endFirstWeek) return firstWeekTokenPrice;
123         if (now <= endSecondWeek) return secondWeekTokenPrice;
124         if (now <= endThirdWeek) return thirdWeekTokenPrice;
125         if (now <= endFourthWeek) return fourthWeekTokenPrice;
126         if (now <= endFifthWeek) return fifthWeekTokenPrice;
127         return fifthWeekTokenPrice;
128     }
129 
130     // price() exposed for unit tests
131     function testPrice(uint256 currentTime) constant returns(uint256) {
132         if (currentTime < endEarlyBird && currentTime >= startEarlyBird) return earlyBirdPrice;
133         if (currentTime < endFirstWeek && currentTime >= startTime) return firstWeekTokenPrice;
134         if (currentTime < endSecondWeek && currentTime >= endFirstWeek) return secondWeekTokenPrice;
135         if (currentTime < endThirdWeek && currentTime >= endSecondWeek) return thirdWeekTokenPrice;
136         if (currentTime < endFourthWeek && currentTime >= endThirdWeek) return fourthWeekTokenPrice;
137         if (currentTime < endFifthWeek && currentTime >= endFourthWeek) return fifthWeekTokenPrice;
138         return fifthWeekTokenPrice;
139     }
140 
141 
142     // Buy entry point
143     function buy( bytes32 hash) payable {
144         print(hash);
145         if (((now < startTime || now >= endTime) && (now < startEarlyBird || now >= endEarlyBird)) || halted) revert();
146         if (now>=startEarlyBird && now<endEarlyBird) {
147             if (msg.value < earlyBirdMinPerPerson || msg.value > earlyBirdMaxPerPerson || (saleEtherRaised + msg.value) > (peCap + earlyBirdCap)) {
148                 revert();
149             }
150         }
151         if (now>=startTime && now<endTime) {
152             if (msg.value < regularMinPerPerson || msg.value > regularMaxPerPerson || (saleEtherRaised + msg.value) > etherCap ) {
153                 revert();
154             }
155         }
156         uint256 tokens = (msg.value * price());
157         balances[msg.sender] = (balances[msg.sender] + tokens);
158         totalSupply = (totalSupply + tokens);
159         saleEtherRaised = (saleEtherRaised + msg.value);
160 
161         if (!founder.call.value(msg.value)()) revert(); //immediately send Ether to founder address
162 
163         Buy(msg.value, tokens);
164     }
165 
166     /**
167      * Set up founder address token balance.
168      *
169      * Security review
170      *
171      * - Integer math: ok - only called once with fixed parameters
172      *
173      * Applicable tests:
174      *
175      *
176      */
177     function allocateFounderTokens() {
178         if (msg.sender!=founder) revert();
179         if (now <= endTime + founderLockup) revert();
180         if (founderAllocated) revert();
181         balances[founder] = (balances[founder] + totalSupply * founderAllocation / (1 ether));
182         totalSupply = (totalSupply + totalSupply * founderAllocation / (1 ether));
183         founderAllocated = true;
184         AllocateFounderTokens(msg.sender);
185     }
186 
187     /**
188      * Set up founder address token balance.
189      *
190      * Security review
191      *
192      * - Integer math: ok - only called once with fixed parameters
193      *
194      * Applicable tests:
195      *
196      *
197      */
198     function offlineSales(uint256 offlineNum, uint256 offlineEther) {
199         if (msg.sender!=founder) revert();
200         // if (now >= startEarlyBird && now <= endEarlyBird) revert(); //offline sales can be done only during early bird time 
201         if (saleEtherRaised + offlineEther > etherCap) revert();
202         totalSupply = (totalSupply + offlineNum);
203         balances[founder] = (balances[founder] + offlineNum );
204         saleEtherRaised = (saleEtherRaised + offlineEther);
205     }
206 
207     /**
208      * Emergency Stop ICO.
209      *
210      *  Applicable tests:
211      *
212      * - Test unhalting, buying, and succeeding
213      */
214     function halt() {
215         if (msg.sender!=founder) revert();
216         halted = true;
217     }
218 
219     function unhalt() {
220         if (msg.sender!=founder) revert();
221         halted = false;
222     }
223 
224     /**
225      * Change founder address (where ICO ETH is being forwarded).
226      *
227      * Applicable tests:
228      *
229      * - Test founder change by hacker
230      * - Test founder change
231      * - Test founder token allocation twice
232      */
233     function changeFounder(address newFounder) {
234         if (msg.sender!=founder) revert();
235         founder = newFounder;
236     }
237 
238     /**
239      * ERC 20 Standard Token interface transfer function
240      *
241      * Prevent transfers until freeze period is over.
242      *
243      * Applicable tests:
244      *
245      * - Test restricted early transfer
246      * - Test transfer after restricted period
247      */
248     function transfer(address _to, uint256 _value) returns (bool success) {
249         if (now <= endTime + transferLockup) revert();
250 
251         //Default assumes totalSupply can't be over max (2^256 - 1).
252         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
253         //Replace the if with this one instead.
254         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
255         //if (balances[msg.sender] >= _value && _value > 0) {
256             balances[msg.sender] -= _value;
257             balances[_to] += _value;
258             Transfer(msg.sender, _to, _value);
259             return true;
260         } else { return false; }
261 
262     }
263     /**
264      * ERC 20 Standard Token interface transfer function
265      *
266      * Prevent transfers until freeze period is over.
267      */
268     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
269         if (msg.sender != founder) revert();
270 
271         //same as above. Replace this line with the following if you want to protect against wrapping uints.
272         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
273         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
274             balances[_to] += _value;
275             balances[_from] -= _value;
276             allowed[_from][msg.sender] -= _value;
277             Transfer(_from, _to, _value);
278             return true;
279         } else { return false; }
280     }
281 
282     /**
283      * Do not allow direct deposits.
284      *
285      * All crowdsale depositors must have read the legal agreement.
286      * This is confirmed by having them signing the terms of service on the website.
287      * The give their crowdsale Ethereum source address on the website.
288      * Website signs this address using crowdsale private key (different from founders key).
289      * buy() takes this signature as input and rejects all deposits that do not have
290      * signature you receive after reading terms of service.
291      *
292      */
293     function() payable {
294         buy(0x33);
295     }
296 
297     // only owner can kill
298     function kill() { 
299         if (msg.sender == founder) suicide(founder); 
300     }
301 
302 }