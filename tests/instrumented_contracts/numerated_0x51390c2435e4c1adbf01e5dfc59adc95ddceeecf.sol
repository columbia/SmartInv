1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title ERC20Basic
34  * @dev Simpler version of ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/179
36  */
37 contract ERC20Basic {
38     uint public totalSupply;
39     function balanceOf(address who) public view returns (uint);
40     function transfer(address to, uint value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint value);
42 }
43 
44 /**
45  * @title Basic token
46  * @dev Basic version of StandardToken, with no allowances.
47  */
48 contract BasicToken is ERC20Basic {
49     using SafeMath for uint;
50 
51     mapping(address => uint) balances;
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58     function transfer(address _to, uint _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[msg.sender]);
61 
62         // SafeMath.sub will throw if there is not enough balance.
63         balances[msg.sender] = balances[msg.sender].sub(_value);
64         balances[_to] = balances[_to].add(_value);
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint representing the amount owned by the passed address.
73   */
74     function balanceOf(address _owner) public view returns (uint balance) {
75         return balances[_owner];
76     }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85     function allowance(address owner, address spender) public view returns (uint);
86 
87     function transferFrom(address from, address to, uint value) public returns (bool);
88 
89     function approve(address spender, uint value) public returns (bool);
90     event Approval(address indexed owner, address indexed spender, uint value);
91 }
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103     mapping (address => mapping (address => uint)) allowed;
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint the amount of tokens to be transferred
110    */
111     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
112         require(_to != address(0));
113 
114         uint _allowance = allowed[_from][msg.sender];
115 
116         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117         require (_value <= _allowance);
118         require(_value > 0);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = _allowance.sub(_value);
123         emit Transfer(_from, _to, _value);
124         return true;
125     }
126 
127   /**
128    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132     function approve(address _spender, uint _value) public returns (bool) {
133 
134         // To change the approve amount you first have to reduce the addresses`
135         //  allowance to zero by calling `approve(_spender, 0)` if it is not
136         //  already 0 to mitigate the race condition described here:
137         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143     }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint specifying the amount of tokens still available for the spender.
150    */
151     function allowance(address _owner, address _spender) public view returns (uint remaining) {
152         return allowed[_owner][_spender];
153     }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
162         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164         return true;
165     }
166 
167     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
168         uint oldValue = allowed[msg.sender][_spender];
169         if (_subtractedValue > oldValue) {
170             allowed[msg.sender][_spender] = 0;
171         } else {
172             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173         }
174         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178 }
179 
180 /**
181  * @title ACToken
182  */
183 contract GOENTEST is StandardToken {
184 
185     string public constant name = "goentesttoken";
186     string public constant symbol = "GOENTEST";
187     // string public constant name = "gttoken";
188     // string public constant symbol = "GTT";
189     uint public constant decimals = 18; // 18位小数
190 
191     uint public constant INITIAL_SUPPLY =  10000000000 * (10 ** decimals); // 100000000000000000000000000（100亿）
192 
193     /**
194     * @dev Contructor that gives msg.sender all of existing tokens.
195     */
196     constructor() public { 
197         totalSupply = INITIAL_SUPPLY;
198         balances[msg.sender] = INITIAL_SUPPLY;
199     }
200 }
201 
202 //big lock storehouse
203 contract lockStorehouseToken is ERC20 {
204     using SafeMath for uint;
205     
206     GOENTEST   tokenReward;
207     
208     address private beneficial;
209     uint    private lockMonth;
210     uint    private startTime;
211     uint    private releaseSupply;
212     bool    private released = false;
213     uint    private per;
214     uint    private releasedCount = 0;
215     uint    public  limitMaxSupply; //限制从合约转出代币的最大金额
216     uint    public  oldBalance;
217     uint    private constant decimals = 18;
218     
219     constructor(
220         address _tokenReward,
221         address _beneficial,
222         uint    _per,
223         uint    _startTime,
224         uint    _lockMonth,
225         uint    _limitMaxSupply
226     ) public {
227         tokenReward     = GOENTEST(_tokenReward);
228         beneficial      = _beneficial;
229         per             = _per;
230         startTime       = _startTime;
231         lockMonth       = _lockMonth;
232         limitMaxSupply  = _limitMaxSupply * (10 ** decimals);
233         
234         // 测试代码
235         // tokenReward = GOENT(0xEfe106c517F3d23Ab126a0EBD77f6Ec0f9efc7c7);
236         // beneficial = 0x1cDAf48c23F30F1e5bC7F4194E4a9CD8145aB651;
237         // per = 125;
238         // startTime = now;
239         // lockMonth = 1;
240         // limitMaxSupply = 3000000000 * (10 ** decimals);
241     }
242     
243     mapping(address => uint) balances;
244     
245     function approve(address _spender, uint _value) public returns (bool){}
246     
247     function allowance(address _owner, address _spender) public view returns (uint){}
248     
249     function balanceOf(address _owner) public view returns (uint balance) {
250         return balances[_owner];
251     }
252     
253     function transfer(address _to, uint _value) public returns (bool) {
254         require(_to != address(0));
255         require(_value <= balances[msg.sender]);
256         
257         balances[msg.sender] = balances[msg.sender].sub(_value);
258         balances[_to] = balances[_to].add(_value);
259         emit Transfer(msg.sender, _to, _value);
260         return true;
261     }
262     
263     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
264         require(_to != address(0));
265         require (_value > 0);
266         require(_value <= balances[_from]);
267         
268         balances[_from] = balances[_from].sub(_value);
269         balances[_to] = balances[_to].add(_value);
270         emit Transfer(_from, _to, _value);
271         return true;
272     }
273     
274     function getBeneficialAddress() public constant returns (address){
275         return beneficial;
276     }
277     
278     function getBalance() public constant returns(uint){
279         return tokenReward.balanceOf(this);
280     }
281     
282     modifier checkBalance {
283         if(!released){
284             oldBalance = getBalance();
285             if(oldBalance > limitMaxSupply){
286                 oldBalance = limitMaxSupply;
287             }
288         }
289         _;
290     }
291     
292     function release() checkBalance public returns(bool) {
293         // uint _lockMonth;
294         // uint _baseDate;
295         uint cliffTime;
296         uint monthUnit;
297         
298         released = true;
299         // 释放金额
300         releaseSupply = SafeMath.mul(SafeMath.div(oldBalance, 1000), per);
301         
302         // 释放金额必须小于等于当前合同余额
303         if(SafeMath.mul(releasedCount, releaseSupply) <= oldBalance){
304             // if(per == 1000){
305             //     _lockMonth = SafeMath.div(lockMonth, 12);
306             //     _baseDate = 1 years;
307                 
308             // }
309             
310             // if(per < 1000){
311             //     _lockMonth = lockMonth;
312             //     _baseDate = 30 days;
313             //     // _baseDate = 1 minutes;
314             // }
315 
316             // _lockMonth = lockMonth;
317             // _baseDate = 30 days;
318             // monthUnit = SafeMath.mul(5, 1 minutes);
319             monthUnit = SafeMath.mul(lockMonth, 30 days);
320             cliffTime = SafeMath.add(startTime, monthUnit);
321         
322             if(now > cliffTime){
323                 
324                 tokenReward.transfer(beneficial, releaseSupply);
325                 
326                 releasedCount++;
327 
328                 startTime = now;
329                 
330                 return true;
331             
332             }
333         } else {
334             return false;
335         }
336         
337     }
338     
339     function () private payable {
340     }
341 }