1 pragma solidity ^0.4.24;
2 
3 
4 /* Exin Tech  */
5  
6 contract Token {
7     uint256 public totalSupply;
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     function transfer(address _to, uint256 _value) returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11     function approve(address _spender, uint256 _value) returns (bool success);
12     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16  
17  
18 /*  ERC 20 token */
19 contract StandardToken is Token {
20  
21     function transfer(address _to, uint256 _value) returns (bool success) {
22         if (balances[msg.sender] >= _value && _value > 0) {
23             balances[msg.sender] -= _value;
24             balances[_to] += _value;
25             Transfer(msg.sender, _to, _value);
26             return true;
27         } else {
28             return false;
29         }
30     }
31  
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else {
40             return false;
41         }
42     }
43  
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47  
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53  
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55         return allowed[_owner][_spender];
56     }
57  
58     mapping (address => uint256) balances;
59     mapping (address => mapping (address => uint256)) allowed;
60 }
61  
62 contract GGG is StandardToken {
63  
64     // metadata
65     string  public constant name = "UUU";
66     string  public constant symbol = "GGG";
67     uint256 public constant decimals = 18;
68     string  public version = "1.0";
69  
70     // contracts
71     address public ethFundDeposit;          
72  
73     // crowdsale parameters
74     bool    public isFunding;                
75     uint256 public fundingStartBlock;
76     uint256 public fundingStopBlock;
77  
78     // transfer
79     function formatDecimals(uint256 _value) internal returns (uint256 ) {
80         return _value * 10 ** decimals;
81     }
82  
83     // constructor
84     function GGG()
85     {
86  
87         isFunding = false;                           
88         fundingStartBlock = 0;
89         fundingStopBlock = 0;
90  
91 
92         totalSupply = formatDecimals(100000000);
93         balances[msg.sender] = totalSupply;
94 
95     }
96 
97 }