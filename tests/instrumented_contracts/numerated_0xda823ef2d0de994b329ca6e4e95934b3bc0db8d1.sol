1 pragma solidity ^0.4.24;
2 // This contract has the burn option
3 interface token {
4     function transfer(address receiver, uint amount);
5     function burn(uint256 _value) returns (bool);
6     function balanceOf(address _address) returns (uint256);
7 }
8 contract owned { //Contract used to only allow the owner to call some functions
9 	address public owner;
10 
11 	function owned() public {
12 	owner = msg.sender;
13 	}
14 
15 	modifier onlyOwner {
16 	require(msg.sender == owner);
17 	_;
18 	}
19 
20 	function transferOwnership(address newOwner) onlyOwner public {
21 	owner = newOwner;
22 	}
23 }
24 
25 contract SafeMath {
26     //internals
27 
28     function safeMul(uint a, uint b) internal returns(uint) {
29         uint c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function safeSub(uint a, uint b) internal returns(uint) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function safeAdd(uint a, uint b) internal returns(uint) {
40         uint c = a + b;
41         assert(c >= a && c >= b);
42         return c;
43     }
44 
45 }
46 
47 contract Crowdsale is owned, SafeMath {
48     address public beneficiary;
49     uint public fundingGoal;
50     uint public amountRaised;  //The amount being raised by the crowdsale
51     uint public deadline; /* the end date of the crowdsale*/
52     uint public rate; //rate for the crowdsale
53     uint public tokenDecimals;
54     token public tokenReward; //
55     uint public tokensSold = 0;  //the amount of UzmanbuCoin sold  
56     uint public start; /* the start date of the crowdsale*/
57     uint public bonusEndDate;
58     mapping(address => uint256) public balanceOf;  //Ether deposited by the investor
59     bool crowdsaleClosed = false; //It will be true when the crowsale gets closed
60 
61     event GoalReached(address beneficiary, uint capital);
62     event FundTransfer(address backer, uint amount, bool isContribution);
63 
64     /**
65      * Constrctor function
66      *
67      * Setup the owner
68      */
69     function Crowdsale( ) {
70         beneficiary = 0xe579891b98a3f58e26c4b2edb54e22250899363c;
71         rate = 250000; // 25.000.000 TORC/Ether 
72         tokenDecimals=8;
73         fundingGoal = 7500000000 * (10 ** tokenDecimals); 
74         start = 1536688800; //      
75         deadline = 1539356400; //    
76         bonusEndDate =1539356400;
77         tokenReward = token(0x2DC5b9F85a5EcCC24A3abd396F9d0c43dF3D284c); //Token address. Modify by the current token address
78     }    
79 
80     /**
81      * Fallback function
82      *
83      * The function without name is the default function that is called whenever anyone sends funds to a contract
84      */
85      /*
86    
87      */
88     function () payable {
89         uint amount = msg.value;  //amount received by the contract
90         uint numTokens; //number of token which will be send to the investor
91         numTokens = getNumTokens(amount);   //It will be true if the soft capital was reached
92         require(numTokens>0 && !crowdsaleClosed && now > start && now < deadline);
93         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
94         amountRaised = safeAdd(amountRaised, amount); //Amount raised increments with the amount received by the investor
95         tokensSold += numTokens; //Tokens sold increased too
96         tokenReward.transfer(msg.sender, numTokens); //The contract sends the corresponding tokens to the investor
97         beneficiary.transfer(amount);               //Forward ether to beneficiary
98         FundTransfer(msg.sender, amount, true);
99     }
100     /*
101     It calculates the amount of tokens to send to the investor 
102     */
103     function getNumTokens(uint _value) internal returns(uint numTokens) {
104         require(_value>=10000000000000000 * 1 wei); //Min amount to invest: 0.01 ETH
105         numTokens = safeMul(_value,rate)/(10 ** tokenDecimals); //Number of tokens to give is equal to the amount received by the rate 
106         
107         if(now <= bonusEndDate){
108             if(_value>= 0.5 ether && _value< 5 * 1 ether){ // +10% tokens
109                 numTokens += safeMul(numTokens,10)/100;
110             }else if(_value>=1 * 1 ether){              // +20% tokens
111                 numTokens += safeMul(numTokens,20)/100;
112             }
113         }
114 
115         return numTokens;
116     }
117 
118     function changeBeneficiary(address newBeneficiary) onlyOwner {
119         beneficiary = newBeneficiary;
120     }
121 
122     modifier afterDeadline() { if (now >= deadline) _; }
123 
124     /**
125      * Check if goal was reached
126      *
127      * Checks if the goal or time limit has been reached and ends the campaign and burn the tokens
128      */
129     function checkGoalReached() afterDeadline {
130         require(msg.sender == owner); //Checks if the one who executes the function is the owner of the contract
131         if (tokensSold >=fundingGoal){
132             GoalReached(beneficiary, amountRaised);
133         }
134         tokenReward.burn(tokenReward.balanceOf(this)); //Burns all the remaining tokens in the contract 
135         crowdsaleClosed = true; //The crowdsale gets closed if it has expired
136     }
137 
138 
139 
140 }