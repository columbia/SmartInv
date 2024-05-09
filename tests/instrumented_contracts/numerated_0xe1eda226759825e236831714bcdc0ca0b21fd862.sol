1 pragma solidity 0.4.16;
2 
3 contract PullPayInterface {
4   function asyncSend(address _dest) public payable;
5 }
6 
7 contract ERC223ReceivingContract {
8     function tokenFallback(address _from, uint _value, bytes _data);
9 }
10 
11 contract ControllerInterface {
12 
13 
14   // State Variables
15   bool public paused;
16   address public nutzAddr;
17 
18   // Nutz functions
19   function babzBalanceOf(address _owner) constant returns (uint256);
20   function activeSupply() constant returns (uint256);
21   function burnPool() constant returns (uint256);
22   function powerPool() constant returns (uint256);
23   function totalSupply() constant returns (uint256);
24   function allowance(address _owner, address _spender) constant returns (uint256);
25 
26   function approve(address _owner, address _spender, uint256 _amountBabz) public;
27   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public;
28   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public;
29 
30   // Market functions
31   function floor() constant returns (uint256);
32   function ceiling() constant returns (uint256);
33 
34   function purchase(address _sender, uint256 _value, uint256 _price) public returns (uint256);
35   function sell(address _from, uint256 _price, uint256 _amountBabz);
36 
37   // Power functions
38   function powerBalanceOf(address _owner) constant returns (uint256);
39   function outstandingPower() constant returns (uint256);
40   function authorizedPower() constant returns (uint256);
41   function powerTotalSupply() constant returns (uint256);
42 
43   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
44   function downTick(address _owner, uint256 _now) public;
45   function createDownRequest(address _owner, uint256 _amountPower) public;
46   function downs(address _owner) constant public returns(uint256, uint256, uint256);
47   function downtime() constant returns (uint256);
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner {
83     require(newOwner != address(0));      
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract ERC20Basic {
90   function totalSupply() constant returns (uint256);
91   function balanceOf(address _owner) constant returns (uint256);
92   function transfer(address _to, uint256 _value) returns (bool);
93   event Transfer(address indexed from, address indexed to, uint value);
94 }
95 
96 contract ERC223Basic is ERC20Basic {
97     function transfer(address to, uint value, bytes data) returns (bool);
98 }
99 
100 /*
101  * ERC20 interface
102  * see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC223Basic {
105   // active supply of tokens
106   function activeSupply() constant returns (uint256);
107   function allowance(address _owner, address _spender) constant returns (uint256);
108   function transferFrom(address _from, address _to, uint _value) returns (bool);
109   function approve(address _spender, uint256 _value);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 /**
115  * Nutz implements a price floor and a price ceiling on the token being
116  * sold. It is based of the zeppelin token contract.
117  */
118 contract Nutz is Ownable, ERC20 {
119 
120   event Sell(address indexed seller, uint256 value);
121 
122   string public name = "Acebusters Nutz";
123   // acebusters units:
124   // 10^12 - Nutz   (NTZ)
125   // 10^9 - Jonyz
126   // 10^6 - Helcz
127   // 10^3 - Pascalz
128   // 10^0 - Babz
129   string public symbol = "NTZ";
130   uint256 public decimals = 12;
131 
132   // returns balances of active holders
133   function balanceOf(address _owner) constant returns (uint) {
134     return ControllerInterface(owner).babzBalanceOf(_owner);
135   }
136 
137   function totalSupply() constant returns (uint256) {
138     return ControllerInterface(owner).totalSupply();
139   }
140 
141   function activeSupply() constant returns (uint256) {
142     return ControllerInterface(owner).activeSupply();
143   }
144 
145   // return remaining allowance
146   // if calling return allowed[address(this)][_spender];
147   // returns balance of ether parked to be withdrawn
148   function allowance(address _owner, address _spender) constant returns (uint256) {
149     return ControllerInterface(owner).allowance(_owner, _spender);
150   }
151 
152   // returns either the salePrice, or if reserve does not suffice
153   // for active supply, returns maxFloor
154   function floor() constant returns (uint256) {
155     return ControllerInterface(owner).floor();
156   }
157 
158   // returns either the salePrice, or if reserve does not suffice
159   // for active supply, returns maxFloor
160   function ceiling() constant returns (uint256) {
161     return ControllerInterface(owner).ceiling();
162   }
163 
164   function powerPool() constant returns (uint256) {
165     return ControllerInterface(owner).powerPool();
166   }
167 
168 
169   function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
170     // erc223: Retrieve the size of the code on target address, this needs assembly .
171     uint256 codeLength;
172     assembly {
173       codeLength := extcodesize(_to)
174     }
175     if(codeLength>0) {
176       ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
177       // untrusted contract call
178       untrustedReceiver.tokenFallback(_from, _value, _data);
179     }
180   }
181 
182 
183 
184   // ############################################
185   // ########### ADMIN FUNCTIONS ################
186   // ############################################
187 
188   function powerDown(address powerAddr, address _holder, uint256 _amountBabz) public onlyOwner {
189     bytes memory empty;
190     _checkDestination(powerAddr, _holder, _amountBabz, empty);
191     // NTZ transfered from power pool to user's balance
192     Transfer(powerAddr, _holder, _amountBabz);
193   }
194 
195 
196   function asyncSend(address _pullAddr, address _dest, uint256 _amountWei) public onlyOwner {
197     assert(_amountWei <= this.balance);
198     PullPayInterface(_pullAddr).asyncSend.value(_amountWei)(_dest);
199   }
200 
201 
202   // ############################################
203   // ########### PUBLIC FUNCTIONS ###############
204   // ############################################
205 
206   function approve(address _spender, uint256 _amountBabz) public {
207     ControllerInterface(owner).approve(msg.sender, _spender, _amountBabz);
208     Approval(msg.sender, _spender, _amountBabz);
209   }
210 
211   function transfer(address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
212     ControllerInterface(owner).transfer(msg.sender, _to, _amountBabz, _data);
213     Transfer(msg.sender, _to, _amountBabz);
214     _checkDestination(msg.sender, _to, _amountBabz, _data);
215     return true;
216   }
217 
218   function transfer(address _to, uint256 _amountBabz) public returns (bool) {
219     bytes memory empty;
220     return transfer(_to, _amountBabz, empty);
221   }
222 
223   function transData(address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
224     return transfer(_to, _amountBabz, _data);
225   }
226 
227   function transferFrom(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
228     ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amountBabz, _data);
229     Transfer(_from, _to, _amountBabz);
230     _checkDestination(_from, _to, _amountBabz, _data);
231     return true;
232   }
233 
234   function transferFrom(address _from, address _to, uint256 _amountBabz) public returns (bool) {
235     bytes memory empty;
236     return transferFrom(_from, _to, _amountBabz, empty);
237   }
238 
239   function () public payable {
240     uint256 price = ControllerInterface(owner).ceiling();
241     purchase(price);
242     require(msg.value > 0);
243   }
244 
245   function purchase(uint256 _price) public payable {
246     require(msg.value > 0);
247     uint256 amountBabz = ControllerInterface(owner).purchase(msg.sender, msg.value, _price);
248     Transfer(owner, msg.sender, amountBabz);
249     bytes memory empty;
250     _checkDestination(address(this), msg.sender, amountBabz, empty);
251   }
252 
253   function sell(uint256 _price, uint256 _amountBabz) public {
254     require(_amountBabz != 0);
255     ControllerInterface(owner).sell(msg.sender, _price, _amountBabz);
256     Sell(msg.sender, _amountBabz);
257   }
258 
259   function powerUp(uint256 _amountBabz) public {
260     Transfer(msg.sender, owner, _amountBabz);
261     ControllerInterface(owner).powerUp(msg.sender, msg.sender, _amountBabz);
262   }
263 
264 }