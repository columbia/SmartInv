1 pragma solidity ^0.4.13;
2 
3 /* Paak Coin
4  * plaak.com 
5  *
6  * @Author Michael Arbach  
7  */
8  
9 
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public constant returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal constant returns (uint256) {
32     /* assert(b > 0); // Solidity automatically throws when dividing by 0 */
33     uint256 c = a / b;
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98 
99     /* SafeMath.sub will throw if there is not enough balance. */
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public constant returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130 
131     uint256 _allowance = allowed[_from][msg.sender];
132 
133     /* Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
134      * require (_value <= _allowance);  
135      */
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = _allowance.sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval (address _spender, uint _addedValue)
177     returns (bool success) {
178     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183   function decreaseApproval (address _spender, uint _subtractedValue)
184     returns (bool success) {
185     uint oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue > oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190     }
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195 }
196 
197 
198 
199 contract Plaak is StandardToken, Ownable {
200     string  public  constant name       = "Plaak Coin";
201     string  public  constant symbol     = "PLK";
202     uint    public  constant decimals   = 18;
203 
204     address public  admin;
205     bool    public  transferEnabled   = true; 
206 
207     function Plaak( uint _tokenTotalAmount ) {
208         /* Mint fixed amount of tokens and disable minting forever. */
209         balances[msg.sender] = _tokenTotalAmount;
210         totalSupply = _tokenTotalAmount;
211         Transfer(address(0x0), msg.sender, _tokenTotalAmount);
212 
213         admin = msg.sender;
214         transferOwnership(admin); 
215     }
216 
217     modifier onlyWhenTransferEnabled() {
218         if( ! transferEnabled   ) {
219             require( msg.sender == admin || msg.sender == owner );
220         }
221         _;
222     }
223 
224     function setTransferEnabled( bool _transferEnabled ) {
225         require( msg.sender == admin );
226         transferEnabled = _transferEnabled; 
227     }
228     
229     function setAdmin(address _admin){
230         require( msg.sender == admin );
231         admin = _admin;
232     }
233 
234     function transfer(address _to, uint _value)
235         onlyWhenTransferEnabled
236         returns (bool) {
237         return super.transfer(_to, _value);
238     }
239 
240     function transferFrom(address _from, address _to, uint _value)
241         onlyWhenTransferEnabled
242         returns (bool) {
243         return super.transferFrom(_from, _to, _value);
244     }
245 
246     event Burn(address indexed _burner, uint _value);
247 
248     function burn(uint _value) onlyWhenTransferEnabled
249         returns (bool){
250         balances[msg.sender] = balances[msg.sender].sub(_value);
251         totalSupply = totalSupply.sub(_value);
252         Burn(msg.sender, _value);
253         Transfer(msg.sender, address(0x0), _value);
254         return true;
255     }
256 
257     function burnFrom(address _from, uint256 _value) 
258         onlyWhenTransferEnabled
259         returns (bool) {
260         assert( transferFrom( _from, msg.sender, _value ) );
261         return burn(_value);
262     }
263 
264 }