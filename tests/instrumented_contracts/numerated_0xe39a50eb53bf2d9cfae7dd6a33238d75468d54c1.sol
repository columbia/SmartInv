1 pragma solidity ^0.4.18;
2 
3 contract myOwned {
4     address public contractOwner;
5     function myOwned() public { contractOwner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == contractOwner); _;}
7     function exOwner(address newOwner) onlyOwner public { contractOwner = newOwner;}
8 }
9 
10 interface token {
11     function transfer(address receiver, uint amount) public;
12 }
13 
14 contract AIAcrowdsale is myOwned {
15     uint public startDate;
16     uint public stopDate;
17     uint public fundingGoal;
18     uint public amountRaised;
19     token public contractTokenReward;
20     address public contractWallet;
21     mapping(address => uint256) public balanceOf;
22     event GoalReached(address receiver, uint amount);
23     event FundTransfer(address backer, uint amount, bool isContribution);
24 
25     function AIAcrowdsale (
26         uint _startDate,
27         uint _stopDate,
28         uint _fundingGoal,
29         address _contractWallet,
30         address _contractTokenReward
31     ) public {
32         startDate = _startDate;
33         stopDate = _stopDate;
34         fundingGoal = _fundingGoal * 1 ether;
35         contractWallet = _contractWallet;
36         contractTokenReward = token(_contractTokenReward);
37     }
38     
39     function getCurrentTimestamp () internal constant returns (uint256) {
40         return now;
41     }
42 
43     function saleActive() public constant returns (bool) {
44         return (now >= startDate && now <= stopDate && amountRaised < fundingGoal);
45     }
46 
47     function getRateAt(uint256 at) public constant returns (uint256) {
48         if (at < startDate) {return 0;} 
49         else if (at < (startDate + 48 hours)) {return 7500;} 
50         else if (at < (startDate + 216 hours)) {return 6500;} 
51         else if (at < (startDate + 384 hours)) {return 6000;} 
52         else if (at <= stopDate) {return 5000;} 
53         else if (at > stopDate) {return 0;}
54     }
55 
56     function getRateNow() public constant returns (uint256) {
57         return getRateAt(now);
58     }
59 
60     function () public payable {
61         require(saleActive());
62         require(amountRaised < fundingGoal);
63         uint amount = msg.value;
64         balanceOf[msg.sender] += amount;
65         amountRaised += amount;
66         uint price =  0.0001 ether / getRateAt(now);
67         contractTokenReward.transfer(msg.sender, amount / price);
68         FundTransfer(msg.sender, amount, true);
69         contractWallet.transfer(msg.value);
70     }
71 
72     function saleEnd() public onlyOwner {
73         require(!saleActive());
74         require(now > stopDate );
75         contractWallet.transfer(this.balance);
76         contractTokenReward.transfer(contractWallet, this.balance);
77     }
78 }