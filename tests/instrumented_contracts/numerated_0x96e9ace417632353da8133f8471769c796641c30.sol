1 pragma solidity 0.4.18;
2 
3 // File: contracts/KnowsConstants.sol
4 
5 contract KnowsConstants {
6     // 2/4/18 @ 6:30 PM EST, the deadline for bets
7     uint public constant GAME_START_TIME = 1517787000;
8 }
9 
10 // File: contracts/KnowsSquares.sol
11 
12 // knows what a valid box is
13 contract KnowsSquares {
14     modifier isValidSquare(uint home, uint away) {
15         require(home >= 0 && home < 10);
16         require(away >= 0 && away < 10);
17         _;
18     }
19 }
20 
21 // File: contracts/interfaces/IKnowsTime.sol
22 
23 interface IKnowsTime {
24     function currentTime() public view returns (uint);
25 }
26 
27 // File: contracts/KnowsTime.sol
28 
29 // knows what time it is
30 contract KnowsTime is IKnowsTime {
31     function currentTime() public view returns (uint) {
32         return now;
33     }
34 }
35 
36 // File: contracts/interfaces/IKnowsVoterStakes.sol
37 
38 interface IKnowsVoterStakes {
39     function getVoterStakes(address voter, uint asOfBlock) public view returns (uint);
40 }
41 
42 // File: contracts/interfaces/IScoreOracle.sol
43 
44 interface IScoreOracle {
45     function getSquareWins(uint home, uint away) public view returns (uint numSquareWins, uint totalWins);
46     function isFinalized() public view returns (bool);
47 }
48 
49 // File: zeppelin-solidity/contracts/math/Math.sol
50 
51 /**
52  * @title Math
53  * @dev Assorted math operations
54  */
55 
56 library Math {
57   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
58     return a >= b ? a : b;
59   }
60 
61   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
62     return a < b ? a : b;
63   }
64 
65   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
66     return a >= b ? a : b;
67   }
68 
69   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
70     return a < b ? a : b;
71   }
72 }
73 
74 // File: zeppelin-solidity/contracts/math/SafeMath.sol
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     if (a == 0) {
83       return 0;
84     }
85     uint256 c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return c;
95   }
96 
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
110 
111 /**
112  * @title Ownable
113  * @dev The Ownable contract has an owner address, and provides basic authorization control
114  * functions, this simplifies the implementation of "user permissions".
115  */
116 contract Ownable {
117   address public owner;
118 
119 
120   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122 
123   /**
124    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
125    * account.
126    */
127   function Ownable() public {
128     owner = msg.sender;
129   }
130 
131 
132   /**
133    * @dev Throws if called by any account other than the owner.
134    */
135   modifier onlyOwner() {
136     require(msg.sender == owner);
137     _;
138   }
139 
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address newOwner) public onlyOwner {
146     require(newOwner != address(0));
147     OwnershipTransferred(owner, newOwner);
148     owner = newOwner;
149   }
150 
151 }
152 
153 // File: contracts/Squares.sol
154 
155 contract Squares is KnowsConstants, KnowsTime, KnowsSquares, IKnowsVoterStakes {
156     using SafeMath for uint;
157 
158     function Squares(IScoreOracle _oracle, address _developer) public {
159         oracle = _oracle;
160         developer = _developer;
161     }
162 
163     // the oracle for the scores
164     IScoreOracle public oracle;
165 
166     // the developer of the smart contract
167     address public developer;
168 
169     // staked ether for each player and each box
170     mapping(address => uint[10][10]) public totalSquareStakesByUser;
171 
172     // total stakes for each box
173     uint[10][10] public totalSquareStakes;
174 
175     // the total stakes for each user
176     mapping(address => uint) public totalUserStakes;
177 
178     // the overall total of money stakes in the grid
179     uint public totalStakes;
180 
181     event LogBet(address indexed better, uint indexed home, uint indexed away, uint stake);
182 
183     function bet(uint home, uint away) public payable isValidSquare(home, away) {
184         require(msg.value > 0);
185         require(currentTime() < GAME_START_TIME);
186 
187         // the stake is the message value
188         uint stake = msg.value;
189 
190         // add the stake amount to the overall total
191         totalStakes = totalStakes.add(stake);
192 
193         // add their stake to the total user stakes
194         totalUserStakes[msg.sender] = totalUserStakes[msg.sender].add(stake);
195 
196         // add their stake to their own accounting
197         totalSquareStakesByUser[msg.sender][home][away] = totalSquareStakesByUser[msg.sender][home][away].add(stake);
198 
199         // add it to the total stakes as well
200         totalSquareStakes[home][away] = totalSquareStakes[home][away].add(stake);
201 
202         LogBet(msg.sender, home, away, stake);
203     }
204 
205     event LogPayout(address indexed winner, uint payout, uint donation);
206 
207     // calculate the winnings owed for a user's bet on a particular square
208     function getWinnings(address user, uint home, uint away) public view returns (uint winnings) {
209         // the square wins and the total wins are used to calculate
210         // the percentage of the total stake that the square is worth
211         var (numSquareWins, totalWins) = oracle.getSquareWins(home, away);
212 
213         return totalSquareStakesByUser[user][home][away]
214             .mul(totalStakes)
215             .mul(numSquareWins)
216             .div(totalWins)
217             .div(totalSquareStakes[home][away]);
218     }
219 
220     // called by the winners to collect winnings for a box
221     function collectWinnings(uint home, uint away, uint donationPercentage) public isValidSquare(home, away) {
222         // score must be finalized
223         require(oracle.isFinalized());
224 
225         // optional donation
226         require(donationPercentage <= 100);
227 
228         // we cannot pay out more than we have
229         // but we should not prevent paying out what we do have
230         // this should never happen since integer math always truncates, we should only end up with too much
231         // however it's worth writing in the protection
232         uint winnings = Math.min256(this.balance, getWinnings(msg.sender, home, away));
233 
234         require(winnings > 0);
235 
236         // the donation amount
237         uint donation = winnings.mul(donationPercentage).div(100);
238 
239         uint payout = winnings.sub(donation);
240 
241         // clear their stakes - can only collect once
242         totalSquareStakesByUser[msg.sender][home][away] = 0;
243 
244         msg.sender.transfer(payout);
245         developer.transfer(donation);
246 
247         LogPayout(msg.sender, payout, donation);
248     }
249 
250     function getVoterStakes(address voter, uint asOfBlock) public view returns (uint) {
251         return totalUserStakes[voter];
252     }
253 }