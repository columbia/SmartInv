1 pragma solidity ^0.4.18;
2  
3 //Never Mind :P
4 /* @dev The Ownable contract has an owner address, and provides basic authorization control
5 * functions, this simplifies the implementation of "user permissions".
6 */
7 contract Ownable {
8   address public owner;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 
41 
42 
43 
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   /**
69   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 
87 
88 contract NVTReceiver {
89     function NVTFallback(address _from, uint _value, uint _code);
90 }
91 
92 contract BasicToken {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint256 totalSupply_;
98 
99   /**
100   * @dev total number of tokens in existence
101   */
102   function totalSupply() public view returns (uint256) {
103     return totalSupply_;
104   }
105 
106   event Transfer(address indexed from, address indexed to, uint256 value);
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115     
116     // SafeMath.sub will throw if there is not enough balance.
117     if(!isContract(_to)){
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     Transfer(msg.sender, _to, _value);
121     return true;}
122     else{
123         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
124     balances[_to] = balanceOf(_to).add(_value);
125     NVTReceiver receiver = NVTReceiver(_to);
126     receiver.NVTFallback(msg.sender, _value, 0);
127     Transfer(msg.sender, _to, _value);
128         return true;
129     }
130     
131   }
132   function transfer(address _to, uint _value, uint _code) public returns (bool) {
133       require(isContract(_to));
134       require(_value <= balances[msg.sender]);
135       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
136       balances[_to] = balanceOf(_to).add(_value);
137       NVTReceiver receiver = NVTReceiver(_to);
138       receiver.NVTFallback(msg.sender, _value, _code);
139       Transfer(msg.sender, _to, _value);
140     
141       return true;
142     
143     }
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public view returns (uint256 balance) {
150     return balances[_owner];
151   }
152 
153 
154 function isContract(address _addr) private returns (bool is_contract) {
155     uint length;
156     assembly {
157         //retrieve the size of the code on target address, this needs assembly
158         length := extcodesize(_addr)
159     }
160     return (length>0);
161   }
162 
163 
164   //function that is called when transaction target is a contract
165   //Only used for recycling NVTs
166   function transferToContract(address _to, uint _value, uint _code) public returns (bool success) {
167     require(isContract(_to));
168     require(_value <= balances[msg.sender]);
169   
170       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
171     balances[_to] = balanceOf(_to).add(_value);
172     NVTReceiver receiver = NVTReceiver(_to);
173     receiver.NVTFallback(msg.sender, _value, _code);
174     Transfer(msg.sender, _to, _value);
175     
176     return true;
177   }
178 }
179 
180 
181 
182 
183 
184 
185 contract NVT is BasicToken, Ownable {
186 
187   string public constant name = "NiceVotingToken";
188   string public constant symbol = "NVT";
189   uint8 public constant decimals = 2;
190 
191   uint256 public constant TOTAL_SUPPLY = 100 * 10 ** 10; //10 billion tokens
192   uint256 public RELEASE_TIME ;
193   uint256 public TOKEN_FOR_SALE = 40 * 10 ** 10;
194   uint256 public TOKEN_FOR_TEAM = 10 * 10 ** 10;
195   uint256 public TOKEN_FOR_COMUNITY = 20 * 10 ** 10;
196   uint256 public TOKEN_FOR_INVESTER = 25 * 10 ** 10;
197 
198 
199   uint256 public price = 10 ** 12; //1:10000
200   bool public halted = false;
201 
202   /**
203   * @dev Constructor that gives msg.sender all of existing tokens.
204   */
205   function NVT() public {
206     totalSupply_ = 5 * 10 ** 10; // 5 percent for early market promotion
207     balances[msg.sender] = 5 * 10 ** 10;
208     Transfer(0x0, msg.sender, 5 * 10 ** 10);
209     RELEASE_TIME = now;
210   }
211 
212   //Rember 18 zeros for decimals of eth(wei), and 2 zeros for NVT. So add 16 zeros with * 10 ** 16
213   //price can only go higher
214   function setPrice(uint _newprice) onlyOwner{
215     require(_newprice > price);
216     price=_newprice; 
217   }
218 
219   //Incoming payment for purchase
220   function () public payable{
221     require(halted == false);
222     uint amout = msg.value.div(price);
223     require(amout <= TOKEN_FOR_SALE);
224     TOKEN_FOR_SALE = TOKEN_FOR_SALE.sub(amout);
225     balances[msg.sender] = balanceOf(msg.sender).add(amout);
226     totalSupply_=totalSupply_.add(amout);
227     Transfer(0x0, msg.sender, amout);
228   }
229 
230   function getTokenForTeam (address _to, uint _amout) onlyOwner returns(bool){
231     TOKEN_FOR_TEAM = TOKEN_FOR_TEAM.sub(_amout);
232     totalSupply_=totalSupply_.add(_amout);
233     balances[_to] = balanceOf(_to).add(_amout);
234     Transfer(0x0, _to, _amout);
235     return true;
236   }
237 
238 
239   function getTokenForInvester (address _to, uint _amout) onlyOwner returns(bool){
240     TOKEN_FOR_INVESTER = TOKEN_FOR_INVESTER.sub(_amout);
241     totalSupply_=totalSupply_.add(_amout);
242     balances[_to] = balanceOf(_to).add(_amout);
243     Transfer(0x0, _to, _amout);
244     return true;
245   }
246 
247 
248   function getTokenForCommunity (address _to, uint _amout) onlyOwner{
249     require(_amout <= TOKEN_FOR_COMUNITY);
250     TOKEN_FOR_COMUNITY = TOKEN_FOR_COMUNITY.sub(_amout);
251     totalSupply_=totalSupply_.add(_amout);
252     balances[_to] = balanceOf(_to).add(_amout);
253     Transfer(0x0, _to, _amout);
254   }
255   
256 
257   function getFunding (address _to, uint _amout) onlyOwner{
258     _to.transfer(_amout);
259   }
260 
261 
262   function getAllFunding() onlyOwner{
263     owner.transfer(this.balance);
264   }
265 
266 
267   /* stop ICO*/
268   function halt() onlyOwner{
269     halted = true;
270   }
271   function unhalt() onlyOwner{
272     halted = false;
273   }
274 
275 
276 
277 }