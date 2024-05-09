1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) public returns (bool success) {
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) public constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) public returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
48       return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53 }
54 
55 contract MinimalToken is StandardToken {
56     string public name;                     // Full token name
57     uint8 public decimals;                  // Number of decimal places (usually 18)
58     string public symbol;                   // Token ticker symbol
59     string public version = "MTV0.1";       // Arbitrary versioning scheme
60     address public peg;                     // Address of peg contract (to reject direct transfers)
61 
62     function MinimalToken(
63         uint256 _initialAmount,
64         string _tokenName,
65         uint8 _decimalUnits,
66         string _tokenSymbol,
67         address _peg
68         ) public {
69         balances[msg.sender] = _initialAmount;
70         totalSupply = _initialAmount;
71         name = _tokenName;
72         decimals = _decimalUnits;
73         symbol = _tokenSymbol;
74         peg = _peg;
75     }
76 
77     function () public {
78         revert();
79     }
80 
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         if (balances[msg.sender] >= _value && _value > 0 && _to != peg) {
83             balances[msg.sender] -= _value;
84             balances[_to] += _value;
85             Transfer(msg.sender, _to, _value);
86             return true;
87         } else { 
88             return false;
89         }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         if (balances[_from] >= _value && (allowed[_from][msg.sender] >= _value || (msg.sender == peg && _to == peg)) && _value > 0) {
94             balances[_to] += _value;
95             balances[_from] -= _value;
96             allowed[_from][msg.sender] -= _value;
97             Transfer(_from, _to, _value);
98             return true;
99         } else if (balances[_from] >= _value && (msg.sender == peg && _to == peg) && _value > 0) { 
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             Transfer(_from, _to, _value);
103             return true;
104         } else { return false; }
105     }
106 }