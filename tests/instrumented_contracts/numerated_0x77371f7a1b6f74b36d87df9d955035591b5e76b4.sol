1 pragma solidity ^0.5.0;
2 
3 // File: contracts\interface\TokenRecipient.sol
4 
5 /// 代币接口
6 interface TokenRecipient {
7 
8     /// 授权合约使用代币
9     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes calldata _extraData) external;
10 }
11 
12 // File: contracts\SECToken.sol
13 
14 // Abstract contract for the full ERC 20 Token standard
15 // https://github.com/ethereum/EIPs/issues/20
16 
17 contract Token {
18     /* This is a slight change to the ERC20 base standard.
19     function totalSupply() constant returns (uint256 supply);
20     is replaced with:
21     uint256 public totalSupply;
22     This automatically creates a getter function for the totalSupply.
23     This is moved to the base contract since public getter functions are not
24     currently recognised as an implementation of the matching abstract
25     function by the compiler.
26     */
27     /// total amount of tokens
28     uint256 public totalSupply;
29 
30     /// @param _owner The address from which the balance will be retrieved
31     /// @return The balance
32     function balanceOf(address _owner) public view returns (uint256 balance);
33 
34     /// @notice send `_value` token to `_to` from `msg.sender`
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transfer(address _to, uint256 _value) public returns (bool success);
39 
40     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41     /// @param _from The address of the sender
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46 
47     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @param _value The amount of wei to be approved for transfer
50     /// @return Whether the approval was successful or not
51     function approve(address _spender, uint256 _value) public returns (bool success);
52 
53     /// @param _owner The address of the account owning tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @return Amount of remaining tokens allowed to spent
56     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 /*
63 You should inherit from StandardToken or, for a token like you would want to
64 deploy in something like Mist, see HumanStandardToken.sol.
65 (This implements ONLY the standard functions and NOTHING else.
66 If you deploy this, you won't have anything useful.)
67 
68 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
69 .*/
70 
71 contract StandardToken is Token {
72 
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         //Default assumes totalSupply can't be over max (2^256 - 1).
75         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
76         //Replace the if with this one instead.
77         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78         if (balances[msg.sender] >= _value && _value > 0) {
79             balances[msg.sender] -= _value;
80             balances[_to] += _value;
81             emit Transfer(msg.sender, _to, _value);
82             return true;
83         } else {
84             return false; 
85         }
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         //same as above. Replace this line with the following if you want to protect against wrapping uints.
90         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92             balances[_to] += _value;
93             balances[_from] -= _value;
94             allowed[_from][msg.sender] -= _value;
95             emit Transfer(_from, _to, _value);
96             return true;
97         } else {
98             return false; 
99         }
100     }
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118 }
119 
120 /*
121 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
122 
123 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
124 Imagine coins, currencies, shares, voting weight, etc.
125 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
126 
127 1) Initial Finite Supply (upon creation one specifies how much is minted).
128 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
129 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
130 
131 .*/
132 
133 contract NtpToken is StandardToken {
134 
135     function () external {
136         //if ether is sent to this address, send it back.
137         revert("fallback not allow used");
138     }
139 
140     /* Public variables of the token */
141 
142     /*
143     NOTE:
144     The following variables are OPTIONAL vanities. One does not have to include them.
145     They allow one to customise the token contract & in no way influences the core functionality.
146     Some wallets/interfaces might not even bother to look at this information.
147     
148     */
149     string public name;                   //fancy name: eg Simon Bucks
150     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
151     string public symbol;                 //An identifier: eg SBX
152     string public version = "H0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
153 
154     constructor () public {
155         // 发币总量 10亿
156         uint _total = 210000000 * (10 ** 18);
157         balances[msg.sender] = _total;               // Give the creator all initial tokens
158         totalSupply = _total;                        // Update total supply
159         name = "Ntimes Plan";                                   // Set the name for display purposes
160         decimals = 18;                            // Amount of decimals for display purposes
161         symbol = "NTP";                               // Set the symbol for display purposes
162     }
163 
164     /* Approves and then calls the receiving contract */
165     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public {
166 
167         approve(_spender, _value);
168 
169         TokenRecipient(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
170     }
171 }