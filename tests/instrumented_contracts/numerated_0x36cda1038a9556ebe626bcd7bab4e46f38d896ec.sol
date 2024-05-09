1 pragma solidity 0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     require(newOwner != address(0));      
66     owner = newOwner;
67   }
68 
69 }
70 contract ControllerInterface {
71 
72 
73   // State Variables
74   bool public paused;
75 
76   // Nutz functions
77   function babzBalanceOf(address _owner) constant returns (uint256);
78   function activeSupply() constant returns (uint256);
79   function burnPool() constant returns (uint256);
80   function powerPool() constant returns (uint256);
81   function totalSupply() constant returns (uint256);
82   function allowance(address _owner, address _spender) constant returns (uint256);
83 
84   function approve(address _owner, address _spender, uint256 _amountBabz) public;
85   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);
86   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);
87 
88   // Market functions
89   function floor() constant returns (uint256);
90   function ceiling() constant returns (uint256);
91 
92   function purchase(address _sender, uint256 _price) public payable returns (uint256, bool);
93   function sell(address _from, uint256 _price, uint256 _amountBabz) public;
94 
95   // Power functions
96   function powerBalanceOf(address _owner) constant returns (uint256);
97   function outstandingPower() constant returns (uint256);
98   function authorizedPower() constant returns (uint256);
99   function powerTotalSupply() constant returns (uint256);
100 
101   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
102   function downTick(uint256 _pos, uint256 _now) public;
103   function createDownRequest(address _owner, uint256 _amountPower) public;
104 }
105 
106 /**
107  * @title PullPayment
108  * @dev Base contract supporting async send for pull payments.
109  */
110 contract PullPayment is Ownable {
111   using SafeMath for uint256;
112 
113   struct Payment {
114     uint256 value;  // TODO: use compact storage
115     uint256 date;   //
116   }
117 
118   uint public dailyLimit = 1000000000000000000000;  // 1 ETH
119   uint public lastDay;
120   uint public spentToday;
121 
122   mapping(address => Payment) internal payments;
123 
124   modifier whenNotPaused () {
125     require(!ControllerInterface(owner).paused());
126      _;
127   }
128   function balanceOf(address _owner) constant returns (uint256 value) {
129     return payments[_owner].value;
130   }
131 
132   function paymentOf(address _owner) constant returns (uint256 value, uint256 date) {
133     value = payments[_owner].value;
134     date = payments[_owner].date;
135     return;
136   }
137 
138   /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
139   /// @param _dailyLimit Amount in wei.
140   function changeDailyLimit(uint _dailyLimit) public onlyOwner {
141       dailyLimit = _dailyLimit;
142   }
143 
144   function changeWithdrawalDate(address _owner, uint256 _newDate)  public onlyOwner {
145     // allow to withdraw immediately
146     // move witdrawal date more days into future
147     payments[_owner].date = _newDate;
148   }
149 
150   function asyncSend(address _dest) public payable onlyOwner {
151     require(msg.value > 0);
152     uint256 newValue = payments[_dest].value.add(msg.value);
153     uint256 newDate;
154     if (isUnderLimit(msg.value)) {
155       newDate = (payments[_dest].date > now) ? payments[_dest].date : now;
156     } else {
157       newDate = now.add(3 days);
158     }
159     spentToday = spentToday.add(msg.value);
160     payments[_dest] = Payment(newValue, newDate);
161   }
162 
163 
164   function withdraw() public whenNotPaused {
165     address untrustedRecipient = msg.sender;
166     uint256 amountWei = payments[untrustedRecipient].value;
167 
168     require(amountWei != 0);
169     require(now >= payments[untrustedRecipient].date);
170     require(this.balance >= amountWei);
171 
172     payments[untrustedRecipient].value = 0;
173 
174     untrustedRecipient.transfer(amountWei);
175   }
176 
177   /*
178    * Internal functions
179    */
180   /// @dev Returns if amount is within daily limit and resets spentToday after one day.
181   /// @param amount Amount to withdraw.
182   /// @return Returns if amount is under daily limit.
183   function isUnderLimit(uint amount) internal returns (bool) {
184     if (now > lastDay.add(24 hours)) {
185       lastDay = now;
186       spentToday = 0;
187     }
188     // not using safe math because we don't want to throw;
189     if (spentToday + amount > dailyLimit || spentToday + amount < spentToday) {
190       return false;
191     }
192     return true;
193   }
194 
195 }