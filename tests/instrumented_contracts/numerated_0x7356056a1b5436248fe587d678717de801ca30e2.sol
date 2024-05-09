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
52 
53 /**
54  * @title SNGT
55  * @dev Implemantation of the SNGT token
56  */
57 contract SNGT is Ownable, ERC20Interface {
58     using SafeMath for uint256;
59 
60     string public constant symbol = "SNGT";
61     string public constant name = "SNGT";
62     uint8 public constant decimals = 18;
63     uint256 private _unmintedTokens = 500000000 * uint(10) ** decimals;
64     uint256 private constant decimalFactor = 10**uint256(18);
65 
66     mapping(address => uint256) balances;
67     mapping (address => mapping (address => uint256)) internal allowed;
68     mapping(address => bool) sgdest;
69 
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     event Burn(address indexed _address, uint256 _value);
74     event Mint(address indexed _address, uint256 _value);
75 
76     /**
77      * @dev Gets the balance of the specified address
78      * @param _owner The address to query the the balance of
79      * @return An uint256 representing the amount owned by the passed address
80      */
81     function balanceOf(address _owner) public view returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     /**
86      * @dev Transfer token to a specified address
87      * @param _to The address to transfer to
88      * @param _value The amount to be transferred
89      */
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91         require(_to != address(0));
92         require(balances[msg.sender] >= _value);
93         assert(balances[_to] + _value >= balances[_to]);
94 
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         emit Transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101 
102     /**
103      * @dev Transfer tokens from one address to another
104      * @param _from The address which you want to send tokens from
105      * @param _to The address which you want to transfer to
106      * @param _value The amout of tokens to be transfered
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
109         require(_to != address(0));
110         require(_value <= balances[_from]);
111         require(_value <= allowed[_from][msg.sender]);
112         assert(balances[_to] + _value >= balances[_to]);
113 
114         balances[_from] = balances[_from].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub( _value);
117         emit Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender
123      * @param _spender The address which will spend the funds
124      * @param _value The amount of tokens to be spent
125      */
126     function approve(address _spender, uint256 _value) public returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * @dev Function to check the amount of tokens than an owner allowed to a spender
134      * @param _owner The address which owns the funds
135      * @param _spender The address which will spend the funds
136      * @return A uint specifing the amount of tokens still avaible for the spender
137      */
138     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
139         return allowed[_owner][_spender];
140     }
141 
142     /**
143      * @dev Mint SNGT tokens. No more than 500,000,000 SNGT can be minted
144      * @param _account The address to which new tokens will be minted
145      * @param _mintedAmount The amout of tokens to be minted
146      */
147     function mintTokens(address _account, uint256 _mintedAmount) public onlyOwner returns (bool success){
148         require(_mintedAmount <= _unmintedTokens);
149 
150         balances[_account] = balances[_account].add(_mintedAmount);
151         _unmintedTokens = _unmintedTokens.sub(_mintedAmount);
152         totalSupply = totalSupply.add(_mintedAmount);
153         emit Mint(_account, _mintedAmount);
154         return true;
155     }
156 
157     /**
158      * @dev Increase the amount of tokens that an owner allowed to a spender.
159      * approve should be called when allowed_[_spender] == 0.
160      * @param _spender The address which will spend the funds.
161      * @param _addedValue The amount of tokens to increase the allowance by.
162      */
163     function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
164         require(_spender != address(0));
165 
166         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171     /**
172      * @dev Decrease the amount of tokens that an owner allowed to a spender.
173      * approve should be called when allowed_[_spender] == 0.
174      * Emits an Approval event.
175      * @param _spender The address which will spend the funds.
176      * @param _subtractedValue The amount of tokens to decrease the allowance by.
177      */
178     function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
179         require(_spender != address(0));
180 
181         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subtractedValue);
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 
186     /**
187      * @dev Mint SNGT tokens and aproves the passed address to spend the minted amount of tokens
188      * No more than 500,000,000 SNGT can be minted
189      * @param _target The address to which new tokens will be minted
190      * @param _mintedAmount The amout of tokens to be minted
191      * @param _spender The address which will spend minted funds
192      */
193     function mintTokensWithApproval(address _target, uint256 _mintedAmount, address _spender) public onlyOwner returns (bool success){
194         require(_mintedAmount <= _unmintedTokens);
195 
196         balances[_target] = balances[_target].add(_mintedAmount);
197         _unmintedTokens = _unmintedTokens.sub(_mintedAmount);
198         totalSupply = totalSupply.add(_mintedAmount);
199         allowed[_target][_spender] = allowed[_target][_spender].add(_mintedAmount);
200         emit Mint(_target, _mintedAmount);
201         return true;
202     }
203 
204     /**
205      * @dev Decrease amount of SNGT tokens that can be minted
206      * @param _burnedAmount The amount of unminted tokens to be burned
207      */
208     function burnUnmintedTokens(uint256 _burnedAmount) public onlyOwner returns (bool success){
209         require(_burnedAmount <= _unmintedTokens);
210         _unmintedTokens = _unmintedTokens.sub(_burnedAmount);
211         emit Burn(msg.sender, _burnedAmount);
212         return true;
213     }
214 
215 
216     /**
217      * @dev Function that burns an amount of the token of a given
218      * account.
219      * @param _account The account whose tokens will be burnt.
220      * @param _value The amount that will be burnt.
221      */
222     function burn(address _account, uint256 _value) onlyOwner public {
223         require(_account != address(0));
224 
225         totalSupply = totalSupply.sub(_value);
226         balances[_account] = balances[_account].sub(_value);
227 
228         emit Burn(_account, _value);
229 
230     }
231 
232     /**
233      * @dev Function that burns an amount of the token of a given
234      * account, deducting from the sender's allowance for said account. Uses the
235      * internal burn function.
236      * Emits an Approval event (reflecting the reduced allowance).
237      * @param _account The account whose tokens will be burnt.
238      * @param _value The amount that will be burnt.
239      */
240     function burnFrom(address _account, uint256 _value) onlyOwner public {
241         allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_value);
242         burn(_account, _value);
243 
244         emit Burn(_account, _value);
245     }
246 
247 
248     /**
249      * @dev Returns the number of unminted token
250      */
251     function unmintedTokens() onlyOwner view public returns (uint256 tokens){
252         return _unmintedTokens;
253     }
254     function multipleTokensDistribution(address[] _recipient) public onlyOwner {
255         // require(now >= startTime);
256         // uint airdropped;
257         for(uint i = 0; i< _recipient.length; i++)
258         {
259             // if (!sgdest[_recipient[i]]) {
260                 // sgdest[_recipient[i]] = true;
261                  transfer(_recipient[i],250 * decimalFactor);
262             //   require(POLY.transfer(_recipient[i], 250 * decimalFactor));
263             //   airdropped = airdropped.add(250 * decimalFactor);
264             // }
265         }
266         // AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(airdropped);
267         // AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(airdropped);
268         // grandTotalClaimed = grandTotalClaimed.add(airdropped);
269       }
270 }
271 
272 /**
273  * @title SafeMath
274  * @dev Math operations with safety checks that throw on error
275  */
276 library SafeMath {
277 
278   /**
279   * @dev Multiplies two numbers, throws on overflow.
280   */
281   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
282     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
283     // benefit is lost if 'b' is also tested.
284     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
285     if (_a == 0) {
286       return 0;
287     }
288 
289     uint256 c = _a * _b;
290     assert(c / _a == _b);
291 
292     return c;
293   }
294 
295   /**
296   * @dev Integer division of two numbers, truncating the quotient.
297   */
298   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
299     // assert(_b > 0); // Solidity automatically throws when dividing by 0
300     uint256 c = _a / _b;
301     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
302 
303     return c;
304   }
305 
306   /**
307   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
308   */
309   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
310     assert(_b <= _a);
311     uint256 c = _a - _b;
312 
313     return c;
314   }
315 
316   /**
317   * @dev Adds two numbers, throws on overflow.
318   */
319   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
320     uint256 c = _a + _b;
321     assert(c >= _a);
322 
323     return c;
324   }
325 }