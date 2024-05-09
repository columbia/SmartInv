1 pragma solidity ^0.4.21;
2 
3 contract BaseToken {
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
18     function balanceOf(address _owner) public view returns (uint256 balance);
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
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract Token is BaseToken {
50     uint256 constant private MAX_UINT256 = 2**256 - 1;
51     mapping (address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) public allowed;
53     
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         require(balances[msg.sender] >= _value);
56         balances[msg.sender] -= _value;
57         balances[_to] += _value;
58         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         uint256 allowance = allowed[_from][msg.sender];
64         require(balances[_from] >= _value && allowance >= _value);
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         if (allowance < MAX_UINT256) {
68             allowed[_from][msg.sender] -= _value;
69         }
70         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
71         return true;
72     }
73 
74     function balanceOf(address _owner) public view returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
85         return allowed[_owner][_spender];
86     }
87 }
88 
89 contract BSK is Token {
90     /*
91     NOTE:
92     The following variables are OPTIONAL vanities. One does not have to include them.
93     They allow one to customise the token contract & in no way influences the core functionality.
94     Some wallets/interfaces might not even bother to look at this information.
95     */
96     string public name;                   //fancy name: eg Simon Bucks
97     uint8 public decimals;                //How many decimals to show.
98     string public symbol;                 //An identifier: eg SBX
99 
100     constructor(uint256 _initialAmount,
101         string _tokenName,
102         uint8 _decimalUnits,
103         string _tokenSymbol) public  {
104         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
105         totalSupply = _initialAmount;                        // Update total supply
106         name = _tokenName;                                   // Set the name for display purposes
107         decimals = _decimalUnits;                            // Amount of decimals for display purposes
108         symbol = _tokenSymbol;                               // Set the symbol for display purposes
109     }
110 
111     /* Approves and then calls the receiving contract */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115 
116         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
117         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
118         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
119         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
120         return true;
121     }
122 }