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
14     string public name = "Authpaper Coin";
15     string public symbol = "AUPC";
16     uint8 public decimals = 18;
17     // 18 decimals is the strongly suggested default, avoid changing it
18     uint256 public totalSupply = 400000000 * 10 ** uint256(decimals);
19 	address public owner;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24 	mapping (address => uint256) public icoAmount;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     
29     // This generates a public event on the blockchain that will notify clients
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 
32     // This notifies clients about the amount burnt
33     event Burn(address indexed from, uint256 value);
34 	
35 	//Date related code
36 	address public dateTimeAddr = 0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce;
37 	DateTime dateTime = DateTime(dateTimeAddr);
38 	uint[] lockupTime = [dateTime.toTimestamp(2018,9,15),dateTime.toTimestamp(2018,10,15),dateTime.toTimestamp(2018,11,15),
39 	dateTime.toTimestamp(2018,12,15),dateTime.toTimestamp(2019,1,15),dateTime.toTimestamp(2019,2,15),
40 	dateTime.toTimestamp(2019,3,15),dateTime.toTimestamp(2019,4,15),dateTime.toTimestamp(2019,5,15),
41 	dateTime.toTimestamp(2019,6,15),dateTime.toTimestamp(2019,7,15),dateTime.toTimestamp(2019,8,15),
42 	dateTime.toTimestamp(2019,9,15)];
43 	uint lockupRatio = 8;
44 	uint fullTradeTime = dateTime.toTimestamp(2019,10,1);
45 
46     /**
47      * Constructor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor() public {
52         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
53 		owner = msg.sender;
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65 		require( balanceOf[_to] + _value >= balanceOf[_to] );
66 		require( 100*(balanceOf[_from] - _value) >= (balanceOf[_from] - _value) );
67 		require( 100*icoAmount[_from] >= icoAmount[_from] );
68 		require( icoAmount[_to] + _value >= icoAmount[_to] );
69 		
70 		if(now < fullTradeTime && _from != owner && _to !=owner && icoAmount[_from] >0) {
71 			//Check for lockup period and lockup percentage
72 			uint256 i=0;
73 			for (uint256 l = lockupTime.length; i < l; i++) {
74 				if(now < lockupTime[i]) break;
75 			}
76 			uint256 minAmountLeft = (i<1)? 0 : ( (lockupRatio*i>100)? 100 : lockupRatio*i );
77 			minAmountLeft = 100 - minAmountLeft;
78 			require( ((balanceOf[_from] - _value)*100) >= (minAmountLeft*icoAmount[_from]) );			
79 		}	
80         // Save this for an assertion in the future
81         uint previousBalances = balanceOf[_from] + balanceOf[_to];
82         // Subtract from the sender
83         balanceOf[_from] -= _value;
84         // Add the same to the recipient
85         balanceOf[_to] += _value;
86 		if(_from == owner && now < fullTradeTime) icoAmount[_to] += _value;
87 		if(_to == owner){
88 			if(icoAmount[_from] >= _value) icoAmount[_from] -= _value;
89 			else icoAmount[_from]=0;
90 		}
91         emit Transfer(_from, _to, _value);
92         // Asserts are used to use static analysis to find bugs in your code. They should never fail
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96     /**
97      * Transfer tokens
98      *
99      * Send `_value` tokens to `_to` from your account
100      *
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transfer(address _to, uint256 _value) public returns (bool success) {
105         _transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Transfer tokens from other address
111      *
112      * Send `_value` tokens to `_to` on behalf of `_from`
113      *
114      * @param _from The address of the sender
115      * @param _to The address of the recipient
116      * @param _value the amount to send
117      */
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119         require(_value <= allowance[_from][msg.sender]);     // Check allowance
120         allowance[_from][msg.sender] -= _value;
121         _transfer(_from, _to, _value);
122         return true;
123     }
124 	function addApprove(address _spender, uint256 _value) public returns (bool success){
125 		require( allowance[msg.sender][_spender] + _value >= allowance[msg.sender][_spender] );
126 		allowance[msg.sender][_spender] += _value;
127         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
128 		return true;
129 	}
130 	function claimICOToken() public returns (bool success){
131 		require(allowance[owner][msg.sender] > 0);     // Check allowance
132 		transferFrom(owner,msg.sender,allowance[owner][msg.sender]);
133 		return true;
134 	}
135 	
136 
137     /**
138      * Set allowance for other address
139      *
140      * Allows `_spender` to spend no more than `_value` tokens on your behalf
141      *
142      * @param _spender The address authorized to spend
143      * @param _value the max amount they can spend
144      */
145     function approve(address _spender, uint256 _value) public
146         returns (bool success) {
147         allowance[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address and notify
154      *
155      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      * @param _extraData some extra information to send to the approved contract
160      */
161     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
162         public
163         returns (bool success) {
164         tokenRecipient spender = tokenRecipient(_spender);
165         if (approve(_spender, _value)) {
166             spender.receiveApproval(msg.sender, _value, this, _extraData);
167             return true;
168         }
169     }
170 
171     /**
172      * Destroy tokens
173      *
174      * Remove `_value` tokens from the system irreversibly
175      *
176      * @param _value the amount of money to burn
177      */
178     function burn(uint256 _value) public returns (bool success) {
179         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
180         balanceOf[msg.sender] -= _value;            // Subtract from the sender
181         totalSupply -= _value;                      // Updates totalSupply
182         emit Burn(msg.sender, _value);
183         return true;
184     }
185 
186     /**
187      * Destroy tokens from other account
188      *
189      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
190      *
191      * @param _from the address of the sender
192      * @param _value the amount of money to burn
193      */
194     function burnFrom(address _from, uint256 _value) public returns (bool success) {
195         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
196         require(_value <= allowance[_from][msg.sender]);    // Check allowance
197         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
198         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
199         totalSupply -= _value;                              // Update totalSupply
200         emit Burn(_from, _value);
201         return true;
202     }
203 }