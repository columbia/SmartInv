1 pragma solidity ^0.4.18;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMult(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 }
31 
32 contract TokenERC20 {
33      function balanceOf(address _owner) constant returns (uint256  balance);
34      function transfer(address _to, uint256  _value) returns (bool success);
35      function transferFrom(address _from, address _to, uint256  _value) returns (bool success);
36      function approve(address _spender, uint256  _value) returns (bool success);
37      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
38      event Transfer(address indexed _from, address indexed _to, uint256  _value);
39      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 contract BICToken is SafeMath, TokenERC20{ 
43     string public name = "BIC";
44     string public symbol = "BIC";
45     uint8 public decimals = 18;
46     uint256 public totalSupply;
47 	address public owner = 0x0;
48 	string  public version = "1.0";	
49 	
50     bool public stopped = false;	
51     bool public locked = false;	
52     uint256 public currentSupply;           
53     uint256 public tokenRaised = 0;    
54     uint256 public tokenExchangeRate = 146700; 
55 
56     /* This creates an array with all balances */
57     mapping (address => uint256) public balanceOf;
58 	mapping (address => uint256) public freezeOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     /* This notifies clients about the amount burnt */
62     event Burn(address indexed from, uint256 value);
63 	
64 	/* This notifies clients about the amount frozen */
65     event Freeze(address indexed from, uint256 value);
66 	
67 	/* This notifies clients about the amount unfrozen */
68     event Unfreeze(address indexed from, uint256 value);
69 
70     /* Initializes contract with initial supply tokens to the creator of the contract */
71     function BICToken(
72         uint256 initialSupply,
73         string tokenName,
74         string tokenSymbol
75         ) {
76         totalSupply = formatDecimals(initialSupply);      			 //  Update total supply
77         balanceOf[msg.sender] = totalSupply;              			 //  Give the creator all initial tokens
78         name = tokenName;                                   		 //  Set the name for display purposes
79 		currentSupply = totalSupply;
80         symbol = tokenSymbol;                                        //  Set the symbol for display purposes
81 		owner = msg.sender;
82     }
83 	
84 	modifier onlyOwner()  { 
85 		require(msg.sender == owner); 
86 		_; 
87 	}
88 	
89 	modifier validAddress()  {
90         require(address(0) != msg.sender);
91         _;
92     }	
93 
94     modifier isRunning() {
95         assert (!stopped);
96         _;
97     }
98 	
99     modifier unlocked() {
100         require(!locked);
101         _;
102     }
103 	
104     function formatDecimals(uint256 _value) internal returns (uint256 ) {
105         return _value * 10 ** uint256(decimals);
106     }
107 	
108 	function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balanceOf[_owner];
110     }
111 
112     /* Allow another contract to spend some tokens in your behalf */
113     function approve(address _spender, uint256 _value) isRunning validAddress unlocked returns (bool success) {
114         require(_value > 0);
115         allowance[msg.sender][_spender] = _value;
116 		Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 	
120 	/*Function to check the amount of tokens that an owner allowed to a spender.*/
121 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122 		return allowance[_owner][_spender];
123 	}
124 
125     /* Send coins */
126     function transfer(address _to, uint256 _value) isRunning validAddress unlocked returns (bool success) {	
127         _transfer(msg.sender, _to, _value);
128     }
129 	
130 	/**
131      * Internal transfer, only can be called by this contract
132      */
133     function _transfer(address _from, address _to, uint _value) internal {
134         // Prevent transfer to 0x0 address. Use burn() instead
135         require(_to != address(0));
136         require(_value > 0);
137         // Check if the sender has enough
138         require(balanceOf[_from] >= _value);
139         // Check for overflows
140         require(balanceOf[_to] + _value > balanceOf[_to]);
141         // Save this for an assertion in the future
142         uint previousBalances = balanceOf[_from] + balanceOf[_to];
143         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);   // Subtract from the sender
144         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);       // Add the same to the recipient
145         Transfer(_from, _to, _value);
146         // Asserts are used to use static analysis to find bugs in your code. They should never fail
147         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
148     }
149 
150     /* A contract attempts to get the coins */
151     function transferFrom(address _from, address _to, uint256 _value) isRunning validAddress unlocked returns (bool success) {	
152         require(_value <= allowance[_from][msg.sender]);     		// Check allowance
153         require(_value > 0);
154         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
155         _transfer(_from, _to, _value);
156         return true;
157     }
158 
159     function burn(uint256 _value) isRunning validAddress unlocked returns (bool success) {
160         require(balanceOf[msg.sender] >= _value);   							  // Check if the sender has enough
161         require(_value > 0);   
162         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);  // Subtract from the sender
163         totalSupply = SafeMath.safeSub(totalSupply,_value);                       // Updates totalSupply
164         currentSupply = SafeMath.safeSub(currentSupply,_value);                   // Updates currentSupply
165         Burn(msg.sender, _value);
166         return true;
167     }
168 	
169 	function freeze(uint256 _value) isRunning validAddress unlocked returns (bool success) {	
170         require(balanceOf[msg.sender] >= _value);   		 					 // Check if the sender has enough
171         require(_value > 0);   
172         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
173         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);   // Updates totalSupply
174         Freeze(msg.sender, _value);
175         return true;
176     }
177 	
178 	function unfreeze(uint256 _value) isRunning validAddress unlocked returns (bool success) {
179         require(freezeOf[msg.sender] >= _value);   		 						   // Check if the sender has enough
180         require(_value > 0);   
181         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);     // Subtract from the sender
182 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);   // Updates totalSupply
183         Unfreeze(msg.sender, _value);
184         return true;
185     }
186 	
187 	function setTokenExchangeRate(uint256 _tokenExchangeRate) onlyOwner external {
188         require(_tokenExchangeRate > 0);   
189         require(_tokenExchangeRate != tokenExchangeRate);   
190         tokenExchangeRate = _tokenExchangeRate;
191     } 
192 	
193     function setName(string _name) onlyOwner {
194         name = _name;
195     }
196 	
197     function setSymbol(string _symbol) onlyOwner {
198         symbol = _symbol;
199     }
200 }