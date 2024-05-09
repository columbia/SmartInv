1 pragma solidity ^0.4.12;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title ERC20Basic
78  * @dev Simpler version of ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/179
80  */
81 contract ERC20Basic {
82   uint256 public totalSupply;
83   function balanceOf(address who) public constant returns (uint256);
84   function transfer(address to, uint256 value) public returns (bool);
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 }
87 
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances.
92  */
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public constant returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155 
156     uint256 _allowance = allowed[_from][msg.sender];
157 
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // require (_value <= _allowance);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
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
179     allowed[msg.sender][_spender] = _value;
180     Approval(msg.sender, _spender, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param _owner address The address which owns the funds.
187    * @param _spender address The address which will spend the funds.
188    * @return A uint256 specifying the amount of tokens still available for the spender.
189    */
190   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194    
195 }
196 
197 
198  
199 
200 contract BingoToken is StandardToken, Ownable {
201  
202     string public constant name = "BINGO TOKEN"; 
203     string public constant symbol = "BGT"; 
204     uint public constant decimals = 18;  
205     uint256 public constant initialSupply = 300000000 * (10 ** uint256(decimals)); 
206     
207     uint256 public startAt;
208     uint256 public priceInWei ;
209     
210 
211     // Constructor
212     function BingoToken(uint256 startat, uint256 priceinWei) {
213         
214         totalSupply = initialSupply;
215         balances[msg.sender] = initialSupply; // Send all tokens to owner
216         startAt = startat;
217         priceInWei=priceinWei;
218     }
219     
220     
221     function() payable{
222         
223         buy();
224     }
225     
226     function buy()  payable returns(bool){
227         
228         require(now > startAt && now <=startAt + 45 days);
229        
230         
231         uint256 weiAmount = msg.value;
232         
233         uint256 tokenAmount = weiAmount.mul(priceInWei).div(10 ** uint256(decimals));   
234         
235         
236        
237         if(now > startAt && now <= startAt + 10 days){
238             
239             balances[owner] = balances[owner].sub(tokenAmount.mul(2));
240             
241             balances[msg.sender] = balances[msg.sender].add(tokenAmount.mul(2));
242             
243             owner.transfer(weiAmount);
244     
245             Transfer(owner, msg.sender, tokenAmount.mul(2));
246             
247         }else if(now > startAt + 10 days && now <= startAt+ 20 days){
248             
249             tokenAmount =tokenAmount + tokenAmount.mul(3).div(4);
250             
251             balances[owner] = balances[owner].sub(tokenAmount);
252             
253             balances[msg.sender] = balances[msg.sender].add(tokenAmount);
254             
255             owner.transfer(weiAmount);
256             
257             Transfer(owner, msg.sender, tokenAmount);
258     
259         }else if(now > startAt + 20 days && now <= startAt+ 30 days){
260             
261             tokenAmount = tokenAmount + tokenAmount.div(2);
262             
263             balances[owner] = balances[owner].sub(tokenAmount);
264             
265             balances[msg.sender] = balances[msg.sender].add(tokenAmount);
266             
267             owner.transfer(weiAmount);
268         
269             Transfer(owner, msg.sender, tokenAmount);
270             
271         }else if(now > startAt + 30 days && now <= startAt + 40 days){
272             
273             tokenAmount = tokenAmount + tokenAmount.div(4);
274              
275             balances[owner] = balances[owner].sub(tokenAmount);
276             
277             balances[msg.sender] = balances[msg.sender].add(tokenAmount);
278             
279             owner.transfer(weiAmount);
280             
281             Transfer(owner, msg.sender, tokenAmount);
282             
283         }else if(now > startAt + 40 days && now <= startAt+ 45 days){
284            
285               
286             balances[owner] = balances[owner].sub(tokenAmount);
287             
288             balances[msg.sender] = balances[msg.sender].add(tokenAmount);
289             
290             owner.transfer(weiAmount);
291     
292             Transfer(owner, msg.sender, tokenAmount);
293             
294         } 
295         
296         return true;
297         
298     }
299     
300     function allocate(address addr, uint256 amount) onlyOwner returns(bool){
301         
302         require(addr != address(0));
303         
304         transfer(addr, amount);
305         
306         return true;
307     }
308     
309     
310      
311     
312     
313     
314 }