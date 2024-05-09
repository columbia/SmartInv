1 pragma solidity ^0.4.24;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * See https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9 
10     function balanceOf(address _who) public view returns (uint256);
11 
12     function transfer(address _to, uint256 _value) public returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
26         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (_a == 0) {
30             return 0;
31         }
32 
33         c = _a * _b;
34         assert(c / _a == _b);
35         return c;
36     }
37 
38     /**
39     * @dev Integer division of two numbers, truncating the quotient.
40     */
41     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
42         // assert(_b > 0); // Solidity automatically throws when dividing by 0
43         // uint256 c = _a / _b;
44         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
45         return _a / _b;
46     }
47 
48     /**
49     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50     */
51     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         assert(_b <= _a);
53         return _a - _b;
54     }
55 
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
60         c = _a + _b;
61         assert(c >= _a);
62         return c;
63     }
64 }
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70     function allowance(address _owner, address _spender)
71     public view returns (uint256);
72 
73     function transferFrom(address _from, address _to, uint256 _value)
74     public returns (bool);
75 
76     function approve(address _spender, uint256 _value) public returns (bool);
77 
78     event Approval(
79         address indexed owner,
80         address indexed spender,
81         uint256 value
82     );
83 }
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) internal balances;
92 
93     uint256 internal totalSupply_;
94 
95     /**
96     * @dev Total number of tokens in existence
97     */
98     function totalSupply() public view returns (uint256) {
99         return totalSupply_;
100     }
101 
102     /**
103     * @dev Transfer token for a specified address
104     * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106     */
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         require(_value <= balances[msg.sender]);
109         require(_to != address(0));
110 
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param _owner The address to query the the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
122     function balanceOf(address _owner) public view returns (uint256) {
123         return balances[_owner];
124     }
125 
126 }
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * https://github.com/ethereum/EIPs/issues/20
132  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136     mapping(address => mapping(address => uint256)) internal allowed;
137 
138 
139     /**
140      * @dev Transfer tokens from one address to another
141      * @param _from address The address which you want to send tokens from
142      * @param _to address The address which you want to transfer to
143      * @param _value uint256 the amount of tokens to be transferred
144      */
145     function transferFrom(
146         address _from,
147         address _to,
148         uint256 _value
149     )
150     public
151     returns (bool)
152     {
153         require(_value <= balances[_from]);
154         require(_value <= allowed[_from][msg.sender]);
155         require(_to != address(0));
156 
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         emit Transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /**
165      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166      * Beware that changing an allowance with this method brings the risk that someone may use both the old
167      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      * @param _spender The address which will spend the funds.
171      * @param _value The amount of tokens to be spent.
172      */
173     function approve(address _spender, uint256 _value) public returns (bool) {
174         allowed[msg.sender][_spender] = _value;
175         emit Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179     /**
180      * @dev Function to check the amount of tokens that an owner allowed to a spender.
181      * @param _owner address The address which owns the funds.
182      * @param _spender address The address which will spend the funds.
183      * @return A uint256 specifying the amount of tokens still available for the spender.
184      */
185     function allowance(
186         address _owner,
187         address _spender
188     )
189     public
190     view
191     returns (uint256)
192     {
193         return allowed[_owner][_spender];
194     }
195 
196     /**
197      * @dev Increase the amount of tokens that an owner allowed to a spender.
198      * approve should be called when allowed[_spender] == 0. To increment
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * @param _spender The address which will spend the funds.
203      * @param _addedValue The amount of tokens to increase the allowance by.
204      */
205     function increaseApproval(
206         address _spender,
207         uint256 _addedValue
208     )
209     public
210     returns (bool)
211     {
212         allowed[msg.sender][_spender] = (
213         allowed[msg.sender][_spender].add(_addedValue));
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      * approve should be called when allowed[_spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _subtractedValue The amount of tokens to decrease the allowance by.
226      */
227     function decreaseApproval(
228         address _spender,
229         uint256 _subtractedValue
230     )
231     public
232     returns (bool)
233     {
234         uint256 oldValue = allowed[msg.sender][_spender];
235         if (_subtractedValue >= oldValue) {
236             allowed[msg.sender][_spender] = 0;
237         } else {
238             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
239         }
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 
244 }
245 
246 contract ModexToken is StandardToken {
247 
248     address public owner;
249     modifier onlyOwner {
250         require(msg.sender == owner);
251         _;
252     }
253 
254     modifier protectReserve{
255         require(COMPANY_RESERVE_RELEASED == false);
256         require(now > COMPANY_RESERVE_UNLOCK_DATE);
257         _;
258     }
259 
260     string public name = "Modex";
261     string public symbol = "MODEX";
262 
263     uint public decimals = 18;
264     uint public COMPANY_RESERVE_UNLOCK_DATE;
265 
266     uint public INITIAL_SUPPLY = 143855996 * (10 ** decimals);
267 
268     bool public COMPANY_RESERVE_RELEASED = false;
269     uint public COMPANY_RESERVE = 122543997 * (10 ** decimals);
270     uint public COMPANY_RESERVE_LOCK_PERIOD=31536000;//1 year
271 
272     constructor() public {
273         owner = msg.sender;
274         totalSupply_ = INITIAL_SUPPLY + COMPANY_RESERVE;
275         COMPANY_RESERVE_UNLOCK_DATE = now + COMPANY_RESERVE_LOCK_PERIOD;
276         //a year in seconds
277         balances[msg.sender] = INITIAL_SUPPLY;
278         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
279     }
280 
281     function bulkSend(address[] addresses, uint256[] amounts) public onlyOwner {
282         require(addresses.length > 0);
283         require(addresses.length == amounts.length);
284 
285         uint256 length = addresses.length;
286         for (uint256 i = 0; i < length; i++) {
287             uint256 amount = amounts[i];
288             require(amount > 0);
289             // Costs 9700 gas for existing accounts,
290             // 34700 gas for nonexistent accounts.
291             // Might fail in case the destination is a smart contract with a default
292             // method that uses more than 2300 gas.
293             // If it fails the top level transaction will be reverted.
294             transfer(addresses[i],amount);
295         }
296     }
297     function releaseCompanyReserve() public onlyOwner protectReserve {
298         balances[msg.sender] += COMPANY_RESERVE;
299         emit Transfer(0x0, msg.sender, COMPANY_RESERVE);
300         COMPANY_RESERVE_RELEASED = true;
301     }
302 }