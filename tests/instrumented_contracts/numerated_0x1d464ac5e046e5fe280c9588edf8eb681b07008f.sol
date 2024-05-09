1 pragma solidity ^0.4.20;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library safeMath
6 {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256)
8   {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function add(uint256 a, uint256 b) internal pure returns (uint256)
14   {
15     uint256 c = a + b;
16     assert(c >= a);
17     return c;
18   }
19 }
20 
21 contract Event
22 {
23   event Transfer(address indexed from, address indexed to, uint256 value);
24   event Deposit(address indexed sender, uint256 amount , string status);
25   event TokenBurn(address indexed from, uint256 value);
26   event TokenAdd(address indexed from, uint256 value);
27   event Set_Status(string changedStatus);
28   event Set_TokenReward(uint256 changedTokenReward);
29   event Set_TimeStamp(uint256 ICO_startingTime, uint256 ICO_closingTime);
30   event WithdrawETH(uint256 amount);
31   event BlockedAddress(address blockedAddress);
32   event TempLockedAddress(address tempLockAddress, uint256 unlockTime);
33 }
34 
35 contract Variable
36 {
37   string public name;
38   string public symbol;
39   uint256 public decimals;
40   uint256 public totalSupply;
41   address public owner;
42   string public status;
43 
44   uint256 internal _decimals;
45   uint256 internal tokenReward;
46   uint256 internal ICO_startingTime;
47   uint256 internal ICO_closingTime;
48   bool internal transferLock;
49   bool internal depositLock;
50   mapping (address => bool) public allowedAddress;
51   mapping (address => bool) public blockedAddress;
52   mapping (address => uint256) public tempLockedAddress;
53 
54   address withdraw_wallet;
55   mapping (address => uint256) public balanceOf;
56 
57 
58   constructor() public
59   {
60     name = "GMB";
61     symbol = "GMB";
62     decimals = 18;
63     _decimals = 10 ** uint256(decimals);
64     tokenReward = 0;
65     totalSupply = _decimals * 5000000000;
66     status = "";
67     ICO_startingTime = 0;// 18.01.01 00:00:00 1514732400;
68     ICO_closingTime = 0;// 18.12.31 23.59.59 1546268399;
69     transferLock = true;
70     depositLock = true;
71     owner =  0xEfe9f7A61083ffE83Cbf833EeE61Eb1757Dd17BB;
72     balanceOf[owner] = totalSupply;
73     allowedAddress[owner] = true;
74     withdraw_wallet = 0x7f7e8355A4c8fA72222DC66Bbb3E701779a2808F;
75   }
76 }
77 
78 contract Modifiers is Variable
79 {
80   modifier isOwner
81   {
82     assert(owner == msg.sender);
83     _;
84   }
85 
86   modifier isValidAddress
87   {
88     assert(0x0 != msg.sender);
89     _;
90   }
91 }
92 
93 contract Set is Variable, Modifiers, Event
94 {
95   function setStatus(string _status) public isOwner returns(bool success)
96   {
97     status = _status;
98     emit Set_Status(status);
99     return true;
100   }
101   function setTokenReward(uint256 _tokenReward) public isOwner returns(bool success)
102   {
103     tokenReward = _tokenReward;
104     emit Set_TokenReward(tokenReward);
105     return true;
106   }
107   function setTimeStamp(uint256 _ICO_startingTime,uint256 _ICO_closingTime) public isOwner returns(bool success)
108   {
109     ICO_startingTime = _ICO_startingTime;
110     ICO_closingTime = _ICO_closingTime;
111 
112     emit Set_TimeStamp(ICO_startingTime, ICO_closingTime);
113     return true;
114   }
115   function setTransferLock(bool _transferLock) public isOwner returns(bool success)
116   {
117     transferLock = _transferLock;
118     return true;
119   }
120   function setDepositLock(bool _depositLock) public isOwner returns(bool success)
121   {
122     depositLock = _depositLock;
123     return true;
124   }
125   function setTimeStampStatus(uint256 _ICO_startingTime, uint256 _ICO_closingTime, string _status) public isOwner returns(bool success)
126   {
127     ICO_startingTime = _ICO_startingTime;
128     ICO_closingTime = _ICO_closingTime;
129     status = _status;
130     emit Set_TimeStamp(ICO_startingTime,ICO_closingTime);
131     emit Set_Status(status);
132     return true;
133   }
134 }
135 
136 contract manageAddress is Variable, Modifiers, Event
137 {
138 
139   function add_allowedAddress(address _address) public isOwner
140   {
141     allowedAddress[_address] = true;
142   }
143 
144   function add_blockedAddress(address _address) public isOwner
145   {
146     require(_address != owner);
147     blockedAddress[_address] = true;
148     emit BlockedAddress(_address);
149   }
150 
151   function delete_allowedAddress(address _address) public isOwner
152   {
153     require(_address != owner);
154     allowedAddress[_address] = false;
155   }
156 
157   function delete_blockedAddress(address _address) public isOwner
158   {
159     blockedAddress[_address] = false;
160   }
161 }
162 
163 contract Get is Variable, Modifiers
164 {
165   function get_tokenTime() public view returns(uint256 start, uint256 stop)
166   {
167     return (ICO_startingTime,ICO_closingTime);
168   }
169   function get_transferLock() public view returns(bool)
170   {
171     return transferLock;
172   }
173   function get_depositLock() public view returns(bool)
174   {
175     return depositLock;
176   }
177   function get_tokenReward() public view returns(uint256)
178   {
179     return tokenReward;
180   }
181 
182 }
183 
184 contract Admin is Variable, Modifiers, Event
185 {
186   function admin_transfer_tempLockAddress(address _to, uint256 _value, uint256 _unlockTime) public isOwner returns(bool success)
187   {
188     require(balanceOf[msg.sender] >= _value);
189     require(balanceOf[_to] + (_value ) >= balanceOf[_to]);
190     balanceOf[msg.sender] -= _value;
191     balanceOf[_to] += _value;
192     tempLockedAddress[_to] = _unlockTime;
193     emit Transfer(msg.sender, _to, _value);
194     emit TempLockedAddress(_to, _unlockTime);
195     return true;
196   }
197   function admin_transferFrom(address _from, address _to, uint256 _value) public isOwner returns(bool success)
198   {
199     require(balanceOf[_from] >= _value);
200     require(balanceOf[_to] + (_value ) >= balanceOf[_to]);
201     balanceOf[_from] -= _value;
202     balanceOf[_to] += _value;
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206   function admin_tokenBurn(uint256 _value) public isOwner returns(bool success)
207   {
208     require(balanceOf[msg.sender] >= _value);
209     balanceOf[msg.sender] -= _value;
210     totalSupply -= _value;
211     emit TokenBurn(msg.sender, _value);
212     return true;
213   }
214   function admin_tokenAdd(uint256 _value) public isOwner returns(bool success)
215   {
216     balanceOf[msg.sender] += _value;
217     totalSupply += _value;
218     emit TokenAdd(msg.sender, _value);
219     return true;
220   }
221   function admin_renewLockedAddress(address _address, uint256 _unlockTime) public isOwner returns(bool success)
222   {
223     tempLockedAddress[_address] = _unlockTime;
224     emit TempLockedAddress(_address, _unlockTime);
225     return true;
226   }
227 }
228 
229 contract GMB is Variable, Event, Get, Set, Admin, manageAddress
230 {
231   using safeMath for uint256;
232 
233   function() payable public
234   {
235     require(ICO_startingTime < block.timestamp && ICO_closingTime > block.timestamp);
236     require(!depositLock);
237     uint256 tokenValue;
238     tokenValue = (msg.value).mul(tokenReward);
239     require(balanceOf[owner] >= tokenValue);
240     require(balanceOf[msg.sender].add(tokenValue) >= balanceOf[msg.sender]);
241     emit Deposit(msg.sender, msg.value, status);
242     balanceOf[owner] -= tokenValue;
243     balanceOf[msg.sender] += tokenValue;
244     emit Transfer(owner, msg.sender, tokenValue);
245   }
246   function transfer(address _to, uint256 _value) public isValidAddress
247   {
248     require(allowedAddress[msg.sender] || transferLock == false);
249     require(tempLockedAddress[msg.sender] < block.timestamp);
250     require(!blockedAddress[msg.sender] && !blockedAddress[_to]);
251     require(balanceOf[msg.sender] >= _value);
252     require((balanceOf[_to].add(_value)) >= balanceOf[_to]);
253     balanceOf[msg.sender] -= _value;
254     balanceOf[_to] += _value;
255     emit Transfer(msg.sender, _to, _value);
256   }
257   function ETH_withdraw(uint256 amount) public isOwner returns(bool)
258   {
259     withdraw_wallet.transfer(amount);
260     emit WithdrawETH(amount);
261     return true;
262   }
263 }