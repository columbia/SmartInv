1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     mapping(address => bool)  internal owners;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() public{
67         owners[msg.sender] = true;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owners[msg.sender] == true);
75         _;
76     }
77 
78     function addOwner(address newAllowed) onlyOwner public {
79         owners[newAllowed] = true;
80     }
81 
82     function removeOwner(address toRemove) onlyOwner public {
83         owners[toRemove] = false;
84     }
85 
86     function isOwner() public view returns(bool){
87         return owners[msg.sender] == true;
88     }
89 
90 }
91 
92 
93 contract FoxicoPool is Ownable {
94   using SafeMath for uint256;
95 
96   mapping (address => uint256) public deposited;
97   mapping (address => uint256) public claimed;
98 
99 
100   // start and end timestamps where investments are allowed (both inclusive)
101   uint256 public startTime;
102   uint256 public endTime;
103 
104   // address where funds are collected
105   address public wallet;
106 
107   bool public refundEnabled;
108 
109   event Refunded(address indexed beneficiary, uint256 weiAmount);
110   event AddDeposit(address indexed beneficiary, uint256 value);
111 
112   function setStartTime(uint256 _startTime) public onlyOwner{
113     startTime = _startTime;
114   }
115 
116   function setEndTime(uint256 _endTime) public onlyOwner{
117     endTime = _endTime;
118   }
119 
120   function setWallet(address _wallet) public onlyOwner{
121     wallet = _wallet;
122   }
123 
124   function setRefundEnabled(bool _refundEnabled) public onlyOwner{
125     refundEnabled = _refundEnabled;
126   }
127 
128   function FoxicoPool(uint256 _startTime, uint256 _endTime, address _wallet) public {
129     require(_startTime >= now);
130     require(_endTime >= _startTime);
131     require(_wallet != address(0));
132 
133     startTime = _startTime;
134     endTime = _endTime;
135     wallet = _wallet;
136     refundEnabled = false;
137   }
138 
139   function () external payable {
140     deposit(msg.sender);
141   }
142 
143   function addFunds() public payable onlyOwner {}
144 
145   
146   function deposit(address beneficiary) public payable {
147     require(beneficiary != address(0));
148     require(validPurchase());
149 
150     deposited[beneficiary] = deposited[beneficiary].add(msg.value);
151 
152     uint256 weiAmount = msg.value;
153     emit AddDeposit(beneficiary, weiAmount);
154   }
155 
156   
157   function validPurchase() internal view returns (bool) {
158     bool withinPeriod = now >= startTime && now <= endTime;
159     bool nonZeroPurchase = msg.value != 0;
160     return withinPeriod && nonZeroPurchase;
161   }
162 
163 
164   // send ether to the fund collection wallet
165   function forwardFunds() onlyOwner public {
166     require(now >= endTime);
167     wallet.transfer(address(this).balance);
168   }
169 
170 
171   function refundWallet(address _wallet) onlyOwner public {
172     refundFunds(_wallet);
173   }
174 
175   function claimRefund() public {
176     refundFunds(msg.sender);
177   }
178 
179   function refundFunds(address _wallet) internal {
180     require(_wallet != address(0));
181     require(deposited[_wallet] > 0);
182     require(now < endTime);
183 
184     uint256 depositedValue = deposited[_wallet];
185     deposited[_wallet] = 0;
186     
187     _wallet.transfer(depositedValue);
188     
189     emit Refunded(_wallet, depositedValue);
190 
191   }
192 
193 }