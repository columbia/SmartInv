1 pragma solidity >=0.4.22 <0.7.0;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 contract Ownable {
20     address public owner;
21 
22     event OwnerLog(address indexed previousOwner, address indexed newOwner, bytes4 sig);
23 
24     constructor() public { 
25         owner = msg.sender; 
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner  public {
34         require(newOwner != address(0));
35         emit OwnerLog(owner, newOwner, msg.sig);
36         owner = newOwner;
37     }
38 }
39 
40 contract ERCPaused is Ownable, Context {
41 
42     bool public pauesed = false;
43 
44     modifier isNotPaued {
45         require (!pauesed);
46         _;
47     }
48     function stop() onlyOwner public {
49         pauesed = true;
50     }
51     function start() onlyOwner public {
52         pauesed = false;
53     }
54 }
55 
56 
57 
58 
59 
60 library SafeMath {
61     
62     /**
63      * @dev Multiplies two numbers, throws on overflow.
64     */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69         if (a == 0) {
70           return 0;
71         }
72 
73         c = a * b;
74         assert(c / a == b);
75         return c;
76     }
77 
78     /**
79      * @dev Integer division of two numbers, truncating the quotient.
80     */
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         // assert(b > 0); // Solidity automatically throws when dividing by 0
83         // uint256 c = a / b;
84         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85         return a / b;
86     }
87 
88     /**
89      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90     */
91     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92         assert(b <= a);
93         return a - b;
94     }
95 
96     /**
97      * @dev Adds two numbers, throws on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100         c = a + b;
101         assert(c >= a);
102         return c;
103     }
104 }
105 
106 contract ERC20Basic {
107     function totalSupply() public view returns (uint256);
108     function balanceOf(address who) public view returns (uint256);
109     function transfer(address to, uint256 value) public returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract ERC20 is ERC20Basic {
114     function allowance(address owner, address spender) public view returns (uint256);
115     function approve(address spender, uint256 value) public returns (bool);
116     function transferFrom(address from, address to, uint256 value) public returns (bool);
117 
118     event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126     using SafeMath for uint256;
127 
128     mapping(address => uint256) internal balances;
129     uint256 internal totalSupply_;
130 
131     /**
132      * @dev Total number of tokens in existence
133     */
134     function totalSupply() public view returns (uint256) {
135         return totalSupply_;
136     }
137 
138     /**
139      * @dev transfer token for a specified address
140      * @param _to The address to transfer to.
141      * @param _value The amount to be transferred.
142     */
143     function _transfer(address _sender, address _to, uint256 _value) internal returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         // SafeMath.sub will throw if there is not enough balance.
148         balances[_sender] = balances[_sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(_sender, _to, _value);
151     
152         return true;
153     }
154 
155     /**
156      * @dev Gets the balance of the specified address.
157      * @param _owner The address to query the the balance of.
158      * @return An uint256 representing the amount owned by the passed address.
159     */
160     function balanceOf(address _owner) public view returns (uint256) {
161         return balances[_owner];
162     }
163 
164 }
165 
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177     mapping (address => mapping (address => uint256)) internal allowed;
178     mapping(address => uint256) blackList;
179 	
180 	function transfer(address _to, uint256 _value) public returns (bool) {
181 		require(blackList[msg.sender] <= 0);
182 		return _transfer(msg.sender, _to, _value);
183 	}
184  
185 
186     /**
187      * @dev Transfer tokens from one address to another
188      * @param _from address The address which you want to send tokens from
189      * @param _to address The address which you want to transfer to
190      * @param _value uint256 the amount of tokens to be transferred
191     */
192     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
193         require(_to != address(0));
194         require(_value <= balances[_from]);
195         require(_value <= allowed[_from][msg.sender]);
196 
197         balances[_from] = balances[_from].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200         emit Transfer(_from, _to, _value);
201 
202         return true;
203     }
204 
205     /**
206      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207      *
208      * Beware that changing an allowance with this method brings the risk that someone may use both the old
209      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      * @param _spender The address which will spend the funds.
213      * @param _value The amount of tokens to be spent.
214     */
215     function approve(address _spender, uint256 _value) public returns (bool) {
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220 
221     /**
222      * @dev Function to check the amount of tokens that an owner allowed to a spender.
223      * @param _owner address The address which owns the funds.
224      * @param _spender address The address which will spend the funds.
225      * @return A uint256 specifying the amount of tokens still available for the spender.
226     */
227     function allowance(address _owner, address _spender) public view returns (uint256) {
228         return allowed[_owner][_spender];
229     }
230 
231     /**
232      * approve should be called when allowed[_spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236     */
237     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
238         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
239         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 contract PausableToken is StandardToken, ERCPaused {
257 
258     function transfer(address _to, uint256 _value) public isNotPaued returns (bool) {
259         return super.transfer(_to, _value);
260     }
261 
262     function transferFrom(address _from, address _to, uint256 _value) public isNotPaued returns (bool) {
263         return super.transferFrom(_from, _to, _value);
264     }
265 
266     function approve(address _spender, uint256 _value) public isNotPaued returns (bool) {
267         return super.approve(_spender, _value);
268     }
269 
270     function increaseApproval(address _spender, uint _addedValue) public isNotPaued returns (bool success) {
271         return super.increaseApproval(_spender, _addedValue);
272     }
273 
274     function decreaseApproval(address _spender, uint _subtractedValue) public isNotPaued returns (bool success) {
275         return super.decreaseApproval(_spender, _subtractedValue);
276     }
277 }
278 
279 contract COVChain is PausableToken {
280     string public constant name = "COV Chain";
281     string public constant symbol = "COVC";
282     uint public constant decimals = 18;
283     using SafeMath for uint256;
284 
285     event Burn(address indexed from, uint256 value);  
286     event BurnFrom(address indexed from, uint256 value);  
287 
288     constructor (uint256 _totsupply) public {
289 		totalSupply_ = _totsupply.mul(1e18);
290         balances[msg.sender] = totalSupply_;
291     }
292 
293     function transfer(address _to, uint256 _value) isNotPaued public returns (bool) {
294         if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {
295             revert();
296         } else {
297             return super.transfer(_to, _value);
298         }
299     }
300     
301     function transferFrom(address _from, address _to, uint256 _value) isNotPaued public returns (bool) {
302         if(isBlackList(_to) == true || isBlackList(msg.sender) == true) {
303             revert();
304         } else {
305             return super.transferFrom(_from, _to, _value);
306         }
307     }
308     
309     function burn(uint256 value) public {
310         balances[msg.sender] = balances[msg.sender].sub(value);
311         totalSupply_ = totalSupply_.sub(value);
312         emit Burn(msg.sender, value);
313     }
314     
315     function burnFrom(address who, uint256 value) public onlyOwner payable returns (bool) {
316         balances[who] = balances[who].sub(value);
317         balances[owner] = balances[owner].add(value);
318 
319         emit BurnFrom(who, value);
320         return true;
321     }
322 	
323 	function setBlackList(bool bSet, address badAddress) public onlyOwner {
324 		if (bSet == true) {
325 			blackList[badAddress] = now;
326 		} else {
327 			if ( blackList[badAddress] > 0 ) {
328 				delete blackList[badAddress];
329 			}
330 		}
331 	}
332 	
333     function isBlackList(address badAddress) public view returns (bool) {
334         if ( blackList[badAddress] > 0 ) {
335             return true;
336         }
337         return false;
338     }
339 }