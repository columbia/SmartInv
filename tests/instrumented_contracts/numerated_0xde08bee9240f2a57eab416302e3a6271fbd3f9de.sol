1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 {
53     function totalSupply() public view returns (uint256);
54 
55     function balanceOf(address who) public view returns (uint256);
56 
57     function transfer(address to, uint256 value) public returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 
61     function allowance(address owner, address spender) public view returns (uint256);
62 
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64 
65     function approve(address spender, uint256 value) public returns (bool);
66 
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Standard ERC20 token
72  *
73  * @dev Implementation of the basic standard token.
74  * @dev https://github.com/ethereum/EIPs/issues/20
75  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  */
77 contract StandardToken is ERC20 {
78 
79     using SafeMath for uint256;
80 
81     mapping(address => uint256) balances;
82 
83     uint256 totalSupply_;
84 
85     mapping(address => mapping(address => uint256)) internal allowed;
86 
87     /**
88     * @dev total number of tokens in existence
89     */
90     function totalSupply() public view returns (uint256) {
91         return totalSupply_;
92     }
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[msg.sender]);
102 
103         // SafeMath.sub will throw if there is not enough balance.
104         balances[msg.sender] = balances[msg.sender].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         Transfer(msg.sender, _to, _value);
107         return true;
108     }
109 
110     /**
111     * @dev Gets the balance of the specified address.
112     * @param _owner The address to query the the balance of.
113     * @return An uint256 representing the amount owned by the passed address.
114     */
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     /**
120      * @dev Transfer tokens from one address to another
121      * @param _from address The address which you want to send tokens from
122      * @param _to address The address which you want to transfer to
123      * @param _value uint256 the amount of tokens to be transferred
124      */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139      *
140      * Beware that changing an allowance with this method brings the risk that someone may use both the old
141      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      * @param _spender The address which will spend the funds.
145      * @param _value The amount of tokens to be spent.
146      */
147     function approve(address _spender, uint256 _value) public returns (bool) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Function to check the amount of tokens that an owner allowed to a spender.
155      * @param _owner address The address which owns the funds.
156      * @param _spender address The address which will spend the funds.
157      * @return A uint256 specifying the amount of tokens still available for the spender.
158      */
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      *
166      * approve should be called when allowed[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      * @param _spender The address which will spend the funds.
171      * @param _addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     /**
180      * @dev Decrease the amount of tokens that an owner allowed to a spender.
181      *
182      * approve should be called when allowed[_spender] == 0. To decrement
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * @param _spender The address which will spend the funds.
187      * @param _subtractedValue The amount of tokens to decrease the allowance by.
188      */
189     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 }
200 
201 
202 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
203 
204 contract Owned {
205     address public owner;
206 
207     function Owned() public{
208         owner = msg.sender;
209     }
210 
211     modifier onlyOwner {
212         require(msg.sender == owner);
213         _;
214     }
215 
216     function transferOwnership(address newOwner) onlyOwner public{
217         owner = newOwner;
218     }
219 }
220 
221 
222 contract DrAgentToken is StandardToken, Owned {
223     string public name = 'Dr.Agent';
224     string public symbol = 'DRA';
225     uint8 public decimals = 18;
226     uint public INITIAL_SUPPLY = 10**28;
227     mapping (address => bool) public frozenAccount;
228 
229     /* This generates a public event on the blockchain that will notify clients */
230     event FrozenFunds(address target, bool frozen);
231 
232     function DrAgentToken() public {
233       totalSupply_ = INITIAL_SUPPLY;
234       balances[msg.sender] = INITIAL_SUPPLY;
235     }
236 
237     /**
238      * Set allowance for other address and notify
239      *
240      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
241      *
242      * @param _spender The address authorized to spend
243      * @param _value the max amount they can spend
244      * @param _extraData some extra information to send to the approved contract
245      */
246     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
247     public
248     returns (bool success) {
249         tokenRecipient spender = tokenRecipient(_spender);
250         if (approve(_spender, _value)) {
251             spender.receiveApproval(msg.sender, _value, this, _extraData);
252             return true;
253         }
254     }
255 
256     /**
257      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
258      * @param target Address to be frozen
259      * @param freeze either to freeze it or not
260      */
261     function freezeAccount(address target, bool freeze) onlyOwner public {
262         frozenAccount[target] = freeze;
263         FrozenFunds(target, freeze);
264     }
265 
266     function transfer(address _to, uint256 _value) public returns (bool) {
267         require(_to != address(0));
268         require(_value <= balances[msg.sender]);
269         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
270         require(!frozenAccount[_to]);                            // Check if recipient is frozen
271         // SafeMath.sub will throw if there is not enough balance.
272         balances[msg.sender] = balances[msg.sender].sub(_value);
273         balances[_to] = balances[_to].add(_value);
274         Transfer(msg.sender, _to, _value);
275         return true;
276     }
277 
278     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
279         require(_to != address(0));
280         require(_value <= balances[_from]);
281         require(_value <= allowed[_from][msg.sender]);
282         require(!frozenAccount[_from]);                          // Check if sender is frozen
283         require(!frozenAccount[_to]);                            // Check if recipient is frozen
284         balances[_from] = balances[_from].sub(_value);
285         balances[_to] = balances[_to].add(_value);
286         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
287         Transfer(_from, _to, _value);
288         return true;
289     }
290 
291     /**
292     * @dev Don't accept ETH
293     */
294     function () public payable {
295         revert();
296     }
297 
298     /**
299     * @dev Owner can transfer out any accidentally sent ERC20 tokens
300     */
301     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
302         return ERC20(tokenAddress).transfer(owner, tokens);
303     }
304 }