1 pragma solidity ^0.5.12;
2 
3 // 
4 // * whitebetting.com - the whitest european football betting game based on ethereum blockchain
5 // on 2019-09-24
6 //
7 
8 contract WhiteBetting {
9   address payable public owner;
10 
11   // Game information
12   struct GameInfo {
13     // game start time
14     uint256 timestamp;
15     // game odds
16     uint32 odd_homeTeam;
17     uint32 odd_drawTeam; 
18     uint32 odd_awayTeam;
19     uint32 odd_over;
20     uint32 odd_under;
21     uint32 odd_homeTeamAndDraw;
22     uint32 odd_homeAndAwayTeam;
23     uint32 odd_awayTeamAndDraw;
24     // Checking the game status
25     uint8  open_status;
26     // Checking whether winning were paid
27     bool   isDone;
28   }
29   mapping(uint64 => GameInfo) public gameList;
30 
31   // Player betting infomation
32   struct BetFixture {
33     address payable player;
34     uint256 stake;
35     uint32  odd;
36     // betting type
37     uint16  selectedTeam;
38   }
39   mapping(uint64 => BetFixture[]) public betList;
40 
41   // Events that are issued to make statistic recovery easier
42   event Success(uint256 odd);
43   event Deposit(address sender, uint256 eth);
44   event Withdraw(address receiver, uint256 eth);
45   event NewStake(address player, uint64 fixtureId, uint16 selectedTeam, uint256 stake, uint256 odd );
46   event SetGame(uint64 _fixtureId, uint256 _timestamp, uint32 _odd_homeTeam, uint32 _odd_drawTeam, uint32 _odd_awayTeam, uint32 _odd_over, uint32 _odd_under, uint32 _odd_homeTeamAndDraw, uint32 _odd_homeAndAwayTeam , uint32 _odd_awayTeamAndDraw, uint8 _open_status);
47   event ChangeOdd (uint64 _fixtureId, uint32 _odd_homeTeam, uint32 _odd_drawTeam, uint32 _odd_awayTeam, uint32 _odd_over, uint32 _odd_under, uint32 _odd_homeTeamAndDraw, uint32 _odd_homeAndAwayTeam , uint32 _odd_awayTeamAndDraw);
48   event GivePrizeMoney(uint64 _fixtureId, uint8 _homeDrawAway, uint8 _overUnder);
49   
50   // Constructor
51   constructor() public {
52     owner   = msg.sender;
53   }
54 
55   // Change the game status
56   function setOpenStatus(uint64 _fixtureId, uint8 _open_status) external onlyOwner {
57     gameList[_fixtureId].open_status = _open_status;
58   }
59 
60   // Refresh the game odd
61   function changeOdd (uint64 _fixtureId, uint32 _odd_homeTeam, uint32 _odd_drawTeam, uint32 _odd_awayTeam, uint32 _odd_over, uint32 _odd_under, uint32 _odd_homeTeamAndDraw, uint32 _odd_homeAndAwayTeam , uint32 _odd_awayTeamAndDraw ) external onlyOwner {
62     gameList[_fixtureId].odd_homeTeam        = _odd_homeTeam;
63     gameList[_fixtureId].odd_drawTeam        = _odd_drawTeam;
64     gameList[_fixtureId].odd_awayTeam        = _odd_awayTeam;
65     gameList[_fixtureId].odd_over            = _odd_over;
66     gameList[_fixtureId].odd_under           = _odd_under;
67     gameList[_fixtureId].odd_homeTeamAndDraw = _odd_homeTeamAndDraw;
68     gameList[_fixtureId].odd_homeAndAwayTeam = _odd_homeAndAwayTeam;
69     gameList[_fixtureId].odd_awayTeamAndDraw = _odd_awayTeamAndDraw;
70     emit ChangeOdd (_fixtureId, _odd_homeTeam, _odd_drawTeam, _odd_awayTeam, _odd_over, _odd_under, _odd_homeTeamAndDraw, _odd_homeAndAwayTeam , _odd_awayTeamAndDraw);
71   }
72 
73   // Save the game information
74   function setGameInfo (uint64 _fixtureId, uint256 _timestamp, uint32 _odd_homeTeam, uint32 _odd_drawTeam, uint32 _odd_awayTeam, uint32 _odd_over, uint32 _odd_under, uint32 _odd_homeTeamAndDraw, uint32 _odd_homeAndAwayTeam , uint32 _odd_awayTeamAndDraw, uint8 _open_status ) external onlyOwner {
75     gameList[_fixtureId].timestamp           = _timestamp;
76     gameList[_fixtureId].odd_homeTeam        = _odd_homeTeam;
77     gameList[_fixtureId].odd_drawTeam        = _odd_drawTeam;
78     gameList[_fixtureId].odd_awayTeam        = _odd_awayTeam;
79     gameList[_fixtureId].odd_over            = _odd_over;
80     gameList[_fixtureId].odd_under           = _odd_under;
81     gameList[_fixtureId].odd_homeTeamAndDraw = _odd_homeTeamAndDraw;
82     gameList[_fixtureId].odd_homeAndAwayTeam = _odd_homeAndAwayTeam;
83     gameList[_fixtureId].odd_awayTeamAndDraw = _odd_awayTeamAndDraw;
84     gameList[_fixtureId].open_status         = _open_status;
85     gameList[_fixtureId].isDone              = false;
86     emit SetGame(_fixtureId, _timestamp, _odd_homeTeam, _odd_drawTeam, _odd_awayTeam, _odd_over, _odd_under, _odd_homeTeamAndDraw, _odd_homeAndAwayTeam , _odd_awayTeamAndDraw, _open_status);
87   }
88 
89   // Player make a bet
90   function placeBet(uint64 _fixtureId, uint16 _selectedTeam, uint32 _odd) external payable  {
91     uint stake = msg.value;
92     // Minium amount to bet is 0.001 ether
93     require(stake >= .001 ether);
94     // Check whether odds is valid
95     require(_odd != 0 );
96 
97     // Compare to match mainnet odds with was submitted odds by betting type
98     if (_selectedTeam == 1 ) {
99       require(gameList[_fixtureId].odd_homeTeam == _odd);
100     } else if ( _selectedTeam == 2) {
101       require(gameList[_fixtureId].odd_drawTeam == _odd);
102     } else if ( _selectedTeam == 3) {
103       require(gameList[_fixtureId].odd_awayTeam == _odd);
104     } else if ( _selectedTeam == 4) {
105       require(gameList[_fixtureId].odd_over == _odd);
106     } else if ( _selectedTeam == 5) {
107       require(gameList[_fixtureId].odd_under == _odd);
108     } else if ( _selectedTeam == 6) {
109       require(gameList[_fixtureId].odd_homeTeamAndDraw == _odd);
110     } else if ( _selectedTeam == 7) {
111       require(gameList[_fixtureId].odd_homeAndAwayTeam == _odd);
112     } else if ( _selectedTeam == 8) {
113       require(gameList[_fixtureId].odd_awayTeamAndDraw == _odd);
114     } else {
115       revert();
116     }
117 
118     // Betting is possible when the game was opening
119     require(gameList[_fixtureId].open_status == 3);
120     // Betting is possible only 10 min. ago
121     require( now < ( gameList[_fixtureId].timestamp  - 10 minutes ) );
122 
123     // Save the betting information
124     betList[_fixtureId].push(BetFixture( msg.sender, stake,  _odd, _selectedTeam));
125     emit NewStake(msg.sender, _fixtureId, _selectedTeam, stake, _odd );
126 
127   }
128 
129   // Give prize money by the game result
130   function givePrizeMoney(uint64 _fixtureId, uint8 _homeDrawAway, uint8 _overUnder) external onlyOwner payable {
131     // Check the game status whether is opening
132     require(gameList[_fixtureId].open_status == 3);
133     // Check if it has ever compensated
134     require(gameList[_fixtureId].isDone == false);
135     // Check if it has any player who betted
136     require(betList[_fixtureId][0].player != address(0) );
137 
138     // Give the prize money!
139     for (uint i= 0 ; i < betList[_fixtureId].length; i++){
140       uint16 selectedTeam = betList[_fixtureId][i].selectedTeam;
141       uint256 returnEth = (betList[_fixtureId][i].stake * betList[_fixtureId][i].odd) / 1000 ;
142       if ( (selectedTeam == 1 && _homeDrawAway == 1) 
143         || (selectedTeam == 2 && _homeDrawAway == 2) 
144         || (selectedTeam == 3 && _homeDrawAway == 3) 
145         || (selectedTeam == 4 && _overUnder == 1) 
146         || (selectedTeam == 5 && _overUnder == 2) 
147         || (selectedTeam == 6 && ( _homeDrawAway == 1 || _homeDrawAway == 2) )
148         || (selectedTeam == 7 && ( _homeDrawAway == 1 || _homeDrawAway == 3) )
149         || (selectedTeam == 8 && ( _homeDrawAway == 3 || _homeDrawAway == 2) ) 
150         ){ 
151         betList[_fixtureId][i].player.transfer(returnEth);
152       }
153     }
154 
155     // Change the game status.
156     gameList[_fixtureId].open_status = 5;
157     // It was paid.
158     gameList[_fixtureId].isDone = true; // 보상을 마쳤으므로 true로 변경.
159 
160     emit GivePrizeMoney( _fixtureId,  _homeDrawAway,  _overUnder);
161   }
162 
163   // Standard modifier on methods invokable only by contract owner.
164   modifier onlyOwner {
165     require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
166     _;
167   }
168 
169   // Get this balance of CA
170   function getBalance() external view returns(uint){
171     return address(this).balance;
172   }
173 
174   // Deposit from owner to CA
175   function deposit(uint256 _eth) external payable{
176     emit Deposit(msg.sender, _eth);
177   }
178 
179   // Change Owner
180   function changeOwner(address payable _newOwner ) external onlyOwner {
181     owner = _newOwner;
182   }
183 
184   // Fallback function
185   function () external payable{
186     owner.transfer(msg.value);    
187   }
188 
189   // Withdraw from CA to owner
190   function withdraw(uint256 _amount) external payable onlyOwner {
191     require(_amount > 0 && _amount <= address(this).balance );
192     owner.transfer(_amount);
193     emit Withdraw(owner, _amount);
194   }
195 
196 }