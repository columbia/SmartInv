1 contract Roulette {
2     
3     // Global variables
4     string sWelcome;
5     /* Remark: 
6      *  Private Seed for generateRand(), 
7      *  since this is nowhere visibile, 
8      *  it's very hard to guess.
9      */
10     uint privSeed; 
11     struct Casino {
12         address addr;
13         uint balance;
14         uint bettingLimitMin;
15         uint bettingLimitMax;
16     }
17     Casino casino;
18 
19     // Init Constructor
20     function Roulette() {
21         sWelcome = "\n-----------------------------\n     Welcome to Roulette \n Got coins? Then come on in! \n-----------------------------\n";
22         privSeed = 1;
23         casino.addr = msg.sender;
24         casino.balance = 0;
25         casino.bettingLimitMin = 1*10**18;
26         casino.bettingLimitMax = 10*10**18;
27     }
28     
29     function welcome() constant returns (string) {
30         return sWelcome;
31     }
32     function casinoBalance() constant returns (uint) {
33         return casino.balance;
34     }
35     function casinoDeposit() {
36         if (msg.sender == casino.addr)
37             casino.balance += msg.value;
38         else 
39             msg.sender.send(msg.value);
40     }
41     function casinoWithdraw(uint amount) {
42         if (msg.sender == casino.addr && amount <= casino.balance) {
43             casino.balance -= amount;
44             casino.addr.send(amount);
45         }
46     }
47     
48     // Bet on Number
49     function betOnNumber(uint number) public returns (string) {
50         // Input Handling
51         address addr = msg.sender;
52         uint betSize = msg.value;
53         if (betSize < casino.bettingLimitMin || betSize > casino.bettingLimitMax) {
54             // Return Funds
55             if (betSize >= 1*10**18)
56                 addr.send(betSize);
57             return "Please choose an amount within between 1 and 10 ETH";
58         }
59         if (betSize * 36 > casino.balance) {
60             // Return Funds
61             addr.send(betSize);
62             return "Casino has insufficient funds for this bet amount";
63         }
64         if (number < 0 || number > 36) {
65             // Return Funds
66             addr.send(betSize);
67             return "Please choose a number between 0 and 36";
68         }
69         // Roll the wheel
70         privSeed += 1;
71         uint rand = generateRand();
72         if (number == rand) {
73             // Winner winner chicken dinner!
74             uint winAmount = betSize * 36;
75             casino.balance -= (winAmount - betSize);
76             addr.send(winAmount);
77             return "Winner winner chicken dinner!";
78         }
79         else {
80             casino.balance += betSize;
81             return "Wrong number.";
82         }
83     }
84     
85     // Bet on Color
86     function betOnColor(uint color) public returns (string) {
87         // Input Handling
88         address addr = msg.sender;
89         uint betSize = msg.value;
90         if (betSize < casino.bettingLimitMin || betSize > casino.bettingLimitMax) {
91             // Return Funds
92             if (betSize >= 1*10**18)
93                 addr.send(betSize);
94             return "Please choose an amount within between 1 and 10 ETH";
95         }
96         if (betSize * 2 > casino.balance) {
97             // Return Funds
98             addr.send(betSize);
99             return "Casino has insufficient funds for this bet amount";
100         }
101         if (color != 0 && color != 1) {
102             // Return Funds
103             addr.send(betSize);
104             return "Please choose either '0' = red or '1' = black as a color";
105         }
106         // Roll the wheel
107         privSeed += 1;
108         uint rand = generateRand();
109         uint randC = (rand + 1) % 2;
110         // Win
111         if (rand != 0 && (randC == color)) {
112             uint winAmount = betSize * 2;
113             casino.balance -= (winAmount - betSize);
114             addr.send(winAmount);
115             return "Win! Good job.";
116         }
117         else {
118             casino.balance += betSize;
119             return "Wrong color.";           
120         }
121     }
122     
123     // Returns a pseudo Random number.
124     function generateRand() private returns (uint) { 
125         // Seeds
126         privSeed = (privSeed*3 + 1) / 2;
127         privSeed = privSeed % 10**9;
128         uint number = block.number; // ~ 10**5 ; 60000
129         uint diff = block.difficulty; // ~ 2 Tera = 2*10**12; 1731430114620
130         uint time = block.timestamp; // ~ 2 Giga = 2*10**9; 1439147273
131         uint gas = block.gaslimit; // ~ 3 Mega = 3*10**6
132         // Rand Number in Percent
133         uint total = privSeed + number + diff + time + gas;
134         uint rand = total % 37;
135         return rand;
136     }
137 
138     // Function to recover the funds on the contract
139     function kill() {
140         if (msg.sender == casino.addr) 
141             suicide(casino.addr);
142     }
143 }