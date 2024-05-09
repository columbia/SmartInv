1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title NATEE WARRANT 01 ERC20 token
5  *
6  * @dev NATEE WARRANT 01 use for airdrop bonus and other for NATEE Token
7  * User can transfer to NATEE Token by pay at FIX RATE 
8  * if user hold NATEE WARRANT until expride FEE to change will reduce to 0 
9  */
10 
11 library SafeMath256 {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if(a==0 || b==0)
14         return 0;  
15     uint256 c = a * b;
16     require(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b>0);
22     uint256 c = a / b;
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27    require( b<= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     require(c >= a);
34 
35     return c;
36   }
37   
38 }
39 
40 
41 // Only Owner modifier it support a lot owner but finally should have 1 owner
42 contract Ownable {
43 
44   mapping (address=>bool) owners;
45   address owner;
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48   event AddOwner(address newOwner);
49   event RemoveOwner(address owner);
50   /**
51    * @dev Ownable constructor ตั้งค่าบัญชีของ sender ให้เป็น `owner` ดั้งเดิมของ contract 
52    *
53    */
54    constructor() public {
55     owner = msg.sender;
56     owners[msg.sender] = true;
57   }
58 
59   function isContract(address _addr) internal view returns(bool){
60      uint256 length;
61      assembly{
62       length := extcodesize(_addr)
63      }
64      if(length > 0){
65        return true;
66     }
67     else {
68       return false;
69     }
70 
71   }
72 
73  // For Single Owner
74   modifier onlyOwner(){
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   function transferOwnership(address newOwner) public onlyOwner{
81     require(isContract(newOwner) == false);
82     emit OwnershipTransferred(owner,newOwner);
83     owner = newOwner;
84 
85   }
86 
87   //For multiple Owner
88   modifier onlyOwners(){
89     require(owners[msg.sender] == true);
90     _;
91   }
92 
93   function addOwner(address newOwner) public onlyOwners{
94     require(owners[newOwner] == false);
95     require(newOwner != msg.sender);
96 
97     owners[newOwner] = true;
98     emit AddOwner(newOwner);
99   }
100 
101   function removeOwner(address _owner) public onlyOwners{
102     require(_owner != msg.sender);  // can't remove your self
103     owners[_owner] = false;
104     emit RemoveOwner(_owner);
105   }
106 
107   function isOwner(address _owner) public view returns(bool){
108     return owners[_owner];
109   }
110 }
111 
112 contract ERC20 {
113 	     event Transfer(address indexed from, address indexed to, uint256 tokens);
114        event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
115 
116    	   function totalSupply() public view returns (uint256);
117        function balanceOf(address tokenOwner) public view returns (uint256 balance);
118        function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
119 
120        function transfer(address to, uint256 tokens) public returns (bool success);
121        
122        function approve(address spender, uint256 tokens) public returns (bool success);
123        function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
124   
125 
126 }
127 
128 
129 contract StandardERC20 is ERC20{
130   using SafeMath256 for uint256;  
131      
132      mapping (address => uint256) balance;
133      mapping (address => mapping (address=>uint256)) allowed;
134 
135 
136      uint256  totalSupply_;  
137      
138       event Transfer(address indexed from,address indexed to,uint256 value);
139       event Approval(address indexed owner,address indexed spender,uint256 value);
140 
141 
142     function totalSupply() public view returns (uint256){
143       return totalSupply_;
144     }
145 
146      function balanceOf(address _walletAddress) public view returns (uint256){
147         return balance[_walletAddress];
148      }
149 
150 
151      function allowance(address _owner, address _spender) public view returns (uint256){
152           return allowed[_owner][_spender];
153         }
154 
155      function transfer(address _to, uint256 _value) public returns (bool){
156         require(_value <= balance[msg.sender]);
157         require(_to != address(0));
158 
159         balance[msg.sender] = balance[msg.sender].sub(_value);
160         balance[_to] = balance[_to].add(_value);
161         emit Transfer(msg.sender,_to,_value);
162         
163         return true;
164 
165      }
166 
167      function approve(address _spender, uint256 _value)
168             public returns (bool){
169             allowed[msg.sender][_spender] = _value;
170 
171             emit Approval(msg.sender, _spender, _value);
172             return true;
173             }
174 
175       function transferFrom(address _from, address _to, uint256 _value)
176             public returns (bool){
177                require(_value <= balance[_from]);
178                require(_value <= allowed[_from][msg.sender]); 
179                require(_to != address(0));
180 
181               balance[_from] = balance[_from].sub(_value);
182               balance[_to] = balance[_to].add(_value);
183               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184               emit Transfer(_from, _to, _value);
185               return true;
186       }
187 
188 
189      
190 }
191 
192 
193 contract SGDSInterface{
194   function balanceOf(address tokenOwner) public view returns (uint256 balance);
195   function intTransfer(address _from, address _to, uint256 _value) external;
196   function transferWallet(address _from,address _to) external;
197   function getCanControl(address _addr) external view returns(bool); // if true mean user can control by him. false mean Company can control
198   function useSGDS(address useAddr,uint256 value) external returns(bool);
199 }
200 
201 contract NATEE_WARRANT is StandardERC20, Ownable {
202   using SafeMath256 for uint256;
203   string public name = "NATEE WARRANT";
204   string public symbol = "NATEE-W1"; // Real Name NATEE
205   uint256 public decimals = 18;
206   uint256 public INITIAL_SUPPLY = 20000000 ether;
207   uint256 public totalUndist;  // How many warrant that not distributed
208   uint256 public totalRedeem;
209   address public NATEE_CONTRACT = address(0);
210   uint256 public transFee = 100;
211   uint32  public expireDate;
212 
213   SGDSInterface public sgds;
214 
215   event RedeemWarrant(address indexed addr,uint256 _value);
216   event SetControlToken(address indexed addr, bool outControl);
217   event FeeTransfer(address indexed addr,uint256 _value);
218   event TransferWallet(address indexed from,address indexed to,address indexed execute_);
219 
220   mapping(address => bool) userControl;   
221 
222   constructor() public {
223     totalSupply_ = INITIAL_SUPPLY;
224     totalUndist = INITIAL_SUPPLY;
225     expireDate = uint32(now + 1825 days);  // Start 5 Year Expire First
226 
227     sgds = SGDSInterface(0xf7EfaF88B380469084f3018271A49fF743899C89);
228   }
229 
230 
231   function setExpireDate(uint32 newDate) external onlyOwners{
232     if(newDate < expireDate && newDate > uint32(now))
233     {
234         expireDate = newDate;
235     }
236   }
237   function sendWarrant(address _to,uint256 _value) external onlyOwners {
238     require(_value <= totalUndist);
239     balance[_to] += _value;
240     totalUndist -= _value;
241 
242     emit Transfer(address(this),_to,_value);
243   }
244 
245 // This for use seitee transfer . Seitee will pay for gas
246   function intTransfer(address _from, address _to, uint256 _value) external onlyOwners{
247     require(userControl[_from] == false);  // Company can do if they still allow compay to do it
248     require(balance[_from] >= _value);
249     //require(_to != address(0)); // internal Call then can remove this
250         
251     balance[_from] -= _value; 
252     balance[_to] += _value;
253     
254     emit Transfer(_from,_to,_value);
255         
256   }
257 
258   // THIS IS SOS FUNCTION 
259   // For transfer all Warrant Token to new Wallet Address. Want to pay 1 SGDS for fee.
260   
261   function transferWallet(address _from,address _to) external onlyOwners{
262     require(userControl[_from] == false); 
263     require(sgds.getCanControl(_from) == false);
264     require(sgds.balanceOf(_from) >= transFee);
265 
266     uint256  value = balance[_from];
267 
268     balance[_from] = balance[_from].sub(value);
269     balance[_to] = balance[_to].add(value); // sub with FEE
270 
271     sgds.useSGDS(_from,transFee);
272 
273     emit TransferWallet(_from,_to,msg.sender);
274     emit Transfer(_from,_to,value);
275   }
276 
277 // This function will call direct from Natee Contract To deduct Warrant
278   function redeemWarrant(address _from, uint256 _value) external {
279     require(msg.sender == NATEE_CONTRACT);
280     require(balance[_from] >= _value);
281 
282     balance[_from] = balance[_from].sub(_value);
283     totalSupply_ -= _value;
284     totalRedeem += _value;
285 
286     emit Transfer(_from,address(0),_value);
287     emit RedeemWarrant(_from,_value);
288   }
289 
290 // Address Owner can set permision by him self. Set to true will stop company control his/her wallet
291   function setUserControl(bool _control) public {
292     userControl[msg.sender] = _control;
293     emit SetControlToken(msg.sender,_control);
294   }
295 
296   function getUserControl(address _addr) external view returns(bool){
297     return userControl[_addr];
298   }
299 
300 // This function can set 1 time to make sure no one can cheat 
301   function setNateeContract(address addr) onlyOwners external{
302     require(NATEE_CONTRACT == address(0));
303     NATEE_CONTRACT = addr; 
304   }
305 
306   function setTransFee(uint256 _fee) onlyOwners public{
307     transFee = _fee;
308   }
309 
310 }