1 pragma solidity ^0.4.8;
2 contract Token {
3     /// token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public totalSupply=52013140;
5 
6     /// 获取账户_owner拥有token的数量
7     function balanceOf(address _owner) constant returns (uint256 balance);
8 
9     //从消息发送者账户中往_to账户转数量为_value的token
10     function transfer(address _to, uint256 _value) returns (bool success);
11 
12     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
13     function transferFrom(address _from, address _to, uint256 _value) returns  (bool success);
14 
15     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
16     function approve(address _spender, uint256 _value) returns (bool success);
17 
18     //获取账户_spender可以从账户_owner中转出token的数量
19     function allowance(address _owner, address _spender) constant returns  (uint256 remaining);
20 
21     //发生转账时必须要触发的事件 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 
24     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 contract StandardToken is Token {
28     function transfer(address _to, uint256 _value) returns (bool success) {
29         //默认totalSupply 不会超过最大值 (2^256 - 1).
30         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
31         //require(balances[msg.sender] >= _value && balances[_to] + _value >balances[_to]);
32         require(balances[msg.sender] >= _value);
33         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
34         balances[_to] += _value;//往接收账户增加token数量_value
35         Transfer(msg.sender, _to, _value);//触发转币交易事件
36         return true;
37     }
38     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
39         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
40         require(balances[_from] >= _value && allowed[_from][msg.sender] >=  _value);
41         balances[_to] += _value;//接收账户增加token数量_value
42         balances[_from] -= _value;//支出账户_from减去token数量_value
43         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
44         Transfer(_from, _to, _value);//触发转币交易事件
45         return true;
46     }
47     //查询余额
48     function balanceOf(address _owner) constant returns (uint256 balance) {
49         return balances[_owner];
50     }
51     //授权账户_spender可以从消息发送者账户转出数量为_value的token
52     function approve(address _spender, uint256 _value) returns (bool success)   
53     {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59       return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
60     }
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 }
65 contract LoveToken is StandardToken {
66     /* Public variables of the token */
67     string public name;                   //名称: eg Simon Bucks
68     uint8 public decimals ;                //最多的小数位数How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
69     string public symbol;                 //token简称: eg SBX
70     string public version = 'H0.1';       //版本
71 
72     function LoveToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
73         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
74         totalSupply = _initialAmount;         // 设置初始总量
75         name = _tokenName;                   // token名称
76         decimals = _decimalUnits;           // 小数位数
77         symbol = _tokenSymbol;             // token简称
78     }
79     /* 同意转出并调用接收合约（根据自己需求实现） */
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
84         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
85         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
86         
87         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
88         return true;
89     }
90 }