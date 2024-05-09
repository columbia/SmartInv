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
128         //log the wager and timestamp(block number)
129         timestamps[msg.sender] = block.number;
130         wagers[msg.sender] = msg.value;
131         emit Wager(msg.value, msg.sender);
132     }
133     
134     /**
135      * method to determine winners and losers
136      */
137     function play()
138     isOpenToPublic()
139     onlyRealPeople()
140     onlyPlayers()
141     public
142     {
143         uint256 blockNumber = timestamps[msg.sender];
144         if(blockNumber < block.number)
145         {
146             timestamps[msg.sender] = 0;
147             wagers[msg.sender] = 0;
148     
149             uint256 winningNumber = uint256(keccak256(abi.encodePacked(blockhash(blockNumber),  msg.sender)))%difficulty +1;
150     
151             if(winningNumber == difficulty / 2)
152             {
153                 payout(msg.sender);
154             }
155             else 
156             {
157                 //player loses
158                 loseWager(betLimit / 2);
159             }    
160         }
161         else
162         {
163             revert();
164         }
165     }
166 
167     /**
168      * For those that just want to donate to the whale
169      */
170     function donate()
171     isOpenToPublic()
172     public 
173     payable
174     {
175         donateToWhale(msg.value);
176     }
177 
178     /**
179      * Payout ETH to winner
180      */
181     function payout(address winner) 
182     internal 
183     {
184         uint256 ethToTransfer = address(this).balance / 2;
185         
186         winner.transfer(ethToTransfer);
187         emit Win(ethToTransfer, winner);
188     }
189 
190     /**
191      * Payout ETH to whale
192      */
193     function donateToWhale(uint256 amount) 
194     internal 
195     {
196         whale.call.value(amount)(bytes4(keccak256("donate()")));
197         totalDonated += amount;
198         emit Donate(amount, whale, msg.sender);
199     }
200 
201     /**
202      * Payout ETH to whale when player loses
203      */
204     function loseWager(uint256 amount) 
205     internal 
206     {
207         whale.call.value(amount)(bytes4(keccak256("donate()")));
208         totalDonated += amount;
209         emit Lose(amount, msg.sender);
210     }
211     
212 
213     /**
214      * ETH balance of contract
215      */
216     function ethBalance() 
217     public 
218     view 
219     returns (uint256)
220     {
221         return address(this).balance;
222     }
223     
224     
225     /**
226      * current difficulty of the game
227      */
228     function currentDifficulty() 
229     public 
230     view 
231     returns (uint256)
232     {
233         return difficulty;
234     }
235     
236     
237     /**
238      * current bet amount for the game
239      */
240     function currentBetLimit() 
241     public 
242     view 
243     returns (uint256)
244     {
245         return betLimit;
246     }
247     
248     function hasPlayerWagered(address player)
249     public 
250     view 
251     returns (bool)
252     {
253         if(wagers[player] > 0)
254         {
255             return true;
256         }
257         else
258         {
259             return false;
260         }
261         
262     }
263 
264     /**
265      * For the UI to properly display the winner's pot
266      */
267     function winnersPot() 
268     public 
269     view 
270     returns (uint256)
271     {
272         return address(this).balance / 2;
273     }
274 
275     /**
276      * A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
277      */
278     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) 
279     public 
280     onlyOwner() 
281     returns (bool success) 
282     {
283         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
284     }
285 }
286 
287 //Define ERC20Interface.transfer, so PoCWHALE can transfer tokens accidently sent to it.
288 contract ERC20Interface 
289 {
290     function transfer(address to, uint256 tokens) public returns (bool success);
291 }