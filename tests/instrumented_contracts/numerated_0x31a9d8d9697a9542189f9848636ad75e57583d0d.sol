1 pragma solidity ^0.4.16;
2 
3 //interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 //： public  to external
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
6 contract ICDCOIN {
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24 function () public payable {
25 	emit GetEth(msg.value);
26 }
27  event GetEth(uint amount);
28     /**
29      * Constructor function
30      *
31      * Initializes contract with initial supply tokens to the creator of the contract
32      */
33     constructor(
34         uint256 initialSupply,
35         string tokenName,
36         string tokenSymbol
37     ) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
39         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
40         name = tokenName;                                   // Set the name for display purposes
41         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
60         //Transfer(_from, _to, _value);
61         // add emit  Invoking events without "emit" prefix is deprecated.
62         emit Transfer(_from, _to, _value);
63         // Asserts are used to use static analysis to find bugs in your code. They should never fail
64         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
139         // add emit  Invoking events without "emit" prefix is deprecated.
140         //Burn(msg.sender, _value);
141         emit Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other account
147      *
148      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
149      *
150      * @param _from the address of the sender
151      * @param _value the amount of money to burn
152      */
153     function burnFrom(address _from, uint256 _value) public returns (bool success) {
154         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
155         require(_value <= allowance[_from][msg.sender]);    // Check allowance
156         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
157         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
158         totalSupply -= _value;                              // Update totalSupply
159         // add emit  Invoking events without "emit" prefix is deprecated.
160         //Burn(_from, _value);
161         emit Burn(_from, _value);
162         return true;
163     }
164 }