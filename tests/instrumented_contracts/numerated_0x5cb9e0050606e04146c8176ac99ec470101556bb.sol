1 pragma solidity 0.4.21;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 pragma solidity 0.4.21;
5 contract EIP20Interface {
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
36 
37     // solhint-disable-next-line no-simple-event-func-name
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 
44 contract SAFCOIN is EIP20Interface {
45 
46     uint256 constant private MAX_UINT256 = 2**256 - 1;
47     mapping (address => uint256) public balances;
48     mapping (address => mapping (address => uint256)) public allowed;
49   
50     string public name;                   //fancy name: s
51     uint8 public decimals;                //How many decimals to show.
52     string public symbol;                 //An identifier:
53 
54     function SAFCOIN(
55         uint256 _initialAmount,
56         string _tokenName,
57         uint8 _decimalUnits,
58         string _tokenSymbol
59     ) public {
60         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
61         totalSupply = _initialAmount;                        // Update total supply
62         name = _tokenName;                                   // Set the name for display purposes
63         decimals = _decimalUnits;                            // Amount of decimals for display purposes
64         symbol = _tokenSymbol;                               // Set the symbol for display purposes
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         require(balances[msg.sender] >= _value);
69         balances[msg.sender] -= _value;
70         balances[_to] += _value;
71         emit Transfer(msg.sender, _to, _value); 
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         uint256 allowance = allowed[_from][msg.sender];
77         require(balances[_from] >= _value && allowance >= _value);
78         balances[_to] += _value;
79         balances[_from] -= _value;
80         if (allowance < MAX_UINT256) {
81             allowed[_from][msg.sender] -= _value;
82         }
83         emit Transfer(_from, _to, _value); 
84         return true;
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value); 
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 }