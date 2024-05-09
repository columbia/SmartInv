1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath from Zeppelin
5  * @dev Math operations with safety checks that throw on error
6  */
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
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b > 0);
26         uint256 c = a / b;
27         assert(a == b * c + a % b);
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         assert(c >= b);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20 Interface
52  */
53 contract ERC20Interface {
54     function totalSupply() public view returns (uint256);
55     function balanceOf(address _owner) public view returns (uint256);
56     function transfer(address _to, uint256 _value) public returns (bool);
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
58     function approve(address _spender, uint256 _value) public returns (bool);
59     function allowance(address _owner, address _spender) public view returns (uint256);
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 }
64 
65 /**
66  * @title Standard ERC20 Token
67  * @dev This contract is based on Zeppelin StandardToken.sol and MonolithDAO Token.sol
68  */
69 contract StandardERC20Token is ERC20Interface {
70 
71     using SafeMath for uint256;
72 
73     // Name of ERC20 token
74     string public name;
75 
76     // Symbol of ERC20 token
77     string public symbol;
78 
79     // Decimals of ERC20 token
80     uint8 public decimals;
81 
82     // Total supply of ERC20 token
83     uint256 internal supply;
84 
85     // Mapping of balances
86     mapping(address => uint256) internal balances;
87 
88     // Mapping of approval
89     mapping (address => mapping (address => uint256)) internal allowed;
90 
91     // Modifier to check the length of msg.data
92     modifier onlyPayloadSize(uint256 size) {
93         if(msg.data.length < size.add(4)) {
94             revert();
95         }
96         _;
97     }
98 
99     /**
100     * @dev Don't accept ETH
101      */
102     function () public payable {
103         revert();
104     }
105 
106     /**
107     * @dev Constructor
108     *
109     * @param _issuer The account who owns all tokens
110     * @param _name The name of the token
111     * @param _symbol The symbol of the token
112     * @param _decimals The decimals of the token
113     * @param _amount The initial amount of the token
114     */
115     constructor(address _issuer, string _name, string _symbol, uint8 _decimals, uint256 _amount) public {
116         require(_issuer != address(0));
117         require(bytes(_name).length > 0);
118         require(bytes(_symbol).length > 0);
119         require(_decimals <= 18);
120         require(_amount > 0);
121 
122         name = _name;
123         symbol = _symbol;
124         decimals = _decimals;
125         supply = _amount.mul(10 ** uint256(decimals));
126         balances[_issuer] = supply;
127     }
128 
129     /**
130     * @dev Get the total amount of tokens
131     *
132     * @return Total amount of tokens
133     */
134     function totalSupply() public view returns (uint256) {
135         return supply;
136     }
137 
138     /**
139     * @dev Get the balance of the specified address
140     *
141     * @param _owner The address from which the balance will be retrieved
142     * @return The balance
143     */
144     function balanceOf(address _owner) public view returns (uint256) {
145         return balances[_owner];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     *
151     * @param _to The address of the recipient
152     * @param _value The amount of token to be transferred
153     * @return Whether the transfer was successful or not
154     */
155     function transfer(address _to, uint256 _value) onlyPayloadSize(64) public returns (bool) {
156         require(_to != address(0));
157         require(_value > 0);
158         require(_value <= balances[msg.sender]);
159 
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162 
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Transfer tokens from one address to another
169     *
170     * @param _from The address of the sender
171     * @param _to The address of the recipient
172     * @param _value The amount of token to be transferred
173     * @return Whether the transfer was successful or not
174     */
175     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(96) public returns (bool) {
176         require(_to != address(0));
177         require(_value > 0);
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180 
181         balances[_from] = balances[_from].sub(_value);
182         balances[_to] = balances[_to].add(_value);
183         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184 
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
191     * To prevent attack described in https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729, 
192     * approve is not allowed when the allowance of specified spender is not zero, call increaseApproval 
193     * or decreaseApproval to change an allowance
194     *
195     * @param _spender The address of the account able to transfer the tokens
196     * @param _value The amount of wei to be approved for transfer
197     * @return Whether the approval was successful or not
198     */
199     function approve(address _spender, uint256 _value) onlyPayloadSize(64) public returns (bool) {
200         require(_value > 0);
201         require(allowed[msg.sender][_spender] == 0);
202 
203         allowed[msg.sender][_spender] = _value;
204 
205         emit Approval(msg.sender, _spender, _value);
206         return true;
207     }
208 
209     /**
210     * @dev Function to check the amount of tokens that an owner allowed to a spender
211     *
212     * @param _owner The address of the account owning tokens
213     * @param _spender The address of the account able to transfer the tokens
214     * @return Amount of remaining tokens allowed to spent
215     */
216     function allowance(address _owner, address _spender) onlyPayloadSize(64) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     /**
221     * @dev Increase the amount of tokens that an owner allowed to a spender
222     *
223     * @param _spender The address which will spend the funds
224     * @param _value The amount of tokens to increase the allowance by
225     * @return Whether the approval was successful or not
226     */
227     function increaseApproval(address _spender, uint _value) onlyPayloadSize(64) public returns (bool) {
228         require(_value > 0);
229 
230         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
231 
232         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233         return true;
234     }
235 
236     /**
237     * @dev Decrease the amount of tokens that an owner allowed to a spender
238     *
239     * @param _spender The address which will spend the funds
240     * @param _value The amount of tokens to decrease the allowance by
241     * @return Whether the approval was successful or not
242     */
243     function decreaseApproval(address _spender, uint _value) onlyPayloadSize(64) public returns (bool) {
244         require(_value > 0);
245 
246         uint256 value = allowed[msg.sender][_spender];
247 
248         if (_value >= value) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = value.sub(_value);
252         }
253 
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 }
258 
259 /**
260  * @title LongHash ERC20 Token
261   */
262 contract LongHashERC20Token is StandardERC20Token {
263 
264     // Issuer of tokens
265     address public issuer;
266 
267     // Events
268     event Issuance(address indexed _from, uint256 _amount, uint256 _value);
269     event Burn(address indexed _from, uint256 _amount, uint256 _value);
270 
271     // Modifier to check the issuer
272     modifier onlyIssuer() {
273         if (msg.sender != issuer) {
274             revert();
275         }
276         _;
277     }
278 
279     /**
280     * @dev Constructor
281     *
282     * @param _issuer The account who owns all tokens
283     * @param _name The name of the token
284     * @param _symbol The symbol of the token
285     * @param _decimals The decimals of the token
286     * @param _amount The initial amount of the token
287     */
288     constructor(address _issuer, string _name, string _symbol, uint8 _decimals, uint256 _amount) 
289         StandardERC20Token(_issuer, _name, _symbol, _decimals, _amount) public {
290         issuer = _issuer;
291     }
292 
293     /**
294     * @dev Issuing tokens
295     *
296     * @param _amount The amount of tokens to be issued
297     * @return Whether the issuance was successful or not
298     */
299     function issue(uint256 _amount) onlyIssuer() public returns (bool) {
300         require(_amount > 0);
301         uint256 value = _amount.mul(10 ** uint256(decimals));
302 
303         supply = supply.add(value);
304         balances[issuer] = balances[issuer].add(value);
305 
306         emit Issuance(msg.sender, _amount, value);
307         return true;
308     }
309 
310     /**
311     * @dev Burn tokens
312     *
313     * @param _amount The amount of tokens to be burned
314     * @return Whether the burn was successful or not
315     */
316     function burn(uint256 _amount) onlyIssuer() public returns (bool) {
317         uint256 value;
318 
319         require(_amount > 0);
320         value = _amount.mul(10 ** uint256(decimals));
321         require(supply >= value);
322         require(balances[issuer] >= value);
323 
324         supply = supply.sub(value);
325         balances[issuer] = balances[issuer].sub(value);
326 
327         emit Burn(msg.sender, _amount, value);
328         return true;
329     }
330 
331     /**
332     * @dev Change the issuer of tokens
333     *
334     * @param _to The new issuer
335     * @param _transfer Whether transfer the old issuer's tokens to new issuer
336     * @return Whether the burn was successful or not
337     */
338     function changeIssuer(address _to, bool _transfer) onlyIssuer() public returns (bool) {
339         require(_to != address(0));
340 
341         if (_transfer) {
342             balances[_to] = balances[issuer];
343             balances[issuer] = 0;
344         }
345         issuer = _to;
346 
347         return true;
348     }
349 }