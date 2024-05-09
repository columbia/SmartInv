1 pragma solidity ^0.4.21;
2 contract Token{
3     uint256 public totalSupply;
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract CYFToken is Token {
16 
17     string public name = "乞力马扎罗的雪CYF";                   //名称
18     uint8 public decimals = 18;               //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
19     string public symbol = "CYF";               //token简称
20 
21     mapping (address => uint256) balances;
22     mapping (address => mapping (address => uint256)) allowed;
23 
24     function CYFToken() public {
25         totalSupply = 7000000000 * (10 ** (uint256(decimals)));         // 设置初始总量
26         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
27     }
28 
29     function transfer(address _to, uint256 _value) public returns (bool success) {
30         //默认totalSupply 不会超过最大值 (2^256 - 1).
31         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
32         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
33         require(_to != 0x0);
34         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
35         balances[_to] += _value;//往接收账户增加token数量_value
36         emit Transfer(msg.sender, _to, _value);//触发转币交易事件
37         return true;
38     }
39     function transferFrom(address _from, address _to, uint256 _value) public returns 
40     (bool success) {
41         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
42         balances[_to] += _value;//接收账户增加token数量_value
43         balances[_from] -= _value; //支出账户_from减去token数量_value
44         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
45         emit Transfer(_from, _to, _value);//触发转币交易事件
46         return true;
47     }
48     function balanceOf(address _owner) public constant returns (uint256 balance) {
49         return balances[_owner];
50     }
51     function approve(address _spender, uint256 _value) public returns (bool success)   
52     { 
53         allowed[msg.sender][_spender] = _value;
54         emit Approval(msg.sender, _spender, _value);
55         return true;
56     }
57     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
58         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
59     }
60 }