1 pragma solidity ^0.4.18;
2 /** ----------------------------------------------------------------------------------------------
3  * author: CosmosGameChain Team
4  * date: 2019-05-01
5  */
6 
7 /**
8  * @dev Math operations with safety checks that throw on error.
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ERC20 {
38     uint256 public totalSupply;
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     function allowance(address owner, address spender) public view returns (uint256);
44     function approve(address spender, uint256 value) public returns (bool);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     emit OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 
86 interface TokenRecipient {
87     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
88 }
89 
90 contract TokenERC20 is ERC20, Ownable{
91     // Public variables of the token
92     string public name;
93     string public symbol;
94     uint8  public decimals = 18;
95     // 18 decimals is the strongly suggested default, avoid changing it
96     using SafeMath for uint256;
97     // Balances
98     mapping (address => uint256) balances;
99     // Allowances
100     mapping (address => mapping (address => uint256)) allowances;
101 
102     // ----- Events -----
103     event Burn(address indexed from, uint256 value);
104 
105     /**
106      * Constructor function
107      */
108     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
109         name = _tokenName;                                   // Set the name for display purposes
110         symbol = _tokenSymbol;                               // Set the symbol for display purposes
111         decimals = _decimals;
112 
113         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
114         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
115     }
116 
117     /**
118      * @dev Fix for the ERC20 short address attack.
119      */
120     modifier onlyPayloadSize(uint size) {
121       if(msg.data.length < size + 4) {
122         revert();
123       }
124       _;
125     }
126     
127 
128     function balanceOf(address _owner) public view returns(uint256) {
129         return balances[_owner];
130     }
131 
132     function allowance(address _owner, address _spender) public view returns (uint256) {
133         return allowances[_owner][_spender];
134     }
135 
136     /**
137      * Internal transfer, only can be called by this contract
138      */
139     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
140         // Prevent transfer to 0x0 address. Use burn() instead
141         require(_to != 0x0);
142         // Check if the sender has enough
143         require(balances[_from] >= _value);
144         // Check for overflows
145         require(balances[_to] + _value > balances[_to]);
146 
147         require(_value >= 0);
148         // Save this for an assertion in the future
149         uint previousBalances = balances[_from].add(balances[_to]);
150          // SafeMath.sub will throw if there is not enough balance.
151         balances[_from] = balances[_from].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         emit Transfer(_from, _to, _value);
154         // Asserts are used to use static analysis to find bugs in your code. They should never fail
155         assert(balances[_from] + balances[_to] == previousBalances);
156 
157         return true;
158     }
159 
160     /**
161      * Transfer tokens
162      *
163      * Send `_value` tokens to `_to` from your account
164      *
165      * @param _to The address of the recipient
166      * @param _value the amount to send
167      */
168     function transfer(address _to, uint256 _value) public returns(bool) {
169         return _transfer(msg.sender, _to, _value);
170     }
171 
172     /**
173      * Transfer tokens from other address
174      *
175      * Send `_value` tokens to `_to` in behalf of `_from`
176      *
177      * @param _from The address of the sender
178      * @param _to The address of the recipient
179      * @param _value the amount to send
180      */
181     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
182         require(_to != address(0));
183         require(_value <= balances[_from]);
184         require(_value > 0);
185 
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
189         emit Transfer(_from, _to, _value);
190         return true;
191     }
192 
193     /**
194      * Set allowance for other address
195      *
196      * Allows `_spender` to spend no more than `_value` tokens in your behalf
197      *
198      * @param _spender The address authorized to spend
199      * @param _value the max amount they can spend
200      */
201     function approve(address _spender, uint256 _value) public returns(bool) {
202         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
203         allowances[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209      * Set allowance for other address and notify
210      *
211      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
212      *
213      * @param _spender The address authorized to spend
214      * @param _value the max amount they can spend
215      * @param _extraData some extra information to send to the approved contract
216      */
217     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
218         if (approve(_spender, _value)) {
219             TokenRecipient spender = TokenRecipient(_spender);
220             spender.receiveApproval(msg.sender, _value, this, _extraData);
221             return true;
222         }
223         return false;
224     }
225 
226 
227   /**
228    * @dev Transfer tokens to multiple addresses
229    * @param _addresses The addresses that will receieve tokens
230    * @param _amounts The quantity of tokens that will be transferred
231    * @return True if the tokens are transferred correctly
232    */
233   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
234     for (uint256 i = 0; i < _addresses.length; i++) {
235       require(_addresses[i] != address(0));
236       require(_amounts[i] <= balances[msg.sender]);
237       require(_amounts[i] > 0);
238 
239       // SafeMath.sub will throw if there is not enough balance.
240       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
241       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
242       emit Transfer(msg.sender, _addresses[i], _amounts[i]);
243     }
244     return true;
245   }
246 
247     /**
248      * Destroy tokens
249      *
250      * Remove `_value` tokens from the system irreversibly
251      *
252      * @param _value the amount of money to burn
253      */
254     function burn(uint256 _value) public returns(bool) {
255         require(balances[msg.sender] >= _value);   // Check if the sender has enough
256         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
257         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
258         emit Burn(msg.sender, _value);
259         return true;
260     }
261 
262     /**
263      * Destroy tokens from other account
264      *
265      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
266      *
267      * @param _from the address of the sender
268      * @param _value the amount of money to burn
269      */
270     function burnFrom(address _from, uint256 _value) public returns(bool) {
271         require(balances[_from] >= _value);                // Check if the targeted balance is enough
272         require(_value <= allowances[_from][msg.sender]);    // Check allowance
273         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
274         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Subtract from the sender's allowance
275         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
276         emit Burn(_from, _value);
277         return true;
278     }
279 
280 
281     /**
282      * approve should be called when allowances[_spender] == 0. To increment
283      * allowances value is better to use this function to avoid 2 calls (and wait until
284      * the first transaction is mined)
285      */
286     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
287         // Check for overflows
288         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
289 
290         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
291         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
292         return true;
293     }
294 
295     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296         uint oldValue = allowances[msg.sender][_spender];
297         if (_subtractedValue > oldValue) {
298             allowances[msg.sender][_spender] = 0;
299         } else {
300             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301         }
302         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
303         return true;
304     }
305 }
306 
307 contract CosmosGameChainToken is TokenERC20 {
308     function CosmosGameChainToken() TokenERC20(3000000000, "Cosmos Game Chain Token", "CGCT", 8) public {
309 
310     }
311 	function () payable public {
312       require(false);
313     }
314 }