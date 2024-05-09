1 pragma solidity 0.4.19;
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
24         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         } else { return false; }
30     }
31 
32     function transferFrom(address _from, address _to, uint _value) returns (bool) {
33         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
34             balances[_to] += _value;
35             balances[_from] -= _value;
36             allowed[_from][msg.sender] -= _value;
37             Transfer(_from, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function balanceOf(address _owner) constant returns (uint) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint _value) returns (bool) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) constant returns (uint) {
53         return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint) balances;
57     mapping (address => mapping (address => uint)) allowed;
58     uint public totalSupply;
59 }
60 
61 contract UnboundedRegularToken is RegularToken {
62 
63     uint constant MAX_UINT = 2**256 - 1;
64     
65     function transferFrom(address _from, address _to, uint _value)
66         public
67         returns (bool)
68     {
69         uint allowance = allowed[_from][msg.sender];
70         if (balances[_from] >= _value
71             && allowance >= _value
72             && balances[_to] + _value >= balances[_to]
73         ) {
74             balances[_to] += _value;
75             balances[_from] -= _value;
76             if (allowance < MAX_UINT) {
77                 allowed[_from][msg.sender] -= _value;
78             }
79             Transfer(_from, _to, _value);
80             return true;
81         } else {
82             return false;
83         }
84     }
85 }
86 
87 contract MYOUToken is UnboundedRegularToken {
88 
89     uint public totalSupply = 9.99999999*10**26;
90     uint8 constant public decimals = 18;
91     string constant public name = "MYOUToken";
92     string constant public symbol = "MYOU";
93 
94     function MYOUToken() {
95         balances[msg.sender] = totalSupply;
96         Transfer(address(0), msg.sender, totalSupply);
97     }
98 }