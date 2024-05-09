1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32 }
33 
34 contract Owned {
35     address public owner;
36     address public newOwner = address(0x0);
37     event OwnershipTransferred(address indexed _from, address indexed _to);
38     function Owned() public {
39         owner = msg.sender;
40     }
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0x0);
53     }
54 }
55 
56 
57 contract Pausable is Owned {
58   event Pause();
59   event Unpause();
60 
61   bool public paused = false;
62 
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   function pause() onlyOwner whenNotPaused public {
74     paused = true;
75     emit Pause();
76   }
77 
78   function unpause() onlyOwner whenPaused public {
79     paused = false;
80     emit Unpause();
81   }
82 }
83 
84 
85 interface tokenRecipient { 
86     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
87     
88 }
89 
90 contract ERC20Interface {
91     function totalSupply() public constant returns (uint256);
92     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
93     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
94     function transfer(address to, uint256 tokens) public returns (bool success);
95     function approve(address spender, uint256 tokens) public returns (bool success);
96     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
97     event Transfer(address indexed from, address indexed to, uint256 tokens);
98     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
99 }
100 
101 contract TokenBase is ERC20Interface, Pausable, SafeMath {
102     string public name;
103     string public symbol;
104     uint256 public decimals;
105     uint256 internal _totalSupply;
106     
107     mapping(address => uint256) balances;
108     mapping(address => mapping(address => uint256)) allowed;
109     mapping (address => bool) public frozenAccount;
110 
111     event FrozenFunds(address target, bool frozen);
112     event Burn(address indexed from, uint256 value);
113     
114     // ------------------------------------------------------------------------
115     // Total supply
116     // ------------------------------------------------------------------------
117     function totalSupply() public constant returns (uint256) {
118         return _totalSupply;
119     }
120     
121     // ------------------------------------------------------------------------
122     // Get the token balance for account `tokenOwner`
123     // ------------------------------------------------------------------------
124     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
125         return balances[tokenOwner];
126     }
127     
128     // ------------------------------------------------------------------------
129     // Returns the amount of tokens approved by the owner that can be
130     // transferred to the spender's account
131     // ------------------------------------------------------------------------
132     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
133         return allowed[tokenOwner][spender];
134     }
135 
136 
137     /**
138      * Internal transfer, only can be called by this contract
139      */
140     function _transfer(address _from, address _to, uint256 _value) internal whenNotPaused returns (bool success) {
141         require(_to != 0x0);                // Prevent transfer to 0x0 address. Use burn() instead
142         require(balances[_from] >= _value);            // Check if the sender has enough
143         require(!frozenAccount[_from]);                     // Check if sender is frozen
144         require(!frozenAccount[_to]);                       // Check if recipient is frozen
145         require( SafeMath.safeAdd(balances[_to], _value) > balances[_to]);          // Check for overflows
146         uint256 previousBalances =  SafeMath.safeAdd(balances[_from], balances[_to]);
147         balances[_from] = SafeMath.safeSub(balances[_from], _value);      // Subtract from the sender
148         balances[_to] = SafeMath.safeAdd(balances[_to], _value);          // Add the same to the recipient
149         assert(balances[_from] + balances[_to] == previousBalances);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * Transfer tokens
156      */
157     function transfer(address _to, uint256 _value) public returns (bool success){
158         _transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     /**
163      * Transfer tokens from other address
164      */
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166         require(_value <= allowed[_from][msg.sender]);     // Check allowance
167         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
168         _transfer(_from, _to, _value);
169         return true;
170     }
171 
172     
173     function approve(address spender, uint256 tokens) public whenNotPaused returns (bool success) {
174         require(tokens >= 0);
175         allowed[msg.sender][spender] = tokens;
176         emit Approval(msg.sender, spender, tokens);
177         return true;
178     }
179 
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
181         public whenNotPaused returns (bool success) {
182         tokenRecipient spender = tokenRecipient(_spender);
183         if (approve(_spender, _value)) {
184             spender.receiveApproval(msg.sender, _value, this, _extraData);
185             return true;
186         }
187     }
188 
189     /**
190      * Destroy tokens
191      */
192     
193     function burn(uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
194 		require(balances[msg.sender] >= _value);
195 		require(_value > 0);
196         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);            // Subtract from the sender
197         _totalSupply = SafeMath.safeSub(_totalSupply, _value);                                // Updates totalSupply
198         emit Burn(msg.sender, _value);
199         return true;
200     }
201 
202     /**
203      * Destroy tokens from another account
204      */
205     function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
206         require(balances[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowed[_from][msg.sender]);    // Check allowance
208         balances[_from] = SafeMath.safeSub(balances[_from], _value);    // Subtract from the targetd balance
209         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);  // Subtract from the sender's allowance
210         _totalSupply = SafeMath.safeSub(_totalSupply,_value);  
211         emit Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 contract CoolTourToken is TokenBase{
217 
218     string internal _tokenName = 'CoolTour Token';
219     string internal _tokenSymbol = 'CTU';
220     uint256 internal _tokenDecimals = 18;
221     uint256 internal _initialSupply = 2000000000;
222     
223 	/* Initializes contract with initial supply tokens to the creator of the contract */
224     function CoolTourToken() public {
225         _totalSupply = _initialSupply * 10 ** uint256(_tokenDecimals);  // Update total supply with the decimal amount
226         balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens
227         name = _tokenName;                                     // Set the name for display purposes
228         symbol = _tokenSymbol;                               // Set the symbol for display purposes
229         decimals = _tokenDecimals;
230         owner = msg.sender;
231     }
232 
233 	// can accept ether
234 	function() payable public {
235     }
236 
237     function freezeAccount(address target, bool value) onlyOwner public {
238         frozenAccount[target] = value;
239         emit FrozenFunds(target, value);
240     }
241     
242     function mintToken(uint256 amount) onlyOwner public {
243         balances[msg.sender] = SafeMath.safeAdd(balances[owner], amount);
244         _totalSupply = SafeMath.safeAdd(_totalSupply, amount);
245         emit Transfer(address(0x0), msg.sender, amount);
246     }
247     
248 	// transfer contract balance to owner
249 	function retrieveEther(uint256 amount) onlyOwner public {
250 	    require(amount > 0);
251 	    require(amount <= address(this).balance);
252 		msg.sender.transfer(amount);
253 	}
254 
255 	// transfer contract token balance to owner
256 	function retrieveToken(uint256 amount) onlyOwner public {
257         _transfer(this, msg.sender, amount);
258 	}
259 	
260 	// transfer contract token balance to owner
261 	function retrieveTokenByContract(address token, uint256 amount) onlyOwner public {
262         ERC20Interface(token).transfer(msg.sender, amount);
263 	}
264 
265 }