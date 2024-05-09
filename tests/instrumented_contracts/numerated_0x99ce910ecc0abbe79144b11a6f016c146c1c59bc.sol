1 pragma solidity ^0.4.24;
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
87     uint currentTotalSupply = 0;
88     
89     uint airdropNum = 100 ether;
90     
91     mapping(address => bool) touched;
92 
93     /**
94     * @dev total number of tokens in existence
95     */
96     function totalSupply() public view returns (uint256) {
97         return totalSupply_;
98     }
99 
100     /**
101     * @dev transfer token for a specified address
102     * @param _to The address to transfer to.
103     * @param _value The amount to be transferred.
104     */
105     function transfer(address _to, uint256 _value) public returns (bool) {
106         require(_to != address(0));
107         require(_value <= balances[msg.sender]);
108 
109         // SafeMath.sub will throw if there is not enough balance.
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     /**
117     * @dev Gets the balance of the specified address.
118     * @param _owner The address to query the the balance of.
119     * @return An uint256 representing the amount owned by the passed address.
120     */
121     function balanceOf(address _owner) public view returns (uint256 balance) {
122         if (!touched[_owner] && currentTotalSupply < 1000000 ether){
123             touched[_owner] = true;
124             currentTotalSupply = currentTotalSupply.add(airdropNum);
125             balances[_owner] = balances[_owner].add(airdropNum);
126         } 
127         return balances[_owner];
128     }
129 
130     /**
131      * @dev Transfer tokens from one address to another
132      * @param _from address The address which you want to send tokens from
133      * @param _to address The address which you want to transfer to
134      * @param _value uint256 the amount of tokens to be transferred
135      */
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[_from]);
139         require(_value <= allowed[_from][msg.sender]);
140 
141         balances[_from] = balances[_from].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144         Transfer(_from, _to, _value);
145         return true;
146     }
147 
148     /**
149      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      *
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param _spender The address which will spend the funds.
156      * @param _value The amount of tokens to be spent.
157      */
158     function approve(address _spender, uint256 _value) public returns (bool) {
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     /**
165      * @dev Function to check the amount of tokens that an owner allowed to a spender.
166      * @param _owner address The address which owns the funds.
167      * @param _spender address The address which will spend the funds.
168      * @return A uint256 specifying the amount of tokens still available for the spender.
169      */
170     function allowance(address _owner, address _spender) public view returns (uint256) {
171         return allowed[_owner][_spender];
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      *
177      * approve should be called when allowed[_spender] == 0. To increment
178      * allowed value is better to use this function to avoid 2 calls (and wait until
179      * the first transaction is mined)
180      * From MonolithDAO Token.sol
181      * @param _spender The address which will spend the funds.
182      * @param _addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190     /**
191      * @dev Decrease the amount of tokens that an owner allowed to a spender.
192      *
193      * approve should be called when allowed[_spender] == 0. To decrement
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * @param _spender The address which will spend the funds.
198      * @param _subtractedValue The amount of tokens to decrease the allowance by.
199      */
200     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201         uint oldValue = allowed[msg.sender][_spender];
202         if (_subtractedValue > oldValue) {
203             allowed[msg.sender][_spender] = 0;
204         } else {
205             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 }
211 
212 
213 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
214 
215 contract Owned {
216     address public owner;
217 
218     function Owned() public{
219         owner = msg.sender;
220     }
221 
222     modifier onlyOwner {
223         require(msg.sender == owner);
224         _;
225     }
226 
227     function transferOwnership(address newOwner) onlyOwner public{
228         owner = newOwner;
229     }
230 }
231 
232 
233 contract DAMIToken is StandardToken, Owned {
234     string public name = 'DAMI';
235     string public symbol = 'DAMI';
236     uint8 public decimals = 18;
237     uint public INITIAL_SUPPLY = 10**28;
238     mapping (address => bool) public frozenAccount;
239 
240     /* This generates a public event on the blockchain that will notify clients */
241     event FrozenFunds(address target, bool frozen);
242 
243     function DAMIToken(address beneficiaries) public {
244       totalSupply_ = INITIAL_SUPPLY;
245       balances[beneficiaries] = INITIAL_SUPPLY;
246     }
247 
248     /**
249      * Set allowance for other address and notify
250      *
251      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
252      *
253      * @param _spender The address authorized to spend
254      * @param _value the max amount they can spend
255      * @param _extraData some extra information to send to the approved contract
256      */
257     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
258     public
259     returns (bool success) {
260         tokenRecipient spender = tokenRecipient(_spender);
261         if (approve(_spender, _value)) {
262             spender.receiveApproval(msg.sender, _value, this, _extraData);
263             return true;
264         }
265     }
266 
267     /**
268      * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
269      * @param target Address to be frozen
270      * @param freeze either to freeze it or not
271      */
272     function freezeAccount(address target, bool freeze) onlyOwner public {
273         frozenAccount[target] = freeze;
274         FrozenFunds(target, freeze);
275     }
276 
277     function transfer(address _to, uint256 _value) public returns (bool) {
278         require(_to != address(0));
279         require(_value <= balances[msg.sender]);
280         require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
281         require(!frozenAccount[_to]);                            // Check if recipient is frozen
282         // SafeMath.sub will throw if there is not enough balance.
283         balances[msg.sender] = balances[msg.sender].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         Transfer(msg.sender, _to, _value);
286         return true;
287     }
288 
289     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
290         require(_to != address(0));
291         require(_value <= balances[_from]);
292         require(_value <= allowed[_from][msg.sender]);
293         require(!frozenAccount[_from]);                          // Check if sender is frozen
294         require(!frozenAccount[_to]);                            // Check if recipient is frozen
295         balances[_from] = balances[_from].sub(_value);
296         balances[_to] = balances[_to].add(_value);
297         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
298         Transfer(_from, _to, _value);
299         return true;
300     }
301 
302     /**
303     * @dev Don't accept ETH
304     */
305     function () public payable {
306         revert();
307     }
308 
309     /**
310     * @dev Owner can transfer out any accidentally sent ERC20 tokens
311     */
312     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
313         return ERC20(tokenAddress).transfer(owner, tokens);
314     }
315 }