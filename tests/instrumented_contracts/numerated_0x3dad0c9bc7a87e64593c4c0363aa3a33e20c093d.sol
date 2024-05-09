1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0 || b == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
63      */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner, "Invalid owner");
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      * @param newOwner The address to transfer ownership to.
79      */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0), "Zero address");
82         emit OwnershipTransferred(owner, newOwner);  
83         owner = newOwner;
84     }
85 }
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 {
93     function totalSupply() public view returns (uint256);
94 
95     function balanceOf(address _owner) public view returns (uint256);
96 
97     function transfer(address to, uint256 value) public returns (bool);
98 
99     function allowance(address owner, address spender) public view returns (uint256);
100 
101     function transferFrom(address from, address to, uint256 value) public returns (bool);
102 
103     function approve(address spender, uint256 value) public returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  */
114 contract EyeToken is ERC20, Ownable {
115     using SafeMath for uint256;
116 
117     struct Frozen {
118         bool frozen;
119         uint until;
120     }
121 
122     string public name = "EyeCoin";
123     string public symbol = "EYE";
124     uint8 public decimals = 18;
125 
126     mapping(address => uint256) internal balances;
127     mapping(address => mapping(address => uint256)) internal allowed;
128     mapping(address => Frozen) public frozenAccounts;
129     uint256 internal totalSupplyTokens;
130     bool internal isICO;
131     address public wallet;
132 
133     function EyeToken() public Ownable() {
134         wallet = msg.sender;
135         isICO = true;
136         totalSupplyTokens = 10000000000 * 10 ** uint256(decimals);
137         balances[wallet] = totalSupplyTokens;
138     }
139 
140     /**
141      * @dev Finalize ICO
142      */
143     function finalizeICO() public onlyOwner {
144         isICO = false;
145     }
146 
147     /**
148     * @dev Total number of tokens in existence
149     */
150     function totalSupply() public view returns (uint256) {
151         return totalSupplyTokens;
152     }
153 
154     /**
155      * @dev Freeze account, make transfers from this account unavailable
156      * @param _account Given account
157      */
158     function freeze(address _account) public onlyOwner {
159         freeze(_account, 0);
160     }
161 
162     /**
163      * @dev  Temporary freeze account, make transfers from this account unavailable for a time
164      * @param _account Given account
165      * @param _until Time until
166      */
167     function freeze(address _account, uint _until) public onlyOwner {
168         if (_until == 0 || (_until != 0 && _until > now)) {
169             frozenAccounts[_account] = Frozen(true, _until);
170         }
171     }
172 
173     /**
174      * @dev Unfreeze account, make transfers from this account available
175      * @param _account Given account
176      */
177     function unfreeze(address _account) public onlyOwner {
178         if (frozenAccounts[_account].frozen) {
179             delete frozenAccounts[_account];
180         }
181     }
182 
183     /**
184      * @dev allow transfer tokens or not
185      * @param _from The address to transfer from.
186      */
187     modifier allowTransfer(address _from) {
188         assert(!isICO);
189         if (frozenAccounts[_from].frozen) {
190             require(frozenAccounts[_from].until != 0 && frozenAccounts[_from].until < now, "Frozen account");
191             delete frozenAccounts[_from];
192         }
193         _;
194     }
195 
196     /**
197     * @dev transfer tokens for a specified address
198     * @param _to The address to transfer to.
199     * @param _value The amount to be transferred.
200     */
201     function transfer(address _to, uint256 _value) public returns (bool) {
202         bool result = _transfer(msg.sender, _to, _value);
203         emit Transfer(msg.sender, _to, _value); 
204         return result;
205     }
206 
207     /**
208     * @dev transfer tokens for a specified address in ICO mode
209     * @param _to The address to transfer to.
210     * @param _value The amount to be transferred.
211     */
212     function transferICO(address _to, uint256 _value) public onlyOwner returns (bool) {
213         assert(isICO);
214         require(_to != address(0), "Zero address 'To'");
215         require(_value <= balances[wallet], "Not enought balance");
216         balances[wallet] = balances[wallet].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         emit Transfer(wallet, _to, _value);  
219         return true;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param _owner The address to query the the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address _owner) public view returns (uint256) {
228         return balances[_owner];
229     }
230 
231     /**
232      * @dev Transfer tokens from one address to another
233      * @param _from address The address which you want to send tokens from
234      * @param _to address The address which you want to transfer to
235      * @param _value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(address _from, address _to, uint256 _value) public allowTransfer(_from) returns (bool) {
238         require(_value <= allowed[_from][msg.sender], "Not enought allowance");
239         bool result = _transfer(_from, _to, _value);
240         if (result) {
241             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242             emit Transfer(_from, _to, _value);  
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249      *
250      * Beware that changing an allowance with this method brings the risk that someone may use both the old
251      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      * @param _spender The address which will spend the funds.
255      * @param _value The amount of tokens to be spent.
256      */
257     function approve(address _spender, uint256 _value) public returns (bool) {
258         allowed[msg.sender][_spender] = _value;
259         emit Approval(msg.sender, _spender, _value);  
260         return true;
261     }
262 
263     /**
264      * @dev Function to check the amount of tokens that an owner allowed to a spender.
265      * @param _owner address The address which owns the funds.
266      * @param _spender address The address which will spend the funds.
267      * @return A uint256 specifying the amount of tokens still available for the spender.
268      */
269     function allowance(address _owner, address _spender) public view returns (uint256) {
270         return allowed[_owner][_spender];
271     }
272 
273     /**
274      * @dev Increase the amount of tokens that an owner allowed to a spender.
275      *
276      * approve should be called when allowed[_spender] == 0. To increment
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * @param _spender The address which will spend the funds.
281      * @param _addedValue The amount of tokens to increase the allowance by.
282      */
283     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
284         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);  
286         return true;
287     }
288 
289     /**
290      * @dev Decrease the amount of tokens that an owner allowed to a spender.
291      *
292      * approve should be called when allowed[_spender] == 0. To decrement
293      * allowed value is better to use this function to avoid 2 calls (and wait until
294      * the first transaction is mined)
295      * From MonolithDAO Token.sol
296      * @param _spender The address which will spend the funds.
297      * @param _subtractedValue The amount of tokens to decrease the allowance by.
298      */
299     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
300         uint oldValue = allowed[msg.sender][_spender];
301         if (_subtractedValue > oldValue) {
302             allowed[msg.sender][_spender] = 0;
303         } else {
304             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305         }
306         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);  
307         return true;
308     }
309 
310     /**
311      * @dev transfer token for a specified address
312      * @param _from The address to transfer from.
313      * @param _to The address to transfer to.
314      * @param _value The amount to be transferred.
315      */
316     function _transfer(address _from, address _to, uint256 _value) internal allowTransfer(_from) returns (bool) {
317         require(_to != address(0), "Zero address 'To'");
318         require(_from != address(0), "Zero address 'From'");
319         require(_value <= balances[_from], "Not enought balance");
320         balances[_from] = balances[_from].sub(_value);
321         balances[_to] = balances[_to].add(_value);
322         return true;
323     }
324 }