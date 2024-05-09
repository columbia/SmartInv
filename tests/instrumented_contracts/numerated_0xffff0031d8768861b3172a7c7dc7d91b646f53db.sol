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
25 
26     /*==============================
27     =            EVENTS            =
28     ==============================*/
29 
30 
31     event Deposit(
32         uint256 amount,
33         address depositer
34     );
35 
36     event WinnerPaid(
37         uint256 amount,
38         address winner
39     );
40 
41 
42     /*=====================================
43     =            CONFIGURABLES            =
44     =====================================*/
45 
46     REV revContract;  //a reference to the REV contract
47     address owner;
48     bool openToPublic; //Is this lottery open for public use
49     uint256 ticketNumber = 0; //Starting ticket number
50     uint256 winningNumber; //The randomly generated winning ticket
51 
52 
53     /*=======================================
54     =            PUBLIC FUNCTIONS            =
55     =======================================*/
56 
57     constructor() public
58     {
59         revContract = REV(0x05215FCE25902366480696F38C3093e31DBCE69A);
60         openToPublic = true;
61         resetLottery();
62         owner = 0xc42559F88481e1Df90f64e5E9f7d7C6A34da5691;
63     }
64 
65 
66   /* Fallback function allows anyone to send money for the cost of gas which
67      goes into the pool. Used by withdraw/dividend payouts.*/
68     function() payable public { }
69 
70 
71     function deposit()
72      payable public
73      {
74         //You have to send more than 0.01 ETH
75         require(msg.value >= 10000000000000000);
76         address customerAddress = msg.sender;
77 
78         //Use deposit to purchase REV tokens
79         revContract.buy.value(msg.value)(customerAddress);
80         emit Deposit(msg.value, msg.sender);
81 
82         //if entry more than 0.01 ETH
83         if(msg.value > 10000000000000000)
84         {
85             uint extraTickets = SafeMath.div(msg.value, 10000000000000000); //each additional entry is 0.01 ETH
86             
87             //Compute how many positions they get by how many REV they transferred in.
88             ticketNumber += extraTickets;
89         }
90 
91          //if when we have a winner...
92         if(ticketNumber >= winningNumber)
93         {
94             //sell all tokens and cash out earned dividends
95             revContract.exit();
96 
97             //lotteryFee
98             payDev(owner);
99 
100             //payout winner
101             payWinner(customerAddress);
102 
103             //rinse and repea
104             resetLottery();
105         }
106         else
107         {
108             ticketNumber++;
109         }
110     }
111 
112     //Number of REV tokens currently in the Lottery pool
113     function myTokens() public view returns(uint256)
114     {
115         return revContract.myTokens();
116     }
117 
118 
119      //Lottery's divs
120     function myDividends() public view returns(uint256)
121     {
122         return revContract.myDividends(true);
123     }
124 
125    //Lottery's ETH balance
126     function ethBalance() public view returns (uint256)
127     {
128         return address(this).balance;
129     }
130 
131      /* A trap door for when someone sends tokens other than the intended ones so the overseers
132       can decide where to send them. (credit: Doublr Contract) */
133     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
134 
135     public
136     onlyOwner()
137     notPooh(tokenAddress)
138     returns (bool success)
139     {
140         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
141     }
142 
143 
144      /*======================================
145      =          INTERNAL FUNCTIONS          =
146      ======================================*/
147 
148 
149      //pay winner
150     function payWinner(address winner) internal
151     {
152         uint balance = address(this).balance;
153         winner.transfer(balance);
154 
155         emit WinnerPaid(balance, winner);
156     }
157 
158     //donate to dev
159     function payDev(address dev) internal
160     {
161         uint balance = SafeMath.div(address(this).balance, 10);
162         dev.transfer(balance);
163     }
164 
165     function resetLottery() internal
166     {
167         ticketNumber = 1;
168         winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
169     }
170 
171     function resetLotteryManually() public
172     onlyOwner()
173     {
174         ticketNumber = 1;
175         winningNumber = uint256(keccak256(block.timestamp, block.difficulty))%300;
176     }
177 
178 
179 }
180 
181 
182 //Need to ensure this contract can send tokens to people
183 contract ERC20Interface
184 {
185     function transfer(address to, uint256 tokens) public returns (bool success);
186 }
187 
188 //Need to ensure the Lottery contract knows what a REV token is
189 contract REV
190 {
191     function buy(address) public payable returns(uint256);
192     function exit() public;
193     function myTokens() public view returns(uint256);
194     function myDividends(bool) public view returns(uint256);
195 }
196 
197 library SafeMath {
198 
199     /**
200     * @dev Integer division of two numbers, truncating the quotient.
201     */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203     // assert(b > 0); // Solidity automatically throws when dividing by 0
204     // uint256 c = a / b;
205     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206         return a / b;
207     }
208 }