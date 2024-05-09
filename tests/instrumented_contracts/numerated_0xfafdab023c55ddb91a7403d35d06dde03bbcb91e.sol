1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
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
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract Claimable is Ownable {
104   address public pendingOwner;
105 
106   /**
107    * @dev Modifier throws if called by any account other than the pendingOwner.
108    */
109   modifier onlyPendingOwner() {
110     require(msg.sender == pendingOwner);
111     _;
112   }
113 
114   /**
115    * @dev Allows the current owner to set the pendingOwner address.
116    * @param newOwner The address to transfer ownership to.
117    */
118   function transferOwnership(address newOwner) onlyOwner public {
119     pendingOwner = newOwner;
120   }
121 
122   /**
123    * @dev Allows the pendingOwner address to finalize the transfer.
124    */
125   function claimOwnership() onlyPendingOwner public {
126     emit OwnershipTransferred(owner, pendingOwner);
127     owner = pendingOwner;
128     pendingOwner = address(0);
129   }
130 }
131 
132 contract SimpleFlyDropToken is Claimable {
133     using SafeMath for uint256;
134 
135     ERC20 internal erc20tk;
136 
137     function setToken(address _token) onlyOwner public {
138         require(_token != address(0));
139         erc20tk = ERC20(_token);
140     }
141 
142     /**
143      * @dev Send tokens to other multi addresses in one function
144      *
145      * @param _destAddrs address The addresses which you want to send tokens to
146      * @param _values uint256 the amounts of tokens to be sent
147      */
148     function multiSend(address[] _destAddrs, uint256[] _values) onlyOwner public returns (uint256) {
149         require(_destAddrs.length == _values.length);
150 
151         uint256 i = 0;
152         for (; i < _destAddrs.length; i = i.add(1)) {
153             if (!erc20tk.transfer(_destAddrs[i], _values[i])) {
154                 break;
155             }
156         }
157 
158         return (i);
159     }
160 }
161 
162 contract DelayedClaimable is Claimable {
163 
164   uint256 public end;
165   uint256 public start;
166 
167   /**
168    * @dev Used to specify the time period during which a pending
169    * owner can claim ownership.
170    * @param _start The earliest time ownership can be claimed.
171    * @param _end The latest time ownership can be claimed.
172    */
173   function setLimits(uint256 _start, uint256 _end) onlyOwner public {
174     require(_start <= _end);
175     end = _end;
176     start = _start;
177   }
178 
179   /**
180    * @dev Allows the pendingOwner address to finalize the transfer, as long as it is called within
181    * the specified start and end time.
182    */
183   function claimOwnership() onlyPendingOwner public {
184     require((block.number <= end) && (block.number >= start));
185     emit OwnershipTransferred(owner, pendingOwner);
186     owner = pendingOwner;
187     pendingOwner = address(0);
188     end = 0;
189   }
190 
191 }
192 
193 contract FlyDropTokenMgr is DelayedClaimable {
194     using SafeMath for uint256;
195 
196     address[] dropTokenAddrs;
197     SimpleFlyDropToken currentDropTokenContract;
198     // mapping(address => mapping (address => uint256)) budgets;
199 
200     /**
201      * @dev Send tokens to other multi addresses in one function
202      *
203      * @param _rand a random index for choosing a FlyDropToken contract address
204      * @param _from address The address which you want to send tokens from
205      * @param _value uint256 the amounts of tokens to be sent
206      * @param _token address the ERC20 token address
207      */
208     function prepare(uint256 _rand,
209                      address _from,
210                      address _token,
211                      uint256 _value) onlyOwner public returns (bool) {
212         require(_token != address(0));
213         require(_from != address(0));
214         require(_rand > 0);
215 
216         if (ERC20(_token).allowance(_from, this) < _value) {
217             return false;
218         }
219 
220         if (_rand > dropTokenAddrs.length) {
221             SimpleFlyDropToken dropTokenContract = new SimpleFlyDropToken();
222             dropTokenAddrs.push(address(dropTokenContract));
223             currentDropTokenContract = dropTokenContract;
224         } else {
225             currentDropTokenContract = SimpleFlyDropToken(dropTokenAddrs[_rand.sub(1)]);
226         }
227 
228         currentDropTokenContract.setToken(_token);
229         return ERC20(_token).transferFrom(_from, currentDropTokenContract, _value);
230         // budgets[_token][_from] = budgets[_token][_from].sub(_value);
231         // return itoken(_token).approveAndCall(currentDropTokenContract, _value, _extraData);
232         // return true;
233     }
234 
235     // function setBudget(address _token, address _from, uint256 _value) onlyOwner public {
236     //     require(_token != address(0));
237     //     require(_from != address(0));
238 
239     //     budgets[_token][_from] = _value;
240     // }
241 
242     /**
243      * @dev Send tokens to other multi addresses in one function
244      *
245      * @param _destAddrs address The addresses which you want to send tokens to
246      * @param _values uint256 the amounts of tokens to be sent
247      */
248     function flyDrop(address[] _destAddrs, uint256[] _values) onlyOwner public returns (uint256) {
249         require(address(currentDropTokenContract) != address(0));
250         return currentDropTokenContract.multiSend(_destAddrs, _values);
251     }
252 
253 }
254 
255 contract ERC20Basic {
256   function totalSupply() public view returns (uint256);
257   function balanceOf(address who) public view returns (uint256);
258   function transfer(address to, uint256 value) public returns (bool);
259   event Transfer(address indexed from, address indexed to, uint256 value);
260 }
261 
262 contract ERC20 is ERC20Basic {
263   function allowance(address owner, address spender)
264     public view returns (uint256);
265 
266   function transferFrom(address from, address to, uint256 value)
267     public returns (bool);
268 
269   function approve(address spender, uint256 value) public returns (bool);
270   event Approval(
271     address indexed owner,
272     address indexed spender,
273     uint256 value
274   );
275 }