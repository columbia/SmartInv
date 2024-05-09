1 pragma solidity ^0.4.22;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 
92 contract HoldersList is Ownable{
93    uint256 public _totalTokens;
94    
95    struct TokenHolder {
96         uint256 balance;
97         uint       regTime;
98         bool isValue;
99     }
100     
101     mapping(address => TokenHolder) holders;
102     address[] public payees;
103     
104     function changeBalance(address _who, uint _amount)  public onlyOwner {
105         
106             holders[_who].balance = _amount;
107             if (notInArray(_who)){
108                 payees.push(_who);
109                 holders[_who].regTime = now;
110                 holders[_who].isValue = true;
111             }
112             
113         //}
114     }
115     function notInArray(address _who) internal view returns (bool) {
116         if (holders[_who].isValue) {
117             return false;
118         }
119         return true;
120     }
121     
122   /**
123    * @dev Defines number of issued tokens. 
124    */
125   
126     function setTotal(uint _amount) public onlyOwner {
127       _totalTokens = _amount;
128   }
129   
130   /**
131    * @dev Returnes number of issued tokens.
132    */
133   
134    function getTotal() public constant returns (uint)  {
135      return  _totalTokens;
136   }
137   
138   /**
139    * @dev Returnes holders balance.
140    
141    */
142   function returnBalance (address _who) public constant returns (uint){
143       uint _balance;
144       
145       _balance= holders[_who].balance;
146       return _balance;
147   }
148   
149   
150   /**
151    * @dev Returnes number of holders in array.
152    
153    */
154   function returnPayees () public constant returns (uint){
155       uint _ammount;
156       
157       _ammount= payees.length;
158       return _ammount;
159   }
160   
161   
162   /**
163    * @dev Returnes holders address.
164    
165    */
166   function returnHolder (uint _num) public constant returns (address){
167       address _addr;
168       
169       _addr= payees[_num];
170       return _addr;
171   }
172   
173   /**
174    * @dev Returnes registration date of holder.
175    
176    */
177   function returnRegDate (address _who) public constant returns (uint){
178       uint _redData;
179       
180       _redData= holders[_who].regTime;
181       return _redData;
182   }
183     
184 }
185 
186 
187 
188 contract Dividend is Ownable   {
189   using SafeMath for uint256;  
190   //address multisig;
191   uint _totalDivid=0;
192   uint _newDivid=0;
193   uint public _totalTokens;
194   uint pointMultiplier = 10e18;
195   HoldersList list;
196   bool public PaymentFinished = false;
197   
198  
199   
200  
201  address[] payees;
202  
203  struct ETHHolder {
204         uint256 balance;
205         uint       balanceUpdateTime;
206         uint       rewardWithdrawTime;
207  }
208  mapping(address => ETHHolder) eholders;
209  
210    function returnMyEthBalance (address _who) public constant returns (uint){
211       //require(msg.sender == _who);
212       uint _eBalance;
213       
214       _eBalance= eholders[_who].balance;
215       return _eBalance;
216   }
217   
218   
219   function returnTotalDividend () public constant returns (uint){
220       return _totalDivid;
221   }
222   
223   
224   function changeEthBalance(address _who, uint256 _amount) internal {
225     //require(_who != address(0));
226     //require(_amount > 0);
227     eholders[_who].balanceUpdateTime = now;
228     eholders[_who].balance += _amount;
229 
230   }
231   
232    /**
233    * @dev Allows the owner to set the List of token holders.
234    * @param _holdersList the List address
235    */
236   function setHoldersList(address _holdersList) public onlyOwner {
237     list = HoldersList(_holdersList);
238   }
239   
240   
241   function Withdraw() public returns (bool){
242     uint _eBalance;
243     address _who;
244     _who = msg.sender;
245     _eBalance= eholders[_who].balance;
246     require(_eBalance>0);
247     eholders[_who].balance = 0;
248     eholders[_who].rewardWithdrawTime = now;
249     _who.transfer(_eBalance);
250     return true;
251     
252    
253   }
254   
255   /**
256    * @dev Function to stop payments.
257    * @return True if the operation was successful.
258    */
259   function finishDividend() onlyOwner public returns (bool) {
260     PaymentFinished = true;
261     return true;
262   }
263   
264   function() external payable {
265      
266      require(PaymentFinished==false);
267      
268      _newDivid= msg.value;
269      _totalDivid += _newDivid;
270      
271      uint _myTokenBalance=0;
272      uint _myRegTime;
273      uint _myEthShare=0;
274      //uint _myTokenPer=0;
275      uint256 _length;
276      address _addr;
277      
278      _length=list.returnPayees();
279      _totalTokens=list.getTotal();
280      
281      for (uint256 i = 0; i < _length; i++) {
282         _addr =list.returnHolder(i);
283         _myTokenBalance=list.returnBalance(_addr);
284         _myRegTime=list.returnRegDate(_addr);
285         _myEthShare=_myTokenBalance.mul(_newDivid).div(_totalTokens);
286           changeEthBalance(_addr, _myEthShare);
287         }
288     
289   }
290  
291 }