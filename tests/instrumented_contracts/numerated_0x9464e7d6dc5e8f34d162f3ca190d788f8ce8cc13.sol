1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 
64 
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) constant returns (uint256);
68   function transfer(address to, uint256 value) returns (bool);
69   
70   event Transfer(address indexed _from, address indexed _to, uint _value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) returns (bool) {
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of. 
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) constant returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 }
100 
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) constant returns (uint256);
103   function transferFrom(address from, address to, uint256 value) returns (bool);
104   function approve(address spender, uint256 value) returns (bool);
105   
106   event Approval(address indexed _owner, address indexed _spender, uint _value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amout of tokens to be transfered
119    */
120   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
121     var _allowance = allowed[_from][msg.sender];
122 
123     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
124     // require (_value <= _allowance);
125 
126     // KYBER-NOTE! code changed to comply with ERC20 standard
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     //balances[_from] = balances[_from].sub(_value); // this was removed
130     allowed[_from][msg.sender] = _allowance.sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) returns (bool) {
141 
142     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
143 
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifing the amount of tokens still avaible for the spender.
154    */
155   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
156     return allowed[_owner][_spender];
157   }
158 
159 }
160 
161 contract GPower is StandardToken, Ownable {
162     string  public  constant name = "GPower";
163     string  public  constant symbol = "GRP";
164     uint    public  constant decimals = 18;
165     
166      //*** ICO ***//
167     uint icoStart;
168     uint256 icoSaleTotalTokens=400000000;
169     address icoAddress;
170     bool public enableIco=false;
171 
172     //*** Walet ***//
173     address public wallet;
174     
175     //*** TranferCoin ***//
176     bool public transferEnabled = false;
177     bool public stopSale=false;
178     uint256 newCourceSale=0;
179 
180 
181     function GPower() {
182         // Mint all tokens. Then disable minting forever.
183         totalSupply = (500000000*1000000000000000000);
184         balances[msg.sender] = totalSupply;
185 
186         Transfer(address(0x0), msg.sender, totalSupply);
187 
188         transferOwnership(msg.sender);
189     }
190     
191     //*** Transfer Enabled ***//
192     modifier onlyWhenTransferEnabled() {
193         if(transferEnabled){
194           require(true);  
195         }
196         else if(transferEnabled==false && msg.sender==owner){
197              require(true);  
198         }
199         else{
200             require(false);
201         }
202         _;
203     }
204 
205     modifier validDestination( address to ) {
206         require(to != address(0x0));
207         require(to != address(this) );
208         _;
209     }
210 
211     //*** Payable ***//
212     function() payable public {
213         require(msg.value>0);
214         require(msg.sender != 0x0);
215         wallet=owner;
216         
217         if(!stopSale){
218             uint256 weiAmount;
219             uint256 tokens;
220             wallet=owner;
221         
222             wallet=icoAddress;
223             
224                 if((icoStart+(7*24*60*60)) >= now){
225                     weiAmount=4000;
226                 }
227                 else if((icoStart+(14*24*60*60)) >= now){
228                     weiAmount=3750;
229                 }
230                 else if((icoStart+(21*24*60*60)) >= now){
231                     weiAmount=3500;
232                 }
233                 else if((icoStart+(28*24*60*60)) >= now){
234                     weiAmount=3250;
235                 }
236                 else if((icoStart+(35*24*60*60)) >= now){
237                     weiAmount=3000;
238                 }
239                 else{
240                         weiAmount=2000;
241                      }
242         }
243         
244         wallet.transfer(msg.value);
245 
246 	}
247     //*** Transfer ***//
248     function transfer(address _to, uint _value)
249         onlyWhenTransferEnabled
250         validDestination(_to)
251         returns (bool) {
252         return super.transfer(_to, _value);
253     }
254     
255     //*** Transfer From ***//
256     function transferFrom(address _from, address _to, uint _value)
257         onlyWhenTransferEnabled
258         validDestination(_to)
259         returns (bool) {
260         return super.transferFrom(_from, _to, _value);
261     }
262 
263     event Burn(address indexed _burner, uint _value);
264 
265     //*** Burn ***//
266     function burn(uint _value) onlyWhenTransferEnabled
267         returns (bool){
268         balances[msg.sender] = balances[msg.sender].sub(_value);
269         totalSupply = totalSupply.sub(_value);
270         Burn(msg.sender, _value);
271         Transfer(msg.sender, address(0x0), _value);
272         return true;
273     }
274 
275     //*** Burn From ***//
276     function burnFrom(address _from, uint256 _value) onlyWhenTransferEnabled
277         returns (bool) {
278         assert( transferFrom( _from, msg.sender, _value ) );
279         return burn(_value);
280     }
281     
282     //*** EmergencyERC20Drain ***//
283     function emergencyERC20Drain(ERC20 token, uint amount ) onlyOwner {
284         token.transfer( owner, amount );
285     }
286     
287     //*** Set CourceSale ***//
288     function setCourceSale(uint256 value) public onlyOwner{
289         newCourceSale=value;
290     }
291     
292     	//*** Set Params For Sale ***//
293 	function setParamsStopSale(bool _value) public onlyOwner{
294 	    stopSale=_value;
295 	}
296 	
297 	//*** Set ParamsTransfer ***//
298 	function setParamsTransfer(bool _value) public onlyOwner{
299 	    transferEnabled=_value;
300 	}
301 	
302 	//*** Set ParamsICO ***//
303     function setParamsIco(bool _value) public onlyOwner returns(bool result){
304         enableIco=_value;
305         return true;
306     }
307     
308     //*** Set ParamsICO ***//
309     function startIco(uint _value) public onlyOwner returns(bool result){
310         stopSale=false;
311         icoStart=_value;
312         enableIco=true;
313         return true;
314     }
315     
316     //*** Set Params For TotalSupply ***//
317     function setParamsTotalSupply(uint256 value) public onlyOwner{
318         totalSupply=value;
319     }
320 }