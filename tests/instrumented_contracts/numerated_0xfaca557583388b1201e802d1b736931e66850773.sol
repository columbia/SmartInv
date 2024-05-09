1 pragma solidity 0.4.25;
2 
3 contract Token {
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint _value);
36     event Approval(address indexed _owner, address indexed _spender, uint _value);
37 }
38 
39 contract RegularToken is Token {
40 
41     function transfer(address _to, uint _value) returns (bool) {
42         //Default assumes totalSupply can't be over max (2^256 - 1).
43         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function transferFrom(address _from, address _to, uint _value) returns (bool) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) constant returns (uint) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint _value) returns (bool) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) constant returns (uint) {
72         return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint) balances;
76     mapping (address => mapping (address => uint)) allowed;
77     uint public totalSupply;
78 }
79 
80 contract UnboundedRegularToken is RegularToken {
81 
82     uint constant MAX_UINT = 2**256 - 1;
83     
84     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
85     /// @param _from Address to transfer from.
86     /// @param _to Address to transfer to.
87     /// @param _value Amount to transfer.
88     /// @return Success of transfer.
89     function transferFrom(address _from, address _to, uint _value)
90         public
91         returns (bool)
92     {
93         uint allowance = allowed[_from][msg.sender];
94         if (balances[_from] >= _value
95             && allowance >= _value
96             && balances[_to] + _value >= balances[_to]
97         ) {
98             balances[_to] += _value;
99             balances[_from] -= _value;
100             if (allowance < MAX_UINT) {
101                 allowed[_from][msg.sender] -= _value;
102             }
103             Transfer(_from, _to, _value);
104             return true;
105         } else {
106             return false;
107         }
108     }
109 }
110 
111 contract TEA is UnboundedRegularToken {
112 
113     uint public totalSupply = 99e16;
114     uint8 constant public decimals = 8;
115     string constant public name = "TEA";
116     string constant public symbol = "TEA";
117 
118     function TEA() {
119         balances[msg.sender] = totalSupply;
120         Transfer(address(0), msg.sender, totalSupply);
121     }
122 }