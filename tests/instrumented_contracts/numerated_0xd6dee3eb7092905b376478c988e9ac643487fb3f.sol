1 pragma solidity ^0.4.24;
2 
3 contract TokenERC20 {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 18;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     // This generates a public event on the blockchain that will notify clients
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * Constructor function
20      *
21      * Initializes contract with initial supply tokens to the creator of the contract
22      */
23      constructor()
24      public {
25         totalSupply = 210000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
27         name = "SuperConduct";                                   // Set the name for display purposes
28         symbol = "SCT";                               // Set the symbol for display purposes
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35        
36         // Check if the sender has enough
37         require(balanceOf[_from] >= _value);
38         // Check for overflows
39         require(balanceOf[_to] + _value >= balanceOf[_to]);
40         // Save this for an assertion in the future
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         // Subtract from the sender
43         balanceOf[_from] -= _value;
44         // Add the same to the recipient
45         balanceOf[_to] += _value;
46         emit Transfer(_from, _to, _value);
47         // Asserts are used to use static analysis to find bugs in your code. They should never fail
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49     }
50 
51     /**
52      * Transfer tokens
53      *
54      * Send `_value` tokens to `_to` from your account
55      *
56      * @param _to The address of the recipient
57      * @param _value the amount to send
58      */
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
62 
63     /**
64      * Transfer tokens from other address
65      *
66      * Send `_value` tokens to `_to` on behalf of `_from`
67      *
68      * @param _from The address of the sender
69      * @param _to The address of the recipient
70      * @param _value the amount to send
71      */
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_value <= allowance[_from][msg.sender]);     // Check allowance
74         allowance[_from][msg.sender] -= _value;
75         _transfer(_from, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Set allowance for other address
81      *
82      * Allows `_spender` to spend no more than `_value` tokens on your behalf
83      *
84      * @param _spender The address authorized to spend
85      * @param _value the max amount they can spend
86      */
87     function approve(address _spender, uint256 _value) public
88         returns (bool success) {
89         allowance[msg.sender][_spender] = _value;
90         return true;
91     }
92 }