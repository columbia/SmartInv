1 pragma solidity ^0.4.24;
2 
3 contract AutoChainTokenCandyInface{
4 
5     function name() public constant returns (string );
6     function  symbol() public constant returns (string );
7     function  decimals()  public constant returns (uint8 );
8     // 返回token总量，名称为totalSupply().
9     function  totalSupply()  public constant returns (uint256 );
10 
11     /// 获取账户_owner拥有token的数量 
12     function  balanceOf(address _owner)  public constant returns (uint256 );
13 
14     //从消息发送者账户中往_to账户转数量为_value的token
15     function  transfer(address _to, uint256 _value) public returns (bool );
16 
17     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
18     function  transferFrom(address _from, address _to, uint256 _value) public returns   
19     (bool );
20 
21     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
22     function  approve(address _spender, uint256 _value) public returns (bool );
23 
24     //获取账户_spender可以从账户_owner中转出token的数量
25     function  allowance(address _owner, address _spender) public constant returns 
26     (uint256 );
27 
28     //发生转账时必须要触发的事件 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
32     event Approval(address indexed _owner, address indexed _spender, uint256 
33     _value);
34 }
35 
36 contract AutoChainTokenCandy is AutoChainTokenCandyInface {
37 
38     /* private variables of the token */
39     uint256 private _localtotalSupply;		//总量
40     string private _localname;                   //名称: eg Simon Bucks
41     uint8 private _localdecimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
42     string private _localsymbol;               //token简称: eg SBX
43     string private _localversion = '0.01';    //版本
44 
45     address private _localowner; //存储合约owner
46 
47     mapping (address => uint256) private balances;
48     mapping (address => mapping (address => uint256)) private allowed;
49 
50     function  AutoChainTokenCandy() public {
51         _localowner=msg.sender;		//储存合约的owner
52         balances[msg.sender] = 50000000000; // 初始token数量给予消息发送者,需要增加小数点后的位数
53         _localtotalSupply = 50000000000;         // 设置初始总量,需要增加小数点后的位数
54         _localname = 'AutoChainTokenCandy';                   // token名称
55         _localdecimals = 4;           // 小数位数
56         _localsymbol = 'ATCx';             // token简称
57         
58     }
59 
60     function getOwner() constant public returns (address ){
61         return _localowner;
62     }
63 
64     function  name() constant public returns (string ){
65     	return _localname;
66     }
67     function  decimals() public constant returns (uint8 ){
68     	return _localdecimals;
69     }
70     function  symbol() public constant returns (string ){
71     	return _localsymbol;
72     }
73     function  version() public constant returns (string ){
74     	return _localversion;
75     }
76     function  totalSupply() public constant returns (uint256 ){
77     	return _localtotalSupply;
78     }
79     function  transfer(address _to, uint256 _value) public returns (bool ) {
80         //默认totalSupply 不会超过最大值 (2^256 - 1).
81         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
82         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
83         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
84         balances[_to] += _value;//往接收账户增加token数量_value
85         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
86         return true;
87     }
88     function  transferFrom(address _from, address _to, uint256 _value) public returns 
89     (bool ) {
90         require(balances[_from] >= _value &&  balances[_to] + _value > balances[_to] && allowed[_from][msg.sender] >= _value);
91         balances[_to] += _value;//接收账户增加token数量_value
92         balances[_from] -= _value; //支出账户_from减去token数量_value
93         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
94         emit Transfer(_from, _to, _value);//触发转币交易事件
95         return true;
96     }
97     function  balanceOf(address _owner) public constant returns (uint256 ) {
98         return balances[_owner];
99     }
100     function  approve(address _spender, uint256 _value) public returns (bool )   
101     {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106     function  allowance(address _owner, address _spender) public constant returns (uint256 ) {
107         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
108     }
109 }