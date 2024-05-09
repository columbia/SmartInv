1 pragma solidity ^0.4.16;
2 //2018.10.18
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
20 contract BarBarToken is Token {
21     uint256 public totalSupply;
22     string  public name;
23     uint8   public decimals;
24     string  public symbol;
25 
26     constructor(uint256 initialAmount, string tokenName, uint8 decimalUnits, string tokenSymbol) public {
27         totalSupply = initialAmount * 10 ** uint256(decimalUnits);
28         balances[msg.sender] = totalSupply;
29 
30         name = tokenName;
31         decimals = decimalUnits;
32         symbol = tokenSymbol;
33     }
34 //Fix for short address attack against ERC20，避免短地址攻击
35 	modifier onlyPayloadSize(uint size) {
36 		assert(msg.data.length == size + 4);
37 		_;
38 	} 
39     function transfer(address _to, uint256 _value) public returns (bool success) {
40         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
41         require(_to != 0x0);
42         balances[msg.sender] -= _value;			//从消息发送者账户中减去token数量_value
43         balances[_to] += _value;				//往接收账户增加token数量_value
44         emit Transfer(msg.sender, _to, _value);		//触发转币交易事件
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
50         balances[_to] += _value;				//接收账户增加token数量_value
51         balances[_from] -= _value; 				//支出账户_from减去token数量_value
52         allowed[_from][msg.sender] -= _value;	//消息发送者可以从账户_from中转出的数量减少_value
53         emit Transfer(_from, _to, _value);			//触发转币交易事件
54         return true;
55     }
56     function balanceOf(address _owner) public constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 
60     function approve(address _spender, uint256 _value) public returns (bool success)
61     {
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
68         return allowed[_owner][_spender];		//允许_spender从_owner中转出的token数，也就是授权
69     }
70 	
71 	mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73 	
74 }