1 pragma solidity ^0.5.12;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 library address_make_payable {
46    function make_payable(address x) internal pure returns (address payable) {
47       return address(uint160(x));
48    }
49 }
50 
51 contract owned {
52     
53     using address_make_payable for address;
54      
55     address payable public owner;
56 
57     constructor()  public{
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address newOwner) onlyOwner public {
67         address payable addr = address(newOwner).make_payable();
68         owner = addr;
69     }
70 }
71 
72 interface tokenRecipient  { function  receiveApproval (address  _from, uint256  _value, address  _token, bytes calldata _extraData) external ; }
73 
74 contract TokenERC20 {
75     // Public variables of the token
76     string public name;
77     string public symbol;
78     uint8 public decimals = 8;
79     // 18 decimals is the strongly suggested default, avoid changing it
80     uint256 public totalSupply;
81 
82     // This creates an array with all balances
83     mapping (address => uint256) public balanceOf;
84     mapping (address => mapping (address => uint256)) public allowance;
85 
86     // This generates a public event on the blockchain that will notify clients
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     // This notifies clients about the amount burnt
90     event Burn(address indexed from, uint256 value);
91 
92     /**
93      * Constrctor function
94      *
95      * Initializes contract with initial supply tokens to the creator of the contract
96      */
97     constructor(
98         uint256 initialSupply,
99          string memory tokenName,
100          string memory tokenSymbol
101     ) public {
102         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
103         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
104         name = tokenName;                                   // Set the name for display purposes
105         symbol = tokenSymbol;                               // Set the symbol for display purposes
106     }
107 
108     /**
109      * Internal transfer, only can be called by this contract
110      */
111     function _transfer(address _from, address _to, uint _value) internal {
112         // Prevent transfer to 0x0 address. Use burn() instead
113         //require(_to != 0x0);
114         assert(_to != address(0x0));
115         // Check if the sender has enough
116         require(balanceOf[_from] >= _value);
117         // Check for overflows
118         require(balanceOf[_to] + _value > balanceOf[_to]);
119         // Save this for an assertion in the future
120         uint previousBalances = balanceOf[_from] + balanceOf[_to];
121         // Subtract from the sender
122         balanceOf[_from] -= _value;
123         // Add the same to the recipient
124         balanceOf[_to] += _value;
125         emit Transfer(_from, _to, _value);
126         // Asserts are used to use static analysis to find bugs in your code. They should never fail
127         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
128     }
129 
130 
131     /**
132      * Transfer tokens
133      *
134      * Send `_value` tokens to `_to` from your account
135      *
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transfer(address _to, uint256 _value) public {
140         _transfer(msg.sender, _to, _value);
141     }
142 
143     /**
144      * Transfer tokens from other address
145      *
146      * Send `_value` tokens to `_to` in behalf of `_from`
147      *
148      * @param _from The address of the sender
149      * @param _to The address of the recipient
150      * @param _value the amount to send
151      */
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
153         require(_value <= allowance[_from][msg.sender]);     // Check allowance
154         allowance[_from][msg.sender] -= _value;
155         _transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160      * Set allowance for other address
161      *
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf
163      *
164      * @param _spender The address authorized to spend
165      * @param _value the max amount they can spend
166      */
167     function approve(address _spender, uint256 _value) public
168         returns (bool success) {
169         allowance[msg.sender][_spender] = _value;
170         return true;
171     }
172 
173     /**
174      * Set allowance for other address and notify
175      *
176      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
177      *
178      * @param _spender The address authorized to spend
179      * @param _value the max amount they can spend
180      * @param _extraData some extra information to send to the approved contract
181      */
182     function approveAndCall(address _spender, uint256  _value, bytes memory _extraData)
183         public
184         returns (bool success) {
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, address(this),  _extraData);
188             return true;
189         }
190     }
191 
192     /**
193      * Destroy tokens
194      *
195      * Remove `_value` tokens from the system irreversibly
196      *
197      * @param _value the amount of money to burn
198      */
199     function burn(uint256 _value) public returns (bool success) {
200         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
201         balanceOf[msg.sender] -= _value;            // Subtract from the sender
202         totalSupply -= _value;                      // Updates totalSupply
203         emit Burn(msg.sender, _value);
204         return true;
205     }
206 
207     /**
208      * Destroy tokens from other account
209      *
210      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
211      *
212      * @param _from the address of the sender
213      * @param _value the amount of money to burn
214      */
215     function burnFrom(address _from, uint256 _value) public returns (bool success) {
216         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
217         require(_value <= allowance[_from][msg.sender]);    // Check allowance
218         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
219         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
220         totalSupply -= _value;                              // Update totalSupply
221         emit Burn(_from, _value);
222         return true;
223     }
224 }
225 
226 /******************************************/
227 /*       ADVANCED TOKEN STARTS HERE       */
228 /******************************************/
229 
230 contract FSUToken is owned, TokenERC20 {
231 
232     using SafeMath for uint256;
233     mapping (address => uint8)  lockBackList;
234     event mylog(uint code);
235 
236     function() external payable{
237         transEth();
238     }
239     
240     /* Initializes contract with initial supply tokens to the creator of the contract */
241     constructor(
242         uint256 initialSupply,
243         string memory tokenName,
244         string memory tokenSymbol
245     ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}
246 
247     function transfer(address _to, uint256 _value) public {
248      
249         _transfer(msg.sender, _to, _value);
250     }
251 
252     /* Internal transfer, only can be called by this contract */
253     function _transfer(address _from, address _to, uint256 _value) internal {
254         
255         require(lockBackList[_from]==0);
256         assert(_to != address(0x0));
257         //require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
258         require(balanceOf[_from] >= _value);               // Check if the sender has enough
259         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
260         balanceOf[_from] -= _value;                         // Subtract from the sender
261         balanceOf[_to] += _value;                           // Add the same to the recipient
262         emit Transfer(_from, _to, _value);
263         emit mylog(0);
264     }
265     
266      /// @notice Create `mintedAmount` tokens and send it to `target`
267     /// @param target Address to receive the tokens
268     /// @param mintedAmount the amount of tokens it will receive
269     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns(bool) {
270         balanceOf[target] += mintedAmount;
271         totalSupply += mintedAmount;
272         emit Transfer(address(0x0), address(this), mintedAmount);
273         emit Transfer(address(this), target, mintedAmount);
274         emit mylog(0);
275         return true;
276     }
277     
278     //Destroy tokens
279     function destroyToken(address target,uint256 mintedAmount ) onlyOwner public  returns(bool) {
280 
281         require(balanceOf[target] >= mintedAmount);
282 
283         balanceOf[target] -=mintedAmount;
284         //balanceOf[target] += mintedAmount;
285         totalSupply -= mintedAmount;
286         //Transfer(0, this, mintedAmount);
287         emit Transfer(target, address(0x0), mintedAmount);
288         emit mylog(0);
289         return true;
290     }
291     
292     function lockBack(address target) onlyOwner public  returns(bool){
293         lockBackList[target] = 1;
294     }
295     
296     function unLockBack(address target) onlyOwner public  returns(bool){
297         lockBackList[target] = 0;
298     }
299     
300     function batchTranToken(address[] memory _toAddrs, uint256[] memory _values)  onlyOwner public {
301         uint256 sendTotal = 0;
302         for (uint256 i = 0; i < _toAddrs.length; i++) {
303             assert(_toAddrs[i] != address(0x0));
304             sendTotal = sendTotal.add(_values[i]);
305         }
306         
307         require(balanceOf[msg.sender] >= sendTotal);
308         for (uint256 j = 0; j < _toAddrs.length; j++) {
309              _transfer(msg.sender, _toAddrs[j], _values[j]);
310         }
311     }
312     
313     function transEth() public payable{
314         (bool success, ) = owner.call.value(msg.value)("");
315         require(success, "Transfer failed.");
316     }
317     
318 }