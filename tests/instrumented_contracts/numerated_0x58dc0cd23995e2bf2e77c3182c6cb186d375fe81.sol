1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint _value);
35     event Approval(address indexed _owner, address indexed _spender, uint _value);
36 }
37 
38 contract RegularToken is Token {
39 
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
80 
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
110 contract LianBaoCoin is UnboundedRegularToken {
111 
112     uint public totalSupply = 18*10**27;
113     uint8 constant public decimals = 18;
114     string constant public name = "LianBaoCoin";
115     string constant public symbol = "LBC";
116 
117     function LianBaoCoin() {
118         balances[msg.sender] = totalSupply;
119         Transfer(address(0), msg.sender, totalSupply);
120     }
121 }