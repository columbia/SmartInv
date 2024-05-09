1 /*  
2 
3 $$$$$$$\                                 $$\$$\   $$\                       $$$$$$\                                
4 $$  __$$\                                $$ $$$\  $$ |                     $$  __$$\                               
5 $$ |  $$ |$$$$$$\ $$$$$$\ $$$$$$$\  $$$$$$$ $$$$\ $$ |$$$$$$\ $$\  $$\  $$\$$ /  \__|$$$$$$$\$$$$$$\ $$$$$$\$$$$\  
6 $$$$$$$\ $$  __$$\\____$$\$$  __$$\$$  __$$ $$ $$\$$ $$  __$$\$$ | $$ | $$ \$$$$$$\ $$  _____\____$$\$$  _$$  _$$\ 
7 $$  __$$\$$ |  \__$$$$$$$ $$ |  $$ $$ /  $$ $$ \$$$$ $$$$$$$$ $$ | $$ | $$ |\____$$\$$ /     $$$$$$$ $$ / $$ / $$ |
8 $$ |  $$ $$ |    $$  __$$ $$ |  $$ $$ |  $$ $$ |\$$$ $$   ____$$ | $$ | $$ $$\   $$ $$ |    $$  __$$ $$ | $$ | $$ |
9 $$$$$$$  $$ |    \$$$$$$$ $$ |  $$ \$$$$$$$ $$ | \$$ \$$$$$$$\\$$$$$\$$$$  \$$$$$$  \$$$$$$$\$$$$$$$ $$ | $$ | $$ |
10 \_______/\__|     \_______\__|  \__|\_______\__|  \__|\_______|\_____\____/ \______/ \_______\_______\__| \__| \__|
11 
12            __________                                 
13          .'----------`.                              
14          | .--------. |                             
15          | |$$$$$$$$| |       __________              
16          | |$$$$$$$$| |      /__________\             
17 .--------| `--------' |------|    --=-- |-------------.
18 |        `----,-.-----'      |o ======  |             | 
19 |       ______|_|_______     |__________|             | 
20 |      /  %%%%%%%%%%%%  \                             | 
21 |     /  %%%%%%%%%%%%%%  \                            | 
22 |     ^^^^^^^^^^^^^^^^^^^^                            | 
23 +-----------------------------------------------------+
24 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
25 
26 You're always on the ground floor to somewhere...
27 
28 * No divs. No refs. Only scams
29 * Scam price only goes up 
30 * No guarantee there will be any ETH left when you sell
31 * 30-minute time out between buying and selling 
32 * Contract has a built-in equal opportunity ETH drain
33 * 5% stupid tax 
34 * The whole contract can be exit scammed in 48 hours
35 
36 */
37 
38 pragma solidity ^0.4.25;
39 
40     contract BrandNewScam {
41 
42     using ScamMath for uint256;
43     
44     address public scammerInChief;
45     uint256 public greaterFools;
46     uint256 public availableBalance;
47     uint256 public countdownToExitScam;
48     uint256 public scamSupply;
49     uint256 public scamPrice = 69696969696969;
50     uint256 public stupidTaxRate = 5;
51     uint256 public timeOut = 30 minutes;
52     mapping (address => uint256) public userTime;
53     mapping (address => uint256) public userScams;
54     mapping (address => uint256) public userBalance;
55     
56     constructor() public payable{
57         scammerInChief = msg.sender;
58         buyScams();
59         countdownToExitScam = now + 48 hours;
60     }
61     
62     modifier relax { 
63         require (msg.sender == tx.origin); 
64         _; 
65     }
66 
67     modifier wait { 
68         require (now >= userTime[msg.sender] + timeOut);
69         _; 
70     }
71     
72     function () public payable relax {
73         buyScams();
74     }
75 
76     function buyScams() public payable relax {
77         uint256 stupidTax = msg.value.mul(stupidTaxRate).div(100);
78         uint256 ethRemaining = msg.value.sub(stupidTax);
79         require(ethRemaining >= scamPrice);
80         uint256 scamsPurchased = ethRemaining.div(scamPrice);
81         userTime[msg.sender] = now;
82         userScams[msg.sender] += scamsPurchased;
83         scamSupply += scamsPurchased;
84         availableBalance += ethRemaining;
85         uint256 newScamPrice = availableBalance.div(scamSupply).mul(2);
86         if (newScamPrice > scamPrice) {
87             scamPrice = newScamPrice;
88         }
89         scammerInChief.transfer(stupidTax);
90         greaterFools++;
91     }
92     
93     function sellScams(uint256 _scams) public relax wait {
94         require (userScams[msg.sender] > 0 && userScams[msg.sender] >= _scams);
95         uint256 scamProfit = _scams.mul(scamPrice);
96         require (scamProfit <= availableBalance);
97         scamSupply = scamSupply.sub(_scams);
98         availableBalance = availableBalance.sub(scamProfit);
99         userScams[msg.sender] = userScams[msg.sender].sub(_scams);
100         userBalance[msg.sender] += scamProfit;
101         userTime[msg.sender] = now;
102     }
103         
104     function withdrawScamEarnings() public relax {
105         require (userBalance[msg.sender] > 0);
106         uint256 balance = userBalance[msg.sender];
107         userBalance[msg.sender] = 0;
108         msg.sender.transfer(balance);
109     }
110 
111     function fastEscape() public relax {
112         uint256 scamProfit = userScams[msg.sender].mul(scamPrice);
113         if (scamProfit <= availableBalance) {
114             sellScams(userScams[msg.sender]);
115             withdrawScamEarnings();
116         } else {
117             uint256 maxScams = availableBalance.div(scamPrice);
118             assert (userScams[msg.sender] >= maxScams);
119             sellScams(maxScams);
120             withdrawScamEarnings();
121         }
122     }
123 
124     function drainMe() public relax {
125         require (availableBalance > 420);
126         uint256 notRandomNumber = uint256(blockhash(block.number - 1)) % 2;
127         if (notRandomNumber == 0) {
128             msg.sender.transfer(420);
129             availableBalance.sub(420);
130         } else {
131             msg.sender.transfer(69);
132             availableBalance.sub(69);
133         }
134     }
135 
136     function exitScam() public relax {
137         require (msg.sender == scammerInChief);
138         require (now >= countdownToExitScam);
139         selfdestruct(scammerInChief);
140     }
141     
142     function checkBalance() public view returns(uint256) {
143         return address(this).balance;
144     }
145 }
146 
147 library ScamMath {
148 
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         if (a == 0) { return 0; }
151         uint256 c = a * b;
152         assert(c / a == b);
153         return c;
154     }
155 
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a / b;
158         return c;
159     }
160 
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         assert(b <= a);
163         return a - b;
164     }
165 
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         assert(c >= a);
169         return c;
170     }
171 }