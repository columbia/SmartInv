1 pragma solidity ^0.4.17;
2 
3 /**
4  * 众筹合约
5  */
6 contract BSHCrowd {
7     address public beneficiary = 0x5b218A74aAc7BcCB5dF3C73c5e2c9d7cf8834334; //受益人地址
8     uint256 public fundingGoal = 9600 ether;  //众筹目标，单位是ether
9     uint256 public amountRaised = 0; //已筹集金额数量， 单位是wei
10     bool public fundingGoalReached = false;  //达成众筹目标
11     bool public crowdsaleClosed = false; //众筹关闭
12 
13     mapping(address => uint256) public balance; 
14 
15     event GoalReached(address _beneficiary, uint _amountRaised);
16     event FundTransfer(address _backer, uint _amount, bool _isContribution);
17     event ReceiveFund(address _addr, uint _amount);
18 
19     function BSHCrowd() public {
20     }
21 
22     /**
23      * 默认函数，可以向合约直接打款
24      */
25     function () payable public {
26         //判断是否关闭众筹
27         require(!crowdsaleClosed);
28         uint amount = msg.value;
29 
30         //众筹人余额累加
31         balance[msg.sender] += amount;
32 
33         //众筹总额累加
34         amountRaised += amount;
35 
36         ReceiveFund(msg.sender, amount);
37     }
38 
39     /**
40      * 检测众筹目标是否已经达到
41      */
42     function checkGoalReached() public {
43         if (amountRaised >= fundingGoal) {
44             //达成众筹目标
45             fundingGoalReached = true;
46             GoalReached(beneficiary, amountRaised);
47                 
48             //关闭众筹
49             crowdsaleClosed = true;
50         }
51     }
52 
53     /**
54      * 关闭众筹
55      */
56     function closeCrowd() public {
57         if (beneficiary == msg.sender) {
58             crowdsaleClosed = true;
59         }
60     }
61 
62     /**
63      * 提币
64      */
65     function safeWithdrawal(uint256 _value) public {
66         if (beneficiary == msg.sender && _value > 0) {
67             if (beneficiary.send(_value)) {
68                 FundTransfer(beneficiary, _value, false);
69             } else {
70                 revert();
71             }
72         }
73     }
74 }