1 pragma solidity ^0.5.17;
2 
3 library SafeMath
4 {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
6 		c = a + b;
7 		require(c >= a, "SafeMath: addition overflow");
8 	}
9 	function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
10 		require(b <= a, "SafeMath: subtraction overflow");
11 		c = a - b;
12 	}
13 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14 		c = a * b;
15 		require(a == 0 || c / a == b, "SafeMath: multiplication overflow");
16 	}
17 	function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
18 		require(b > 0, "SafeMath: division by zero");
19 		c = a / b;
20 	}
21 }
22 
23 contract Variable
24 {
25   string public name;
26   string public symbol;
27   uint256 public decimals;
28   uint256 public totalSupply;
29   address public owner;
30 
31   uint256 internal _decimals;
32   bool internal transferLock;
33   
34   mapping (address => bool) public allowedAddress;
35   mapping (address => bool) public blockedAddress;
36 
37   mapping (address => uint256) public balanceOf;
38   
39   mapping (address => bool) public lockTimeAddress;
40   mapping (address => uint8) public lockCountMonth;
41   mapping (address => uint256) public lockPermitBalance;
42   mapping (address => uint256[]) public lockTime;
43   mapping (address => uint8[]) public lockPercent;
44   mapping (address => bool[]) public lockCheck;
45   mapping (address => uint256[]) public lockBalance;
46   
47   mapping (address => mapping (address => uint256)) internal allowed;
48 
49   constructor() public
50   {
51     name = "Beyond Finance";
52     symbol = "BYN";
53     decimals = 18;
54     _decimals = 10 ** uint256(decimals);
55     totalSupply = _decimals * 100000000;
56     transferLock = true;
57     owner =  msg.sender;
58     balanceOf[owner] = totalSupply;
59     allowedAddress[owner] = true;
60   }
61 }
62 
63 contract Modifiers is Variable
64 {
65   modifier isOwner
66   {
67     assert(owner == msg.sender);
68     _;
69   }
70 }
71 
72 contract Event
73 {
74   event Transfer(address indexed from, address indexed to, uint256 value);
75   event TokenBurn(address indexed from, uint256 value);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 contract manageAddress is Variable, Modifiers, Event
80 {
81   using SafeMath for uint256;
82   function add_allowedAddress(address _address) public isOwner
83   {
84     allowedAddress[_address] = true;
85   }
86   function delete_allowedAddress(address _address) public isOwner
87   {
88     require(_address != owner,"Not owner");
89     allowedAddress[_address] = false;
90   }
91   function add_blockedAddress(address _address) public isOwner
92   {
93     require(_address != owner,"Not owner");
94     blockedAddress[_address] = true;
95   }
96   function delete_blockedAddress(address _address) public isOwner
97   {
98     blockedAddress[_address] = false;
99   }
100   function add_timeAddress(address _address, uint8 total_month) public isOwner
101   {
102     if(lockTimeAddress[_address] == true)
103     {
104         revert("Already set address");
105     }
106     if(total_month < 2 && lockCountMonth[_address] > 0)
107     {
108         revert("Period want to set is short");
109     }
110     lockCountMonth[_address] = total_month;
111     lockTime[_address] = new uint256[](total_month);
112     lockPercent[_address] = new uint8[](total_month);
113     lockCheck[_address] = new bool[](total_month);
114     lockBalance[_address] = new uint256[](total_month);
115   }
116   function delete_timeAddress(address _address) public isOwner
117   {
118     lockTimeAddress[_address] = false;
119     lockPermitBalance[_address] = 0;
120     for(uint8 i = 0; i < lockCountMonth[_address]; i++)
121     {
122         delete lockTime[_address][i];
123         delete lockPercent[_address][i];
124         delete lockCheck[_address][i];
125         delete lockBalance[_address][i];
126     }
127     lockCountMonth[_address] = 0;
128   }
129   function add_timeAddressMonth(address _address,uint256 _time,uint8 idx, uint8 _percent) public isOwner
130   {
131     if(now > _time)
132     {
133         revert("Must greater than current time");
134     }
135     if(idx >= lockCountMonth[_address])
136     {
137         revert("Invalid Setup Period");
138     }
139     if(idx != 0 && lockTime[_address][idx - 1] >= _time)
140     {
141         revert("Must greater than previous time");
142     }
143 
144     lockPercent[_address][idx] = _percent;
145     lockTime[_address][idx] = _time;
146   }
147   function add_timeAddressApply(address _address, uint256 lock_balance) public isOwner
148   {
149     if(balanceOf[_address] >= lock_balance && lock_balance > 0)
150     {
151         uint8 sum = lockPercent[_address][0];
152 
153         lockPermitBalance[_address] = 0;
154         for(uint8 i = 0; i < lockCountMonth[_address]; i++)
155         {
156             lockBalance[_address][i] = (lock_balance.mul(lockPercent[_address][i])).div(100);
157             if(i > 0)
158             {
159                 sum += lockPercent[_address][i];
160             }
161         }
162         
163         if(sum != 100)
164         {
165             revert("Invalid percentage");
166         }
167         lockTimeAddress[_address] = true;
168     }
169     else
170     {
171         revert("Invalid balance");
172     }
173     
174   }
175   function refresh_lockPermitBalance(address _address) public 
176   {
177     if(lockTimeAddress[_address] == false)
178     {
179         revert("Address without Lock");  
180     }
181     for(uint8 i = 0; i < lockCountMonth[msg.sender]; i++)
182     {
183         if(now >= lockTime[_address][i] && lockCheck[_address][i] == false)
184         {
185             lockPermitBalance[_address] += lockBalance[_address][i];
186             lockCheck[_address][i] = true;
187             if(lockCountMonth[_address] - 1 == i)
188             {
189                 delete_timeAddress(_address);
190             }
191         }
192     }
193   }
194 }
195 contract Admin is Variable, Modifiers, Event
196 {
197   using SafeMath for uint256;
198   
199   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
200   {
201     require(balanceOf[msg.sender] >= _value, "Invalid balance");
202     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
203     totalSupply = totalSupply.sub(_value);
204     emit TokenBurn(msg.sender, _value);
205     return true;
206   }
207 }
208 contract Get is Variable, Modifiers
209 {
210   function get_transferLock() public view returns(bool)
211   {
212     return transferLock;
213   }
214 }
215 
216 contract Set is Variable, Modifiers, Event
217 {
218   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
219   {
220     transferLock = _transferLock;
221     return true;
222   }
223 }
224 
225 contract BYN is Variable, Event, Get, Set, Admin, manageAddress
226 {
227   function() external payable 
228   {
229     revert();
230   }
231   function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) 
232   {
233     return allowed[tokenOwner][spender];
234   }
235   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
236   {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool)
242   {
243     uint256 oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue > oldValue) 
245     {
246         allowed[msg.sender][_spender] = 0;
247     } 
248     else
249     {
250         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255   function approve(address _spender, uint256 _value) public returns (bool)
256   {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
262   {
263     require(allowedAddress[_from] || transferLock == false, "Transfer lock : true");
264     require(!blockedAddress[_from] && !blockedAddress[_to] && !blockedAddress[msg.sender], "Blocked address");
265     require(balanceOf[_from] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");
266     require(lockTimeAddress[_to] == false, "Lock address : to");
267     require(_value <= allowed[_from][msg.sender], "Invalid balance : allowed");
268 
269     if(lockTimeAddress[_from])
270     {
271         lockPermitBalance[_from] = lockPermitBalance[_from].sub(_value);
272     }
273 
274     balanceOf[_from] = balanceOf[_from].sub(_value);
275     balanceOf[_to] = balanceOf[_to].add(_value);
276     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
277     emit Transfer(_from, _to, _value);
278 
279     return true;
280 
281   }
282   
283   function transfer(address _to, uint256 _value) public returns (bool)  
284   {
285     require(allowedAddress[msg.sender] || transferLock == false, "Transfer lock : true");
286     require(!blockedAddress[msg.sender] && !blockedAddress[_to], "Blocked address");
287     require(balanceOf[msg.sender] >= _value && (balanceOf[_to].add(_value)) >= balanceOf[_to], "Invalid balance");
288     require(lockTimeAddress[_to] == false, "Lock address : to");
289 
290     if(lockTimeAddress[msg.sender])
291     {
292         lockPermitBalance[msg.sender] = lockPermitBalance[msg.sender].sub(_value);
293     }
294 
295     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
296     balanceOf[_to] = balanceOf[_to].add(_value);
297     emit Transfer(msg.sender, _to, _value);
298         
299     return true;
300   }
301 }