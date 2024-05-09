1 pragma solidity ^0.4.16;
2 contract BBCCToken{
3 uint256 public totalSupply;
4 function balanceOf(address _owner) public constant returns (uint256 balance);
5 
6 function transfer(address _to, uint256 _value) public returns (bool success);
7 
8 function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
9 
10 function approve(address _spender, uint256 _value) public returns (bool success);
11 
12 function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
13 
14 event Transfer(address indexed _from, address indexed _to, uint256 _value);
15 event Approval(address indexed _owner, address indexed _spender,uint256 _value);
16 }
17 
18 contract BBCC is BBCCToken {
19 
20 string public name; //名称，例如" BBCCToken, BBCC "
21 uint8 public decimals; //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
22 
23 string public symbol; //24 token简称,like BBCC
24 
25 function BBCC(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
26 
27 totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);// 设置初始总量
28 
29 balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
30 
31 name = _tokenName;
32 decimals = _decimalUnits;
33 symbol = _tokenSymbol;
34 }
35 
36 function transfer(address _to, uint256 _value) public returns (bool success) {
37 
38 //默认totalSupply 不会超过最大值 (2^256 - 1).
39 //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
40 require(balances[msg.sender] >= _value && balances[_to] + _value >balances[_to]);
41 
42 require(_to != 0x0);
43 balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
44 
45 balances[_to] += _value;//往接收账户增加token数量_value
46 Transfer(msg.sender, _to, _value);//触发转币交易事件
47 return true;
48 }
49 
50 
51 function transferFrom(address _from, address _to, uint256 _value)
52 public returns(bool success) {
53 require(balances[_from] >= _value && allowed[_from][msg.sender] >=_value);
54 
55 balances[_to] += _value;//接收账户增加token数量_value
56 balances[_from] -= _value; //支出账户_from减去token数量_value
57 allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
58 
59 Transfer(_from, _to, _value);//触发转币交易事件
60 return true;
61 }
62 function balanceOf(address _owner) public constant returns (uint256 balance) {
63 return balances[_owner];
64 }
65 
66 
67 function approve(address _spender, uint256 _value) public returns(bool success)
68 {
69 allowed[msg.sender][_spender] = _value;
70 Approval(msg.sender, _spender, _value);
71 return true;
72 }
73 
74 function allowance(address _owner, address _spender) public constant
75 returns (uint256 remaining) {
76 return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
77 
78 }
79 mapping (address => uint256) balances;
80 mapping (address => mapping (address => uint256)) allowed;
81 }