1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16     //How many decimals to show.
17     uint256 public decimals;
18     
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name  
48     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 contract EIP20Token is EIP20Interface{
54 
55     uint256 constant private MAX_UINT256 = 2**256 - 1;
56     mapping (address => uint256) private balances;
57     mapping (address => mapping (address => uint256)) public allowed;
58        
59     string public name;                             //fancy name: eg Alex Cabrera 
60     string public symbol;                           //An identifier: eg ACG
61      
62     function EIP20Token() public {  
63         name = "LEX Coin";                        // Set the name for display purposes
64         decimals = 18;                              // Amount of decimals for display purposes
65         symbol = "LEXC";                            // Set the symbol for display purposes
66           
67         totalSupply = 100000000 * 10 ** decimals;               // Update total supply
68         balances[msg.sender] = totalSupply;         // Give the creator all initial tokens 
69     } 
70      
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         require(balances[msg.sender] >= _value);
73         balances[msg.sender] -= _value;
74         balances[_to] += _value;
75         emit Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         uint256 allowance = allowed[_from][msg.sender];
81         require(balances[_from] >= _value && allowance >= _value);
82         balances[_to] += _value;
83         balances[_from] -= _value;
84         if (allowance < MAX_UINT256) {
85             allowed[_from][msg.sender] -= _value;
86         }
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function balanceOf(address _owner) public view returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
102         return allowed[_owner][_spender];
103     }   
104 	 
105 }