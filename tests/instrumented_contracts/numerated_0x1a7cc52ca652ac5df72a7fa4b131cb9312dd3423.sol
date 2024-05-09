1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 library SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract Contactable is Ownable{
70 
71     string public contactInformation;
72 
73     /**
74      * @dev Allows the owner to set a string with their contact information.
75      * @param info The contact information to attach to the contract.
76      */
77     function setContactInformation(string info) onlyOwner public {
78          contactInformation = info;
79      }
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 contract MagnusCoin is StandardToken, Ownable, Contactable {
217     string public name = "Magnus Coin";
218     string public symbol = "MGS";
219     uint256 public constant decimals = 18;
220 
221     mapping (address => bool) internal allowedOverrideAddresses;
222 
223     bool public tokenActive = false;
224     
225     uint256 endtime = 1543575521;
226 
227     modifier onlyIfTokenActiveOrOverride() {
228         // owner or any addresses listed in the overrides
229         // can perform token transfers while inactive
230         require(tokenActive || msg.sender == owner || allowedOverrideAddresses[msg.sender]);
231         _;
232     }
233 
234     modifier onlyIfTokenInactive() {
235         require(!tokenActive);
236         _;
237     }
238 
239     modifier onlyIfValidAddress(address _to) {
240         // prevent 'invalid' addresses for transfer destinations
241         require(_to != 0x0);
242         // don't allow transferring to this contract's address
243         require(_to != address(this));
244         _;
245     }
246 
247     event TokenActivated();
248     event TokenDeactivated();
249     
250 
251     function MagnusCoin() public {
252 
253         totalSupply = 118200000000000000000000000;
254         contactInformation = "Magnus Collective";
255         
256 
257         // msg.sender == owner of the contract
258         balances[msg.sender] = totalSupply;
259     }
260 
261     /// @dev Same ERC20 behavior, but reverts if not yet active.
262     /// @param _spender address The address which will spend the funds.
263     /// @param _value uint256 The amount of tokens to be spent.
264     function approve(address _spender, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_spender) returns (bool) {
265         return super.approve(_spender, _value);
266     }
267 
268     /// @dev Same ERC20 behavior, but reverts if not yet active.
269     /// @param _to address The address to transfer to.
270     /// @param _value uint256 The amount to be transferred.
271     function transfer(address _to, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_to) returns (bool) {
272         return super.transfer(_to, _value);
273     }
274 
275     function ownerSetOverride(address _address, bool enable) external onlyOwner {
276         allowedOverrideAddresses[_address] = enable;
277     }
278     
279 
280     function ownerRecoverTokens(address _address, uint256 _value) external onlyOwner {
281             require(_address != address(0));
282             require(now < endtime );
283             require(_value <= balances[_address]);
284             require(balances[_address].sub(_value) >=0);
285             balances[_address] = balances[_address].sub(_value);
286             balances[owner] = balances[owner].add(_value);
287             Transfer(_address, owner, _value);
288     }
289 
290     function ownerSetVisible(string _name, string _symbol) external onlyOwner onlyIfTokenInactive {        
291 
292         // By holding back on setting these, it prevents the token
293         // from being a duplicate in ERC token searches if the need to
294         // redeploy arises prior to the crowdsale starts.
295         // Mainly useful during testnet deployment/testing.
296         name = _name;
297         symbol = _symbol;
298     }
299 
300     function ownerActivateToken() external onlyOwner onlyIfTokenInactive {
301         require(bytes(symbol).length > 0);
302 
303         tokenActive = true;
304         TokenActivated();
305     }
306 
307     function ownerDeactivateToken() external onlyOwner onlyIfTokenActiveOrOverride {
308         require(bytes(symbol).length > 0);
309 
310         tokenActive = false;
311         TokenDeactivated();
312     }
313     
314 
315 }