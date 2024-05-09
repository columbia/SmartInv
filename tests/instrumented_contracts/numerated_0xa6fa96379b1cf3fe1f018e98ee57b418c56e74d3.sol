1 pragma solidity ^0.4.16;
2 
3 contract Token{
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6 
7     function transfer(address _to, uint256 _value) public returns (bool success);
8 
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10 
11     function approve(address _spender, uint256 _value) public returns (bool success);
12 
13     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 
17     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 }
19 
20 contract HongmenToken is Token {
21     uint256 public totalSupply;
22     string  public name;
23     uint8   public decimals;
24     string  public symbol;
25 
26     function HongmenToken(uint256 initialAmount, string tokenName, uint8 decimalUnits, string tokenSymbol) public {
27         totalSupply = initialAmount * 10 ** uint256(decimalUnits);
28         balances[msg.sender] = totalSupply;
29 
30         name = tokenName;
31         decimals = decimalUnits;
32         symbol = tokenSymbol;
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         //默认totalSupply 不会超过最大值 (2^256 - 1).
37         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
38         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
39         require(_to != 0x0);
40         balances[msg.sender] -= _value;			//从消息发送者账户中减去token数量_value
41         balances[_to] += _value;				//往接收账户增加token数量_value
42         Transfer(msg.sender, _to, _value);		//触发转币交易事件
43         return true;
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
48         balances[_to] += _value;				//接收账户增加token数量_value
49         balances[_from] -= _value; 				//支出账户_from减去token数量_value
50         allowed[_from][msg.sender] -= _value;	//消息发送者可以从账户_from中转出的数量减少_value
51         Transfer(_from, _to, _value);			//触发转币交易事件
52         return true;
53     }
54     function balanceOf(address _owner) public constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     function approve(address _spender, uint256 _value) public returns (bool success)
59     {
60         allowed[msg.sender][_spender] = _value;
61         Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
66         return allowed[_owner][_spender];		//允许_spender从_owner中转出的token数，也就是授权
67     }
68 
69 	mapping (address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71 	
72 }