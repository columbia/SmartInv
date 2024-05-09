1 pragma solidity ^0.4.8;
2 
3  
4 
5 contract MUMUtoken  {
6     string public constant symbol = "MUMUS";
7     string public constant name = "Mumus4all";
8     uint8 public constant decimals = 1;
9 	// Owner of the contract
10 	address public owner;
11 	// Total supply of tokens
12 	uint256 _totalSupply = 1000000;
13 	// Ledger of the balance of the account
14 	mapping (address => uint256) balances;
15 	// Owner of account approuves the transfert of an account to another account
16     mapping (address => mapping (address => uint256)) allowed;
17     
18     // Events can be trigger when certain actions happens
19     // Triggered when tokens are transferred
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     
22     // Triggered whenever approve(address _spender, uint256 _value) is called.
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     
25     // Constructor
26     function MUMUtoken() {
27          owner = msg.sender;
28          balances[owner] = _totalSupply;
29      }
30 
31     // Transfert the amont _value from the address calling the function to address _to
32     function transfer(address _to, uint256 _value) returns (bool success) {
33         // Check if the value is autorized
34         if (balances[msg.sender] >= _value && _value > 0) {
35             // Decrease the sender balance
36             balances[msg.sender] -= _value;
37             // Increase the sender balance
38             balances[_to] += _value;
39             // Trigger the Transfer event
40             Transfer(msg.sender, _to, _value);
41             return true;
42         } else { return false; }
43     }
44 
45     
46 
47      // Transfert 
48     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
49 
50         // if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         } else { return false; }
58     }
59 
60     // Return the balance of an account
61     function balanceOf(address _owner) constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     // Autorize the address _spender to transfer from the account msg.sender
66     function approve(address _spender, uint256 _value) returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     // Return the amont of allowance
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 
77 }