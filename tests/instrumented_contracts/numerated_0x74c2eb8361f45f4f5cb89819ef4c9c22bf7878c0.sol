1 pragma solidity ^0.4.16;
2 
3 interface token {
4     function transfer(address receiver, uint amount);
5 }
6 
7 contract Crowdsale {
8     address public beneficiary;  // 募资成功后的收款方
9     uint public fundingGoal;   // 募资额度
10     uint public amountRaised;   // 参与数量
11     uint public deadline;      // 募资截止期
12 
13     uint public price;    //  token 与以太坊的汇率 , token卖多少钱
14     token public tokenReward;   // 要卖的token
15 
16     mapping(address => uint256) public balanceOf;
17 
18     bool fundingGoalReached = false;  // 众筹是否达到目标
19     bool crowdsaleClosed = false;   //  众筹是否结束
20 
21     /**
22     * 事件可以用来跟踪信息
23     **/
24     event GoalReached(address recipient, uint totalAmountRaised);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26 
27     /**
28      * 构造函数, 设置相关属性
29      */
30     function Crowdsale(
31         address ifSuccessfulSendTo,
32         uint fundingGoalInEthers,
33         uint durationInMinutes,
34         uint finneyCostOfEachToken,
35         address addressOfTokenUsedAsReward) {
36             beneficiary = ifSuccessfulSendTo;
37             fundingGoal = fundingGoalInEthers * 1 ether;
38             deadline = now + durationInMinutes * 1 minutes;
39             price = finneyCostOfEachToken * 1 szabo;
40             tokenReward = token(addressOfTokenUsedAsReward);   // 传入已发布的 token 合约的地址来创建实例
41     }
42 
43     /**
44      * 无函数名的Fallback函数，
45      * 在向合约转账时，这个函数会被调用
46      */
47     function () payable {
48         require(!crowdsaleClosed);
49         uint amount = msg.value;
50         balanceOf[msg.sender] += amount;
51         amountRaised += amount;
52         tokenReward.transfer(msg.sender, amount / price);
53         FundTransfer(msg.sender, amount, true);
54     }
55 
56     /**
57     *  定义函数修改器modifier（作用和Python的装饰器很相似）
58     * 用于在函数执行前检查某种前置条件（判断通过之后才会继续执行该方法）
59     * _ 表示继续执行之后的代码
60     **/
61     modifier afterDeadline() { if (now >= deadline) _; }
62 
63     /**
64      * 判断众筹是否完成融资目标， 这个方法使用了afterDeadline函数修改器
65      *
66      */
67     function checkGoalReached() afterDeadline {
68         if (amountRaised >= fundingGoal) {
69             fundingGoalReached = true;
70             GoalReached(beneficiary, amountRaised);
71         }
72         crowdsaleClosed = true;
73     }
74 
75 
76     /**
77      * 完成融资目标时，融资款发送到收款方
78      * 未完成融资目标时，执行退款
79      *
80      */
81     function safeWithdrawal() afterDeadline {
82         if (!fundingGoalReached) {
83             uint amount = balanceOf[msg.sender];
84             balanceOf[msg.sender] = 0;
85             if (amount > 0) {
86                 if (msg.sender.send(amount)) {
87                     FundTransfer(msg.sender, amount, false);
88                 } else {
89                     balanceOf[msg.sender] = amount;
90                 }
91             }
92         }
93 
94         if (fundingGoalReached && beneficiary == msg.sender) {
95             if (beneficiary.send(amountRaised)) {
96                 FundTransfer(beneficiary, amountRaised, false);
97             } else {
98                 //If we fail to send the funds to beneficiary, unlock funders balance
99                 fundingGoalReached = false;
100             }
101         }
102     }
103 }