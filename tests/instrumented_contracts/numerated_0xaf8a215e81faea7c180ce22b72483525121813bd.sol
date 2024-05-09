1 pragma solidity ^0.4.18;
2 /** ----------------------------------------------------------------------------------------------
3  * ENGINE_Token by ENGINE Limited.
4  * An ERC20 standard
5  *
6  * author: ENGINE Team
7  */
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error.
13  */
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 
44 contract ERC20 {
45 
46     uint256 public totalSupply;
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     function balanceOf(address who) public view returns (uint256);
52     function transfer(address to, uint256 value) public returns (bool);
53 
54     function allowance(address owner, address spender) public view returns (uint256);
55     function approve(address spender, uint256 value) public returns (bool);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57 
58 }
59 
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() public {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 
98 interface TokenRecipient {
99     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
100 }
101 
102 
103 
104 contract TokenERC20 is ERC20, Ownable{
105     // Public variables of the token
106     string public name;
107     string public symbol;
108     uint8  public decimals = 18;
109     // 18 decimals is the strongly suggested default, avoid changing it
110     using SafeMath for uint256;
111     // Balances
112     mapping (address => uint256) balances;
113     // Allowances
114     mapping (address => mapping (address => uint256)) allowances;
115 
116 
117     // ----- Events -----
118     event Burn(address indexed from, uint256 value);
119 
120 
121     /**
122      * Constructor function
123      */
124     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
125         name = _tokenName;                                   // Set the name for display purposes
126         symbol = _tokenSymbol;                               // Set the symbol for display purposes
127         decimals = _decimals;
128 
129         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
130         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
131     }
132 
133         /**
134      * @dev Fix for the ERC20 short address attack.
135      */
136     modifier onlyPayloadSize(uint size) {
137       if(msg.data.length < size + 4) {
138         revert();
139       }
140       _;
141     }
142     
143 
144     function balanceOf(address _owner) public view returns(uint256) {
145         return balances[_owner];
146     }
147 
148     function allowance(address _owner, address _spender) public view returns (uint256) {
149         return allowances[_owner][_spender];
150     }
151 
152     /**
153      * Internal transfer, only can be called by this contract
154      */
155     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
156         // Prevent transfer to 0x0 address. Use burn() instead
157         require(_to != 0x0);
158         // Check if the sender has enough
159         require(balances[_from] >= _value);
160         // Check for overflows
161         require(balances[_to] + _value > balances[_to]);
162 
163         require(_value >= 0);
164         // Save this for an assertion in the future
165         uint previousBalances = balances[_from].add(balances[_to]);
166          // SafeMath.sub will throw if there is not enough balance.
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         Transfer(_from, _to, _value);
170         // Asserts are used to use static analysis to find bugs in your code. They should never fail
171         assert(balances[_from] + balances[_to] == previousBalances);
172 
173         return true;
174     }
175 
176     /**
177      * Transfer tokens
178      *
179      * Send `_value` tokens to `_to` from your account
180      *
181      * @param _to The address of the recipient
182      * @param _value the amount to send
183      */
184     function transfer(address _to, uint256 _value) public returns(bool) {
185         return _transfer(msg.sender, _to, _value);
186     }
187 
188     /**
189      * Transfer tokens from other address
190      *
191      * Send `_value` tokens to `_to` in behalf of `_from`
192      *
193      * @param _from The address of the sender
194      * @param _to The address of the recipient
195      * @param _value the amount to send
196      */
197     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
198         require(_to != address(0));
199         require(_value <= balances[_from]);
200         require(_value > 0);
201 
202         balances[_from] = balances[_from].sub(_value);
203         balances[_to] = balances[_to].add(_value);
204         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
205         Transfer(_from, _to, _value);
206         return true;
207     }
208 
209     /**
210      * Set allowance for other address
211      *
212      * Allows `_spender` to spend no more than `_value` tokens in your behalf
213      *
214      * @param _spender The address authorized to spend
215      * @param _value the max amount they can spend
216      */
217     function approve(address _spender, uint256 _value) public returns(bool) {
218         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
219         allowances[msg.sender][_spender] = _value;
220         Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     /**
225      * Set allowance for other address and notify
226      *
227      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
228      *
229      * @param _spender The address authorized to spend
230      * @param _value the max amount they can spend
231      * @param _extraData some extra information to send to the approved contract
232      */
233     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
234         if (approve(_spender, _value)) {
235             TokenRecipient spender = TokenRecipient(_spender);
236             spender.receiveApproval(msg.sender, _value, this, _extraData);
237             return true;
238         }
239         return false;
240     }
241 
242 
243   /**
244    * @dev Transfer tokens to multiple addresses
245    * @param _addresses The addresses that will receieve tokens
246    * @param _amounts The quantity of tokens that will be transferred
247    * @return True if the tokens are transferred correctly
248    */
249   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
250     for (uint256 i = 0; i < _addresses.length; i++) {
251       require(_addresses[i] != address(0));
252       require(_amounts[i] <= balances[msg.sender]);
253       require(_amounts[i] > 0);
254 
255       // SafeMath.sub will throw if there is not enough balance.
256       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
257       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
258       Transfer(msg.sender, _addresses[i], _amounts[i]);
259     }
260     return true;
261   }
262 
263     /**
264      * Destroy tokens
265      *
266      * Remove `_value` tokens from the system irreversibly
267      *
268      * @param _value the amount of money to burn
269      */
270     function burn(uint256 _value) public returns(bool) {
271         require(balances[msg.sender] >= _value);   // Check if the sender has enough
272         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
273         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
274         Burn(msg.sender, _value);
275         return true;
276     }
277 
278         /**
279      * Destroy tokens from other account
280      *
281      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
282      *
283      * @param _from the address of the sender
284      * @param _value the amount of money to burn
285      */
286     function burnFrom(address _from, uint256 _value) public returns(bool) {
287         require(balances[_from] >= _value);                // Check if the targeted balance is enough
288         require(_value <= allowances[_from][msg.sender]);    // Check allowance
289         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
290         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
291         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
292         Burn(_from, _value);
293         return true;
294     }
295 
296 
297     /**
298      * approve should be called when allowances[_spender] == 0. To increment
299      * allowances value is better to use this function to avoid 2 calls (and wait until
300      * the first transaction is mined)
301      * From MonolithDAO Token.sol
302      */
303     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
304         // Check for overflows
305         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
306 
307         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
308         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
309         return true;
310     }
311 
312     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
313         uint oldValue = allowances[msg.sender][_spender];
314         if (_subtractedValue > oldValue) {
315             allowances[msg.sender][_spender] = 0;
316         } else {
317             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318         }
319         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
320         return true;
321     }
322 
323 
324 }
325 
326 
327 contract EGCCToken is TokenERC20 {
328 
329     function EGCCToken() TokenERC20(10000000000, "Engine Token", "EGCC", 18) public {
330 
331     }
332 }