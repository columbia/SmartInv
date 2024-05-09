1 pragma solidity ^0.4.21;
2 
3 contract ReceivingContract {
4     function onTokenReceived(address _from, uint _value, bytes _data) public;
5 }
6 
7 contract Gate {
8     ERC20Basic private TOKEN;
9     address private PROXY;
10 
11     /// Gates are to be created by the TokenProxy.
12     function Gate(ERC20Basic _token, address _proxy) public {
13         TOKEN = _token;
14         PROXY = _proxy;
15     }
16 
17     /// Transfer requested amount of tokens from Gate to Proxy address.
18     /// Only the Proxy can request this and should request transfer of all
19     /// tokens.
20     function transferToProxy(uint256 _value) public {
21         require(msg.sender == PROXY);
22 
23         require(TOKEN.transfer(PROXY, _value));
24     }
25 }
26 
27 contract ERC20Basic {
28   function totalSupply() public view returns (uint256);
29   function balanceOf(address who) public view returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract BasicToken is ERC20Basic {
35   using SafeMath for uint256;
36 
37   mapping(address => uint256) balances;
38 
39   uint256 totalSupply_;
40 
41   /**
42   * @dev total number of tokens in existence
43   */
44   function totalSupply() public view returns (uint256) {
45     return totalSupply_;
46   }
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of.
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) public view returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 contract BurnableToken is BasicToken {
76 
77   event Burn(address indexed burner, uint256 value);
78 
79   /**
80    * @dev Burns a specific amount of tokens.
81    * @param _value The amount of token to be burned.
82    */
83   function burn(uint256 _value) public {
84     require(_value <= balances[msg.sender]);
85     // no need to require value <= totalSupply, since that would imply the
86     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
87 
88     address burner = msg.sender;
89     balances[burner] = balances[burner].sub(_value);
90     totalSupply_ = totalSupply_.sub(_value);
91     emit Burn(burner, _value);
92     emit Transfer(burner, address(0), _value);
93   }
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     if (a == 0) {
110       return 0;
111     }
112     uint256 c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   /**
118   * @dev Integer division of two numbers, truncating the quotient.
119   */
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return c;
125   }
126 
127   /**
128   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   /**
136   * @dev Adds two numbers, throws on overflow.
137   */
138   function add(uint256 a, uint256 b) internal pure returns (uint256) {
139     uint256 c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }
144 
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    *
171    * Beware that changing an allowance with this method brings the risk that someone may use both the old
172    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
173    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
174    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175    * @param _spender The address which will spend the funds.
176    * @param _value The amount of tokens to be spent.
177    */
178   function approve(address _spender, uint256 _value) public returns (bool) {
179     require(allowed[msg.sender][_spender] == 0);
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222     uint oldValue = allowed[msg.sender][_spender];
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232 }
233 
234 contract TokenProxy is StandardToken, BurnableToken {
235 
236     ERC20Basic public TOKEN;
237 
238     mapping(address => address) private gates;
239 
240 
241     event GateOpened(address indexed gate, address indexed user);
242 
243     event Mint(address indexed to, uint256 amount);
244 
245     function TokenProxy(ERC20Basic _token) public {
246         TOKEN = _token;
247     }
248 
249     function getGateAddress(address _user) external view returns (address) {
250         return gates[_user];
251     }
252 
253     /// Create a new migration Gate for the User.
254     function openGate() external {
255         address user = msg.sender;
256 
257         // Do not allow creating more than one Gate per User.
258         require(gates[user] == 0);
259 
260         // Create new Gate.
261         address gate = new Gate(TOKEN, this);
262 
263         // Remember User - Gate relationship.
264         gates[user] = gate;
265 
266         emit GateOpened(gate, user);
267     }
268 
269     function transferFromGate() external {
270         address user = msg.sender;
271 
272         address gate = gates[user];
273 
274         // Make sure the User's Gate exists.
275         require(gate != 0);
276 
277         uint256 value = TOKEN.balanceOf(gate);
278 
279         Gate(gate).transferToProxy(value);
280 
281         // Handle the information about the amount of migrated tokens.
282         // This is a trusted information becase it comes from the Gate.
283         totalSupply_ += value;
284         balances[user] += value;
285 
286         emit Mint(user, value);
287     }
288 
289     function withdraw(uint256 _value) external {
290         withdrawTo(_value, msg.sender);
291     }
292 
293     function withdrawTo(uint256 _value, address _destination) public {
294         require(_value > 0 && _destination != address(0));
295         burn(_value);
296         TOKEN.transfer(_destination, _value);
297     }
298 }
299 
300 contract GolemNetworkTokenBatching is TokenProxy {
301 
302     string public constant name = "Golem Network Token Batching";
303     string public constant symbol = "GNTB";
304     uint8 public constant decimals = 18;
305 
306 
307     event BatchTransfer(address indexed from, address indexed to, uint256 value,
308         uint64 closureTime);
309 
310     function GolemNetworkTokenBatching(ERC20Basic _gntToken) TokenProxy(_gntToken) public {
311     }
312 
313     function batchTransfer(bytes32[] payments, uint64 closureTime) external {
314         require(block.timestamp >= closureTime);
315 
316         uint balance = balances[msg.sender];
317 
318         for (uint i = 0; i < payments.length; ++i) {
319             // A payment contains compressed data:
320             // first 96 bits (12 bytes) is a value,
321             // following 160 bits (20 bytes) is an address.
322             bytes32 payment = payments[i];
323             address addr = address(payment);
324             require(addr != address(0) && addr != msg.sender);
325             uint v = uint(payment) / 2**160;
326             require(v <= balance);
327             balances[addr] += v;
328             balance -= v;
329             emit BatchTransfer(msg.sender, addr, v, closureTime);
330         }
331 
332         balances[msg.sender] = balance;
333     }
334 
335     function transferAndCall(address to, uint256 value, bytes data) external {
336       // Transfer always returns true so no need to check return value
337       transfer(to, value);
338 
339       // No need to check whether recipient is a contract, this method is
340       // supposed to used only with contract recipients
341       ReceivingContract(to).onTokenReceived(msg.sender, value, data);
342     }
343 }