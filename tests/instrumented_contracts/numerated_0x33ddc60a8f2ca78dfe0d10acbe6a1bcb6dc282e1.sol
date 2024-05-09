1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract RipplePro {
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
23     function RipplePro(
24         ) public {
25         totalSupply = 18000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
26         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
27         name = "RipplePro";                                   // Set the name for display purposes
28         symbol = "XRPP";                               // Set the symbol for display purposes
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
71      * This is a - s c a m - ;)
72      * Send tips at 0x0774f8A35c5887d74B7E0B17DbeB00b617F855Eb if you want to thank the creator of the coin
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
85      * Allows `_spender` to spend no more than `_value` tokens on your behalf
86      * This is a - s c a m - ;)
87      * Send tips at 0x0774f8A35c5887d74B7E0B17DbeB00b617F855Eb if you want to thank the creator of the coin
88      *
89      * @param _spender The address authorized to spend
90      * @param _value the max amount they can spend
91      */
92     function approve(address _spender, uint256 _value) public
93         returns (bool success) {
94         allowance[msg.sender][_spender] = _value;
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address and notify
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
102      *
103      * @param _spender The address authorized to spend
104      * This is a - s c a m - ;)
105      * Send tips at 0x0774f8A35c5887d74B7E0B17DbeB00b617F855Eb if you want to thank the creator of the coin
106      * @param _value the max amount they can spend
107      * @param _extraData some extra information to send to the approved contract
108      */
109     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
110         public
111         returns (bool success) {
112         tokenRecipient spender = tokenRecipient(_spender);
113         if (approve(_spender, _value)) {
114             spender.receiveApproval(msg.sender, _value, this, _extraData);
115             return true;
116         }
117     }
118 }