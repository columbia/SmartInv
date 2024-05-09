1 pragma solidity ^0.4.14;
2 
3 contract CicadaToken {
4     /* Public variables of the Cicada token. Not made by the "official" Cicada 3301... or is it? 
5         No, probably not, you're paranoid. Or am I? What if we're all Cicada? 
6         No, you're delusional.
7         This is insanity, or maybe it's genius?
8         
9         We barely could wait this moment...
10         
11         2+5+1=8
12         25*13=325
13         15,31,3301
14         sqrt(324)=18
15         360360/7=51480
16         360360/8=45045
17         2513/800=3.14125
18         0.2:17.1-2:48.1:3.0:
19         
20         2.192049988θ 5.58268339λ 9.7977693090G
21         2.247000175θ 2.981716939λ 9.800514797G
22         1.158788615θ 2.32884262λ 9.7862954650G
23         2.543813754θ 3.798403597λ 9.815386451G
24         0.9800521274θ 5.781580817λ 9.79624214G
25         
26         1089287209,1731065632,1293893558,2643986998,2760389337, 2760389337,3568826184,3178676277,2183895820,2543659070, 2543659070,2919791668,1361677804,3926934151,1617304876, 1617304876,1623817017,1840265213,3059753916,3495850100, 3495850100,2779122780,3703974151,1504463065,371931331, 371931331,2194531146,591366817,1289280794,1454640230, 1454640230,3751306772,286836652,82106479,1353632321, 1353632321,1978935931,129784666,2165612938,302519271, 302519271,667805565,2104503549,1748047881,3143345858, 3143345858,2567161908,844070088,3531551908,2467396602, 2467396602,1990243106,2313045040,1552967400,1873430530, 1873430530,3016683839,960906741,1721405341,3031535805, 3031535805,1955189866,3308308023,3408057436,1053761308, 1053761308,3325869169,293492001,3050005651,1449160016,3019723895, 1449160016,3019723895,631258258,1117748972,1360032086,4202359100, 1360032086,4202359100,1377521687,2916041631,3594610343,1283949744, 3594610343,1283949744,2813523239,834212454,1259726505,1418243105, 1259726505,1418243105,2398810229,3405631455,583373212,121296986, 583373212,121296986,889286024,2884948373,1074344036,2259419743, 1074344036,2259419743,3277259298,1174437393,2795777571,1562207636, 2795777571,1562207636,2171732791,2956478056,3787583060,1407756383, 3787583060,1407756383,1642154795,2704472112,2767934171,424994609, 2767934171,424994609,2202848543,736480564,3045833213,3005171440, 3045833213,3005171440,405401169,1469264431,1221013806,1778305550, 1221013806,1778305550,4149771067,2979449995,4288475081,483827587, 4288475081,483827587,1367887139,522769879,2923195508,154691999, 2923195508,154691999,1923517015,1216850072,162547509,1729425590, 162547509,1729425590,340416303,2759327460,
27         We ask this because We care about you
28         
29         clues4u
30         
31         Watch the website closely on August 21st, September 23rd, Novermber 11th and December 21st 2017 
32         .site/date should get you the tokens you look for if you're faster than the others on those dates.
33        
34         Once upon a time, I, Chuang Chou, dreamt I was a butterfly, 
35         fluttering hither and thither, to all intents and purposes a butterfly. 
36         I was conscious only of my happiness as a butterfly, unaware that I was Chou. 
37         Soon I awaked, and there I was, veritably myself again. 
38         Now I do not know whether I was then a man dreaming I was a butterfly, 
39         or whether I am now a butterfly, dreaming I am a man. 
40         Between a man and a butterfly there is necessarily a distinction. 
41         The transition is called the transformation of material things.*/
42     string public standard = 'Cicada 33.01';
43     string public name;
44     string public symbol;
45     uint8 public decimals;
46     uint256 public initialSupply;
47 
48     /* This creates an array with all balances */
49     mapping (address => uint256) public balanceOf;
50     mapping (address => mapping (address => uint256)) public allowance;
51 
52   
53     /* Initializes contract with initial supply tokens to the creator of the contract
54         Restate my assumptions: One, Mathematics is the language of nature. 
55         Two, Everything around us can be represented and understood through numbers. 
56         Three: If you graph the numbers of any system, patterns emerge. 
57         Therefore, there are patterns everywhere in nature. 
58         Evidence: The cycling of disease epidemics;the wax and wane of caribou populations; 
59         sun spot cycles; the rise and fall of the Nile. 
60         So, what about the crypto market? 
61         The universe of numbers that represents the global economy. 
62         Millions of hands at work, billions of minds. 
63         A vast network, screaming with life. An organism.
64         A natural organism. 
65         My hypothesis: Within the crypto market, there is a pattern as well... 
66         Right in front of me... hiding behind the numbers. Always has been.*/
67         
68     function CicadaToken() {
69 
70          initialSupply = 3301000000000;
71          name ="CICADA";
72          decimals = 9;
73          symbol = "3301";
74         
75         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
76         uint256 totalSupply = initialSupply;                // Update total supply
77                                    
78     }
79 
80     /* Send coins 
81     The Ancient Japanese considered the Go board to be a microcosm of the universe. 
82     Although when it is empty it appears to be simple and ordered, 
83     in fact, the possibilities of gameplay are endless. 
84     They say that no two Go games have ever been alike. Just like snowflakes. 
85     So, the Go board actually represents an extremely complex and chaotic universe.*/
86     
87     function transfer(address _to, uint256 _value) {
88         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
89         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
90         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
91         balanceOf[_to] += _value;                            // Add the same to the recipient
92       
93     }
94     
95     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a * b;
97     assert(a == 0 || c / a == b);
98     return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal constant returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106     }
107 
108     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
109     assert(b <= a);
110     return a - b;
111     }
112 
113     function add(uint256 a, uint256 b) internal constant returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117     }  
118 }