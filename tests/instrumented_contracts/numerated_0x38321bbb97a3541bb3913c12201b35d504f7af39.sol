1 pragma solidity ^0.4.20;
2 
3  
4 
5 contract Lottery{
6 
7      /*=================================
8     =            MODIFIERS            =
9     =================================*/
10 
11    // Only owner allowed.
12     modifier onlyOwner()
13     {
14         require(msg.sender == owner);
15         _;
16     }
17 
18    // The tokens can never be stolen.
19     modifier notPooh(address aContract)
20     {
21         require(aContract != address(revContract));
22         _;
23     }
24 
25     modifier isOpenToPublic()
26     {
27         require(openToPublic);
28         _;
29     }
30 
31 
32     /*==============================
33     =            EVENTS            =
34     ==============================*/
35 
36 
37     event Deposit(
38         uint256 amount,
39         address depositer
40     );
41 
42     event WinnerPaid(
43         uint256 amount,
44         address winner
45     );
46 
47 
48     /*=====================================
49     =            CONFIGURABLES            =
50     =====================================*/
51 
52     REV revContract;  //a reference to the REV contract
53     address owner;
54     bool openToPublic = false; //Is this lottery open for public use
55     uint256 ticketNumber = 0; //Starting ticket number
56     uint256 winningNumber; //The randomly generated winning ticket
57 
58 
59     /*=======================================
60     =            PUBLIC FUNCTIONS            =
61     =======================================*/
62 
63     constructor() public
64     {
65         revContract = REV(0x05215FCE25902366480696F38C3093e31DBCE69A);
66         openToPublic = false;
67         owner = 0xc42559F88481e1Df90f64e5E9f7d7C6A34da5691;
68     }
69 
70 
71   /* Fallback function allows anyone to send money for the cost of gas which
72      goes into the pool. Used by withdraw/dividend payouts.*/
73     function() payable public { }
74 
75 
76     function deposit()
77        isOpenToPublic()
78      payable public
79      {
80         //You have to send more than 0.01 ETH
81         require(msg.value >= 10000000000000000);
82         address customerAddress = msg.sender;
83 
84         //Use deposit to purchase REV tokens
85         revContract.buy.value(msg.value)(customerAddress);
86         emit Deposit(msg.value, msg.sender);
87 
88         //if entry more than 0.01 ETH
89         if(msg.value > 10000000000000000)
90         {
91             uint extraTickets = SafeMath.div(msg.value, 10000000000000000); //each additional entry is 0.01 ETH
92             
93             //Compute how many positions they get by how many REV they transferred in.
94             ticketNumber += extraTickets;
95         }
96 
97          //if when we have a winner...
98         if(ticketNumber >= winningNumber)
99         {
100             //sell all tokens and cash out earned dividends
101             revContract.exit();
102 
103             //lotteryFee
104             payDev(owner);
105 
106             //payout winner
107             payWinner(customerAddress);
108 
109             //rinse and repea
110             resetLottery();
111         }
112         else
113         {
114             ticketNumber++;
115         }
116     }
117 
118     //Number of REV tokens currently in the Lottery pool
119     function myTokens() public view returns(uint256)
120     {
121         return revContract.myTokens();
122     }
123 
124 
125      //Lottery's divs
126     function myDividends() public view returns(uint256)
127     {
128         return revContract.myDividends(true);
129     }
130 
131    //Lottery's ETH balance
132     function ethBalance() public view returns (uint256)
133     {
134         return address(this).balance;
135     }
136 
137 
138      /*======================================
139      =          OWNER ONLY FUNCTIONS        =
140      ======================================*/
141 
142     //give the people access to play
143     function openToThePublic()
144        onlyOwner()
145         public
146     {
147         openToPublic = true;
148         resetLottery();
149     }
150 
151     //If this doesn't work as expected, cash out and send to owner to disperse ETH back to players
152     function emergencyStop()
153         onlyOwner()
154         public
155     {
156        // cash out token pool and send to owner to distribute back to players
157         revContract.exit();
158         uint balance = address(this).balance;
159         owner.transfer(balance);
160 
161         //make lottery closed to public
162         openToPublic = false;
163     }
164 
165 
166      /* A trap door for when someone sends tokens other than the intended ones so the overseers
167       can decide where to send them. (credit: Doublr Contract) */
168     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
169 
170     public
171     onlyOwner()
172     notPooh(tokenAddress)
173     returns (bool success)
174     {
175         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
176     }
177 
178 
179      /*======================================
180      =          INTERNAL FUNCTIONS          =
181      ======================================*/
182 
183 
184      //pay winner
185     function payWinner(address winner) internal
186     {
187         uint balance = address(this).balance;
188         winner.transfer(balance);
189 
190         emit WinnerPaid(balance, winner);
191     }
192 
193     //donate to dev
194     function payDev(address dev) internal
195     {
196         uint balance = SafeMath.div(address(this).balance, 10);
197         dev.transfer(balance);
198     }
199 
200     function resetLottery() internal
201     {
202         ticketNumber = 1;
203         winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
204     }
205 
206     function resetLotteryManually() public
207     onlyOwner()
208     {
209         ticketNumber = 1;
210         winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
211     }
212 
213 
214 }
215 
216 
217 //Need to ensure this contract can send tokens to people
218 contract ERC20Interface
219 {
220     function transfer(address to, uint256 tokens) public returns (bool success);
221 }
222 
223 //Need to ensure the Lottery contract knows what a REV token is
224 contract REV
225 {
226     function buy(address) public payable returns(uint256);
227     function exit() public;
228     function myTokens() public view returns(uint256);
229     function myDividends(bool) public view returns(uint256);
230 }
231 
232 library SafeMath {
233 
234     /**
235     * @dev Integer division of two numbers, truncating the quotient.
236     */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     // uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241         return a / b;
242     }
243 }