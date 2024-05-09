1 contract BlockChainChallenge {
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
13   mapping (address => uint) winners;
14   
15   event Begin(string log);
16   event Leader(string log, address newLeader, bytes32 newHash);
17   event GameOver(string log);
18   event Winner (string log, address winner);
19   event NoWinner (string log);
20   event WorldRecord (string log, bytes32 DifficultyRecord, address RecordHolder);
21   
22   function BlockChainChallenge(){ 
23       
24     //Admin Backdoor
25     admin = msg.sender;
26 
27     //Starting Time
28     startingTime = block.timestamp;
29     
30     //Game Length (TODO: Change to 1 weeks)
31     gameLength = 1 weeks;
32 
33     //Initial seed for the first challenge. This should always be in rotation afterward.
34     leaderHash = sha3("09F911029D74E35BD84156C5635688C0");
35 
36     //First leader is the creator of the contract
37     leader = msg.sender;
38 
39     //The placeholder leader message
40     defaultLeaderMessage = "If you're this weeks leader, you own this field. Write a message here.";
41     leaderMessage = defaultLeaderMessage;
42     
43     //This difficulty starts as easy as possible. Any XOR will be less, to start.
44     difficulty = leaderHash;
45     
46     //Seed the world record
47     difficultyWorldRecord = leaderHash;
48     
49     //Counter for successful collisions this week.
50     fallenLeaders = 0;
51 
52     Begin("Collide the most bits of the leader's hash to replace the leader. Leader will win any bounty at the end of the week.");
53 
54   }
55   
56   function reset() private{
57       
58       //Make the hash unpredictable.
59       leaderHash = sha3(block.timestamp);
60       
61       //Reset the leader message
62       leaderMessage = defaultLeaderMessage;
63       difficulty = leaderHash;
64       leader = admin;
65       fallenLeaders = 0;
66   }
67   
68   function checkDate() private returns (bool success) {
69       
70       //Are we one week beyond the last game? TODO change time for mainnet
71       if (block.timestamp > (startingTime + gameLength)) {
72           
73           //If so, log winner. If the admin "wins", it's because no one else won.
74           if(leader != admin){
75             Winner("Victory! Game will be reset to end in 1 week (in block time).", leader);
76             leader.send(this.balance);
77           }else NoWinner("No winner! Game will be reset to end in 1 week (in block time).");
78 
79           startingTime = block.timestamp;
80 
81           //Reset
82           reset();
83           return true;
84       }
85       return false;
86   }
87 
88   function overthrow(string challengeData) returns (bool success){
89         
90         //Create hash from player data sent to contract
91         var challengeHash = sha3(challengeData);
92 
93         //Check One: Submission too late, reset game w/ new hash
94         if(checkDate())
95             return false;
96         
97         //Check Two: Cheating - of course last hash will collide!
98         if(challengeHash == leaderHash)
99             return false;
100 
101         //Check Three: Core gaming logic favoring collisions of MSB
102         if((challengeHash ^ leaderHash) > difficulty)
103           return false;
104 
105         //If player survived the checks, they've overcome difficulty level and beat the leader.
106         //Update the difficulty. This makes the game progressively harder through the week.
107         difficulty = (challengeHash ^ leaderHash);
108         
109         //Did they set a record?
110         challengeWorldRecord(difficulty);
111         
112         //We have a new Leader
113         leader = msg.sender;
114         
115         //The winning hash is our new hash. This undoes any work being done by competition!
116         leaderHash = challengeHash;
117         
118         //Announce our new victor. Congratulations!    
119         Leader("New leader! This is their address, and the new hash to collide.", leader, leaderHash);
120         
121         //Add to historical Winners
122         winners[msg.sender]++;
123         
124         //Keep track of how many new leaders we've had this week.
125         fallenLeaders++;
126         
127         return true;
128   }
129   
130   function challengeWorldRecord (bytes32 difficultyChallenge) private {
131       if(difficultyChallenge < difficultyWorldRecord) {
132         difficultyWorldRecord = difficultyChallenge;
133         WorldRecord("A record setting collision occcured!", difficultyWorldRecord, msg.sender);
134       }
135   }
136   
137   function changeLeaderMessage(string newMessage){
138         //The leader gets to talk all kinds of shit. If abuse, might remove.
139         if(msg.sender == leader)
140             leaderMessage = newMessage;
141   }
142   
143   //The following functions designed for mist UI
144   function currentLeader() constant returns (address CurrentLeaderAddress){
145       return leader;
146   }
147   function Difficulty() constant returns (bytes32 XorMustBeLessThan){
148       return difficulty;
149   }
150   function TargetHash() constant returns (bytes32 leadingHash){
151       return leaderHash;
152   }
153   function LeaderMessage() constant returns (string MessageOfTheDay){
154       return leaderMessage;
155   }
156   function FallenLeaders() constant returns (uint Victors){
157       return fallenLeaders;
158   }
159   function GameEnds() constant returns (uint EndingTime){
160       return startingTime + gameLength;
161   }
162   function getWins(address check) constant returns (uint wins){
163       return winners[check];
164   }
165 
166   function kill(){
167       if (msg.sender == admin){
168         GameOver("The challenge has ended.");
169         selfdestruct(admin);
170       }
171   }
172 }