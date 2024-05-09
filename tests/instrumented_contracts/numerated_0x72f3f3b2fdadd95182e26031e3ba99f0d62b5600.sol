1 pragma solidity 0.4.19;
2 
3 contract Token {
4 
5 
6     function totalSupply() constant returns (uint supply) {}
7 
8 
9     function balanceOf(address _owner) constant returns (uint balance) {}
10 
11 
12     function transfer(address _to, uint _value) returns (bool success) {}
13 
14 
15     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
16 
17 
18     function approve(address _spender, uint _value) returns (bool success) {}
19 
20 
21     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
22 
23     event Transfer(address indexed _from, address indexed _to, uint _value);
24     event Approval(address indexed _owner, address indexed _spender, uint _value);
25 }
26 
27 contract RegularToken is Token {
28 
29     function transfer(address _to, uint _value) returns (bool) {
30        
31         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function transferFrom(address _from, address _to, uint _value) returns (bool) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function balanceOf(address _owner) constant returns (uint) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint _value) returns (bool) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant returns (uint) {
60         return allowed[_owner][_spender];
61     }
62 
63     mapping (address => uint) balances;
64     mapping (address => mapping (address => uint)) allowed;
65     uint public totalSupply;
66 }
67 
68 contract UnboundedRegularToken is RegularToken {
69 
70     uint constant MAX_UINT = 2**256 - 1;
71     
72 
73     function transferFrom(address _from, address _to, uint _value)
74         public
75         returns (bool)
76     {
77         uint allowance = allowed[_from][msg.sender];
78         if (balances[_from] >= _value
79             && allowance >= _value
80             && balances[_to] + _value >= balances[_to]
81         ) {
82             balances[_to] += _value;
83             balances[_from] -= _value;
84             if (allowance < MAX_UINT) {
85                 allowed[_from][msg.sender] -= _value;
86             }
87             Transfer(_from, _to, _value);
88             return true;
89         } else {
90             return false;
91         }
92     }
93 }
94 
95 contract GangnamToken is UnboundedRegularToken {
96 
97     uint public totalSupply = 20*10**26;
98     uint8 constant public decimals = 18;
99     string constant public name = "GangnamToken";
100     string constant public symbol = "GNLT";
101 
102     function GangnamToken() {
103         balances[msg.sender] = totalSupply;
104         Transfer(address(0), msg.sender, totalSupply);
105     }
106 }