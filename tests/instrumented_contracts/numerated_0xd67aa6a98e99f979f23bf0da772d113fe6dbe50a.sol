1 pragma solidity ^0.4.21;
2 
3 interface token {
4     function transfer(address receiver, uint amount)external;
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;
9     uint public amountRaised;
10 	uint public allAmountRaised;
11     uint public deadline;
12     uint public price;
13 	uint public limitTransfer;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     bool crowdsaleClosed = false;
17 	bool public crowdsalePaused = false;
18 
19     event FundTransfer(address backer, uint amount, bool isContribution);
20     
21     modifier onlyOwner {
22         require(msg.sender == beneficiary);
23         _;
24     }
25 	
26 	/**
27      * Constrctor function
28      *
29      * Setup the owner
30      */
31     function Crowdsale(
32         address ifSuccessfulSendTo,
33         uint durationInMinutes,
34         uint etherCostOfEachToken,
35 		uint limitAfterSendToBeneficiary,
36         address addressOfTokenUsedAsReward
37     )public {
38         beneficiary = ifSuccessfulSendTo;
39         deadline = now + durationInMinutes * 1 minutes;
40         price = etherCostOfEachToken;
41         tokenReward = token(addressOfTokenUsedAsReward);
42 		limitTransfer = limitAfterSendToBeneficiary;
43     }
44 	
45 	/**
46      * changeDeadline function
47      *
48      * Setup the new deadline
49      */
50     function changeDeadline(uint durationInMinutes) public onlyOwner 
51 	{
52 		crowdsaleClosed = false;
53         deadline = now + durationInMinutes * 1 minutes;
54     }
55 	
56 	/**
57      * changePrice function
58      *
59      * Setup the new price
60      */
61     function changePrice(uint _price) public onlyOwner 
62 	{
63         price = _price;
64     }
65 	
66 	/**
67      * Pause Crowdsale
68      *
69      */
70     function pauseCrowdsale()public onlyOwner 
71 	{
72         crowdsaleClosed = true;
73 		crowdsalePaused = true;
74     }
75 	
76 	/**
77      * Run Crowdsale
78      *
79      */
80     function runCrowdsale()public onlyOwner 
81 	{
82 		require(now <= deadline);
83         crowdsaleClosed = false;
84 		crowdsalePaused = false;
85     }
86 
87     /**
88      * Send To Beneficiary
89      *
90      * Transfer to Beneficiary
91      */
92     function sendToBeneficiary()public onlyOwner 
93 	{
94         if (beneficiary.send(amountRaised)) 
95 		{
96 			amountRaised = 0;
97 			emit FundTransfer(beneficiary, amountRaised, false);
98 		}
99     }
100 	
101 	/**
102      * Fallback function
103      *
104      * The function without name is the default function that is called whenever anyone sends funds to a contract
105      */
106     function () public payable 
107 	{
108         require(!crowdsaleClosed);
109 		require(now <= deadline);
110         uint amount = msg.value;
111         balanceOf[msg.sender] += amount;
112         amountRaised    += amount;
113 		allAmountRaised += amount;
114         tokenReward.transfer(msg.sender, amount / price);
115         emit FundTransfer(msg.sender, amount, true);
116 		
117 		if (amountRaised >= limitTransfer)
118 		{
119 			if (beneficiary.send(amountRaised)) 
120 			{
121                 amountRaised = 0;
122 				emit FundTransfer(beneficiary, amountRaised, false);
123             }
124 		}
125     }
126 }