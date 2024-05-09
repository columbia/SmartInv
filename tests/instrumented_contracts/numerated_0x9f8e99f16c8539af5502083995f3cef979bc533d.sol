1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint balance) {}
8 
9     function transfer(address _to, uint _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
12 
13     function approve(address _spender, uint _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18     event Approval(address indexed _owner, address indexed _spender, uint _value);
19 }
20 
21 contract RegularToken is Token {
22 
23     function transfer(address _to, uint _value) returns (bool) {
24         //Default assumes totalSupply can't be over max (2^256 - 1).
25         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint _value) returns (bool) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint _value) returns (bool) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint) {
54         return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint) balances;
58     mapping (address => mapping (address => uint)) allowed;
59     uint public totalSupply;
60 }
61 
62 contract UnboundedRegularToken is RegularToken {
63 
64     uint constant MAX_UINT = 2**256 - 1;
65 
66     function transferFrom(address _from, address _to, uint _value)
67         public
68         returns (bool)
69     {
70         uint allowance = allowed[_from][msg.sender];
71         if (balances[_from] >= _value
72             && allowance >= _value
73             && balances[_to] + _value >= balances[_to]
74         ) {
75             balances[_to] += _value;
76             balances[_from] -= _value;
77             if (allowance < MAX_UINT) {
78                 allowed[_from][msg.sender] -= _value;
79             }
80             Transfer(_from, _to, _value);
81             return true;
82         } else {
83             return false;
84         }
85     }
86 }
87 
88 contract EYTToken is UnboundedRegularToken {
89 
90     uint public totalSupply = 10*10**26;
91     uint8 constant public decimals = 18;
92     string constant public name = "EYinTong";
93     string constant public symbol = "EYT";
94 
95     function EYTToken() {
96         balances[msg.sender] = totalSupply;
97         Transfer(address(0), msg.sender, totalSupply);
98     }
99 }