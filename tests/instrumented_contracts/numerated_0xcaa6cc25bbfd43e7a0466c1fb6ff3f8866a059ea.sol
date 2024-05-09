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
46         require(_newOwner != address(0x0));
47         newOwner = _newOwner;
48     }
49     function acceptOwnership() public {
50         require(msg.sender == newOwner);
51         emit OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         newOwner = address(0x0);
54     }
55 }
56 
57 
58 contract Pausable is Owned {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64   modifier whenNotPaused() {
65     require(!paused);
66     _;
67   }
68 
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     emit Pause();
77   }
78 
79   function unpause() onlyOwner whenPaused public {
80     paused = false;
81     emit Unpause();
82   }
83 }
84 
85 
86 interface tokenRecipient { 
87     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
88     
89 }
90 
91 contract ERC20Interface {
92     function totalSupply() public constant returns (uint256);
93     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
94     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
95     function transfer(address to, uint256 tokens) public returns (bool success);
96     function approve(address spender, uint256 tokens) public returns (bool success);
97     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
98     event Transfer(address indexed from, address indexed to, uint256 tokens);
99     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
100 }
101 
102 contract TokenBase is ERC20Interface, Pausable, SafeMath {
103     string public name;
104     string public symbol;
105     uint256 public decimals;
106     uint256 internal _totalSupply;
107     
108     mapping(address => uint256) balances;
109     mapping(address => mapping(address => uint256)) allowed;
110     mapping (address => bool) public frozenAccount;
111 
112     event FrozenFunds(address target, bool frozen);
113     event Burn(address indexed from, uint256 value);
114     
115     // ------------------------------------------------------------------------
116     // Total supply
117     // ------------------------------------------------------------------------
118     function totalSupply() public constant returns (uint256) {
119         return _totalSupply;
120     }
121     
122     // ------------------------------------------------------------------------
123     // Get the token balance for account `tokenOwner`
124     // ------------------------------------------------------------------------
125     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
126         return balances[tokenOwner];
127     }
128     
129     // ------------------------------------------------------------------------
130     // Returns the amount of tokens approved by the owner that can be
131     // transferred to the spender's account
132     // ------------------------------------------------------------------------
133     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
134         return allowed[tokenOwner][spender];
135     }
136 
137 
138     /**
139      * Internal transfer, only can be called by this contract
140      */
141     function _transfer(address _from, address _to, uint256 _value) internal whenNotPaused returns (bool success) {
142         require(_to != 0x0);                // Prevent transfer to 0x0 address. Use burn() instead
143         require(balances[_from] >= _value);            // Check if the sender has enough
144         require(!frozenAccount[_from]);                     // Check if sender is frozen
145         require(!frozenAccount[_to]);                       // Check if recipient is frozen
146         require( SafeMath.safeAdd(balances[_to], _value) > balances[_to]);          // Check for overflows
147         uint256 previousBalances =  SafeMath.safeAdd(balances[_from], balances[_to]);
148         balances[_from] = SafeMath.safeSub(balances[_from], _value);      // Subtract from the sender
149         balances[_to] = SafeMath.safeAdd(balances[_to], _value);          // Add the same to the recipient
150         assert(balances[_from] + balances[_to] == previousBalances);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155     /**
156      * Transfer tokens
157      */
158     function transfer(address _to, uint256 _value) public returns (bool success){
159         _transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163     /**
164      * Transfer tokens from other address
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
167         require(_value <= allowed[_from][msg.sender]);     // Check allowance
168         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
169         _transfer(_from, _to, _value);
170         return true;
171     }
172 
173     
174     function approve(address spender, uint256 tokens) public whenNotPaused returns (bool success) {
175         require(tokens >= 0);
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
182         public whenNotPaused returns (bool success) {
183         tokenRecipient spender = tokenRecipient(_spender);
184         if (approve(_spender, _value)) {
185             spender.receiveApproval(msg.sender, _value, this, _extraData);
186             return true;
187         }
188     }
189 
190     /**
191      * Destroy tokens
192      */
193     
194     function burn(uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
195 		require(balances[msg.sender] >= _value);
196 		require(_value > 0);
197         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);            // Subtract from the sender
198         _totalSupply = SafeMath.safeSub(_totalSupply, _value);                                // Updates totalSupply
199         emit Burn(msg.sender, _value);
200         return true;
201     }
202 
203     /**
204      * Destroy tokens from another account
205      */
206     function burnFrom(address _from, uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
207         require(balances[_from] >= _value);                // Check if the targeted balance is enough
208         require(_value <= allowed[_from][msg.sender]);    // Check allowance
209         balances[_from] = SafeMath.safeSub(balances[_from], _value);    // Subtract from the targetd balance
210         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);  // Subtract from the sender's allowance
211         _totalSupply = SafeMath.safeSub(_totalSupply,_value);  
212         emit Burn(_from, _value);
213         return true;
214     }
215 }
216 
217 contract FDataToken is TokenBase{
218 
219     string internal _tokenName = 'FData';
220     string internal _tokenSymbol = 'FDT';
221     uint256 internal _tokenDecimals = 18;
222     uint256 internal _initialSupply = 10000000000;
223     
224 	/* Initializes contract with initial supply tokens to the creator of the contract */
225     function FDataToken() public {
226         _totalSupply = _initialSupply * 10 ** uint256(_tokenDecimals);  // Update total supply with the decimal amount
227         balances[msg.sender] = _totalSupply;                // Give the creator all initial tokens
228         name = _tokenName;                                     // Set the name for display purposes
229         symbol = _tokenSymbol;                               // Set the symbol for display purposes
230         decimals = _tokenDecimals;
231         owner = msg.sender;
232     }
233 
234 	// can accept ether
235 	function() payable public {
236     }
237 
238     function freezeAccount(address target, bool value) onlyOwner public {
239         frozenAccount[target] = value;
240         emit FrozenFunds(target, value);
241     }
242     
243 	// transfer contract balance to owner
244 	function retrieveEther(uint256 amount) onlyOwner public {
245 	    require(amount > 0);
246 	    require(amount <= address(this).balance);
247 		msg.sender.transfer(amount);
248 	}
249 
250 	// transfer contract token balance to owner
251 	function retrieveToken(uint256 amount) onlyOwner public {
252         _transfer(this, msg.sender, amount);
253 	}
254 	
255 	// transfer contract token balance to owner
256 	function retrieveTokenByContract(address token, uint256 amount) onlyOwner public {
257         ERC20Interface(token).transfer(msg.sender, amount);
258 	}
259 
260 }