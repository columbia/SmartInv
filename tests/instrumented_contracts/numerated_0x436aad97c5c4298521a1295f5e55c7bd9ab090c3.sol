1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
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
32 }
33 
34 pragma solidity ^0.4.15;
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner {
69     require(newOwner != address(0));
70     owner = newOwner;
71   }
72 
73 }
74 
75 pragma solidity ^0.4.15;
76 
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = false;
87 
88 
89   /**
90    * @dev modifier to allow actions only when the contract IS paused
91    */
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   /**
98    * @dev modifier to allow actions only when the contract IS NOT paused
99    */
100   modifier whenPaused() {
101     require(paused);
102     _;
103   }
104 
105   /**
106    * @dev called by the owner to pause, triggers stopped state
107    */
108   function pause() onlyOwner whenNotPaused {
109     paused = true;
110     Pause();
111   }
112 
113   /**
114    * @dev called by the owner to unpause, returns to normal state
115    */
116   function unpause() onlyOwner whenPaused {
117     paused = false;
118     Unpause();
119   }
120 }
121 
122 pragma solidity ^0.4.15;
123 
124 
125 contract FundRequestPrivateSeed is Pausable {
126   using SafeMath for uint;
127 
128   // address where funds are collected
129   address public wallet;
130   // how many token units a buyer gets per wei
131   uint public rate;
132   // amount of raised money in wei
133   uint public weiRaised;
134 
135   mapping(address => uint) public deposits;
136   mapping(address => uint) public balances;
137   address[] public investors;
138   uint public investorCount;
139   mapping(address => bool) public allowed;
140   /**
141    * event for token purchase logging
142    * @param purchaser who paid for the tokens
143    * @param beneficiary who got the tokens
144    * @param value weis paid for purchase
145    * @param amount amount of tokens purchased
146    */
147   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
148 
149   function FundRequestPrivateSeed(uint _rate, address _wallet) {
150     require(_rate > 0);
151     require(_wallet != 0x0);
152 
153     rate = _rate;
154     wallet = _wallet;
155   }
156   // low level token purchase function
157   function buyTokens(address beneficiary) payable whenNotPaused {
158     require(validBeneficiary(beneficiary));
159     require(validPurchase());
160     require(validPurchaseSize());
161     bool existing = deposits[beneficiary] > 0;
162     uint weiAmount = msg.value;
163     uint updatedWeiRaised = weiRaised.add(weiAmount);
164     // calculate token amount to be created
165     uint tokens = weiAmount.mul(rate);
166     weiRaised = updatedWeiRaised;
167     deposits[beneficiary] = deposits[beneficiary].add(msg.value);
168     balances[beneficiary] = balances[beneficiary].add(tokens);
169     if(!existing) {
170       investors.push(beneficiary);
171       investorCount++;
172     }
173     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
174     forwardFunds();
175   }
176   // send ether to the fund collection wallet
177   // override to create custom fund forwarding mechanisms
178   function forwardFunds() internal {
179     wallet.transfer(msg.value);
180   }
181   function validBeneficiary(address beneficiary) internal constant returns (bool) {
182       return allowed[beneficiary] == true;
183   }
184   // @return true if the transaction can buy tokens
185   function validPurchase() internal constant returns (bool) {
186     return msg.value != 0;
187   }
188   // @return true if the amount is higher then 25ETH
189   function validPurchaseSize() internal constant returns (bool) {
190     return msg.value >=25000000000000000000;
191   }
192   function balanceOf(address _owner) constant returns (uint balance) {
193     return balances[_owner];
194   }
195   function depositsOf(address _owner) constant returns (uint deposit) {
196     return deposits[_owner];
197   }
198   function allow(address beneficiary) onlyOwner {
199     allowed[beneficiary] = true;
200   }
201   function updateRate(uint _rate) onlyOwner whenPaused {
202     rate = _rate;
203   }
204 
205   function updateWallet(address _wallet) onlyOwner whenPaused {
206     require(_wallet != 0x0);
207     wallet = _wallet;
208   }
209 
210   // fallback function can be used to buy tokens
211   function () payable {
212     buyTokens(msg.sender);
213   }
214 }