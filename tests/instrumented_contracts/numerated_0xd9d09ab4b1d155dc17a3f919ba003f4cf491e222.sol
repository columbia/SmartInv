1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7 }
8 
9 contract Crowdsale {
10 
11     address public crowdsaleOwner;
12     address public crowdsaleBeneficiary;
13     address public crowdsaleWallet;
14 
15     uint public amountRaised;
16     uint public deadline;
17     uint public period;
18     uint public etherCost = 470;
19     uint public started;
20 
21     Token public rewardToken;
22 
23     mapping(address => uint256) public balanceOf;
24 
25     bool public fundingGoalReached = false;
26     bool public crowdsaleClosed = false;
27 
28     event GoalReached(address recipient, uint totalAmountRaised);
29     event FundTransfer(address backer, uint amount, bool isContribution);
30 
31     function Crowdsale(
32         address _beneficiaryThatOwnsTokens,
33         uint _durationInDays,
34         address _addressOfTokenUsedAsReward,
35         address _crowdsaleWallet
36     ) public {
37         crowdsaleOwner = msg.sender;
38         crowdsaleBeneficiary = _beneficiaryThatOwnsTokens;
39         deadline = now + _durationInDays * 1 days;
40         period = _durationInDays * 1 days / 3;
41         rewardToken = Token(_addressOfTokenUsedAsReward);
42         crowdsaleWallet = _crowdsaleWallet;
43         started = now;
44     }
45 
46     function stageNumber() public constant returns (uint stage) {
47         require(now >= started);
48         uint result = 1  + (now - started) / period;
49         if (result > 3) {
50             result = 3;
51         }
52         stage = result;
53     }
54 
55     function calcTokenCost() public constant returns (uint tokenCost) {
56         /* How many WEIs in half dollar */
57         uint halfDollar = 1 ether / etherCost / 2;
58         /* Get current stage for discount calculation */
59         uint stage = stageNumber();
60         /* For first stage price is 2 dollars, for second stage is 2.5 dollars & 3 dollars for others */
61         if (stage == 1) {
62             tokenCost = halfDollar * 4;
63         } else if (stage == 2) {
64             tokenCost = halfDollar * 5;
65         } else {
66             tokenCost = halfDollar * 6;
67         }
68     }
69 
70     function () public payable {
71         /* Crowdsale shouldn't be closed */
72         require(!crowdsaleClosed);
73         /* Calculate & check number of tokens for that amount */
74         uint amount = msg.value;
75         uint tokens = amount / calcTokenCost();
76         require(tokens > 0);
77         /* Increase user's amount of WEI in crowdsale */
78         balanceOf[msg.sender] += amount;
79         amountRaised += amount;
80         /* Transfer allowed tokens from crowdsale owner to sender */
81         rewardToken.transferFrom(crowdsaleWallet, msg.sender, tokens);
82         FundTransfer(msg.sender, amount, true);
83         /* Check has goal been reached */
84         checkGoalReached();
85     }
86 
87     function checkGoalReached() public {
88         uint256 tokensLeft = rewardToken.balanceOf(crowdsaleWallet);
89         if (tokensLeft == 0) {
90             fundingGoalReached = true;
91             crowdsaleClosed = true;
92             GoalReached(crowdsaleBeneficiary, amountRaised);
93         } else if (now >= deadline) {
94             crowdsaleClosed = true;
95             GoalReached(crowdsaleBeneficiary, amountRaised);
96         }
97     }
98 
99     function withdraw() public {
100         require(crowdsaleBeneficiary == msg.sender);
101         if (crowdsaleBeneficiary.send(amountRaised)) {
102             FundTransfer(crowdsaleBeneficiary, amountRaised, false);
103         }
104     }
105 
106     function updateEtherCost(uint _etherCost) public {
107         require(msg.sender == crowdsaleOwner);
108         etherCost = _etherCost;
109     }
110 }