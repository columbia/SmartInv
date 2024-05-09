1 pragma solidity ^0.4.15;
2 
3 library SafeMathLib {
4 
5   function times(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function minus(uint a, uint b) internal returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function plus(uint a, uint b) internal returns (uint) {
17     uint c = a + b;
18     assert(c>=a);
19     return c;
20   }
21 
22   function divide(uint a, uint b) internal returns (uint) {
23     assert(b > 0);
24     uint c = a / b;
25     assert(a == b * c + a % b);
26     return c;
27   }
28 
29 }
30 
31 //basic ownership contract
32 contract Owned {
33     address public owner;
34 
35     //ensures only owner can call functions
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     //constructor makes sets owner to contract deployer
42     function Owned() public { owner = msg.sender;}
43 
44     //update owner
45     function changeOwner(address _newOwner) public onlyOwner {
46         owner = _newOwner;
47         NewOwner(msg.sender, _newOwner);
48     }
49 
50     event NewOwner(address indexed oldOwner, address indexed newOwner);
51 }
52 
53 /**
54  * Collect funds from presale investors to be manually send to the crowdsale smart contract later.
55  *
56  * - Collect funds from pre-sale investors
57  * - Send funds to an specified address when the pre-sale ends
58  * 
59  */ 
60 contract DadaPresaleFundCollector is Owned {
61 
62   using SafeMathLib for uint;
63 
64   address public presaleAddressAmountHolder = 0xF636c93F98588b7F1624C8EC4087702E5BE876b6;
65 
66   /** How much they have invested */
67   mapping(address => uint) public balances;
68 
69   /** What is the minimum buy in */
70   uint constant maximumIndividualCap = 500 ether;
71   // Limit in Ether for this contract to allow investment
72   uint constant etherCap = 3000 ether;
73 
74   /** Have we begun to move funds */
75   bool public moving;
76 
77   // turned off while doing initial configuration of the whitelist
78   bool public isExecutionAllowed;
79 
80   // turned on when the refund function is allowed to be isExecutionAllowed
81   bool public isRefundAllowed;
82   
83   // Used to handle if the cap was reached due to investment received 
84   // in either Bitcoin or USD
85   bool public isCapReached;
86 
87   bool public isFinalized;
88 
89   mapping (address => bool) public whitelist;
90 
91   event Invested(address investor, uint value);
92   event Refunded(address investor, uint value);
93   event WhitelistUpdated(address whitelistedAddress, bool isWhitelisted);
94   event EmptiedToWallet(address wallet);
95 
96   /**
97    * Create presale contract where lock up period is given days
98    */
99   function DadaPresaleFundCollector() public {
100 
101   }
102 
103   /**
104   * Whitelist handler function 
105   **/
106   function updateWhitelist(address whitelistedAddress, bool isWhitelisted) public onlyOwner {
107     whitelist[whitelistedAddress] = isWhitelisted;
108     WhitelistUpdated(whitelistedAddress, isWhitelisted);
109   }
110 
111   /**
112    * Participate in the presale.
113    */
114   function invest() public payable {
115     // execution shoulf be turned ON
116     require(isExecutionAllowed);
117     // the cap shouldn't be reached yet
118     require(!isCapReached);
119     // the final balance of the contract should not be greater than
120     // the etherCap
121     uint currentBalance = this.balance;
122     require(currentBalance <= etherCap);
123 
124     // Cannot invest anymore through crowdsale when moving has begun
125     require(!moving);
126     address investor = msg.sender;
127     // the investor is whitlisted
128     require(whitelist[investor]);
129     
130     // the total balance of the user shouldn't be greater than the maximumIndividualCap
131     require((balances[investor].plus(msg.value)) <= maximumIndividualCap);
132 
133     require(msg.value <= maximumIndividualCap);
134     balances[investor] = balances[investor].plus(msg.value);
135     // if the cap is reached then turn ON the flag
136     if (currentBalance == etherCap){
137       isCapReached = true;
138     }
139     Invested(investor, msg.value);
140   }
141 
142   /**
143    * Allow refund if isRefundAllowed is ON.
144    */
145   function refund() public {
146     require(isRefundAllowed);
147     address investor = msg.sender;
148     require(this.balance > 0);
149     require(balances[investor] > 0);
150     // We have started to move funds
151     moving = true;
152     uint amount = balances[investor];
153     balances[investor] = 0;
154     investor.transfer(amount);
155     Refunded(investor, amount);
156   }
157 
158   // utility functions
159   function emptyToWallet() public onlyOwner {
160     require(!isFinalized);
161     isFinalized = true;
162     moving = true;
163     presaleAddressAmountHolder.transfer(this.balance);
164     EmptiedToWallet(presaleAddressAmountHolder); 
165   }  
166 
167   function flipExecutionSwitchTo(bool state) public onlyOwner{
168     isExecutionAllowed = state;
169   }
170 
171   function flipCapSwitchTo(bool state) public onlyOwner{
172     isCapReached = state;
173   }
174 
175   function flipRefundSwitchTo(bool state) public onlyOwner{
176     isRefundAllowed = state;
177   }
178 
179   function flipFinalizedSwitchTo(bool state) public onlyOwner{
180     isFinalized = state;
181   }
182 
183   function flipMovingSwitchTo(bool state) public onlyOwner{
184     moving = state;
185   }  
186 
187   /** Explicitly call function from your wallet. */
188   function() public payable {
189     revert();
190   }
191 }