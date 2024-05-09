1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-29
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 
8 contract Ownable {
9     address private _owner;
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11     constructor () internal {
12         _owner = msg.sender;
13         emit OwnershipTransferred(address(0), _owner);
14     }
15     function owner() public view returns (address) {
16         return _owner;
17     }
18     
19     modifier onlyOwner() {
20         require(isOwner());
21         _;
22     }
23     
24     function isOwner() public view returns (bool) {
25         return msg.sender == _owner;
26     }
27     
28     
29     function transferOwnership(address newOwner) public onlyOwner {
30         _transferOwnership(newOwner);
31     }
32    
33     function _transferOwnership(address newOwner) internal {
34         require(newOwner != address(0));
35         emit OwnershipTransferred(_owner, newOwner);
36         _owner = newOwner;
37     }
38 }
39 
40 
41 contract SafeMath {
42   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b > 0);
50     uint256 c = a / b;
51     assert(a == b * c + a % b);
52     return c;
53   }
54 
55   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c>=a && c>=b);
63     return c;
64   }
65 
66 }
67 
68 contract BaseToken is  SafeMath,Ownable{
69     string public name;
70     string public symbol;
71     uint8 public decimals;
72     uint256 public totalSupply;
73 
74     mapping (address => uint256) public balanceOf;
75     mapping (address => mapping (address => uint256)) public allowance;
76     mapping (address => bool) public isFreeze;
77     event Transfer(address indexed from, address indexed to, uint256  value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79     event FrozenFunds(address target, bool frozen);
80     
81     
82     constructor(uint256 initialSupply,
83         string tokenName,
84         string tokenSymbol,
85         uint8 decimals
86     )public {
87         totalSupply = initialSupply * 10 ** uint256(decimals);  
88         balanceOf[msg.sender] = totalSupply;                
89         name = tokenName;                                  
90         symbol = tokenSymbol; 
91         decimals=decimals;
92     }
93 
94     modifier not_frozen(){
95         require(isFreeze[msg.sender]==false);
96         _;
97     }
98     function transfer(address _to, uint256 _value) public not_frozen returns (bool) {
99         require(_to != address(0));
100 		require(_value > 0); 
101         require(balanceOf[msg.sender] >= _value);
102         require(balanceOf[_to] + _value >= balanceOf[_to]);
103 		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
104         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
106         emit Transfer(msg.sender, _to, _value);
107 		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
108         return true;
109     }
110 
111     function approve(address _spender, uint256 _value) public not_frozen returns (bool success) {
112 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) public not_frozen returns (bool success) {
119         require (_to != address(0));
120 		require (_value > 0); 
121         require (balanceOf[_from] >= _value) ;
122         require (balanceOf[_to] + _value > balanceOf[_to]);
123         require (_value <= allowance[_from][msg.sender]);
124         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
125         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
126         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130       //冻结解冻
131     function freezeOneAccount(address target, bool freeze) onlyOwner public {
132         require(freeze!=isFreeze[target]); 
133         isFreeze[target] = freeze;
134         emit FrozenFunds(target, freeze);
135     }
136     
137     //批量冻结解冻
138     function multiFreeze(address[] targets,bool freeze) onlyOwner public {
139         for(uint256 i = 0; i < targets.length ; i++){
140             freezeOneAccount(targets[i],freeze);
141         }
142     }
143     
144 }
145 
146 contract MBSCoin is BaseToken
147 {
148     string public name = "Mobius";
149     string public symbol = "MBS";
150     string public version = '1.0.0';
151     uint8 public decimals = 18;
152     uint256 initialSupply=100000000;
153     constructor()BaseToken(initialSupply, name,symbol,decimals)public {}
154     bool public auto_lock   = false;
155     mapping (address => uint) public lockedAmount;
156     address[] public lockedAddress;
157     mapping(address => bool) public isExsitLocked;
158     uint256 public lockedAddressAmount;
159     event LockToken(address indexed target, uint256 indexed amount);
160     event OwnerUnlock(address indexed from,uint256 indexed amount);
161     event TransferLockedCoin(address indexed from, address indexed to, uint256 indexed value);
162     uint256 public buy_price;
163     uint256 public buyer_lock_rate; 
164     uint8 public usdt_decimal=6;
165     uint8 public price_decimal=3;
166     function set_buy_price(uint256 price) public onlyOwner
167     {
168         buy_price=price;
169     }
170     function set_lock_rate(uint256 new_lock_rate) public onlyOwner
171     {
172         require(new_lock_rate>=0 && new_lock_rate<=10);
173         buyer_lock_rate=new_lock_rate;
174     }
175     
176     function sum(uint256[] data) public  pure returns (uint256) {
177         uint256 S;
178         for(uint i;i < data.length;i++) {
179             S += data[i];
180         }
181         return S;
182     }
183 
184     function setAutoLockFlag(bool openOrClose) public onlyOwner {
185         require(openOrClose!=auto_lock);
186         auto_lock=openOrClose;
187     }
188 
189     function transfer_locked_coin(address _to, uint256 _value) public not_frozen returns (bool) {
190         require(_to != address(0));
191 		require(_value > 0); 
192         require(lockedAmount[msg.sender] >= _value);
193         require(lockedAmount[_to] + _value >= lockedAmount[_to]);
194 		uint previousBalances = lockedAmount[msg.sender] + lockedAmount[_to];		
195         lockedAmount[msg.sender] = SafeMath.safeSub(lockedAmount[msg.sender], _value);
196         lockedAmount[_to] = SafeMath.safeAdd(lockedAmount[_to], _value);
197 		assert(lockedAmount[msg.sender]+lockedAmount[_to]==previousBalances);
198 		emit TransferLockedCoin(msg.sender, _to, _value);
199         return true;
200     }
201 
202     //批量转账
203     function SendGiftMultiAddress(address[] _recivers, uint256[] _values) public onlyOwner 
204     {
205         require (_recivers.length == _values.length);
206         require(balanceOf[msg.sender]>=sum(_values));
207         address receiver;
208         uint256 value;
209         for(uint256 i = 0; i < _recivers.length ; i++){
210             receiver = _recivers[i];
211             value = _values[i];
212             transfer(receiver,value);
213             //自动锁仓
214             if(auto_lock==true)
215             {
216                 lockToken(receiver,value);
217             }
218         }
219     }
220     
221     function send_to_buyer(uint256 usdt_amount,address buyer_address) public onlyOwner 
222     {
223         require(buy_price>0);
224         require(usdt_amount>0);
225         require(buyer_lock_rate>=0 && buyer_lock_rate<=10);
226         uint256 can_buy_amount=(usdt_amount*buy_price)* 10**uint256(decimals)/10**uint256(usdt_decimal)/10**uint256(price_decimal);
227         require(balanceOf[msg.sender]>=can_buy_amount);
228         uint256 lock_amount=can_buy_amount*buyer_lock_rate/10;
229         if (can_buy_amount>0)
230         {
231             transfer(buyer_address,can_buy_amount);
232         }
233         if(lock_amount>0)
234         {
235             lockToken(buyer_address,lock_amount);
236         }
237     }
238     
239       //锁仓
240      function lockToken (address target,uint256 lockAmount) onlyOwner public returns(bool res)
241     {
242         require(target != address(0));
243 		require(lockAmount > 0); 
244         require(balanceOf[target] >= lockAmount);
245         uint previousBalances = balanceOf[target]+lockedAmount[target];
246         balanceOf[target] = safeSub(balanceOf[target],lockAmount);
247         lockedAmount[target] =safeAdd(lockedAmount[target],lockAmount);
248         if  (isExsitLocked[target]==false)
249         {
250             isExsitLocked[target]=true;
251             lockedAddress.push(target);
252             lockedAddressAmount+=1;
253         }
254         emit LockToken(target, lockAmount);
255         assert(previousBalances==balanceOf[target]+lockedAmount[target]);
256         return true;
257     }
258     
259  //解锁
260      function ownerUnlock (address target, uint256 amount) onlyOwner public returns(bool res) 
261      {
262         require(target != address(0));
263         require(amount > 0); 
264         require(lockedAmount[target] >= amount);
265         uint previousBalances = balanceOf[target]+lockedAmount[target];
266         balanceOf[target] = safeAdd(balanceOf[target],amount);
267         lockedAmount[target] = safeSub(lockedAmount[target],amount);
268         emit OwnerUnlock(target,amount);
269         assert(previousBalances==balanceOf[target]+lockedAmount[target]);
270         return true;
271     }
272 
273     function unlockAll(address target) onlyOwner public returns(bool res) 
274     {
275         require(target != address(0));
276         ownerUnlock(target,lockedAmount[target]);
277         return true;
278     }
279 
280 }