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
16 
17 // Abstract contract for the full ERC 20 Token standard
18 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
19 pragma solidity ^0.5.7;
20 
21 
22 contract IRC20Vanilla {
23     /* This is a slight change to the ERC20 base standard.
24     function totalSupply() constant returns (uint256 supply);
25     is replaced with:
26     uint256 public totalSupply;
27     This automatically creates a getter function for the totalSupply.
28     This is moved to the base contract since public getter functions are not
29     currently recognised as an implementation of the matching abstract
30     function by the compiler.
31     */
32     /// total amount of tokens
33     uint256 public totalSupply;
34 
35     /// @param _owner The address from which the balance will be retrieved
36     /// @return The balance
37     function balanceOf(address _owner) public view returns (uint256 balance);
38 
39     /// @notice send `_value` token to `_to` from `msg.sender`
40     /// @param _to The address of the recipient
41     /// @param _value The amount of token to be transferred
42     /// @return Whether the transfer was successful or not
43     function transfer(address _to, uint256 _value) public returns (bool success);
44 
45     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
46     /// @param _from The address of the sender
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51 
52     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
53     /// @param _spender The address of the account able to transfer the tokens
54     /// @param _value The amount of tokens to be approved for transfer
55     /// @return Whether the approval was successful or not
56     function approve(address _spender, uint256 _value) public returns (bool success);
57 
58     /// @param _owner The address of the account owning tokens
59     /// @param _spender The address of the account able to transfer the tokens
60     /// @return Amount of remaining tokens allowed to spent
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
62 
63     // solhint-disable-next-line no-simple-event-func-name
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 contract ERC20Vanilla is IRC20Vanilla {
69 
70     uint256 constant private MAX_UINT256 = 2**256 - 1;
71     mapping (address => uint256) public balances;
72     mapping (address => mapping (address => uint256)) public allowed;
73     /*
74     NOTE:
75     The following variables are OPTIONAL vanities. One does not have to include them.
76     They allow one to customise the token contract & in no way influences the core functionality.
77     Some wallets/interfaces might not even bother to look at this information.
78     */
79     string public name;                   //fancy name: eg Simon Bucks
80     uint8 public decimals;                //How many decimals to show.
81     string public symbol;                 //An identifier: eg SBX
82 
83     constructor(address _manager, uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol
84     ) public {
85         balances[_manager] = _initialAmount;               // Give the creator all initial tokens
86         totalSupply = _initialAmount;                        // Update total supply
87         name = _tokenName;                                   // Set the name for display purposes
88         decimals = _decimalUnits;                            // Amount of decimals for display purposes
89         symbol = _tokenSymbol;                               // Set the symbol for display purposes
90     }
91 
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         require(balances[msg.sender] >= _value);
94         balances[msg.sender] -= _value;
95         balances[_to] += _value;
96         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
97         return true;
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         uint256 allowance = allowed[_from][msg.sender];
102         require(balances[_from] >= _value && allowance >= _value);
103         balances[_to] += _value;
104         balances[_from] -= _value;
105         if (allowance < MAX_UINT256) {
106             allowed[_from][msg.sender] -= _value;
107         }
108         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
109         return true;
110     }
111 
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126 }