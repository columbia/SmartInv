1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeERC20
29  * @dev Wrappers around ERC20 operations that throw on failure.
30  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
31  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
32  */
33 library SafeERC20 {
34   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
35     assert(token.transfer(to, value));
36   }
37 
38   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
39     assert(token.transferFrom(from, to, value));
40   }
41 
42   function safeApprove(ERC20 token, address spender, uint256 value) internal {
43     assert(token.approve(spender, value));
44   }
45 }
46 
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   constructor() public {
60     owner = msg.sender;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 
83 /**
84  * @title SafeMath
85  * @dev Math operations with safety checks that throw on error
86  */
87 library SafeMath {
88 
89   /**
90   * @dev Multiplies two numbers, throws on overflow.
91   */
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0) {
94       return 0;
95     }
96     uint256 c = a * b;
97     assert(c / a == b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   /**
112   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 }
128 
129 /**
130  * @title TokenVesting
131  * @dev TokenVesting is a token holder contract that will allow a
132  * beneficiary to extract the tokens after a given release time
133  */
134 contract TokenVesting is Ownable {
135     using SafeERC20 for ERC20Basic;
136     using SafeMath for uint256;
137 
138     // ERC20 basic token contract being held
139     ERC20Basic public token;
140 
141     struct VestingObj {
142         uint256 token;
143         uint256 releaseTime;
144     }
145 
146     mapping (address  => VestingObj[]) public vestingObj;
147 
148     uint256 public totalTokenVested;
149 
150     event AddVesting ( address indexed _beneficiary, uint256 token, uint256 _vestingTime);
151     event Release ( address indexed _beneficiary, uint256 token, uint256 _releaseTime);
152 
153     modifier checkZeroAddress(address _add) {
154         require(_add != address(0));
155         _;
156     }
157 
158     constructor(ERC20Basic _token)
159         public
160         checkZeroAddress(_token)
161     {
162         token = _token;
163     }
164 
165     function addVesting( address[] _beneficiary, uint256[] _token, uint256[] _vestingTime) 
166         external 
167         onlyOwner
168     {
169         require((_beneficiary.length == _token.length) && (_beneficiary.length == _vestingTime.length));
170         
171         for (uint i = 0; i < _beneficiary.length; i++) {
172             require(_vestingTime[i] > now);
173             require(checkZeroValue(_token[i]));
174             require(uint256(getBalance()) >= totalTokenVested.add(_token[i]));
175             vestingObj[_beneficiary[i]].push(VestingObj({
176                 token : _token[i],
177                 releaseTime : _vestingTime[i]
178             }));
179             totalTokenVested = totalTokenVested.add(_token[i]);
180             emit AddVesting(_beneficiary[i], _token[i], _vestingTime[i]);
181         }
182     }
183 
184     /**
185    * @notice Transfers tokens held by timelock to beneficiary.
186    */
187     function claim() external {
188         uint256 transferTokenCount = 0;
189         for (uint i = 0; i < vestingObj[msg.sender].length; i++) {
190             if (now >= vestingObj[msg.sender][i].releaseTime) {
191                 transferTokenCount = transferTokenCount.add(vestingObj[msg.sender][i].token);
192                 delete vestingObj[msg.sender][i];
193             }
194         }
195         require(transferTokenCount > 0);
196         token.safeTransfer(msg.sender, transferTokenCount);
197         emit Release(msg.sender, transferTokenCount, now);
198     }
199 
200     function getBalance() public view returns (uint256) {
201         return token.balanceOf(address(this));
202     }
203     
204     function checkZeroValue(uint256 value) internal pure returns(bool){
205         return value > 0;
206     }
207 }