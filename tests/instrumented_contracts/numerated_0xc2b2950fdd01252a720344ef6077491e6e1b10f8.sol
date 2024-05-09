1 pragma solidity ^0.4.19;
2 
3 /*  base token */
4 contract Token {
5     uint256 public totalSupply;
6     function balanceOf(address _owner) constant public returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public  returns (bool success);
10     function allowance(address _owner, address _spender) constant public  returns (uint256 remaining);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) public returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant public  returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value)  public returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant  public returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract MyToken is StandardToken{
60 
61     // metadata
62     string public  name;
63     string public  symbol;
64     uint256 public  decimals;
65     string public version = "1.0";
66     address public owner;
67     
68     function MyToken (string init_name,string init_symbol,uint256 init_decimals,uint256 init_total,address init_address)  public {
69         name=init_name;
70         symbol=init_symbol;
71         decimals=init_decimals;
72         balances[init_address] = init_total;
73         totalSupply = init_total;
74         owner=msg.sender;
75     }
76     
77     modifier owned(){
78         require(msg.sender==owner);
79         _;
80     }
81     
82     function setName(string new_name) public owned {
83         name = new_name;
84     }
85 	
86 	 function setSymbol(string new_symbol) public owned {
87         symbol = new_symbol;
88     }
89 	
90 }