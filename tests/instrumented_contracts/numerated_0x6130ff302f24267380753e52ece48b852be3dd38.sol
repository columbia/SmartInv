1 /*
2 	IOB ERC20 token by IOB llc.
3 	IOB token is a Security Token. 
4 	The token holders are qualified to receive dividends from time to time when the dividend distributions are declared by the management.
5 	
6 	As we're exploring the "Same Token, Multiple Offerings and Listings," Token Contract may be updated in the future to meet different local requirements by various jurisdictions and exchanges.
7 */
8 
9 pragma solidity 0.4.23;
10 
11 contract Token {
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
32     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of wei to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(balances[msg.sender] >= _value);
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         emit Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value); 
59         balances[_to] += _value;
60         balances[_from] -= _value;
61         allowed[_from][msg.sender] -= _value;
62         emit Transfer(_from, _to, _value);
63         return true;
64     }
65 
66     function balanceOf(address _owner) public view returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         require(_value == 0 || allowed[msg.sender][_spender] == 0);
72 		allowed[msg.sender][_spender] = _value;
73         emit Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83 }
84 
85 
86 contract HumanStandardToken is StandardToken {
87 
88     /* Public variables of the token */
89 
90     string public name;                   //Token Name is "IOB Token"
91     uint8 public decimals;                //Decimals is 18
92     string public symbol;                 //Token symbol is "IOB"
93     string public version = "H0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
94 
95     constructor (
96         uint256 _initialAmount,
97         string _tokenName,
98         uint8 _decimalUnits,
99         string _tokenSymbol
100         ) public {
101         balances[msg.sender] = _initialAmount;               // Initial Amount = 1,000,000,000 * (10 ** uint256(decimals))
102         totalSupply = _initialAmount;                        // Total supply = 1,000,000,000 * (10 ** uint256(decimals))
103         name = _tokenName;                                   // Set the name to "IOB Token"
104         decimals = _decimalUnits;                            // Amount of decimals for display purposes，set to 18
105         symbol = _tokenSymbol;                               // Set the symbol for display purposes,set to "IOB"
106     }
107 
108 }