1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 
10 
11     address owner;
12 
13     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
14 
15     function Ownable() {
16         owner = msg.sender;
17         OwnershipTransferred (address(0), owner);
18     }
19 
20     function transferOwnership(address _newOwner)
21         public
22         onlyOwner
23         notZeroAddress(_newOwner)
24     {
25         owner = _newOwner;
26         OwnershipTransferred(msg.sender, _newOwner);
27     }
28 
29     //Only owner can call function
30     modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     modifier notZeroAddress(address _address) {
36         require(_address != address(0));
37         _;
38     }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48 
49     /*
50         @return sum of a and b
51     */
52     function ADD (uint256 a, uint256 b) internal returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 
58     /*
59         @return difference of a and b
60     */
61     function SUB (uint256 a, uint256 b) internal returns (uint256) {
62         assert(a >= b);
63         return a - b;
64     }
65     
66 }
67 
68 /*	Interface of GeeToken contract */
69 contract Token {
70 
71     function transfer(address _to, uint256 _value) 
72         external;
73 
74     function burn(uint256 _value) 
75         external;
76 
77 }
78 
79 
80 contract GEECrowdsale is Ownable {
81 
82     using SafeMath for uint256;
83 
84     //VARIABLE
85     uint256 public soldTokens;                                  //Counts how many Gee coins are soldTokens
86     
87     uint256 public hardCapInTokens = 67 * (10**6) * (10**8);    //Hard cap in Gee coins (with 8 decimals)
88     
89     uint256 public constant MIN_ETHER = 0.03 ether;             //Min amount of Ether
90     uint256 public constant MAX_ETHER = 1000 ether;             //Max amount of Ether
91 
92     
93     address fund = 0x48a2909772b049D0eA3A0979eE05eDF37119738d;  //Address where funds are forwarded during the ICO
94 
95     
96     uint256 public constant START_BLOCK_NUMBER = 4506850;       //Start block
97     
98     uint256 public constant TIER2 = 4525700;                      //Start + 3 days
99     uint256 public constant TIER3 = 4569600;                     //Start + 10 days ( 3 days + 7 days)
100     uint256 public constant TIER4 = 4632300;                     //Start + 20 days ( 3 days + 7 days + 10 days)
101     uint256 public endBlockNumber = 4695000;                        //Start + 30 days
102     uint256 public constant MAX_END_BLOCK_NUMBER = 4890000;         //End + 30 days
103 
104     uint256 public price;                                       //GEE price
105    
106     uint256 public constant TIER1_PRICE = 6000000;              //Price in 1st tier
107     uint256 public constant TIER2_PRICE = 6700000;              //Price in 2nd tier
108     uint256 public constant TIER3_PRICE = 7400000;              //Price in 3rd tier
109     uint256 public constant TIER4_PRICE = 8200000;              //Price in 4th tier
110 
111     Token public gee;                                           //GeeToken contract
112 
113     uint256 public constant SOFT_CAP_IN_ETHER = 4000 ether;    //softcap in ETH
114 
115     uint256 public collected;                                   //saves how much ETH was collected
116 
117     uint256 public constant GEE100 = 100 * (10**8);
118 
119 
120     //MAP
121     mapping (address => uint256) public bought;                 //saves how much ETH user spent on GEE
122 
123 
124     //EVENT
125     event Buy    (address indexed _who, uint256 _amount, uint256 indexed _price);   //Keep track of buyings
126     event Refund (address indexed _who, uint256 _amount);                           //Keep track of refunding
127     event CrowdsaleEndChanged (uint256 _crowdsaleEnd, uint256 _newCrowdsaleEnd);    //Notifies users about end block change
128 
129 
130     //FUNCTION
131     //Payable - can store ETH
132     function GEECrowdsale (Token _geeToken)
133         public
134         notZeroAddress(_geeToken)
135         payable
136     {
137         gee = _geeToken;
138     }
139 
140 
141     /* Fallback function is called when Ether is sent to the contract */
142     function() 
143         external 
144         payable 
145     {
146         if (isCrowdsaleActive()) {
147             buy();
148         } else { 
149             require (msg.sender == fund || msg.sender == owner);    //after crowdsale owner can send back eth for refund
150         }
151     }
152 
153 
154     /* Burn unsold GEE after crowdsale */
155     function finalize() 
156         external
157         onlyOwner
158     {
159         require(soldTokens != hardCapInTokens);
160         if (soldTokens < (hardCapInTokens - GEE100)) {
161             require(block.number > endBlockNumber);
162         }
163         hardCapInTokens = soldTokens;
164         gee.burn(hardCapInTokens.SUB(soldTokens));
165     }
166 
167 
168     /* Buy tokens */
169     function buy()
170         public
171         payable
172     {
173         uint256 amountWei = msg.value;
174         uint256 blocks = block.number;
175 
176 
177         require (isCrowdsaleActive());
178         require(amountWei >= MIN_ETHER);                            //Ether limitation
179         require(amountWei <= MAX_ETHER);
180 
181         price = getPrice();
182         
183         uint256 amount = amountWei / price;                         //Count how many GEE sender can buy
184 
185         soldTokens = soldTokens.ADD(amount);                        //Add amount to soldTokens
186 
187         require(soldTokens <= hardCapInTokens);
188 
189         if (soldTokens >= (hardCapInTokens - GEE100)) {
190             endBlockNumber = blocks;
191         }
192         
193         collected = collected.ADD(amountWei);                       //counts ETH
194         bought[msg.sender] = bought[msg.sender].ADD(amountWei);
195 
196         gee.transfer(msg.sender, amount);                           //Transfer amount of Gee coins to msg.sender
197         fund.transfer(this.balance);                                //Transfer contract Ether to fund
198 
199         Buy(msg.sender, amount, price);
200     }
201 
202 
203     /* Return Crowdsale status, depending on block numbers and stopInEmergency() state */
204     function isCrowdsaleActive() 
205         public 
206         constant 
207         returns (bool) 
208     {
209 
210         if (endBlockNumber < block.number || START_BLOCK_NUMBER > block.number) {
211             return false;
212         }
213         return true;
214     }
215 
216 
217     /* Change tier taking block numbers as time */
218     function getPrice()
219         internal
220         constant
221         returns (uint256)
222     {
223         if (block.number < TIER2) {
224             return TIER1_PRICE;
225         } else if (block.number < TIER3) {
226             return TIER2_PRICE;
227         } else if (block.number < TIER4) {
228             return TIER3_PRICE;
229         }
230 
231         return TIER4_PRICE;
232     }
233 
234 
235     /* Refund, if the soft cap is not reached */
236     function refund() 
237         external 
238     {
239         uint256 refund = bought[msg.sender];
240         require (!isCrowdsaleActive());
241         require (collected < SOFT_CAP_IN_ETHER);
242         bought[msg.sender] = 0;
243         msg.sender.transfer(refund);
244         Refund(msg.sender, refund);
245     }
246 
247 
248     function drainEther() 
249         external 
250         onlyOwner 
251     {
252         fund.transfer(this.balance);
253     }
254 
255     /*
256     Allows owner setting the new end block number to extend/close Crowdsale.
257     */
258     function setEndBlockNumber(uint256 _newEndBlockNumber) external onlyOwner {
259         require(isCrowdsaleActive());
260         require(_newEndBlockNumber >= block.number);
261         require(_newEndBlockNumber <= MAX_END_BLOCK_NUMBER);
262 
263         uint256 currentEndBlockNumber = endBlockNumber;
264         endBlockNumber = _newEndBlockNumber;
265         CrowdsaleEndChanged (currentEndBlockNumber, _newEndBlockNumber);
266     }
267 
268 }