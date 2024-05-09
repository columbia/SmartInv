1 pragma solidity ^0.4.8;
2 contract PeonyToken{ 
3     /* Public variables of the token */
4     string public name;                   //名称: eg Simon Bucks
5     uint8 public decimals;               //最多的小数位数，How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
6     string public symbol;               //token简称: eg SBX
7     string public version = 'MD0.1';    //版本
8     uint256 public totalSupply;
9 
10     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) {
11         balances[msg.sender] = _initialAmount; // 初始token数量给予消息发送者
12         totalSupply = _initialAmount;         // 设置初始总量
13         name = _tokenName;                   // token名称
14         decimals = _decimalUnits;           // 小数位数
15         symbol = _tokenSymbol;             // token简称
16     }
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19         //默认totalSupply 不会超过最大值 (2^256 - 1).
20         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
21         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
22         require(balances[msg.sender] >= _value);
23         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
24         balances[_to] += _value;//往接收账户增加token数量_value
25         Transfer(msg.sender, _to, _value);//触发转币交易事件
26         return true;
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns 
30     (bool success) {
31         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= 
32         // _value && balances[_to] + _value > balances[_to]);
33         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
34         balances[_to] += _value;//接收账户增加token数量_value
35         balances[_from] -= _value; //支出账户_from减去token数量_value
36         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
37         Transfer(_from, _to, _value);//触发转币交易事件
38         return true;
39     }
40     function balanceOf(address _owner) constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44 
45     function approve(address _spender, uint256 _value) returns (bool success)   
46     {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
55     }
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 
59     //发生转账时必须要触发的事件 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62     //当函数approve(address _spender, uint256 _value)成功执行时必须触发的事件
63     event Approval(address indexed _owner, address indexed _spender, uint256 
64     _value);
65 
66     /* Approves and then calls the receiving contract */
67     
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
72         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
73         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
74         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
75         return true;
76     }
77 
78 
79 }