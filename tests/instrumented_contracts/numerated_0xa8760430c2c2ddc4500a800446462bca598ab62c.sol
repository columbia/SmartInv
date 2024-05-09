1 /*
2  ****************************************************************************************************************************
3  *          ╦ ╦┌─┐┬  ┌─┐┌─┐┌┬┐┌─┐  ┌─────────────────────────┐  ╔═╗┌─┐┬  ┬┌┬┐┬┌┬┐┬ ┬
4  *          ║║║├┤ │  │  │ ││││├┤   │   https://metatron.vip  │  ╚═╗│ ││  │ │││ │ └┬┘ 
5  *          ╚╩╝└─┘└─┘└─┘└─┘┴ ┴└─┘  └─┬─────────────────────┬─┘  ╚═╝└─┘┴─┘┴─┴┘┴ ┴  ┴ 
6  *   ┌───────────────────────────────┘                     └─────────────────────────────────┐
7  *   │                        ╔═╗┌─┐┬  ┬┌┬┐┬┌┬┐┬ ┬   ╔╦╗┌─┐┌─┐┬┌─┐┌┐┌                        │
8  *   │                        ╚═╗│ ││  │ │││ │ └┬┘ ═  ║║├┤ └─┐││ ┬│││                        │
9  *   │                        ╚═╝└─┘┴─┘┴─┴┘┴ ┴  ┴    ═╩╝└─┘└─┘┴└─┘┘└┘                        │
10  *   │    ┌──────────┐           ┌─────────────┐            ┌─────────┐        ┌────────┐    │
11  *   └────┤ Metatron ├───────────┤ Singularity ├────────────┤ Penrose ├────────┤   MTM  ├────┘
12  *        └──────────┘           └─────────────┘            └─────────┘        └────────┘
13  ******************************************************************************************************************************
14 */
15 
16 pragma solidity 0.4.19;
17 
18 contract Token {
19 
20     /// @return total amount of tokens
21     function totalSupply() constant returns (uint supply) {}
22 
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) constant returns (uint balance) {}
26 
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint _value) returns (bool success) {}
32 
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
39 
40     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of wei to be approved for transfer
43     /// @return Whether the approval was successful or not
44     function approve(address _spender, uint _value) returns (bool success) {}
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
50 
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 }
54 
55 contract RegularToken is Token {
56 
57     function transfer(address _to, uint _value) returns (bool) {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint _value) returns (bool) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) constant returns (uint) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint _value) returns (bool) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint) {
88         return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint) balances;
92     mapping (address => mapping (address => uint)) allowed;
93     uint public totalSupply;
94 }
95 
96 contract UnboundedRegularToken is RegularToken {
97 
98     uint constant MAX_UINT = 2**256 - 1;
99     
100     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
101     /// @param _from Address to transfer from.
102     /// @param _to Address to transfer to.
103     /// @param _value Amount to transfer.
104     /// @return Success of transfer.
105     function transferFrom(address _from, address _to, uint _value)
106         public
107         returns (bool)
108     {
109         uint allowance = allowed[_from][msg.sender];
110         if (balances[_from] >= _value
111             && allowance >= _value
112             && balances[_to] + _value >= balances[_to]
113         ) {
114             balances[_to] += _value;
115             balances[_from] -= _value;
116             if (allowance < MAX_UINT) {
117                 allowed[_from][msg.sender] -= _value;
118             }
119             Transfer(_from, _to, _value);
120             return true;
121         } else {
122             return false;
123         }
124     }
125 }
126 
127 contract MetatronToken is UnboundedRegularToken {
128 
129     uint public totalSupply = 1*10**26;
130     uint8 constant public decimals = 18;
131     string constant public name = "MetatronToken";
132     string constant public symbol = "MTM";
133 
134     function MetatronToken() {
135         balances[msg.sender] = totalSupply;
136         Transfer(address(0), msg.sender, totalSupply);
137     }
138 }