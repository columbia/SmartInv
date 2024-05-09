1 pragma solidity ^0.4.15;
2 
3 contract myOwned {
4     address public owner;
5     function myOwned() public { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner); _;}
7     function exOwner(address newOwner) onlyOwner public { owner = newOwner;}
8 }
9 
10 
11 interface token {
12     function transfer(address receiver, uint amount);
13 }
14 
15 contract aiaPrivatesale is myOwned {
16     uint public startDate;
17     uint public stopDate;
18     uint public fundingGoal;
19     uint public amountRaised;
20     uint public exchangeRate;
21     token public tokenReward;
22     address public beneficiary;
23     mapping(address => uint256) public balanceOf;
24     event GoalReached(address receiver, uint amount);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26 
27     function aiaPrivatesale (
28         uint _startDate,
29         uint _stopDate,
30         uint _fundingGoal,
31         address _beneficiary,
32         address _tokenReward
33     ) {
34         startDate = _startDate;
35         stopDate = _stopDate;
36         fundingGoal = _fundingGoal * 1 ether;
37         beneficiary = _beneficiary;
38         tokenReward = token(_tokenReward);
39     }
40 
41     function saleActive() public constant returns (bool) {
42         return (now >= startDate && now <= stopDate && amountRaised < fundingGoal);
43     }
44     
45     function getCurrentTimestamp() internal returns (uint256) {
46         return now;    
47     }
48 
49     function getRateAt(uint256 at) constant returns (uint256) {
50         if (at < startDate) {return 0;} 
51         else if (at <= stopDate) {return 6500;} 
52         else if (at > stopDate) {return 0;}
53     }
54 
55     function () payable {
56         require(saleActive());
57         require(amountRaised < fundingGoal);
58         uint amount = msg.value;
59         balanceOf[msg.sender] += amount;
60         amountRaised += amount;
61         exchangeRate = getRateAt(getCurrentTimestamp());
62         uint price =  0.0001 ether / getRateAt(getCurrentTimestamp());
63         tokenReward.transfer(msg.sender, amount / price);
64         FundTransfer(msg.sender, amount, true);
65         beneficiary.transfer(msg.value);
66     }
67 
68     function saleEnd() onlyOwner {
69         require(!saleActive());
70         require(now > stopDate );
71         beneficiary.transfer(this.balance);
72         tokenReward.transfer(beneficiary, this.balance);
73 
74     }
75 
76     function destroy() { 
77         if (msg.sender == beneficiary) { 
78         suicide(beneficiary);
79         tokenReward.transfer(beneficiary, this.balance);
80         }
81     }    
82 }