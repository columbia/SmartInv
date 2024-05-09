1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // CEW token contract
6 //
7 // Symbol           : CEW
8 // Name             : Cewnote
9 // Total Supply     : 200.000.000
10 // Decimals         : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25     // benefit is lost if 'b' is also tested.
26     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27     if (a == 0) {
28       return 0;
29     }
30 
31     c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35   
36   
37 
38   /**
39   * @dev Integer division of two numbers, truncating the quotient.
40   */
41   function div(uint256 a, uint256 b) internal pure returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     // uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return a / b;
46   }
47 
48   /**
49   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50   */
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   /**
57   * @dev Adds two numbers, throws on overflow.
58   */
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74 
75   address public owner;
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81    constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner)public onlyOwner {
98     require(newOwner != address(0));
99     owner = newOwner;
100   }
101 }
102 
103 // ----------------------------------------------------------------------------
104 // ERC Token Standard #20 Interface
105 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
106 // ----------------------------------------------------------------------------
107 contract ERC20Interface {
108     function totalSupply() public view returns (uint);
109     function balanceOf(address tokenOwner) public view returns (uint balance);
110     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
111     function transfer(address to, uint tokens) public returns (bool success);
112     function approve(address spender, uint tokens) public returns (bool success);
113     function transferFrom(address from, address to, uint tokens) public returns (bool success);
114 
115     event Transfer(address indexed from, address indexed to, uint tokens);
116     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
117 }
118 
119 
120 // ----------------------------------------------------------------------------
121 // ERC20 Token, with the addition of symbol, name and decimals and an
122 // initial fixed supply
123 // ----------------------------------------------------------------------------
124 contract CewnoteToken is ERC20Interface, Ownable {
125     
126     using SafeMath for uint;
127 
128     string public symbol;
129     string public  name;
130     uint8 public decimals;
131     uint public _totalSupply;
132 
133     mapping(address => uint) balances;
134     mapping(address => mapping(address => uint)) allowed;
135     mapping (address => bool) public frozenAccount;
136     
137 
138   /* This generates a public event on the blockchain that will notify clients */
139   event FrozenFunds(
140       address target, 
141       bool frozen
142       );
143   
144     event Burn(
145         address indexed burner, 
146         uint256 value
147         );
148 
149 
150 
151     // ------------------------------------------------------------------------
152     // Constructor
153     // ------------------------------------------------------------------------
154     constructor() public {
155         symbol = "CEW";
156         name = "Cewnote";
157         decimals = 18;
158         _totalSupply = 200000000;
159         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
160         balances[msg.sender] = _totalSupply;
161         emit Transfer(address(0), msg.sender, _totalSupply);
162     }
163     
164     
165     // ------------------------------------------------------------------------
166     // Reject when someone sends ethers to this contract
167     // ------------------------------------------------------------------------
168     function() public payable {
169         revert();
170     }
171     
172     
173     // ------------------------------------------------------------------------
174     // Total supply
175     // ------------------------------------------------------------------------
176     function totalSupply() public view returns (uint) {
177         return _totalSupply;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Get the token balance for account `tokenOwner`
183     // ------------------------------------------------------------------------
184     function balanceOf(address tokenOwner) public view returns (uint balance) {
185         return balances[tokenOwner];
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Transfer the balance from token owner's account to `to` account
191     // - Owner's account must have sufficient balance to transfer
192     // - 0 value transfers are allowed
193     // ------------------------------------------------------------------------
194     function transfer(address to, uint tokens) public returns (bool success) {
195         require(to != address(0));
196         require(tokens > 0);
197         require(balances[msg.sender] >= tokens);
198         require(!frozenAccount[msg.sender]);
199         
200         balances[msg.sender] = balances[msg.sender].sub(tokens);
201         balances[to] = balances[to].add(tokens);
202         emit Transfer(msg.sender, to, tokens);
203         return true;
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Token owner can approve for `spender` to transferFrom(...) `tokens`
209     // from the token owner's account
210     //
211     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
212     // recommends that there are no checks for the approval double-spend attack
213     // as this should be implemented in user interfaces 
214     // ------------------------------------------------------------------------
215     function approve(address spender, uint tokens) public returns (bool success) {
216         require(spender != address(0));
217         require(tokens > 0);
218         
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Transfer `tokens` from the `from` account to the `to` account
227     // 
228     // The calling account must already have sufficient tokens approve(...)-d
229     // for spending from the `from` account and
230     // - From account must have sufficient balance to transfer
231     // - Spender must have sufficient allowance to transfer
232     // ------------------------------------------------------------------------
233     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
234         require(from != address(0));
235         require(to != address(0));
236         require(tokens > 0);
237         require(balances[from] >= tokens);
238         require(allowed[from][msg.sender] >= tokens);
239         require(!frozenAccount[from]);
240 
241         
242         balances[from] = balances[from].sub(tokens);
243         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
244         balances[to] = balances[to].add(tokens);
245         emit Transfer(from, to, tokens);
246         return true;
247     }
248 
249 
250     // ------------------------------------------------------------------------
251     // Returns the amount of tokens approved by the owner that can be
252     // transferred to the spender's account
253     // ------------------------------------------------------------------------
254     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
255         return allowed[tokenOwner][spender];
256     }
257     
258     
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281     
282     
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue > oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310   /**
311    * 
312    * @notice `freeze? Prevent | Allow` `target` from sending tokens
313    * @param target Address to be frozen
314    * @param freeze either to freeze it or not
315     */
316     
317     function freezeAccount(address target, bool freeze) onlyOwner public {
318         frozenAccount[target] = freeze;
319         emit FrozenFunds(target, freeze);
320     }
321     
322 /**
323    * @dev Internal function that burns an amount of the token of a given
324    * account.
325    * @param _account The account whose tokens will be burnt.
326    * @param _amount The amount that will be burnt.
327    */
328   function _burn(address _account, uint256 _amount) internal {
329     require(_account != 0);
330     require(_amount <= balances[_account]);
331 
332     _totalSupply = _totalSupply.sub(_amount);
333     balances[_account] = balances[_account].sub(_amount);
334     emit Transfer(_account, address(0), _amount);
335     emit Burn(msg.sender, _amount);
336   }
337 
338   /**
339    * @dev Internal function that burns an amount of the token of a given
340    * account, deducting from the sender's allowance for said account. Uses the
341    * internal _burn function.
342    * @param _account The account whose tokens will be burnt.
343    * @param _amount The amount that will be burnt.
344    */
345   function burnFrom(address _account, uint256 _amount) public {
346     require(_amount <= allowed[_account][msg.sender]);
347 
348     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
349     // this function needs to emit an event with the updated approval.
350     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
351     _burn(_account, _amount);
352   }
353 
354   /**
355    * @dev Burns a specific amount of tokens.
356    * @param _value The amount of token to be burned.
357    */
358   function burn(uint256 _value) public {
359     _burn(msg.sender, _value);
360   }
361 
362 }