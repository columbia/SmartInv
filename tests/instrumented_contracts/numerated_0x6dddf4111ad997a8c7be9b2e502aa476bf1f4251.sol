1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * 
6  * 
7  * 
8  * Website: https://www.unimonitor.io
9  * Telegram: https://t.me/UniMonitorTools
10  * Announcement channel: https://t.me/UniMonitor_Announcement
11  * Twitter: https://twitter.com/UniMonitor
12  * 
13  * 
14  * 
15  **/
16  
17  
18  
19 interface tokenRecipient { 
20     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata) external; 
21 }
22 
23 contract TokenERC20 {
24     // Public variables of the token
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constructor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor(
50         uint256 initialSupply,
51         string memory tokenName,
52         string memory tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56         name = tokenName;                                   // Set the name for display purposes
57         symbol = tokenSymbol;                               // Set the symbol for display purposes
58     }
59 
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint _value) internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != address(0x0));
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value >= balanceOf[_to]);
70         // Save this for an assertion in the future
71         uint previousBalances = balanceOf[_from] + balanceOf[_to];
72         // Subtract from the sender
73         balanceOf[_from] -= _value;
74         // Add the same to the recipient
75         balanceOf[_to] += _value;
76         emit Transfer(_from, _to, _value);
77         // Asserts are used to use static analysis to find bugs in your code. They should never fail
78         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
79     }
80 
81     /**
82      * Transfer tokens
83      *
84      * Send `_value` tokens to `_to` from your account
85      *
86      * @param _to The address of the recipient
87      * @param _value the amount to send
88      */
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         _transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95      * Transfer tokens from other address
96      *
97      * Send `_value` tokens to `_to` on behalf of `_from`
98      *
99      * @param _from The address of the sender
100      * @param _to The address of the recipient
101      * @param _value the amount to send
102      */
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104         require(_value <= allowance[_from][msg.sender]);     // Check allowance
105         allowance[_from][msg.sender] -= _value;
106         _transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * Set allowance for other address
112      *
113      * Allows `_spender` to spend no more than `_value` tokens on your behalf
114      *
115      * @param _spender The address authorized to spend
116      * @param _value the max amount they can spend
117      */
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         emit Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * Destroy tokens from other account
161      *
162      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163      *
164      * @param _from the address of the sender
165      * @param _value the amount of money to burn
166      */
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172         totalSupply -= _value;                              // Update totalSupply
173         emit Burn(_from, _value);
174         return true;
175     }
176 }