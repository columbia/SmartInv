1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0 || b == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b, "Mul overflow!");
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         return c;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a, "Sub overflow!");
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         require(c >= a, "Add overflow!");
44         return c;
45     }
46 }
47 
48 // ----------------------------------------------------------------------------
49 // ERC Token Standard #20 Interface
50 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface {
53 
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58     function balanceOf(address _owner) external view returns (uint256);
59     function transfer(address _to, uint256 _value) external returns(bool);
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68 
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     modifier onlyOwner {
75         require(msg.sender == owner, "Only Owner can do that!");
76         _;
77     }
78 
79     function transferOwnership(address _newOwner)
80     external onlyOwner {
81         newOwner = _newOwner;
82     }
83 
84     function acceptOwnership()
85     external {
86         require(msg.sender == newOwner, "You are not new Owner!");
87         owner = newOwner;
88         newOwner = address(0);
89         emit OwnershipTransferred(owner, newOwner);
90     }
91 }
92 
93 contract Permissioned {
94 
95     function approve(address _spender, uint256 _value) public returns(bool);
96     function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
97     function allowance(address _owner, address _spender) external view returns (uint256);
98 
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 contract Burnable {
103 
104     function burn(uint256 _value) external returns(bool);
105     function burnFrom(address _from, uint256 _value) external returns(bool);
106 
107     // This notifies clients about the amount burnt
108     event Burn(address indexed _from, uint256 _value);
109 }
110 
111 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
112 
113 contract Aligato is ERC20Interface, Owned, Permissioned, Burnable {
114 
115     using SafeMath for uint256; //Be aware of overflows
116 
117     // This creates an array with all balances
118     mapping(address => uint256) internal _balanceOf;
119 
120     // This creates an array with all allowance
121     mapping(address => mapping(address => uint256)) internal _allowance;
122 
123     bool public isLocked = true; //only contract Owner can transfer tokens
124 
125     uint256 icoSupply = 0;
126 
127     //set ICO balance and emit
128     function setICO(address user, uint256 amt) internal{
129         uint256 amt2 = amt * (10 ** uint256(decimals));
130         _balanceOf[user] = amt2;
131         emit Transfer(0x0, user, amt2);
132         icoSupply += amt2;
133     }
134 
135     // As ICO been done on platform, we need set proper amouts for ppl that participate
136    
137 
138     /**
139     * Constructor function
140     *
141     * Initializes contract with initial supply tokens to the creator of the contract
142     */
143     constructor(string _symbol, string _name, uint256 _supply, uint8 _decimals)
144     public {
145         require(_supply != 0, "Supply required!"); //avoid accidental deplyment with zero balance
146         owner = msg.sender;
147         symbol = _symbol;
148         name = _name;
149         decimals = _decimals;
150         
151         totalSupply = _supply.mul(10 ** uint256(decimals)); //supply in constuctor is w/o decimal zeros
152         _balanceOf[msg.sender] = totalSupply - icoSupply;
153         emit Transfer(address(0), msg.sender, totalSupply - icoSupply);
154     }
155 
156     // unlock transfers for everyone
157     function unlock() external onlyOwner returns (bool success)
158     {
159         require (isLocked == true, "It is unlocked already!"); //you can unlock only once
160         isLocked = false;
161         return true;
162     }
163 
164     /**
165     * Get the token balance for account
166     *
167     * Get token balance of `_owner` account
168     *
169     * @param _owner The address of the owner
170     */
171     function balanceOf(address _owner)
172     external view
173     returns(uint256 balance) {
174         return _balanceOf[_owner];
175     }
176 
177     /**
178     * Internal transfer, only can be called by this contract
179     */
180     function _transfer(address _from, address _to, uint256 _value)
181     internal {
182         // check that contract is unlocked
183         require (isLocked == false || _from == owner, "Contract is locked!");
184         // Prevent transfer to 0x0 address. Use burn() instead
185         require(_to != address(0), "Can`t send to 0x0, use burn()");
186         // Check if the sender has enough
187         require(_balanceOf[_from] >= _value, "Not enough balance!");
188         // Subtract from the sender
189         _balanceOf[_from] = _balanceOf[_from].sub(_value);
190         // Add the same to the recipient
191         _balanceOf[_to] = _balanceOf[_to].add(_value);
192         emit Transfer(_from, _to, _value);
193     }
194 
195     /**
196     * Transfer tokens
197     *
198     * Send `_value` tokens to `_to` from your account
199     *
200     * @param _to The address of the recipient
201     * @param _value the amount to send
202     */
203     function transfer(address _to, uint256 _value)
204     external
205     returns(bool success) {
206         _transfer(msg.sender, _to, _value);
207         return true;
208     }
209 
210     /**
211     * Transfer tokens from other address
212     *
213     * Send `_value` tokens to `_to` on behalf of `_from`
214     *
215     * @param _from The address of the sender
216     * @param _to The address of the recipient
217     * @param _value the amount to send
218     */
219     function transferFrom(address _from, address _to, uint256 _value)
220     external
221     returns(bool success) {
222         // Check allowance
223         require(_value <= _allowance[_from][msg.sender], "Not enough allowance!");
224         // Check balance
225         require(_value <= _balanceOf[_from], "Not enough balance!");
226         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
227         _transfer(_from, _to, _value);
228         emit Approval(_from, _to, _allowance[_from][_to]);
229         return true;
230     }
231 
232     /**
233     * Set allowance for other address
234     *
235     * Allows `_spender` to spend no more than `_value` tokens on your behalf
236     *
237     * @param _spender The address authorized to spend
238     * @param _value the max amount they can spend
239     */
240     function approve(address _spender, uint256 _value)
241     public
242     returns(bool success) {
243         _allowance[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247 
248     /**
249     * Set allowance for other address and notify
250     *
251     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
252     *
253     * @param _spender The address authorized to spend
254     * @param _value the max amount they can spend
255     * @param _extraData some extra information to send to the approved contract
256     */
257     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
258     external
259     returns(bool success) {
260         tokenRecipient spender = tokenRecipient(_spender);
261         if (approve(_spender, _value)) {
262             spender.receiveApproval(msg.sender, _value, this, _extraData);
263             return true;
264         }
265     }
266 
267     /**
268     * @dev Function to check the amount of tokens that an owner allowed to a spender.
269     * @param _owner address The address which owns the funds.
270     * @param _spender address The address which will spend the funds.
271     * @return A uint256 specifying the amount of tokens still available for the spender.
272     */
273     function allowance(address _owner, address _spender)
274     external view
275     returns(uint256 value) {
276         return _allowance[_owner][_spender];
277     }
278 
279     /**
280     * Destroy tokens
281     *
282     * Remove `_value` tokens from the system irreversibly
283     *
284     * @param _value the amount of money to burn
285     */
286     function burn(uint256 _value)
287     external
288     returns(bool success) {
289         _burn(msg.sender, _value);
290         return true;
291     }
292 
293     /**
294     * Destroy tokens from other account
295     *
296     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
297     *
298     * @param _from the address of the sender
299     * @param _value the amount of money to burn
300     */
301     function burnFrom(address _from, uint256 _value)
302     external
303     returns(bool success) {
304          // Check allowance
305         require(_value <= _allowance[_from][msg.sender], "Not enough allowance!");
306         // Is tehere enough coins on account
307         require(_value <= _balanceOf[_from], "Insuffient balance!");
308         // Subtract from the sender's allowance
309         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
310         _burn(_from, _value);
311         emit Approval(_from, msg.sender, _allowance[_from][msg.sender]);
312         return true;
313     }
314 
315     function _burn(address _from, uint256 _value)
316     internal {
317         // Check if the targeted balance is enough
318         require(_balanceOf[_from] >= _value, "Insuffient balance!");
319         // Subtract from the sender
320         _balanceOf[_from] = _balanceOf[_from].sub(_value);
321         // Updates totalSupply
322         totalSupply = totalSupply.sub(_value);
323         emit Burn(msg.sender, _value);
324         emit Transfer(_from, address(0), _value);
325     }
326 
327     // ------------------------------------------------------------------------
328     // Don't accept accidental ETH
329     // ------------------------------------------------------------------------
330     function () external payable {
331         revert("This contract is not accepting ETH.");
332     }
333 
334     //Owner can take ETH from contract
335     function withdraw(uint256 _amount)
336     external onlyOwner
337     returns (bool){
338         require(_amount <= address(this).balance, "Not enough balance!");
339         owner.transfer(_amount);
340         return true;
341     }
342 
343     // ------------------------------------------------------------------------
344     // Owner can transfer out any accidentally sent ERC20 tokens
345     // ------------------------------------------------------------------------
346     function transferAnyERC20Token(address tokenAddress, uint256 _value)
347     external onlyOwner
348     returns(bool success) {
349         return ERC20Interface(tokenAddress).transfer(owner, _value);
350     }
351 }