1 /*
2 This is the ROY Ethereum smart contract
3 
4 ROY Implements the EIP20 token standard: https://github.com/ethereum/EIPs/issues/20
5 
6 The smart contract code can be viewed here: https://github.com/UdotCASH/ROY-ERC20.git
7 
8 For more info about ROY and the U.CASH ecosystem, visit https://u.cash
9 .*/
10 
11 pragma solidity ^0.4.8;
12 
13 contract JEY{
14     /* This is a slight change to the ERC20 base standard.
15     function totalSupply() constant returns (uint256 supply);
16     is replaced with:
17     uint256 public totalSupply;
18     This automatically creates a getter function for the totalSupply.
19     This is moved to the base contract since public getter functions are not
20     currently recognised as an implementation of the matching abstract
21     function by the compiler.
22     */
23     /// total amount of tokens
24     uint256 public totalSupply;
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) constant returns (uint256 balance);
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of tokens to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
56 }
57 
58 
59 contract JEYCoinContract is JEY{
60 
61     uint256 constant MAX_UINT256 = 2**256 - 1;
62 
63 
64     string public name;
65     uint8 public decimals;
66     string public symbol;
67 
68      function JEY(
69 
70         ) public {
71         totalSupply = 700000000;               //ROY totalSupply
72         balances[msg.sender] = totalSupply;         //Allocate ROY to contract deployer
73         name = "JEY";
74         decimals = 8;                               //Amount of decimals for display purposes
75         symbol = "JEY";
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         require(balances[msg.sender] >= _value);
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         uint256 allowance = allowed[_from][msg.sender];
88         require(balances[_from] >= _value && allowance >= _value);
89         balances[_to] += _value;
90         balances[_from] -= _value;
91         if (allowance < MAX_UINT256) {
92             allowed[_from][msg.sender] -= _value;
93         }
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function balanceOf(address _owner) constant returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender)
109     constant returns (uint256 remaining) {
110       return allowed[_owner][_spender];
111     }
112 
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115 }