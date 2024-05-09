1 /**
2  * by ARBITRAGE developer 2017 
3  * site arbit.top
4  * twitter twitter.com/arbitrage_arbit
5  * medium medium.com/@arbitrage_arbit
6  * contact e-mail admin@arbit.top
7  */
8   
9   pragma solidity ^0.4.16; 
10     contract owned {
11         address public owner;
12 
13         function owned() {
14             owner = msg.sender;
15         }
16 
17         modifier onlyOwner {
18             require(msg.sender == owner);
19             _;
20         }
21 
22         function transferOwnership(address newOwner) onlyOwner {
23             owner = newOwner;
24         }
25     }
26 	interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract ARBITRAGE is owned {
29     // Public variables of the token
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     function ARBITRAGE(
51     ) public {
52      balanceOf[msg.sender] = 5000000000000000;              // Give the creator all initial tokens
53         totalSupply = 5000000000000000;                        // Update total supply
54         name = 'ARBITRAGE';                                   // Set the name for display purposes
55         symbol = 'ARBIT';                               // Set the symbol for display purposes
56         decimals = 8;                              // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public {
89         _transfer(msg.sender, _to, _value);
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` in behalf of `_from`
96     
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108     
109      */
110     function approve(address _spender, uint256 _value) public
111         returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119     
120      */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         public
123         returns (bool success) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129     }
130 
131   
132 
133     /**
134      * Destroy tokens
135   
136      */
137     function burn(uint256 _value) public returns (bool success) {
138         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
139         balanceOf[msg.sender] -= _value;            // Subtract from the sender
140         totalSupply -= _value;                      // Updates totalSupply
141         Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other ccount
147 
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