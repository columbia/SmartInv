1 pragma solidity ^0.4.25;
2 
3 contract Town {
4     struct Position {
5         int x;
6         int y;
7     }
8     
9     uint movePrice = 0.001 ether;
10     uint attackPrice = 0.005 ether;
11     uint spawnPrice = 0.01 ether;
12     uint fee = 20;
13     uint refFee = 10;
14     
15     mapping (address => bool) internal users;
16     mapping (address => bool) internal ingame;
17     mapping (address => address) public referrers;
18     mapping (int => mapping (int => address)) public field;
19     mapping (address => Position) public positions;
20     address support = msg.sender;
21     
22     uint private seed;
23     
24     event UserPlaced(address user, int x, int y);
25     event UserAttacked(address user, address by);
26     event UserRemoved(address user);
27     
28     /* Converts uint256 to bytes32 */
29     function toBytes(uint256 x) internal pure returns (bytes b) {
30         b = new bytes(32);
31         assembly {
32             mstore(add(b, 32), x)
33         }
34     }
35     
36     function random(uint lessThan) internal returns (uint) {
37         seed += block.timestamp + uint(msg.sender);
38         return uint(sha256(toBytes(uint(blockhash(block.number - 1)) + seed))) % lessThan;
39     }
40     
41     function bytesToAddress(bytes source) internal pure returns (address parsedAddress) {
42         assembly {
43             parsedAddress := mload(add(source,0x14))
44         }
45         return parsedAddress;
46     }
47     
48     function requireEmptyCell(int x, int y) internal view {
49         require(field[x][y] == 0x0);
50     }
51     
52     function moveTo(int diffX, int diffY) internal {
53         Position storage p = positions[msg.sender];
54         int _x = p.x + diffX;
55         int _y = p.y + diffY;
56         requireEmptyCell(_x, _y);
57         delete field[p.x][p.y];
58         field[_x][_y] = msg.sender;
59         positions[msg.sender] = Position(_x, _y);
60     }
61     
62     function removeUserFrom(address user, int x, int y) internal {
63         delete ingame[user];
64         delete field[x][y];
65         delete positions[user];
66     }
67     
68     function tryAttack(int diffX, int diffY) internal returns (address) {
69         Position storage p = positions[msg.sender];
70         int _x = p.x + diffX;
71         int _y = p.y + diffY;
72         address enemy = field[_x][_y];
73         if (enemy != 0x0) {
74             removeUserFrom(enemy, _x, _y);
75             msg.sender.transfer(address(this).balance / 2);
76             return enemy;
77         } else {
78             return 0x0;
79         }
80     }
81     
82     function fees() internal {
83         support.transfer(msg.value * fee / 100);
84         if (referrers[msg.sender] != 0x0) {
85             referrers[msg.sender].transfer(msg.value * refFee / 100);
86         }
87     }
88 
89     function move(uint8 dir) external payable {
90         require(ingame[msg.sender]);
91         require(msg.value == movePrice);
92         require(dir < 4);
93         fees();
94         if (dir == 0) {
95             moveTo(0, -1);
96         } else if (dir == 1) {
97             moveTo(1, 0);
98         } else if (dir == 2) {
99             moveTo(0, 1);
100         } else {
101             moveTo(-1, 0);
102         }
103         emit UserPlaced(msg.sender, positions[msg.sender].x, positions[msg.sender].y);
104     }
105     
106     function attack(uint8 dir) external payable {
107         require(ingame[msg.sender]);
108         require(msg.value == attackPrice);
109         require(dir < 4);
110         fees();
111         address enemy;
112         if (dir == 0) {
113             enemy = tryAttack(0, -1);
114         } else if (dir == 1) {
115             enemy = tryAttack(1, 0);
116         } else if (dir == 2) {
117             enemy = tryAttack(0, 1);
118         } else {
119             enemy = tryAttack(-1, 0);
120         }
121         emit UserAttacked(enemy, msg.sender);
122         emit UserRemoved(enemy);
123     }
124     
125     function () external payable {
126         require(!ingame[msg.sender]);
127         require(msg.value == spawnPrice);
128         ingame[msg.sender] = true;
129         if (!users[msg.sender]) {
130             users[msg.sender] = true;
131             address referrerAddress = bytesToAddress(bytes(msg.data));
132             require(referrerAddress != msg.sender);     
133             if (users[referrerAddress]) {
134                 referrers[msg.sender] = referrerAddress;
135             }
136         }
137         
138         fees();
139         
140         int x = int(random(20)) - 10;
141         int y = int(random(20)) - 10;
142         
143         while (field[x][y] != 0x0) {
144             x += int(random(2)) * 2 - 1;
145             y += int(random(2)) * 2 - 1;
146         }
147         
148         field[x][y] = msg.sender;
149         positions[msg.sender] = Position(x, y);
150         
151         emit UserPlaced(msg.sender, x, y);
152     }
153 }