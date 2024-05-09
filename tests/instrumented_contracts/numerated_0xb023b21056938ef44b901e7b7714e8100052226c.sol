1 pragma solidity 0.4.25;
2 /**
3  * 外部调用外部代币。
4  */
5  interface token {
6     function transfer(address receiver, uint amount) external;
7 }
8 
9 /**
10  * 众筹合约
11  */
12 contract Crowdsale {
13     address public beneficiary = msg.sender; //受益人地址，测试时为合约创建者
14     uint public fundingGoal;  //众筹目标，单位是ether
15     uint public amountRaised; //已筹集金额数量， 单位是ether
16     uint public deadline; //截止时间
17     uint public price;  //代币价格
18     token public tokenReward;   // 要卖的token
19     bool public fundingGoalReached = false;  //达成众筹目标
20     bool public crowdsaleClosed = false; //众筹关闭
21 
22 
23     mapping(address => uint256) public balance; //保存众筹地址及对应的以太币数量
24 
25     // 受益人将众筹金额转走的通知
26     event GoalReached(address _beneficiary, uint _amountRaised);
27 
28     // 用来记录众筹资金变动的通知，_isContribution表示是否是捐赠，因为有可能是捐赠者退出或发起者转移众筹资金
29     event FundTransfer(address _backer, uint _amount, bool _isContribution);
30 
31     /**
32      * 初始化构造函数
33      *
34      * @param fundingGoalInEthers 众筹以太币总量
35      * @param durationInMinutes 众筹截止,单位是分钟
36      */
37     constructor(
38         uint fundingGoalInEthers,
39         uint durationInMinutes,
40         uint TokenCostOfEachether,
41         address addressOfTokenUsedAsReward
42     )  public {
43         fundingGoal = fundingGoalInEthers * 1 ether;
44         deadline = now + durationInMinutes * 1 minutes;
45         price = TokenCostOfEachether ; //1个以太币可以买几个代币
46         tokenReward = token(addressOfTokenUsedAsReward); 
47     }
48 
49 
50     /**
51      * 默认函数
52      *
53      * 默认函数，可以向合约直接打款
54      */
55     function () payable public {
56 
57         //判断是否关闭众筹
58         require(!crowdsaleClosed);
59         uint amount = msg.value;
60 
61         //捐款人的金额累加
62         balance[msg.sender] += amount;
63 
64         //捐款总额累加
65         amountRaised += amount;
66 
67         //转帐操作，转多少代币给捐款人
68          tokenReward.transfer(msg.sender, amount * price);
69          emit FundTransfer(msg.sender, amount, true);
70     }
71 
72     /**
73      * 判断是否已经过了众筹截止限期
74      */
75     modifier afterDeadline() { if (now >= deadline) _; }
76 
77     /**
78      * 检测众筹目标是否已经达到
79      */
80     function checkGoalReached() afterDeadline public {
81         if (amountRaised >= fundingGoal){
82             //达成众筹目标
83             fundingGoalReached = true;
84           emit  GoalReached(beneficiary, amountRaised);
85         }
86 
87         //关闭众筹
88         crowdsaleClosed = true;
89     }
90     function backtoken(uint backnum) public{
91         uint amount = backnum * 10 ** 18;
92         tokenReward.transfer(beneficiary, amount);
93        emit FundTransfer(beneficiary, amount, true);
94     }
95     
96     function backeth() public{
97         beneficiary.transfer(amountRaised);
98         emit FundTransfer(beneficiary, amountRaised, true);
99     }
100 
101     /**
102      * 收回资金
103      *
104      * 检查是否达到了目标或时间限制，如果有，并且达到了资金目标，
105      * 将全部金额发送给受益人。如果没有达到目标，每个贡献者都可以退出
106      * 他们贡献的金额
107      * 注：这里代码应该是限制了众筹时间结束且众筹目标没有达成的情况下才允许退出。如果去掉限制条件afterDeadline，应该是可以允许众筹时间还未到且众筹目标没有达成的情况下退出
108      */
109     function safeWithdrawal() afterDeadline public {
110 
111         //如果没有达成众筹目标
112         if (!fundingGoalReached) {
113             //获取合约调用者已捐款余额
114             uint amount = balance[msg.sender];
115 
116             if (amount > 0) {
117                 //返回合约发起者所有余额
118                 beneficiary.transfer(amountRaised);
119                 emit  FundTransfer(beneficiary, amount, false);
120                 balance[msg.sender] = 0;
121             }
122         }
123 
124         //如果达成众筹目标，并且合约调用者是受益人
125         if (fundingGoalReached && beneficiary == msg.sender) {
126 
127             //将所有捐款从合约中给受益人
128             beneficiary.transfer(amountRaised);
129 
130           emit  FundTransfer(beneficiary, amount, false);
131         }
132     }
133 }