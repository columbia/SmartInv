1 pragma solidity ^0.4.2;
2 interface token {
3    function transfer (address receiver, uint amount) public;
4 }
5 contract Crowdsale {
6    address public beneficiary;
7    uint public fundingGoal;
8    uint public amountRaised;
9    uint public currentBalance;
10    uint public deadline;
11    uint public bonusPhaseOneDeadline;
12    uint public bonusPhaseTwoDeadline;
13    uint public bonusPhaseThreeDeadline;
14    uint public price;
15    uint public phaseOneBonusPercent;
16    uint public phaseTwoBonusPercent;
17    uint public phaseThreeBonusPercent;
18    uint public remainingTokens;
19    token public tokenReward;
20    mapping(address => uint256) public balanceOf;
21    bool public crowdsaleClosed = false;
22    event GoalReached(address recipient, uint totalAmountRaised);
23    event FundTransfer(address backer, uint amount, bool isContribution);
24    function Crowdsale(
25        address ifSuccessfulSendTo,
26        uint fundingGoalInEthers,
27        uint durationInMinutes,
28        address addressOfTokenUsedAsReward,
29        uint phaseOneDuration,
30        uint phaseTwoDuration,
31        uint phaseThreeDuration,
32        uint additionalBonusTokens
33    ) public {
34        beneficiary = ifSuccessfulSendTo;
35        fundingGoal = fundingGoalInEthers * 1 ether;
36        deadline = now + durationInMinutes * 1 minutes;
37        bonusPhaseOneDeadline = now + phaseOneDuration * 1 minutes;
38        bonusPhaseTwoDeadline = now + phaseTwoDuration * 1 minutes;
39        bonusPhaseThreeDeadline = now + phaseThreeDuration * 1 minutes;
40        price = 0.0002 * 1 ether;
41        tokenReward = token(addressOfTokenUsedAsReward);
42        currentBalance = 0;
43        remainingTokens = (5000 * fundingGoalInEthers * 10 ** uint256(8)) + (additionalBonusTokens * 10 ** uint256(8));
44        phaseOneBonusPercent = 40;
45        phaseTwoBonusPercent = 35;
46        phaseThreeBonusPercent = 30;
47    }
48    function () public payable {
49        require(!crowdsaleClosed);
50        require(now < deadline);
51        uint amount = msg.value;
52        if (msg.sender != beneficiary) {
53            require(msg.value >= 1 ether);
54            amountRaised += amount;
55            uint tokens = uint(amount * 10 ** uint256(8) / price);
56            if (now < bonusPhaseOneDeadline) {
57                tokens += ((phaseOneBonusPercent * tokens)/100 );
58            } else if (now < bonusPhaseTwoDeadline) {
59                tokens += ((phaseTwoBonusPercent * tokens)/100);
60            } else if (now < bonusPhaseThreeDeadline) {
61                tokens += ((phaseThreeBonusPercent * tokens)/100);
62            }
63            balanceOf[msg.sender] += tokens;
64            remainingTokens -= tokens;
65            tokenReward.transfer(msg.sender, tokens);
66            FundTransfer(msg.sender, amount, true);
67        }
68        currentBalance += amount;
69    }
70    function checkGoalReached() public {
71        require(beneficiary == msg.sender);
72        crowdsaleClosed = true;
73    }
74    function safeWithdrawal(uint amountInWei) public {
75        require(beneficiary == msg.sender);
76        if (beneficiary.send(amountInWei)) {
77            FundTransfer(beneficiary, amountInWei, false);
78            currentBalance -= amountInWei;
79        }
80    }
81    function withdrawUnsold() public {
82        require(msg.sender == beneficiary);
83        require(remainingTokens > 0);
84        tokenReward.transfer(msg.sender, remainingTokens);
85    }
86 }