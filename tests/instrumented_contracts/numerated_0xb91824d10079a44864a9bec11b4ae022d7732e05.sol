1 pragma solidity ^0.4.8;
2 
3 //代币合约
4  contract token {
5      string public name = "cao token"; //代币名称
6      string public symbol = "CAO"; //代币符号比如'$'
7      uint8 public decimals = 18;  //代币单位，展示的小数点后面多少个0,和以太币一样后面是是18个0
8      uint256 public totalSupply; //代币总量,这里没有做限制,你也可以限定
9 
10     //地址对应的余额
11      mapping (address => uint256) public balanceOf;
12 
13      event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
14 
15      /* 初始化合约，并且把初始的所有代币都给这合约的创建者
16       * @param _owned 合约的管理者
17       * @param tokenName 代币名称
18       * @param tokenSymbol 代币符号
19       */
20 
21      function token(address _owned, string tokenName, string tokenSymbol) public {
22          //合约的创建者获得的所有代币
23          balanceOf[_owned] = totalSupply;
24          name = tokenName;
25          symbol = tokenSymbol;
26      }
27 
28      /**
29       * 转帐，具体可以根据自己的需求来实现
30       * @param  _to address 接受代币的地址
31       * @param  _value uint256 接受代币的数量
32       */
33      function transfer(address _to, uint256 _value) public{
34        //从发送者减掉发送额
35        balanceOf[msg.sender] -= _value;
36 
37        //给接收者加上相同的量
38        balanceOf[_to] += _value;
39 
40        //通知任何监听该交易的客户端
41        Transfer(msg.sender, _to, _value);
42      }
43 
44      /**
45       * 增加代币，并将代币发送给捐赠新用户,即所谓的增发,本文固定总量,
46       * @param  _to address 接受代币的地址
47       * @param  _amount uint256 接受代币的数量
48       */
49      function issue(address _to, uint256 _amount) public{
50          totalSupply = totalSupply + _amount;
51          balanceOf[_to] += _amount;
52 
53          //通知任何监听该交易的客户端
54          Transfer(this, _to, _amount);
55      }
56   }
57 
58 /**
59  * 众筹合约
60  */
61 contract CAOsale is token {
62     address public beneficiary = msg.sender; //受益人地址，测试时为合约创建者,自己发自己
63     uint public fundingGoal;  //众筹目标，单位是ether
64     uint public amountRaised; //已筹集金额数量， 单位是wei
65     uint public deadline; //截止时间
66     uint public price;  //代币价格
67     bool public fundingGoalReached = false;  //达成众筹目标,默认未完成
68     bool public crowdsaleClosed = false; //众筹关闭,默认不关闭
69 
70 
71     mapping(address => uint256) public balance; //保存众筹地址
72 
73     //记录已接收的eth通知
74     event GoalReached(address _beneficiary, uint _amountRaised);
75 
76     //转帐时事件
77     event FundTransfer(address _backer, uint _amount, bool _isContribution);
78 
79     /**
80      * 初始化构造函数
81      * @param fundingGoalInEthers 众筹以太币总量
82      * @param durationInMinutes 众筹截止,单位是分钟
83      * @param tokenName 代币名称
84      * @param tokenSymbol 代币符号
85      */
86 
87     //  在初始化众筹合约构造函数的时候，我们会将众筹合约的帐户地址，
88     //  传递给代币做为管理地址，这里使用的是关键字this表示当前合约的地址，
89     //  也可以传递给某个人，初始创建时奖励给这个人指定量的代币。
90     function CAOsale(
91         uint fundingGoalInEthers,
92         uint durationInMinutes,
93         string tokenName,
94         string tokenSymbol
95     ) public token(this, tokenName, tokenSymbol){
96         fundingGoal = fundingGoalInEthers * 1 ether;
97         deadline = now + durationInMinutes * 1 minutes;
98         price = 0.00001 ether; //1个以太币可以买 1 个代币
99     }
100 
101     // 在众筹合约中，用于设置众筹以太币总量、众筹截止时间、以太币和代币的兑换比例,
102     // 如果不使用单位进行声明换算，默认在以太坊中，所有的单位都是wei，1 ether=10^18 wei：
103 
104     /**
105      * 默认函数
106      *
107      * 默认函数，可以向合约直接打款
108      */
109     function () payable public{
110         //判断是否关闭众筹
111         //如果关闭,则禁止打款.
112         require(!crowdsaleClosed);
113         // if (!crowdsaleClosed) throw; 这个是老写法,版本大坑啊!
114         uint amount = msg.value;
115 
116         //捐款人的金额累加
117         balance[msg.sender] += amount;
118 
119         //捐款总额累加
120         amountRaised += amount;
121 
122         //转帐操作，转多少代币给捐款人
123         issue(msg.sender, amount / price * 10 ** uint256(decimals));
124         FundTransfer(msg.sender, amount, true);
125     }
126 
127     /**
128      * 判断是否已经过了众筹截止限期
129      */
130     modifier afterDeadline() {
131         // if (this == msg.sender && now >= deadline) _; 并且该方法只能被创建者调用,严格一点
132         if (now >= deadline) _;
133         }
134 
135     /**
136      * 检测众筹目标是否完成
137      */
138     function checkGoalReached() afterDeadline public{
139         if (amountRaised >= fundingGoal){
140             //达成众筹目标
141             fundingGoalReached = true;
142             GoalReached(beneficiary, amountRaised);
143         }
144         //关闭众筹,禁止打款
145         crowdsaleClosed = true;
146     }
147 
148     /**
149      * 收回资金
150      * 检查是否达到了目标或时间限制，如果有，并且达到了资金目标，
151      * 将全部金额发送给受益人。如果没有达到目标，每个贡献者都可以退出
152      * 他们贡献的金额
153      */
154     function safeWithdrawal() afterDeadline public{
155 
156         //如果没有达成众筹目标,清空代币
157         if (!fundingGoalReached) {
158             //获取合约调用者已捐款余额
159             uint amount = balance[msg.sender];
160 
161             if (amount > 0) {
162                 //返回合约发起者所有余额
163                 //transfer是自带的方法,就是朝msg.sender转入数量的意思.类似方法还有 send
164                 //文档具体地址:http://solidity.readthedocs.io/en/develop/types.html#members-of-addresses
165                 msg.sender.transfer(amount);
166                 FundTransfer(msg.sender, amount, false);
167                 balance[msg.sender] = 0;
168             }
169         }
170 
171         //如果达成众筹目标，并且合约调用者是受益人
172         if (fundingGoalReached && beneficiary == msg.sender) {
173 
174             //将所有捐款从合约中给受益人
175             beneficiary.transfer(amountRaised);
176 
177             FundTransfer(beneficiary, amount, false);
178         }
179     }
180 }