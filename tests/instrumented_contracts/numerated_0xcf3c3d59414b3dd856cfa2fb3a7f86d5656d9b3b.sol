1 pragma solidity ^0.4.24;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: contracts/token/ERC20Cutted.sol
120 
121 contract ERC20Cutted {
122 
123   function balanceOf(address who) public view returns (uint256);
124 
125   function transfer(address to, uint256 value) public returns (bool);
126 
127 }
128 
129 // File: contracts/Room2Online.sol
130 
131 contract Room2Online is Ownable {
132 
133   event TicketPurchased(address lotAddr, uint ticketNumber, address player, uint totalAmount, uint netAmount);
134 
135   event TicketPaid(address lotAddr, uint lotIndex, uint ticketNumber, address player, uint winning);
136 
137   event LotStarted(address lotAddr, uint lotIndex, uint startTime);
138 
139   event LotFinished(address lotAddr, uint lotIndex, uint finishTime);
140 
141   event ParametersUpdated(address feeWallet, uint feePercent, uint minInvestLimit);
142 
143   using SafeMath for uint;
144 
145   uint public percentRate = 100;
146 
147   uint public minInvestLimit;
148 
149   uint public feePercent;
150 
151   address public feeWallet;
152 
153   struct Ticket {
154     address owner;
155     uint totalAmount;
156     uint netAmount;
157     uint winning;
158     bool finished;
159   }
160 
161   struct Lot {
162     uint balance;
163     uint[] ticketNumbers;
164     uint startTime;
165     uint finishTime;
166   }
167 
168   Ticket[] public tickets;
169 
170   uint public lotIndex;
171 
172   mapping(uint => Lot) public lots;
173 
174   modifier notContract(address to) {
175     uint codeLength;
176     assembly {
177       codeLength := extcodesize(to)
178     }
179     require(codeLength == 0, "Contracts not supported!");
180     _;
181   }
182 
183   function updateParameters(address newFeeWallet, uint newFeePercent, uint newMinInvestLimit) public onlyOwner {
184     feeWallet = newFeeWallet;
185     feePercent = newFeePercent;
186     minInvestLimit = newMinInvestLimit;
187     emit ParametersUpdated(newFeeWallet, newFeePercent, newMinInvestLimit);
188   }
189 
190   function getTicketInfo(uint ticketNumber) public view returns(address, uint, uint, uint, bool) {
191     Ticket storage ticket = tickets[ticketNumber];
192     return (ticket.owner, ticket.totalAmount, ticket.netAmount, ticket.winning, ticket.finished);
193   }
194 
195   constructor () public {
196     minInvestLimit = 10000000000000000;
197     feePercent = 10;
198     feeWallet = 0x53F22b8f420317E7CDcbf2A180A12534286CB578;
199     emit ParametersUpdated(feeWallet, feePercent, minInvestLimit);
200     emit LotStarted(address(this), lotIndex, now);
201   }
202 
203   function setFeeWallet(address newFeeWallet) public onlyOwner {
204     feeWallet = newFeeWallet;
205   }
206 
207   function () public payable notContract(msg.sender) {
208     require(msg.value >= minInvestLimit);
209     uint fee = msg.value.mul(feePercent).div(percentRate);
210     uint netAmount = msg.value.sub(fee);
211     tickets.push(Ticket(msg.sender, msg.value, netAmount, 0, false));
212     emit TicketPurchased(address(this), tickets.length.sub(1), msg.sender, msg.value, netAmount);
213     feeWallet.transfer(fee);
214   }
215 
216   function processRewards(uint[] ticketNumbers, uint[] winnings) public onlyOwner {
217     Lot storage lot = lots[lotIndex];
218     for (uint i = 0; i < ticketNumbers.length; i++) {
219       uint ticketNumber = ticketNumbers[i];
220       Ticket storage ticket = tickets[ticketNumber];
221       if (!ticket.finished) {
222         ticket.winning = winnings[i];
223         ticket.finished = true;
224         lot.ticketNumbers.push(ticketNumber);
225         lot.balance = lot.balance.add(winnings[i]);
226         ticket.owner.transfer(winnings[i]);
227         emit TicketPaid(address(this), lotIndex, ticketNumber, ticket.owner, winnings[i]);
228       }
229     }
230   }
231 
232   function finishLot(uint currentLotFinishTime, uint nextLotStartTime) public onlyOwner {
233     Lot storage currentLot = lots[lotIndex];
234     currentLot.finishTime = currentLotFinishTime;
235     emit LotFinished(address(this), lotIndex, currentLotFinishTime);
236     lotIndex++;
237     Lot storage nextLot = lots[lotIndex];
238     nextLot.startTime = nextLotStartTime;
239     emit LotStarted(address(this), lotIndex, nextLotStartTime);
240   }
241 
242   function retrieveTokens(address tokenAddr, address to) public onlyOwner {
243     ERC20Cutted token = ERC20Cutted(tokenAddr);
244     token.transfer(to, token.balanceOf(address(this)));
245   }
246 
247 }