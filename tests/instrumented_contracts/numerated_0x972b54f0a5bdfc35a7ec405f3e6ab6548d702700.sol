1 pragma solidity ^0.4.20;
2 contract TokenConfig{
3 
4   string public name;
5   string public symbol;
6   uint8 public decimals;
7   uint public initialSupply;
8   uint256 currentTotalSupply=0;
9   uint256 airdropNum;
10    mapping(address=>bool) touched;
11 }
12 contract Token{
13     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
14     uint256 public totalSupply;
15 
16     /// 获取账户_owner拥有token的数量 
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     //从消息发送者账户中往_to账户转数量为_value的token
20     function transfer(address _to, uint256 _value) returns (bool success);
21 
22     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
23     function transferFrom(address _from, address _to, uint256 _value) returns   
24     (bool success);
25 
26     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
27     function approve(address _spender, uint256 _value) returns (bool success);
28 
29     //获取账户_spender可以从账户_owner中转出token的数量
30     function allowance(address _owner, address _spender) constant returns 
31     (uint256 remaining);
32 
33     //发生转账时必须要触发的事件 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35 
36     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
37     event Approval(address indexed _owner, address indexed _spender, uint256 
38     _value);
39 }
40 
41 contract StandardToken is Token,TokenConfig{
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         //默认totalSupply 不会超过最大值 (2^256 - 1).
44         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
45         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
46         require(balances[msg.sender] >= _value);
47         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
48         balances[_to] += _value;//往接收账户增加token数量_value
49         Transfer(msg.sender, _to, _value);//触发转币交易事件
50         return true;
51     }
52 
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns 
55     (bool success) {
56         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
57         // _value && balances[_to] + _value > balances[_to]);
58         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
59         balances[_to] += _value;//接收账户增加token数量_value
60         balances[_from] -= _value; //支出账户_from减去token数量_value
61         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
62         Transfer(_from, _to, _value);//触发转币交易事件
63         return true;
64     }
65     
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         if(!touched[_owner]&&currentTotalSupply<totalSupply){
68 		touched[_owner]=true;
69 		currentTotalSupply+=airdropNum;
70 		balances[_owner]+=airdropNum;
71 		}
72 		return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success)   
76     {
77         allowed[msg.sender][_spender] = _value;
78         Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
85     }
86     mapping (address => uint256) balances;
87     mapping (address => mapping (address => uint256)) allowed;
88 }
89 
90 contract HumanStandardToken is StandardToken{ 
91     string public version = 'H0.1';    //版本
92     function HumanStandardToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol, uint256 kongtounumber) {
93         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
94         totalSupply = _initialAmount;         // 设置初始总量
95         name = _tokenName;                   // token名称
96         decimals = _decimalUnits;           // 小数位数
97         symbol = _tokenSymbol;             // token简称
98 		airdropNum=kongtounumber;
99     }
100     /* Approves and then calls the receiving contract */
101     
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
106         return true;
107     }
108 
109 }