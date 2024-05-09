1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.25;
4 
5 contract Token {
6 
7     /// @return total amount of tokens
8     function totalSupply() constant returns (uint supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) constant returns (uint balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint _value) returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint _value) returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 }
41 
42 contract RegularToken is Token {
43 
44     function transfer(address _to, uint _value) returns (bool) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint _value) returns (bool) {
55         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
56             balances[_to] += _value;
57             balances[_from] -= _value;
58             allowed[_from][msg.sender] -= _value;
59             Transfer(_from, _to, _value);
60             return true;
61         } else { return false; }
62     }
63 
64     function balanceOf(address _owner) constant returns (uint) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint _value) returns (bool) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint) {
75         return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint) balances;
79     mapping (address => mapping (address => uint)) allowed;
80     uint public totalSupply;
81 }
82 
83 contract UnboundedRegularToken is RegularToken {
84 
85     uint constant MAX_UINT = 2**256 - 1;
86     
87     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
88     /// @param _from Address to transfer from.
89     /// @param _to Address to transfer to.
90     /// @param _value Amount to transfer.
91     /// @return Success of transfer.
92     function transferFrom(address _from, address _to, uint _value)
93         public
94         returns (bool)
95     {
96         uint allowance = allowed[_from][msg.sender];
97         if (balances[_from] >= _value
98             && allowance >= _value
99             && balances[_to] + _value >= balances[_to]
100         ) {
101             balances[_to] += _value;
102             balances[_from] -= _value;
103             if (allowance < MAX_UINT) {
104                 allowed[_from][msg.sender] -= _value;
105             }
106             Transfer(_from, _to, _value);
107             return true;
108         } else {
109             return false;
110         }
111     }
112 }
113 
114 contract CFlyToken is UnboundedRegularToken {
115 
116     uint public totalSupply = 100*10**26;
117     uint8 constant public decimals = 18;
118     string constant public name = "CodingFly Token";
119     string constant public symbol = "CFLY";
120 
121     function CFlyToken() {
122         balances[msg.sender] = totalSupply;
123         Transfer(address(0), msg.sender, totalSupply);
124     }
125 }