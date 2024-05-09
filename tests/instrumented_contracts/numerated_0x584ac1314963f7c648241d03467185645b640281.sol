1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10   address public owner;
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner {
33     require(newOwner != address(0));      
34     owner = newOwner;
35   }
36 
37 }
38 
39  
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45     
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51  
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58  
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63  
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69   
70 }
71  
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77     
78   event Pause();
79   
80   event Unpause();
81 
82   bool public paused = false;
83 
84   /**
85    * @dev modifier to allow actions only when the contract IS paused
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev modifier to allow actions only when the contract IS NOT paused
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused {
104     paused = true;
105     Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused {
112     paused = false;
113     Unpause();
114   }
115   
116 }
117 
118 
119 /**
120  * @title PreSale
121  * @dev The PreSale contract stores balances investors of pre sale stage.
122  */
123 contract PreSale is Pausable {
124     
125   event Invest(address, uint);
126 
127   using SafeMath for uint;
128     
129   address public wallet;
130 
131   uint public start;
132   
133   uint public total;
134   
135   uint16 public period;
136 
137   mapping (address => uint) balances;
138   
139   address[] public investors;
140   
141   modifier saleIsOn() {
142     require(now > start && now < start + period * 1 days);
143     _;
144   }
145   
146   function totalInvestors() constant returns (uint) {
147     return investors.length;
148   }
149   
150   function balanceOf(address investor) constant returns (uint) {
151     return balances[investor];
152   }
153   
154   function setStart(uint newStart) onlyOwner {
155     start = newStart;
156   }
157   
158   function setPeriod(uint16 newPeriod) onlyOwner {
159     period = newPeriod;
160   }
161   
162   function setWallet(address newWallet) onlyOwner {
163     require(newWallet != address(0));
164     wallet = newWallet;
165   }
166 
167   function invest() saleIsOn whenNotPaused payable {
168     wallet.transfer(msg.value);
169     balances[msg.sender] = balances[msg.sender].add(msg.value);
170     investors.push(msg.sender);
171     total = total.add(msg.value);
172     Invest(msg.sender, msg.value);
173   }
174 
175   function() external payable {
176     invest();
177   }
178 
179 }