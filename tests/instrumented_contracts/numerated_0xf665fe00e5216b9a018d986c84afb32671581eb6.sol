1 pragma solidity ^0.4.18;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) public returns (bool success);
24 
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30 
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of tokens to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
40 
41     // solhint-disable-next-line no-simple-event-func-name  
42     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 
47 contract WerderCoin is EIP20Interface {
48 
49     uint256 constant private MAX_UINT256 = 2**256 - 1;
50     mapping (address => uint256) public balances;
51     mapping (address => mapping (address => uint256)) public allowed;
52 
53     string public name;
54     uint8 public decimals;
55     string public symbol;
56 
57     function WerderCoin(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public {
58         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
59         totalSupply = _initialAmount;                        // Update total supply
60         name = _tokenName;                                   // Set the name for display purposes
61         decimals = _decimalUnits;                            // Amount of decimals for display purposes
62         symbol = _tokenSymbol;                               // Set the symbol for display purposes
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         require(balances[msg.sender] >= _value);
67         balances[msg.sender] -= _value;
68         balances[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         uint256 allowance = allowed[_from][msg.sender];
75         require(balances[_from] >= _value && allowance >= _value);
76         balances[_to] += _value;
77         balances[_from] -= _value;
78         if (allowance < MAX_UINT256) {
79             allowed[_from][msg.sender] -= _value;
80         }
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function balanceOf(address _owner) public view returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
96         return allowed[_owner][_spender];
97     }   
98 }