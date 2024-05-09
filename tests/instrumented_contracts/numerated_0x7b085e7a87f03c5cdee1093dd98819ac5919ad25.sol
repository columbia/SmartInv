1 pragma solidity 0.4.19;
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
41 
42     function transfer(address _to, uint _value) returns (bool) {
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
111 contract NEBlockchain is UnboundedRegularToken {
112 
113     uint public totalSupply = 10*10**17;
114     uint8 constant public decimals = 8;
115     string constant public name = "New Energy BlockChain Token";
116     string constant public symbol = "NEB";
117 
118     function NEBlockchain() {
119         balances[msg.sender] = totalSupply;
120         Transfer(address(0), msg.sender, totalSupply);
121     }
122 }