1 pragma solidity ^0.4.16;
2 
3 /// Once upon a time, the LLU contract is created. The Light Lemon Unicorn (LLU) is a smart contract which provides Magic Lemon Juice for sharing and caring.
4 /// This will be a fun project: To bring and share the World of the Light Lemon Unicorn to everybody who likes to see, visit and experience.
5 /// Main goal of this project is to create, build and see what happens. Let's start with the journey and see where the LLU will be in 3 years. 
6 /// Let the heartiness of the Light Lemon Unicorn and her friends shine upon us!
7 
8 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
9 
10 contract LightLemonUnicorn {
11     // Public variables of the token
12     string public name;
13     string public symbol;
14     uint8 public decimals = 18;
15     // 18 decimals is the strongly suggested default, avoid changing it
16     uint256 public totalSupply;
17 
18     // This creates an array with all balances
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     // This generates a public event on the blockchain that will notify clients
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     
25     // This generates a public event on the blockchain that will notify clients
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 
31     /**
32      * Constructor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract
35      */
36     function LightLemonUnicorn(
37 
38     ) public {
39         totalSupply = 387131517000000000000000000;  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = 387131517000000000000000000;                // Give the creator all initial tokens
41         name = "Light Lemon Unicorn";                              // Set the name for display purposes
42         symbol = "LLU";                               // Set the symbol for display purposes
43     }
44 
45     /**
46      * Internal transfer, only can be called by this contract
47      */
48     function _transfer(address _from, address _to, uint _value) internal {
49         // Prevent transfer to 0x0 address. Use burn() instead
50         require(_to != 0x0);
51         // Check if the sender has enough
52         require(balanceOf[_from] >= _value);
53         // Check for overflows
54         require(balanceOf[_to] + _value >= balanceOf[_to]);
55         // Save this for an assertion in the future
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         emit Transfer(_from, _to, _value);
62         // Asserts are used to use static analysis to find bugs in your code. They should never fail
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64     }
65 
66     /**
67      * Transfer tokens
68      *
69      * Send `_value` tokens to `_to` from your account
70      *
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         _transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80      * Transfer tokens from other address
81      *
82      * Send `_value` tokens to `_to` on behalf of `_from`
83      *
84      * @param _from The address of the sender
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens on your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value) public
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address and notify
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      * @param _extraData some extra information to send to the approved contract
118      */
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120         public
121         returns (bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129 }
130 
131 /// Glad you red this code. It's a shit copy paste code isn't it. Because I am not really good at coding (read: really not good). 
132 /// But if it works, it works right? 
133 /// We hope the messages/feellings the LLU encompasses will reach the people, who will like the concept of Light Lemon Unicorn! Whatever that may be.