1 /**
2 
3 ██╗    ██╗██████╗ ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗ ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗███████╗    ██████╗ ██████╗ ███╗   ███╗
4 ██║    ██║██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝   ██╔════╝██╔═══██╗████╗ ████║
5 ██║ █╗ ██║██████╔╝███████╗██╔████╔██║███████║██████╔╝   ██║   ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║   ███████╗   ██║     ██║   ██║██╔████╔██║
6 ██║███╗██║██╔═══╝ ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║   ╚════██║   ██║     ██║   ██║██║╚██╔╝██║
7 ╚███╔███╔╝██║     ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║   ███████║██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
8  ╚══╝╚══╝ ╚═╝     ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝
9 
10 Blockchain Made Easy
11 
12 http://wpsmartcontracts.com/
13 
14 */
15 
16 pragma solidity ^0.5.7;
17 
18 contract IRC20Vanilla {
19     /* This is a slight change to the ERC20 base standard.
20     function totalSupply() constant returns (uint256 supply);
21     is replaced with:
22     uint256 public totalSupply;
23     This automatically creates a getter function for the totalSupply.
24     This is moved to the base contract since public getter functions are not
25     currently recognised as an implementation of the matching abstract
26     function by the compiler.
27     */
28     /// total amount of tokens
29     uint256 public totalSupply;
30 
31     /// @param _owner The address from which the balance will be retrieved
32     /// @return The balance
33     function balanceOf(address _owner) public view returns (uint256 balance);
34 
35     /// @notice send `_value` token to `_to` from `msg.sender`
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transfer(address _to, uint256 _value) public returns (bool success);
40 
41     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
42     /// @param _from The address of the sender
43     /// @param _to The address of the recipient
44     /// @param _value The amount of token to be transferred
45     /// @return Whether the transfer was successful or not
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47 
48     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
49     /// @param _spender The address of the account able to transfer the tokens
50     /// @param _value The amount of tokens to be approved for transfer
51     /// @return Whether the approval was successful or not
52     function approve(address _spender, uint256 _value) public returns (bool success);
53 
54     /// @param _owner The address of the account owning tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @return Amount of remaining tokens allowed to spent
57     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
58 
59     // solhint-disable-next-line no-simple-event-func-name
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 contract ERC20Vanilla is IRC20Vanilla {
65 
66     uint256 constant private MAX_UINT256 = 2**256 - 1;
67     mapping (address => uint256) public balances;
68     mapping (address => mapping (address => uint256)) public allowed;
69     /*
70     NOTE:
71     The following variables are OPTIONAL vanities. One does not have to include them.
72     They allow one to customise the token contract & in no way influences the core functionality.
73     Some wallets/interfaces might not even bother to look at this information.
74     */
75     string public name;                   //fancy name: eg Simon Bucks
76     uint8 public decimals;                //How many decimals to show.
77     string public symbol;                 //An identifier: eg SBX
78 
79     constructor(address _manager, uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol
80     ) public {
81         balances[_manager] = _initialAmount;               // Give the creator all initial tokens
82         totalSupply = _initialAmount;                        // Update total supply
83         name = _tokenName;                                   // Set the name for display purposes
84         decimals = _decimalUnits;                            // Amount of decimals for display purposes
85         symbol = _tokenSymbol;                               // Set the symbol for display purposes
86     }
87 
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         require(balances[msg.sender] >= _value);
90         balances[msg.sender] -= _value;
91         balances[_to] += _value;
92         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         uint256 allowance = allowed[_from][msg.sender];
98         require(balances[_from] >= _value && allowance >= _value);
99         balances[_to] += _value;
100         balances[_from] -= _value;
101         if (allowance < MAX_UINT256) {
102             allowed[_from][msg.sender] -= _value;
103         }
104         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
105         return true;
106     }
107 
108     function balanceOf(address _owner) public view returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122 }