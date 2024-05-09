1 pragma solidity ^0.4.16;
2 
3 contract Token{
4     uint256 public totalSupply;
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns   (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15 自定义的MaryCash代币
16  */
17 contract MaryCash is Token {
18  
19     /**
20     代币名称，例如"MaryCash"
21      */
22     string public name;  
23     /**
24     返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
25     */                 
26     uint8 public decimals; 
27     /**
28     token简称, GAVC
29     */              
30     string public symbol;               
31  
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34     
35     /**
36     构造方法
37      */
38     function MaryCash(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
39         // 设置初始总量
40         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits); 
41         /**
42         初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者        
43         */
44         balances[msg.sender] = totalSupply; 
45         name = _tokenName;                   
46         decimals = _decimalUnits;          
47         symbol = _tokenSymbol;
48     }
49  
50     function transfer(address _to, uint256 _value) public returns (bool success) {
51         //默认totalSupply 不会超过最大值 (2^256 - 1).
52         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
53         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
54         require(_to != 0x0);
55         //从消息发送者账户中减去token数量_value
56         balances[msg.sender] -= _value;
57         //往接收账户增加token数量_value
58         balances[_to] += _value;
59         //触发转币交易事件
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63  
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         //接收账户增加token数量_value
67         balances[_to] += _value;
68         //支出账户_from减去token数量_value
69         balances[_from] -= _value; 
70         //消息发送者可以从账户_from中转出的数量减少_value
71         allowed[_from][msg.sender] -= _value;
72         //触发转币交易事件
73         Transfer(_from, _to, _value);
74         return true;
75     }
76  
77     function balanceOf(address _owner) public constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80  
81     function approve(address _spender, uint256 _value) public returns (bool success) { 
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86  
87     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
88         //允许_spender从_owner中转出的token数
89         return allowed[_owner][_spender];
90     }   
91 }