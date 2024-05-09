1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.21;
4 
5 contract EIP20Interface {
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
46     // solhint-disable-next-line no-simple-event-func-name
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 contract XiaoliangToken is EIP20Interface {
53 
54     uint256 constant private MAX_UINT256 = 2**256 - 1;
55     mapping (address => uint256) public balances;
56     mapping (address => mapping (address => uint256)) public allowed;
57     /*
58     NOTE:
59     The following variables are OPTIONAL vanities. One does not have to include them.
60     They allow one to customise the token contract & in no way influences the core functionality.
61     Some wallets/interfaces might not even bother to look at this information.
62     */
63     string public name;                   //fancy name: eg Simon Bucks
64     uint8 public decimals;                //How many decimals to show.
65     string public symbol;                 //An identifier: eg SBX
66 
67     constructor () public {
68         totalSupply = 21 * (10**8) * (10**8);                        // Update total supply
69         balances[msg.sender] = totalSupply;
70         name = "XiaoliangToken";                                   // Set the name for display purposes
71         decimals = 8;                            // Amount of decimals for display purposes
72         symbol = "XLT";                               // Set the symbol for display purposes
73     }
74 
75     function transfer(address _to, uint256 _value) public returns (bool success) {
76         require(balances[msg.sender] >= _value);
77         balances[msg.sender] -= _value;
78         balances[_to] += _value;
79         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
80         return true;
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         uint256 allowance = allowed[_from][msg.sender];
85         require(balances[_from] >= _value && allowance >= _value);
86         balances[_to] += _value;
87         balances[_from] -= _value;
88         if (allowance < MAX_UINT256) {
89             allowed[_from][msg.sender] -= _value;
90         }
91         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
92         return true;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
106         return allowed[_owner][_spender];
107     }
108 }