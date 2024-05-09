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
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   constructor() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 interface IFreezableToken {
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Freeze(address indexed owner, address indexed user, bool status);
96 
97     function totalSupply() external view returns (uint256);
98     function balanceOf(address who) external view returns (uint256);
99     function transfer(address to, uint256 value) external returns (bool);
100     function allowance(address owner, address spender) external view returns (uint256);
101     function transferFrom(address from, address to, uint256 value) external returns (bool);
102     function approve(address spender, uint256 value) external returns (bool);
103     function increaseApproval(address spender, uint256 addedValue) external returns (bool);
104     function decreaseApproval(address spender, uint256 subtractedValue) external returns (bool);
105     function freeze(address user) external returns (bool);
106     function unfreeze(address user) external returns (bool);
107     function freezing(address user) external view returns (bool);
108 }
109 
110 
111 contract FreezableToken is Ownable, IFreezableToken {
112     using SafeMath for uint256;
113 
114     mapping(address => uint256) balances;
115     mapping(address => mapping(address => uint256)) internal allowed;
116     mapping(address => bool) frozen;
117 
118     modifier unfreezing(address user) {
119         require(!frozen[user], "Cannot transfer from a freezing address");
120         _;
121     }
122 
123     uint256 internal _totalSupply;
124 
125     /**
126      * @dev total number of tokens in existence
127      */
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     /**
133      * @dev transfer token for a specified address
134      * @param _to The address to transfer to.
135      * @param _value The amount to be transferred.
136      */
137     function transfer(address _to, uint256 _value) public unfreezing(msg.sender) returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[msg.sender]);
140 
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer(msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Gets the balance of the specified address.
149      * @param _owner The address to query the the balance of.
150      * @return An uint256 representing the amount owned by the passed address.
151      */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156     /**
157      * @dev Transfer tokens from one address to another
158      * @param _from address The address which you want to send tokens from
159      * @param _to address The address which you want to transfer to
160      * @param _value uint256 the amount of tokens to be transferred
161      */
162     function transferFrom(address _from, address _to, uint256 _value) public unfreezing(_from) returns (bool) {
163         require(_to != address(0));
164         require(_value <= balances[_from]);
165         require(_value <= allowed[_from][msg.sender]);
166 
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
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
184     function approve(address _spender, uint256 _value) public returns (bool) {
185         require(_spender != address(0));
186 
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191 
192     /**
193      * @dev Function to check the amount of tokens that an owner allowed to a spender.
194      * @param _owner address The address which owns the funds.
195      * @param _spender address The address which will spend the funds.
196      * @return A uint256 specifying the amount of tokens still available for the spender.
197      */
198     function allowance(address _owner, address _spender) public view returns (uint256) {
199         return allowed[_owner][_spender];
200     }
201 
202     /**
203      * @dev Increase the amount of tokens that an owner allowed to a spender.
204      *
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * @param _spender The address which will spend the funds.
210      * @param _addedValue The amount of tokens to increase the allowance by.
211      */
212     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
213         require(_spender != address(0));
214 
215         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 
220     /**
221      * @dev Decrease the amount of tokens that an owner allowed to a spender.
222      *
223      * approve should be called when allowed[_spender] == 0. To decrement
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _subtractedValue The amount of tokens to decrease the allowance by.
229      */
230     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
231         require(_spender != address(0));
232 
233         uint256 oldValue = allowed[msg.sender][_spender];
234         if (_subtractedValue > oldValue) {
235             allowed[msg.sender][_spender] = 0;
236         } else {
237             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240         return true;
241     }
242 
243     /**
244      * @dev Freeze the balance of the specified address
245      * @param _user The address to freeze the balance
246      * @return The boolean status of freezing
247      */
248     function freeze(address _user) public onlyOwner returns (bool) {
249         frozen[_user] = true;
250         emit Freeze(msg.sender, _user, true);
251         return true;
252     }
253 
254     /**
255      * @dev Unfreeze the balance of the specified address
256      * @param _user The address to unfreeze the balance
257      * @return The boolean status of freezing
258      */
259     function unfreeze(address _user) public onlyOwner returns (bool) {
260         frozen[_user] = false;
261         emit Freeze(msg.sender, _user, false);
262         return false;
263     }
264 
265     /**
266      * @dev Gets the freezing status of the specified address.
267      * @param _user The address to query the the balance of.
268      * @return An uint256 representing the amount owned by the passed address.
269      */
270     function freezing(address _user) public view returns (bool) {
271         return frozen[_user];
272     }
273 }
274 
275 
276 interface IKAT {
277   function name() external view returns (string);
278   function symbol() external view returns (string);
279   function decimals() external view returns (uint256);
280 }
281 
282 
283 /**
284  * @title KAT Token
285  * 
286  * @dev Constructor of the deployment
287  */
288 contract KAT is FreezableToken, IKAT {
289   
290   string private _name;
291   string private _symbol;
292   uint256 private _decimals;
293 
294   /**
295    * @dev constructor
296    */
297   constructor() public {
298     _name = "Kambria Token";
299     _symbol = "KAT";
300     _decimals = 18;
301     _totalSupply = 5000000000 * 10 ** _decimals;
302 
303     balances[msg.sender] = _totalSupply; // coinbase
304   }
305 
306   function name() public view returns (string) {
307     return _name;
308   }
309 
310   function symbol() public view returns (string) {
311     return _symbol;
312   }
313 
314   function decimals() public view returns (uint256) {
315     return _decimals;
316   }
317 }