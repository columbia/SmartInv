1 pragma solidity ^0.4.18;
2 
3 //import "./SafeMath.sol";
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   function Ownable() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     emit OwnershipTransferred(owner, newOwner);
110     owner = newOwner;
111   }
112 
113 }
114 
115 
116 /**
117  * @title Pausable
118  * @dev Base contract which allows children to implement an emergency stop mechanism.
119  */
120 contract Pausable is Ownable {
121   event Pause();
122   event Unpause();
123 
124   bool public paused = false;
125 
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is not paused.
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is paused.
137    */
138   modifier whenPaused() {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     emit Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     emit Unpause();
157   }
158 }
159 
160 //import "./ERC20.sol";
161 //import "./Pausable.sol";
162 
163 contract DateTime {
164         function getYear(uint timestamp) public constant returns (uint16);
165         function getMonth(uint timestamp) public constant returns (uint8);
166         function getDay(uint timestamp) public constant returns (uint8);
167 }
168 
169 contract ERC20Distributor {
170 
171     using SafeMath for uint256;
172 
173     address public owner;   
174     address public newOwnerCandidate;
175 
176     ERC20 public token;
177     uint public neededAmountTotal;
178     uint public releasedTokenTotal;
179 
180     address public approver;
181     uint public distributedBountyTotal;
182 
183 
184     /*
185     //
186     // address for DateTime should be changed before contract deploying.
187     //
188     */
189     //address public dateTimeAddr = 0xF0847087aAf608b4732be58b63151bDf4d548612;
190     //DateTime public dateTime = DateTime(dateTimeAddr);    
191     DateTime public dateTime;
192     
193     /*
194     //  events
195     */
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197     event OwnershipTransferRequsted(address indexed previousOwner, address indexed newOwner);
198 
199     event BountyDistributed(uint listCount, uint amount);
200    
201    /*
202    //   modifiers
203    */
204     modifier onlyOwner() {
205         require(msg.sender == owner);
206         _;
207     }
208     
209     /* constructor */
210     function ERC20Distributor(ERC20 _tokenAddr, address _dateTimeAddr, address _approver) public {
211         owner = msg.sender;
212         token = _tokenAddr;
213         dateTime = DateTime(_dateTimeAddr); 
214         approver = _approver;
215     }
216 
217     function requestTransferOwnership(address newOwner) public onlyOwner {
218         require(newOwner != address(0));
219         emit OwnershipTransferRequsted(owner, newOwner);
220         newOwnerCandidate = newOwner;
221     }
222 
223     function receiveTransferOwnership() public {
224         require(newOwnerCandidate == msg.sender);
225         emit OwnershipTransferred(owner, newOwnerCandidate);
226         owner = newOwnerCandidate;
227     }
228     
229     function transfer(address _to, uint _amount) public onlyOwner {
230         require(neededAmountTotal.add(_amount) <= token.balanceOf(this) && token.balanceOf(this) > 0);
231         token.transfer(_to, _amount);
232     }
233     
234     //should be set for distributeBounty function. and set appropriate approve amount for bounty. 
235     function setApprover(address _approver) public onlyOwner {
236         approver = _approver;
237     }
238     
239     //change processing ERC20 address
240     function changeTokenAddress(ERC20 _tokenAddr) public onlyOwner {
241         token = _tokenAddr;
242     }
243     
244     //should be checked approved amount and the sum of _amount
245     function distributeBounty(address[] _receiver, uint[] _amount) public payable onlyOwner {
246         require(_receiver.length == _amount.length);
247         uint bountyAmount;
248         
249         for (uint i = 0; i < _amount.length; i++) {
250             distributedBountyTotal += _amount[i];
251             bountyAmount += _amount[i];
252             token.transferFrom(approver, _receiver[i], _amount[i]);
253         }
254         emit BountyDistributed(_receiver.length, bountyAmount);
255     }
256 
257 
258     function viewContractHoldingToken() public view returns (uint _amount) {
259         return (token.balanceOf(this));
260     }
261 
262 }