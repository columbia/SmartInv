1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Claimable is Ownable {
81   address public pendingOwner;
82 
83   /**
84    * @dev Modifier throws if called by any account other than the pendingOwner.
85    */
86   modifier onlyPendingOwner() {
87     require(msg.sender == pendingOwner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to set the pendingOwner address.
93    */
94   function transferOwnership(address newOwner) public onlyOwner{
95     pendingOwner = newOwner;
96   }
97 
98   /**
99    * @dev Allows the pendingOwner address to finalize the transfer.
100    */
101   function claimOwnership() onlyPendingOwner public {
102     OwnershipTransferred(owner, pendingOwner);
103     owner = pendingOwner;
104     pendingOwner = address(0);
105   }
106 }
107 
108 contract ComissionList is Claimable {
109   using SafeMath for uint256;
110 
111   struct Transfer {
112     uint256 stat;
113     uint256 perc;
114   }
115 
116   mapping (string => Transfer) refillPaySystemInfo;
117   mapping (string => Transfer) widthrawPaySystemInfo;
118 
119   Transfer transferInfo;
120 
121   event RefillCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
122   event WidthrawCommisionIsChanged(string _paySystem, uint256 stat, uint256 perc);
123   event TransferCommisionIsChanged(uint256 stat, uint256 perc);
124 
125   // установить информацию по комиссии для пополняемой платёжной системы
126   function setRefillFor(string _paySystem, uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
127     refillPaySystemInfo[_paySystem].stat = _stat;
128     refillPaySystemInfo[_paySystem].perc = _perc;
129 
130     RefillCommisionIsChanged(_paySystem, _stat, _perc);
131   }
132 
133   // установить информацию по комиссии для снимаеомй платёжной системы
134   function setWidthrawFor(string _paySystem,uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
135     widthrawPaySystemInfo[_paySystem].stat = _stat;
136     widthrawPaySystemInfo[_paySystem].perc = _perc;
137 
138     WidthrawCommisionIsChanged(_paySystem, _stat, _perc);
139   }
140 
141   // установить информацию по комиссии для перевода
142   function setTransfer(uint256 _stat, uint256 _perc) public onlyOwner returns (uint256) {
143     transferInfo.stat = _stat;
144     transferInfo.perc = _perc;
145 
146     TransferCommisionIsChanged(_stat, _perc);
147   }
148 
149   // взять процент по комиссии для пополняемой платёжной системы
150   function getRefillStatFor(string _paySystem) public view returns (uint256) {
151     return refillPaySystemInfo[_paySystem].perc;
152   }
153 
154   // взять фикс по комиссии для пополняемой платёжной системы
155   function getRefillPercFor(string _paySystem) public view returns (uint256) {
156     return refillPaySystemInfo[_paySystem].stat;
157   }
158 
159   // взять процент по комиссии для снимаемой платёжной системы
160   function getWidthrawStatFor(string _paySystem) public view returns (uint256) {
161     return widthrawPaySystemInfo[_paySystem].perc;
162   }
163 
164   // взять фикс по комиссии для снимаемой платёжной системы
165   function getWidthrawPercFor(string _paySystem) public view returns (uint256) {
166     return widthrawPaySystemInfo[_paySystem].stat;
167   }
168 
169   // взять процент по комиссии для перевода
170   function getTransferPerc() public view returns (uint256) {
171     return transferInfo.perc;
172   }
173   
174   // взять фикс по комиссии для перевода
175   function getTransferStat() public view returns (uint256) {
176     return transferInfo.stat;
177   }
178 
179   // рассчитать комиссию со снятия для платёжной системы и суммы
180   function calcWidthraw(string _paySystem, uint256 _value) public view returns(uint256) {
181     uint256 _totalComission;
182     _totalComission = widthrawPaySystemInfo[_paySystem].stat + (_value / 100 ) * widthrawPaySystemInfo[_paySystem].perc;
183 
184     return _totalComission;
185   }
186 
187   // рассчитать комиссию с пополнения для платёжной системы и суммы
188   function calcRefill(string _paySystem, uint256 _value) public view returns(uint256) {
189     uint256 _totalComission;
190     _totalComission = refillPaySystemInfo[_paySystem].stat + (_value / 100 ) * refillPaySystemInfo[_paySystem].perc;
191 
192     return _totalComission;
193   }
194 
195   // рассчитать комиссию с перевода для платёжной системы и суммы
196   function calcTransfer(uint256 _value) public view returns(uint256) {
197     uint256 _totalComission;
198     _totalComission = transferInfo.stat + (_value / 100 ) * transferInfo.perc;
199 
200     return _totalComission;
201   }
202 }