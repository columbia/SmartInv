1 pragma solidity ^0.4.16;
2 
3 contract TKT_TokenERC20 {
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
19      * Constrctor function
20      *
21      * Initializes contract with initial supply tokens to the creator of the contract
22      */
23     function TKT_TokenERC20(
24         uint256 initialSupply,
25         string tokenName,
26         string tokenSymbol
27     ) public {
28         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
29         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
30         name = tokenName;                                   // Set the name for display purposes
31         symbol = tokenSymbol;                               // Set the symbol for display purposes
32     }
33 
34     /**
35      * Internal transfer, only can be called by this contract
36      */
37     function _transfer(address _from, address _to, uint _value) internal {
38         // Prevent transfer to 0x0 address. Use burn() instead
39         require(_to != 0x0);
40         // Check if the sender has enough
41         require(balanceOf[_from] >= _value);
42         // Check for overflows
43         require(balanceOf[_to] + _value > balanceOf[_to]);
44         // Save this for an assertion in the future
45         uint previousBalances = balanceOf[_from] + balanceOf[_to];
46         // Subtract from the sender
47         balanceOf[_from] -= _value;
48         // Add the same to the recipient
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51         // Asserts are used to use static analysis to find bugs in your code. They should never fail
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55     /**
56      * Transfer tokens
57      *
58      * Send `_value` tokens to `_to` from your account
59      *
60      * @param _to The address of the recipient
61      * @param _value the amount to send
62      */
63     function transfer(address _to, uint256 _value) public {
64         _transfer(msg.sender, _to, _value);
65     }
66 
67     /**
68      * Transfer tokens from other address
69      *
70      * Send `_value` tokens to `_to` in behalf of `_from`
71      *
72      * @param _from The address of the sender
73      * @param _to The address of the recipient
74      * @param _value the amount to send
75      */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     /**
84      * Set allowance for other address
85      *
86      * Allows `_spender` to spend no more than `_value` tokens in your behalf
87      *
88      * @param _spender The address authorized to spend
89      * @param _value the max amount they can spend
90      */
91     function approve(address _spender, uint256 _value) public
92         returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         return true;
95     }
96 }