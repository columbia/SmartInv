1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract MinerToken {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 6;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function MinerToken(
29         
30     ) public {
31         totalSupply = 10000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
33         name = "MinerToken";                                   // Set the name for display purposes
34         symbol = "MIT";                               // Set the symbol for display purposes
35     }
36     function transfer(address _to, uint256 _value) {
37         /* Check if sender has balance and for overflows */
38         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
39 
40         /* Add and subtract new balances */
41         balanceOf[msg.sender] -= _value;
42         balanceOf[_to] += _value;
43     }
44 
45     
46 
47     /**
48      * Set allowance for other address
49      *
50      * Allows `_spender` to spend no more than `_value` tokens on your behalf
51      *
52      * @param _spender The address authorized to spend
53      * @param _value the max amount they can spend
54      */
55     function approve(address _spender, uint256 _value) public
56         returns (bool success) {
57         allowance[msg.sender][_spender] = _value;
58         return true;
59     }
60 
61     /**
62      * Set allowance for other address and notify
63      *
64      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
65      *
66      * @param _spender The address authorized to spend
67      * @param _value the max amount they can spend
68      * @param _extraData some extra information to send to the approved contract
69      */
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 
80    
81 }