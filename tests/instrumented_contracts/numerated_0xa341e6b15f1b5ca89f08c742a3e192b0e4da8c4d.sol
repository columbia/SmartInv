1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract PowerSourceToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
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
23     function PowerSourceToken (
24         ) public {
25         totalSupply = 200000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
27         name = "Power Source Token";                                   // Set the name for display purposes
28         symbol = "PSTA";                               // Set the symbol for display purposes
29     }
30 
31     /**
32      * Internal transfer, only can be called by this contract
33      */
34     function _transfer(address _from, address _to, uint _value) internal {
35         // Prevent transfer to 0x0 address. Use burn() instead
36         require(_to != 0x0);
37         // Check if the sender has enough
38         require(balanceOf[_from] >= _value);
39         // Check for overflows
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41         // Save this for an assertion in the future
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         // Subtract from the sender
44         balanceOf[_from] -= _value;
45         // Add the same to the recipient
46         balanceOf[_to] += _value;
47         Transfer(_from, _to, _value);
48         // Asserts are used to use static analysis to find bugs in your code. They should never fail
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      *
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     /**
65      * Transfer tokens from other address
66      *
67      * Send `_value` tokens to `_to` on behalf of `_from`
68      *
69      * @param _from The address of the sender
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);     // Check allowance
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Set allowance for other address
82      *
83      * Allows `_spender` to spend no more than `_value` tokens on your behalf
84      *
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value) public
89         returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address and notify
96      *
97      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      * @param _extraData some extra information to send to the approved contract
102      */
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104         public
105         returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (approve(_spender, _value)) {
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 }