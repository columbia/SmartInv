1 pragma solidity ^0.4.15;
2 
3  
4 
5 contract SAUBAERtoken  {
6     string public constant symbol = "SAUBAER";
7     string public constant name = "SAUBAER";
8     uint8 public constant decimals = 1;
9 	// Owner of the contract
10 	address public owner;
11 	// Total supply of tokens
12 	uint256 _totalSupply = 100000;
13 	// Ledger of the balance of the account
14 	mapping (address => uint256) balances;
15 	// Owner of account approuves the transfert of an account to another account
16     mapping (address => mapping (address => uint256)) allowed;
17     
18      
19     // Triggered when tokens are transferred
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     
22     // Triggered whenever approve(address _spender, uint256 _value) is called.
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25     // Constructor
26     function SAUBAERtoken() {
27          owner = msg.sender;
28          balances[owner] = _totalSupply;
29      }
30 
31 
32     
33     // SEND TOKEN: Transfer amount _value from the addr calling function to address _to
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         // Check if the value is autorized
36         if (balances[msg.sender] >= _value && _value > 0) {
37             // Decrease the sender balance
38             balances[msg.sender] -= _value;
39             // Increase the sender balance
40             balances[_to] += _value;
41             // Trigger the Transfer event
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46  
47    
48 
49 
50 }