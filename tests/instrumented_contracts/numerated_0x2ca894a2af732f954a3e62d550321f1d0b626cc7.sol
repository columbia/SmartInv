1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4  
5  function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SafeMath for uint256;
19 
20   mapping(address => uint256) balances;
21 
22   /**
23   * @dev transfer token for a specified address
24   * @param _to The address to transfer to.
25   * @param _value The amount to be transferred.
26   */
27   function transfer(address _to, uint256 _value) public returns (bool) {
28     require(_to != address(0));
29     require(_value <= balances[msg.sender]);
30 
31     // SafeMath.sub will throw if there is not enough balance.
32     balances[msg.sender] = balances[msg.sender].sub(_value);
33     balances[_to] = balances[_to].add(_value);
34     Transfer(msg.sender, _to, _value);
35     return true;
36   }
37 
38   /**
39   * @dev Gets the balance of the specified address.
40   * @param _owner The address to query the the balance of.
41   * @return An uint256 representing the amount owned by the passed address.
42   */
43   function balanceOf(address _owner) public constant returns (uint256 balance) {
44     return balances[_owner];
45   }
46 
47 }
48 
49 contract StandardToken is ERC20, BasicToken {
50 
51   mapping (address => mapping (address => uint256)) internal allowed;
52 
53 
54   /**
55    * @dev Transfer tokens from one address to another
56    * @param _from address The address which you want to send tokens from
57    * @param _to address The address which you want to transfer to
58    * @param _value uint256 the amount of tokens to be transferred
59    */
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[_from]);
63     require(_value <= allowed[_from][msg.sender]);
64 
65     balances[_from] = balances[_from].sub(_value);
66     balances[_to] = balances[_to].add(_value);
67     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
68     Transfer(_from, _to, _value);
69     return true;
70   }
71 
72   /**
73    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
74    *
75    * Beware that changing an allowance with this method brings the risk that someone may use both the old
76    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
77    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
78    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79    * @param _spender The address which will spend the funds.
80    * @param _value The amount of tokens to be spent.
81    */
82   function approve(address _spender, uint256 _value) public returns (bool) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   /**
89    * @dev Function to check the amount of tokens that an owner allowed to a spender.
90    * @param _owner address The address which owns the funds.
91    * @param _spender address The address which will spend the funds.
92    * @return A uint256 specifying the amount of tokens still available for the spender.
93    */
94   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95     return allowed[_owner][_spender];
96   }
97 
98   /**
99    * approve should be called when allowed[_spender] == 0. To increment
100    * allowed value is better to use this function to avoid 2 calls (and wait until
101    * the first transaction is mined)
102    * From MonolithDAO Token.sol
103    */
104   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   /**
128    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
129    * account.
130    */
131   function Ownable() {
132     owner = msg.sender;
133   }
134 
135 
136   /**
137    * @dev Throws if called by any account other than the owner.
138    */
139   modifier onlyOwner() {
140     require(msg.sender == owner);
141     _;
142   }
143 }
144 
145 
146 contract Whizz is StandardToken,Ownable{
147       
148       
149       string public constant name = "Whizz Coin";
150       string public constant symbol = "WHZ";
151       uint8 public constant decimals = 3; 
152       
153     // 1 Whizzcoin is made up of 1000 Kaalu so 1000 Kaalu = 1 Whizzcoin  
154     
155       uint256 public constant maxTokens = 67500000*1000; 
156       // otherSupply includes 12% tokens for founders, 20% reserve whz, 27.2% supply for bitcoin & bitcoin cash
157       uint256 public constant otherSupply = maxTokens*592/1000;
158       uint256 _initialSupply = otherSupply;
159       uint256 public constant token_price = 600*10**3; 
160       uint public constant ico_start = 1507221000;
161       uint public constant ico_finish = 1514851200; 
162       uint public constant minValue = 1/10*10**18;
163       address public wallet = 0x5F217D83784192d397039Ed6E30e796bFB91B9c4;
164       
165       // pre-ico bonus cap for Ether in Wei
166       
167       uint256 public constant weicap = 13500*10**18;
168       uint256 public weiRaised;
169       
170       
171       
172       using SafeMath for uint;      
173       
174       // Assign other suply to contract creator
175  
176       function Whizz() {
177           balances[owner] = otherSupply;    
178       }
179       
180       // function for buying tokens      
181       function() payable {        
182           tokens_buy();        
183       }
184       
185       
186       function totalSupply() constant returns (uint256 totalSupply) {
187           totalSupply = _initialSupply;
188       }
189    
190       
191             //Withdraw funds from contract balance to secure hardware wallet
192       function withdraw() onlyOwner returns (bool result) {
193           wallet.transfer(this.balance);
194           return true;
195       }
196    
197      
198  
199       // Buy tokens 
200 
201       
202             
203       function tokens_buy() payable returns (bool) { 
204 
205         if((now < ico_start)||(now > ico_finish)) throw;        
206         if(_initialSupply >= maxTokens) throw;
207         if(!(msg.value >= token_price)) throw;
208         if(!(msg.value >= minValue)) throw;
209 
210         uint tokens_buy = ((msg.value*token_price)/10**18);
211         //update amount of raised funds
212         weiRaised = weiRaised.add(msg.value);
213 
214         if(!(tokens_buy > 0)) throw;        
215 
216         uint tnow = now;
217 
218         if((ico_start + 86400*0 <= tnow)&&(tnow <= ico_start + 86400*28)&&(weiRaised <= weicap)){
219           tokens_buy = tokens_buy*120/100;
220         } 
221         
222               
223         if(_initialSupply.add(tokens_buy) > maxTokens) throw;
224         _initialSupply = _initialSupply.add(tokens_buy);
225         balances[msg.sender] = balances[msg.sender].add(tokens_buy);        
226 
227       }
228 
229       
230  }
231  
232 
233 library SafeMath {
234   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
235     uint256 c = a * b;
236     assert(a == 0 || c / a == b);
237     return c;
238   }
239 
240   function div(uint256 a, uint256 b) internal constant returns (uint256) {
241     // assert(b > 0); // Solidity automatically throws when dividing by 0
242     uint256 c = a / b;
243     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244     return c;
245   }
246 
247   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   function add(uint256 a, uint256 b) internal constant returns (uint256) {
253     uint256 c = a + b;
254     assert(c >= a);
255     return c;
256   }
257 }