1 contract CryptoHill {
2     
3   address admin;
4   address leader;
5   bytes32 leaderHash;
6   bytes32 difficulty;
7   bytes32 difficultyWorldRecord;
8   uint fallenLeaders;
9   uint startingTime;
10   uint gameLength;
11   string leaderMessage;
12   string defaultLeaderMessage;
13   
14   event Begin(string log);
15   event Leader(string log, address newLeader, bytes32 newHash);
16   event GameOver(string log);
17   event Winner (string log, address winner);
18   event NoWinner (string log);
19   event WorldRecord (string log, bytes32 DifficultyRecord, address RecordHolder);
20   
21   function CryptoHill(){ 
22       
23     //Admin Backdoor
24     admin = msg.sender;
25 
26     //Starting Time
27     startingTime = block.timestamp;
28     
29     //Game Length (TODO: Change to 1 weeks)
30     gameLength = 1 weeks;
31 
32     //Initial seed for the first challenge. This should always be in rotation afterward.
33     leaderHash = sha3("09F911029D74E35BD84156C5635688C0");
34 
35     //First leader is the creator of the contract
36     leader = msg.sender;
37 
38     //The placeholder leader message
39     defaultLeaderMessage = "If you're this weeks leader, you own this field. Write a message here.";
40     leaderMessage = defaultLeaderMessage;
41     
42     //This difficulty starts as easy as possible. Any XOR will be less, to start.
43     difficulty = leaderHash;
44     
45     //Seed the world record
46     difficultyWorldRecord = leaderHash;
47     
48     //Counter for successful collisions this week.
49     fallenLeaders = 0;
50 
51     Begin("Collide the most bits of the leader's hash to replace the leader. Leader will win any bounty at the end of the week.");
52 
53   }
54   
55   function reset() private{
56       
57       //Make the hash unpredictable.
58       leaderHash = sha3(block.timestamp);
59       
60       //Reset the leader message
61       leaderMessage = defaultLeaderMessage;
62       difficulty = leaderHash;
63       leader = admin;
64       fallenLeaders = 0;
65   }
66   
67   function checkDate() private returns (bool success) {
68       
69       //Are we one week beyond the last game? TODO change time for mainnet
70       if (block.timestamp > (startingTime + gameLength)) {
71           
72           //If so, log winner. If the admin "wins", it's because no one else won.
73           if(leader != admin){
74             Winner("Victory! Game will be reset to end in 1 week (in block time).", leader);
75             leader.send(this.balance);
76           }else NoWinner("No winner! Game will be reset to end in 1 week (in block time).");
77 
78           startingTime = block.timestamp;
79 
80           //Reset
81           reset();
82           return true;
83       }
84       return false;
85   }
86 
87   function overthrow(string challengeData) returns (bool success){
88         
89         //Create hash from player data sent to contract
90         var challengeHash = sha3(challengeData);
91 
92         //Check One: Submission too late, reset game w/ new hash
93         if(checkDate())
94             return false;
95         
96         //Check Two: Cheating - of course last hash will collide!
97         if(challengeHash == leaderHash)
98             return false;
99 
100         //Check Three: Core gaming logic favoring collisions of MSB
101         if((challengeHash ^ leaderHash) > difficulty)
102           return false;
103 
104         //If player survived the checks, they've overcome difficulty level and beat the leader.
105         //Update the difficulty. This makes the game progressively harder through the week.
106         difficulty = (challengeHash ^ leaderHash);
107         
108         //Did they set a record?
109         challengeWorldRecord(difficulty);
110         
111         //We have a new Leader
112         leader = msg.sender;
113         
114         //The winning hash is our new hash. This undoes any work being done by competition!
115         leaderHash = challengeHash;
116         
117         //Announce our new victor. Congratulations!    
118         Leader("New leader! This is their address, and the new hash to collide.", leader, leaderHash);
119         
120         //Keep track of how many new leaders we've had this week.
121         fallenLeaders++;
122         
123         return true;
124   }
125   
126   function challengeWorldRecord (bytes32 difficultyChallenge) private {
127       if(difficultyChallenge < difficultyWorldRecord) {
128         difficultyWorldRecord = difficultyChallenge;
129         WorldRecord("A record setting collision occcured!", difficultyWorldRecord, msg.sender);
130       }
131   }
132   
133   function changeLeaderMessage(string newMessage){
134         //The leader gets to talk all kinds of shit. If abuse, might remove.
135         if(msg.sender == leader)
136             leaderMessage = newMessage;
137   }
138   
139   //The following functions designed for mist UI
140   function currentLeader() constant returns (address CurrentLeaderAddress){
141       return leader;
142   }
143   function Difficulty() constant returns (bytes32 XorMustBeLessThan){
144       return difficulty;
145   }
146   function LeaderHash() constant returns (bytes32 leadingHash){
147       return leaderHash;
148   }
149   function LeaderMessage() constant returns (string MessageOfTheDay){
150       return leaderMessage;
151   }
152   function FallenLeaders() constant returns (uint Victors){
153       return fallenLeaders;
154   }
155   function GameEnds() constant returns (uint EndingTime){
156       return startingTime + gameLength;
157   }
158 
159   function kill(){
160       if (msg.sender == admin){
161         GameOver("The Crypto Hill has ended.");
162         selfdestruct(admin);
163       }
164   }
165 }