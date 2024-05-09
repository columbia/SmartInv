1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.21;
7 
8 contract EIP20Interface {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     // solhint-disable-next-line no-simple-event-func-name
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 contract Suren3Token is EIP20Interface {
55 
56     uint256 constant private MAX_UINT256 = 2**256 - 1;
57     mapping (address => uint256) public balances;
58     mapping (address => mapping (address => uint256)) public allowed;
59     /*
60     NOTE:
61     The following variables are OPTIONAL vanities. One does not have to include them.
62     They allow one to customise the token contract & in no way influences the core functionality.
63     Some wallets/interfaces might not even bother to look at this information.
64     */
65     string public name;                   //fancy name: eg Simon Bucks
66     uint8 public decimals;                //How many decimals to show.
67     string public symbol;                 //An identifier: eg SBX
68 
69     function Suren3Token() public {
70         balances[msg.sender] = 22000000;               // Give the creator all initial tokens
71         totalSupply = 22000000;                        // Update total supply
72         name = "Suren3Token";                                   // Set the name for display purposes
73         decimals = 18;                            // Amount of decimals for display purposes
74         symbol = "Suren3";                               // Set the symbol for display purposes
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         require(balances[msg.sender] >= _value);
79         balances[msg.sender] -= _value;
80         balances[_to] += _value;
81         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         uint256 allowance = allowed[_from][msg.sender];
87         require(balances[_from] >= _value && allowance >= _value);
88         balances[_to] += _value;
89         balances[_from] -= _value;
90         if (allowance < MAX_UINT256) {
91             allowed[_from][msg.sender] -= _value;
92         }
93         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
94         return true;
95     }
96 
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 }