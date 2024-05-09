1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender)
59     public view returns (uint256);
60 
61   function transferFrom(address from, address to, uint256 value)
62     public returns (bool);
63 
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(
66     address indexed owner,
67     address indexed spender,
68     uint256 value
69   );
70 }
71 
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     public
129     returns (bool)
130   {
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     emit Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     emit Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(
165     address _owner,
166     address _spender
167    )
168     public
169     view
170     returns (uint256)
171   {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(
186     address _spender,
187     uint _addedValue
188   )
189     public
190     returns (bool)
191   {
192     allowed[msg.sender][_spender] = (
193       allowed[msg.sender][_spender].add(_addedValue));
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(
209     address _spender,
210     uint _subtractedValue
211   )
212     public
213     returns (bool)
214   {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 contract CrowdsaleToken is StandardToken {
228     using SafeMath for uint256;
229     
230     uint public _totalSupply = 10000000000000000000000000000;
231     uint private _tokenSupply = 25000000000000000000000000;
232     
233     uint256 public constant RATE = 1000000;
234     
235     address public owner;
236     
237     string public constant symbol = "XOXO";
238     string public constant name = "Lust Token";
239     uint8 public constant decimals = 18;
240     
241     
242     mapping(address => uint256) balances;
243     mapping(address => mapping(address => uint256)) allowed;
244     
245     function () payable {
246         createTokens();
247     }
248 
249     function CrowdsaleToken() {
250         balances[msg.sender] = _tokenSupply;
251         owner = 0xDe0ABce6E55e4422100022e50f37D3E082524DBD;
252     }
253     
254     function createTokens() payable {
255         require(msg.value > 0);
256         
257         uint256 tokens = msg.value.mul(RATE);
258         balances[msg.sender] = balances[msg.sender].add(tokens);
259         
260         owner.transfer(msg.value);
261         
262     }
263     
264     function totalSupply() constant returns (uint256 totalSupply) {
265         return _totalSupply;
266     }
267     
268     function balanceOf(address _owner) constant returns (uint256 balance) {
269         return balances[_owner];
270     }
271     
272     function transfer(address _to, uint256 _value) returns (bool success) {
273         require(
274             balances[msg.sender] >= _value
275             && _value > 0
276         );
277         balances[msg.sender] = balances[msg.sender].sub(_value);
278         balances[_to] = balances[_to].add(_value);
279         Transfer(msg.sender, _to, _value);
280         return true;
281     }
282     
283     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
284         require(
285             allowed[_from][msg.sender] >= _value
286             && balances[_from] >= _value
287             && _value > 0
288         );
289         balances[_from] = balances[_from].sub(_value);
290         balances[_to] = balances[_to].add(_value);
291         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
292         Transfer(_from, _to, _value);
293         return true;
294     }
295     
296     function approve(address _spender, uint256 _value) returns (bool success) {
297         allowed[msg.sender][_spender] = _value;
298         Approval(msg.sender, _spender, _value);
299         return true;
300     }
301     
302     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
303         return allowed[_owner][_spender];
304     }
305     
306     event Transfer(address indexed _from, address indexed _to, uint256 _value);
307     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
308 }