1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract TokenDistributor is Ownable {
103     using SafeMath for uint;
104 
105     address public targetToken;
106     address[] public stakeHolders;
107     uint256 public maxStakeHolders;
108     event InsufficientTokenBalance( address indexed _token, uint256 _time );
109     event TokensDistributed( address indexed _token, uint256 _total, uint256 _time );
110 
111     constructor ( address _targetToken, uint256 _totalStakeHolders, address[] _stakeHolders) public Ownable() {
112         setTargetToken(_targetToken);
113         maxStakeHolders = _totalStakeHolders;
114         if (_stakeHolders.length > 0) {
115             for (uint256 count = 0; count < _stakeHolders.length && count < _totalStakeHolders; count++) {
116                 if (_stakeHolders[count] != 0x0) {
117                     _setStakeHolder(_stakeHolders[count]);
118                 }
119             }
120         }
121     }
122 
123     function isDistributionDue (address _token) public view returns (bool) {
124         return getTokenBalance(_token) > 1;
125     }
126 
127     function isDistributionDue () public view returns (bool) {
128         return getTokenBalance(targetToken) > 1;
129     }
130 
131     function countStakeHolders () public view returns (uint256) {
132         return stakeHolders.length;
133     }
134 
135     function getTokenBalance(address _token) public view returns (uint256) {
136         ERC20Basic token = ERC20Basic(_token);
137         return token.balanceOf(address(this));
138     }
139 
140     function getPortion (uint256 _total) public view returns (uint256) {
141         return _total.div(stakeHolders.length);
142     }
143 
144     function setTargetToken (address _targetToken) public onlyOwner returns (bool) {
145         if(_targetToken != 0x0 && targetToken == 0x0) {
146           targetToken = _targetToken;
147           return true;
148         }
149     }
150 
151     function _setStakeHolder (address _stakeHolder) internal onlyOwner returns (bool) {
152         require(countStakeHolders() < maxStakeHolders, "Max StakeHolders set");
153         stakeHolders.push(_stakeHolder);
154         return true;
155     }
156 
157     function _transfer (address _token, address _recipient, uint256 _value) internal {
158         ERC20Basic token = ERC20Basic(_token);
159         token.transfer(_recipient, _value);
160     }
161 
162     function distribute (address _token) public returns (bool) {
163         uint256 balance = getTokenBalance(_token);
164         uint256 perStakeHolder = getPortion(balance);
165 
166         if (balance < 1) {
167             emit InsufficientTokenBalance(_token, block.timestamp);
168             return false;
169         } else {
170             for (uint256 count = 0; count < stakeHolders.length; count++) {
171                 _transfer(_token, stakeHolders[count], perStakeHolder);
172             }
173 
174             uint256 newBalance = getTokenBalance(_token);
175             if (newBalance > 0 && getPortion(newBalance) == 0) {
176                 _transfer(_token, owner, newBalance);
177             }
178 
179             emit TokensDistributed(_token, balance, block.timestamp);
180             return true;
181         }
182     }
183 
184     function () public {
185         distribute(targetToken);
186     }
187 }
188 
189 contract WeightedTokenDistributor is TokenDistributor {
190     using SafeMath for uint;
191 
192     mapping( address => uint256) public stakeHoldersWeight;
193 
194     constructor ( address _targetToken, uint256 _totalStakeHolders, address[] _stakeHolders, uint256[] _weights) public
195     TokenDistributor(_targetToken, _totalStakeHolders, stakeHolders)
196     {
197         if (_stakeHolders.length > 0) {
198             for (uint256 count = 0; count < _stakeHolders.length && count < _totalStakeHolders; count++) {
199                 if (_stakeHolders[count] != 0x0) {
200                   _setStakeHolder( _stakeHolders[count], _weights[count] );
201                 }
202             }
203         }
204     }
205 
206     function getTotalWeight () public view returns (uint256 _total) {
207         for (uint256 count = 0; count < stakeHolders.length; count++) {
208             _total = _total.add(stakeHoldersWeight[stakeHolders[count]]);
209         }
210     }
211 
212     function getPortion (uint256 _total, uint256 _totalWeight, address _stakeHolder) public view returns (uint256) {
213         uint256 weight = stakeHoldersWeight[_stakeHolder];
214         return (_total.mul(weight)).div(_totalWeight);
215     }
216 
217     function getPortion (uint256 _total) public view returns (uint256) {
218         revert("Kindly indicate stakeHolder and totalWeight");
219     }
220 
221     function _setStakeHolder (address _stakeHolder, uint256 _weight) internal onlyOwner returns (bool) {
222         stakeHoldersWeight[_stakeHolder] = _weight;
223         require(super._setStakeHolder(_stakeHolder));
224         return true;
225     }
226 
227     function _setStakeHolder (address _stakeHolder) internal onlyOwner returns (bool) {
228         revert("Kindly set Weights for stakeHolder");
229     }
230 
231     function distribute (address _token) public returns (bool) {
232         uint256 balance = getTokenBalance(_token);
233         uint256 totalWeight = getTotalWeight();
234 
235         if (balance < 1) {
236             emit InsufficientTokenBalance(_token, block.timestamp);
237             return false;
238         } else {
239             for (uint256 count = 0; count < stakeHolders.length; count++) {
240                 uint256 perStakeHolder = getPortion(balance, totalWeight, stakeHolders[count]);
241                 _transfer(_token, stakeHolders[count], perStakeHolder);
242             }
243 
244             uint256 newBalance = getTokenBalance(_token);
245             if (newBalance > 0) {
246                 _transfer(_token, owner, newBalance);
247             }
248 
249             emit TokensDistributed(_token, balance, block.timestamp);
250             return true;
251         }
252     }
253 }