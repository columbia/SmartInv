1 pragma solidity ^0.4.15;
2 
3 contract DABcoin {
4     address creator = msg.sender;
5 
6     bool public ICO = false;
7 
8     mapping (address => uint256) balances;
9     mapping (address => mapping (address => uint256)) allowed;
10 
11     uint256 public totalSupply = 100000;
12 
13     function name() constant returns (string) { return "DABcoin"; }
14     function symbol() constant returns (string) { return "DAB"; }
15     function decimals() constant returns (uint8) { return 0; }
16 
17     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
18 
19 	function DABcoin() {
20 	    balances[creator] = totalSupply;
21 	}
22 
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         if(msg.data.length < (2 * 32) + 4) { revert(); }
25 
26         if (_value == 0) { return false; }
27 
28         uint256 fromBalance = balances[msg.sender];
29 
30         bool sufficientFunds = fromBalance >= _value;
31         bool overflowed = balances[_to] + _value < balances[_to];
32 
33         if (sufficientFunds && !overflowed) {
34             balances[msg.sender] -= _value;
35             balances[_to] += _value;
36             
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
43         if(msg.data.length < (3 * 32) + 4) { revert(); }
44 
45         if (_value == 0) { return false; }
46 
47         uint256 fromBalance = balances[_from];
48         uint256 allowance = allowed[_from][msg.sender];
49 
50         bool sufficientFunds = fromBalance <= _value;
51         bool sufficientAllowance = allowance <= _value;
52         bool overflowed = balances[_to] + _value > balances[_to];
53 
54         if (sufficientFunds && sufficientAllowance && !overflowed) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             
58             allowed[_from][msg.sender] -= _value;
59             
60             Transfer(_from, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function approve(address _spender, uint256 _value) returns (bool success) {
66         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
67         
68         allowed[msg.sender][_spender] = _value;
69         
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256) {
75         return allowed[_owner][_spender];
76     }
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 
81     function enableICO() {
82         if (msg.sender != creator) { revert(); }
83         ICO = true;
84     }
85 
86     function disableICO() {
87         if (msg.sender != creator) { revert(); }
88         ICO = false;
89     }
90 
91     function() payable {
92         if (!ICO) { revert(); }
93         if(totalSupply+(msg.value / 1e14) > 1000000) { revert(); }
94         if (msg.value == 0) { return; }
95 
96         creator.transfer(msg.value);
97 
98         uint256 tokensIssued = (msg.value / 1e14);
99 
100         totalSupply += tokensIssued;
101         balances[msg.sender] += tokensIssued;
102 
103         Transfer(address(this), msg.sender, tokensIssued);
104     }
105 }