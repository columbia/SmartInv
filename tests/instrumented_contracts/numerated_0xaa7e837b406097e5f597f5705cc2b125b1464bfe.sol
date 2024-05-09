1 /**
2  * Source Code first verified at https://etherscan.io on Friday, may 13, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.16;
6 
7 contract Marble {
8     // Public variables of the token
9     string public name = "Marble";
10     string public symbol = "MARBLE";
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 
15     // This creates an array with all balances
16     mapping(address => uint256) public balanceOf;
17     mapping(address => mapping(address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constrctor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     constructor (
31         uint256 initialSupply
32     ) public {
33         totalSupply = initialSupply * 10 ** uint256(decimals);
34         // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;
36         // Give the creator all initial tokens
37     }
38 
39     /**
40      * Transfer tokens
41      *
42      * Send `_value` tokens to `_to` from your account
43      *
44      * @param _to The address of the recipient
45      * @param _value the amount to send
46      */
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70 
71     }
72     /**
73      * Get balance for an address
74      *
75      * Returns the balance of given address
76      *
77      * @param _owner The address to return
78      */
79     function balanceOf(address _owner) public constant returns (uint256 _balance) {
80         return balanceOf[_owner];
81     }
82 
83     /**
84      * Destroy tokens
85      *
86      * Remove `_value` tokens from the system irreversibly
87      *
88      * @param _value the amount of money to burn
89      */
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         // Check if the sender has enough
93         balanceOf[msg.sender] -= _value;
94         // Subtract from the sender
95         totalSupply -= _value;
96         // Updates totalSupply
97         emit Burn(msg.sender, _value);
98         return true;
99     }
100 }