1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, February 27, 2019
3  (UTC) */
4 
5 // Abstract contract for the full ERC 20 Token standard
6 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
7 pragma solidity ^0.4.25;
8 
9 contract Token {
10 
11     /// @return total amount of tokens
12     function totalSupply() constant returns (uint supply) {}
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint balance) {}
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint _value) returns (bool success) {}
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
30 
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint _value) returns (bool success) {}
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
41 
42     event Transfer(address indexed _from, address indexed _to, uint _value);
43     event Approval(address indexed _owner, address indexed _spender, uint _value);
44 }
45 
46 contract RegularToken is Token {
47 
48     function transfer(address _to, uint _value) returns (bool) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint _value) returns (bool) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint _value) returns (bool) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint) {
79         return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint) balances;
83     mapping (address => mapping (address => uint)) allowed;
84     uint public totalSupply;
85 }
86 
87 contract UnboundedRegularToken is RegularToken {
88 
89     uint constant MAX_UINT = 2**256 - 1;
90     
91     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
92     /// @param _from Address to transfer from.
93     /// @param _to Address to transfer to.
94     /// @param _value Amount to transfer.
95     /// @return Success of transfer.
96     function transferFrom(address _from, address _to, uint _value)
97         public
98         returns (bool)
99     {
100         uint allowance = allowed[_from][msg.sender];
101         if (balances[_from] >= _value
102             && allowance >= _value
103             && balances[_to] + _value >= balances[_to]
104         ) {
105             balances[_to] += _value;
106             balances[_from] -= _value;
107             if (allowance < MAX_UINT) {
108                 allowed[_from][msg.sender] -= _value;
109             }
110             Transfer(_from, _to, _value);
111             return true;
112         } else {
113             return false;
114         }
115     }
116 }
117 
118 contract CNCToken is UnboundedRegularToken {
119 
120     uint public totalSupply = 21*10**26;
121     uint8 constant public decimals = 18;
122     string constant public name = "Coinance coin";
123     string constant public symbol = "CNC";
124 
125     function CNCToken() {
126         balances[msg.sender] = totalSupply;
127         Transfer(address(0), msg.sender, totalSupply);
128     }
129 }