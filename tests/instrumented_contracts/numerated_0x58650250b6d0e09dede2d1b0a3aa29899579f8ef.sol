1 pragma solidity ^0.4.18;
2 /** ----------------------------------------------------------------------------------------------
3  * author: Value of Criculation Team
4  */
5 
6 /**
7  * @dev Math operations with safety checks that throw on error.
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37     uint256 public totalSupply;
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     function allowance(address owner, address spender) public view returns (uint256);
43     function approve(address spender, uint256 value) public returns (bool);
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() public {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     emit OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 
85 interface TokenRecipient {
86     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
87 }
88 
89 contract TokenERC20 is ERC20, Ownable{
90     // Public variables of the token
91     string public name;
92     string public symbol;
93     uint8  public decimals = 18;
94     // 18 decimals is the strongly suggested default, avoid changing it
95     using SafeMath for uint256;
96     // Balances
97     mapping (address => uint256) balances;
98     // Allowances
99     mapping (address => mapping (address => uint256)) allowances;
100 
101     // ----- Events -----
102     event Burn(address indexed from, uint256 value);
103 
104     /**
105      * Constructor function
106      */
107     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
108         name = _tokenName;                                   // Set the name for display purposes
109         symbol = _tokenSymbol;                               // Set the symbol for display purposes
110         decimals = _decimals;
111 
112         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
113         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
114     }
115 
116     /**
117      * @dev Fix for the ERC20 short address attack.
118      */
119     modifier onlyPayloadSize(uint size) {
120       if(msg.data.length < size + 4) {
121         revert();
122       }
123       _;
124     }
125     
126 
127     function balanceOf(address _owner) public view returns(uint256) {
128         return balances[_owner];
129     }
130 
131     function allowance(address _owner, address _spender) public view returns (uint256) {
132         return allowances[_owner][_spender];
133     }
134 
135     /**
136      * Internal transfer, only can be called by this contract
137      */
138     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
139         // Prevent transfer to 0x0 address. Use burn() instead
140         require(_to != 0x0);
141         // Check if the sender has enough
142         require(balances[_from] >= _value);
143         // Check for overflows
144         require(balances[_to] + _value > balances[_to]);
145 
146         require(_value >= 0);
147         // Save this for an assertion in the future
148         uint previousBalances = balances[_from].add(balances[_to]);
149          // SafeMath.sub will throw if there is not enough balance.
150         balances[_from] = balances[_from].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         emit Transfer(_from, _to, _value);
153         // Asserts are used to use static analysis to find bugs in your code. They should never fail
154         assert(balances[_from] + balances[_to] == previousBalances);
155 
156         return true;
157     }
158 
159     /**
160      * Transfer tokens
161      *
162      * Send `_value` tokens to `_to` from your account
163      *
164      * @param _to The address of the recipient
165      * @param _value the amount to send
166      */
167     function transfer(address _to, uint256 _value) public returns(bool) {
168         return _transfer(msg.sender, _to, _value);
169     }
170 
171     /**
172      * Transfer tokens from other address
173      *
174      * Send `_value` tokens to `_to` in behalf of `_from`
175      *
176      * @param _from The address of the sender
177      * @param _to The address of the recipient
178      * @param _value the amount to send
179      */
180     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value > 0);
184 
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
188         emit Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193      * Set allowance for other address
194      *
195      * Allows `_spender` to spend no more than `_value` tokens in your behalf
196      *
197      * @param _spender The address authorized to spend
198      * @param _value the max amount they can spend
199      */
200     function approve(address _spender, uint256 _value) public returns(bool) {
201         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
202         allowances[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * Set allowance for other address and notify
209      *
210      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
211      *
212      * @param _spender The address authorized to spend
213      * @param _value the max amount they can spend
214      * @param _extraData some extra information to send to the approved contract
215      */
216     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
217         if (approve(_spender, _value)) {
218             TokenRecipient spender = TokenRecipient(_spender);
219             spender.receiveApproval(msg.sender, _value, this, _extraData);
220             return true;
221         }
222         return false;
223     }
224 
225 
226   /**
227    * @dev Transfer tokens to multiple addresses
228    * @param _addresses The addresses that will receieve tokens
229    * @param _amounts The quantity of tokens that will be transferred
230    * @return True if the tokens are transferred correctly
231    */
232   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
233     for (uint256 i = 0; i < _addresses.length; i++) {
234       require(_addresses[i] != address(0));
235       require(_amounts[i] <= balances[msg.sender]);
236       require(_amounts[i] > 0);
237 
238       // SafeMath.sub will throw if there is not enough balance.
239       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
240       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
241       emit Transfer(msg.sender, _addresses[i], _amounts[i]);
242     }
243     return true;
244   }
245 
246     /**
247      * Destroy tokens
248      *
249      * Remove `_value` tokens from the system irreversibly
250      *
251      * @param _value the amount of money to burn
252      */
253     function burn(uint256 _value) public returns(bool) {
254         require(balances[msg.sender] >= _value);   // Check if the sender has enough
255         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
256         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
257         emit Burn(msg.sender, _value);
258         return true;
259     }
260 
261     /**
262      * Destroy tokens from other account
263      *
264      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
265      *
266      * @param _from the address of the sender
267      * @param _value the amount of money to burn
268      */
269     function burnFrom(address _from, uint256 _value) public returns(bool) {
270         require(balances[_from] >= _value);                // Check if the targeted balance is enough
271         require(_value <= allowances[_from][msg.sender]);    // Check allowance
272         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
273         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
274         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
275         emit Burn(_from, _value);
276         return true;
277     }
278 
279 
280     /**
281      * approve should be called when allowances[_spender] == 0. To increment
282      * allowances value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      */
285     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286         // Check for overflows
287         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
288 
289         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
290         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
291         return true;
292     }
293 
294     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
295         uint oldValue = allowances[msg.sender][_spender];
296         if (_subtractedValue > oldValue) {
297             allowances[msg.sender][_spender] = 0;
298         } else {
299             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300         }
301         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
302         return true;
303     }
304 }
305 
306 contract VOCToken is TokenERC20 {
307     function VOCToken() TokenERC20(200000000, "Value of Criculation", "VOC", 8) public {
308 
309     }
310 	function () payable public {
311       require(false);
312     }
313 }