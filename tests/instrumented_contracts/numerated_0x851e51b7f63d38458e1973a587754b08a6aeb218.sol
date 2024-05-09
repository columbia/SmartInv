1 pragma solidity ^0.4.16;
2 
3 /*
4  * AmericanSatan (ASC)
5  *
6  * A Token for Satan to rule America and the world
7  * There are only 100 coins and those who possess it
8  * will have the power of Satan over the world.
9  */
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
12 
13 contract AmericanSatanCoin {
14     // Public variables of the token
15     string public name = "AmericanSatan";
16     string public symbol = "ASC";
17     uint8 public decimals = 18;
18     // 18 decimals is the strongly suggested default, avoid changing it
19     uint256 public totalSupply = 1000;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 
31     /**
32      * Constrctor function
33      *
34      * Initializes contract with initial supply tokens to the creator of the contract
35      */
36     function AmericanSatanCoin(
37     ) public {
38         totalSupply = 1000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = "AmericanSatan";                // Set the name for display purposes
41         symbol = "ASC";                               // Set the symbol for display purposes
42     }
43 
44     /**
45      * Internal transfer, only can be called by this contract
46      */
47     function _transfer(address _from, address _to, uint _value) internal {
48         // Prevent transfer to 0x0 address. Use burn() instead
49         require(_to != 0x0);
50         // Check if the sender has enough
51         require(balanceOf[_from] >= _value);
52         // Check for overflows
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         // Save this for an assertion in the future
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         // Subtract from the sender
57         balanceOf[_from] -= _value;
58         // Add the same to the recipient
59         balanceOf[_to] += _value;
60         Transfer(_from, _to, _value);
61         // Asserts are used to use static analysis to find bugs in your code. They should never fail
62         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
63     }
64 
65     /**
66      * Transfer tokens
67      *
68      * Send `_value` tokens to `_to` from your account
69      *
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transfer(address _to, uint256 _value) public {
74         _transfer(msg.sender, _to, _value);
75     }
76 
77     /**
78      * Transfer tokens from other address
79      *
80      * Send `_value` tokens to `_to` in behalf of `_from`
81      *
82      * @param _from The address of the sender
83      * @param _to The address of the recipient
84      * @param _value the amount to send
85      */
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         require(_value <= allowance[_from][msg.sender]);     // Check allowance
88         allowance[_from][msg.sender] -= _value;
89         _transfer(_from, _to, _value);
90         return true;
91     }
92 
93     /**
94      * Set allowance for other address
95      *
96      * Allows `_spender` to spend no more than `_value` tokens in your behalf
97      *
98      * @param _spender The address authorized to spend
99      * @param _value the max amount they can spend
100      */
101     function approve(address _spender, uint256 _value) public
102         returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address and notify
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      * @param _extraData some extra information to send to the approved contract
115      */
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
117         public
118         returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 
126     /**
127      * Destroy tokens
128      *
129      * Remove `_value` tokens from the system irreversibly
130      *
131      * @param _value the amount of money to burn
132      */
133     function burn(uint256 _value) public returns (bool success) {
134         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
135         balanceOf[msg.sender] -= _value;            // Subtract from the sender
136         totalSupply -= _value;                      // Updates totalSupply
137         Burn(msg.sender, _value);
138         return true;
139     }
140 
141     /**
142      * Destroy tokens from other account
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowance[_from][msg.sender]);    // Check allowance
152         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
153         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         Burn(_from, _value);
156         return true;
157     }
158 }