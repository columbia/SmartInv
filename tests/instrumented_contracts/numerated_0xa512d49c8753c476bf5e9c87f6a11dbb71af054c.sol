1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://eips.ethereum.org/EIPS/eip-20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 contract HarukaTest01 is IERC20 {
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     using SafeMath for uint256;
94 
95     enum ReleaseType {
96         Public,
97         Private1,
98         Private23,
99         Foundation,
100         Ecosystem,
101         Team,
102         Airdrop,
103         Contributor
104     }
105 
106     // Default is Public aka no locking
107     mapping (address => ReleaseType) private _accountType;
108 
109     // Required to calculate actual balance
110     // uint256 should be more than enough in lifetime
111     mapping (address => uint256) private _totalBalance;
112     mapping (address => uint256) private _spentBalance;
113 
114     mapping (address => mapping (address => uint256)) private _allowed;
115 
116     uint256 private _totalSupply = 10_000_000_000E18;
117 
118     string private _name = "Haruka Test Token #01";
119     string private _symbol = "HARUKAT01";
120     uint8 private _decimals = 18;
121 
122     address public owner;
123 
124     // Used when calculating available balance
125     // Will change after
126     uint256 public reference_time = 2000000000;
127 
128     modifier onlyOwner {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     constructor() public {
134         owner = msg.sender;
135 
136         // Initial balance
137         _totalBalance[owner] = _totalSupply;
138         _accountType[owner] = ReleaseType.Private1;
139     }
140 
141     function name() public view returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view returns (uint8) {
150         return _decimals;
151     }
152 
153     function transfer(address _to, uint256 _value) public returns (bool) {
154         _transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function approve(address _spender, uint256 _value) public returns (bool) {
159         require(_spender != address(0));
160 
161         _allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         _transfer(_from, _to, _value);
168         _allowed[_from][_to] = _allowed[_from][_to].sub(_value);
169         return true;
170     }
171 
172     function _transfer(address from, address to, uint256 value) internal {
173         require(value <= balanceOf(from));
174         require(to != address(0));
175 
176         _spentBalance[from] = _spentBalance[from].add(value);
177         _totalBalance[to] = _totalBalance[to].add(value);
178         emit Transfer(from, to, value);
179     }
180 
181     function totalSupply() public view returns (uint256) {
182         return _totalSupply;
183     }
184 
185     // For ERC20 compatible clients, show current available balance instead of total balance
186     // This is also called in other functions to get the balance
187     // SafeMath should be unnecessary as all calculations should be already "safe"
188     // May lose precision due to truncating but it only loses fraction of E-18 so should be safe to ignore
189     // Overflow should be impossible as uint256 has E+77 and total supply has only E+28
190     // For complete readable schedule, please refer to official documents
191     function balanceOf(address _owner) public view returns (uint256) {
192         // Type of address
193         ReleaseType _type = _accountType[_owner];
194         uint256 balance = _totalBalance[_owner].sub(_spentBalance[_owner]);
195 
196         // Contract owner is exempt from "before release" check to be able to make initial distribution
197         // Contract owner is also exempt from locking
198         if (_owner == owner) {
199             return balance;
200         }
201 
202         // Elapsed time since release
203         uint256 elapsed = now - reference_time;
204         // Before release
205         if (elapsed < 0) {
206             return 0;
207         }
208         // Shortcut: after complete unlock
209         if (elapsed >= 21 * 30 minutes) {
210             return balance;
211         }
212 
213         // Available amount for each type of address
214         if (_type == ReleaseType.Public) {
215             // No locking
216             return balance;
217         } else if (_type == ReleaseType.Private1) {
218             if (elapsed < 3 * 30 minutes) {
219                 return 0;
220             } else if (elapsed < 6 * 30 minutes) {
221                 return balance / 6;
222             } else if (elapsed < 9 * 30 minutes) {
223                 return balance * 2 / 6;
224             } else if (elapsed < 12 * 30 minutes) {
225                 return balance * 3 / 6;
226             } else if (elapsed < 15 * 30 minutes) {
227                 return balance * 4 / 6;
228             } else if (elapsed < 18 * 30 minutes) {
229                 return balance * 5 / 6;
230             } else {
231                 return balance;
232             }
233         } else if (_type == ReleaseType.Private23) {
234             if (elapsed < 6 * 30 minutes) {
235                 return 0;
236             } else if (elapsed < 9 * 30 minutes) {
237                 return balance / 4;
238             } else if (elapsed < 12 * 30 minutes) {
239                 return balance * 2 / 4;
240             } else if (elapsed < 15 * 30 minutes) {
241                 return balance * 3 / 4;
242             } else {
243                 return balance;
244             }
245         } else if (_type == ReleaseType.Foundation) {
246             if (elapsed < 3 * 30 minutes) {
247                 return 0;
248             } else if (elapsed < 6 * 30 minutes) {
249                 return balance * 3 / 20;
250             } else if (elapsed < 9 * 30 minutes) {
251                 return balance * 6 / 20;
252             } else if (elapsed < 12 * 30 minutes) {
253                 return balance * 9 / 20;
254             } else if (elapsed < 15 * 30 minutes) {
255                 return balance * 12 / 20;
256             } else if (elapsed < 18 * 30 minutes) {
257                 return balance * 15 / 20;
258             } else if (elapsed < 21 * 30 minutes) {
259                 return balance * 18 / 20;
260             } else {
261                 return balance;
262             }
263         } else if (_type == ReleaseType.Ecosystem) {
264             if (elapsed < 3 * 30 minutes) {
265                 return balance * 5 / 30;
266             } else if (elapsed < 6 * 30 minutes) {
267                 return balance * 10 / 30;
268             } else if (elapsed < 9 * 30 minutes) {
269                 return balance * 15 / 30;
270             } else if (elapsed < 12 * 30 minutes) {
271                 return balance * 18 / 30;
272             } else if (elapsed < 15 * 30 minutes) {
273                 return balance * 21 / 30;
274             } else if (elapsed < 18 * 30 minutes) {
275                 return balance * 24 / 30;
276             } else if (elapsed < 21 * 30 minutes) {
277                 return balance * 27 / 30;
278             } else {
279                 return balance;
280             }
281         } else if (_type == ReleaseType.Team) {
282             if (elapsed < 12 * 30 minutes) {
283                 return 0;
284             } else if (elapsed < 15 * 30 minutes) {
285                 return balance / 4;
286             } else if (elapsed < 18 * 30 minutes) {
287                 return balance * 2 / 4;
288             } else if (elapsed < 21 * 30 minutes) {
289                 return balance * 3 / 4;
290             } else {
291                 return balance;
292             }
293         } else if (_type == ReleaseType.Airdrop) {
294             if (elapsed < 3 * 30 minutes) {
295                 return balance / 2;
296             } else {
297                 return balance;
298             }
299         } else if (_type == ReleaseType.Contributor) {
300             if (elapsed < 12 * 30 minutes) {
301                 return 0;
302             } else if (elapsed < 15 * 30 minutes) {
303                 return balance / 4;
304             } else if (elapsed < 18 * 30 minutes) {
305                 return balance * 2 / 4;
306             } else if (elapsed < 21 * 30 minutes) {
307                 return balance * 3 / 4;
308             } else {
309                 return balance;
310             }
311         }
312 
313         // For unknown type which is quite impossible, return zero
314         return 0;
315 
316     }
317 
318     // Total balance including locked part
319     function totalBalanceOf(address _owner) public view returns (uint256) {
320         return _totalBalance[_owner].sub(_spentBalance[_owner]);
321     }
322 
323     // Allowance is not affected by locking
324     function allowance(address _owner, address _spender) public view returns (uint256) {
325         return _allowed[_owner][_spender];
326     }
327 
328     // Set the release type of specified address
329     // Only contract owner could call this
330     function setReleaseType(address _target, ReleaseType _type) public onlyOwner {
331         require(_target != address(0));
332         _accountType[_target] = _type;
333     }
334 
335     // Set reference time
336     // Only contract owner could call this
337     function setReferenceTime(uint256 newTime) public onlyOwner {
338         reference_time = newTime;
339     }
340 
341     // Contract owner transfer
342     // Note that only current contract owner and "Public" addresses are exempt from locking
343     function ownerTransfer(address newOwner) public onlyOwner {
344         require(newOwner != address(0));
345         emit OwnershipTransferred(owner, newOwner);
346         owner = newOwner;
347     }
348 }