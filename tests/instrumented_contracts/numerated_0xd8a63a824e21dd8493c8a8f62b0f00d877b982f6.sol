1 contract EIP20Interface {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) public view returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) public returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
41 
42     // solhint-disable-next-line no-simple-event-func-name
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract LooisToken is EIP20Interface {
48     uint256 constant private MAX_UINT256 = 2**256 - 1;
49     mapping (address => uint256) public balances;
50     mapping (address => mapping (address => uint256)) public allowed;
51     /*
52     NOTE:
53     The following variables are OPTIONAL vanities. One does not have to include them.
54     They allow one to customise the token contract & in no way influences the core functionality.
55     Some wallets/interfaces might not even bother to look at this information.
56     */
57     string public name;                   //fancy name: eg Simon Bucks
58     uint8 public decimals;                //How many decimals to show.
59     string public symbol;                 //An identifier: eg SBX
60 
61     function LooisToken(
62         uint256 _initialAmount,
63         string _tokenName,
64         uint8 _decimalUnits,
65         string _tokenSymbol
66     ) public {
67         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
68         totalSupply = _initialAmount;                        // Update total supply
69         name = _tokenName;                                   // Set the name for display purposes
70         decimals = _decimalUnits;                            // Amount of decimals for display purposes
71         symbol = _tokenSymbol;                               // Set the symbol for display purposes
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         require(balances[msg.sender] >= _value);
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
79         return true;
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         uint256 allowance = allowed[_from][msg.sender];
84         require(balances[_from] >= _value && allowance >= _value);
85         balances[_to] += _value;
86         balances[_from] -= _value;
87         if (allowance < MAX_UINT256) {
88             allowed[_from][msg.sender] -= _value;
89         }
90         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }
107 }