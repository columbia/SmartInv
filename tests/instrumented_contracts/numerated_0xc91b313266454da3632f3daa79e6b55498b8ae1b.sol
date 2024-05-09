1 pragma solidity 0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // 'COLT' 'COLONERToken' token contract
5 //
6 // Symbol      : COLT
7 // Name        : COLONER Token
8 // Total supply: 900,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Passion;Creative;Intergation.
12 //
13 // (c) KT TEAM / PENTAGON Blockchain Solution 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 contract Token {
17 
18     /// @return total amount of tokens
19     function totalSupply() constant returns (uint supply) {}
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant returns (uint balance) {}
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint _value) returns (bool success) {}
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint _value) returns (bool success) {}
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
48 
49     event Transfer(address indexed _from, address indexed _to, uint _value);
50     event Approval(address indexed _owner, address indexed _spender, uint _value);
51 }
52 
53 contract RegularToken is Token {
54 
55     function transfer(address _to, uint _value) returns (bool) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint _value) returns (bool) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint _value) returns (bool) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint) {
86         return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint) balances;
90     mapping (address => mapping (address => uint)) allowed;
91     uint public totalSupply;
92 }
93 
94 contract UnboundedRegularToken is RegularToken {
95 
96     uint constant MAX_UINT = 2**256 - 1;
97     
98     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
99     /// @param _from Address to transfer from.
100     /// @param _to Address to transfer to.
101     /// @param _value Amount to transfer.
102     /// @return Success of transfer.
103     function transferFrom(address _from, address _to, uint _value)
104         public
105         returns (bool)
106     {
107         uint allowance = allowed[_from][msg.sender];
108         if (balances[_from] >= _value
109             && allowance >= _value
110             && balances[_to] + _value >= balances[_to]
111         ) {
112             balances[_to] += _value;
113             balances[_from] -= _value;
114             if (allowance < MAX_UINT) {
115                 allowed[_from][msg.sender] -= _value;
116             }
117             Transfer(_from, _to, _value);
118             return true;
119         } else {
120             return false;
121         }
122     }
123 }
124 
125 contract COLONERToken is UnboundedRegularToken {
126 
127     uint public totalSupply = 9*10**26;
128     uint8 constant public decimals = 18;
129     string constant public name = "COLONERToken";
130     string constant public symbol = "COLT";
131 
132     function COLONERToken() {
133         balances[msg.sender] = totalSupply;
134         Transfer(address(0), msg.sender, totalSupply);
135     }
136 }