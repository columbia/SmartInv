1 pragma solidity ^0.4.24;
2 
3  
4 
5 contract Potions{
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
43    event WinnerPaid(
44         uint256 amount,
45         address winner
46     );
47 
48     event TransactionDetails(
49     uint256 chosenNumber,
50     uint256 winningNumber
51     );
52 
53     /*=====================================
54     =            CONFIGURABLES            =
55     =====================================*/
56 
57     BIT BITcontract;  //a reference to the 8thereum contract
58     address owner;
59     bool openToPublic = false; 
60     uint256 winningNumber; //The randomly generated number(this changes with every transaction)
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
75      function start(uint256 choice)
76        isOpenToPublic()
77        onlyRealPeople()
78       public returns(bool)
79      {
80         bool didYouWin = false;
81         uint256 tokensTransferred = getTokensPaidToGame(msg.sender);
82 
83         // When you transfer a token to the contract, there is a 1 coin difference until you enter the next if statement
84         if( tokensTransferred > paidPlayers[msg.sender]) //can't play if you don't pay
85         {
86             paidPlayers[msg.sender] = tokensTransferred;
87         }
88         else
89         {
90             revert();
91         }
92        
93         winningNumber = uint256(keccak256(blockhash(block.number-1), choice,  msg.sender))%5 +1;//choose random number
94        
95          //if when we have a winner...
96         if(choice == winningNumber)
97         {   
98             uint256 tokensToWinner = (BITBalanceOf(address(this)) / 2);
99            //payout winner
100            BITcontract.transfer(msg.sender, tokensToWinner);
101            emit WinnerPaid(tokensToWinner, msg.sender);
102            didYouWin = true;
103         }
104         
105         emit TransactionDetails(choice, winningNumber);
106         return didYouWin;
107         
108     }
109 
110     function BITBalanceOf(address someAddress) public view returns(uint256)
111     {
112         return BITcontract.balanceOf(someAddress);
113     }
114     
115     function getTokensPaidToGame(address customerAddress) public view returns (uint256)
116     {
117        return BITcontract.gamePlayers(address(this), customerAddress);
118     }
119 
120     function winnersPot() public view returns(uint256)
121     {
122        uint256 balance = BITBalanceOf(this);
123        return balance / 2;
124     }
125 
126     function BITWhaleBalance() public view returns(uint256)
127     {
128        uint256 balance = BITBalanceOf(address(0x1570c19151305162e2391e956F74509D4f566d42));
129        return balance;
130     }
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
144 
145      /* A trap door for when someone sends tokens other than the intended ones so the overseers
146       can decide where to send them. (credit: Doublr Contract) */
147     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
148     public
149     onlyOwner()
150     notBIT(tokenAddress)
151     returns (bool success)
152     {
153         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
154     }
155 
156 }
157 
158 
159 contract ERC20Interface
160 {
161     function transfer(address to, uint256 tokens) public returns (bool success);
162 }  
163 
164 //Need to ensure the Lottery contract knows what a test token is
165 contract BIT
166 {
167     function transfer(address, uint256) public returns(bool);
168     mapping(address => mapping(address => uint256)) public gamePlayers;
169     function balanceOf(address customerAddress) public view returns(uint256);
170 }