1 pragma solidity >=0.4.22 <0.6.0;
2 contract EIP20Interface {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) public view returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
42 
43     // solhint-disable-next-line no-simple-event-func-name
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract HotDollarsToken is EIP20Interface {
49     uint256 constant private MAX_UINT256 = 2**256 - 1;
50     mapping (address => uint256) public balances;
51     mapping (address => mapping (address => uint256)) public allowed;
52     /*
53     NOTE:
54     The following variables are OPTIONAL vanities. One does not have to include them.
55     They allow one to customise the token contract & in no way influences the core functionality.
56     Some wallets/interfaces might not even bother to look at this information.
57     */
58     string public name;                   //fancy name: eg Simon Bucks
59     uint8 public decimals;                //How many decimals to show.
60     string public symbol;                 //An identifier: eg SBX
61 
62     constructor() public {
63         totalSupply = 3 * 1e28;                        
64         name = "HotDollars Token";                          
65         decimals = 18;                           
66         symbol = "HDS";
67         balances[msg.sender] = totalSupply; 
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(balances[msg.sender] >= _value);
72         balances[msg.sender] -= _value;
73         balances[_to] += _value;
74         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         uint256 allowance = allowed[_from][msg.sender];
80         require(balances[_from] >= _value && allowance >= _value);
81         balances[_to] += _value;
82         balances[_from] -= _value;
83         if (allowance < MAX_UINT256) {
84             allowed[_from][msg.sender] -= _value;
85         }
86         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
87         return true;
88     }
89 
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
101         return allowed[_owner][_spender];
102     }
103 }