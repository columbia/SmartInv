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
20 contract MeiJiuToken is Token {
21     uint256 public totalSupply;
22     string  public name;
23     uint8   public decimals;
24     string  public symbol;
25 
26     function MeiJiuToken(uint256 initialAmount, string tokenName, uint8 decimalUnits, string tokenSymbol) public {
27         totalSupply = initialAmount * 10 ** uint256(decimalUnits);
28         balances[msg.sender] = totalSupply;
29 
30         name = tokenName;
31         decimals = decimalUnits;
32         symbol = tokenSymbol;
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
37         require(_to != 0x0);
38         balances[msg.sender] -= _value;			//从消息发送者账户中减去token数量_value
39         balances[_to] += _value;				//往接收账户增加token数量_value
40         Transfer(msg.sender, _to, _value);		//触发转币交易事件
41         return true;
42     }
43 
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
45         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
46         balances[_to] += _value;				//接收账户增加token数量_value
47         balances[_from] -= _value; 				//支出账户_from减去token数量_value
48         allowed[_from][msg.sender] -= _value;	//消息发送者可以从账户_from中转出的数量减少_value
49         Transfer(_from, _to, _value);			//触发转币交易事件
50         return true;
51     }
52     function balanceOf(address _owner) public constant returns (uint256 balance) {
53         return balances[_owner];
54     }
55 
56     function approve(address _spender, uint256 _value) public returns (bool success)
57     {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
64         return allowed[_owner][_spender];		
65     }
66 	
67 	mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 	
70 }