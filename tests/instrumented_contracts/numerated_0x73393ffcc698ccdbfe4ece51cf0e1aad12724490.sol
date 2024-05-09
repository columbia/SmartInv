1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 contract ERC20 {
34 
35     uint256 public totalSupply;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42 
43     function allowance(address owner, address spender) public view returns (uint256);
44     function approve(address spender, uint256 value) public returns (bool);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46 
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 
87 interface TokenRecipient {
88     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
89 }
90 
91 
92 
93 contract TokenERC20 is ERC20, Ownable{
94     // Public variables of the token
95     string public name;
96     string public symbol;
97     uint8  public decimals = 18;
98     // 18 decimals is the strongly suggested default, avoid changing it
99     using SafeMath for uint256;
100     // Balances
101     mapping (address => uint256) balances;
102     // Allowances
103     mapping (address => mapping (address => uint256)) allowances;
104 
105 
106     // ----- Events -----
107     event Burn(address indexed from, uint256 value);
108 
109 
110     /**
111      * Constructor function
112      */
113     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
114         name = _tokenName;                                   // Set the name for display purposes
115         symbol = _tokenSymbol;                               // Set the symbol for display purposes
116         decimals = _decimals;
117 
118         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
119         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
120     }
121 
122         /**
123      * @dev Fix for the ERC20 short address attack.
124      */
125     modifier onlyPayloadSize(uint size) {
126       if(msg.data.length < size + 4) {
127         revert();
128       }
129       _;
130     }
131     
132 
133     function balanceOf(address _owner) public view returns(uint256) {
134         return balances[_owner];
135     }
136 
137     function allowance(address _owner, address _spender) public view returns (uint256) {
138         return allowances[_owner][_spender];
139     }
140 
141     /**
142      * Internal transfer, only can be called by this contract
143      */
144     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
145         // Prevent transfer to 0x0 address. Use burn() instead
146         require(_to != 0x0);
147         // Check if the sender has enough
148         require(balances[_from] >= _value);
149         // Check for overflows
150         require(balances[_to] + _value > balances[_to]);
151 
152         require(_value >= 0);
153         // Save this for an assertion in the future
154         uint previousBalances = balances[_from].add(balances[_to]);
155          // SafeMath.sub will throw if there is not enough balance.
156         balances[_from] = balances[_from].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         Transfer(_from, _to, _value);
159         // Asserts are used to use static analysis to find bugs in your code. They should never fail
160         assert(balances[_from] + balances[_to] == previousBalances);
161 
162         return true;
163     }
164 
165     /**
166      * Transfer tokens
167      *
168      * Send `_value` tokens to `_to` from your account
169      *
170      * @param _to The address of the recipient
171      * @param _value the amount to send
172      */
173     function transfer(address _to, uint256 _value) public returns(bool) {
174         return _transfer(msg.sender, _to, _value);
175     }
176 
177     /**
178      * Transfer tokens from other address
179      *
180      * Send `_value` tokens to `_to` in behalf of `_from`
181      *
182      * @param _from The address of the sender
183      * @param _to The address of the recipient
184      * @param _value the amount to send
185      */
186     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
187         require(_to != address(0));
188         require(_value <= balances[_from]);
189         require(_value > 0);
190 
191         balances[_from] = balances[_from].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
194         Transfer(_from, _to, _value);
195         return true;
196     }
197 
198     /**
199      * Set allowance for other address
200      *
201      * Allows `_spender` to spend no more than `_value` tokens in your behalf
202      *
203      * @param _spender The address authorized to spend
204      * @param _value the max amount they can spend
205      */
206     function approve(address _spender, uint256 _value) public returns(bool) {
207         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
208         allowances[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     /**
214      * Set allowance for other address and notify
215      *
216      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
217      *
218      * @param _spender The address authorized to spend
219      * @param _value the max amount they can spend
220      * @param _extraData some extra information to send to the approved contract
221      */
222     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
223         if (approve(_spender, _value)) {
224             TokenRecipient spender = TokenRecipient(_spender);
225             spender.receiveApproval(msg.sender, _value, this, _extraData);
226             return true;
227         }
228         return false;
229     }
230 
231 
232   /**
233    * @dev Transfer tokens to multiple addresses
234    * @param _addresses The addresses that will receieve tokens
235    * @param _amounts The quantity of tokens that will be transferred
236    * @return True if the tokens are transferred correctly
237    */
238   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
239     for (uint256 i = 0; i < _addresses.length; i++) {
240       require(_addresses[i] != address(0));
241       require(_amounts[i] <= balances[msg.sender]);
242       require(_amounts[i] > 0);
243 
244       // SafeMath.sub will throw if there is not enough balance.
245       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
246       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
247       Transfer(msg.sender, _addresses[i], _amounts[i]);
248     }
249     return true;
250   }
251 
252     /**
253      * Destroy tokens
254      *
255      * Remove `_value` tokens from the system irreversibly
256      *
257      * @param _value the amount of money to burn
258      */
259     function burn(uint256 _value) public returns(bool) {
260         require(balances[msg.sender] >= _value);   // Check if the sender has enough
261         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
262         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
263         Burn(msg.sender, _value);
264         return true;
265     }
266 
267         /**
268      * Destroy tokens from other account
269      *
270      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
271      *
272      * @param _from the address of the sender
273      * @param _value the amount of money to burn
274      */
275     function burnFrom(address _from, uint256 _value) public returns(bool) {
276         require(balances[_from] >= _value);                // Check if the targeted balance is enough
277         require(_value <= allowances[_from][msg.sender]);    // Check allowance
278         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
279         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
280         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
281         Burn(_from, _value);
282         return true;
283     }
284 
285 
286     /**
287      * approve should be called when allowances[_spender] == 0. To increment
288      * allowances value is better to use this function to avoid 2 calls (and wait until
289      * the first transaction is mined)
290      * From MonolithDAO Token.sol
291      */
292     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
293         // Check for overflows
294         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
295 
296         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
297         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
298         return true;
299     }
300 
301     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302         uint oldValue = allowances[msg.sender][_spender];
303         if (_subtractedValue > oldValue) {
304             allowances[msg.sender][_spender] = 0;
305         } else {
306             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307         }
308         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
309         return true;
310     }
311 
312 
313 }
314 
315 
316 contract STBToken is TokenERC20 {
317 
318     function STBToken() TokenERC20(970000000, "STBToken", "STB", 18) public {
319 
320     }
321 }