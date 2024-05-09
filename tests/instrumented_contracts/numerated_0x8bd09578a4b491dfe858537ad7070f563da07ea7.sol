1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Burn(address indexed from, uint256 value);
40 }
41 
42 
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) constant returns (uint256);
45   function transferFrom(address from, address to, uint256 value);
46   function approve(address spender, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) {
62       
63     require ( balances[msg.sender] >= _value);           // Check if the sender has enough
64     require (balances[_to] + _value >= balances[_to]);   // Check for overflows
65 
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69   }
70   
71   // burn tokens from sender balance
72   function burn(uint256 _value) {
73       
74     require ( balances[msg.sender] >= _value);           // Check if the sender has enough
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     totalSupply = totalSupply.sub(_value);
77     
78     Burn(msg.sender, _value);
79   }
80   
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) constant returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 
94 contract StandardToken is ERC20, BasicToken {
95 
96   mapping (address => mapping (address => uint256)) allowed;
97 
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amout of tokens to be transfered
104    */
105   function transferFrom(address _from, address _to, uint256 _value) {
106     var _allowance = allowed[_from][msg.sender];
107 
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // if (_value > _allowance) throw;
110 
111     balances[_to] = balances[_to].add(_value);
112     balances[_from] = balances[_from].sub(_value);
113     allowed[_from][msg.sender] = _allowance.sub(_value);
114     Transfer(_from, _to, _value);
115   }
116 
117   /**
118    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    * @param _spender The address which will spend the funds.
120    * @param _value The amount of tokens to be spent.
121    */
122   function approve(address _spender, uint256 _value) {
123 
124     // To change the approve amount you first have to reduce the addresses`
125     //  allowance to zero by calling `approve(_spender, 0)` if it is not
126     //  already 0 to mitigate the race condition described here:
127     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128     require((_value != 0) && (allowed[msg.sender][_spender] == 0)) ;
129 
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param _owner address The address which owns the funds.
137    * @param _spender address The address which will spend the funds.
138    * @return A uint256 specifing the amount of tokens still avaible for the spender.
139    */
140   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
141     return allowed[_owner][_spender];
142   }
143 
144 }
145 
146 contract Ownable {
147   address public owner;
148 
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   function Ownable() {
155     owner = msg.sender;
156   }
157 
158 
159   /**
160    * @dev Throws if called by any account other than the owner.
161    */
162   modifier onlyOwner() {
163     require(msg.sender == owner) ;
164     
165     _;
166   }
167 
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) onlyOwner {
174     if (newOwner != address(0)) {
175       owner = newOwner;
176     }
177   }
178 
179 }
180 
181 contract EbocoinToken is StandardToken, Ownable {
182   event Mint(address indexed to, uint256 amount);
183   event MintFinished();
184   string public name = "EBO coin Token";
185   string public symbol = "EBT";
186   uint256 public decimals = 6;
187 
188   bool public mintingFinished = false;
189 
190 
191   modifier canMint() {
192     require(!mintingFinished) ;
193     _;
194   }
195 
196   function EbocoinToken(){
197     mint(msg.sender,10000000000000000000000000);
198     finishMinting();
199   }
200     
201   /**
202    * @dev Function to mint tokens
203    * @param _to The address that will recieve the minted tokens.
204    * @param _amount The amount of tokens to mint.
205    * @return A boolean that indicates if the operation was successful.
206    */
207   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
208     totalSupply = totalSupply.add(_amount);
209     balances[_to] = balances[_to].add(_amount);
210     Mint(_to, _amount);
211     return true;
212   }
213   
214 
215   /**
216    * @dev Function to stop minting new tokens.
217    * @return True if the operation was successful.
218    */
219   function finishMinting() onlyOwner returns (bool) {
220     mintingFinished = true;
221     MintFinished();
222     return true;
223   }
224 }