1 // File: contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/math/SafeMath.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (a == 0) {
87       return 0;
88     }
89 
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 // File: contracts/token/ERC20Cutted.sol
124 
125 pragma solidity ^0.4.24;
126 
127 contract ERC20Cutted {
128 
129   function balanceOf(address who) public view returns (uint256);
130 
131   function transfer(address to, uint256 value) public returns (bool);
132 
133 }
134 
135 // File: contracts/SimpleLottery.sol
136 
137 pragma solidity ^0.4.24;
138 
139 
140 
141 
142 
143 contract SimpleLottery is Ownable {
144 
145     event TicketPurchased(uint lotIndex, uint ticketNumber, address player, uint ticketPrice);
146 
147     event TicketWon(uint lotIndex, uint ticketNumber, address player, uint win);
148 
149     using SafeMath for uint;
150 
151     uint public percentRate = 100;
152 
153     uint public ticketPrice = 500000000000000000;
154 
155     uint public feePercent = 10;
156 
157     uint public playersLimit = 10;
158 
159     uint public ticketsPerPlayerLimit = 2;
160 
161     address public feeWallet = 0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770;
162 
163     uint curLotIndex = 0;
164 
165     struct Lottery {
166         uint summaryInvested;
167         uint rewardBase;
168         uint ticketsCount;
169         uint playersCount;
170         address winner;
171         mapping(address => uint) ticketsCounts;
172         mapping(uint => address) tickets;
173         mapping(address => uint) invested;
174         address[] players;
175     }
176 
177     Lottery[] public lots;
178 
179     modifier notContract(address to) {
180         uint codeLength;
181         assembly {
182             codeLength := extcodesize(to)
183         }
184         require(codeLength == 0, "Contracts not supported!");
185         _;
186     }
187 
188     function setTicketsPerPlayerLimit(uint newTicketsPerPlayerLimit) public onlyOwner {
189         ticketsPerPlayerLimit = newTicketsPerPlayerLimit;
190     }
191 
192     function setFeeWallet(address newFeeWallet) public onlyOwner {
193         feeWallet = newFeeWallet;
194     }
195 
196     function setTicketPrice(uint newTicketPrice) public onlyOwner {
197         ticketPrice = newTicketPrice;
198     }
199 
200     function setFeePercent(uint newFeePercent) public onlyOwner {
201         feePercent = newFeePercent;
202     }
203 
204     function setPlayesrLimit(uint newPlayersLimit) public onlyOwner {
205         playersLimit = newPlayersLimit;
206     }
207 
208     function() public payable notContract(msg.sender) {
209         require(msg.value >= ticketPrice, "Not enough funds to buy ticket!");
210 
211         if (lots.length == 0) {
212             lots.length = 1;
213         }
214 
215         Lottery storage lot = lots[curLotIndex];
216 
217         uint numTicketsToBuy = msg.value.div(ticketPrice);
218 
219         if (numTicketsToBuy > ticketsPerPlayerLimit) {
220             numTicketsToBuy = ticketsPerPlayerLimit;
221         }
222 
223         uint toInvest = ticketPrice.mul(numTicketsToBuy);
224 
225         if (lot.invested[msg.sender] == 0) {
226             lot.players.push(msg.sender);
227             lot.playersCount = lot.playersCount.add(1);
228         }
229 
230         lot.invested[msg.sender] = lot.invested[msg.sender].add(toInvest);
231 
232         for (uint i = 0; i < numTicketsToBuy; i++) {
233             lot.tickets[lot.ticketsCount] = msg.sender;
234             emit TicketPurchased(curLotIndex, lot.ticketsCount, msg.sender, ticketPrice);
235             lot.ticketsCount = lot.ticketsCount.add(1);
236             lot.ticketsCounts[msg.sender]++;
237         }
238 
239         lot.summaryInvested = lot.summaryInvested.add(toInvest);
240 
241         uint refund = msg.value.sub(toInvest);
242         msg.sender.transfer(refund);
243 
244         if (lot.playersCount >= playersLimit) {
245             uint number = uint(keccak256(abi.encodePacked(block.number))) % lot.ticketsCount;
246             address winner = lot.tickets[number];
247             lot.winner = winner;
248             uint fee = lot.summaryInvested.mul(feePercent).div(percentRate);
249             feeWallet.transfer(fee);
250             winner.transfer(lot.rewardBase);
251             lot.rewardBase = lot.summaryInvested.sub(fee);
252             emit TicketWon(curLotIndex, number, lot.winner, lot.rewardBase);
253             curLotIndex++;
254         }
255     }
256 
257     function retrieveTokens(address tokenAddr, address to) public onlyOwner {
258         ERC20Cutted token = ERC20Cutted(tokenAddr);
259         token.transfer(to, token.balanceOf(address(this)));
260     }
261 
262 }