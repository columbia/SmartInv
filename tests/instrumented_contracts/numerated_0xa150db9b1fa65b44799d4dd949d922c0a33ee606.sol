1 contract EIP20Interface {
2     /// total amount of tokens
3     uint256 public totalSupply;
4 
5     /// @param _owner The address from which the balance will be retrieved
6     /// @return The balance
7     function balanceOf(address _owner) public view returns (uint256 balance);
8 
9     /// @notice send `_value` token to `_to` from `msg.sender`
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) public returns (bool success);
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
21 
22     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of tokens to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) public returns (bool success);
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
32 
33     // solhint-disable-next-line no-simple-event-func-name
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 pragma solidity ^0.4.26;
39 
40 contract DigitalReserveCurrency is EIP20Interface {
41 
42     uint256 constant private MAX_UINT256 = 2**256 - 1;
43     mapping (address => uint256) public balances;
44     mapping (address => mapping (address => uint256)) public allowed;
45 
46     string public name;                   
47     uint8 public decimals;                
48     string public symbol;                 
49 
50     constructor(
51         uint256 _initialAmount,
52         string _tokenName,
53         uint8 _decimalUnits,
54         string _tokenSymbol
55     ) public {
56         balances[msg.sender] = _initialAmount;               
57         totalSupply = _initialAmount;                        
58         name = _tokenName;                                   
59         decimals = _decimalUnits;                            
60         symbol = _tokenSymbol;                               
61     }
62 
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         require(balances[msg.sender] >= _value);
65         balances[msg.sender] -= _value;
66         balances[_to] += _value;
67         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         uint256 allowance = allowed[_from][msg.sender];
73         require(balances[_from] >= _value && allowance >= _value);
74         balances[_to] += _value;
75         balances[_from] -= _value;
76         if (allowance < MAX_UINT256) {
77             allowed[_from][msg.sender] -= _value;
78         }
79         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
80         return true;
81     }
82 
83     function balanceOf(address _owner) public view returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool success) {
88         allowed[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
94         return allowed[_owner][_spender];
95     }
96 }