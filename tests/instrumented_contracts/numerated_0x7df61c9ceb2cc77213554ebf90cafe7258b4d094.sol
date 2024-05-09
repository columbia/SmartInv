1 pragma solidity ^0.4.15;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     function div(uint256 a, uint256 b) internal returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25     function add(uint256 a, uint256 b) internal returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address public owner;
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     function Ownable() public {
44         owner = msg.sender;
45     }
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param newOwner The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner) onlyOwner public  {
58         require(newOwner != address(0));
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 }
63 /**
64  * @title Pausable
65  * @dev Base contract which allows children to implement an emergency stop mechanism.
66  */
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70     bool public paused = false;
71     /**
72      * @dev Modifier to make a function callable only when the contract is not paused.
73      */
74     modifier whenNotPaused() {
75         require(!paused);
76         _;
77     }
78     /**
79      * @dev Modifier to make a function callable only when the contract is paused.
80      */
81     modifier whenPaused() {
82         require(paused);
83         _;
84     }
85     /**
86      * @dev called by the owner to pause, triggers stopped state
87      */
88     function pause() onlyOwner whenNotPaused public {
89         paused = true;
90         Pause();
91     }
92     /**
93      * @dev called by the owner to unpause, returns to normal state
94      */
95     function unpause() onlyOwner whenPaused public {
96         paused = false;
97         Unpause();
98     }
99 }
100 
101 /**
102 * ERC20 + ERC20Basic
103 */
104 contract ERC20Token {
105     uint256 public totalSupply;
106     function balanceOf(address who) public view returns (uint256);
107     function allowance(address owner, address spender) public view returns (uint256);
108     function transfer(address to, uint256 value) public returns (bool);
109     function transferFrom(address from, address to, uint256 value) public returns (bool);
110     function approve(address spender, uint256 value) public returns (bool);
111     event Transfer(address indexed from, address indexed to, uint256 value);
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 interface tokenRecipient {
116     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
117 }
118 
119 
120 /**
121 StandardToken + MintableToken + BurnableToken
122  */
123 contract MoonToken is ERC20Token, Pausable {
124     using SafeMath for uint256;
125     mapping(address => uint256) balances;
126     mapping (address => mapping (address => uint256)) internal allowed;
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param _owner The address to query the the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address _owner) public view returns (uint256 balance) {
133         return balances[_owner];
134     }
135     /**
136          * @dev Function to check the amount of tokens that an owner allowed to a spender.
137          * @param _owner address The address which owns the funds.
138          * @param _spender address The address which will spend the funds.
139          * @return A uint256 specifying the amount of tokens still available for the spender.
140          */
141     function allowance(address _owner, address _spender) public view returns (uint256) {
142         return allowed[_owner][_spender];
143     }
144     /**
145         * @dev transfer token for a specified address
146         * @param _to The address to transfer to.
147         * @param _value The amount to be transferred.
148         */
149     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
150         require(_to != address(0));
151         require(_value <= balances[msg.sender]);
152         // SafeMath.sub will throw if there is not enough balance.
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158     /**
159      * @dev Transfer tokens from one address to another
160      * @param _from address The address which you want to send tokens from
161      * @param _to address The address which you want to transfer to
162      * @param _value uint256 the amount of tokens to be transferred
163      */
164     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
165         require(_to != address(0));
166         require(_value <= balances[_from]);
167         require(_value <= allowed[_from][msg.sender]);
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171         Transfer(_from, _to, _value);
172         return true;
173     }
174     /**
175      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176      *
177      * Beware that changing an allowance with this method brings the risk that someone may use both the old
178      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      * @param _spender The address which will spend the funds.
182      * @param _value The amount of tokens to be spent.
183      */
184     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189     /**
190      * Set allowance for other address and notify
191      *
192      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
193      *
194      * @param _spender The address authorized to spend
195      * @param _value the max amount they can spend
196      * @param _extraData some extra information to send to the approved contract
197      */
198     function approveAndCall(address _spender, uint256 _value, bytes _extraData) whenNotPaused public returns (bool success) {
199         tokenRecipient spender = tokenRecipient(_spender);
200         if (approve(_spender, _value)) {
201             spender.receiveApproval(msg.sender, _value, this, _extraData);
202             return true;
203         }
204     }
205     /**
206      * approve should be called when allowed[_spender] == 0. To increment
207      * allowed value is better to use this function to avoid 2 calls (and wait until
208      * the first transaction is mined)
209      * From MonolithDAO Token.sol
210      */
211     function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
212         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216     function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226     /**
227      * @dev Function to mint tokens
228      * @param _to The address that will receive the minted tokens.
229      * @param _amount The amount of tokens to mint.
230      * @return A boolean that indicates if the operation was successful.
231      */
232     function mint(address _to, uint256 _amount) onlyOwner whenNotPaused public returns (bool) {
233         totalSupply = totalSupply.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         Mint(_to, _amount);
236         Transfer(address(0), _to, _amount);
237         return true;
238     }
239     /**
240      * @dev Burns a specific amount of tokens.
241      * @param _value The amount of token to be burned.
242      */
243     function burn(uint256 _value) whenNotPaused public {
244         require(_value > 0);
245         require(_value <= balances[msg.sender]);
246         // no need to require value <= totalSupply, since that would imply the
247         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
248         address burner = msg.sender;
249         balances[burner] = balances[burner].sub(_value);
250         totalSupply = totalSupply.sub(_value);
251         Burn(burner, _value);
252     }
253     function burnFrom(address _from, uint256 _value) onlyOwner whenNotPaused public {
254         require(_value > 0);
255         require(_value <= balances[_from]);
256         address burner = _from;
257         balances[burner] = balances[burner].sub(_value);
258         totalSupply = totalSupply.sub(_value);
259         Burn(burner, _value);
260     }
261     event Mint(address indexed to, uint256 amount);
262     event Burn(address indexed burner, uint256 value);
263 }
264 contract MoonLotteryToken is MoonToken {
265     string public name = "MoonLottery Token";
266     string public symbol = "MLOT";
267     uint8 public decimals = 18;
268 
269     function MoonLotteryToken () public {
270 
271     }
272 }