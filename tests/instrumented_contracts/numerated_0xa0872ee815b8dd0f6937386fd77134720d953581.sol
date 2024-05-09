1 pragma solidity ^0.4.18;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
5 
6 contract Token {
7 
8     /// total amount of tokens
9     uint256 public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) constant public returns (uint256 balance);
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of tokens to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) public returns (bool success);
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 /*
44 You should inherit from StandardToken or, for a token like you would want to
45 deploy in something like Mist, see HumanStandardToken.sol.
46 (This implements ONLY the standard functions and NOTHING else.
47 If you deploy this, you won't have anything useful.)
48 
49 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
50 .*/
51 
52 contract StandardToken is Token {
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         // Prevent transfer to 0x0 address.
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balances[msg.sender] >= _value);
59         // Check for overflows
60         require(balances[_to] + _value > balances[_to]);
61 
62         uint previousBalances = balances[msg.sender] + balances[_to];
63         balances[msg.sender] -= _value;
64         balances[_to] += _value;
65         Transfer(msg.sender, _to, _value);
66         // Asserts are used to use static analysis to find bugs in your code. They should never fail
67         assert(balances[msg.sender] + balances[_to] == previousBalances);
68 
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         /// same as above
74         require(_to != 0x0);
75         require(balances[_from] >= _value);
76         require(balances[_to] + _value > balances[_to]);
77 
78         uint previousBalances = balances[_from] + balances[_to];
79         balances[_from] -= _value;
80         balances[_to] += _value;
81         allowed[_from][msg.sender] -= _value;
82         Transfer(_from, _to, _value);
83         assert(balances[_from] + balances[_to] == previousBalances);
84 
85         return true;
86     }
87 
88     function balanceOf(address _owner) constant public returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint256) balances; /// balance amount of tokens for address
103     mapping (address => mapping (address => uint256)) allowed;
104 }
105 
106 contract EduCoin is StandardToken {
107 
108     function () payable public {
109         //if ether is sent to this address, send it back.
110         //throw;
111         require(false);
112     }
113 
114     string public constant name = "EduCoinToken";   
115     string public constant symbol = "EDU";
116     uint256 private constant _INITIAL_SUPPLY = 15*10**27;
117     uint8 public decimals = 18;         
118     uint256 public totalSupply;            
119     //string public version = 'H0.1';
120 
121     function EduCoin(
122     ) public {
123         // init
124         balances[msg.sender] = _INITIAL_SUPPLY;
125         totalSupply = _INITIAL_SUPPLY;
126        
127     }
128 
129     /* Approves and then calls the receiving contract */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 }