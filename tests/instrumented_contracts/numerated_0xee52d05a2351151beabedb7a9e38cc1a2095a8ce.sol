1 contract Owner {
2     address public owner;
3 
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8 
9     function Owner(address _owner) public {
10         owner = _owner;
11     }
12 
13     function changeOwner(address _newOwnerAddr) public onlyOwner {
14         require(_newOwnerAddr != address(0));
15         owner = _newOwnerAddr;
16     }
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24     /**
25     * @dev Multiplies two numbers, throws on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31         uint256 c = a * b;
32         assert(c / a == b);
33         return c;
34     }
35 
36     /**
37     * @dev Integer division of two numbers, truncating the quotient.
38     */
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         // assert(b > 0); // Solidity automatically throws when dividing by 0
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46     /**
47     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         assert(b <= a);
51         return a - b;
52     }
53 
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62 }
63 
64 
65 contract PIPOT is Owner {
66     using SafeMath for uint256;
67     event Game(uint _game, uint indexed _time);
68     event ChangePrice(uint _price);
69     event Ticket(
70         address indexed _address,
71         uint indexed _game,
72         uint _number,
73         uint _time,
74         uint _price
75     );
76     
77     event ChangeFee(uint _fee);
78     event Winner(address _winnerAddress, uint _price, uint _jackpot);
79     event Lose(uint _price, uint _currentJackpot);
80     
81     // Game fee.
82     uint public fee = 20;
83     // Current game number.
84     uint public game;
85     // Ticket price.
86     uint public ticketPrice = 0.1 ether;
87     // All-time game jackpot.
88     uint public allTimeJackpot = 0;
89     // All-time game players count
90     uint public allTimePlayers = 0;
91     
92     // Game status.
93     bool public isActive = true;
94     // The variable that indicates game status switching.
95     bool public toogleStatus = false;
96     // The array of all games
97     uint[] public games;
98     
99     // Store game jackpot.
100     mapping(uint => uint) jackpot;
101     // Store game players.
102     mapping(uint => address[]) players;
103     mapping(uint => mapping(uint => address[])) orders;
104 
105     
106     // Funds distributor address.
107     address public fundsDistributor;
108 
109     /**
110     * @dev Check sender address and compare it to an owner.
111     */
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116     
117     function PIPOT(
118         address distributor
119     )
120     public Owner(msg.sender)
121     {
122         fundsDistributor = distributor;
123         startGame();
124     }
125 
126     function getPlayedGamePlayers() 
127         public
128         view
129         returns (uint)
130     {
131         return getPlayersInGame(game);
132     }
133 
134     function getPlayersInGame(uint playedGame) 
135         public 
136         view
137         returns (uint)
138     {
139         return players[playedGame].length;
140     }
141 
142     function getPlayedGameJackpot() 
143         public 
144         view
145         returns (uint) 
146     {
147         return getGameJackpot(game);
148     }
149     
150     function getGameJackpot(uint playedGame) 
151         public 
152         view 
153         returns(uint)
154     {
155         return jackpot[playedGame];
156     }
157     
158     function toogleActive() public onlyOwner() {
159         if (!isActive) {
160             isActive = true;
161         } else {
162             toogleStatus = !toogleStatus;
163         }
164     }
165     
166     function start(uint winPrice) public onlyOwner() {
167         if (players[game].length > 0) {
168             pickTheWinner(winPrice);
169         }
170         startGame();
171     }
172 
173     function changeTicketPrice(uint price) 
174         public 
175         onlyOwner() 
176     {
177         ticketPrice = price;
178         emit ChangePrice(price);
179     }
180     
181     function changeFee(uint _fee) 
182         public 
183         onlyOwner() 
184     {
185         fee = _fee;
186         emit ChangeFee(_fee);
187     }
188     
189     function buyTicket(uint betPrice) public payable {
190         require(isActive);
191         require(msg.value == ticketPrice);
192         
193         
194         uint playerNumber =  players[game].length;
195         
196         players[game].push(msg.sender);
197         orders[game][betPrice].push(msg.sender);
198         
199         uint distribute = msg.value * fee / 100;
200         
201         jackpot[game] += (msg.value - distribute);
202         
203         fundsDistributor.transfer(distribute);
204         
205         emit Ticket(msg.sender, game, playerNumber, now, betPrice);
206     }
207 
208     /**
209     * @dev Start the new game.
210     * @dev Checks ticket price changes, if exists new ticket price the price will be changed.
211     * @dev Checks game status changes, if exists request for changing game status game status 
212     * @dev will be changed.
213     */
214     function startGame() internal {
215         require(isActive);
216 
217         game = block.number;
218         if (toogleStatus) {
219             isActive = !isActive;
220             toogleStatus = false;
221         }
222         emit Game(game, now);
223     }
224 
225     function pickTheWinner(uint winPrice) internal {
226         
227         uint toPlayer;
228         
229         toPlayer = jackpot[game]/orders[game][winPrice].length;
230         
231         if(orders[game][winPrice].length > 0){
232             for(uint i = 0; i < orders[game][winPrice].length;i++){
233                 orders[game][winPrice][i].transfer(toPlayer);
234                 allTimeJackpot += jackpot[game];
235                 emit Winner(orders[game][winPrice][i], winPrice, toPlayer);
236             }   
237         }else{
238             emit Lose(winPrice, jackpot[game]);
239         }
240         
241         allTimePlayers += players[game].length;
242     }
243 }