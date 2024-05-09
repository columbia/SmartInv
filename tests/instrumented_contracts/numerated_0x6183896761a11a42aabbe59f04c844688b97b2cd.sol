1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32   
33 }
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41     
42   address public owner;
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     require(newOwner != address(0));      
66     owner = newOwner;
67   }
68 
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76     
77   event Pause();
78   
79   event Unpause();
80 
81   bool public paused = false;
82 
83   /**
84    * @dev modifier to allow actions only when the contract IS paused
85    */
86   modifier whenNotPaused() {
87     require(!paused);
88     _;
89   }
90 
91   /**
92    * @dev modifier to allow actions only when the contract IS NOT paused
93    */
94   modifier whenPaused() {
95     require(paused);
96     _;
97   }
98 
99   /**
100    * @dev called by the owner to pause, triggers stopped state
101    */
102   function pause() onlyOwner whenNotPaused {
103     paused = true;
104     Pause();
105   }
106 
107   /**
108    * @dev called by the owner to unpause, returns to normal state
109    */
110   function unpause() onlyOwner whenPaused {
111     paused = false;
112     Unpause();
113   }
114   
115 }
116 
117 
118 /**
119  * @title PreSale
120  * @dev The PreSale contract stores balances investors of pre sale stage.
121  */
122 contract PreSale is Pausable {
123     
124   event Invest(address, uint);
125 
126   using SafeMath for uint;
127     
128   address public wallet;
129 
130   uint public start;
131 
132   uint public min;
133 
134   uint public hardcap;
135   
136   uint public invested;
137   
138   uint public period;
139 
140   mapping (address => uint) public balances;
141 
142   address[] public investors;
143 
144   modifier saleIsOn() {
145     require(now > start && now < start + period * 1 days);
146     _;
147   }
148 
149   modifier isUnderHardcap() {
150     require(invested < hardcap);
151     _;
152   }
153 
154   function setMin(uint newMin) onlyOwner {
155     min = newMin;
156   }
157 
158   function setHardcap(uint newHardcap) onlyOwner {
159     hardcap = newHardcap;
160   }
161   
162   function totalInvestors() constant returns (uint) {
163     return investors.length;
164   }
165   
166   function balanceOf(address investor) constant returns (uint) {
167     return balances[investor];
168   }
169   
170   function setStart(uint newStart) onlyOwner {
171     start = newStart;
172   }
173   
174   function setPeriod(uint16 newPeriod) onlyOwner {
175     period = newPeriod;
176   }
177   
178   function setWallet(address newWallet) onlyOwner {
179     require(newWallet != address(0));
180     wallet = newWallet;
181   }
182 
183   function invest() saleIsOn isUnderHardcap whenNotPaused payable {
184     require(msg.value >= min);
185     wallet.transfer(msg.value);
186     if(balances[msg.sender] == 0) {
187       investors.push(msg.sender);    
188     }
189     balances[msg.sender] = balances[msg.sender].add(msg.value);
190     invested = invested.add(msg.value);
191     Invest(msg.sender, msg.value);
192   }
193 
194   function() external payable {
195     invest();
196   }
197 
198 }