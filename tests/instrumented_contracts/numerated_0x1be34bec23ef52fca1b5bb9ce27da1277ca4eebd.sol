1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract DateTime {
6 		function toTimestamp(uint16 year, uint8 month, uint8 day) public constant returns (uint timestamp);
7         function getYear(uint timestamp) public constant returns (uint16);
8         function getMonth(uint timestamp) public constant returns (uint8);
9         function getDay(uint timestamp) public constant returns (uint8);
10 }
11 
12 contract TokenERC20 {
13     // Public variables of the token
14     string public name = "mHealthCoin";
15     string public symbol = "MHEC";
16     uint8 public decimals = 18;
17     // 18 decimals is the strongly suggested default, avoid changing it
18     uint256 public totalSupply = 4000000000 * 10 ** uint256(decimals);
19 	address public owner;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     // This generates a public event on the blockchain that will notify clients
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     
28     // This generates a public event on the blockchain that will notify clients
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // This notifies clients about the amount burnt
32     event Burn(address indexed from, uint256 value);
33 	
34 	//Date related code
35 	address public dateTimeAddr = 0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce;
36 	DateTime dateTime = DateTime(dateTimeAddr);
37 	uint[] lockupTime = [dateTime.toTimestamp(2018,11,13),dateTime.toTimestamp(2019,1,13),dateTime.toTimestamp(2019,3,13),dateTime.toTimestamp(2019,5,13)];
38 	uint8[] lockupPercent = [0,25,50,75];
39 
40     /**
41      * Constructor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     constructor() public {
46         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
47 		owner = msg.sender;
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value >= balanceOf[_to]);
60 		
61 		//Check for lockup period and lockup percentage
62 		uint256 i=0;
63 		for (uint256 l = lockupTime.length; i < l; i++) {
64 			if(now < lockupTime[i]) break;
65 		}
66 		uint256 maxAmount = (i<1)? 0 : 
67 			( (i>=lockupPercent.length)? balanceOf[_from] : (lockupPercent[i] * balanceOf[_from] / 100) );
68 		if(_from != owner) require(_value <= maxAmount);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         emit Transfer(_from, _to, _value);
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
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         _transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` on behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens on your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         emit Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address and notify
126      *
127      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      * @param _extraData some extra information to send to the approved contract
132      */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143     /**
144      * Destroy tokens
145      *
146      * Remove `_value` tokens from the system irreversibly
147      *
148      * @param _value the amount of money to burn
149      */
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166     function burnFrom(address _from, uint256 _value) public returns (bool success) {
167         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
168         require(_value <= allowance[_from][msg.sender]);    // Check allowance
169         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
170         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
171         totalSupply -= _value;                              // Update totalSupply
172         emit Burn(_from, _value);
173         return true;
174     }
175 }