1 pragma solidity ^ 0.4.21;
2 
3 contract ThreeQueens {
4     address[3] public Queens;
5     
6     enum AntType {Worker, Warrior, Miner}
7     
8     struct Colony {
9         uint food;
10         uint materials;
11         uint gold;
12         uint tunnels;
13         
14         uint workers;
15         uint warriors;
16         uint miners;
17         
18         AntType spawningType;
19         uint lastSpawnBN;
20     }
21     
22     Colony[3] public colonies;
23     
24     function claimQueen(uint8 playerID)
25     external {
26         require(Queens[playerID] == 0x0);
27         
28         Queens[playerID] = msg.sender;
29         
30         colonies[playerID].food = 100;
31         
32         colonies[playerID].spawningType = AntType.Worker;
33         colonies[playerID].lastSpawnBN = block.number;
34     }
35     
36 //    modifier onlyQueen() {
37 //        require(msg.sender == Queens[0] || msg.sender == Queens[1] || msg.sender == Queens[2]);
38 //        _;
39 //    }
40     
41     function checkAndGetSendersID()
42     internal
43     view
44     returns(uint8) {
45         for (uint8 i=0; i<3; i++) {
46             if (msg.sender == Queens[i]) {
47                 return i;
48             }
49         }
50         revert();
51     }
52     
53     function setSpawnType(AntType spawnType)
54     external {
55         uint8 playerID = checkAndGetSendersID();
56         
57         colonies[playerID].spawningType = spawnType;
58         colonies[playerID].lastSpawnBN = block.number;
59     }
60     
61     function getAntCost(AntType antType)
62     internal
63     pure
64     returns(uint) {
65         if (antType == AntType.Worker) return 1;
66         if (antType == AntType.Warrior) return 5;
67         if (antType == AntType.Miner) return 15;
68     }
69     
70     function spawnAnts(uint8 playerID, uint number, AntType spawnType)
71     internal {
72         uint prevFood = colonies[playerID].food;
73         colonies[playerID].food -= number * getAntCost(spawnType);
74         
75         // Currently this is probably still vulnerable to attacks relating to overflow...
76         assert(colonies[playerID].food <= prevFood);// this won't really fix it completely, but might help??
77         
78         if (spawnType == AntType.Worker) colonies[playerID].workers += number;
79         if (spawnType == AntType.Warrior) colonies[playerID].warriors += number;
80         if (spawnType == AntType.Miner) colonies[playerID].miners += number;
81         
82         colonies[playerID].lastSpawnBN = block.number;
83     }
84     
85     function spawn()
86     external {
87         uint8 playerID = checkAndGetSendersID();
88         
89         uint numBlocksPassed = block.number - colonies[playerID].lastSpawnBN;
90         uint maxSpawnTimeConstraint = numBlocksPassed; // Could change this in the future
91         
92         uint maxSpawnFoodConstraint = colonies[playerID].food / getAntCost(colonies[playerID].spawningType);
93         
94         uint spawnNumber;
95         if (maxSpawnTimeConstraint < maxSpawnFoodConstraint) spawnNumber = maxSpawnTimeConstraint;
96         else spawnNumber = maxSpawnFoodConstraint;
97         
98         spawnAnts(playerID, spawnNumber, colonies[playerID].spawningType);
99     }
100 }