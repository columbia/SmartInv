1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal constant returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public constant returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 /**
41  * @title Basic token
42  * @dev Basic version of StandardToken, with no allowances.
43  */
44 contract BasicToken is ERC20Basic {
45     using SafeMath for uint256;
46 
47     mapping(address => uint256) balances;
48 
49     /**
50      * @dev transfer token for a specified address
51      * @param _to The address to transfer to.
52      * @param _value The amount to be transferred.
53      */
54     function transfer(address _to, uint256 _value) public returns (bool) {
55         require(_to != address(0));
56         require(_value <= balances[msg.sender]);
57         balances[msg.sender] = balances[msg.sender].sub(_value);
58         balances[_to] = balances[_to].add(_value);
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     /**
64      * @dev Gets the balance of the specified address.
65      * @param _owner The address to query the the balance of.
66      * @return An uint256 representing the amount owned by the passed address.
67      */
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78     function allowance(address owner, address spender) public constant returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 /**
85  * @title Standard ERC20 token
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is ERC20, BasicToken {
91     mapping (address => mapping (address => uint256)) internal allowed;
92 
93     /**
94      * @dev Transfer tokens from one address to another
95      * @param _from address The address which you want to send tokens from
96      * @param _to address The address which you want to transfer to
97      * @param _value uint256 the amount of tokens to be transferred
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
100         require(_to != address(0));
101         require(_value <= balances[_from]);
102         require(_value <= allowed[_from][msg.sender]);
103         balances[_from] = balances[_from].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
106         Transfer(_from, _to, _value);
107         return true;
108     }
109 
110     /**
111      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
112      * Beware that changing an allowance with this method brings the risk that someone may use both the old
113      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
114      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
115      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116      * @param _spender The address which will spend the funds.
117      * @param _value The amount of tokens to be spent.
118      */
119     function approve(address _spender, uint256 _value) public returns (bool) {
120         allowed[msg.sender][_spender] = _value;
121         Approval(msg.sender, _spender, _value);
122         return true;
123     }
124 
125     /**
126      * @dev Function to check the amount of tokens that an owner allowed to a spender.
127      * @param _owner address The address which owns the funds.
128      * @param _spender address The address which will spend the funds.
129      * @return A uint256 specifying the amount of tokens still available for the spender.
130      */
131     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
132         return allowed[_owner][_spender];
133     }
134 
135     /**
136      * approve should be called when allowed[_spender] == 0. To increment
137      * allowed value is better to use this function to avoid 2 calls (and wait until
138      * the first transaction is mined)
139      * From MonolithDAO Token.sol
140      */
141     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     /**
148      * @dev Decrease the amount of tokens that an owner allowed to a spender.
149      * approve should be called when allowed[_spender] == 0. To decrement
150      * allowed value is better to use this function to avoid 2 calls (and wait until
151      * the first transaction is mined)
152      * From MonolithDAO Token.sol
153      * @param _spender The address which will spend the funds.
154      * @param _subtractedValue The amount of tokens to decrease the allowance by.
155      */
156     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
157         uint oldValue = allowed[msg.sender][_spender];
158         if (_subtractedValue > oldValue) {
159             allowed[msg.sender][_spender] = 0;
160         } else {
161             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162         }
163         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164         return true;
165     }
166 }
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174     address public owner;
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177     /**
178      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
179      * account.
180      */
181     function Ownable() {
182         owner = msg.sender;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         require(msg.sender == owner);
190         _;
191     }
192 
193     /**
194      * @dev Allows the current owner to transfer control of the contract to a newOwner.
195      * @param newOwner The address to transfer ownership to.
196      */
197     function transferOwnership(address newOwner) onlyOwner public {
198         require(newOwner != address(0));
199         OwnershipTransferred(owner, newOwner);
200         owner = newOwner;
201     }
202 }
203 
204 /**
205  * @title Pausable
206  * @dev Base contract which allows children to implement an emergency stop mechanism.
207  */
208 contract Pausable is Ownable {
209     event Pause();
210     event Unpause();
211     bool public paused = false;
212 
213     /**
214      * @dev Modifier to make a function callable only when the contract is not paused.
215      */
216     modifier whenNotPaused() {
217         require(!paused);
218         _;
219     }
220 
221     /**
222      * @dev Modifier to make a function callable only when the contract is paused.
223      */
224     modifier whenPaused() {
225         require(paused);
226         _;
227     }
228 
229     /**
230      * @dev called by the owner to pause, triggers stopped state
231      */
232     function pause() onlyOwner whenNotPaused public {
233         paused = true;
234         Pause();
235     }
236 
237     /**
238      * @dev called by the owner to unpause, returns to normal state
239      */
240     function unpause() onlyOwner whenPaused public {
241         paused = false;
242         Unpause();
243     }
244 }
245 
246 /**
247  * @title UnionChain
248  * @dev ERC20 UnionChain (UNC)
249  */
250 contract UnionChain is StandardToken, Pausable {
251     string public constant name = 'Union Chain';
252     string public constant symbol = 'UNC';
253     uint8 public constant decimals = 6;
254     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**uint256(decimals);
255 
256     /**
257      * @dev SesnseToken Constructor
258      * Runs only on initial contract creation.
259      */
260     function UnionChain() {
261         totalSupply = INITIAL_SUPPLY;
262         balances[msg.sender] = INITIAL_SUPPLY;
263         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
264     }
265 
266     /**
267      * @dev Transfer token for a specified address when not paused
268      * @param _to The address to transfer to.
269      * @param _value The amount to be transferred.
270      */
271     function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
272         require(_to != address(0));
273         return super.transfer(_to, _value);
274     }
275 
276     /**
277      * @dev Transfer tokens from one address to another when not paused
278      * @param _from address The address which you want to send tokens from
279      * @param _to address The address which you want to transfer to
280      * @param _value uint256 the amount of tokens to be transferred
281      */
282     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
283         require(_to != address(0));
284         return super.transferFrom(_from, _to, _value);
285     }
286 
287     /**
288      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
289      * @param _spender The address which will spend the funds.
290      * @param _value The amount of tokens to be spent.
291      */
292     function approve(address _spender, uint256 _value) whenNotPaused returns (bool) {
293         return super.approve(_spender, _value);
294     }
295 
296 }