1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     if (_a == 0) {
10       return 0;
11     }
12     c = _a * _b;
13     assert(c / _a == _b);
14     return c;
15   }
16 
17   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
18     // assert(_b > 0); // Solidity automatically throws when dividing by 0
19     // uint256 c = _a / _b;
20     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
21     return _a / _b;
22   }
23 
24   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     assert(_b <= _a);
26     return _a - _b;
27   }
28 
29   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     c = _a + _b;
31     assert(c >= _a);
32     return c;
33   }
34 }
35 
36 contract ERC20Basic {
37   function totalSupply() public view returns (uint256);
38   function balanceOf(address _who) public view returns (uint256);
39   function transfer(address _to, uint256 _value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 /**
44  * @title ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/20
46  */
47 contract ERC20 is ERC20Basic {
48   function allowance(address _owner, address _spender) public view returns (uint256);
49   function transferFrom(address _from, address _to, uint256 _value)  public returns (bool);
50   function approve(address _spender, uint256 _value) public returns (bool);
51   event Approval(address indexed owner,address indexed spender,uint256 value);
52 }
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56   mapping(address => uint256) internal balances;
57   uint256 internal totalSupply_;
58 
59   /**
60   * @dev Total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev Transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_value <= balances[msg.sender]);
73     require(_to != address(0));
74 
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94   mapping (address => mapping (address => uint256)) internal allowed;
95 
96 
97   /**
98    * @dev Transfer tokens from one address to another
99    * @param _from address The address which you want to send tokens from
100    * @param _to address The address which you want to transfer to
101    * @param _value uint256 the amount of tokens to be transferred
102    */
103   function transferFrom(
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     public
109     returns (bool)
110   {
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113     require(_to != address(0));
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     emit Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129  
130   function allowance(
131     address _owner,
132     address _spender
133    )
134     public
135     view
136     returns (uint256)
137   {
138     return allowed[_owner][_spender];
139   }
140 
141   /**
142    * @dev Increase the amount of tokens that an owner allowed to a spender.
143    * approve should be called when allowed[_spender] == 0. To increment
144    * allowed value is better to use this function to avoid 2 calls (and wait until
145    * the first transaction is mined)
146    * From MonolithDAO Token.sol
147    * @param _spender The address which will spend the funds.
148    * @param _addedValue The amount of tokens to increase the allowance by.
149    */
150   function increaseApproval(
151     address _spender,
152     uint256 _addedValue
153   )
154     public
155     returns (bool)
156   {
157     allowed[msg.sender][_spender] = (
158       allowed[msg.sender][_spender].add(_addedValue));
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   /**
164    * @dev Decrease the amount of tokens that an owner allowed to a spender.
165    * approve should be called when allowed[_spender] == 0. To decrement
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    * @param _spender The address which will spend the funds.
170    * @param _subtractedValue The amount of tokens to decrease the allowance by.
171    */
172   function decreaseApproval(
173     address _spender,
174     uint256 _subtractedValue
175   )
176     public
177     returns (bool)
178   {
179     uint256 oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue >= oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 // ERC20 standard token
192 contract NBEToken is StandardToken {
193     address public admin;
194     string public name = "NBEToken";
195     string public symbol = "NBE"; 
196     uint8 public decimals = 18; 
197     uint256 public INITIAL_SUPPLY = 10000000000000000000000000000;
198     
199     mapping (address => uint256) public frozenTimestamp; 
200 
201     bool public exchangeFlag = true; 
202    
203     uint256 public minWei = 1;  // 1 wei  1eth = 1*10^18 wei
204     uint256 public maxWei = 20000000000000000000000; // 20000 eth
205     uint256 public maxRaiseAmount = 500000000000000000000000; //  500000 eth
206     uint256 public raisedAmount = 0; //  0 eth
207     uint256 public raiseRatio = 10000; //  1eth = 10000
208 
209     constructor() public {
210         totalSupply_ = INITIAL_SUPPLY;
211         admin = msg.sender;
212         balances[msg.sender] = INITIAL_SUPPLY;
213     }
214 
215     function()
216     public payable {
217         require(msg.value > 0);
218         if (exchangeFlag) {
219             if (msg.value >= minWei && msg.value <= maxWei){
220                 if (raisedAmount < maxRaiseAmount) {
221                     uint256 valueNeed = msg.value;
222                     raisedAmount = raisedAmount.add(msg.value);
223                     if (raisedAmount > maxRaiseAmount) {
224                         uint256 valueLeft = raisedAmount.sub(maxRaiseAmount);
225                         valueNeed = msg.value.sub(valueLeft);
226                         msg.sender.transfer(valueLeft);
227                         raisedAmount = maxRaiseAmount;
228                     }
229                     if (raisedAmount >= maxRaiseAmount) {
230                         exchangeFlag = false;
231                     }
232                    
233                     uint256 _value = valueNeed.mul(raiseRatio);
234 
235                     require(_value <= balances[admin]);
236                     balances[admin] = balances[admin].sub(_value);
237                     balances[msg.sender] = balances[msg.sender].add(_value);
238 
239                     emit Transfer(admin, msg.sender, _value);
240 
241                 }
242             } else {
243                 msg.sender.transfer(msg.value);
244             }
245         } else {
246             msg.sender.transfer(msg.value);
247         }
248     }
249 
250     /**
251     * admin
252     */
253     function changeAdmin(
254         address _newAdmin
255     )
256     public
257     returns (bool)  {
258         require(msg.sender == admin);
259         require(_newAdmin != address(0));
260         balances[_newAdmin] = balances[_newAdmin].add(balances[admin]);
261         balances[admin] = 0;
262         admin = _newAdmin;
263         return true;
264     }
265 
266     // withdraw admin
267     function withdraw (
268         uint256 _amount
269     )
270     public
271     returns (bool) {
272         require(msg.sender == admin);
273         msg.sender.transfer(_amount);
274         return true;
275     }
276     
277     /**
278     * 
279     */
280     function transfer(
281         address _to,
282         uint256 _value
283     )
284     public
285     returns (bool) {
286         // require(!frozenAccount[msg.sender]);
287         require(now > frozenTimestamp[msg.sender]);
288         require(_to != address(0));
289         require(_value <= balances[msg.sender]);
290 
291         balances[msg.sender] = balances[msg.sender].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293 
294         emit Transfer(msg.sender, _to, _value);
295         return true;
296     }
297     
298     //********************************************************************************
299     //
300     function getFrozenTimestamp(
301         address _target
302     )
303     public view
304     returns (uint256) {
305         require(_target != address(0));
306         return frozenTimestamp[_target];
307     }
308   
309     //
310     function getBalance()
311     public view
312     returns (uint256) {
313         return address(this).balance;
314     }
315     
316 
317     // change flag
318     function setExchangeFlag (
319         bool _flag
320     )
321     public
322     returns (bool) {
323         require(msg.sender == admin);
324         exchangeFlag = _flag;
325         return true;
326 
327     }
328 
329     // change ratio
330     function setRaiseRatio (
331         uint256 _value
332     )
333     public
334     returns (bool) {
335         require(msg.sender == admin);
336         raiseRatio = _value;
337         return true;
338     }
339 
340 
341 }