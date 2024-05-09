1 pragma solidity ^0.4.20;
2 
3 /*
4  * https://www.reddit.com/r/ethtrader/comments/81jmv0/90_of_the_vicetoken_ico_is_fake/ (VICETOKEN_ICO_IS_FAKE)
5  * A Token meant to out ViceToken for 90% fake ICO contributions from AION advisors from Ontario Canada
6  * Tokken MSB AKA ViceToken AKA Shidan Gouran & Steven Nerayoff - AION
7  * 
8  * VICETOKEN LIES: https://www.reddit.com/r/ethtrader/comments/81jmv0/90_of_the_vicetoken_ico_is_fake/
9  * LIARS: https://twitter.com/vitalikbuterin/status/912212689069342720?lang=en
10  */
11 
12 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
13 
14 contract VICETOKEN_ICO_IS_FAKE {
15     // Public variables of the token
16     string public name = "https://www.reddit.com/r/ethtrader/comments/81jmv0/90_of_the_vicetoken_ico_is_fake/";
17     string public symbol = "VICETOKEN_ICO_IS_FAKE";
18     uint8 public decimals = 18;
19     // 18 decimals is the strongly suggested default, avoid changing it
20     uint256 public totalSupply = 1000000000;
21 
22     // This creates an array with all balances
23     mapping (address => uint256) public balanceOf;
24     mapping (address => mapping (address => uint256)) public allowance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     // This notifies clients about the amount burnt
30     event Burn(address indexed from, uint256 value);
31 
32     /**
33      * Constrctor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function VICETOKEN_ICO_IS_FAKE(
38     ) public {
39         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
40         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
41         name = "https://www.reddit.com/r/ethtrader/comments/81jmv0/90_of_the_vicetoken_ico_is_fake/";                // Set the name for display purposes
42         symbol = "VICETOKEN_ICO_IS_FAKE";                               // Set the symbol for display purposes
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
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         // Save this for an assertion in the future
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         // Subtract from the sender
58         balanceOf[_from] -= _value;
59         // Add the same to the recipient
60         balanceOf[_to] += _value;
61         Transfer(_from, _to, _value);
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
74     function transfer(address _to, uint256 _value) public {
75         _transfer(msg.sender, _to, _value);
76     }
77 
78     /**
79      * Transfer tokens from other address
80      *
81      * Send `_value` tokens to `_to` in behalf of `_from`
82      *
83      * @param _from The address of the sender
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_value <= allowance[_from][msg.sender]);     // Check allowance
89         allowance[_from][msg.sender] -= _value;
90         _transfer(_from, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public
103         returns (bool success) {
104         allowance[msg.sender][_spender] = _value;
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address and notify
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      * @param _extraData some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118         public
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     /**
128      * Destroy tokens
129      *
130      * Remove `_value` tokens from the system irreversibly
131      *
132      * @param _value the amount of money to burn
133      */
134     function burn(uint256 _value) public returns (bool success) {
135         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
136         balanceOf[msg.sender] -= _value;            // Subtract from the sender
137         totalSupply -= _value;                      // Updates totalSupply
138         Burn(msg.sender, _value);
139         return true;
140     }
141 
142     /**
143      * Destroy tokens from other account
144      *
145      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
146      *
147      * @param _from the address of the sender
148      * @param _value the amount of money to burn
149      */
150     function burnFrom(address _from, uint256 _value) public returns (bool success) {
151         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
152         require(_value <= allowance[_from][msg.sender]);    // Check allowance
153         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
154         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
155         totalSupply -= _value;                              // Update totalSupply
156         Burn(_from, _value);
157         return true;
158     }
159 }