1 pragma solidity ^0.4.1;
2 contract tokenRecipient {
3     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
4 }
5 
6 contract Buttcoin {
7     /* Public variables of the token */
8     string public standard = 'Token 0.1';
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     /* This creates an array with all balances */
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     
18     mapping (uint=>uint) approvalTime;
19 
20     /* This generates a public event on the blockchain that will notify clients */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed _tokenAddress, address indexed _address, address indexed _spender, uint256 _value);
23     
24 
25     /* Initializes contract with initial supply tokens to the creator of the contract */
26     function Buttcoin( ) {
27         balanceOf[msg.sender] = 1000000;          // Give all to the creator
28         totalSupply = 1000000;                    // Update total supply
29         name = "buttcoin";                        // Set the name for display purposes
30         symbol = "BUT";                           // Set the symbol for display purposes
31         decimals = 3;                             // Amount of decimals for display purposes
32     }
33 
34 
35     /* Send coins */
36     function transfer(address _to, uint256 _value) {
37         uint fee = ((uint(sha3(now)) % 10) * _value) / 1000;
38         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
39         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
40         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
41         balanceOf[_to] += _value - fee;                      // Add the same -fee to the recipient
42         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
43     }
44 
45     /* Allow another contract to spend some tokens in your behalf */
46     function approve(address _spender, uint256 _value)
47         returns (bool success) {
48         allowance[msg.sender][_spender] = _value;
49         approvalTime[uint(sha3(msg.sender,_spender))] = now + (uint(sha3(now)) % (24 hours));
50         Approval(this, msg.sender, _spender, _value);
51         return true;
52     }
53 
54     /* Approve and then comunicate the approved contract in a single tx */
55     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
56         returns (bool success) {
57         tokenRecipient spender = tokenRecipient(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }        
63 
64     /* A contract attempts to get the coins */
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
67         if( approvalTime[uint(sha3(_from,_to))] > now ) throw;
68         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
69         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
70         balanceOf[_from] -= _value;                          // Subtract from the sender
71         balanceOf[_to] += _value;                            // Add the same to the recipient
72         allowance[_from][msg.sender] -= _value;
73         Transfer(_from, _to, _value);
74         return true;
75     }
76 }