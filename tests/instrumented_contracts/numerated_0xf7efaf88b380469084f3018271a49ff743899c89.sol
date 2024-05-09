1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SGDS ERC20 token
5  *
6  * @dev SGDS are stable coin from SEITEE Pte Ltd use only to compare
7  *  1 - 1 with SGD Dollar
8  *  it for use only internal in NATEE Service and other service from Seitee in future;
9  *  This stable coin are unlimit but can user a lot of crypto to buy it with exchange late FROM Seitee Only
10  *  SGDS are control by SEITEE Pte,Ltd. Please understand before purchase it
11  */
12 
13 library SafeMath256 {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if(a==0 || b==0)
16         return 0;  
17     uint256 c = a * b;
18     require(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     require(b>0);
24     uint256 c = a / b;
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29    require( b<= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     require(c >= a);
36 
37     return c;
38   }
39   
40 }
41 
42 
43 // Only Owner modifier it support a lot owner but finally should have 1 owner
44 contract Ownable {
45 
46   mapping (address=>bool) owners;
47   address owner;
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50   event AddOwner(address newOwner);
51   event RemoveOwner(address owner);
52 
53    constructor() public {
54     owner = msg.sender;
55     owners[msg.sender] = true;
56   }
57 
58   function isContract(address _addr) internal view returns(bool){
59      uint256 length;
60      assembly{
61       length := extcodesize(_addr)
62      }
63      if(length > 0){
64        return true;
65     }
66     else {
67       return false;
68     }
69 
70   }
71 
72  // For Single Owner
73   modifier onlyOwner(){
74     require(msg.sender == owner);
75     _;
76   }
77 
78 
79   function transferOwnership(address newOwner) public onlyOwner{
80     require(isContract(newOwner) == false); 
81     emit OwnershipTransferred(owner,newOwner);
82     owner = newOwner;
83 
84   }
85 
86   //For multiple Owner
87   modifier onlyOwners(){
88     require(owners[msg.sender] == true);
89     _;
90   }
91 
92   function addOwner(address newOwner) public onlyOwners{
93     require(owners[newOwner] == false);
94     require(newOwner != msg.sender);
95 
96     owners[newOwner] = true;
97     emit AddOwner(newOwner);
98   }
99 
100   function removeOwner(address _owner) public onlyOwners{
101     require(_owner != msg.sender);  // can't remove your self
102     owners[_owner] = false;
103     emit RemoveOwner(_owner);
104   }
105 
106   function isOwner(address _owner) public view returns(bool){
107     return owners[_owner];
108   }
109 }
110 
111 contract ERC20 {
112        event Transfer(address indexed from, address indexed to, uint256 tokens);
113        event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
114 
115        function totalSupply() public view returns (uint256);
116        function balanceOf(address tokenOwner) public view returns (uint256 balance);
117        function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
118 
119        function transfer(address to, uint256 tokens) public returns (bool success);
120        
121        function approve(address spender, uint256 tokens) public returns (bool success);
122        function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
123   
124 
125 }
126 
127 
128 contract StandarERC20 is ERC20{
129   using SafeMath256 for uint256; 
130      
131      mapping (address => uint256) balance;
132      mapping (address => mapping (address=>uint256)) allowed;
133 
134 
135      uint256  totalSupply_; 
136      
137       event Transfer(address indexed from,address indexed to,uint256 value);
138       event Approval(address indexed owner,address indexed spender,uint256 value);
139 
140 
141     function totalSupply() public view returns (uint256){
142       return totalSupply_;
143     }
144 
145      function balanceOf(address _walletAddress) public view returns (uint256){
146         return balance[_walletAddress]; 
147      }
148 
149 
150      function allowance(address _owner, address _spender) public view returns (uint256){
151           return allowed[_owner][_spender];
152         }
153 
154      function transfer(address _to, uint256 _value) public returns (bool){
155         require(_value <= balance[msg.sender]);
156         require(_to != address(0));
157 
158         balance[msg.sender] = balance[msg.sender].sub(_value);
159         balance[_to] = balance[_to].add(_value);
160         emit Transfer(msg.sender,_to,_value);
161         
162         return true;
163 
164      }
165 
166      function approve(address _spender, uint256 _value)
167             public returns (bool){
168             allowed[msg.sender][_spender] = _value;
169 
170             emit Approval(msg.sender, _spender, _value);
171             return true;
172             }
173 
174       function transferFrom(address _from, address _to, uint256 _value)
175             public returns (bool){
176                require(_value <= balance[_from]);
177                require(_value <= allowed[_from][msg.sender]); 
178                require(_to != address(0));
179 
180               balance[_from] = balance[_from].sub(_value);
181               balance[_to] = balance[_to].add(_value);
182               allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183               emit Transfer(_from, _to, _value);
184               return true;
185       }
186 
187 
188      
189 }
190 
191 
192 contract SGDS is StandarERC20, Ownable {
193   using SafeMath256 for uint256;
194   string public name = "SEITEE SGD";
195   string public symbol = "SGDS"; 
196   uint256 public decimals = 2;
197   uint256 public totalUsed;
198   uint256 public totalPurchange;
199   uint256 public transFee = 100; // default transection fee = 1.00 SGDS
200   uint256 public version = 10000;
201   
202   
203   struct PurchaseData{
204     string fromCoin;   // Name OF Coin or Token BTC,LITE,ETH,ETC or other
205     uint256 value;     // Value from that coin  18 dacimon
206     uint256 exchangeRate; // 1: xxxxx   18 decimon
207     string tranHash;  // Tran hash from that token 
208   }
209 
210   event PurchaseSGDS(address indexed addr,uint256 value,uint256 refID);
211   event UsedSGDS(address indexed addr,uint256 value);
212   event SetControlToken(address indexed addr, bool outControl);
213   event FeeTransfer(address indexed addr,uint256 _value);
214   event TransferWallet(address indexed from,address indexed to,address indexed execute_);
215 
216   mapping(address => bool) userControl;   // if true mean can't not control this address
217   mapping(uint256 => uint256) purchaseID;
218 
219   PurchaseData[]  purDatas;
220 
221   constructor() public {
222     totalSupply_ = 0;
223     totalUsed = 0;
224     totalPurchange = 0;
225   }
226 
227 // It can only purchase direct from SETITEE ONLY
228   function purchaseSGDS(address addr, uint256 value,uint256 refID,string fromCoin,uint256 coinValue,uint256 rate,string txHash)  external onlyOwners{
229     balance[addr] += value;
230     totalSupply_ += value;
231     totalPurchange += value;
232     
233     uint256 id = purDatas.push(PurchaseData(fromCoin,coinValue,rate,txHash));
234     purchaseID[refID] = id;
235 
236     emit PurchaseSGDS(addr,value,refID);
237     emit Transfer(address(this),addr,value);
238   }
239 
240   function getPurchaseData(uint256 refID) view public returns(string fromCoin,uint256 value,uint256 exchangeRate,string txHash) {
241     require(purchaseID[refID] > 0);
242     uint256  pId = purchaseID[refID] - 1;
243     PurchaseData memory pData = purDatas[pId];
244 
245     fromCoin = pData.fromCoin;
246     value = pData.value;
247     exchangeRate = pData.exchangeRate;
248     txHash = pData.tranHash;
249 
250   }
251 
252 // This will cal only in website then it will no gas fee for user that buy and use in my system.
253 // SETITEE will pay for that
254   function useSGDS(address useAddr,uint256 value) onlyOwners external returns(bool)  {
255     require(userControl[useAddr] == false); // if true user want to  make it by your self
256     require(balance[useAddr] >= value);
257 
258     balance[useAddr] -= value;
259     totalSupply_ -= value;
260     totalUsed += value;
261 
262     emit UsedSGDS(useAddr,value);
263     emit Transfer(useAddr,address(0),value);
264 
265     return true;
266   }
267 
268 // This for use seitee transfer . Seitee will pay for gas
269   function intTransfer(address _from, address _to, uint256 _value) external onlyOwners returns(bool){
270     require(userControl[_from] == false);  // Company can do if they still allow compay to do it
271     require(balance[_from] >= _value);
272     require(_to != address(0));
273         
274     balance[_from] -= _value; 
275     balance[_to] += _value;
276     
277     emit Transfer(_from,_to,_value);
278     return true;
279   }
280 
281   // For transfer all SGDS Token to new Wallet Address. Want to pay 1 SGDS for fee.
282   
283   function transferWallet(address _from,address _to) external onlyOwners{
284         require(userControl[_from] == false);
285         require(balance[_from] > transFee);  //Fee 1 SGDS
286         uint256  value = balance[_from];
287 
288         balance[_from] = balance[_from].sub(value);
289         balance[_to] = balance[_to].add(value - transFee); // sub with FEE
290 
291         emit TransferWallet(_from,_to,msg.sender);
292         emit Transfer(_from,_to,value - transFee);
293         emit FeeTransfer(_to,transFee);
294   }
295 
296 // Address Owner can set permision by him self. Set to true will stop company control his/her wallet
297   function setUserControl(bool _control) public {
298     userControl[msg.sender] = _control;
299     emit SetControlToken(msg.sender,_control);
300   }
301 
302   function getUserControl(address _addr) external view returns(bool){
303     return userControl[_addr];
304   }
305   
306   function setTransFee(uint256 _fee) onlyOwners public{
307     transFee = _fee;
308   }
309 }