1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 // Guess the number, win a prize!
4 
5 contract CashMoney {
6     uint256 private current;
7     uint256 private last;
8     WinnerLog private winnerLog;
9     uint256 private first;
10     address public owner;
11     uint256 public min_bet = 0.001 ether;
12     uint256[5] public bonuses = [5 ether, 2 ether, 1.5 ether, 1 ether, 0.5 ether];
13 
14     struct Guess {
15         uint256 playerNo;
16         uint256 time;
17     }
18     
19     struct Player {
20         bool exists;
21         bytes name;
22         uint256 playerNo;
23     }
24     
25     Guess[] guesses;
26     //mapping( address => bool ) public winners;
27     mapping( address => Player ) private players;
28 
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     modifier onlyPlayer {
35         require(players[msg.sender].exists);
36         _;
37     }
38     
39     function getWL() public view returns(address) {
40         return winnerLog;
41     }
42     
43     constructor(address[] players_, uint256[] nums, bytes[] names, address winnerLog_) public payable {
44         owner = msg.sender;
45         every_day_im_shufflin();
46         
47         for (uint256 i = 0; i < players_.length; i++) {
48             players[players_[i]] = Player(true, names[i], nums[i]);
49         }
50         
51         first = now;
52         
53         winnerLog = WinnerLog(winnerLog_);
54     }
55     
56     function every_day_im_shufflin() internal {
57         // EVERY DAY IM SHUFFLIN
58         current = uint8(keccak256(abi.encodePacked(blockhash(block.number-2)))) % 11;
59     }
60     
61     function getName() public view returns(bytes){
62         return players[msg.sender].name;
63     }
64     
65     function updateSelf(uint256 number, bytes name) public onlyPlayer {
66         players[msg.sender].playerNo = number;
67         players[msg.sender].name = name;
68         players[msg.sender].exists = true;
69     }
70 
71     
72     function do_guess(uint256 number) payable public onlyPlayer {
73         require(msg.value >= min_bet && number <= 10);
74         // YOWO - You Only Win Once
75         require(!winnerLog.isWinner(msg.sender));
76         
77         Guess storage guess;
78         guess.playerNo = players[msg.sender].playerNo;
79         guess.time = now;
80         
81         guesses.push(guess);
82         
83         if (number == current) {
84             // you win!
85             winnerLog.logWinner(msg.sender, players[msg.sender].playerNo, players[msg.sender].name);
86             
87             uint256 winnerNum = winnerLog.getWinnerAddrs().length;
88             
89             // should always be true
90             assert(winnerNum > 0);
91             
92             if (winnerNum <= bonuses.length) {
93                 msg.sender.transfer(msg.value+bonuses[winnerNum-1]);
94             } else {
95                 msg.sender.transfer(msg.value);
96             }
97         } else {
98             revert("that wasn't very cash money of you");
99         }
100         
101         every_day_im_shufflin();
102         
103         last = now;
104     }
105     
106     function kill() public onlyOwner {
107         selfdestruct(msg.sender);
108     }
109     
110     function() public payable {
111     }
112 }
113 
114 contract WinnerLog {
115     address public owner;
116     event NewWinner(
117         address sender,
118         string name,
119         uint256 number
120     );
121     
122     
123     struct Player {
124         uint256 number;
125         string name;
126         bool exists;
127     }
128 
129     mapping(address => bool) winners;
130     address[] public winner_addr_list;
131     string[] public winner_name_list;
132     mapping( address => Player ) private players;
133 
134     modifier onlyOwner() {
135         require(msg.sender == owner);
136         _;
137     }
138 
139     modifier onlyPlayer {
140         require(players[msg.sender].exists);
141         _;
142     }
143 
144     function isWinner(address addr) public view returns (bool) {
145         return winners[addr];
146     }
147 
148     function getWinnerAddrs() public view returns (address[]) {
149         return winner_addr_list;
150     }
151     
152     function getWinnerNames() public view returns (string[]) {
153         return winner_name_list;
154     }
155     
156     constructor(address[] players_, uint256[] nums, string[] names) public {
157         owner = msg.sender;
158         for (uint256 i = 0; i < players_.length; i++) {
159             players[players_[i]] = Player(nums[i], names[i], true);
160         }
161     }
162 
163     function addPlayer(address addr, uint256 number, string name) public onlyOwner {
164         players[addr] = Player(number, name, true);
165     }
166 
167     function logWinner(address addr, uint256 playerNo, bytes name) public onlyPlayer { 
168             winners[addr] = true;
169             winner_name_list.push(string(name));
170             winner_addr_list.push(addr);
171             emit NewWinner(msg.sender, string(name), playerNo);
172     }
173 }