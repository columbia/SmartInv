1 pragma solidity 0.4.16;
2 
3 contract ControllerInterface {
4 
5 
6   // State Variables
7   bool public paused;
8   address public nutzAddr;
9 
10   // Nutz functions
11   function babzBalanceOf(address _owner) constant returns (uint256);
12   function activeSupply() constant returns (uint256);
13   function burnPool() constant returns (uint256);
14   function powerPool() constant returns (uint256);
15   function totalSupply() constant returns (uint256);
16   function allowance(address _owner, address _spender) constant returns (uint256);
17 
18   function approve(address _owner, address _spender, uint256 _amountBabz) public;
19   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public;
20   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public;
21 
22   // Market functions
23   function floor() constant returns (uint256);
24   function ceiling() constant returns (uint256);
25 
26   function purchase(address _sender, uint256 _value, uint256 _price) public returns (uint256);
27   function sell(address _from, uint256 _price, uint256 _amountBabz);
28 
29   // Power functions
30   function powerBalanceOf(address _owner) constant returns (uint256);
31   function outstandingPower() constant returns (uint256);
32   function authorizedPower() constant returns (uint256);
33   function powerTotalSupply() constant returns (uint256);
34 
35   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
36   function downTick(address _owner, uint256 _now) public;
37   function createDownRequest(address _owner, uint256 _amountPower) public;
38   function downs(address _owner) constant public returns(uint256, uint256, uint256);
39   function downtime() constant returns (uint256);
40 }
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48   address public owner;
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   function Ownable() {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) onlyOwner {
74     require(newOwner != address(0));      
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86   function mul(uint256 a, uint256 b) internal returns (uint256) {
87     uint256 c = a * b;
88     assert(a == 0 || c / a == b);
89     return c;
90   }
91 
92   function div(uint256 a, uint256 b) internal returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   function sub(uint256 a, uint256 b) internal returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   function add(uint256 a, uint256 b) internal returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 /**
112  * @title PullPayment
113  * @dev Base contract supporting async send for pull payments.
114  */
115 contract PullPayment is Ownable {
116   using SafeMath for uint256;
117 
118 
119   uint public dailyLimit = 1000000000000000000000;  // 1 ETH
120   uint public lastDay;
121   uint public spentToday;
122 
123   // 8bytes date, 24 bytes value
124   mapping(address => uint256) internal payments;
125 
126   modifier onlyNutz() {
127     require(msg.sender == ControllerInterface(owner).nutzAddr());
128     _;
129   }
130 
131   modifier whenNotPaused () {
132     require(!ControllerInterface(owner).paused());
133      _;
134   }
135 
136   function balanceOf(address _owner) constant returns (uint256 value) {
137     return uint192(payments[_owner]);
138   }
139 
140   function paymentOf(address _owner) constant returns (uint256 value, uint256 date) {
141     value = uint192(payments[_owner]);
142     date = (payments[_owner] >> 192);
143     return;
144   }
145 
146   /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
147   /// @param _dailyLimit Amount in wei.
148   function changeDailyLimit(uint _dailyLimit) public onlyOwner {
149       dailyLimit = _dailyLimit;
150   }
151 
152   function changeWithdrawalDate(address _owner, uint256 _newDate)  public onlyOwner {
153     // allow to withdraw immediately
154     // move witdrawal date more days into future
155     payments[_owner] = (_newDate << 192) + uint192(payments[_owner]);
156   }
157 
158   function asyncSend(address _dest) public payable onlyNutz {
159     require(msg.value > 0);
160     uint256 newValue = msg.value.add(uint192(payments[_dest]));
161     uint256 newDate;
162     if (isUnderLimit(msg.value)) {
163       uint256 date = payments[_dest] >> 192;
164       newDate = (date > now) ? date : now;
165     } else {
166       newDate = now.add(3 days);
167     }
168     spentToday = spentToday.add(msg.value);
169     payments[_dest] = (newDate << 192) + uint192(newValue);
170   }
171 
172 
173   function withdraw() public whenNotPaused {
174     address untrustedRecipient = msg.sender;
175     uint256 amountWei = uint192(payments[untrustedRecipient]);
176 
177     require(amountWei != 0);
178     require(now >= (payments[untrustedRecipient] >> 192));
179     require(this.balance >= amountWei);
180 
181     payments[untrustedRecipient] = 0;
182 
183     untrustedRecipient.transfer(amountWei);
184   }
185 
186   /*
187    * Internal functions
188    */
189   /// @dev Returns if amount is within daily limit and resets spentToday after one day.
190   /// @param amount Amount to withdraw.
191   /// @return Returns if amount is under daily limit.
192   function isUnderLimit(uint amount) internal returns (bool) {
193     if (now > lastDay.add(24 hours)) {
194       lastDay = now;
195       spentToday = 0;
196     }
197     // not using safe math because we don't want to throw;
198     if (spentToday + amount > dailyLimit || spentToday + amount < spentToday) {
199       return false;
200     }
201     return true;
202   }
203 
204 }