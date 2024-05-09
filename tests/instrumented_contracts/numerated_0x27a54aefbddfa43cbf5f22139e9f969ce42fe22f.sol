1 //Gladiate
2 
3 pragma solidity ^0.4.21;
4 
5 library gladiate {
6     enum Weapon {None, Knife, Sword, Spear}
7     enum GladiatorState {Null, Incoming, Active, Outgoing}
8     
9     struct Gladiator {
10         GladiatorState state;
11         uint stateTransitionBlock;
12         uint8 x;
13         uint8 y;
14         Weapon weapon;
15         uint8 coins;
16     }
17 }
18 
19 contract Arena {
20     uint8 pseudoRandomNonce;
21     function pseudoRandomUint8(uint8 limit)
22     internal
23     returns (uint8) {
24         return uint8(keccak256(block.blockhash(block.number-1), pseudoRandomNonce)) % limit;
25         pseudoRandomNonce++;
26     }
27     
28     uint constant public coinValue = 50000000000000000; // 0.05 ETH
29     
30     uint constant spawnTime = 3;
31     uint constant despawnTime = 2;
32     
33     address public emperor;
34     mapping (address => gladiate.Gladiator) public gladiators;
35     
36     struct Tile {
37         uint coins;
38         gladiate.Weapon weapon;
39         address gladiator;
40     }
41     
42     Tile[10][10] tiles;
43     
44     function Arena()
45     public {
46         emperor = msg.sender;
47     }
48     
49     modifier onlyEmporer() 
50         {require(msg.sender == emperor); _;}
51     modifier gladiatorExists(address owner) 
52         {require(gladiators[owner].state != gladiate.GladiatorState.Null); _;}
53     modifier gladiatorInState(address owner, gladiate.GladiatorState s) 
54         {require(gladiators[owner].state == s); _;}
55     
56     function startGladiatorWithCoin(uint8 x, uint8 y, address owner)
57     internal {
58         gladiators[owner].state = gladiate.GladiatorState.Incoming;
59         gladiators[owner].stateTransitionBlock = block.number + spawnTime;
60         gladiators[owner].x = x;
61         gladiators[owner].y = y;
62         gladiators[owner].coins = 1;
63         
64         tiles[x][y].gladiator = owner;
65     }
66     
67     function despawnGladiatorAndAwardCoins(address owner)
68     internal {
69         owner.transfer(gladiators[owner].coins * coinValue);
70         
71         gladiators[owner].state = gladiate.GladiatorState.Null;
72     }
73     
74     function addCoins(uint8 x, uint8 y, uint amount)
75     internal {
76         tiles[x][y].coins += amount;
77     }
78     
79     function throwIn()
80     external
81     payable 
82     returns (bool) {
83         require(gladiators[msg.sender].state == gladiate.GladiatorState.Null);
84         require(msg.value == coinValue);
85         
86         uint8 lastX;
87         uint8 lastY;
88         for (uint8 i=0; i<3; i++) {
89             uint8 x = pseudoRandomUint8(10);
90             uint8 y = pseudoRandomUint8(10);
91             lastX = x;
92             lastY = y;
93             
94             if (tiles[x][y].gladiator == 0x0) {
95                 startGladiatorWithCoin(x, y, msg.sender);
96                 return true;
97             }
98         }
99         //Couldn't find a place for the gladiator. Let's take the money anyway and put it in the Arena.
100         //Ether is already in the contract unless we revert, so just have to put a coin somewhere
101         addCoins(lastX, lastY, 1);
102         return false;
103     }
104     
105     function activateGladiator(address who)
106     external
107     gladiatorExists(who)
108     gladiatorInState(who, gladiate.GladiatorState.Incoming) {
109         require(gladiators[who].stateTransitionBlock <= block.number);
110         
111         gladiators[who].state = gladiate.GladiatorState.Active;
112         gladiators[who].stateTransitionBlock = (uint(0) - 1);//max int
113     }
114     
115     function imOut()
116     external
117     gladiatorInState(msg.sender, gladiate.GladiatorState.Active) {
118         gladiators[msg.sender].state = gladiate.GladiatorState.Outgoing;
119         gladiators[msg.sender].stateTransitionBlock = block.number + despawnTime;
120     }
121     
122     function getOut()
123     external
124     gladiatorInState(msg.sender, gladiate.GladiatorState.Outgoing) {
125         require(gladiators[msg.sender].stateTransitionBlock <= block.number);
126         
127         despawnGladiatorAndAwardCoins(msg.sender);
128     }
129     
130     function nextBlock() 
131     public {
132         gladiators[0x0].coins ++;
133     }
134 }