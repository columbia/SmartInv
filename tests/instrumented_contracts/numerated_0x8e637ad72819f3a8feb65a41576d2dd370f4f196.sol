1 pragma solidity ^0.4.16;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) constant public returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) constant public returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) constant public returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) constant public returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract Ownable {
29   address public owner;
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     if(msg.sender == owner){
46       _;
47     }
48     else{
49       revert();
50     }
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public{
59     if (newOwner != address(0)) {
60       owner = newOwner;
61     }
62   }
63 
64 }
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) constant public returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) constant public returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances. 
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   /**
89   * @dev transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of. 
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) constant public returns (uint256 balance) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amout of tokens to be transfered
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     var _allowance = allowed[_from][msg.sender];
125 
126     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
127     // require (_value <= _allowance);
128 
129     balances[_to] = balances[_to].add(_value);
130     balances[_from] = balances[_from].sub(_value);
131     allowed[_from][msg.sender] = _allowance.sub(_value);
132     Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141   function approve(address _spender, uint256 _value) public returns (bool) {
142 
143     // To change the approve amount you first have to reduce the addresses`
144     //  allowance to zero by calling `approve(_spender, 0)` if it is not
145     //  already 0 to mitigate the race condition described here:
146     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
148 
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifing the amount of tokens still avaible for the spender.
159    */
160   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164 }
165 
166 
167 contract MintableToken is StandardToken, Ownable {
168   event Mint(address indexed to, uint256 amount);
169   event MintFinished();
170 
171   bool public mintingFinished = false;
172 
173 
174   modifier canMint() {
175     if(!mintingFinished){
176       _;
177     }
178     else{
179       revert();
180     }
181   }
182 
183 
184   /**
185    * @dev Function to mint tokens
186    * @param _to The address that will recieve the minted tokens.
187    * @param _amount The amount of tokens to mint.
188    * @return A boolean that indicates if the operation was successful.
189    */
190   function mint(address _to, uint256 _amount) canMint internal returns (bool) {
191     totalSupply = totalSupply.add(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     Mint(_to, _amount);
194     return true;
195   }
196 
197   /**
198    * @dev Function to stop minting new tokens.
199    * @return True if the operation was successful.
200    */
201   function finishMinting()  internal returns (bool) {
202     mintingFinished = true;
203     MintFinished();
204     return true;
205   }
206 }
207 
208 contract GreenCoin is MintableToken{
209 	
210 	string public constant name = "Green Coin";
211 	string public constant symbol = "GREEN";
212 	uint8 public constant decimals = 18;
213 	uint256 public constant MaxSupply = 10**18*10**6 ;
214 	uint256 public _startTime = 0 ;
215 	
216 	function GreenCoin(){
217 		_startTime = block.timestamp ;
218 		owner = msg.sender;
219 	}
220 	
221 	function GetMaxEther() returns(uint256){
222 		return (MaxSupply.sub(totalSupply)).div(1000);
223 	}
224 	
225 	function IsICOOver() public constant returns(bool){
226 		
227 		if(mintingFinished){
228 			return true;	
229 		}
230 		return false;
231 	}
232 	
233 	function IsICONotStarted() public constant returns(bool){
234 		if(block.timestamp<_startTime){
235 			return true;
236 		}
237 		return false;
238 	}
239 	
240 	function () public payable{
241 		if(IsICOOver() || IsICONotStarted()){
242 			revert();
243 		}
244 		else{
245 			if(GetMaxEther()>msg.value){
246 				mint(msg.sender,msg.value*1000);
247 				owner.transfer(msg.value);
248 			}
249 			else{
250 				mint(msg.sender,GetMaxEther()*1000);
251 				owner.transfer(GetMaxEther());
252 				finishMinting();
253 				
254 			}
255 		}
256 	}
257 }