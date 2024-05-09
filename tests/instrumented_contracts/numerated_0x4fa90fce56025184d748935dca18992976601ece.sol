1 pragma solidity ^0.4.18;
2 
3 /**
4   * @title SafeMath
5   * @dev Math operations with safety checks that throw on error
6   */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0);
19         // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b);
22         // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 /**
39   * @title ERC20Basic
40   * @dev Simpler version of ERC20 interface
41   * @dev see https://github.com/ethereum/EIPs/issues/179
42   */
43 contract ERC20Basic {
44     uint256 public totalSupply;
45     function balanceOf(address who) public view returns (uint256);
46     function transfer(address to, uint256 value) public returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 /**
51   * @title ERC20 interface
52   * @dev see https://github.com/ethereum/EIPs/issues/20
53   */
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62   * @title Basic token
63   * @dev Basic version of StandardToken, with no allowances.
64   */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     /**
71       * @dev transfer token for a specified address
72       * @param _to The address to transfer to.
73       * @param _value The amount to be transferred.
74       */ 
75     function transfer(address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[msg.sender]);
78 
79         // SafeMath.sub will throw if there is not enough balance.
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87       * @dev Gets the balance of the specified address.
88       * @param _owner The address to query the the balance of.
89       * @return An uint256 representing the amount owned by the passed address.
90       */
91     function balanceOf(address _owner) public view returns (uint256 balance) {
92         return balances[_owner];
93     }
94 }
95 
96 /**
97   * @title Standard ERC20 token
98   *
99   * @dev Implementation of the basic standard token.
100   * @dev https://github.com/ethereum/EIPs/issues/20
101   * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102   */
103 
104 contract StandardToken is ERC20, BasicToken {
105     mapping (address => mapping (address => uint256)) internal allowed;
106 
107     /**
108       * @dev Transfer tokens from one address to another
109       * @param _from address The address which you want to send tokens from
110       * @param _to address The address which you want to transfer to
111       * @param _value uint256 the amount of tokens to be transferred
112       */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126       * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127       *
128       * Beware that changing an allowance with this method brings the risk that someone may use both the old
129       * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130       * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131       * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132       * @param _spender The address which will spend the funds.
133       * @param _value The amount of tokens to be spent.
134       */
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     /**
142       * @dev Function to check the amount of tokens that an owner allowed to a spender.
143       * @param _owner address The address which owns the funds.
144       * @param _spender address The address which will spend the funds.
145       * @return A uint256 specifying the amount of tokens still available for the spender.
146       */
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151     /**
152       * approve should be called when allowed[_spender] == 0. To increment
153       * allowed value is better to use this function to avoid 2 calls (and wait until
154       * the first transaction is mined)
155       * From MonolithDAO Token.sol
156       */
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164         uint oldValue = allowed[msg.sender][_spender];
165         if (_subtractedValue > oldValue) {
166             allowed[msg.sender][_spender] = 0;
167         } else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 }
174 
175 /**
176   * @title Ownable
177   * @dev The Ownable contract has an owner address, and provides basic authorization control
178   * functions, this simplifies the implementation of "user permissions".
179   */
180 contract Ownable {
181     address public owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /**
186       * @dev The Ownable constructor sets the original owner of the contract to the sender
187       * account.
188       */
189     function Ownable() internal {
190         owner = msg.sender;
191     }
192 
193     /**
194       * @dev Throws if called by any account other than the owner.
195       */
196     modifier onlyOwner() {
197         require(msg.sender == owner);
198         _;
199     }
200 
201     /**
202       * @dev Allows the current owner to transfer control of the contract to a newOwner.
203       * @param newOwner The address to transfer ownership to.
204       */
205     function transferOwnership(address newOwner) onlyOwner public {
206         require(newOwner != address(0));
207         OwnershipTransferred(owner, newOwner);
208         owner = newOwner;
209     }
210 }
211 
212 /**
213   * @title Pausable
214   * @dev Base contract which allows children to implement an emergency stop mechanism.
215   */
216 contract Pausable is Ownable {
217     event Pause();
218     event Unpause();
219 
220     bool public paused = false;
221 
222     /**
223       * @dev Modifier to make a function callable only when the contract is not paused.
224       */
225     modifier whenNotPaused() {
226         require(!paused);
227         _;
228     }
229 
230     /**
231       * @dev Modifier to make a function callable only when the contract is paused.
232       */
233     modifier whenPaused() {
234         require(paused);
235         _;
236     }
237 
238     /**
239       * @dev called by the owner to pause, triggers stopped state
240       */
241     function pause() onlyOwner whenNotPaused public {
242         paused = true;
243         Pause();
244     }
245 
246     /**
247       * @dev called by the owner to unpause, returns to normal state
248       */
249     function unpause() onlyOwner whenPaused public {
250         paused = false;
251         Unpause();
252     }
253 }
254 
255 /**
256   * @title Pausable token
257   *
258   * @dev StandardToken modified with pausable transfers.
259   *
260   */
261 
262 contract PausableToken is StandardToken, Pausable {
263 
264     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
265         return super.transfer(_to, _value);
266     }
267 
268     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
269         return super.transferFrom(_from, _to, _value);
270     }
271 
272     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
273         return super.approve(_spender, _value);
274     }
275 }
276 
277 /**
278   * @title Rocktoken
279   *
280   * @dev Implementation of Rocktoken based on the basic standard token.
281   */
282 contract Rocktoken is PausableToken {
283 
284     function () public {
285         //if ether is sent to this address, send it back.
286         revert();
287     }
288 
289     /**
290     * Public variables of the token
291     * The following variables are OPTIONAL vanities. One does not have to include them.
292     * They allow one to customise the token contract & in no way influences the core functionality.
293     * Some wallets/interfaces might not even bother to look at this information.
294     */
295     string public name;
296     uint8 public decimals;
297     string public symbol;
298     string public version = '1.0.0';
299 
300     /**
301      * @dev Function to check the amount of tokens that an owner allowed to a spender.
302      * @param _totalSupply total supply of the token.
303      * @param _name token name e.g Rocktoken.
304      * @param _symbol token symbol e.g Rock.
305      * @param _decimals amount of decimals.
306      */
307     function Rocktoken(uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) public {
308         totalSupply = _totalSupply * 10 ** uint256(_decimals);
309         balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
310         name = _name;
311         symbol = _symbol;
312         decimals = _decimals;
313     }
314 }