1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract WorldCupTeam {
48 
49     EtherWorldCup etherWorldCup;
50     string public teamName;
51     address public parentAddr;
52     uint256 public endTime = 1528988400; // 1528988400 - 2018-6-14 15:00 GMT
53 
54     function WorldCupTeam(address _parent, string _name) public {
55         parentAddr = _parent;
56         etherWorldCup = EtherWorldCup(parentAddr);
57         teamName = _name;
58     }
59 
60     // deposit will be transfered to the main pool in the parent contract
61     function () 
62         public
63         payable 
64     {
65         require(now <= endTime, "Betting period has ended");
66 
67         parentAddr.transfer(msg.value);
68         etherWorldCup.UpdateBetOnTeams(teamName, msg.sender, msg.value);
69     }
70 }
71 
72 contract EtherWorldCup is Ownable {
73     using SafeMath for uint256;
74 
75     mapping(address=>bool) public isWorldCupTeam;
76     uint public numOfTeam;
77 
78     mapping(string=>mapping(address=>uint256)) playersBetOnTeams; // address that bet on each team
79     mapping(string=>address[]) playersPick; // player addresses on each team
80     mapping(string=>uint256) PlayersBet; // bets on each team
81     uint public commission = 90; // number in percent
82 
83     uint256 public sharingPool;
84     uint256 totalShare = 50; 
85 
86     // EVENTS
87     event UpdatedBetOnTeams(string team, address whom, uint256 betAmt);
88 
89     // FUNCTIONS
90 
91     function EtherWorldCup() public {}
92 
93     function permitChildContract(address[] _teams)
94         public
95         onlyOwner
96     {
97         for (uint i = 0; i < _teams.length; i++) {
98             if (!isWorldCupTeam[_teams[i]]) numOfTeam++;
99             isWorldCupTeam[_teams[i]] = true;
100         }
101     }
102 
103     function () payable {}
104 	
105     // update the bets by child contract only
106     function UpdateBetOnTeams(string _team, address _addr, uint256 _betAmt) 
107     {   
108         require(isWorldCupTeam[msg.sender]);
109 
110         if (playersBetOnTeams[_team][_addr] == 0) playersPick[_team].push(_addr); // prevent duplicate address
111         playersBetOnTeams[_team][_addr] = playersBetOnTeams[_team][_addr].add(_betAmt);
112         PlayersBet[_team] = PlayersBet[_team].add(_betAmt);
113         sharingPool = sharingPool.add(_betAmt);
114         UpdatedBetOnTeams(_team, _addr, _betAmt);
115     }
116 
117     uint256 public numOfWinner;
118     address[] public winners;
119     uint256 public distributeAmount;
120 
121     // distribute fund to winners
122     function distributeWinnerPool(string _winTeam, uint256 _share) 
123         public 
124         onlyOwner
125     {
126         distributeAmount = sharingPool.mul(commission).div(100).mul(_share).div(totalShare);
127         winners = playersPick[_winTeam]; // number of ppl bet on the winning team
128         numOfWinner = winners.length;
129 
130         // for each address, to distribute the prize according to the ratio
131         for (uint i = 0; i < winners.length; i++) {
132             uint256 sendAmt = distributeAmount.mul(playersBetOnTeams[_winTeam][winners[i]]).div(PlayersBet[_winTeam]);
133             winners[i].transfer(sendAmt);
134         }
135     }
136 
137     function getPlayerBet(string _team, address _addr) 
138         public
139         returns (uint256)
140     {
141         return playersBetOnTeams[_team][_addr];
142     }
143 
144     function getPlayersPick(string _team) 
145         public
146         returns (address[])
147     {
148         return playersPick[_team];
149     }
150 
151     function getTeamBet(string _team) 
152         public 
153         returns (uint256)
154     {
155         return PlayersBet[_team];
156     }
157 
158     function updateCommission(uint _newPercent) 
159         public 
160         onlyOwner
161     {
162         commission = _newPercent;
163     }
164 
165     function safeDrain() 
166         public 
167         onlyOwner 
168     {
169         owner.transfer(this.balance);
170     }
171 }