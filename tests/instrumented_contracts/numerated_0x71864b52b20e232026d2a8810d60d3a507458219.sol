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
51     /* the end date of the crowdsale*/
52     uint public deadline; /* the end date of the crowdsale*/
53     uint public rate; //rate for the crowdsale
54     uint public tokenDecimals;
55     token public tokenReward; //
56     uint public tokensSold = 0;  //the amount of UzmanbuCoin sold  
57     /* the start date of the crowdsale*/
58     uint public start; /* the start date of the crowdsale*/
59     mapping(address => uint256) public balanceOf;  //Ether deposited by the investor
60     // bool fundingGoalReached = false;
61     bool crowdsaleClosed = false; //It will be true when the crowsale gets closed
62 
63     event GoalReached(address beneficiary, uint capital);
64     event FundTransfer(address backer, uint amount, bool isContribution);
65 
66     /**
67      * Constrctor function
68      *
69      * Setup the owner
70      */
71     function Crowdsale( ) {
72         beneficiary = 0xE579891b98a3f58E26c4B2edB54E22250899363c;
73         rate = 40000; //
74         tokenDecimals=8;
75         fundingGoal = 2500000000 * (10 ** tokenDecimals); 
76         start = 1536537600; 
77         deadline =1539129600; 
78         tokenReward = token(0x19335137283563C9531062EDD04ddf19d42097bd); //Token address. Modify by the current token address
79     }    
80 
81     /**
82      * Fallback function
83      *
84      * The function without name is the default function that is called whenever anyone sends funds to a contract
85      */
86      /*
87    
88      */
89     function () payable {
90         uint amount = msg.value;  //amount received by the contract
91         uint numTokens; //number of token which will be send to the investor
92         numTokens = getNumTokens(amount);   //It will be true if the soft capital was reached
93         require(numTokens>0 && !crowdsaleClosed && now > start && now < deadline);
94         balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], amount);
95         amountRaised = safeAdd(amountRaised, amount); //Amount raised increments with the amount received by the investor
96         tokensSold += numTokens; //Tokens sold increased too
97         tokenReward.transfer(msg.sender, numTokens); //The contract sends the corresponding tokens to the investor
98         beneficiary.transfer(amount);               //Forward ether to beneficiary
99         FundTransfer(msg.sender, amount, true);
100     }
101     /*
102     It calculates the amount of tokens to send to the investor 
103     */
104     function getNumTokens(uint _value) internal returns(uint numTokens) {
105         require(_value>=10000000000000000 * 1 wei); //Min amount to invest: 0.01 ETH
106         numTokens = safeMul(_value,rate)/(10 ** tokenDecimals); //Number of tokens to give is equal to the amount received by the rate 
107         return numTokens;
108     }
109 
110     function changeBeneficiary(address newBeneficiary) onlyOwner {
111         beneficiary = newBeneficiary;
112     }
113 
114     modifier afterDeadline() { if (now >= deadline) _; }
115 
116     /**
117      * Check if goal was reached
118      *
119      * Checks if the goal or time limit has been reached and ends the campaign and burn the tokens
120      */
121     function checkGoalReached() afterDeadline {
122         require(msg.sender == owner); //Checks if the one who executes the function is the owner of the contract
123         if (tokensSold >=fundingGoal){
124             GoalReached(beneficiary, amountRaised);
125         }
126         tokenReward.burn(tokenReward.balanceOf(this)); //Burns all the remaining tokens in the contract 
127         crowdsaleClosed = true; //The crowdsale gets closed if it has expired
128     }
129 
130 
131 
132 }