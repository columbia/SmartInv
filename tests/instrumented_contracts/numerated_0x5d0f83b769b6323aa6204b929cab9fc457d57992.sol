1 pragma solidity ^0.4.12;
2 contract Token{
3     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public totalSupply;
5 
6     /// 获取账户_owner拥有token的数量 
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     //从消息发送者账户中往_to账户转数量为_value的token
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14 
15     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
16     function approve(address _spender, uint256 _value) returns (bool success);
17 
18     //获取账户_spender可以从账户_owner中转出token的数量
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
20 
21     //发生转账时必须要触发的事件 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 
24     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 contract QFBToken is Token {
29     address manager;
30 //    mapping(address => bool) accountFrozen;
31     mapping(address => uint) frozenTime;
32 
33     modifier onlyManager() {
34         require(msg.sender == manager);
35         _;
36     }
37 
38     function freeze(address account, bool frozen) public onlyManager {
39         frozenTime[account] = now + 10 minutes;
40 //        accountFrozen[account] = frozen;
41     }
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         if(balances[msg.sender] >= _value && _value > 0) {
45             require(balances[msg.sender] >= _value);
46             balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
47             balances[_to] += _value;//往接收账户增加token数量_value
48             Transfer(msg.sender, _to, _value);//触发转币交易事件
49             freeze(_to, true);
50             return true;
51         }
52         
53     }
54 
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         require(frozenTime[_from] <= now);
58         
59         if(balances[_from] >= _value  && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             Transfer(_from, _to, _value);
63 
64             return true;
65         } else {
66             return false;
67         }
68     }
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73 
74     function approve(address _spender, uint256 _value) returns (bool success)   
75     {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81 
82     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
83         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
84     }
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 
88     string public constant name = "QFBCOIN";                   //名称: eg Simon Bucks
89     uint256 public constant decimals = 18;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
90     string public constant symbol = "QFB";               //token简称: eg SBX
91     string public version = 'QF1.0';    //版本
92 
93     // contracts
94     address public ethFundDeposit;          // ETH存放地址
95     address public newContractAddr;         // token更新地址
96 
97     // crowdsale parameters
98     bool    public isFunding;                // 状态切换到true
99     uint256 public fundingStartBlock;
100     uint256 public fundingStopBlock;
101 
102     uint256 public currentSupply;           // 正在售卖中的tokens数量
103     uint256 public tokenRaised = 0;         // 总的售卖数量token
104     uint256 public tokenMigrated = 0;     // 总的已经交易的 token
105     uint256 public tokenExchangeRate = 625;             // 625 BILIBILI 兑换 1 ETH
106 
107     // events
108     event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
109     event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
110     event IncreaseSupply(uint256 _value);
111     event DecreaseSupply(uint256 _value);
112     event Migrate(address indexed _to, uint256 _value);
113 
114      // 转换
115     function formatDecimals(uint256 _value) internal returns (uint256) {
116         return _value * 10 ** decimals;
117     }
118 
119     // constructor
120     function QFBToken( address _ethFundDeposit, uint256 _currentSupply) {
121         ethFundDeposit = _ethFundDeposit;
122 
123         isFunding = false;
124         //通过控制预CrowdS ale状态
125         fundingStartBlock = 0;
126         fundingStopBlock = 0;
127         currentSupply = formatDecimals(_currentSupply);
128         totalSupply = formatDecimals(10000);
129         balances[msg.sender] = totalSupply;
130         manager = msg.sender;
131         if (currentSupply > totalSupply) throw;
132     }
133 }