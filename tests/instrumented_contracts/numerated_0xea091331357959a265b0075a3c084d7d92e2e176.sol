1 pragma solidity ^0.4.18;
2 // This contract has the burn option
3 interface token {
4     function transfer(address receiver, uint amount);
5     function burn(uint256 _value) returns (bool);
6     function balanceOf(address _address) returns (uint256);
7 }
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 }
20 
21 contract SafeMath {
22     //internals
23 
24     function safeMul(uint a, uint b) internal returns(uint) {
25         uint c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function safeSub(uint a, uint b) internal returns(uint) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function safeAdd(uint a, uint b) internal returns(uint) {
36         uint c = a + b;
37         assert(c >= a && c >= b);
38         return c;
39     }
40 
41 }
42 
43 contract BTCxCrowdsale is owned, SafeMath {
44     address public beneficiary;
45     uint public fundingGoal;
46     uint public amountRaised;  //The amount being raised by the crowdsale
47     /* the end date of the crowdsale*/
48     uint public deadline; /* the end date of the crowdsale*/
49     uint public rate; //rate for the crowdsale
50     uint public tokenDecimals;
51     token public tokenReward; //
52     uint public tokensSold = 0;  
53     /* the start date of the crowdsale*/
54     uint public start; /* the start date of the crowdsale*/
55     mapping(address => uint256) public balanceOf;  //Ether deposited by the investor
56     // bool fundingGoalReached = false;
57     bool crowdsaleClosed = false; //It will be true when the crowsale gets closed
58 
59     event GoalReached(address beneficiary, uint capital);
60     event FundTransfer(address backer, uint amount, bool isContribution);
61 
62     /**
63      * Constrctor function
64      *
65      * Setup the owner
66      */
67     function BTCxCrowdsale( ) {
68         beneficiary = 0x781AC8C2D6dc017c4259A1f06123659A4f6dFeD8;
69         rate = 2; 
70         tokenDecimals=8;
71         fundingGoal = 14700000 * (10 ** tokenDecimals); 
72         start = 1512831600; //      12/11/2017 @ 2:00pm (UTC)
73         deadline =1515628740; //    01/10/2018 @ 11:59pm (UTC)
74         tokenReward = token(0x5A82De3515fC4A4Db9BA9E869F269A1e85300092); //Token address. Modify by the current token address
75     }    
76 
77     /**
78      * Fallback function
79      *
80      * The function without name is the default function that is called whenever anyone sends funds to a contract
81      */
82      /*
83    
84      */
85     function () payable {
86         uint amount = msg.value;  //amount received by the contract
87         uint numTokens; //number of token which will be send to the investor
88         numTokens = getNumTokens(amount);   //It will be true if the soft capital was reached
89         require(numTokens>0 && !crowdsaleClosed && now > start && now < deadline);
90         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
91         amountRaised = safeAdd(amountRaised, amount); //Amount raised increments with the amount received by the investor
92         tokensSold += numTokens; //Tokens sold increased too
93         tokenReward.transfer(msg.sender, numTokens); //The contract sends the corresponding tokens to the investor
94         beneficiary.transfer(amount);               //Forward ether to beneficiary
95         FundTransfer(msg.sender, amount, true);
96     }
97     /*
98     It calculates the amount of tokens to send to the investor 
99     */
100     function getNumTokens(uint _value) internal returns(uint numTokens) {
101         numTokens = safeMul(_value,rate)/(10 ** tokenDecimals); //Number of tokens to give is equal to the amount received by the rate 
102         return numTokens;
103     }
104 
105     modifier afterDeadline() { if (now >= deadline) _; }
106 
107     /**
108      * Check if goal was reached
109      *
110      * Checks if the goal or time limit has been reached and ends the campaign and burn the tokens
111      */
112     function checkGoalReached() afterDeadline {
113         require(msg.sender == owner); //Checks if the one who executes the function is the owner of the contract
114         if (tokensSold >=fundingGoal){
115             GoalReached(beneficiary, amountRaised);
116         }
117         tokenReward.burn(tokenReward.balanceOf(this)); //Burns all the remaining tokens in the contract 
118         crowdsaleClosed = true; //The crowdsale gets closed if it has expired
119     }
120 
121 
122 
123 }