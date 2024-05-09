1 pragma solidity ^0.4.26;
2 
3 contract ERC20Token {
4 	mapping (address => uint256) balances;
5 	address public owner;
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9 	// total amount of tokens
10     uint256 public totalSupply;
11 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
12     mapping (address => mapping (address => uint256)) allowed;
13 
14     constructor() public {
15         uint256 initialSupply = 10000000000;
16         totalSupply = initialSupply * 10 ** uint256(decimals);
17         balances[msg.sender] = totalSupply;
18         name = "Game Chain";
19         symbol = "GMI";
20     }
21 	
22     /// @param _owner The address from which the balance will be retrieved
23     /// @return The balance
24     function balanceOf(address _owner) public constant returns (uint256 balance) {
25 		 return balances[_owner];
26 	}
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33 	    require(_value > 0 );                                      // Check send token value > 0;
34 		require(balances[msg.sender] >= _value);                   // Check if the sender has enough
35         require(balances[_to] + _value > balances[_to]);           // Check for overflows											
36 		balances[msg.sender] -= _value;                            // Subtract from the sender
37 		balances[_to] += _value;                                   // Add the same to the recipient                       
38 		 
39 		emit Transfer(msg.sender, _to, _value); 			       // Notify anyone listening that this transfer took place
40 		return true;      
41 	}
42 
43     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
44     /// @param _from The address of the sender
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49 	  
50 	    require(balances[_from] >= _value);                 // Check if the sender has enough
51         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
52         require(_value <= allowed[_from][msg.sender]);      // Check allowance
53         balances[_from] -= _value;                         // Subtract from the sender
54         balances[_to] += _value;                           // Add the same to the recipient
55         allowed[_from][msg.sender] -= _value;
56         emit Transfer(_from, _to, _value);
57         return true;
58 	}
59 
60     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @param _value The amount of tokens to be approved for transfer
63     /// @return Whether the approval was successful or not
64     function approve(address _spender, uint256 _value) public returns (bool success) {
65 		require(balances[msg.sender] >= _value);
66 		allowed[msg.sender][_spender] = _value;
67         emit Approval(msg.sender, _spender, _value);
68 		return true;
69 	
70 	}
71 	
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77 	}
78 	
79 	/* This unnamed function is called whenever someone tries to send ether to it */
80     function () private {
81         revert();     // Prevents accidental sending of ether
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
86 }