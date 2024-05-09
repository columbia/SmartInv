1 pragma solidity ^0.4.17;
2 
3 contract Token {
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) public returns (bool success);
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 /*
38 This implements ONLY the standard functions and NOTHING else.
39 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
40 
41 If you deploy this, you won't have anything useful.
42 
43 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
44 .*/
45 
46 
47 
48 
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             emit Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             emit Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) public view returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     uint256 public totalSupply;
94 }
95 
96 /*
97 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
98 
99 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
100 Imagine coins, currencies, shares, voting weight, etc.
101 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
102 
103 1) Initial Finite Supply (upon creation one specifies how much is minted).
104 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
105 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
106 
107 .*/
108 
109 
110 
111 
112 contract PiedPiperNetworkCoin is StandardToken {
113 
114     function () public {
115         //if ether is sent to this address, send it back.
116         revert();
117     }
118 
119     /* Public variables of the token */
120 
121     string public name = "PiedPiperNetwork Coin";
122     uint8 public decimals = 18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
123     string public symbol = "PPN";                 //An identifier
124 
125     function PiedPiperNetworkCoin() public {
126         totalSupply = 330300 * (10 ** uint256(decimals));                        // Update total supply
127         balances[0x973286f6e84BDd60438F5fad182a96De9E6cb66E] = totalSupply;
128     }
129 
130     /* Approves and then calls the receiving contract */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134 
135         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
136         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
137         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
138         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
139         return true;
140     }
141 }