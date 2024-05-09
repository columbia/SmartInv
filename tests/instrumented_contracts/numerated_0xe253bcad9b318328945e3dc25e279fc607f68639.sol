1 pragma solidity ^0.4.16;
2 
3 contract GFCI {
4     mapping (address => uint256) balances;
5     mapping (address => mapping (address => uint256)) allowed;
6     
7     event Transfer(address indexed _from, address indexed _to, uint256 _value);
8     event Approval(address indexed _owner, address indexed _spender, uint256 
9     _value);
10     
11     uint256 public totalSupply;
12     
13     string public name;                   //名称，例如"My test token"
14     uint8 public decimals;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
15     string public symbol;               //token简称,like MTT
16     
17     function GFCI(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
18         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量
19         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
20         
21         name = _tokenName;                   
22         decimals = _decimalUnits;          
23         symbol = _tokenSymbol;
24     }
25     
26     function transfer(address _to, uint256 _value) public returns (bool success) {
27         //默认totalSupply 不会超过最大值 (2^256 - 1).
28         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
29         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
30         require(_to != 0x0);
31         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
32         balances[_to] += _value;//往接收账户增加token数量_value
33         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
34         return true;
35     }
36 
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns 
39     (bool success) {
40         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
41         balances[_to] += _value;//接收账户增加token数量_value
42         balances[_from] -= _value; //支出账户_from减去token数量_value
43         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
44         emit Transfer(_from, _to, _value);//触发转币交易事件
45         return true;
46     }
47     function balanceOf(address _owner) public constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51 
52     function approve(address _spender, uint256 _value) public returns (bool success)   
53     { 
54         allowed[msg.sender][_spender] = _value;
55         emit Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
60         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
61     }
62    
63 }