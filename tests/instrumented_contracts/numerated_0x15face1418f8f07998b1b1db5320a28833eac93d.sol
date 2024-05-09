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
43         //Default assumes totalSupply can't be over max (2^256 - 1).
44         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint _value) returns (bool) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) constant returns (uint) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint _value) returns (bool) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) constant returns (uint) {
73         return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint) balances;
77     mapping (address => mapping (address => uint)) allowed;
78     uint public totalSupply;
79 }
80 
81 contract UnboundedRegularToken is RegularToken {
82 
83     uint constant MAX_UINT = 2**256 - 1;
84     
85     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
86     /// @param _from Address to transfer from.
87     /// @param _to Address to transfer to.
88     /// @param _value Amount to transfer.
89     /// @return Success of transfer.
90     function transferFrom(address _from, address _to, uint _value)
91         public
92         returns (bool)
93     {
94         uint allowance = allowed[_from][msg.sender];
95         if (balances[_from] >= _value
96             && allowance >= _value
97             && balances[_to] + _value >= balances[_to]
98         ) {
99             balances[_to] += _value;
100             balances[_from] -= _value;
101             if (allowance < MAX_UINT) {
102                 allowed[_from][msg.sender] -= _value;
103             }
104             Transfer(_from, _to, _value);
105             return true;
106         } else {
107             return false;
108         }
109     }
110 }
111 
112 contract HCPTToken is UnboundedRegularToken {
113 
114     uint public totalSupply = 60*10**26;
115     uint8 constant public decimals = 18;
116     string constant public name = "Hash Computing Power Token";
117     string constant public symbol = "HCPT";
118 
119     function HCPTToken() {
120         balances[msg.sender] = totalSupply;
121         Transfer(address(0), msg.sender, totalSupply);
122     }
123 }