1 //New Energy Era token
2 //Copyright 2016
3 
4 pragma solidity ^0.4.16;
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner {
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 
66 
67 
68 contract ERC20Basic {
69   uint256 public totalSupply;
70   function balanceOf(address who) constant returns (uint256);
71   function transfer(address to, uint256 value) returns (bool);
72   
73 
74   event Transfer(address indexed _from, address indexed _to, uint _value);
75 
76 }
77 
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) returns (bool) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of. 
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 contract ERC20 is ERC20Basic {
107   function allowance(address owner, address spender) constant returns (uint256);
108   function transferFrom(address from, address to, uint256 value) returns (bool);
109   function approve(address spender, uint256 value) returns (bool);
110   
111   event Approval(address indexed _owner, address indexed _spender, uint _value);
112 
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amout of tokens to be transfered
125    */
126   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
127     var _allowance = allowed[_from][msg.sender];
128 
129     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
130     // require (_value <= _allowance);
131 
132     //code changed to comply with ERC20 standard
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     //balances[_from] = balances[_from].sub(_value); // this was removed
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * @param _spender The address which will spend the funds.
144    * @param _value The amount of tokens to be spent.
145    */
146   function approve(address _spender, uint256 _value) returns (bool) {
147 
148     // To change the approve amount you first have to reduce the addresses`
149     //  allowance to zero by calling `approve(_spender, 0)` if it is not
150     //  already 0 to mitigate the race condition described here:
151     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
153 
154     allowed[msg.sender][_spender] = _value;
155     Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Function to check the amount of tokens that an owner allowed to a spender.
161    * @param _owner address The address which owns the funds.
162    * @param _spender address The address which will spend the funds.
163    * @return A uint256 specifing the amount of tokens still avaible for the spender.
164    */
165   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169 }
170 
171 contract NeeToken is StandardToken, Ownable {
172     string  public  constant name = "New Energy Era Token";
173     string  public  constant symbol = "NEE";
174     uint    public  constant decimals = 18;
175     uint    public  constant INITIAL_SUPPLY = 1000000000000000000000000000;
176     address public  crowdsaleContract;
177     bool    public  transferEnabled;
178     
179 
180      modifier onlyWhenTransferEnabled() {
181      if(msg.sender != crowdsaleContract) {
182      require(transferEnabled);
183      }
184     _;
185      
186     }
187     
188     function NeeToken() {
189     
190         balances[msg.sender] = INITIAL_SUPPLY; 
191         transferEnabled = true;
192         totalSupply = INITIAL_SUPPLY;
193         crowdsaleContract = msg.sender; //initial by setting crowdsalecontract location to owner
194         Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
195         }
196     
197     function setupCrowdsale(address _contract, bool _transferAllowed) onlyOwner {
198         crowdsaleContract = _contract;
199         transferEnabled = _transferAllowed;
200     }
201     function transfer(address _to, uint _value)
202         onlyWhenTransferEnabled()
203         returns (bool) {
204         return super.transfer(_to, _value);
205         }
206     
207     function transferFrom(address _from, address _to, uint _value) 
208         onlyWhenTransferEnabled()
209         returns (bool) {
210         return super.transferFrom(_from, _to, _value);
211         }
212    
213     
214     event Burn(address indexed _burner, uint _value);
215 
216     function burn(uint _value) 
217         onlyWhenTransferEnabled()
218         returns (bool){
219         balances[msg.sender] = balances[msg.sender].sub(_value);
220         totalSupply = totalSupply.sub(_value);
221         Burn(msg.sender, _value);
222         Transfer(msg.sender, address(0x0), _value);
223         return true;
224     }
225 
226     // save some gas by making only one contract call
227     function burnFrom(address _from, uint256 _value) 
228         onlyWhenTransferEnabled()
229         returns (bool) {
230         assert( transferFrom( _from, msg.sender, _value ) );
231         return burn(_value);
232     }
233 
234     function emergencyERC20Drain(ERC20 token, uint amount ) onlyOwner {
235         token.transfer( owner, amount );
236     }
237     
238     function ChangeTransferStatus() onlyOwner {
239             if(transferEnabled == false){
240             transferEnabled = true;
241         } else{
242             transferEnabled = false;
243         }
244     }
245 }