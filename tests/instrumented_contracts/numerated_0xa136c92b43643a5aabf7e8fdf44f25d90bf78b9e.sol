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
79       returns(bool startGame)
80      {
81         startGame = false;
82         uint256 tokensTransferred = getTokensPaidToGame(msg.sender);
83 
84         // When you transfer a token to the contract, there is a 1 coin difference until you enter the next if statement
85         if( tokensTransferred > paidPlayers[msg.sender]) //can't play if you don't pay
86         {
87             //check if player paid
88             paidPlayers[msg.sender] = tokensTransferred;
89             // pay dev fee
90             BITcontract.transfer(owner, 50000000000000000); //5% of 1 BIT
91             //start the game for the player
92             emit StartGame(msg.sender);
93 
94             return true;
95         }
96         else
97         {
98             revert();
99         }
100     }
101 
102     function BITBalanceOf(address someAddress) public view returns(uint256)
103     {
104         return BITcontract.balanceOf(someAddress);
105     }
106     
107     function getTokensPaidToGame(address customerAddress) public view returns (uint256)
108     {
109        return BITcontract.gamePlayers(address(this), customerAddress);
110     }
111 
112     function firstPlacePot() public view returns(uint256)
113     {
114        uint256 balance = BITBalanceOf(this);
115        return balance / 4;
116     }
117     
118     function secondPlacePot() public view returns(uint256)
119     {
120        uint256 balance = BITBalanceOf(this);
121        return (balance * 15)/ 100;
122     }
123     
124     function thirdPlacePot() public view returns(uint256)
125     {
126        uint256 balance = BITBalanceOf(this);
127        return balance / 10;
128     }
129 
130    
131 
132      /*======================================
133      =          OWNER ONLY FUNCTIONS        =
134      ======================================*/
135 
136    //give the people access to play
137     function openToThePublic()
138        onlyOwner()
139         public
140     {
141         openToPublic = true;
142     }
143 
144     //Pay tournament winners
145     function PayWinners(uint place, address winner) 
146     public 
147     isOpenToPublic()
148     onlyRealPeople() 
149     onlyOwner()
150     {
151         uint256 awardAmount = 0;
152        if(place == 1)
153        {
154            awardAmount = firstPlacePot();
155            BITcontract.transfer(winner, awardAmount);
156            
157        }
158        else if(place == 2 )
159        {
160             awardAmount = secondPlacePot();
161             BITcontract.transfer(winner, awardAmount);
162        }
163        else if(place ==3)
164        {
165             awardAmount = thirdPlacePot();
166             BITcontract.transfer(winner, awardAmount);
167        }
168       
169       emit WinnerPaid(awardAmount, winner);
170     }
171     
172     
173      /* A trap door for when someone sends tokens other than the intended ones so the overseers
174       can decide where to send them. (credit: Doublr Contract) */
175     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
176     public
177     onlyOwner()
178     notBIT(tokenAddress)
179     returns (bool success)
180     {
181         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
182     }
183 
184 }
185 
186 contract ERC20Interface
187 {
188     function transfer(address to, uint256 tokens) public returns (bool success);
189 }  
190 
191 //Need to ensure the Lottery contract knows what a test token is
192 contract BIT
193 {
194     function transfer(address, uint256) public returns(bool);
195     mapping(address => mapping(address => uint256)) public gamePlayers;
196     function balanceOf(address customerAddress) public view returns(uint256);
197 }