1 pragma solidity ^0.4.24;
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
21         require(aContract != address(poohContract));
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
42    event WinnerPaid(
43         uint256 amount,
44         address winner
45     );
46 
47 
48     /*=====================================
49     =            CONFIGURABLES            =
50     =====================================*/
51 
52     POOH poohContract;  //a reference to the POOH contract
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
65         poohContract = POOH(0x4C29d75cc423E8Adaa3839892feb66977e295829);
66         openToPublic = false;
67         owner = msg.sender;
68     }
69 
70 
71   /* Fallback function allows anyone to send money for the cost of gas which
72      goes into the pool. Used by withdraw/dividend payouts.*/
73     function() payable public { }
74 
75 
76      function deposit()
77        isOpenToPublic()
78      payable public
79      {
80         //You have to send more than 0.01 ETH
81         require(msg.value >= 10000000000000000);
82         address customerAddress = msg.sender;
83 
84         //Use deposit to purchase POOH tokens
85         poohContract.buy.value(msg.value)(customerAddress);
86         emit Deposit(msg.value, msg.sender);
87 
88         //if entry more than 0.01 ETH
89         if(msg.value > 10000000000000000)
90         {
91             uint extraTickets = SafeMath.div(msg.value, 10000000000000000); //each additional entry is 0.01 ETH
92             
93             //Compute how many positions they get by how many POOH they transferred in.
94             ticketNumber += extraTickets;
95         }
96 
97          //if when we have a winner...
98         if(ticketNumber >= winningNumber)
99         {
100             //sell all tokens and cash out earned dividends
101             poohContract.exit();
102 
103             //lotteryFee
104             payDev(owner);
105 
106             //payout winner
107             payWinner(customerAddress);
108 
109            //rinse and repea
110            resetLottery();
111         }
112         else
113         {
114            ticketNumber++;
115         }
116     }
117 
118     //Number of POOH tokens currently in the Lottery pool
119     function myTokens() public view returns(uint256)
120     {
121         return poohContract.myTokens();
122     }
123 
124      //Lottery's divs
125     function myDividends() public view returns(uint256)
126     {
127         return poohContract.myDividends(true);
128     }
129 
130    //Lottery's ETH balance
131    function ethBalance() public view returns (uint256)
132    {
133        return address(this).balance;
134    }
135 
136 
137      /*======================================
138      =          OWNER ONLY FUNCTIONS        =
139      ======================================*/
140 
141    //give the people access to play
142     function openToThePublic()
143        onlyOwner()
144         public
145     {
146         openToPublic = true;
147         resetLottery();
148     }
149 
150 
151      /* A trap door for when someone sends tokens other than the intended ones so the overseers
152       can decide where to send them. (credit: Doublr Contract) */
153     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
154 
155     public
156     onlyOwner()
157     notPooh(tokenAddress)
158     returns (bool success)
159     {
160         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
161     }
162 
163 
164      /*======================================
165      =          INTERNAL FUNCTIONS          =
166      ======================================*/
167 
168 
169      //pay winner
170     function payWinner(address winner) internal
171     {
172         //need to have 0.05 ETH balance left over for the next round.
173         uint balance = SafeMath.sub(address(this).balance, 50000000000000000);
174         winner.transfer(balance);
175 
176         emit WinnerPaid(balance, winner);
177     }
178 
179     //donate to dev
180     function payDev(address dev) internal
181     {
182         uint balance = SafeMath.div(address(this).balance, 10);
183         dev.transfer(balance);
184     }
185 
186    function resetLottery() internal
187    isOpenToPublic()
188    {
189        ticketNumber = 1;
190        winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
191    }
192 }
193 
194 
195 //Need to ensure this contract can send tokens to people
196 contract ERC20Interface
197 {
198     function transfer(address to, uint256 tokens) public returns (bool success);
199 }
200 
201 //Need to ensure the Lottery contract knows what a POOH token is
202 contract POOH
203 {
204     function buy(address) public payable returns(uint256);
205     function exit() public;
206     function myTokens() public view returns(uint256);
207     function myDividends(bool) public view returns(uint256);
208 }
209 
210 library SafeMath {
211 
212     /**
213     * @dev Integer division of two numbers, truncating the quotient.
214     */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) 
216     {
217         uint256 c = a / b;
218         return c;
219     }
220     
221      /**
222     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
223     */
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         assert(b <= a);
226         return a - b;
227     }
228 }