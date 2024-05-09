1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23     function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26     function approve(address spender, uint256 value) public returns (bool);
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two numbers, truncating the quotient.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         // uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return a / b;
64     }
65 
66     /**
67     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     /**
75     * @dev Adds two numbers, throws on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
78         c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89     using SafeMath for uint256;
90 
91     mapping(address => uint256) balances;
92 
93     uint256 totalSupply_;
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
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
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
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141      * @dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(
147         address _from,
148         address _to,
149         uint256 _value
150     )
151     public
152     returns (bool)
153     {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * @dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190     public
191     view
192     returns (uint256)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseApproval(
207         address _spender,
208         uint256 _addedValue
209     )
210     public
211     returns (bool)
212     {
213         allowed[msg.sender][_spender] = (
214         allowed[msg.sender][_spender].add(_addedValue));
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219     /**
220      * @dev Decrease the amount of tokens that an owner allowed to a spender.
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(
229         address _spender,
230         uint256 _subtractedValue
231     )
232     public
233     returns (bool)
234     {
235         uint256 oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 contract BecentToken is StandardToken {
248 
249     string public name = "BecentToken";
250 
251     string public symbol = "BCT";
252 
253     uint public decimals = 18;
254 
255     uint public INITIAL_SUPPLY = 10000000000 * 1000000000000000000;
256 
257     address public masterAddress;
258 
259     bool public paused = false;
260 
261     constructor() public {
262         totalSupply_ = INITIAL_SUPPLY;
263         balances[msg.sender] = INITIAL_SUPPLY;
264         masterAddress = msg.sender;
265     }
266 
267     modifier whenPaused() {
268         require(paused);
269         _;
270     }
271 
272     modifier whenNotPaused() {
273         require(!paused);
274         _;
275     }
276 
277     modifier onlyMaster() {
278         require(msg.sender == masterAddress);
279         _;
280     }
281 
282     function pause() public whenNotPaused onlyMaster {
283         paused = true;
284     }
285 
286     function unpause() public whenPaused onlyMaster {
287         paused = false;
288     }
289 
290     function transfer(address _to, uint256 _value) public returns (bool) {
291         require(!paused);
292         require(msg.data.length >= (2 * 32) + 4);
293         return super.transfer(_to, _value);
294     }
295 
296     function transferFrom(
297         address _from,
298         address _to,
299         uint256 _value
300     ) public returns (bool) {
301         require(!paused);
302         return super.transferFrom(_from, _to, _value);
303     }
304 
305     function approve(address _spender, uint256 _value) public returns (bool) {
306         require(!paused);
307         require(_value == 0 || allowed[msg.sender][_spender] == 0);
308         require(msg.data.length >= (2 * 32) + 4);
309         return super.approve(_spender, _value);
310     }
311 
312     function increaseApproval(
313         address _spender,
314         uint256 _addedValue
315     ) public returns (bool) {
316         require(!paused);
317         return super.increaseApproval(_spender, _addedValue);
318     }
319 
320     function decreaseApproval(
321         address _spender,
322         uint256 _subtractedValue
323     ) public returns (bool) {
324         require(!paused);
325         return super.decreaseApproval(_spender, _subtractedValue);
326     }
327 }