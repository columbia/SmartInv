1 pragma solidity ^0.4.18;
2 
3 contract WorldBetToken {
4     /* Token name */
5     string public name = "World Bet Lottery Tickets";
6 
7     /* Token Symbol */
8     string public symbol = "WBT";
9 
10     /* Token digit*/
11     uint public decimals = 0;
12 
13     mapping(uint => uint) private userBalanceOf;                // user total amount of tickets
14     bool public stopped = false;
15 
16     /* User*/
17     struct Country {
18         uint user; // country sequence id
19         uint balance; // total amount of bought tickets for this country
20     }
21 
22     // installed when one country has won
23     uint public WINNER_COUNTRY_CODE = 0;
24 
25     mapping(uint => bool) private countryIsPlaying;
26 
27     /* Countries->Users*/
28     mapping(uint => Country[]) public users;       // countries
29 
30 
31     /* Countries->Users*/
32     mapping(uint => uint[]) public countries;       // countries
33 
34     /* Jackpot Users*/
35     uint[] public jackpotUsers;
36 
37     /* Jackpot Users*/
38     uint[] activeCountries;
39 
40     /* Jackpot Eligibility*/
41     mapping(uint => bool) isJackpotEligible;
42 
43     /* Jackpot Location*/
44     mapping(uint => uint) jackpotLocation;
45 
46     // JACKPOT WINNER
47     uint public JACKPOT_WINNER = 0;
48 
49     uint jackpotMaxCap = 100;
50 
51     uint public totalSupply = 0;
52 
53     address owner = 0x0;
54 
55     modifier isOwner {
56         assert(owner == msg.sender);
57         _;
58     }
59 
60     modifier isRunning {
61         assert(!stopped);
62         _;
63     }
64 
65     modifier valAddress {
66         assert(0x0 != msg.sender);
67         _;
68     }
69 
70     function WorldBetToken() public {
71         owner = msg.sender;
72         countryIsPlaying[1] = true;
73         // Argentina
74         countryIsPlaying[2] = true;
75         // Australia
76         countryIsPlaying[3] = true;
77         // Belgium
78         countryIsPlaying[4] = true;
79         // Brazil
80         countryIsPlaying[5] = true;
81         // Colombia
82         countryIsPlaying[6] = true;
83         // Costa Rica
84         countryIsPlaying[7] = true;
85         // Croatia
86         countryIsPlaying[8] = true;
87         // Denmark
88         countryIsPlaying[9] = true;
89         // Egypt
90         countryIsPlaying[10] = true;
91         // England
92         countryIsPlaying[11] = true;
93         // France
94         countryIsPlaying[12] = true;
95         // Germany
96         countryIsPlaying[13] = true;
97         // Iceland
98         countryIsPlaying[14] = true;
99         // Iran
100         countryIsPlaying[15] = true;
101         // Japan
102         countryIsPlaying[16] = true;
103         // Mexico
104         countryIsPlaying[17] = true;
105         // Morocco
106         countryIsPlaying[18] = true;
107         // Nigeria
108         countryIsPlaying[19] = true;
109         // Panama
110         countryIsPlaying[20] = true;
111         // Peru
112         countryIsPlaying[21] = true;
113         // Poland
114         countryIsPlaying[22] = true;
115         // Portugal
116         countryIsPlaying[23] = true;
117         // Russia
118         countryIsPlaying[24] = true;
119         // Saudi Arabia
120         countryIsPlaying[25] = true;
121         // Senegal
122         countryIsPlaying[26] = true;
123         // Serbia
124         countryIsPlaying[27] = true;
125         // South Korea
126         countryIsPlaying[28] = true;
127         // Spain
128         countryIsPlaying[29] = true;
129         // Sweden
130         countryIsPlaying[30] = true;
131         // Switzerland
132         countryIsPlaying[31] = true;
133         // Tunisia
134         countryIsPlaying[32] = true;
135         // Uruguay
136     }
137 
138     function giveBalance(uint country, uint user, uint value) public isRunning returns (bool success) {
139         require(countryIsPlaying[country]);
140         require(WINNER_COUNTRY_CODE == 0);
141 
142 
143         // add user total amount of tickets
144         userBalanceOf[user] += value;
145 
146 
147         countries[country].push(user);
148 
149         users[user].push(Country(user, value));
150 
151         if (userBalanceOf[user] >= jackpotMaxCap && !isJackpotEligible[user]) {
152             jackpotUsers.push(user);
153             jackpotLocation[user] = jackpotUsers.length - 1;
154         }
155 
156         // increase totalSupply
157         totalSupply += value;
158 
159         // fire transfer event
160         Transfer(0x0, user, value);
161         return true;
162     }
163 
164     function installWinner(uint country) public {
165         require(WINNER_COUNTRY_CODE == 0);
166         require(countryIsPlaying[country]);
167         WINNER_COUNTRY_CODE = country;
168         WinnerInstalled(WINNER_COUNTRY_CODE);
169     }
170 
171     function removeCountry(uint country) public {
172         countryIsPlaying[country] = false;
173         CountryRemoved(country);
174     }
175 
176     function playJackpot() public {
177         require(JACKPOT_WINNER == 0);
178         if (jackpotUsers.length >= 2) {
179             uint nonce = jackpotUsers.length;
180             uint max = jackpotUsers.length - 1;
181             uint randomNumber = uint(keccak256(nonce)) % max;
182             JACKPOT_WINNER = jackpotUsers[randomNumber];
183         } else {
184             JACKPOT_WINNER = jackpotUsers[0];
185         }
186     }
187 
188     function winnerList() view public returns (uint[]){
189         return countries[WINNER_COUNTRY_CODE];
190     }
191 
192     event Transfer(address indexed _from, uint indexed _to, uint _value);
193     event CountryRemoved(uint indexed country);
194     event WinnerInstalled(uint indexed country);
195 }