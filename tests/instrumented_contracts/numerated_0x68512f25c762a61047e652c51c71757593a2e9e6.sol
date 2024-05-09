1 pragma solidity 0.4.24;
2 
3 // Random lottery
4 // Smart contracts can't bet
5 
6 // Pay 0.001 to get a random number
7 // If your random number is the highest so far you're in the lead
8 // If no one beats you in 1 day you can claim your winnnings - half of the pot.
9 
10 // Three pots total - hour long, day long, and week long.
11 // Successfully getting the highest value on one of them resets only that one.
12 
13 // When you bet, you bet for ALL THREE pots. (each is a different random number)
14 
15 contract RandoLotto {
16     
17     bool activated;
18     address internal owner;
19     uint256 internal devFee;
20     uint256 internal seed;
21     
22     uint256 public totalBids;
23     
24     // Three pots
25     uint256 public hourPot;
26     uint256 public dayPot;
27     uint256 public weekPot;
28     
29     // Each put has a current winner
30     address public hourPotLeader;
31     address public dayPotLeader;
32     address public weekPotLeader;
33     
34     // Each pot has a current high score
35     uint256 public hourPotHighscore;
36     uint256 public dayPotHighscore;
37     uint256 public weekPotHighscore;
38     
39     // Each pot has an expiration - reset when someone else takes leader of that pot
40     uint256 public hourPotExpiration;
41     uint256 public dayPotExpiration;
42     uint256 public weekPotExpiration;
43     
44     struct threeUints {
45         uint256 a;
46         uint256 b; 
47         uint256 c;
48     }
49     
50     mapping (address => threeUints) playerLastScores;
51     
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56     
57     constructor () public {
58         owner = msg.sender;
59         
60         activated = false;
61         totalBids = 0;
62         
63         hourPotHighscore = 0;
64         dayPotHighscore = 0;
65         weekPotHighscore = 0;
66         
67         hourPotLeader = msg.sender;
68         dayPotLeader = msg.sender;
69         weekPotLeader = msg.sender;
70     }
71     
72     function activate() public payable onlyOwner {
73         require(!activated);
74         require(msg.value >= 0 ether);
75         
76         hourPotExpiration = now + 1 hours;
77         dayPotExpiration = now + 1 days;
78         weekPotExpiration = now + 1 weeks;
79         
80         hourPot = msg.value / 3;
81         dayPot = msg.value / 3;
82         weekPot = msg.value - hourPot - dayPot;
83         
84         activated = true;
85     }
86     
87     // Fallback function calls bid.
88     function () public payable {
89         bid();
90     }
91     
92     // Bid function.
93     function bid() public payable returns (uint256, uint256, uint256) {
94         // Humans only unlike F3D
95         require(msg.sender == tx.origin);
96         require(msg.value == 0.01 ether);
97 
98         checkRoundEnd();
99 
100         // Add monies to pot
101         devFee = devFee + (msg.value / 100);
102         uint256 toAdd = msg.value - (msg.value / 100);
103         hourPot = hourPot + (toAdd / 3);
104         dayPot = dayPot + (toAdd / 3);
105         weekPot = weekPot + (toAdd - ((toAdd/3) + (toAdd/3)));
106 
107         // Random number via blockhash    
108         seed = uint256(keccak256(blockhash(block.number - 1), seed, now));
109         uint256 seed1 = seed;
110         
111         if (seed > hourPotHighscore) {
112             hourPotLeader = msg.sender;
113             hourPotExpiration = now + 1 hours;
114             hourPotHighscore = seed;
115         }
116         
117         seed = uint256(keccak256(blockhash(block.number - 1), seed, now));
118         uint256 seed2 = seed;
119         
120         if (seed > dayPotHighscore) {
121             dayPotLeader = msg.sender;
122             dayPotExpiration = now + 1 days;
123             dayPotHighscore = seed;
124         }
125         
126         seed = uint256(keccak256(blockhash(block.number - 1), seed, now));
127         uint256 seed3 = seed;
128         
129         if (seed > weekPotHighscore) {
130             weekPotLeader = msg.sender;
131             weekPotExpiration = now + 1 weeks;
132             weekPotHighscore = seed;
133         }
134         
135         totalBids++;
136         
137         playerLastScores[msg.sender] = threeUints(seed1, seed2, seed3);
138         return (seed1, seed2, seed3);
139     }
140     
141     function checkRoundEnd() internal {
142         if (now > hourPotExpiration) {
143             uint256 hourToSend = hourPot / 2;
144             hourPot = hourPot - hourToSend;
145             hourPotLeader.send(hourToSend);
146             hourPotLeader = msg.sender;
147             hourPotHighscore = 0;
148             hourPotExpiration = now + 1 hours;
149         }
150         
151         if (now > dayPotExpiration) {
152             uint256 dayToSend = dayPot / 2;
153             dayPot = dayPot - dayToSend;
154             dayPotLeader.send(dayToSend);
155             dayPotLeader = msg.sender;
156             dayPotHighscore = 0;
157             dayPotExpiration = now + 1 days;
158         }
159         
160         if (now > weekPotExpiration) {
161             uint256 weekToSend = weekPot / 2;
162             weekPot = weekPot - weekToSend;
163             weekPotLeader.send(weekToSend);
164             weekPotLeader = msg.sender;
165             weekPotHighscore = 0;
166             weekPotExpiration = now + 1 weeks;
167         }
168     }
169     
170     function claimWinnings() public {
171         checkRoundEnd();
172     }
173     
174     function getMyLastScore() public view returns (uint256, uint256, uint256) {
175         return (playerLastScores[msg.sender].a, playerLastScores[msg.sender].b, playerLastScores[msg.sender].c);
176     }
177     
178     function devWithdraw() public onlyOwner {
179         uint256 toSend = devFee;
180         devFee = 0;
181         owner.transfer(toSend);
182     }
183 }