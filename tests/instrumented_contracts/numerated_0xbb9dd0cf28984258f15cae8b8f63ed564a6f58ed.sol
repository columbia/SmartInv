1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) public view returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 contract StandardToken is Token {
51 
52     uint256 constant MAX_UINT256 = 2**256 - 1;
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
59         require(balances[msg.sender] >= _value);
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         //same as above. Replace this line with the following if you want to protect against wrapping uints.
68         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
69         uint256 allowance = allowed[_from][msg.sender];
70         require(balances[_from] >= _value && allowance >= _value);
71         balances[_to] += _value;
72         balances[_from] -= _value;
73         if (allowance < MAX_UINT256) {
74             allowed[_from][msg.sender] -= _value;
75         }
76         Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) view public returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }
97 
98 contract ProgrammersTestToken is StandardToken {
99     string public name = "Programmers' Test Token";
100     uint8 public decimals = 0;
101     string public symbol = 'PTT';
102     uint256 public totalSupply = 500000000;
103     
104     function ProgrammersTestToken() public {
105         balances[msg.sender] = totalSupply;                         // Set the symbol for display purposes
106     }
107     
108     
109 }