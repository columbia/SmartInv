1 pragma solidity ^0.4.21;
2 
3 
4 contract Owned {
5      address public owner;
6     address public newOwner;
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Owned() {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         if (msg.sender != owner) throw;
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) onlyOwner {
19         newOwner = _newOwner;
20     }
21  
22     function acceptOwnership() {
23         if (msg.sender == newOwner) {
24             OwnershipTransferred(owner, newOwner);
25             owner = newOwner;
26         }
27     }
28     
29 }
30 
31 
32 contract EthExploder is Owned { 
33     uint256 public jackpotSmall;
34     uint256 public jackpotMedium; 
35     uint256 public jackpotLarge; 
36     
37     uint256 public houseEarnings; 
38     uint256 public houseTotal; 
39     
40     uint256 public gameCount; 
41     
42     uint16 public smallCount; 
43     uint16 public mediumCount; 
44     uint16 public largeCount; 
45     
46     uint16 public smallSize; 
47     uint16 public mediumSize;
48     uint16 public largeSize; 
49     
50     uint256 public seed; 
51     
52     mapping (uint16 => address) playersSmall; 
53     mapping (uint16 => address) playersMedium; 
54     mapping (uint16 => address) playersLarge; 
55     
56     function enterSmall() payable {
57         require(msg.value > 0);
58         
59         jackpotSmall += msg.value; 
60         playersSmall[smallCount] = msg.sender; 
61         seed += uint256(msg.sender);
62         
63         if (smallCount < smallSize-1) { 
64             smallCount++;
65         } else { 
66             seed += gameCount + mediumCount + largeCount;
67             houseEarnings += (jackpotSmall*3)/100;
68             jackpotSmall -= (jackpotSmall*3)/100;
69             
70             uint16 winner = uint16(seed % smallSize); 
71             address winning = playersSmall[winner]; 
72            
73             
74             //Reset the game: 
75             smallCount = 0; 
76             uint256 amt = jackpotSmall;
77             jackpotSmall = 0; 
78             winning.transfer(amt);
79             gameCount++;
80             emit GameWon(0,winning,amt); 
81         }
82     }
83     
84     function enterMedium() payable { 
85         require(msg.value > 0); 
86         
87         jackpotMedium += msg.value; 
88         playersMedium[mediumCount] = msg.sender; 
89         seed += uint256(msg.sender);
90          
91         if (mediumCount < mediumSize-1) { 
92             mediumCount++;
93         } else { 
94             seed += gameCount + smallCount + largeCount;
95             houseEarnings += (jackpotMedium*3)/100;
96             jackpotMedium -= (jackpotMedium*3)/100;
97             
98             uint16 winner = uint16(seed % mediumSize); 
99             address winning = playersMedium[winner];
100             //winning.transfer(jackpotMedium); 
101             
102             //Reset the game 
103             mediumCount = 0; 
104             uint256 amt = jackpotMedium;
105             jackpotMedium = 0; 
106             winning.transfer(amt);
107             gameCount++;
108             emit GameWon(1,winning,amt); 
109 
110         }
111     }
112     
113     function enterLarge() payable { 
114         require(msg.value > 0); 
115         
116         jackpotLarge += msg.value; 
117         playersLarge[largeCount] = msg.sender; 
118         seed += uint256(msg.sender);
119         
120         if (largeCount < largeSize-1) { 
121             largeCount++; 
122         } else { 
123             seed += gameCount + mediumCount + largeCount; 
124             houseEarnings += (jackpotLarge*3)/100;
125             jackpotLarge -= (jackpotLarge*3)/100;
126             
127             uint16 winner = uint16(seed % largeSize); 
128             address winning = playersLarge[winner];
129             
130             //Reset the game 
131             largeCount = 0; 
132             uint256 amt = jackpotLarge;
133             jackpotLarge = 0; 
134             winning.transfer(amt);
135             gameCount++;
136             emit GameWon(2,winning,amt); 
137 
138         }
139         
140     }
141     
142     function setPools(uint16 sm, uint16 med, uint16 lrg) onlyOwner { 
143         smallSize = sm; 
144         mediumSize = med; 
145         largeSize = lrg; 
146     }
147     
148     function claim(address payment) onlyOwner { 
149         payment.transfer(houseEarnings); 
150         houseTotal += houseEarnings; 
151         houseEarnings = 0; 
152     }
153     
154     //Prevent accidental ether sending 
155     function () payable { 
156      revert(); 
157  }
158 
159  event GameWon(uint8 gameType, address winner, uint256 winnings); 
160     
161 }