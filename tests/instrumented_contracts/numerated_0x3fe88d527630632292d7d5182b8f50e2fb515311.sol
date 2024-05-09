1 pragma solidity ^0.4.21;
2 
3 contract Token{
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns   
9     (bool success);
10 
11     function approve(address _spender, uint256 _value) public returns (bool success);
12 
13     function allowance(address _owner, address _spender) public constant returns 
14     (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Approval(address indexed _owner, address indexed _spender, uint256 
18     _value);
19 }
20 
21 contract owned {
22     address public owner;
23 
24     function owned() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function upgradeOwner(address newOwner) onlyOwner public {
34         owner = newOwner;
35     }
36 }
37 
38 contract SimpleToken is Token,owned {
39 
40     string public name;                 //名称，例如"My test token"
41     uint8 public decimals;              //返回token使用的小数点后几位。比如如果设置为3，就是支持0.001表示.
42     string public symbol;               //token简称,like MTT
43 
44     function SimpleToken(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
45         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);         // 设置初始总量
46         balances[msg.sender] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
47 
48         name = _tokenName;                   
49         decimals = _decimalUnits;          
50         symbol = _tokenSymbol;
51     }
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         _transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns 
60     (bool success) {
61         require(_value <= allowed[_from][msg.sender]);     // Check allowed
62         allowed[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70 
71     function approve(address _spender, uint256 _value) public returns (bool success)   
72     { 
73         allowed[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
80     }
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 
84 	
85 	/**
86      * Internal transfer, only can be called by this contract
87      */
88     function _transfer(address _from, address _to, uint _value) internal {
89         // Prevent transfer to 0x0 address. Use burn() instead
90         require(_to != 0x0);
91         // Check if the sender has enough
92         require(balances[_from] >= _value);
93         // Check for overflows
94         require(balances[_to] + _value > balances[_to]);
95         // Save this for an assertion in the future
96         uint previousBalances = balances[_from] + balances[_to];
97         // Subtract from the sender
98         balances[_from] -= _value;
99         // Add the same to the recipient
100         balances[_to] += _value;
101         emit Transfer(_from, _to, _value);
102         // Asserts are used to use static analysis to find bugs in your code. They should never fail
103         assert(balances[_from] + balances[_to] == previousBalances);
104     }
105 	
106 }