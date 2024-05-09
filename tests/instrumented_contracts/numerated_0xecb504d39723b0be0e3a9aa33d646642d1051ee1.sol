1 // SPDX-License-Identifier: Unlicense
2 
3 /*
4   (w) (a) (g) (m) (i)
5   by dom
6 */
7 
8 pragma solidity ^0.8.0;
9 
10 contract Wagmipet {
11     address _owner;
12     bool _birthed;
13     
14     event CaretakerLoved(address indexed caretaker, uint256 indexed amount);
15     
16     uint256 lastFeedBlock;
17     uint256 lastCleanBlock;
18     uint256 lastPlayBlock;
19     uint256 lastSleepBlock;
20     
21     uint8 internal hunger;
22     uint8 internal uncleanliness;
23     uint8 internal boredom;
24     uint8 internal sleepiness;
25     
26     mapping (address => uint256) public love;
27     
28     modifier onlyOwner() {
29         require(msg.sender == _owner);
30         _;
31     }
32     
33     constructor() {
34         _owner = msg.sender;
35         lastFeedBlock = block.number;
36         lastCleanBlock = block.number;
37         lastPlayBlock = block.number;
38         lastSleepBlock = block.number;
39         
40         hunger = 0;
41         uncleanliness = 0;
42         boredom = 0;
43         sleepiness = 0;
44     }
45     
46     function addLove(address caretaker, uint256 amount) internal {
47         love[caretaker] += amount;
48         emit CaretakerLoved(caretaker, amount);
49     }
50     
51     function feed() public {
52         require(getAlive(), "no longer with us");
53         require(getBoredom() < 80, "im too tired to eat");
54         require(getUncleanliness() < 80, "im feeling too gross to eat");
55         // require(getHunger() > 0, "i dont need to eat");
56         
57         lastFeedBlock = block.number;
58         
59         hunger = 0;
60         boredom += 10;
61         uncleanliness += 3;
62 
63         addLove(msg.sender, 1);
64     }
65     
66     function clean() public {
67         require(getAlive(), "no longer with us");
68         require(getUncleanliness() > 0, "i dont need a bath");
69         lastCleanBlock = block.number;
70         
71         uncleanliness = 0;
72         
73         addLove(msg.sender, 1);
74     }
75     
76     function play() public {
77         require(getAlive(), "no longer with us");
78         require(getHunger() < 80, "im too hungry to play");
79         require(getSleepiness() < 80, "im too sleepy to play");
80         require(getUncleanliness() < 80, "im feeling too gross to play");
81         // require(getBoredom() > 0, "i dont wanna play");
82         
83         lastPlayBlock = block.number;
84         
85         boredom = 0;
86         hunger += 10;
87         sleepiness += 10;
88         uncleanliness += 5;
89         
90         addLove(msg.sender, 1);
91     }
92     
93     function sleep() public {
94         require(getAlive(), "no longer with us");
95         require(getUncleanliness() < 80, "im feeling too gross to sleep");
96         require(getSleepiness() > 0, "im not feeling sleepy");
97         
98         lastSleepBlock = block.number;
99         
100         sleepiness = 0;
101         uncleanliness += 5;
102         
103         addLove(msg.sender, 1);
104     }
105     
106     function getStatus() public view returns (string memory) {
107         uint256 mostNeeded = 0;
108         
109         string[4] memory goodStatus = [
110             "gm",
111             "im feeling great",
112             "all good",
113             "i love u"
114         ];
115         
116         string memory status = goodStatus[block.number % 4];
117         
118         uint256 _hunger = getHunger();
119         uint256 _uncleanliness = getUncleanliness();
120         uint256 _boredom = getBoredom();
121         uint256 _sleepiness = getSleepiness();
122         
123         if (getAlive() == false) {
124             return "no longer with us";
125         }
126         
127         if (_hunger > 50 && _hunger > mostNeeded) {
128             mostNeeded = _hunger;
129             status = "im hungry";
130         }
131         
132         if (_uncleanliness > 50 && _uncleanliness > mostNeeded) {
133             mostNeeded = _uncleanliness;
134             status = "i need a bath";
135         }
136         
137         if (_boredom > 50 && _boredom > mostNeeded) {
138             mostNeeded = _boredom;
139             status = "im bored";
140         }
141         
142         if (_sleepiness > 50 && _sleepiness > mostNeeded) {
143             mostNeeded = _sleepiness;
144             status = "im sleepy";
145         }
146         
147         return status;
148     }
149     
150     function getAlive() public view returns (bool) {
151         return getHunger() < 101 && getUncleanliness() < 101 &&
152             getBoredom() < 101 && getSleepiness() < 101;
153     }
154     
155     function getHunger() public view returns (uint256) {
156         return hunger + ((block.number - lastFeedBlock) / 50);
157     }
158     
159     function getUncleanliness() public view returns (uint256) {
160         return uncleanliness + ((block.number - lastCleanBlock) / 50);
161     }
162     
163     function getBoredom() public view returns (uint256) {
164         return boredom + ((block.number - lastPlayBlock) / 50);
165     }
166     
167     function getSleepiness() public view returns (uint256) {
168         return sleepiness + ((block.number - lastSleepBlock) / 50);
169     }
170 }