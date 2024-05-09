1 pragma solidity ^0.4.16;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns   
8     (bool success);
9 
10     function approve(address _spender, uint256 _value) public returns (bool success);
11 
12     function allowance(address _owner, address _spender) public constant returns 
13     (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 
17     _value);
18 }
19 
20 contract TTNCoin is Token {
21 
22     string public constant name = "TTN";                   
23     uint8 public constant decimals = 2; 
24     string public constant symbol = "TTN";
25 
26     function TTNCoin(uint256 _initialAmount) public {
27         totalSupply = _initialAmount * 10 ** uint256(decimals);         // 设置初始总量
28         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
29     }
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32         //默认totalSupply 不会超过最大值 (2^256 - 1).
33         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
34         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
35         require(_to != 0x0);
36         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
37         balances[_to] += _value;//往接收账户增加token数量_value
38         Transfer(msg.sender, _to, _value);//触发转币交易事件
39         return true;
40     }
41 
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns 
44     (bool success) {
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
46         balances[_to] += _value;//接收账户增加token数量_value
47         balances[_from] -= _value; //支出账户_from减去token数量_value
48         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
49         Transfer(_from, _to, _value);//触发转币交易事件
50         return true;
51     }
52     function balanceOf(address _owner) public constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56 
57     function approve(address _spender, uint256 _value) public returns (bool success)   
58     { 
59         allowed[msg.sender][_spender] = _value;
60         Approval(msg.sender, _spender, _value);
61         return true;
62     }
63 
64     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
65         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
66     }
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 }