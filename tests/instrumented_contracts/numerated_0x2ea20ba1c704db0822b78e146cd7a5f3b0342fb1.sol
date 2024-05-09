1 pragma solidity ^0.4.18;
2 /** ----------------------------------------------------------------------------------------------
3  * ZJLTToken by ZJLT Distributed Factoring Network Limited.
4  * An ERC20 standard
5  *
6  * author: ZJLT Distributed Factoring Network Team
7  */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error.
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 
43 contract ERC20 {
44 
45     uint256 public totalSupply;
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52 
53     function allowance(address owner, address spender) public view returns (uint256);
54     function approve(address spender, uint256 value) public returns (bool);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56 
57 }
58 
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 
94 }
95 
96 
97 interface TokenRecipient {
98     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
99 }
100 
101 
102 
103 contract TokenERC20 is ERC20, Ownable{
104     // Public variables of the token
105     string public name;
106     string public symbol;
107     uint8  public decimals = 18;
108     // 18 decimals is the strongly suggested default, avoid changing it
109     using SafeMath for uint256;
110     // Balances
111     mapping (address => uint256) balances;
112     // Allowances
113     mapping (address => mapping (address => uint256)) allowances;
114 
115 
116     // ----- Events -----
117     event Burn(address indexed from, uint256 value);
118 
119 
120     /**
121      * Constructor function
122      */
123     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol, uint8 _decimals) public {
124         name = _tokenName;                                   // Set the name for display purposes
125         symbol = _tokenSymbol;                               // Set the symbol for display purposes
126         decimals = _decimals;
127 
128         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
129         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
130     }
131 
132         /**
133      * @dev Fix for the ERC20 short address attack.
134      */
135     modifier onlyPayloadSize(uint size) {
136       if(msg.data.length < size + 4) {
137         revert();
138       }
139       _;
140     }
141     
142 
143     function balanceOf(address _owner) public view returns(uint256) {
144         return balances[_owner];
145     }
146 
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowances[_owner][_spender];
149     }
150 
151     /**
152      * Internal transfer, only can be called by this contract
153      */
154     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
155         // Prevent transfer to 0x0 address. Use burn() instead
156         require(_to != 0x0);
157         // Check if the sender has enough
158         require(balances[_from] >= _value);
159         // Check for overflows
160         require(balances[_to] + _value > balances[_to]);
161 
162         require(_value >= 0);
163         // Save this for an assertion in the future
164         uint previousBalances = balances[_from].add(balances[_to]);
165          // SafeMath.sub will throw if there is not enough balance.
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         emit Transfer(_from, _to, _value);
169         // Asserts are used to use static analysis to find bugs in your code. They should never fail
170         assert(balances[_from] + balances[_to] == previousBalances);
171 
172         return true;
173     }
174 
175     /**
176      * Transfer tokens
177      *
178      * Send `_value` tokens to `_to` from your account
179      *
180      * @param _to The address of the recipient
181      * @param _value the amount to send
182      */
183     function transfer(address _to, uint256 _value) public returns(bool) {
184         return _transfer(msg.sender, _to, _value);
185     }
186 
187     /**
188      * Transfer tokens from other address
189      *
190      * Send `_value` tokens to `_to` in behalf of `_from`
191      *
192      * @param _from The address of the sender
193      * @param _to The address of the recipient
194      * @param _value the amount to send
195      */
196     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
197         require(_to != address(0));
198         require(_value <= balances[_from]);
199         require(_value > 0);
200 
201         balances[_from] = balances[_from].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
204         emit Transfer(_from, _to, _value);
205         return true;
206     }
207 
208     /**
209      * Set allowance for other address
210      *
211      * Allows `_spender` to spend no more than `_value` tokens in your behalf
212      *
213      * @param _spender The address authorized to spend
214      * @param _value the max amount they can spend
215      */
216     function approve(address _spender, uint256 _value) public returns(bool) {
217         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
218         allowances[msg.sender][_spender] = _value;
219         emit Approval(msg.sender, _spender, _value);
220         return true;
221     }
222 
223     /**
224      * Set allowance for other address and notify
225      *
226      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
227      *
228      * @param _spender The address authorized to spend
229      * @param _value the max amount they can spend
230      * @param _extraData some extra information to send to the approved contract
231      */
232     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
233         if (approve(_spender, _value)) {
234             TokenRecipient spender = TokenRecipient(_spender);
235             spender.receiveApproval(msg.sender, _value, this, _extraData);
236             return true;
237         }
238         return false;
239     }
240 
241 
242   /**
243    * @dev Transfer tokens to multiple addresses
244    * @param _addresses The addresses that will receieve tokens
245    * @param _amounts The quantity of tokens that will be transferred
246    * @return True if the tokens are transferred correctly
247    */
248   function transferForMultiAddresses(address[] _addresses, uint256[] _amounts)  public returns (bool) {
249     for (uint256 i = 0; i < _addresses.length; i++) {
250       require(_addresses[i] != address(0));
251       require(_amounts[i] <= balances[msg.sender]);
252       require(_amounts[i] > 0);
253 
254       // SafeMath.sub will throw if there is not enough balance.
255       balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
256       balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
257       emit Transfer(msg.sender, _addresses[i], _amounts[i]);
258     }
259     return true;
260   }
261 
262     /**
263      * Destroy tokens
264      *
265      * Remove `_value` tokens from the system irreversibly
266      *
267      * @param _value the amount of money to burn
268      */
269     function burn(uint256 _value) public returns(bool) {
270         require(balances[msg.sender] >= _value);   // Check if the sender has enough
271         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
272         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
273         emit Burn(msg.sender, _value);
274         return true;
275     }
276 
277         /**
278      * Destroy tokens from other account
279      *
280      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
281      *
282      * @param _from the address of the sender
283      * @param _value the amount of money to burn
284      */
285     function burnFrom(address _from, uint256 _value) public returns(bool) {
286         require(balances[_from] >= _value);                // Check if the targeted balance is enough
287         require(_value <= allowances[_from][msg.sender]);    // Check allowance
288         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
289         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
290         totalSupply = totalSupply.sub(_value);                                 // Update totalSupply
291         emit Burn(_from, _value);
292         return true;
293     }
294 
295 
296     /**
297      * approve should be called when allowances[_spender] == 0. To increment
298      * allowances value is better to use this function to avoid 2 calls (and wait until
299      * the first transaction is mined)
300      * From MonolithDAO Token.sol
301      */
302     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
303         // Check for overflows
304         require(allowances[msg.sender][_spender].add(_addedValue) > allowances[msg.sender][_spender]);
305 
306         allowances[msg.sender][_spender] =allowances[msg.sender][_spender].add(_addedValue);
307         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
308         return true;
309     }
310 
311     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
312         uint oldValue = allowances[msg.sender][_spender];
313         if (_subtractedValue > oldValue) {
314             allowances[msg.sender][_spender] = 0;
315         } else {
316             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
317         }
318         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
319         return true;
320     }
321 
322 
323 }
324 
325 
326 contract ZJLTToken is TokenERC20 {
327 
328     function ZJLTToken() TokenERC20(2500000000, "ZJLTToken", "ZJLT Distributed Factoring Network", 18) public {
329 
330     }
331 	
332 	function () payable public {
333       //if ether is sent to this address, send it back.
334       //throw;
335       require(false);
336     }
337 }