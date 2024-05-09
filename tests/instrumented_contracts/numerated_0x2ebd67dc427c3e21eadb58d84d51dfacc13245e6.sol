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
42 contract MMMToken is SafeMath, TokenERC20{ 
43     string public name = "MMM";
44     string public symbol = "MMM";
45     uint8 public decimals = 18;
46     uint256 public totalSupply = 4204800;
47 	address public owner = 0x0;
48 	string  public version = "1.0";	
49 	
50     bool public locked = false;	
51     uint256 public currentSupply;           
52     uint256 public tokenRaised = 0;    
53     uint256 public tokenExchangeRate = 500; 
54 
55     /* This creates an array with all balances */
56     mapping (address => uint256) public balanceOf;
57 	mapping (address => uint256) public freezeOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 	
60 	/* IssueToken*/
61     event IssueToken(address indexed to, uint256 value);
62 
63     /* Initializes contract with initial supply tokens to the creator of the contract */
64     function MMMToken(
65         uint256 initialSupply,
66         string tokenName,
67         string tokenSymbol
68         ) {
69         totalSupply = formatDecimals(initialSupply);      			 //  Update total supply
70         balanceOf[msg.sender] = totalSupply;              			 //  Give the creator all initial tokens
71         name = tokenName;                                   		 //  Set the name for display purposes
72 		currentSupply = totalSupply;
73         symbol = tokenSymbol;                                        //  Set the symbol for display purposes
74 		owner = msg.sender;
75     }
76 	
77 	modifier onlyOwner()  { 
78 		require(msg.sender == owner); 
79 		_; 
80 	}
81 	
82 	modifier validAddress()  {
83         require(address(0) != msg.sender);
84         _;
85     }
86 	
87     modifier unlocked() {
88         require(!locked);
89         _;
90     }
91 	
92     function formatDecimals(uint256 _value) internal returns (uint256 ) {
93         return _value * 10 ** uint256(decimals);
94 	}
95 	
96 	function balanceOf(address _owner) constant returns (uint256 balance) {
97         return balanceOf[_owner];
98     }
99 
100     /* Allow another contract to spend some tokens in your behalf */
101     function approve(address _spender, uint256 _value) validAddress unlocked returns (bool success) {
102         require(_value > 0);
103         allowance[msg.sender][_spender] = _value;
104 		Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 	
108 	/*Function to check the amount of tokens that an owner allowed to a spender.*/
109 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
110 		return allowance[_owner][_spender];
111 	}	
112 
113 	  /**
114 	   * @dev Increase the amount of tokens that an owner allowance to a spender.
115 	   * approve should be called when allowance[_spender] == 0. To increment
116 	   * allowance value is better to use this function to avoid 2 calls (and wait until
117 	   * the first transaction is mined)
118 	   * @param _spender The address which will spend the funds.
119 	   * @param _addedValue The amount of tokens to increase the allowance by.
120 	   */
121 	  function increaseApproval(address _spender, uint256 _addedValue) validAddress unlocked public returns (bool success)
122 	  {
123 		allowance[msg.sender][_spender] = SafeMath.safeAdd(allowance[msg.sender][_spender], _addedValue);
124 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
125 		return true;
126 	  }
127 
128 	  /**
129 	   * @dev Decrease the amount of tokens that an owner allowance to a spender.
130 	   * approve should be called when allowance[_spender] == 0. To decrement
131 	   * allowance value is better to use this function to avoid 2 calls (and wait until
132 	   * the first transaction is mined)
133 	   * @param _spender The address which will spend the funds.
134 	   * @param _subtractedValue The amount of tokens to decrease the allowance by.
135 	   */
136 	  function decreaseApproval(address _spender, uint256 _subtractedValue) validAddress unlocked public returns (bool success)
137 	  {
138 		uint256 oldValue = allowance[msg.sender][_spender];
139 		if (_subtractedValue > oldValue) {
140 		  allowance[msg.sender][_spender] = 0;
141 		} else {
142 		  allowance[msg.sender][_spender] = SafeMath.safeSub(oldValue, _subtractedValue);
143 		}
144 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
145 		return true;
146 	  }
147 
148     /* Send coins */
149     function transfer(address _to, uint256 _value) validAddress unlocked returns (bool success) {	
150         _transfer(msg.sender, _to, _value);
151     }
152 	
153 	/**
154      * Internal transfer, only can be called by this contract
155      */
156     function _transfer(address _from, address _to, uint _value) internal {
157         // Prevent transfer to 0x0 address. Use burn() instead
158         require(_to != address(0));
159         require(_value > 0);
160         // Check if the sender has enough
161         require(balanceOf[_from] >= _value);
162         // Check for overflows
163         require(balanceOf[_to] + _value > balanceOf[_to]);
164         // Save this for an assertion in the future
165         uint previousBalances = balanceOf[_from] + balanceOf[_to];
166         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);   // Subtract from the sender
167         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);       // Add the same to the recipient
168         Transfer(_from, _to, _value);
169         // Asserts are used to use static analysis to find bugs in your code. They should never fail
170         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
171     }
172 
173     /* A contract attempts to get the coins */
174     function transferFrom(address _from, address _to, uint256 _value) validAddress unlocked returns (bool success) {	
175         require(_value <= allowance[_from][msg.sender]);     		// Check allowance
176         require(_value > 0);
177         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
178         _transfer(_from, _to, _value);
179         return true;
180     }
181 }