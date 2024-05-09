1 // https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol
2 // Abstract contract for the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
4 pragma solidity ^0.4.18;
5 
6 
7 contract EIP20Interface {
8     /* This is a slight change to the ERC20 base standard.
9     function totalSupply() constant returns (uint256 supply);
10     is replaced with:
11     uint256 public totalSupply;
12     This automatically creates a getter function for the totalSupply.
13     This is moved to the base contract since public getter functions are not
14     currently recognised as an implementation of the matching abstract
15     function by the compiler.
16     */
17     /// total amount of tokens
18     uint256 public totalSupply;
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) public view returns (uint256 balance);
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36 
37     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of tokens to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
47 
48     // solhint-disable-next-line no-simple-event-func-name
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 contract EIP20 is EIP20Interface {
54 
55     uint256 constant private MAX_UINT256 = 2**256 - 1;
56     mapping (address => uint256) public balances;
57     mapping (address => mapping (address => uint256)) public allowed;
58     /*
59     NOTE:
60     The following variables are OPTIONAL vanities. One does not have to include them.
61     They allow one to customise the token contract & in no way influences the core functionality.
62     Some wallets/interfaces might not even bother to look at this information.
63     */
64     string public name;                   //fancy name: eg Simon Bucks
65     uint8 public decimals = 8;                //How many decimals to show.
66     string public symbol;                 //An identifier: eg SBX
67 
68     function EIP20(
69         uint256 _initialAmount,
70         string _tokenName,
71         string _tokenSymbol
72     ) public {
73         totalSupply = _initialAmount * 10 ** uint256(decimals); // Update total supply
74         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
75         name = _tokenName;                                   // Set the name for display purposes
76         symbol = _tokenSymbol;                               // Set the symbol for display purposes
77     }
78 
79     function transfer(address _to, uint256 _value) public returns (bool success) {
80         require(balances[msg.sender] >= _value);
81         balances[msg.sender] -= _value;
82         balances[_to] += _value;
83         Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         uint256 allowance = allowed[_from][msg.sender];
89         require(balances[_from] >= _value && allowance >= _value);
90         balances[_to] += _value;
91         balances[_from] -= _value;
92         if (allowance < MAX_UINT256) {
93             allowed[_from][msg.sender] -= _value;
94         }
95         Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
110         return allowed[_owner][_spender];
111     }
112 }