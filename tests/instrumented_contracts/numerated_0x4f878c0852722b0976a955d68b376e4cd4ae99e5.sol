1 pragma solidity ^0.4.11;
2 contract WaykiCoin{
3 	mapping (address => uint256) balances;
4 	address public owner;
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8 	// total amount of tokens
9     uint256 public totalSupply;
10 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
11     mapping (address => mapping (address => uint256)) allowed;
12     function WaykiCoin() public { 
13         owner = msg.sender;                                         // Set owner of contract 
14         name = "WaykiCoin";                                         // Set the name for display purposes
15         symbol = "WIC";                                             // Set the symbol for display purposes
16         decimals = 8;                                               // Amount of decimals for display purposes
17 		totalSupply = 21000000000000000;                            // Total supply
18 		balances[owner] = totalSupply;                              // Set owner balance equal totalsupply 
19     }
20 	
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public constant returns (uint256 balance) {
24 		 return balances[_owner];
25 	}
26 
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32 	    require(_value > 0 );                                      // Check send token value > 0;
33 		require(balances[msg.sender] >= _value);                    // Check if the sender has enough
34         require(balances[_to] + _value > balances[_to]);           // Check for overflows											
35 		balances[msg.sender] -= _value;                          // Subtract from the sender
36 		balances[_to] += _value;                                 // Add the same to the recipient                       
37 		 
38 		Transfer(msg.sender, _to, _value); 							// Notify anyone listening that this transfer took place
39 		return true;      
40 	}
41 
42     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43     /// @param _from The address of the sender
44     /// @param _to The address of the recipient
45     /// @param _value The amount of token to be transferred
46     /// @return Whether the transfer was successful or not
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48 	  
49 	    require(balances[_from] >= _value);                 // Check if the sender has enough
50         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
51         require(_value <= allowed[_from][msg.sender]);      // Check allowance
52         balances[_from] -= _value;                         // Subtract from the sender
53         balances[_to] += _value;                           // Add the same to the recipient
54         allowed[_from][msg.sender] -= _value;
55         Transfer(_from, _to, _value);
56         return true;
57 	}
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) public returns (bool success) {
64 		require(balances[msg.sender] >= _value);
65 		allowed[msg.sender][_spender] = _value;
66         Approval(msg.sender, _spender, _value);
67 		return true;
68 	
69 	}
70 	
71     /// @param _owner The address of the account owning tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @return Amount of remaining tokens allowed to spent
74     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76 	}
77 	
78 	/* This unnamed function is called whenever someone tries to send ether to it */
79     function () private {
80         revert();     // Prevents accidental sending of ether
81     }
82 
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }