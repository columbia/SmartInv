1 pragma solidity ^0.4.18;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     // solhint-disable-next-line no-simple-event-func-name  
46     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract IDH is EIP20Interface {
52 
53     uint256 constant private MAX_UINT256 = 2**256 - 1;
54     mapping (address => uint256) public balances;
55     mapping (address => mapping (address => uint256)) public allowed;
56     /*
57     NOTE:
58     The following variables are OPTIONAL vanities. One does not have to include them.
59     They allow one to customise the token contract & in no way influences the core functionality.
60     Some wallets/interfaces might not even bother to look at this information.
61     */
62     string public name;                   //fancy name: eg Simon Bucks
63     uint8 public decimals;                //How many decimals to show.
64     string public symbol;                 //An identifier: eg SBX
65 
66     function IDH() public {
67         balances[msg.sender] = (10 ** 8 * 5) * (10 ** 18);               // Give the creator all initial tokens
68         totalSupply = (10 ** 8 * 5) * (10 ** 18);                        // Update total supply
69         name = 'Identity Hub Token';                                            // Set the name for display purposes
70         decimals = 18;                                                   // Amount of decimals for display purposes
71         symbol = 'IDHUB';                                                  // Set the symbol for display purposes
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         require(balances[msg.sender] >= _value);
76         require(balances[_to] + _value >= balances[_to]);
77         balances[msg.sender] -= _value;
78         balances[_to] += _value;
79         Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         uint256 allowance = allowed[_from][msg.sender];
85         require(balances[_from] >= _value && allowance >= _value);
86         require(balances[_to] + _value >= balances[_to]);
87         balances[_to] += _value;
88         balances[_from] -= _value;
89         if (allowance < MAX_UINT256) {
90             allowed[_from][msg.sender] -= _value;
91         }
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function balanceOf(address _owner) public view returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     }   
109 }