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
14 contract EPOsale is myOwned {
15     uint public startDate;
16     uint public stopDate;
17     uint public saleSupply;
18     uint public fundingGoal;
19     uint public amountRaised;
20     token public contractTokenReward;
21     address public contractWallet;
22     mapping(address => uint256) public balanceOf;
23     event TakeBackToken(uint amount);
24     event FundTransfer(address backer, uint amount, bool isContribution);
25 
26     function EPOsale (
27         uint _startDate,
28         uint _stopDate,
29         uint _saleSupply,
30         uint _fundingGoal,
31         address _contractWallet,
32         address _contractTokenReward
33     ) public {
34         startDate = _startDate;
35         stopDate = _stopDate;
36         saleSupply = _saleSupply;
37         fundingGoal = _fundingGoal;
38         contractWallet = _contractWallet;
39         contractTokenReward = token(_contractTokenReward);
40     }
41     
42     function getCurrentTimestamp () internal constant returns (uint256) {
43         return now;
44     }
45 
46     function saleActive() public constant returns (bool) {
47         return (now >= startDate && now <= stopDate);
48     }
49 
50     function getRateAt(uint256 at) public constant returns (uint256) {
51         if (at < startDate) {return 0;} 
52         else if (at < (startDate + 168 hours)) {return 3000;} 
53         else if (at < (startDate + 336 hours)) {return 2750;} 
54         else if (at < (startDate + 504 hours)) {return 2625;} 
55         else if (at <= stopDate) {return 2500;} 
56         else if (at > stopDate) {return 0;}
57     }
58 
59     function getRateNow() public constant returns (uint256) {
60         return getRateAt(now);
61     }
62 
63     function () public payable {
64         require(saleActive());
65         require(msg.value >= 0.05 ether);
66         uint amount = msg.value;
67         amountRaised += amount/10000000000000000;
68         uint price = 0.00000001 ether/getRateAt(now);
69         contractTokenReward.transfer(msg.sender, amount/price);
70         contractWallet.transfer(msg.value);
71         FundTransfer(msg.sender, amount, true);
72     }
73 
74     function saleEnd(uint restAmount) public onlyOwner {
75         require(!saleActive());
76         require(now > stopDate );
77         contractTokenReward.transfer(contractWallet, restAmount);
78         TakeBackToken(restAmount);
79     }
80 }