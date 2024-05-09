1 pragma solidity 0.5.12;
2 library SafeMath {
3     /**
4      * @dev Returns the addition of two unsigned integers, reverting on
5      * overflow.
6      *
7      * Counterpart to Solidity's `+` operator.
8      *
9      * Requirements:
10      * - Addition cannot overflow.
11      */
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15         return c;
16     }
17     /**
18      * @dev Returns the subtraction of two unsigned integers, reverting on
19      * overflow (when the result is negative).
20      *
21      * Counterpart to Solidity's `-` operator.
22      *
23      * Requirements:
24      * - Subtraction cannot overflow.
25      */
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     /**
30      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
31      * overflow (when the result is negative).
32      *
33      * Counterpart to Solidity's `-` operator.
34      *
35      * Requirements:
36      * - Subtraction cannot overflow.
37      *
38      * _Available since v2.4.0._
39      */
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45     /**
46      * @dev Returns the multiplication of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `*` operator.
50      *
51      * Requirements:
52      * - Multiplication cannot overflow.
53      */
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56         // benefit is lost if 'b' is also tested.
57         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65     /**
66      * @dev Returns the integer division of two unsigned integers. Reverts on
67      * division by zero. The result is rounded towards zero.
68      *
69      * Counterpart to Solidity's `/` operator. Note: this function uses a
70      * `revert` opcode (which leaves remaining gas untouched) while Solidity
71      * uses an invalid opcode to revert (consuming all remaining gas).
72      *
73      * Requirements:
74      * - The divisor cannot be zero.
75      */
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79     /**
80      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
81      * division by zero. The result is rounded towards zero.
82      *
83      * Counterpart to Solidity's `/` operator. Note: this function uses a
84      * `revert` opcode (which leaves remaining gas untouched) while Solidity
85      * uses an invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      *
90      * _Available since v2.4.0._
91      */
92     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         // Solidity only automatically asserts when dividing by 0
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97         return c;
98     }
99     /**
100      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
101      * Reverts when dividing by zero.
102      *
103      * Counterpart to Solidity's `%` operator. This function uses a `revert`
104      * opcode (which leaves remaining gas untouched) while Solidity uses an
105      * invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      * - The divisor cannot be zero.
109      */
110     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
111         return mod(a, b, "SafeMath: modulo by zero");
112     }
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts with custom message when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      *
124      * _Available since v2.4.0._
125      */
126     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b != 0, errorMessage);
128         return a % b;
129     }
130 }
131 contract MartiGame {
132     using SafeMath for uint;
133     uint public fee = 5;
134     address payable owner;
135     /** State
136      *
137      * - New: 0
138      * - Deleted: 1
139      * - OnGoing: 2
140      * - Closed: 3
141      */
142     enum State{New, Deleted, OnGoing, Closed}
143     struct _game {
144         address payable creator;
145         address payable responder;
146         uint bet;
147         uint blocknumber;
148         uint id;
149         State state;
150     }
151     _game[] public Games;
152     mapping(uint => address) public gameWinner;
153     event NewGame(uint indexed game_id, address indexed creator, address indexed responder, uint bet, uint id);
154     event RespondGame(uint indexed game_id, address indexed responder);
155     event DeleteGame(uint indexed game_id);
156     event RefundGame(uint indexed game_id);
157     event ResultGame(uint indexed game_id, address indexed winner, uint winAmount);
158     constructor() public {
159         owner = msg.sender;
160     }
161     function createGame(address payable _creator, uint _id) payable external {
162         Games.push(_game({
163             creator : _creator,
164             responder : msg.sender,
165             bet : msg.value,
166             blocknumber : 0,
167             state : State.New,
168             id : _id
169             }));
170         emit NewGame(Games.length - 1, _creator, msg.sender, msg.value, _id);
171     }
172     function respondGame(uint _gameID) payable external {
173         _game storage game = Games[_gameID];
174         require(game.state == State.New, '01');
175         require(game.bet == msg.value, '02');
176         require(game.creator == msg.sender, '03');
177         game.state = State.OnGoing;
178         game.blocknumber = block.number;
179         emit RespondGame(_gameID, msg.sender);
180     }
181     function deleteGame(uint _gameID) external {
182         _game storage game = Games[_gameID];
183         require(game.creator == msg.sender, '04');
184         require(game.state == State.New, '05');
185         game.state = State.Deleted;
186         game.creator.transfer(game.bet);
187         emit DeleteGame(_gameID);
188     }
189     function getWin(uint _gameID) external {
190         _game storage game = Games[_gameID];
191         require(game.state == State.OnGoing, '06');
192         require(game.creator == msg.sender || game.responder == msg.sender, '07');
193         require(block.number > game.blocknumber + 1, '08');
194         game.state = State.Closed;
195         if (blockhash(game.blocknumber) == 0 || (block.number - game.blocknumber) > 256) {
196             game.creator.transfer(game.bet);
197             game.responder.transfer(game.bet);
198             emit RefundGame(_gameID);
199             gameWinner[_gameID] = address(0);
200         } else {
201             uint hash = uint(keccak256(abi.encodePacked(blockhash(game.blocknumber + 1), game.creator, game.responder, game.bet)));
202             uint game_bet_common = game.bet.mul(2);
203             uint owner_fee = game_bet_common.mul(fee).div(100);
204             owner.transfer(owner_fee);
205             uint winAmount = game_bet_common.sub(owner_fee);
206             address winner;
207             if (hash % 2 == 0) {
208                 game.creator.transfer(winAmount);
209                 winner = game.creator;
210                 emit ResultGame(_gameID, game.creator, winAmount);
211             } else {
212                 game.responder.transfer(winAmount);
213                 winner = game.responder;
214                 emit ResultGame(_gameID, game.responder, winAmount);
215             }
216             gameWinner[_gameID] = winner;
217         }
218     }
219 }