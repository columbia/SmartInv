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
42 contract CCCTESTToken is SafeMath, TokenERC20{ 
43     string public name = "CCCTEST";
44     string public symbol = "CCCTEST";
45     uint8 public decimals = 18;
46     uint256 public totalSupply = 4204800;
47 	address public owner = 0x0;
48 	string  public version = "1.0";	
49 	
50     bool public locked = false;	
51     uint256 public currentSupply;           
52     uint256 public tokenRaised = 0;    
53     uint256 public tokenExchangeRate = 333; 
54 
55     /* This creates an array with all balances */
56     mapping (address => uint256) public balanceOf;
57 	mapping (address => uint256) public freezeOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     /* This notifies clients about the amount burnt */
61     event Burn(address indexed from, uint256 value);
62 	
63 	/* This notifies clients about the amount frozen */
64     event Freeze(address indexed from, uint256 value);
65 	
66 	/* This notifies clients about the amount unfrozen */
67     event Unfreeze(address indexed from, uint256 value);
68 	
69 	/* IssueToken*/
70     event IssueToken(address indexed to, uint256 value);
71     
72 	/* TransferOwnerEther*/
73     event TransferOwnerEther(address indexed to, uint256 value);
74 
75     /* Initializes contract with initial supply tokens to the creator of the contract */
76     function CCCTESTToken(
77         uint256 initialSupply,
78         string tokenName,
79         string tokenSymbol
80         ) {
81         totalSupply = formatDecimals(initialSupply);      			 //  Update total supply
82         balanceOf[msg.sender] = totalSupply;              			 //  Give the creator all initial tokens
83         name = tokenName;                                   		 //  Set the name for display purposes
84 		currentSupply = totalSupply;
85         symbol = tokenSymbol;                                        //  Set the symbol for display purposes
86 		owner = msg.sender;
87     }
88 	
89 	modifier onlyOwner()  { 
90 		require(msg.sender == owner); 
91 		_; 
92 	}
93 	
94 	modifier validAddress()  {
95         require(address(0) != msg.sender);
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
106 	}
107 	
108 	function balanceOf(address _owner) constant returns (uint256 balance) {
109         return balanceOf[_owner];
110     }
111 
112     /* Allow another contract to spend some tokens in your behalf */
113     function approve(address _spender, uint256 _value) validAddress unlocked returns (bool success) {
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
125 	  /**
126 	   * @dev Increase the amount of tokens that an owner allowance to a spender.
127 	   * approve should be called when allowance[_spender] == 0. To increment
128 	   * allowance value is better to use this function to avoid 2 calls (and wait until
129 	   * the first transaction is mined)
130 	   * @param _spender The address which will spend the funds.
131 	   * @param _addedValue The amount of tokens to increase the allowance by.
132 	   */
133 	  function increaseApproval(address _spender, uint256 _addedValue) validAddress unlocked public returns (bool success)
134 	  {
135 		allowance[msg.sender][_spender] = SafeMath.safeAdd(allowance[msg.sender][_spender], _addedValue);
136 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
137 		return true;
138 	  }
139 
140 	  /**
141 	   * @dev Decrease the amount of tokens that an owner allowance to a spender.
142 	   * approve should be called when allowance[_spender] == 0. To decrement
143 	   * allowance value is better to use this function to avoid 2 calls (and wait until
144 	   * the first transaction is mined)
145 	   * @param _spender The address which will spend the funds.
146 	   * @param _subtractedValue The amount of tokens to decrease the allowance by.
147 	   */
148 	  function decreaseApproval(address _spender, uint256 _subtractedValue) validAddress unlocked public returns (bool success)
149 	  {
150 		uint256 oldValue = allowance[msg.sender][_spender];
151 		if (_subtractedValue > oldValue) {
152 		  allowance[msg.sender][_spender] = 0;
153 		} else {
154 		  allowance[msg.sender][_spender] = SafeMath.safeSub(oldValue, _subtractedValue);
155 		}
156 		Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
157 		return true;
158 	  }
159 
160     /* Send coins */
161     function transfer(address _to, uint256 _value) validAddress unlocked returns (bool success) {	
162         _transfer(msg.sender, _to, _value);
163     }
164 	
165 	/**
166      * Internal transfer, only can be called by this contract
167      */
168     function _transfer(address _from, address _to, uint _value) internal {
169         // Prevent transfer to 0x0 address. Use burn() instead
170         require(_to != address(0));
171         require(_value > 0);
172         // Check if the sender has enough
173         require(balanceOf[_from] >= _value);
174         // Check for overflows
175         require(balanceOf[_to] + _value > balanceOf[_to]);
176         // Save this for an assertion in the future
177         uint previousBalances = balanceOf[_from] + balanceOf[_to];
178         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);   // Subtract from the sender
179         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);       // Add the same to the recipient
180         Transfer(_from, _to, _value);
181         // Asserts are used to use static analysis to find bugs in your code. They should never fail
182         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
183     }
184 
185     /* A contract attempts to get the coins */
186     function transferFrom(address _from, address _to, uint256 _value) validAddress unlocked returns (bool success) {	
187         require(_value <= allowance[_from][msg.sender]);     		// Check allowance
188         require(_value > 0);
189         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
190         _transfer(_from, _to, _value);
191         return true;
192     }
193 
194     function burn(uint256 _value) validAddress unlocked returns (bool success) {
195         require(balanceOf[msg.sender] >= _value);   							  // Check if the sender has enough
196         require(_value > 0);   
197         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);  // Subtract from the sender
198         totalSupply = SafeMath.safeSub(totalSupply,_value);                       // Updates totalSupply
199         currentSupply = SafeMath.safeSub(currentSupply,_value);                   // Updates currentSupply
200         Burn(msg.sender, _value);
201         return true;
202     }
203 	
204 	function freeze(uint256 _value) validAddress unlocked returns (bool success) {	
205         require(balanceOf[msg.sender] >= _value);   		 					 // Check if the sender has enough
206         require(_value > 0);   
207         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value); // Subtract from the sender
208         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);   // Updates totalSupply
209         Freeze(msg.sender, _value);
210         return true;
211     }
212 	
213 	function unfreeze(uint256 _value) validAddress unlocked returns (bool success) {
214         require(freezeOf[msg.sender] >= _value);   		 						   // Check if the sender has enough
215         require(_value > 0);   
216         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);     // Subtract from the sender
217 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);   // Updates totalSupply
218         Unfreeze(msg.sender, _value);
219         return true;
220     }
221 	
222 	function setTokenExchangeRate(uint256 _tokenExchangeRate) onlyOwner external {
223         require(_tokenExchangeRate > 0);   
224         require(_tokenExchangeRate != tokenExchangeRate);   
225         tokenExchangeRate = _tokenExchangeRate;
226     } 
227 	
228     function setName(string _name) onlyOwner {
229         name = _name;
230     }
231 	
232     function setSymbol(string _symbol) onlyOwner {
233         symbol = _symbol;
234     }	
235 	
236 	 /**
237 	  * @dev Function to lock token transfers
238 	  * @param _newLockState New lock state
239 	  * @return A boolean that indicates if the operation was successful.
240 	  */
241     function setLock(bool _newLockState) onlyOwner public returns (bool success) {
242         require(_newLockState != locked);
243         locked = _newLockState;
244         return true;
245     }
246 	
247     function transferETH() onlyOwner external {
248         require(this.balance > 0);
249         require(owner.send(this.balance));
250     }
251 	
252 	// transfer balance to owner
253 	function withdrawEther(uint256 amount) onlyOwner {
254         require(msg.sender == owner); 
255 		owner.transfer(amount);
256 	}
257 	
258     /**
259      * Fallback function
260      *
261      * The function without name is the default function that is called whenever anyone sends funds to a contract
262      */
263     function() payable public {
264         require(msg.sender != address(0));
265 		require(msg.value > 0);		 
266         uint256 tokens = SafeMath.safeMult(msg.value, tokenExchangeRate);
267 		require(tokens + tokenRaised <= currentSupply);	
268         tokenRaised = SafeMath.safeAdd(tokenRaised, tokens);
269         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], tokens);
270         balanceOf[owner] = SafeMath.safeSub(balanceOf[owner], tokens);
271         IssueToken(msg.sender, tokens); 
272     }
273 }