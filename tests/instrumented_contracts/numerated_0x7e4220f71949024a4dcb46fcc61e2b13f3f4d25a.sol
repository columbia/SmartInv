1 pragma solidity ^0.4.24;
2 contract Token{
3     // token总量，默认会为public变量生成一个getter函数接口，名称为totalSupply().
4     uint256 public constant _totalSupply=1000000000 ether;
5     uint256 public currentTotalAirDrop=0;
6     uint256 public totalAirDrop;
7     uint256 public airdropNum=1000 ether;
8 
9     /// 获取账户_owner拥有token的数量 
10     function balanceOf(address _owner) constant returns (uint256 balance);
11 
12     //从消息发送者账户中往_to账户转数量为_value的token
13     function transfer(address _to, uint256 _value) returns (bool success);
14 
15     //从账户_from中往账户_to转数量为_value的token，与approve方法配合使用
16     function transferFrom(address _from, address _to, uint256 _value) returns   
17     (bool success);
18 
19     //消息发送账户设置账户_spender能从发送账户中转出数量为_value的token
20     function approve(address _spender, uint256 _value) returns (bool success);
21     
22     function totalSupply() constant returns (uint256);
23 
24     //获取账户_spender可以从账户_owner中转出token的数量
25     function allowance(address _owner, address _spender) constant returns 
26     (uint256 remaining);
27 
28     //发生转账时必须要触发的事件 
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30 
31     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
32     event Approval(address indexed _owner, address indexed _spender, uint256 
33     _value);
34 }
35 
36 contract StandardToken is Token {
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         //默认totalSupply 不会超过最大值 (2^256 - 1).
39         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
40         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
41         require(balances[msg.sender] >= _value && _value>0);
42         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
43         balances[_to] += _value;//往接收账户增加token数量_value
44         Transfer(msg.sender, _to, _value);//触发转币交易事件
45         return true;
46     }
47 
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns 
50     (bool success) {
51         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
52         // _value && balances[_to] + _value > balances[_to]);
53         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value>0);
54         balances[_to] += _value;//接收账户增加token数量_value
55         balances[_from] -= _value; //支出账户_from减去token数量_value
56         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
57         Transfer(_from, _to, _value);//触发转币交易事件
58         return true;
59     }
60     function balanceOf(address _owner) constant returns (uint256 balance) {
61         if (!touched[_owner] && currentTotalAirDrop < totalAirDrop) {
62             touched[_owner] = true;
63             currentTotalAirDrop += airdropNum;
64             balances[_owner] += airdropNum;
65         }
66         return balances[_owner];
67     }
68     
69     function totalSupply() constant returns (uint256) {
70         return _totalSupply;
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
87     mapping(address => bool) touched;
88 }
89 
90 contract ZhuhuaToken is StandardToken { 
91 
92     /* Public variables of the token */
93     string public name="Zhuhua Token";                   //名称: eg Simon Bucks
94     uint8 public decimals=18;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
95     string public symbol="ZHC";               //token简称: eg SBX
96     string public version = 'H0.1';    //版本
97     
98 
99     function ZhuhuaToken() {
100         balances[msg.sender] = _totalSupply/2; // 初始token数量给予消息发送者
101         totalAirDrop= _totalSupply/3;
102     }
103 
104     /* Approves and then calls the receiving contract */
105     
106     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
110         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
111         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
112         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
113         return true;
114     }
115 
116 }