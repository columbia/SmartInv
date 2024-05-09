1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     uint256 totalSupply_;
70 
71     /**
72     * @dev total number of tokens in existence
73     */
74     function totalSupply() public view returns (uint256) {
75         return totalSupply_;
76     }
77 
78     /**
79     * @dev transfer token for a specified address
80     * @param _to The address to transfer to.
81     * @param _value The amount to be transferred.
82     */
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         require(_to != address(0));
85         require(_value <= balances[msg.sender]);
86 
87         // SafeMath.sub will throw if there is not enough balance.
88         balances[msg.sender] = balances[msg.sender].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         emit Transfer(msg.sender, _to, _value);
91         return true;
92     }
93 
94     /**
95     * @dev Gets the balance of the specified address.
96     * @param _owner The address to query the the balance of.
97     * @return An uint256 representing the amount owned by the passed address.
98     */
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103 }
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113     function transferFrom(address from, address to, uint256 value) public returns (bool);
114     function approve(address spender, uint256 value) public returns (bool);
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128     mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131     /**
132     * @dev Transfer tokens from one address to another
133     * @param _from address The address which you want to send tokens from
134     * @param _to address The address which you want to transfer to
135     * @param _value uint256 the amount of tokens to be transferred
136     */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         require(_value <= allowed[_from][msg.sender]);
141 
142         balances[_from] = balances[_from].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145         Transfer(_from, _to, _value);
146         return true;
147     }
148 
149     /**
150     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151     *
152     * Beware that changing an allowance with this method brings the risk that someone may use both the old
153     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     * @param _spender The address which will spend the funds.
157     * @param _value The amount of tokens to be spent.
158     */
159     function approve(address _spender, uint256 _value) public returns (bool) {
160         allowed[msg.sender][_spender] = _value;
161         Approval(msg.sender, _spender, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Function to check the amount of tokens that an owner allowed to a spender.
167     * @param _owner address The address which owns the funds.
168     * @param _spender address The address which will spend the funds.
169     * @return A uint256 specifying the amount of tokens still available for the spender.
170     */
171     function allowance(address _owner, address _spender) public view returns (uint256) {
172         return allowed[_owner][_spender];
173     }
174 
175     /**
176     * @dev Increase the amount of tokens that an owner allowed to a spender.
177     *
178     * approve should be called when allowed[_spender] == 0. To increment
179     * allowed value is better to use this function to avoid 2 calls (and wait until
180     * the first transaction is mined)
181     * From MonolithDAO Token.sol
182     * @param _spender The address which will spend the funds.
183     * @param _addedValue The amount of tokens to increase the allowance by.
184     */
185     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188         return true;
189     }
190 
191     /**
192     * @dev Decrease the amount of tokens that an owner allowed to a spender.
193     *
194     * approve should be called when allowed[_spender] == 0. To decrement
195     * allowed value is better to use this function to avoid 2 calls (and wait until
196     * the first transaction is mined)
197     * From MonolithDAO Token.sol
198     * @param _spender The address which will spend the funds.
199     * @param _subtractedValue The amount of tokens to decrease the allowance by.
200     */
201     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202         uint oldValue = allowed[msg.sender][_spender];
203         if (_subtractedValue > oldValue) {
204             allowed[msg.sender][_spender] = 0;
205         } else {
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 
212 }
213 
214 contract Usable {
215     function use(address to, uint256 value, uint256 useType, uint256 param1, uint256 param2, uint256 param3, string param4) external;
216     function setUseAddr(address addr) external;
217     function setFee(uint256 useType, uint16 feeType, uint256 fee) external;
218     event UseSucc(address indexed from, address indexed to, uint256 useType, uint256 value, uint256 fee, uint256 param1, uint256 param2, uint256 param3, string param4);
219     event UseFail(address indexed from, address indexed to, uint256 useType, uint256 value, uint256 fee, uint256 param1, uint256 param2, uint256 param3, string param4);
220 }
221 
222 contract DragonCoin is StandardToken, Usable {
223     using SafeMath for uint256;
224     
225     event Mint(address indexed to, uint256 value);
226     event Burn(address indexed burner, uint256 value);
227     
228     string public name = "DragonSeriesToken"; 
229     string public symbol = "DST";
230     uint public decimals = 18;
231     uint public INITIAL_SUPPLY = 1100000 * (10 ** decimals);     
232     uint public MAX_SUPPLY = 10 * 100000000 * (10 ** decimals); 
233     address public ceo;
234     address public coo;
235     address public cfo;
236 
237     UseInterface public useAddr;
238 
239     // key = useType, value = UseFee
240     mapping (uint256 => UseFee) public useFees;
241     uint private _maxPercentFee = 1000000;
242 
243     struct UseFee {
244         uint16 feeType;     // 1: fixed, 2: percentage
245         uint256 fee;        // feeType=1: DST, feeType=2: 0-1000000 (0.0000% - 100.0000%)
246     }
247     
248     function DragonCoin() public {
249         totalSupply_ = INITIAL_SUPPLY;
250         balances[msg.sender] = INITIAL_SUPPLY;
251         ceo = msg.sender;
252         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
253     }
254     
255     function setCEO(address newCEO) public onlyCEO{
256         require(newCEO != address(0));
257         
258         ceo = newCEO;
259     }
260     
261     function setCOO(address newCOO) public onlyCEO{
262         require(newCOO != address(0));
263         
264         coo = newCOO;
265     }
266     
267     function setCFO(address newCFO) public onlyCEO{
268         require(newCFO != address(0));
269         
270         cfo = newCFO;
271     }
272 
273     function mint(uint256 value) public onlyCFO returns (bool) {
274         require(totalSupply_.add(value) <= MAX_SUPPLY);
275         
276         balances[cfo] = balances[cfo].add(value);
277         totalSupply_ = totalSupply_.add(value);
278         
279         // mint event
280         emit Mint(cfo, value);
281         emit Transfer(0x0, cfo, value);
282         return true;
283     }
284     
285     function burn(uint256 value) public onlyCOO returns (bool) {
286         require(balances[coo] >= value); 
287         
288         balances[coo] = balances[coo].sub(value);
289         totalSupply_ = totalSupply_.sub(value);
290         
291         // burn event
292         emit Burn(coo, value);
293         emit Transfer(coo, 0x0, value);
294         return true;
295     }
296 
297     // Useable
298 
299     function setUseAddr(address addr) external onlyCOO{
300         useAddr = UseInterface(addr);
301     }
302 
303     function setFee(uint256 useType, uint16 feeType, uint256 fee) external onlyCOO{
304         require(feeType == 1 || feeType == 2);
305 
306         if(feeType == 2){
307             require(fee <= _maxPercentFee);
308         }
309 
310         UseFee memory ufee = UseFee({
311             feeType: feeType,
312             fee: fee
313         });
314         useFees[useType] = ufee;
315     }
316 
317     function use(address to, uint256 value, uint256 useType, uint256 param1, uint256 param2, uint256 param3, string param4) external {
318         require(useAddr != address(0));
319         require(balances[msg.sender] >= value);
320         require(to != address(0) && cfo != address(0));
321         
322         UseFee memory ufee = useFees[useType];
323 
324         require(ufee.feeType == 1 || ufee.feeType == 2);
325         
326         uint256 actualFee = 0;
327 
328         if(ufee.feeType == 1){  // fixed fee
329             actualFee = ufee.fee;
330         }else if(ufee.feeType == 2){  // percentage fee
331             actualFee = value.mul(ufee.fee).div(_maxPercentFee);
332         }
333 
334         uint256 actualVal = value.sub(actualFee);
335 
336         if(useAddr.use(msg.sender, to, value, useType, param1, param2, param3, param4)){
337             // transfer token
338             balances[msg.sender] = balances[msg.sender].sub(value);
339             balances[to] = balances[to].add(actualVal);
340             emit Transfer(msg.sender, to, actualVal);
341 
342             if(actualFee > 0){
343                 balances[cfo] = balances[cfo].add(actualFee);
344                 emit Transfer(msg.sender, cfo, actualFee);
345             }
346 
347             emit UseSucc(msg.sender, to, useType, value, actualFee, param1, param2, param3, param4);
348         }else{
349             emit UseFail(msg.sender, to, useType, value, actualFee, param1, param2, param3, param4);
350         }
351     }
352 
353     /// @dev Access modifier for CEO-only functionality
354     modifier onlyCEO() {
355         require(msg.sender == ceo);
356         _;
357     }
358     
359     /// @dev Access modifier for CFO-only functionality
360     modifier onlyCFO() {
361         require(msg.sender == cfo);
362         _;
363     }
364     
365     /// @dev Access modifier for COO-only functionality
366     modifier onlyCOO() {
367         require(msg.sender == coo);
368         _;
369     }
370     
371 }
372 
373 contract UseInterface {
374     function use(address from, address to, uint256 value, uint256 useType, uint256 param1, uint256 param2, uint256 param3, string param4) external returns (bool);
375 }