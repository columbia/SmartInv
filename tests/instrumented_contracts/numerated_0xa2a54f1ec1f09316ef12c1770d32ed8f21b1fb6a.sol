1 pragma solidity ^0.4.11;
2 contract DFT{
3 	mapping (address => uint256) balances;
4 	address public owner;
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8 	uint256 public lockAmount ;
9     uint256 public startTime ;
10 	// total amount of tokens
11     uint256 public totalSupply;
12 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
13     mapping (address => mapping (address => uint256)) allowed;
14     
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     function DFT() public { 
19         owner = 0x7f29c275bB8903f233D90edBF88402F216aEdC05;          // Set owner of contract 
20 		startTime = 1521129600;
21         name = "DFT";                                   // Set the name for display purposes
22         symbol = "DFT";                                           // Set the symbol for display purposes
23         decimals = 8;                                            // Amount of decimals for display purposes
24 		totalSupply = 210000000000000000;               // Total supply
25 		balances[owner] = totalSupply;
26         Transfer(msg.sender, owner, totalSupply);
27     }
28 	
29     /// @param _owner The address from which the balance will be retrieved
30     /// @return The balance
31     function balanceOf(address _owner) public constant returns (uint256 balance) {
32 		 return balances[_owner];
33 	}
34 
35     /// @notice send `_value` token to `_to` from `msg.sender`
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transfer(address _to, uint256 _value) public payable returns (bool success) {
40 	    require(_value > 0 );                                      // Check send token value > 0;
41 		require(balances[msg.sender] >= _value);
42 		balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         Transfer(msg.sender, _to, _value);
45         return true;
46 	}
47 
48     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49     /// @param _from The address of the sender
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transferFrom(address _from, address _to, uint256 _value) public payable returns (bool success) {
54 	    require(balances[_from] >= _value);                 // Check if the sender has enough
55         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
56         require(_value <= allowed[_from][msg.sender]);      // Check allowance
57 		balances[_from] -= _value;
58         balances[_to] += _value;
59 		allowed[_from][_to] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62 	}
63 
64     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @param _value The amount of tokens to be approved for transfer
67     /// @return Whether the approval was successful or not
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69 		require(balances[msg.sender] >= _value);
70 		allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72 		return true;
73 	}
74 	
75     /// @param _owner The address of the account owning tokens
76     /// @param _spender The address of the account able to transfer the tokens
77     /// @return Amount of remaining tokens allowed to spent
78     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80 	}
81 	
82 	/* This unnamed function is called whenever someone tries to send ether to it */
83     function () private {
84         revert();     // Prevents accidental sending of ether
85     }
86 	
87 }