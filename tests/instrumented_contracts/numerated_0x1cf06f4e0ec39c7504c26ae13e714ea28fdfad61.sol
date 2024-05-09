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
42 contract CCCToken is SafeMath, TokenERC20{ 
43     string public name = "CCC";
44     string public symbol = "CCC";
45     uint8 public decimals = 18;
46     uint256 public totalSupply = 4204800;
47 	address public owner = 0x0;
48 	string  public version = "1.0";	
49 	
50     bool public locked = false;	
51     uint256 public currentSupply;      
52     uint256 public tokenExchangeRate = 500; 
53 
54     /* This creates an array with all balances */
55     mapping (address => uint256) public balanceOf;
56 	mapping (address => uint256) public freezeOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     /* Initializes contract with initial supply tokens to the creator of the contract */
60     function CCCToken(
61         uint256 initialSupply,
62         string tokenName,
63         string tokenSymbol
64         ) {
65         totalSupply = formatDecimals(initialSupply);      			 //  Update total supply
66         balanceOf[msg.sender] = totalSupply;              			 //  Give the creator all initial tokens
67         name = tokenName;                                   		 //  Set the name for display purposes
68 		currentSupply = totalSupply;
69         symbol = tokenSymbol;                                        //  Set the symbol for display purposes
70 		owner = msg.sender;
71     }
72 	
73 	modifier onlyOwner()  { 
74 		require(msg.sender == owner); 
75 		_; 
76 	}
77 	
78 	modifier validAddress()  {
79         require(address(0) != msg.sender);
80         _;
81     }
82 	
83     modifier unlocked() {
84         require(!locked);
85         _;
86     }
87 	
88     function formatDecimals(uint256 _value) internal returns (uint256 ) {
89         return _value * 10 ** uint256(decimals);
90 	}
91 	
92 	function balanceOf(address _owner) constant returns (uint256 balance) {
93         return balanceOf[_owner];
94     }
95 
96     /* Allow another contract to spend some tokens in your behalf */
97     function approve(address _spender, uint256 _value) validAddress unlocked returns (bool success) {
98         require(_value > 0);
99         allowance[msg.sender][_spender] = _value;
100 		Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 	
104 	/*Function to check the amount of tokens that an owner allowed to a spender.*/
105 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
106 		return allowance[_owner][_spender];
107 	}	
108 
109 	  /**
110 	   * @dev Increase the amount of tokens that an owner allowance to a spender.
111 	   * approve should be called when allowance[_spender] == 0. To increment
112 	   * allowance value is better to use this function to avoid 2 calls (and wait until
113 	   * the first transaction is mined)
114 	   * @param _spender The address which will spend the funds.
115 	   * @param _addedValue The amount of tokens to increase the allowance by.
116 	   */
117 	  function increaseApproval(address _spender, uint256 _addedValue) validAddress unlocked public returns (bool success)
118 	  {
119 		allowance[msg.sender][_spender] = SafeMath.safeAdd(allowance[msg.sender][_spender], _addedValue);
120 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
121 		return true;
122 	  }
123 
124 	  /**
125 	   * @dev Decrease the amount of tokens that an owner allowance to a spender.
126 	   * approve should be called when allowance[_spender] == 0. To decrement
127 	   * allowance value is better to use this function to avoid 2 calls (and wait until
128 	   * the first transaction is mined)
129 	   * @param _spender The address which will spend the funds.
130 	   * @param _subtractedValue The amount of tokens to decrease the allowance by.
131 	   */
132 	  function decreaseApproval(address _spender, uint256 _subtractedValue) validAddress unlocked public returns (bool success)
133 	  {
134 		uint256 oldValue = allowance[msg.sender][_spender];
135 		if (_subtractedValue > oldValue) {
136 		  allowance[msg.sender][_spender] = 0;
137 		} else {
138 		  allowance[msg.sender][_spender] = SafeMath.safeSub(oldValue, _subtractedValue);
139 		}
140 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
141 		return true;
142 	  }
143 
144     /* Send coins */
145     function transfer(address _to, uint256 _value) validAddress unlocked returns (bool success) {	
146         _transfer(msg.sender, _to, _value);
147     }
148 	
149 	/**
150      * Internal transfer, only can be called by this contract
151      */
152     function _transfer(address _from, address _to, uint _value) internal {
153         // Prevent transfer to 0x0 address. Use burn() instead
154         require(_to != address(0));
155         require(_value > 0);
156         // Check if the sender has enough
157         require(balanceOf[_from] >= _value);
158         // Check for overflows
159         require(balanceOf[_to] + _value > balanceOf[_to]);
160         // Save this for an assertion in the future
161         uint previousBalances = balanceOf[_from] + balanceOf[_to];
162         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);   // Subtract from the sender
163         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);       // Add the same to the recipient
164         Transfer(_from, _to, _value);
165         // Asserts are used to use static analysis to find bugs in your code. They should never fail
166         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
167     }
168 
169     /* A contract attempts to get the coins */
170     function transferFrom(address _from, address _to, uint256 _value) validAddress unlocked returns (bool success) {	
171         require(_value <= allowance[_from][msg.sender]);     		// Check allowance
172         require(_value > 0);
173         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
174         _transfer(_from, _to, _value);
175         return true;
176     }
177 }