1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Interface
5  * @dev Standard version of ERC20 interface
6  */
7 contract ERC20Interface {
8     uint256 public totalSupply;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24     address public owner;
25 
26     /**
27      * @dev The Ownable constructor sets the original `owner` 
28      * of the contract to the sender account.
29      */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the current owner
36      */
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner
44      * @param newOwner The address to transfer ownership to
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         owner = newOwner;
49     }
50 }
51 
52 /**
53  * @title GAMT
54  * @dev Implemantation of the GAMT token
55  */
56 contract GAMT is Ownable, ERC20Interface {
57     using SafeMath for uint256;
58     
59     string public constant symbol = "GAMT";
60     string public constant name = "GAMT";
61     uint8 public constant decimals = 18;
62     uint256 private _unmintedTokens = 300000000 * uint(10) ** decimals;
63 
64     mapping(address => uint256) balances;
65     mapping (address => mapping (address => uint256)) internal allowed;
66     
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     
70     event Burn(address indexed _address, uint256 _value);
71     event Mint(address indexed _address, uint256 _value);
72       
73     /**
74      * @dev Gets the balance of the specified address
75      * @param _owner The address to query the the balance of
76      * @return An uint256 representing the amount owned by the passed address
77      */
78     function balanceOf(address _owner) public view returns (uint256 balance) {
79         return balances[_owner];
80     }
81     
82     /**
83      * @dev Transfer token to a specified address
84      * @param _to The address to transfer to
85      * @param _value The amount to be transferred
86      */  
87     function transfer(address _to, uint256 _value) public returns (bool success) {
88         require(_to != address(0));
89         require(balances[msg.sender] >= _value);
90         assert(balances[_to] + _value >= balances[_to]);
91         
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         emit Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     
99     /**
100      * @dev Transfer tokens from one address to another 
101      * @param _from The address which you want to send tokens from
102      * @param _to The address which you want to transfer to
103      * @param _value The amout of tokens to be transfered
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_to != address(0));
107         require(_value <= balances[_from]);
108         require(_value <= allowed[_from][msg.sender]);
109         assert(balances[_to] + _value >= balances[_to]);
110         
111         balances[_from] = balances[_from].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub( _value);
114         emit Transfer(_from, _to, _value);
115         return true;
116     }
117 
118     /**
119      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender
120      * @param _spender The address which will spend the funds
121      * @param _value The amount of tokens to be spent
122      */
123     function approve(address _spender, uint256 _value) public returns (bool success) {
124         allowed[msg.sender][_spender] = _value;
125         emit Approval(msg.sender, _spender, _value);
126         return true;
127     }
128     
129     /**
130      * @dev Function to check the amount of tokens than an owner allowed to a spender
131      * @param _owner The address which owns the funds
132      * @param _spender The address which will spend the funds
133      * @return A uint specifing the amount of tokens still avaible for the spender
134      */
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138 
139     /**
140      * @dev Mint GAMT tokens. No more than 300,000,000 GAMT can be minted
141      * @param _account The address to which new tokens will be minted
142      * @param _mintedAmount The amout of tokens to be minted
143      */    
144     function mintTokens(address _account, uint256 _mintedAmount) public onlyOwner returns (bool success){
145         require(_mintedAmount <= _unmintedTokens);
146         
147         balances[_account] = balances[_account].add(_mintedAmount);
148         _unmintedTokens = _unmintedTokens.sub(_mintedAmount);
149         totalSupply = totalSupply.add(_mintedAmount);
150         emit Mint(_account, _mintedAmount);
151         return true;
152     }
153     
154     /**
155      * @dev Increase the amount of tokens that an owner allowed to a spender.
156      * approve should be called when allowed_[_spender] == 0. 
157      * @param _spender The address which will spend the funds.
158      * @param _addedValue The amount of tokens to increase the allowance by.
159      */
160     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
161         require(_spender != address(0));
162 
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     /**
169      * @dev Decrease the amount of tokens that an owner allowed to a spender.
170      * approve should be called when allowed_[_spender] == 0.
171      * Emits an Approval event.
172      * @param _spender The address which will spend the funds.
173      * @param _subtractedValue The amount of tokens to decrease the allowance by.
174      */
175     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
176         require(_spender != address(0));
177 
178         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182     
183     /**
184      * @dev Mint GAMT tokens and aproves the passed address to spend the minted amount of tokens
185      * No more than 300,000,000 GAMT can be minted
186      * @param _target The address to which new tokens will be minted
187      * @param _mintedAmount The amout of tokens to be minted
188      * @param _spender The address which will spend minted funds
189      */ 
190     function mintTokensWithApproval(address _target, uint256 _mintedAmount, address _spender) public onlyOwner returns (bool success){
191         require(_mintedAmount <= _unmintedTokens);
192         
193         balances[_target] = balances[_target].add(_mintedAmount);
194         _unmintedTokens = _unmintedTokens.sub(_mintedAmount);
195         totalSupply = totalSupply.add(_mintedAmount);
196         allowed[_target][_spender] = allowed[_target][_spender].add(_mintedAmount);
197         emit Mint(_target, _mintedAmount);
198         return true;
199     }
200     
201     /**
202      * @dev Decrease amount of GAMT tokens that can be minted
203      * @param _burnedAmount The amount of unminted tokens to be burned
204      */ 
205     function burnUnmintedTokens(uint256 _burnedAmount) public onlyOwner returns (bool success){
206         require(_burnedAmount <= _unmintedTokens);
207         _unmintedTokens = _unmintedTokens.sub(_burnedAmount);
208         emit Burn(msg.sender, _burnedAmount);
209         return true;
210     }
211     
212 
213     /**
214      * @dev Function that burns an amount of the token of a given
215      * account.
216      * @param _account The account whose tokens will be burnt.
217      * @param _value The amount that will be burnt.
218      */
219     function burn(address _account, uint256 _value) onlyOwner public {
220         require(_account != address(0));
221 
222         totalSupply = totalSupply.sub(_value);
223         balances[_account] = balances[_account].sub(_value);
224         
225         emit Burn(_account, _value);
226 
227     }
228 
229     /**
230      * @dev Function that burns an amount of the token of a given
231      * account, deducting from the sender's allowance for said account. Uses the
232      * internal burn function.
233      * Emits an Approval event (reflecting the reduced allowance).
234      * @param _account The account whose tokens will be burnt.
235      * @param _value The amount that will be burnt.
236      */
237     function burnFrom(address _account, uint256 _value) onlyOwner public {
238         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_value);
239         burn(_account, _value);
240         
241         emit Burn(_account, _value);
242     }
243     
244 
245     /**
246      * @dev Returns the number of unminted token
247      */
248     function unmintedTokens() onlyOwner view public returns (uint256 tokens){
249         return _unmintedTokens;
250     }
251 
252 }
253 
254 /**
255  * @title SafeMath
256  * @dev Math operations with safety checks that throw on error
257  */
258 library SafeMath {
259 
260   /**
261   * @dev Multiplies two numbers, throws on overflow.
262   */
263   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
264     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
265     // benefit is lost if 'b' is also tested.
266     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
267     if (_a == 0) {
268       return 0;
269     }
270 
271     uint256 c = _a * _b;
272     assert(c / _a == _b);
273 
274     return c;
275   }
276 
277   /**
278   * @dev Integer division of two numbers, truncating the quotient.
279   */
280   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
281     // assert(_b > 0); // Solidity automatically throws when dividing by 0
282     uint256 c = _a / _b;
283     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
284 
285     return c;
286   }
287 
288   /**
289   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
290   */
291   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
292     assert(_b <= _a);
293     uint256 c = _a - _b;
294 
295     return c;
296   }
297 
298   /**
299   * @dev Adds two numbers, throws on overflow.
300   */
301   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
302     uint256 c = _a + _b;
303     assert(c >= _a);
304 
305     return c;
306   }
307 }