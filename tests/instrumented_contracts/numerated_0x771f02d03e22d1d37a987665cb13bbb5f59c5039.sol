1 pragma solidity 0.4.25;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 
40 contract RegularToken is Token {
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
81     uint constant MAX_UINT = 2**256 - 1;
82 
83     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
84     /// @param _from Address to transfer from.
85     /// @param _to Address to transfer to.
86     /// @param _value Amount to transfer.
87     /// @return Success of transfer.
88     function transferFrom(address _from, address _to, uint _value)
89         public
90         returns (bool)
91     {
92         uint allowance = allowed[_from][msg.sender];
93         if (balances[_from] >= _value
94             && allowance >= _value
95             && balances[_to] + _value >= balances[_to]
96         ) {
97             balances[_to] += _value;
98             balances[_from] -= _value;
99             if (allowance < MAX_UINT) {
100                 allowed[_from][msg.sender] -= _value;
101             }
102             Transfer(_from, _to, _value);
103             return true;
104         } else {
105             return false;
106         }
107     }
108 }
109 
110 contract BOSSToken is UnboundedRegularToken {
111     uint public totalSupply = 0.65*10**26;
112     uint8 constant public decimals = 18;
113     string constant public name = "BOSSToken";
114     string constant public symbol = "BOSS";
115 
116     function BOSSToken() {
117         balances[msg.sender] = totalSupply;
118         Transfer(address(0), msg.sender, totalSupply);
119     }
120 }