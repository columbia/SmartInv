1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2017-10-10
7  */
8 
9 pragma solidity ^0.4.16;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17         uint256 c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal constant returns (uint256) {
23         // assert(b > 0); // Solidity automatically throws when dividing by 0
24         uint256 c = a / b;
25         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     function add(uint256 a, uint256 b) internal constant returns (uint256) {
35         uint256 c = a + b;
36         assert(c >= a);
37         return c;
38     }
39 }
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47     uint256 public totalSupply;
48     function balanceOf(address who) public constant returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60                        mapping(address => uint256) balances;
61 
62     /**
63      * @dev transfer token for a specified address
64      * @param _to The address to transfer to.
65      * @param _value The amount to be transferred.
66      */
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         // require(_to != address(0));
69         require(_value <= balances[msg.sender]);
70 
71         // SafeMath.sub will throw if there is not enough balance.
72         balances[msg.sender] = balances[msg.sender].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     /**
79      * @dev Gets the balance of the specified address.
80      * @param _owner The address to query the the balance of.
81      * @return An uint256 representing the amount owned by the passed address.
82      */
83     function balanceOf(address _owner) public constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94     function allowance(address owner, address spender) public constant returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113     /**
114      * @dev Transfer tokens from one address to another
115      * @param _from address The address which you want to send tokens from
116      * @param _to address The address which you want to transfer to
117      * @param _value uint256 the amount of tokens to be transferred
118      */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         // require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      *
134      * Beware that changing an allowance with this method brings the risk that someone may use both the old
135      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138      * @param _spender The address which will spend the funds.
139      * @param _value The amount of tokens to be spent.
140      */
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Function to check the amount of tokens that an owner allowed to a spender.
149      * @param _owner address The address which owns the funds.
150      * @param _spender address The address which will spend the funds.
151      * @return A uint256 specifying the amount of tokens still available for the spender.
152      */
153     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
154         return allowed[_owner][_spender];
155     }
156 }
157 
158 /**
159  * @title Ownable
160  * @dev The Ownable contract has an owner address, and provides basic authorization control
161  * functions, this simplifies the implementation of "user permissions".
162  */
163 contract Ownable {
164     address public owner;
165 
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169 
170     /**
171      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
172      * account.
173      */
174     function Ownable() {
175         owner = msg.sender;
176     }
177 
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(msg.sender == owner);
184         _;
185     }
186 
187 
188     /**
189      * @dev Allows the current owner to transfer control of the contract to a newOwner.
190      * @param newOwner The address to transfer ownership to.
191      */
192     function transferOwnership(address newOwner) onlyOwner public {
193         require(newOwner != address(0));
194         OwnershipTransferred(owner, newOwner);
195         owner = newOwner;
196     }
197 
198 }
199 
200 /**
201  * @title Pausable
202  * @dev Base contract which allows children to implement an emergency stop mechanism.
203  */
204 contract Pausable is Ownable {
205     event Pause();
206     event Unpause();
207 
208     bool public paused = false;
209 
210 
211     /**
212      * @dev Modifier to make a function callable only when the contract is not paused.
213      */
214     modifier whenNotPaused() {
215         require(!paused);
216         _;
217     }
218 
219     /**
220      * @dev Modifier to make a function callable only when the contract is paused.
221      */
222     modifier whenPaused() {
223         require(paused);
224         _;
225     }
226 
227     /**
228      * @dev called by the owner to pause, triggers stopped state
229      */
230     function pause() onlyOwner whenNotPaused public {
231         paused = true;
232         Pause();
233     }
234 
235     /**
236      * @dev called by the owner to unpause, returns to normal state
237      */
238     function unpause() onlyOwner whenPaused public {
239         paused = false;
240         Unpause();
241     }
242 }
243 
244 /**
245  * @title Pausable token
246  *
247  * @dev StandardToken modified with pausable transfers.
248  **/
249 
250 contract PausableToken is StandardToken, Pausable {
251 
252     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
253         return super.transfer(_to, _value);
254     }
255 
256     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
257         return super.transferFrom(_from, _to, _value);
258     }
259 
260     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
261         return super.approve(_spender, _value);
262     }
263 }
264 
265 /**
266  * @title QASH Token
267  *
268  * @dev Implementation of QASH Token based on the basic standard token.
269  */
270 contract LMToken is PausableToken {
271 
272     function () {
273         //if ether is sent to this address, send it back.
274         revert();
275     }
276 
277     /**
278      * Public variables of the token
279      * The following variables are OPTIONAL vanities. One does not have to include them.
280      * They allow one to customise the token contract & in no way influences the core functionality.
281      * Some wallets/interfaces might not even bother to look at this information.
282      */
283     string public name;
284     uint8 public decimals;
285     string public symbol;
286     string public version = '1.0.0';
287 
288     /**
289      * @dev Function to check the amount of tokens that an owner allowed to a spender.
290      * @param _totalSupply total supply of the token.
291      * @param _name token name e.g QASH Token.
292      * @param _symbol token symbol e.g QASH.
293      * @param _decimals amount of decimals.
294      */
295     function LMToken(uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) {
296         balances[msg.sender] = _totalSupply;    // Give the creator all initial tokens
297         totalSupply = _totalSupply;
298         name = _name;
299         symbol = _symbol;
300         decimals = _decimals;
301     }
302 }