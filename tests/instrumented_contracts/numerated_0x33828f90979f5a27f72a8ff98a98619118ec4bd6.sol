1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeERC20
31  * @dev Wrappers around ERC20 operations that throw on failure.
32  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
33  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
34  */
35 library SafeERC20 {
36   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
37     assert(token.transfer(to, value));
38   }
39 
40   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
41     assert(token.transferFrom(from, to, value));
42   }
43 
44   function safeApprove(ERC20 token, address spender, uint256 value) internal {
45     assert(token.approve(spender, value));
46   }
47 }
48 
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that throw on error
53  */
54 library SafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, throws on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     if (a == 0) {
61       return 0;
62     }
63     uint256 c = a * b;
64     assert(c / a == b);
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers, truncating the quotient.
70   */
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   /**
79   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
80   */
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   /**
87   * @dev Adds two numbers, throws on overflow.
88   */
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 
97 /**
98  * @title Ownable
99  * @dev The Ownable contract has an owner address, and provides basic authorization control
100  * functions, this simplifies the implementation of "user permissions".
101  */
102 contract Ownable {
103   address public owner;
104 
105 
106   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108 
109   /**
110    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
111    * account.
112    */
113   function Ownable() public {
114     owner = msg.sender;
115   }
116 
117   /**
118    * @dev Throws if called by any account other than the owner.
119    */
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner {
130     require(newOwner != address(0));
131     emit OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 
135 }
136 
137 
138 contract Whitelisting is Ownable {
139     mapping(address => bool) public isInvestorApproved;
140 
141     event Approved(address indexed investor);
142     event Disapproved(address indexed investor);
143 
144     function approveInvestor(address toApprove) public onlyOwner {
145         isInvestorApproved[toApprove] = true;
146         emit Approved(toApprove);
147     }
148 
149     function approveInvestorsInBulk(address[] toApprove) public onlyOwner {
150         for (uint i=0; i<toApprove.length; i++) {
151             isInvestorApproved[toApprove[i]] = true;
152             emit Approved(toApprove[i]);
153         }
154     }
155 
156     function disapproveInvestor(address toDisapprove) public onlyOwner {
157         delete isInvestorApproved[toDisapprove];
158         emit Disapproved(toDisapprove);
159     }
160 
161     function disapproveInvestorsInBulk(address[] toDisapprove) public onlyOwner {
162         for (uint i=0; i<toDisapprove.length; i++) {
163             delete isInvestorApproved[toDisapprove[i]];
164             emit Disapproved(toDisapprove[i]);
165         }
166     }
167 }
168 
169 
170 /**
171  * @title TokenVesting
172  * @dev TokenVesting is a token holder contract that will allow a
173  * beneficiary to extract the tokens after a given release time
174  */
175 contract TokenVesting is Ownable {
176     using SafeERC20 for ERC20Basic;
177     using SafeMath for uint256;
178 
179     // ERC20 basic token contract being held
180     ERC20Basic public token;
181     // whitelisting contract being held
182     Whitelisting public whitelisting;
183 
184     struct VestingObj {
185         uint256 token;
186         uint256 releaseTime;
187     }
188 
189     mapping (address  => VestingObj[]) public vestingObj;
190 
191     uint256 public totalTokenVested;
192 
193     event AddVesting ( address indexed _beneficiary, uint256 token, uint256 _vestingTime);
194     event Release ( address indexed _beneficiary, uint256 token, uint256 _releaseTime);
195 
196     modifier checkZeroAddress(address _add) {
197         require(_add != address(0));
198         _;
199     }
200 
201     function TokenVesting(ERC20Basic _token, Whitelisting _whitelisting)
202         public
203         checkZeroAddress(_token)
204         checkZeroAddress(_whitelisting)
205     {
206         token = _token;
207         whitelisting = _whitelisting;
208     }
209 
210     function addVesting( address[] _beneficiary, uint256[] _token, uint256[] _vestingTime) 
211         external 
212         onlyOwner
213     {
214         require((_beneficiary.length == _token.length) && (_beneficiary.length == _vestingTime.length));
215         
216         for (uint i = 0; i < _beneficiary.length; i++) {
217             require(_vestingTime[i] > now);
218             require(checkZeroValue(_token[i]));
219             require(uint256(getBalance()) >= totalTokenVested.add(_token[i]));
220             vestingObj[_beneficiary[i]].push(VestingObj({
221                 token : _token[i],
222                 releaseTime : _vestingTime[i]
223             }));
224             totalTokenVested = totalTokenVested.add(_token[i]);
225             emit AddVesting(_beneficiary[i], _token[i], _vestingTime[i]);
226         }
227     }
228 
229     /**
230    * @notice Transfers tokens held by timelock to beneficiary.
231    */
232     function claim() external {
233         require(whitelisting.isInvestorApproved(msg.sender));
234         uint256 transferTokenCount = 0;
235         for (uint i = 0; i < vestingObj[msg.sender].length; i++) {
236             if (now >= vestingObj[msg.sender][i].releaseTime) {
237                 transferTokenCount = transferTokenCount.add(vestingObj[msg.sender][i].token);
238                 delete vestingObj[msg.sender][i];
239             }
240         }
241         require(transferTokenCount > 0);
242         token.safeTransfer(msg.sender, transferTokenCount);
243         emit Release(msg.sender, transferTokenCount, now);
244     }
245 
246     function getBalance() public view returns (uint256) {
247         return token.balanceOf(address(this));
248     }
249     
250     function checkZeroValue(uint256 value) internal returns(bool){
251         return value > 0;
252     }
253 }