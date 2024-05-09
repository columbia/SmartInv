1 pragma solidity 0.4.24;
2 
3 contract Token {
4 
5   
6     function totalSupply() constant returns (uint supply) {}
7 
8     function balanceOf(address _owner) constant returns (uint balance) {}
9     
10     function transfer(address _to, uint _value) returns (bool success) {}
11 
12     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
13 
14     function approve(address _spender, uint _value) returns (bool success) {}
15 
16     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
17 
18     event Transfer(address indexed _from, address indexed _to, uint _value);
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20 }
21 
22 contract RegularToken is Token {
23 
24     function transfer(address _to, uint _value) returns (bool) {
25         //Default assumes totalSupply can't be over max (2^256 - 1).
26             require (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             emit Transfer(msg.sender, _to, _value);
30             return true;
31     }
32 
33     function transferFrom(address _from, address _to, uint _value) returns (bool) {
34             require (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             emit  Transfer(_from, _to, _value);
39             return true;
40        
41     }
42 
43     function balanceOf(address _owner) constant returns (uint) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint _value) returns (bool) {
48         allowed[msg.sender][_spender] = _value;
49         emit Approval(msg.sender, _spender, _value);
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
66  
67     function transferFrom(address _from, address _to, uint _value) public returns (bool)
68     {
69         uint allowance = allowed[_from][msg.sender];
70         require (balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]); 
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             if (allowance < MAX_UINT) {
74                 allowed[_from][msg.sender] -= _value;
75             }
76             emit Transfer(_from, _to, _value);
77             return true;
78       
79     }
80 }
81 
82 contract Dkey is UnboundedRegularToken {
83 
84     uint public totalSupply = 260000000000000000000000000;
85     uint8 constant public decimals = 18;
86     string constant public name = "Dkey";
87     string constant public symbol = "Dkey";
88 
89     constructor() {
90         balances[msg.sender] = totalSupply;
91         emit Transfer(address(0), msg.sender, totalSupply);
92     }
93 }