1 pragma solidity 0.4.19;
2 
3 contract Token {
4     function totalSupply() constant returns (uint supply) {}
5     function balanceOf(address _owner) constant returns (uint balance) {}
6     function transfer(address _to, uint _value) returns (bool success) {}
7     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
8     function approve(address _spender, uint _value) returns (bool success) {}
9     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
10 
11     event Transfer(address indexed _from, address indexed _to, uint _value);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 contract StandardToken is Token {
16 
17     function transfer(address _to, uint _value) returns (bool) {
18         //Default assumes totalSupply can't be over max (2^256 - 1).
19         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint _value) returns (bool) {
28         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
29             balances[_to] += _value;
30             balances[_from] -= _value;
31             allowed[_from][msg.sender] -= _value;
32             Transfer(_from, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint _value) returns (bool) {
42         allowed[msg.sender][_spender] = _value;
43         Approval(msg.sender, _spender, _value);
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant returns (uint) {
48         return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint) balances;
52     mapping (address => mapping (address => uint)) allowed;
53     uint public totalSupply;
54 }
55 
56 contract UnlimitedAllowanceToken is StandardToken {
57 
58     uint constant MAX_UINT = 2**256 - 1;
59     
60     function transferFrom(address _from, address _to, uint _value)
61         public
62         returns (bool)
63     {
64         uint allowance = allowed[_from][msg.sender];
65         if (balances[_from] >= _value
66             && allowance >= _value
67             && balances[_to] + _value >= balances[_to]
68         ) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             if (allowance < MAX_UINT) {
72                 allowed[_from][msg.sender] -= _value;
73             }
74             Transfer(_from, _to, _value);
75             return true;
76         } else {
77             return false;
78         }
79     }
80 }
81 
82 contract DMarketToken is UnlimitedAllowanceToken {
83 
84     uint8 constant public decimals = 18;
85     uint public totalSupply = 10**27; // 1 billion tokens, 18 decimal places
86     string constant public name = "DMarket";
87     string constant public symbol = "DMT";
88 
89     function DMarketToken() {
90         balances[msg.sender] = totalSupply;
91     }
92 }