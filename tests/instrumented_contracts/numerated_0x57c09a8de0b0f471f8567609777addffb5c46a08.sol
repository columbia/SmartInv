1 pragma solidity ^0.4.16;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
5 
6 contract BitexGlobalXBXCoin  {
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13     address public owner;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17 	 mapping (address => uint256) public lockAmount;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 	
26 	//function lockAmount(address who) public view returns (uint256);
27 	
28 	event Lock(address indexed _owner, address indexed _spender, uint256 _value);
29 
30     // This notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32     
33     //This is common notifier for all events
34     event eventForAllTxn(address indexed from, address indexed to, uint256 value, string eventName, string platformTxId);
35 
36     /**
37      * Constructor function
38      *
39      * Initializes contract with initial supply tokens to the creator of the contract
40      */
41    // function AustralianBitCoin(
42 
43    constructor (
44         uint256 initialSupply,
45         string tokenName,
46         uint8 decimalUnits,
47         string tokenSymbol,
48 	string plaformTxId
49 	) public {
50         totalSupply = initialSupply;                        // Update total supply with the decimal amount
51         balanceOf[msg.sender] = initialSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54         decimals = decimalUnits;
55         owner = msg.sender;
56         emit eventForAllTxn(msg.sender, msg.sender, totalSupply,"DEPLOY", plaformTxId);
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value,string plaformTxId) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67 	    // Check for overflows
68         require(balanceOf[_to] + _value >= balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         emit Transfer(_from, _to, _value);
76         emit eventForAllTxn(_from, _to, _value,"TRANSFER",plaformTxId);
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
89     function transferForExchange(address _to, uint256 _value,string plaformTxId) public returns (bool success) {
90        require(balanceOf[msg.sender] - lockAmount[msg.sender] >= _value); 
91 		_transfer(msg.sender, _to, _value,plaformTxId);
92         return true;
93     }
94 	
95 	/////////
96 	function transfer(address _to, uint256 _value) public returns (bool success) {
97        require(balanceOf[msg.sender] - lockAmount[msg.sender] >= _value); 
98 		_transfer(msg.sender, _to, _value,"OTHER");
99         return true;
100     }
101 
102 
103     /**
104      * Transfer tokens from other address
105      *
106      * Send `_value` tokens to `_to` on behalf of `_from`
107      *
108      * @param _from The address of the sender
109      * @param _to The address of the recipient
110      * @param _value the amount to send
111      */
112     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
113         require(_value <= allowance[_from][msg.sender]);     // Check allowance
114 		require(balanceOf[_from] - lockAmount[_from] >= _value); 
115         allowance[_from][msg.sender] -= _value;
116       // require(msg.sender==owner);
117        _transfer(_from, _to, _value, "OTHER");
118         return true;
119     }
120 	/////////this is for exchange
121 	function transferFromForExchange(address _from, address _to, uint256 _value, string plaformTxId) public returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     // Check allowance
123 		require(balanceOf[_from] - lockAmount[_from] >= _value); 
124         allowance[_from][msg.sender] -= _value;
125       // require(msg.sender==owner);
126        _transfer(_from, _to, _value, plaformTxId);
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address
132      *
133      * Allows `_spender` to spend no more than `_value` tokens on your behalf
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      */
138     function approve(address _spender, uint256 _value) public
139         returns (bool success) {
140 		require(msg.sender==owner);
141         allowance[msg.sender][_spender] = _value;
142         emit Approval(msg.sender, _spender, _value);
143         return true;
144     }
145 	/*
146 	*lock perticular amount of any user by admin
147 	*/
148 	 function lock(address _spender, uint256 _value) public
149         returns (bool success) {
150 		require(msg.sender==owner);
151 		 require(balanceOf[_spender] >= _value);  
152        lockAmount[_spender] += _value;
153 	   emit Lock(msg.sender, _spender, _value);
154         return true;
155     }
156 	
157 	/*
158 	*unlock perticular amount of any user by admin
159 	*/
160 	 function unlock(address _spender, uint256 _value) public
161         returns (bool success) {
162 		require(msg.sender==owner);
163 		require(balanceOf[_spender] >= _value);  
164        lockAmount[_spender] -= _value;
165 	   emit Lock(msg.sender, _spender, _value);
166         return true;
167     }
168 	
169 	/**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174  // function lockAmount(address _spender) public view returns (uint256 balance) {
175  //   return balanceOf[_spender];
176  // }
177 
178     /**
179      * Set allowance for other address and notify
180      *
181      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      * @param _extraData some extra information to send to the approved contract
186      */
187     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
188         public
189         returns (bool success) {
190         tokenRecipient spender = tokenRecipient(_spender);
191         if (approve(_spender, _value)) {
192             spender.receiveApproval(msg.sender, _value, this, _extraData);
193             return true;
194         }
195     }
196 
197     /**
198      * Destroy tokens
199      *
200      * Remove `_value` tokens from the system irreversibly
201      *
202      * @param _value the amount of money to burn
203      */
204     function burn(uint256 _value, string plaformTxId) public returns (bool success) {
205         require(msg.sender==owner);
206         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
207         balanceOf[msg.sender] -= _value;            // Subtract from the sender
208         totalSupply -= _value;                      // Updates totalSupply
209         emit Burn(msg.sender, _value);
210         emit eventForAllTxn(msg.sender, msg.sender, _value,"BURN", plaformTxId);
211         return true;
212     }
213     
214        
215     
216     function mint(uint256 _value, string plaformTxId) public returns (bool success) {  
217     	require(msg.sender==owner);
218 		require(balanceOf[msg.sender] + _value <= 300000000);     //if total supply reaches at 300,000,000 then its not mint
219         balanceOf[msg.sender] += _value;                          // Subtract from the sender
220         totalSupply += _value;                                    // Updates totalSupply
221          emit eventForAllTxn(msg.sender, msg.sender, _value,"MINT", plaformTxId);
222         return true;
223     }
224 
225     
226 }