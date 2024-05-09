1 pragma solidity ^0.4.21;
2 
3 
4 
5 
6 
7 
8 contract PoCGame
9 {
10     
11     /**
12      * Modifiers
13      */
14      
15     modifier onlyOwner()
16     {
17         require(msg.sender == owner);
18         _;
19     }
20     
21    modifier isOpenToPublic()
22     {
23         require(openToPublic);
24         _;
25     }
26 
27     modifier onlyRealPeople()
28     {
29           require (msg.sender == tx.origin);
30         _;
31     }
32 
33     modifier  onlyPlayers()
34     { 
35         require (wagers[msg.sender] > 0); 
36         _; 
37     }
38     
39    
40     /**
41      * Events
42      */
43     event Wager(uint256 amount, address depositer);
44     event Win(uint256 amount, address paidTo);
45     event Lose(uint256 amount, address loser);
46     event Donate(uint256 amount, address paidTo, address donator);
47     event DifficultyChanged(uint256 currentDifficulty);
48     event BetLimitChanged(uint256 currentBetLimit);
49 
50     /**
51      * Global Variables
52      */
53     address private whale;
54     uint256 betLimit;
55     uint difficulty;
56     uint private randomSeed;
57     address owner;
58     mapping(address => uint256) timestamps;
59     mapping(address => uint256) wagers;
60     bool openToPublic;
61     uint256 totalDonated;
62 
63     /**
64      * Constructor
65      */
66     constructor(address whaleAddress, uint256 wagerLimit) 
67     onlyRealPeople()
68     public 
69     {
70         openToPublic = false;
71         owner = msg.sender;
72         whale = whaleAddress;
73         totalDonated = 0;
74         betLimit = wagerLimit;
75         
76     }
77 
78 
79     /**
80      * Let the public play
81      */
82     function OpenToThePublic() 
83     onlyOwner()
84     public
85     {
86         openToPublic = true;
87     }
88     
89     /**
90      * Adjust the bet amounts
91      */
92     function AdjustBetAmounts(uint256 amount) 
93     onlyOwner()
94     public
95     {
96         betLimit = amount;
97         
98         emit BetLimitChanged(betLimit);
99     }
100     
101      /**
102      * Adjust the difficulty
103      */
104     function AdjustDifficulty(uint256 amount) 
105     onlyOwner()
106     public
107     {
108         difficulty = amount;
109         
110         emit DifficultyChanged(difficulty);
111     }
112     
113     
114     function() public payable { }
115 
116     /**
117      * Wager your bet
118      */
119     function wager()
120     isOpenToPublic()
121     onlyRealPeople() 
122     payable
123     public 
124     {
125         //You have to send exactly 0.01 ETH.
126         require(msg.value == betLimit);
127         
128         //You cannot wager multiple times
129         require(wagers[msg.sender] == 0);
130 
131         //log the wager and timestamp(block number)
132         timestamps[msg.sender] = block.number;
133         wagers[msg.sender] = msg.value;
134         emit Wager(msg.value, msg.sender);
135     }
136     
137     /**
138      * method to determine winners and losers
139      */
140     function play()
141     isOpenToPublic()
142     onlyRealPeople()
143     onlyPlayers()
144     public
145     {
146         uint256 blockNumber = timestamps[msg.sender];
147         if(blockNumber < block.number)
148         {
149             timestamps[msg.sender] = 0;
150             wagers[msg.sender] = 0;
151     
152             uint256 winningNumber = uint256(keccak256(abi.encodePacked(blockhash(blockNumber),  msg.sender)))%difficulty +1;
153     
154             if(winningNumber == difficulty / 2)
155             {
156                 payout(msg.sender);
157             }
158             else 
159             {
160                 //player loses
161                 loseWager(betLimit / 2);
162             }    
163         }
164         else
165         {
166             revert();
167         }
168     }
169 
170     /**
171      * For those that just want to donate to the whale
172      */
173     function donate()
174     isOpenToPublic()
175     public 
176     payable
177     {
178         donateToWhale(msg.value);
179     }
180 
181     /**
182      * Payout ETH to winner
183      */
184     function payout(address winner) 
185     internal 
186     {
187         uint256 ethToTransfer = address(this).balance / 2;
188         
189         winner.transfer(ethToTransfer);
190         emit Win(ethToTransfer, winner);
191     }
192 
193     /**
194      * Payout ETH to whale
195      */
196     function donateToWhale(uint256 amount) 
197     internal 
198     {
199         whale.call.value(amount)(bytes4(keccak256("donate()")));
200         totalDonated += amount;
201         emit Donate(amount, whale, msg.sender);
202     }
203 
204     /**
205      * Payout ETH to whale when player loses
206      */
207     function loseWager(uint256 amount) 
208     internal 
209     {
210         whale.call.value(amount)(bytes4(keccak256("donate()")));
211         totalDonated += amount;
212         emit Lose(amount, msg.sender);
213     }
214     
215 
216     /**
217      * ETH balance of contract
218      */
219     function ethBalance() 
220     public 
221     view 
222     returns (uint256)
223     {
224         return address(this).balance;
225     }
226     
227     
228     /**
229      * current difficulty of the game
230      */
231     function currentDifficulty() 
232     public 
233     view 
234     returns (uint256)
235     {
236         return difficulty;
237     }
238     
239     
240     /**
241      * current bet amount for the game
242      */
243     function currentBetLimit() 
244     public 
245     view 
246     returns (uint256)
247     {
248         return betLimit;
249     }
250     
251     function hasPlayerWagered(address player)
252     public 
253     view 
254     returns (bool)
255     {
256         if(wagers[player] > 0)
257         {
258             return true;
259         }
260         else
261         {
262             return false;
263         }
264         
265     }
266 
267     /**
268      * For the UI to properly display the winner's pot
269      */
270     function winnersPot() 
271     public 
272     view 
273     returns (uint256)
274     {
275         return address(this).balance / 2;
276     }
277 
278     /**
279      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
280      */
281     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) 
282     public 
283     onlyOwner() 
284     returns (bool success) 
285     {
286         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
287     }
288 }
289 
290 //Define ERC20Interface.transfer, so PoCWHALE can transfer tokens accidently sent to it.
291 contract ERC20Interface 
292 {
293     function transfer(address to, uint256 tokens) public returns (bool success);
294 }