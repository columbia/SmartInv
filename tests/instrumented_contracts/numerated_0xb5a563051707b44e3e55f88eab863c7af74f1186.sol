1 pragma solidity 0.4.19;
2 contract Token {
3 
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
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint _value) returns (bool) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     function balanceOf(address _owner) constant returns (uint) {
61         return balances[_owner];
62     }
63 
64     function approve(address _spender, uint _value) returns (bool) {
65         allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint) {
71         return allowed[_owner][_spender];
72     }
73 
74     mapping (address => uint) balances;
75     mapping (address => mapping (address => uint)) allowed;
76     uint public totalSupply;
77 }
78 
79 contract UnboundedRegularToken is RegularToken {
80     uint constant MAX_UINT = 2**256 - 1;
81 
82     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
83     /// @param _from Address to transfer from.
84     /// @param _to Address to transfer to.
85     /// @param _value Amount to transfer.
86     /// @return Success of transfer.
87     function transferFrom(address _from, address _to, uint _value)
88         public
89         returns (bool)
90     {
91         uint allowance = allowed[_from][msg.sender];
92         if (balances[_from] >= _value
93             && allowance >= _value
94             && balances[_to] + _value >= balances[_to]
95         ) {
96             balances[_to] += _value;
97             balances[_from] -= _value;
98             if (allowance < MAX_UINT) {
99                 allowed[_from][msg.sender] -= _value;
100             }
101             Transfer(_from, _to, _value);
102             return true;
103         } else {
104             return false;
105         }
106     }
107 }
108 
109 contract RTCToken is UnboundedRegularToken {
110     uint public totalSupply = 0.668*10**26;
111     uint8 constant public decimals = 18;
112     string constant public name = "RTCToken";
113     string constant public symbol = "RTC";
114 
115     function RTCToken() {
116         balances[msg.sender] = totalSupply;
117         Transfer(address(0), msg.sender, totalSupply);
118     }
119 }