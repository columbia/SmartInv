1 pragma solidity ^0.4.18;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9 
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner public {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 
89 contract TwoXMachine is Ownable, Pausable {
90 
91   // Address of the contract creator
92   address public contractOwner;
93 
94   // FIFO queue
95   BuyIn[] public buyIns;
96 
97   // The current BuyIn queue index
98   uint256 public index;
99 
100   // Total invested for entire contract
101   uint256 public contractTotalInvested;
102 
103   // Total invested for a given address
104   mapping (address => uint256) public totalInvested;
105 
106   // Total value for a given address
107   mapping (address => uint256) public totalValue;
108 
109   // Total paid out for a given address
110   mapping (address => uint256) public totalPaidOut;
111 
112   struct BuyIn {
113     uint256 value;
114     address owner;
115   }
116 
117   /**
118    * Fallback function to handle ethereum that was send straight to the contract
119    */
120   function() whenNotPaused() public payable {
121     purchase();
122   }
123 
124   function purchase() whenNotPaused() public payable {
125     // I don't want no scrub
126     require(msg.value >= 0.01 ether);
127 
128     uint256 value = SafeMath.div(SafeMath.mul(msg.value, 98), 100);
129 
130     // HNNNNNNGGGGGG
131     uint256 valueMultiplied = SafeMath.div(SafeMath.mul(msg.value, 150), 100);
132 
133     contractTotalInvested += msg.value;
134     totalInvested[msg.sender] += msg.value;
135 
136     while (index < buyIns.length && value > 0) {
137       BuyIn storage buyIn = buyIns[index];
138 
139       if (value < buyIn.value) {
140         buyIn.owner.transfer(value);
141         totalPaidOut[buyIn.owner] += value;
142         totalValue[buyIn.owner] -= value;
143         buyIn.value -= value;
144         value = 0;
145       } else {
146         buyIn.owner.transfer(buyIn.value);
147         totalPaidOut[buyIn.owner] += buyIn.value;
148         totalValue[buyIn.owner] -= buyIn.value;
149         value -= buyIn.value;
150         buyIn.value = 0;
151         index++;
152       }
153     }
154 
155     // if buyins have been exhausted, return the remaining
156     // funds back to the investor
157     if (value > 0) {
158       msg.sender.transfer(value);
159       valueMultiplied -= value;
160       totalPaidOut[msg.sender] += value;
161     }
162 
163     totalValue[msg.sender] += valueMultiplied;
164 
165     buyIns.push(BuyIn({
166       value: valueMultiplied,
167       owner: msg.sender
168     }));
169   }
170 
171   function payout() onlyOwner() public {
172     owner.transfer(this.balance);
173   }
174 }
175 
176 /**
177  * @title SafeMath
178  * @dev Math operations with safety checks that throw on error
179  */
180 library SafeMath {
181 
182   /**
183   * @dev Multiplies two numbers, throws on overflow.
184   */
185   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186     if (a == 0) {
187       return 0;
188     }
189     uint256 c = a * b;
190     assert(c / a == b);
191     return c;
192   }
193 
194   /**
195   * @dev Integer division of two numbers, truncating the quotient.
196   */
197   function div(uint256 a, uint256 b) internal pure returns (uint256) {
198     // assert(b > 0); // Solidity automatically throws when dividing by 0
199     uint256 c = a / b;
200     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201     return c;
202   }
203 
204   /**
205   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
206   */
207   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208     assert(b <= a);
209     return a - b;
210   }
211 
212   /**
213   * @dev Adds two numbers, throws on overflow.
214   */
215   function add(uint256 a, uint256 b) internal pure returns (uint256) {
216     uint256 c = a + b;
217     assert(c >= a);
218     return c;
219   }
220 }