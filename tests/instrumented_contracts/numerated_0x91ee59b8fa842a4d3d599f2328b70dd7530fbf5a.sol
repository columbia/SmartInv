1 pragma solidity ^0.4.16;
2 
3 contract MSERToken {
4     // Public variables of the token
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     // 18 decimals is the strongly suggested default, avoid changing it
9     uint256 public totalSupply;
10 
11     // This creates an array with all balances
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14     mapping (address => string) public  keys;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     // This notifies clients about the amount burnt
19     event Burn(address indexed from, uint256 value);
20 
21     /**
22      * Constrctor function
23      *
24      * Initializes contract with initial supply tokens to the creator of the contract
25      */
26     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
27         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
28         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
29         name = tokenName;                                   // Set the name for display purposes
30         symbol = tokenSymbol;                               // Set the symbol for display purposes
31     }
32 
33     /**
34      * Internal transfer, only can be called by this contract
35      */
36     function _transfer(address _from, address _to, uint _value) internal {
37         // Prevent transfer to 0x0 address. Use burn() instead
38         require(_to != 0x0);
39         // Check if the sender has enough
40         require(balanceOf[_from] >= _value);
41         // Check for overflows
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         // Save this for an assertion in the future
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45         // Subtract from the sender
46         balanceOf[_from] -= _value;
47         // Add the same to the recipient
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         // Asserts are used to use static analysis to find bugs in your code. They should never fail
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     /**
55      * Transfer tokens
56      *
57      * Send `_value` tokens to `_to` from your account
58      *
59      * @param _to The address of the recipient
60      * @param _value the amount to send
61      */
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     /**
67      * Transfer tokens from other address
68      *
69      * Send `_value` tokens to `_to` in behalf of `_from`
70      *
71      * @param _from The address of the sender
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         require(_value <= allowance[_from][msg.sender]);     // Check allowance
77         allowance[_from][msg.sender] -= _value;
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     /**
83      * Set allowance for other address
84      *
85      * Allows `_spender` to spend no more than `_value` tokens in your behalf
86      *
87      * @param _spender The address authorized to spend
88      * @param _value the max amount they can spend
89      */
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /**
96      * Destroy tokens
97      *
98      * Remove `_value` tokens from the system irreversibly
99      *
100      * @param _value the amount of money to burn
101      */
102     function burn(uint256 _value) public returns (bool success) {
103         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
104 
105         balanceOf[msg.sender] -= _value;            // Subtract from the sender
106         totalSupply -= _value;                      // Updates totalSupply
107         emit Burn(msg.sender, _value);
108         
109         return true;
110     }
111 
112 }