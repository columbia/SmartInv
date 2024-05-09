1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BTK {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     /**
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function BTK () public {
29         totalSupply = 4187500000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = "Betok";                                   // Set the name for display purposes
32         symbol = "BTK";                               // Set the symbol for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         // Prevent transfer to 0x0 address. Use burn() instead
40         require(_to != 0x0);
41         // Check if the sender has enough
42         require(balanceOf[_from] >= _value);
43         // Check for overflows
44         require(balanceOf[_to] + _value > balanceOf[_to]);
45         // Save this for an assertion in the future
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         // Subtract from the sender
48         balanceOf[_from] -= _value;
49         // Add the same to the recipient
50         balanceOf[_to] += _value;
51         Transfer(_from, _to, _value);
52         // Asserts are used to use static analysis to find bugs in your code. They should never fail
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56 
57     // Get the total token supply in circulation
58     function totalSupply() public constant returns (uint) {
59         return totalSupply;
60     }
61 
62     // Get the account balance of another account with address _owner
63     function balanceOf(address _owner) public constant returns (uint balance) {
64         return balanceOf[_owner];
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
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
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address and notify
111      *
112      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      * @param _extraData some extra information to send to the approved contract
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         public
120         returns (bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 
128     /**
129      * Destroy tokens
130      *
131      * Remove `_value` tokens from the system irreversibly
132      *
133      * @param _value the amount of money to burn
134      */
135     function burn(uint256 _value) public returns (bool success) {
136         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
137         balanceOf[msg.sender] -= _value;            // Subtract from the sender
138         totalSupply -= _value;                      // Updates totalSupply
139         Burn(msg.sender, _value);
140         return true;
141     }
142 
143     /**
144      * Destroy tokens from other account
145      *
146      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
147      *
148      * @param _from the address of the sender
149      * @param _value the amount of money to burn
150      */
151     function burnFrom(address _from, uint256 _value) public returns (bool success) {
152         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
153         require(_value <= allowance[_from][msg.sender]);    // Check allowance
154         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
155         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
156         totalSupply -= _value;                              // Update totalSupply
157         Burn(_from, _value);
158         return true;
159     }
160 }