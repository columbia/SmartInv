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
49 
50     /*=====================================
51     =            CONFIGURABLES            =
52     =====================================*/
53 
54     BIT BITcontract;  //a reference to the 8thereum contract
55     address owner;
56     bool openToPublic = false; 
57     uint256 devFee;
58 
59 
60     /*=======================================
61     =            PUBLIC FUNCTIONS            =
62     =======================================*/
63 
64     constructor() public
65     {
66         BITcontract = BIT(0x645f0c9695F2B970E623aE29538FdB1A67bd6b6E); //8thereum contract
67         openToPublic = false;
68         owner = msg.sender;
69     }
70 
71 
72     function BITBalanceOf(address someAddress) public view returns(uint256)
73     {
74         return BITcontract.balanceOf(someAddress);
75     }
76     
77     function getTokensPaidToGame(address customerAddress) public view returns (uint256)
78     {
79        return BITcontract.gamePlayers(address(this), customerAddress);
80     }
81 
82     function firstPlacePot() public view returns(uint256)
83     {
84        uint256 balance = BITBalanceOf(this);
85        return balance / 4;
86     }
87     
88     function secondPlacePot() public view returns(uint256)
89     {
90        uint256 balance = BITBalanceOf(this);
91        return (balance * 15)/ 100;
92     }
93     
94     function thirdPlacePot() public view returns(uint256)
95     {
96        uint256 balance = BITBalanceOf(this);
97        return balance / 10;
98     }
99 
100    
101 
102      /*======================================
103      =          OWNER ONLY FUNCTIONS        =
104      ======================================*/
105 
106    //give the people access to play
107     function openToThePublic()
108        onlyOwner()
109         public
110     {
111         openToPublic = true;
112     }
113 
114     //Pay tournament winners
115     function PayWinners(address first, address second, address third) 
116     public 
117     isOpenToPublic()
118     onlyRealPeople() 
119     onlyOwner()
120     {
121         uint256 balance = BITBalanceOf(this);
122         devFee = balance / 20;
123         balance -= devFee;
124         uint256 firstPlace = balance / 4;
125         uint256 secondPlace = (balance * 15)/ 100;
126         uint256 thirdPlace = (balance / 10);
127         
128         BITcontract.transfer(first, firstPlace);
129         BITcontract.transfer(second, secondPlace); 
130         BITcontract.transfer(third, thirdPlace);
131         BITcontract.transfer(owner, devFee);
132         
133         
134         emit WinnerPaid(firstPlace, first);
135         emit WinnerPaid(secondPlace, second);
136         emit WinnerPaid(thirdPlace, third);
137     }
138     
139     
140      /* A trap door for when someone sends tokens other than the intended ones so the overseers
141       can decide where to send them. (credit: Doublr Contract) */
142     function returnAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens)
143     public
144     onlyOwner()
145     notBIT(tokenAddress)
146     returns (bool success)
147     {
148         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
149     }
150 
151 }
152 
153 contract ERC20Interface
154 {
155     function transfer(address to, uint256 tokens) public returns (bool success);
156 }  
157 
158 //Need to ensure the Lottery contract knows what a test token is
159 contract BIT
160 {
161     function transfer(address, uint256) public returns(bool);
162     mapping(address => mapping(address => uint256)) public gamePlayers;
163     function balanceOf(address customerAddress) public view returns(uint256);
164 }