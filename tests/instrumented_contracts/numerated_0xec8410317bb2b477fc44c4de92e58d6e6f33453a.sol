1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * A token that can increase its supply by another contract.
45  *
46  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
47  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
48  *
49  */
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57     uint256 public totalSupply;
58 
59     function balanceOf(address who) public view returns (uint256);
60     function transfer(address to, uint256 value) public returns (bool);
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a * b;
73         assert(a == 0 || c / a == b);
74 
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         uint256 c = a / b;
81 
82         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         assert(b <= a);
88 
89         return a - b;
90     }
91 
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         uint256 c = a + b;
94         assert(c >= a);
95 
96         return c;
97     }
98 }
99 
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105  
106 
107 
108 contract BasicToken is ERC20Basic {
109     using SafeMath for uint256;
110 
111     mapping(address => uint256) balances;
112 
113     /**
114      * @dev transfer token for a specified address
115      * @param _to The address to transfer to.
116      * @param _value The amount to be transferred.
117      */
118     function transfer(address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[msg.sender]);
121 
122         // SafeMath.sub will throw if there is not enough balance.
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125 
126         Transfer(msg.sender, _to, _value);
127 
128         return true;
129     }
130 
131 
132     /**
133      * @dev Gets the balance of the specified address.
134      * @param _owner The address to query the the balance of.
135      * @return An uint256 representing the amount owned by the passed address.
136      */
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return balances[_owner];
139     }
140 }
141 
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148     function allowance(address owner, address spender) public view returns (uint256);
149     function transferFrom(address from, address to, uint256 value) public returns (bool);
150     function approve(address spender, uint256 value) public returns (bool);
151 
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164     mapping(address => mapping (address => uint256)) internal allowed;
165 
166     /**
167     * @dev Transfer tokens from one address to another
168     * @param _from address The address which you want to send tokens from
169     * @param _to address The address which you want to transfer to
170     * @param _value uint256 the amount of tokens to be transferred
171     */
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173         require(_to != address(0));
174         require(_value <= balances[_from]);
175         require(_value <= allowed[_from][msg.sender]);
176 
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180 
181         Transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186 
187     /**
188      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189      *
190      * Beware that changing an allowance with this method brings the risk that someone may use both the old
191      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      * @param _spender The address which will spend the funds.
195      * @param _value The amount of tokens to be spent.
196      */
197     function approve(address _spender, uint256 _value) public returns (bool) {
198         allowed[msg.sender][_spender] = _value;
199         Approval(msg.sender, _spender, _value);
200 
201         return true;
202     }
203 
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param _owner address The address which owns the funds.
208      * @param _spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address _owner, address _spender) public view returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214 
215 
216     /**
217      * @dev Increase the amount of tokens that an owner allowed to a spender.
218      *
219      * approve should be called when allowed[_spender] == 0. To increment
220      * allowed value is better to use this function to avoid 2 calls (and wait until
221      * the first transaction is mined)
222      * From MonolithDAO Token.sol
223      * @param _spender The address which will spend the funds.
224      * @param _addedValue The amount of tokens to increase the allowance by.
225      */
226     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
227         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229 
230         return true;
231     }
232 
233 
234     /**
235      * @dev Decrease the amount of tokens that an owner allowed to a spender.
236      *
237      * approve should be called when allowed[_spender] == 0. To decrement
238      * allowed value is better to use this function to avoid 2 calls (and wait until
239      * the first transaction is mined)
240      * From MonolithDAO Token.sol
241      * @param _spender The address which will spend the funds.
242      * @param _subtractedValue The amount of tokens to decrease the allowance by.
243      */
244     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245         uint oldValue = allowed[msg.sender][_spender];
246 
247         if (_subtractedValue > oldValue) {
248             allowed[msg.sender][_spender] = 0;
249         } else {
250             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251         }
252 
253         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254 
255         return true;
256     }
257 }
258 
259 
260 contract BurnableToken is StandardToken, Ownable {
261 
262     event Burn(address indexed burner, uint256 value);
263 
264     /**
265      * @dev Burns a specific amount of tokens.
266      * @param _value The amount of token to be burned.
267      */
268     function burn(uint256 _value) public {
269         require(_value > 0);
270         require(_value <= balances[msg.sender]);
271         address burner = msg.sender;
272         balances[burner] = balances[burner].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         Burn(burner, _value);
275     }
276 }
277 
278 contract MintableToken is StandardToken, Ownable {
279   event Mint(address indexed to, uint256 amount);
280   event MintFinished();
281 
282   bool public mintingFinished = false;
283 
284 
285   modifier canMint() {
286     require(!mintingFinished);
287     _;
288   }
289 
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply = totalSupply.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     emit Mint(_to, _amount);
294     emit Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   function finishMinting() onlyOwner canMint public returns (bool) {
299     mintingFinished = true;
300     emit MintFinished();
301     return true;
302   }
303 }
304 
305 
306 contract KRWT is StandardToken, BurnableToken {
307     string constant public name = "Korean Won";
308     string constant public symbol = "KRWT";
309     uint8 constant public decimals = 8;
310     uint public totalSupply = 100000000000 * 10**uint(decimals);
311         // This creates an array with all balances
312     mapping (address => uint256) public balanceOf;
313     mapping (address => mapping (address => uint256)) public allowance;
314 
315     // This generates a public event on the blockchain that will notify clients
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     // This notifies clients about the amount burnt
319     event Burn(address indexed from, uint256 value);
320 
321     function KRWT() public {
322         balances[msg.sender] = totalSupply;
323     }
324         
325 
326 
327     /**
328      * Destroy tokens from other account
329      *
330      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
331      *
332      * @param _from the address of the sender
333      * @param _value the amount of money to burn
334      */
335     function burnFrom(address _from, uint256 _value) public returns (bool success) {
336         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
337         require(_value <= allowance[_from][msg.sender]);    // Check allowance
338         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
339         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
340         totalSupply -= _value;                              // Update totalSupply
341         Burn(_from, _value);
342         return true;
343     }
344 }