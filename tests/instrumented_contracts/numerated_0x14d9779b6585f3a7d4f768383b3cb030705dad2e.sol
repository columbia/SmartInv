1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 /*
6 You should inherit from TokenBase. This implements ONLY the standard functions obeys ERC20,
7 and NOTHING else. If you deploy this, you won't have anything useful.
8 
9 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
10 .*/
11 contract ERC20 {
12 
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant public returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract TokenBase is ERC20 {
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         // Prevent transfer to 0x0 address.
51         require(_to != 0x0);
52         // Check if the sender has enough
53         require(balances[msg.sender] >= _value);
54         // Check for overflows
55         require(balances[_to] + _value > balances[_to]);
56 
57         uint previousBalances = balances[msg.sender] + balances[_to];
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balances[msg.sender] + balances[_to] == previousBalances);
63 
64         return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         /// same as above
69         require(_to != 0x0);
70         require(balances[_from] >= _value);
71         require(balances[_to] + _value > balances[_to]);
72 
73         uint previousBalances = balances[_from] + balances[_to];
74         balances[_from] -= _value;
75         balances[_to] += _value;
76         allowed[_from][msg.sender] -= _value;
77         Transfer(_from, _to, _value);
78         assert(balances[_from] + balances[_to] == previousBalances);
79 
80         return true;
81     }
82 
83     function balanceOf(address _owner) constant public returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
94       return allowed[_owner][_spender];
95     }
96 
97     mapping (address => uint256) balances; /// balance amount of tokens for address
98     mapping (address => mapping (address => uint256)) allowed;
99 }
100 
101 contract BAI20 is TokenBase {
102 
103     function () payable public {
104         //if ether is sent to this address, send it back.
105         //throw;
106         require(false);
107     }
108 
109     string public constant name = "BAI2.0";
110     string public constant symbol = "BAI";
111     uint256 private constant _INITIAL_SUPPLY = 21000000000;
112     uint8 public decimals = 18;
113     uint256 public totalSupply;
114     string public version = "BAI2.0";
115 
116     function BAI20(
117     ) public {
118         // init
119         totalSupply = _INITIAL_SUPPLY * 10 ** 18;
120         balances[msg.sender] = totalSupply;
121     }
122 
123     /* Approves and then calls the receiving contract */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 }