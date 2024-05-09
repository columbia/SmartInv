1 pragma solidity 0.5.12;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      * - Addition cannot overflow.
12      */
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17         return c;
18     }
19 
20     /**
21      * @dev Returns the subtraction of two unsigned integers, reverting on
22      * overflow (when the result is negative).
23      *
24      * Counterpart to Solidity's `-` operator.
25      *
26      * Requirements:
27      * - Subtraction cannot overflow.
28      */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      *
42      * _Available since v2.4.0._
43      */
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      *
100      * _Available since v2.4.0._
101      */
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         // Solidity only automatically asserts when dividing by 0
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
113      * Reverts when dividing by zero.
114      *
115      * Counterpart to Solidity's `%` operator. This function uses a `revert`
116      * opcode (which leaves remaining gas untouched) while Solidity uses an
117      * invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      * - The divisor cannot be zero.
121      */
122     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
123         return mod(a, b, "SafeMath: modulo by zero");
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts with custom message when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 
146 contract MartiGame {
147     using SafeMath for uint;
148     uint public fee = 5;
149     address payable owner;
150 
151 
152     /** State
153      *
154      * - New: 0
155      * - Deleted: 1
156      * - OnGoing: 2
157      * - Closed: 3
158      */
159     enum State{New, Deleted, OnGoing, Closed}
160 
161     struct _game {
162         address payable creator;
163         address payable responder;
164         uint bet;
165         uint blocknumber;
166         uint id;
167         State state;
168     }
169 
170     _game[] public Games;
171 
172     mapping(uint => address) public gameWinner;
173 
174     event NewGame(uint indexed game_id, address indexed creator, address indexed responder, uint bet, uint id);
175     event RespondGame(uint indexed game_id, address indexed responder);
176     event DeleteGame(uint indexed game_id);
177     event RefundGame(uint indexed game_id);
178     event ResultGame(uint indexed game_id, address indexed winner, uint winAmount);
179 
180 
181 
182     constructor() public {
183         owner = msg.sender;
184     }
185 
186 
187     function createGame(address payable _responder, uint _id) payable external {
188         Games.push(_game({
189             creator : msg.sender,
190             responder : _responder,
191             bet : msg.value,
192             blocknumber : 0,
193             state : State.New,
194             id : _id
195             }));
196 
197         emit NewGame(Games.length - 1, msg.sender, _responder, msg.value, _id);
198     }
199 
200 
201     function respondGame(uint _gameID) payable external {
202         _game storage game = Games[_gameID];
203 
204         require(game.state == State.New, '01');
205         require(game.bet == msg.value, '02');
206         require(game.responder == msg.sender, '03');
207 
208         game.state = State.OnGoing;
209         game.blocknumber = block.number;
210 
211         emit RespondGame(_gameID, msg.sender);
212     }
213 
214 
215     function deleteGame(uint _gameID) external {
216         _game storage game = Games[_gameID];
217 
218         require(game.creator == msg.sender, '04');
219         require(game.state == State.New, '05');
220 
221         game.state = State.Deleted;
222 
223         game.creator.transfer(game.bet);
224 
225         emit DeleteGame(_gameID);
226     }
227 
228 
229     function getWin(uint _gameID) external {
230         _game storage game = Games[_gameID];
231 
232         require(game.state == State.OnGoing, '06');
233         require(game.creator == msg.sender || game.responder == msg.sender, '07');
234         require(block.number > game.blocknumber + 1, '08');
235 
236         game.state = State.Closed;
237 
238         if (blockhash(game.blocknumber) == 0 || (block.number - game.blocknumber) > 256) {
239             game.creator.transfer(game.bet);
240             game.responder.transfer(game.bet);
241 
242             emit RefundGame(_gameID);
243             gameWinner[_gameID] = address(0);
244         } else {
245             uint hash = uint(keccak256(abi.encodePacked(blockhash(game.blocknumber + 1), game.creator, game.responder, game.bet)));
246 
247             uint game_bet_common = game.bet.mul(2);
248             uint owner_fee = game_bet_common.mul(fee).div(100);
249             owner.transfer(owner_fee);
250             uint winAmount = game_bet_common.sub(owner_fee);
251 
252             address winner;
253 
254             if (hash % 2 == 0) {
255                 game.creator.transfer(winAmount);
256                 winner = game.creator;
257                 emit ResultGame(_gameID, game.creator, winAmount);
258             } else {
259                 game.responder.transfer(winAmount);
260                 winner = game.responder;
261                 emit ResultGame(_gameID, game.responder, winAmount);
262             }
263 
264             gameWinner[_gameID] = winner;
265 
266         }
267     }
268 
269 
270 }