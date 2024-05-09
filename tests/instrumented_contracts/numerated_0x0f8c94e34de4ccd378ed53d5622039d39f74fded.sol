1 pragma solidity ^0.4.19;
2 
3 contract Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public returns (uint256 balance);
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
42     function allowance(address _owner, address _spender) public returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49 
50     uint256 constant MAX_UINT256 = 2**256 - 1;
51 
52     function transfer(address _to, uint256 _value) public returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
57         require(balances[msg.sender] >= _value);
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         //same as above. Replace this line with the following if you want to protect against wrapping uints.
66         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
67         uint256 allowance = allowed[_from][msg.sender];
68         require(balances[_from] >= _value && allowance >= _value);
69         balances[_to] += _value;
70         balances[_from] -= _value;
71         if (allowance < MAX_UINT256) {
72             allowed[_from][msg.sender] -= _value;
73         }
74         Transfer(_from, _to, _value);
75         return true;
76     }
77 
78     function balanceOf(address _owner) public returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) public returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) public returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 
92     mapping (address => uint256) balances;
93     mapping (address => mapping (address => uint256)) allowed;
94 }
95 
96 contract Faucet {
97     address public owner;
98     StandardToken public token;
99     
100     modifier onlyOwner { if (msg.sender != owner) revert(); _; }
101     
102     function Faucet(address _token) public {
103         owner = msg.sender;
104         
105         require(_token != 0x0);
106         token = StandardToken(_token);
107     }
108     
109     function withdrawAll() public onlyOwner {
110         uint balance = token.balanceOf(this);
111         require(balance > 0);
112         token.transfer(owner, balance);
113     }
114     
115     function () public {
116         uint senderBalance = token.balanceOf(msg.sender);
117         require(senderBalance < 100000);
118         uint diff = 100000 - senderBalance;
119         token.transfer(msg.sender, diff);
120     }
121 }