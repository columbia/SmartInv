1 pragma solidity ^0.4.16;
2 
3 contract GSEPTO {
4     string public name = "GSEPTO";
5     string public symbol = "GSEPTO";
6 
7     address private owner;//操作者
8     uint256 public fundingGoal; //目标金额
9     uint256 public amountRaised; //当前金额
10     mapping(address => uint256) public balanceOf; //每个地址的众筹数目，map类型
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _amount);//转账
13     event FundTransfer(address indexed _backer, uint256 _amount);//事件，资金转账记录
14     event IncreaseFunding(uint256 indexed _increase, uint256 indexed _curFundingGoal);//事件，增发
15     bool public crowdsaleOpened = true; //合约开关，启动时默认为“开”
16 
17     /*  at initialization, setup the owner */
18     function GSEPTO(uint256 _fundingGoal) public {
19         owner = msg.sender;
20         fundingGoal = _fundingGoal;
21         balanceOf[owner] = fundingGoal;
22         Transfer(0x0, owner, fundingGoal);
23     }
24 
25     // allows execution by the owner only
26     modifier ownerOnly {
27         assert(owner == msg.sender);
28         _;
29     }
30     // when crowdsale closed, throw exception
31     modifier validCrowdsale {
32         assert(crowdsaleOpened);
33         _;
34     }
35 
36     function record(address _to, uint256 _amount) public ownerOnly validCrowdsale returns (bool success) {
37         require(_to != 0x0);
38         require(balanceOf[msg.sender] >= _amount);
39         require(balanceOf[_to] + _amount >= balanceOf[_to]);
40         balanceOf[msg.sender] -= _amount;
41         //计入统计，发送者发送的数量
42         balanceOf[_to] += _amount;
43         //累计收到的金额
44         amountRaised += _amount;
45         Transfer(msg.sender, _to, _amount);
46         //发送资金变动事件通知
47         FundTransfer(_to, _amount);
48         return true;
49     }
50 
51     // increase the fundingGoal
52     // 增发总目标金额
53     function increaseFundingGoal(uint256 _amount) public ownerOnly validCrowdsale {
54         balanceOf[msg.sender] += _amount;
55         fundingGoal += _amount;
56         Transfer(0x0, msg.sender, _amount);
57         IncreaseFunding(_amount, fundingGoal);
58     }
59 
60     //close this crowdsale
61     // 关闭合约
62     function closeUp() public ownerOnly validCrowdsale {
63         crowdsaleOpened = false;
64     }
65 
66     //re open this crowdsale
67     // 开放合约
68     function reopen() public ownerOnly {
69         crowdsaleOpened = true;
70     }
71 }