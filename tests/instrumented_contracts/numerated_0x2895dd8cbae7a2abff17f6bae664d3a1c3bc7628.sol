1 pragma solidity ^0.4.24;
2 
3  
4 
5 contract Kman{
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
19     modifier notBIT(address aContract)
20     {
21         require(aContract != address(BITcontract));
22         _;
23     } 
24 
25     modifier isOpenToPublic()
26     {
27         require(openToPublic);
28         _;
29     }
30 
31     modifier onlyRealPeople()
32     {
33           require (msg.sender == tx.origin);
34         _;
35     }
36     
37     
38     /*==============================
39     =            EVENTS            =
40     ==============================*/
41 
42 
43    event WinnerPaid
44    (
45         uint256 amount,
46         address winner
47     );
48     
49     event StartGame
50     (
51         address player
52     );
53 
54     /*=====================================
55     =            CONFIGURABLES            =
56     =====================================*/
57 
58     BIT BITcontract;  //a reference to the 8thereum contract
59     address owner;
60     bool openToPublic = false; 
61     mapping(address => uint256) paidPlayers;
62 
63 
64     /*=======================================
65     =            PUBLIC FUNCTIONS            =
66     =======================================*/
67 
68     constructor() public
69     {
70         BITcontract = BIT(0x645f0c9695F2B970E623aE29538FdB1A67bd6b6E); //8thereum contract
71         openToPublic = false;
72         owner = msg.sender;
73     }
74 
75      function start()
76        isOpenToPublic()
77        onlyRealPeople()
78       public
79      {
80        
81         uint256 tokensTransferred = getTokensPaidToGame(msg.sender);
82 
83         // When you transfer a token to the contract, there is a 1 coin difference until you enter the next if statement
84         if( tokensTransferred > paidPlayers[msg.sender]) //can't play if you don't pay
85         {
86             //check if player paid
87             paidPlayers[msg.sender] = tokensTransferred;
88             // pay dev fee
89             BITcontract.transfer(owner, 50000000000000000); //5% of 1 BIT
90             //start the game for the player
91             emit StartGame(msg.sender);
92         }
93         else
94         {
95             revert();
96         }
97     }
98 
99     function BITBalanceOf(address someAddress) public view returns(uint256)
100     {
101         return BITcontract.balanceOf(someAddress);
102     }
103     
104     function getTokensPaidToGame(address customerAddress) public view returns (uint256)
105     {
106        return BITcontract.gamePlayers(address(this), customerAddress);
107     }
108 
109     function firstPlacePot() public view returns(uint256)
110     {
111        uint256 balance = BITBalanceOf(this);
112        return balance / 4;
113     }
114     
115     function secondPlacePot() public view returns(uint256)
116     {
117        uint256 balance = BITBalanceOf(this);
118        return (balance * 15)/ 100;
119     }
120     
121     function thirdPlacePot() public view returns(uint256)
122     {
123        uint256 balance = BITBalanceOf(this);
124        return balance / 10;
125     }
126 
127    
128 
129      /*======================================
130      =          OWNER ONLY FUNCTIONS        =
131      ======================================*/
132 
133    //give the people access to play
134     function openToThePublic()
135        onlyOwner()
136         public
137     {
138         openToPublic = true;
139     }
140 
141     //Pay tournament winners
142     function PayWinners(uint place, address winner) 
143     public 
144     isOpenToPublic()
145     onlyRealPeople() 
146     onlyOwner()
147     {
148         uint256 awardAmount = 0;
149        if(place == 1)
150        {
151            awardAmount = firstPlacePot();
152            BITcontract.transfer(winner, awardAmount);
153            
154        }
155        else if(place == 2 )
156        {
157             awardAmount = secondPlacePot();
158             BITcontract.transfer(winner, awardAmount);
159        }
160        else if(place ==3)
161        {
162             awardAmount = thirdPlacePot();
163             BITcontract.transfer(winner, awardAmount);
164        }
165       
166       emit WinnerPaid(awardAmount, winner);
167     }
168     
169     
170      /* A trap door for when someone sends tokens other than the intended ones so the overseers
171       can decide where to send them. (credit: Doublr Contract) */
172     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
173     public
174     onlyOwner()
175     notBIT(tokenAddress)
176     returns (bool success)
177     {
178         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
179     }
180 
181 }
182 
183 contract ERC20Interface
184 {
185     function transfer(address to, uint256 tokens) public returns (bool success);
186 }  
187 
188 //Need to ensure the Lottery contract knows what a test token is
189 contract BIT
190 {
191     function transfer(address, uint256) public returns(bool);
192     mapping(address => mapping(address => uint256)) public gamePlayers;
193     function balanceOf(address customerAddress) public view returns(uint256);
194 }