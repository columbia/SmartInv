1 pragma solidity 0.4.24;
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
40     function transfer(address _to, uint _value) returns (bool) {
41         //Default assumes totalSupply can't be over max (2^256 - 1).
42         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { 
48             return false; 
49         }
50     }
51 
52     function transferFrom(address _from, address _to, uint _value) returns (bool) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { 
60             return false; 
61         }
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
84     uint constant MAX_UINT = 2**256 - 1;
85     
86     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
87     /// @param _from Address to transfer from.
88     /// @param _to Address to transfer to.
89     /// @param _value Amount to transfer.
90     /// @return Success of transfer.
91     function transferFrom(address _from, address _to, uint _value)
92         public
93         returns (bool)
94     {
95         uint allowance = allowed[_from][msg.sender];
96         if (balances[_from] >= _value
97             && allowance >= _value
98             && balances[_to] + _value >= balances[_to]
99         ) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             if (allowance < MAX_UINT) {
103                 allowed[_from][msg.sender] -= _value;
104             }
105             Transfer(_from, _to, _value);
106             return true;
107         } else {
108             return false;
109         }
110     }
111 }
112 
113 contract ZoomToken is UnboundedRegularToken {
114 
115     uint public totalSupply = 100*10**26;
116     uint8 constant public decimals = 18;
117     string constant public name = "ZoomToken";
118     string constant public symbol = "ZOOM";
119 
120     function ZoomToken() {
121         balances[msg.sender] = totalSupply;
122         Transfer(address(0), msg.sender, totalSupply);
123     }
124 }