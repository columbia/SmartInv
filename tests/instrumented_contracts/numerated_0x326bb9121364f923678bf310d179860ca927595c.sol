1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Token ERC20 implementation
5  * @dev Simplified version - Contract allows only Transfer and Burn Tokens
6  * @dev source: https://www.ethereum.org/token
7  */
8 contract ArdexToken {
9     // Public variables of the token
10     string public name;
11     string public symbol;
12     uint8 public decimals = 18;
13     // 18 decimals is the strongly suggested default, avoid changing it
14     uint256 public totalSupply;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     // This notifies clients about the amount burnt
23     event Burn(address indexed from, uint256 value);
24 
25     /**
26      * Constructor function
27      *
28      * Initializes contract with initial supply tokens to the creator of the contract
29      */
30     constructor(uint256 initialSupply, string tokenName, string tokenSymbol)
31         public
32     {
33         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
35         name = tokenName;                                   // Set the name for display purposes
36         symbol = tokenSymbol;                               // Set the symbol for display purposes
37     }
38 
39     /**
40      * Internal transfer, only can be called by this contract
41      */
42     function _transfer(address _from, address _to, uint _value)
43         internal
44     {
45         // Prevent transfer to 0x0 address. Use burn() instead
46         require(_to != 0x0);
47         // Check if the sender has enough
48         require(balanceOf[_from] >= _value);
49         // Check for overflows
50         require(balanceOf[_to] + _value >= balanceOf[_to]);
51         // Save this for an assertion in the future
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         // Subtract from the sender
54         balanceOf[_from] -= _value;
55         // Add the same to the recipient
56         balanceOf[_to] += _value;
57         emit Transfer(_from, _to, _value);
58         // Asserts are used to use static analysis to find bugs in your code. They should never fail
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     /**
63      * Transfer tokens
64      *
65      * Send `_value` tokens to `_to` from your account
66      *
67      * @param _to The address of the recipient
68      * @param _value the amount to send
69      */
70     function transfer(address _to, uint256 _value)
71         public 
72         returns (bool success) 
73     {
74         _transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * Destroy tokens
80      *
81      * Remove `_value` tokens from the system irreversibly
82      *
83      * @param _value the amount of money to burn
84      */
85     function burn(uint256 _value)
86         public
87         returns (bool success)
88     {
89         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
90         balanceOf[msg.sender] -= _value;            // Subtract from the sender
91         totalSupply -= _value;                      // Updates totalSupply
92         emit Burn(msg.sender, _value);
93         return true;
94     }
95 }