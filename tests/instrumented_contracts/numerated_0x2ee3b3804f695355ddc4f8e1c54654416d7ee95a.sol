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
70   // NOTE! code changed to comply with ERC20 standard
71   event Transfer(address indexed _from, address indexed _to, uint256 _value);
72   //event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) returns (bool) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of. 
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) constant returns (uint256);
105   function transferFrom(address from, address to, uint256 value) returns (bool);
106   function approve(address spender, uint256 value) returns (bool);
107   
108   // NOTE! code changed to comply with ERC20 standard
109   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
110   //event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 contract StandardToken is ERC20, BasicToken {
114 
115   mapping (address => mapping (address => uint256)) allowed;
116 
117 
118   /**
119    * @dev Transfer tokens from one address to another
120    * @param _from address The address which you want to send tokens from
121    * @param _to address The address which you want to transfer to
122    * @param _value uint256 the amout of tokens to be transfered
123    */
124   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
125     var _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     // NOTE! code changed to comply with ERC20 standard
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     //balances[_from] = balances[_from].sub(_value); // this was removed
134     allowed[_from][msg.sender] = _allowance.sub(_value);
135     Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) returns (bool) {
145 
146     // To change the approve amount you first have to reduce the addresses`
147     //  allowance to zero by calling `approve(_spender, 0)` if it is not
148     //  already 0 to mitigate the race condition described here:
149     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
151 
152     allowed[msg.sender][_spender] = _value;
153     Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifing the amount of tokens still avaible for the spender.
162    */
163   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
164     return allowed[_owner][_spender];
165   }
166 
167 }
168 
169 contract Blocform is StandardToken, Ownable {
170     string  public  constant name = "Blocform Global";
171     string  public  constant symbol = "BFG";
172     uint    public  constant decimals = 8;
173 
174 
175     address public  tokenSaleContract;
176 
177 
178     modifier validDestination( address to ) {
179         require(to != address(0x0));
180         require(to != address(this) );
181         _;
182     }
183 
184     function Blocform(  address admin ) {
185         // Mint all tokens. Then disable minting forever.
186         uint256 tokenTotalAmount = 200000000000000000;
187         balances[msg.sender] = tokenTotalAmount;
188         totalSupply = tokenTotalAmount;
189         Transfer(address(0x0), msg.sender, tokenTotalAmount);
190 
191 
192         tokenSaleContract = msg.sender;
193         transferOwnership(admin); // admin could drain tokens that were sent here by mistake
194     }
195 
196     function transfer(address _to, uint256 _value)
197         
198         validDestination(_to)
199         returns (bool) {
200         return super.transfer(_to, _value);
201     }
202 
203     function transferFrom(address _from, address _to, uint256 _value)
204         validDestination(_to)
205         returns (bool) {
206         return super.transferFrom(_from, _to, _value);
207     }
208 
209     event Burn(address indexed _burner, uint256 _value);
210     
211     function burn(uint256 _value) 
212         returns (bool){
213         balances[msg.sender] = balances[msg.sender].sub(_value);
214         totalSupply = totalSupply.sub(_value);
215         Burn(msg.sender, _value);
216         Transfer(msg.sender, address(0x0), _value);
217         return true;
218     }
219 
220     // save some gas by making only one contract call
221     function burnFrom(address _from, uint256 _value) 
222         returns (bool) {
223         assert( transferFrom( _from, msg.sender, _value ) );
224         return burn(_value);
225     }
226 
227     function emergencyERC20Drain( ERC20 token, uint256 amount ) onlyOwner {
228         token.transfer( owner, amount );
229     }
230 }