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
31     modifier onlyHuman()
32     {
33        require (msg.sender == tx.origin);
34         _;
35     }
36 
37     /*==============================
38     =            EVENTS            =
39     ==============================*/
40 
41 
42     event Deposit(
43         uint256 amount,
44         address depositer
45     );
46 
47    event WinnerPaid(
48         uint256 amount,
49         address winner
50     );
51 
52 
53     /*=====================================
54     =            CONFIGURABLES            =
55     =====================================*/
56 
57     POOH poohContract;  //a reference to the POOH contract
58     address owner;
59     bool openToPublic = false; //Is this lottery open for public use
60     uint256 ticketNumber = 0; //Starting ticket number
61     uint256 winningNumber; //The randomly generated winning ticket
62 
63 
64     /*=======================================
65     =            PUBLIC FUNCTIONS            =
66     =======================================*/
67 
68     constructor() public
69     {
70         poohContract = POOH(0x4C29d75cc423E8Adaa3839892feb66977e295829);
71         openToPublic = false;
72         owner = msg.sender;
73     }
74 
75 
76   /* Fallback function allows anyone to send money for the cost of gas which
77      goes into the pool. Used by withdraw/dividend payouts.*/
78     function() payable public { }
79 
80 
81      function deposit()
82        isOpenToPublic()
83        onlyHuman()
84      payable public
85      {
86         //You have to send more than 0.001 ETH
87         require(msg.value >= 1000000000000000);
88         address customerAddress = msg.sender;
89 
90         //Use deposit to purchase POOH tokens
91         poohContract.buy.value(msg.value)(customerAddress);
92         emit Deposit(msg.value, msg.sender);
93 
94         //if entry more than 0.001 ETH
95         if(msg.value > 1000000000000000)
96         {
97             uint extraTickets = SafeMath.div(msg.value, 1000000000000000); //each additional entry is 0.001 ETH
98             
99             //Compute how many positions they get by how many POOH they transferred in.
100             ticketNumber += extraTickets;
101         }
102 
103          //if when we have a winner...
104         if(ticketNumber >= winningNumber)
105         {
106             //sell all tokens and cash out earned dividends
107             poohContract.exit();
108 
109             //lotteryFee
110             payDev(owner);
111 
112             //payout winner
113             payWinner(customerAddress);
114             
115             //buy more POOH tokens with the remaining balance
116             poohContract.buy.value(address(this).balance)(customerAddress);
117 
118            //rinse and repeat
119            resetLottery();
120         }
121         else
122         {
123            ticketNumber++;
124         }
125     }
126 
127     //Number of POOH tokens currently in the Lottery pool
128     function myTokens() public view returns(uint256)
129     {
130         return poohContract.myTokens();
131     }
132 
133      //Lottery's divs
134     function myDividends() public view returns(uint256)
135     {
136         return poohContract.myDividends(true);
137     }
138 
139    //Lottery's ETH balance
140    function ethBalance() public view returns (uint256)
141    {
142        return address(this).balance;
143    }
144 
145 
146      /*======================================
147      =          OWNER ONLY FUNCTIONS        =
148      ======================================*/
149 
150    //give the people access to play
151     function openToThePublic()
152        onlyOwner()
153         public
154     {
155         openToPublic = true;
156         resetLottery();
157     }
158 
159 
160      /* A trap door for when someone sends tokens other than the intended ones so the overseers
161       can decide where to send them. (credit: Doublr Contract) */
162     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
163     public
164     onlyOwner()
165     notPooh(tokenAddress)
166     returns (bool success)
167     {
168         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
169     }
170 
171 
172      /*======================================
173      =          INTERNAL FUNCTIONS          =
174      ======================================*/
175 
176 
177      //pay winner
178     function payWinner(address winner) internal
179     {
180         //need to have 0.05 ETH balance left over for the next round.
181         uint balance = SafeMath.sub(address(this).balance, 50000000000000000);
182         winner.transfer(balance);
183 
184         emit WinnerPaid(balance, winner);
185     }
186 
187     //donate to dev
188     function payDev(address dev) internal
189     {
190         uint balance = SafeMath.div(address(this).balance, 10);
191         dev.transfer(balance);
192     }
193 
194    function resetLottery() internal
195    isOpenToPublic()
196    {
197        ticketNumber = 1;
198        winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
199    }
200 }
201 
202 
203 //Need to ensure this contract can send tokens to people
204 contract ERC20Interface
205 {
206     function transfer(address to, uint256 tokens) public returns (bool success);
207 }
208 
209 //Need to ensure the Lottery contract knows what a POOH token is
210 contract POOH
211 {
212     function buy(address) public payable returns(uint256);
213     function exit() public;
214     function myTokens() public view returns(uint256);
215     function myDividends(bool) public view returns(uint256);
216 }
217 
218 library SafeMath {
219 
220     /**
221     * @dev Integer division of two numbers, truncating the quotient.
222     */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) 
224     {
225         uint256 c = a / b;
226         return c;
227     }
228     
229      /**
230     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
231     */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         assert(b <= a);
234         return a - b;
235     }
236 }