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
20 contract TheGTokenTest is Token {
21 
22     string public name;                   //名称，例如"My test token"
23     uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
24     string public symbol;               //token简称,like MTT
25 
26     function TheGTokenTest(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
27         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量
28         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
29         name = _tokenName;                   
30         decimals = _decimalUnits;          
31         symbol = _tokenSymbol;
32     }
33 
34     function transfer(address _to, uint256 _value) public returns (bool success) {
35         //默认totalSupply 不会超过最大值 (2^256 - 1).
36         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
37         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
38         require(_to != 0x0);
39         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
40         balances[_to] += _value;//往接收账户增加token数量_value
41         Transfer(msg.sender, _to, _value);//触发转币交易事件
42         return true;
43     }
44 
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns 
47     (bool success) {
48         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
49         balances[_to] += _value;//接收账户增加token数量_value
50         balances[_from] -= _value; //支出账户_from减去token数量_value
51         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
52         Transfer(_from, _to, _value);//触发转币交易事件
53         return true;
54     }
55     function balanceOf(address _owner) public constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59 
60     function approve(address _spender, uint256 _value) public returns (bool success)   
61     { 
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
69     }
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 }