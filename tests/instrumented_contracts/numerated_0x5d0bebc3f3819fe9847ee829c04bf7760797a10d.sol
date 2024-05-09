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
77     event Winner(address _winnerAddress, uint _price, uint _jackpot);
78     event Lose(uint _price, uint _currentJackpot);
79     
80     // Game fee.
81     uint8 public fee = 20;
82     // Current game number.
83     uint public game;
84     // Ticket price.
85     uint public ticketPrice = 0.1 ether;
86     // All-time game jackpot.
87     uint public allTimeJackpot = 0;
88     // All-time game players count
89     uint public allTimePlayers = 0;
90     
91     // Game status.
92     bool public isActive = true;
93     // The variable that indicates game status switching.
94     bool public toogleStatus = false;
95     // The array of all games
96     uint[] public games;
97     
98     // Store game jackpot.
99     mapping(uint => uint) jackpot;
100     // Store game players.
101     mapping(uint => address[]) players;
102     //Store bet price
103     mapping(uint => address[]) orders;
104     //Store price with orders
105     mapping(uint => bool) orderPrices;
106     
107     // Funds distributor address.
108     address public fundsDistributor;
109 
110     /**
111     * @dev Check sender address and compare it to an owner.
112     */
113     modifier onlyOwner() {
114         require(msg.sender == owner);
115         _;
116     }
117     
118     function PIPOT(
119         address distributor
120     )
121     public Owner(msg.sender)
122     {
123         fundsDistributor = distributor;
124         startGame();
125     }
126 
127     function getPlayedGamePlayers() 
128         public
129         view
130         returns (uint)
131     {
132         return getPlayersInGame(game);
133     }
134 
135     function getPlayersInGame(uint playedGame) 
136         public 
137         view
138         returns (uint)
139     {
140         return players[playedGame].length;
141     }
142 
143     function getPlayedGameJackpot() 
144         public 
145         view
146         returns (uint) 
147     {
148         return getGameJackpot(game);
149     }
150     
151     function getGameJackpot(uint playedGame) 
152         public 
153         view 
154         returns(uint)
155     {
156         return jackpot[playedGame];
157     }
158     
159     function toogleActive() public onlyOwner() {
160         if (!isActive) {
161             isActive = true;
162         } else {
163             toogleStatus = !toogleStatus;
164         }
165     }
166     
167     function start(uint winPrice) public onlyOwner() {
168         if (players[game].length > 0) {
169             pickTheWinner(winPrice);
170         }
171         startGame();
172     }
173 
174     function changeTicketPrice(uint price) 
175         public 
176         onlyOwner() 
177     {
178         ticketPrice = price;
179         emit ChangePrice(price);
180     }
181     
182     function buyTicket(uint betPrice) public payable {
183         require(isActive);
184         require(msg.value == ticketPrice);
185         
186         
187         orders[betPrice].push(msg.sender);
188         if(orderPrices[betPrice] != true){
189             orderPrices[betPrice] = true;
190         }
191         
192         uint playerNumber =  players[game].length;
193         players[game].push(msg.sender);
194         
195         uint distribute = msg.value * fee / 100;
196         jackpot[game] += (msg.value - distribute);
197         fundsDistributor.transfer(distribute);
198         
199         emit Ticket(msg.sender, game, playerNumber, now, betPrice);
200     }
201 
202     /**
203     * @dev Start the new game.
204     * @dev Checks game status changes, if exists request for changing game status game status 
205     * @dev will be changed.
206     */
207     function startGame() internal {
208         require(isActive);
209 
210         game = block.number;
211         if (toogleStatus) {
212             isActive = !isActive;
213             toogleStatus = false;
214         }
215         emit Game(game, now);
216     }
217 
218     function pickTheWinner(uint winPrice) internal {
219         
220         uint toPlayer;
221         if (players[game].length == 1) {
222             toPlayer = jackpot[game];
223             players[game][0].transfer(jackpot[game]);
224         } else {
225             toPlayer = jackpot[game]/orders[winPrice].length;
226             if(orders[winPrice].length > 0){
227                 for(uint i = 0; i < orders[winPrice].length;i++){
228                     if(orderPrices[winPrice] == true){
229                         orders[winPrice][i].transfer(toPlayer);
230                         emit Winner(orders[winPrice][i], winPrice, toPlayer);
231                     }
232                 }   
233             }else{
234                 emit Lose(winPrice, jackpot[game]);
235             }
236         }
237         
238         allTimeJackpot += toPlayer;
239         allTimePlayers += players[game].length;
240     }
241 }