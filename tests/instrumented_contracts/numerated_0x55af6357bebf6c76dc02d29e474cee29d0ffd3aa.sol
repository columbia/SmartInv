1 pragma solidity ^0.4.8;
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
13     function transferFrom(address _from, address _to, uint256 _value) returns   
14     (bool success);
15 
16     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
17     function approve(address _spender, uint256 _value) returns (bool success);
18 
19     //获取账户_spender可以从账户_owner中转出token的数量
20     function allowance(address _owner, address _spender) constant returns 
21     (uint256 remaining);
22 
23     //发生转账时必须要触发的事件 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 
26     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
27     event Approval(address indexed _owner, address indexed _spender, uint256 
28     _value);
29 }
30 
31 contract StandardToken is Token {
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         //默认totalSupply 不会超过最大值 (2^256 - 1).
34         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
35         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
36         require(balances[msg.sender] >= _value);
37         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
38         balances[_to] += _value;//往接收账户增加token数量_value
39         Transfer(msg.sender, _to, _value);//触发转币交易事件
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) returns 
44     (bool success) {
45         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
46         // _value && balances[_to] + _value > balances[_to]);
47         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
48         balances[_to] += _value;//接收账户增加token数量_value
49         balances[_from] -= _value; //支出账户_from减去token数量_value
50         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
51         Transfer(_from, _to, _value);//触发转币交易事件
52         return true;
53     }
54     
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     function approve(address _spender, uint256 _value) returns (bool success)   
60     {
61         allowed[msg.sender][_spender] = _value;
62         Approval(msg.sender, _spender, _value);
63         return true;
64     }
65 
66     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
67         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
68     }
69     mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71 }
72 
73 contract VerifyingIdentityToken is StandardToken {
74     string public constant name = "Verifying Identity Token";
75     string public constant symbol = "VIT";
76     uint8 public constant decimals = 18;
77 
78     uint256 public constant ONE_TOKENS = (10 ** uint256(decimals));
79     uint256 public constant MILLION_TOKENS = (10**6) * ONE_TOKENS;
80     uint256 public constant TOTAL_TOKENS = 1800 * MILLION_TOKENS;
81 
82     function VerifyingIdentityToken ()    
83     {
84         balances[msg.sender] = TOTAL_TOKENS; // 初始token数量给予消息发送者
85         totalSupply = TOTAL_TOKENS;         // 设置初始总量
86     }   
87 }