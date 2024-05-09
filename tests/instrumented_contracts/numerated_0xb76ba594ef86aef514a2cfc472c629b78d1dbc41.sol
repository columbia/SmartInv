1 pragma solidity ^0.4.16;
2 
3 interface token {
4   function transfer(address receiver, uint amount);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6   function burn(uint256 _value) public returns (bool success);
7 }
8 
9 contract WHAPRESALEICO {
10   address public beneficiary = 0x3aDbBe8DDe40A949dF54F2F5700b9D2Eb2cF1Bbb;
11   uint public fundingGoal;
12   uint public tokensForOneEth = 7000;
13   uint public amountRaised;
14   uint public icoEndTime;
15   uint public bonusEndTime;
16   uint public bonusPercentage = 20;
17   token public tokenReward;
18   uint256 public unsoldTokens;
19   bool public fundingGoalReached = false;
20   bool public preIcoOpen = false;
21   mapping(address => uint256) public balanceOf;
22 
23   event GoalReached(address _beneficiary, uint _amountRaised);
24   event FundTransfer(address backer, uint amount, bool isContribution);
25 
26     /**
27      * Constrctor function
28      *
29      * Setup the owner
30      */
31      function WHAPRESALEICO() {
32       fundingGoal = 1400 * 1 ether;
33       bonusEndTime = now + 1910 * 1 minutes;
34       icoEndTime = now + 12770 * 1 minutes;
35       tokenReward = token(0x3d8945DcfC11627a6a762F203bE3B1B14Db36C4C);
36     }
37 
38     function safeMul(uint a, uint b) internal returns (uint) {
39       uint c = a * b;
40       assert(a == 0 || c / a == b);
41       return c;
42     }
43 
44     function safeDiv(uint a, uint b) internal returns (uint) {
45       assert(b > 0);
46       uint c = a / b;
47       assert(a == b * c + a % b);
48       return c;
49     }
50     
51     function safeSub(uint a, uint b) internal returns (uint) {
52       assert(b <= a);
53       return a - b;
54     }
55 
56     function safeAdd(uint a, uint b) internal returns (uint) {
57       uint c = a + b;
58       assert(c >= a);
59       return c;
60     }
61 
62     function () payable {
63       require(now<icoEndTime); 
64       require(preIcoOpen); 
65       require(msg.value > 0);
66 
67       uint amount = msg.value;
68       balanceOf[msg.sender] += amount;
69       amountRaised += amount;
70       if (now >= bonusEndTime) {
71         uint tokens = safeMul(msg.value, tokensForOneEth);
72       } else 
73       {
74         uint tokenswobonus = safeMul(msg.value, tokensForOneEth);
75         uint bonusamount = safeMul(safeDiv(tokenswobonus,100), bonusPercentage);
76         tokens = safeAdd(tokenswobonus,bonusamount);
77       }
78 
79       tokenReward.transfer(msg.sender, tokens);
80       FundTransfer(msg.sender, amount, true);
81       unsoldTokens = tokenReward.balanceOf(address(this));
82     }
83 
84     modifier aftericoEndTime() { if (now >= icoEndTime) _; }
85 
86 
87     function checkGoalReached() aftericoEndTime {
88       if (amountRaised >= fundingGoal){
89         fundingGoalReached = true;
90         GoalReached(beneficiary, amountRaised);
91       }
92       preIcoOpen = false;
93     }
94 
95     function pausePreIco() {
96       require(preIcoOpen); 
97       require(beneficiary == msg.sender);
98       preIcoOpen = false;
99     }
100 
101     function reStartPreIco() {
102       require(!preIcoOpen); 
103       require(beneficiary == msg.sender);
104       preIcoOpen = true;
105     }
106 
107     function changeBonusPercentage(uint newBonusPercentage) {
108      require(beneficiary == msg.sender);
109      require(newBonusPercentage > 0);
110      require(newBonusPercentage <= 50);
111      bonusPercentage = newBonusPercentage;
112    }
113 
114    function prolongPreIco(uint addMinutes) {
115      require(beneficiary == msg.sender);
116      icoEndTime = icoEndTime + addMinutes * 1 minutes;   
117    }
118 
119    function shortenPreIco(uint removeMinutes) {
120      require(beneficiary == msg.sender);
121      require((icoEndTime - removeMinutes * 1 minutes)>now);
122      require((icoEndTime - removeMinutes * 1 minutes)>bonusEndTime);
123      icoEndTime = icoEndTime - removeMinutes * 1 minutes;   
124    }
125 
126    function prolongBonusPreIco(uint addMinutes) {
127     require(beneficiary == msg.sender);
128     require((bonusEndTime + addMinutes * 1 minutes) <= icoEndTime);
129     bonusEndTime = bonusEndTime + addMinutes * 1 minutes;
130   }
131   function shortenBonusPreIco(uint removeMinutes) {
132     require(beneficiary == msg.sender);
133     require((icoEndTime - removeMinutes * 1 minutes)>now);
134     require((bonusEndTime - removeMinutes * 1 minutes) <= icoEndTime);
135     bonusEndTime = bonusEndTime - removeMinutes * 1 minutes;
136   }
137 
138   function burnAllLeftTokens() aftericoEndTime {
139     require(beneficiary == msg.sender);
140     unsoldTokens = tokenReward.balanceOf(address(this));
141     tokenReward.burn(unsoldTokens);
142   }
143 
144   function updateUnsoldTokens() {
145     unsoldTokens = tokenReward.balanceOf(address(this));
146   }
147 
148   function Withdrawal() {
149     require(beneficiary == msg.sender);
150     if (beneficiary.send(amountRaised)) {
151       FundTransfer(beneficiary, amountRaised, false);
152     }
153   }
154 }