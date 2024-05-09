1 pragma solidity ^0.4.24;
2 
3 // File: contracts\utils\SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49   /**
50   * @dev gives square root of given x.
51   */
52   function sqrt(uint256 x)
53     internal
54     pure
55     returns (uint256 y)
56   {
57     uint256 z = ((add(x,1)) / 2);
58     y = x;
59     while (z < y)
60     {
61         y = z;
62         z = ((add((x / z),z)) / 2);
63     }
64   }
65 
66   /**
67   * @dev gives square. multiplies x by x
68   */
69   function sq(uint256 x)
70     internal
71     pure
72     returns (uint256)
73   {
74     return (mul(x,x));
75   }
76 
77   /**
78   * @dev x to the power of y
79   */
80   function pwr(uint256 x, uint256 y)
81     internal
82     pure
83     returns (uint256)
84   {
85     if (x==0)
86         return (0);
87     else if (y==0)
88         return (1);
89     else
90     {
91         uint256 z = x;
92         for (uint256 i=1; i < y; i++)
93             z = mul(z,x);
94         return (z);
95     }
96   }
97 }
98 
99 // File: contracts\FundCenter.sol
100 
101 // This contract only keep user's deposit & withdraw records. 
102 // we use a private chain to maintain users' balance book. 
103 // All user's spending and earning records are kept in the private chain. 
104 contract FundCenter {
105     using SafeMath for *;
106 
107     string constant public name = "FundCenter";
108     string constant public symbol = "FundCenter";
109     
110     event BalanceRecharge(address indexed sender, uint256 amount, uint64 evented_at); // deposit
111     event BalanceWithdraw(address indexed sender, uint256 amount, bytes txHash, uint64 evented_at); //withdraw
112 
113     uint lowestRecharge = 0.1 ether; // lowest deposit amount 
114     uint lowestWithdraw = 0.1 ether; //lowest withdraw amount
115     bool enable = true;
116     address public CEO;
117     address public COO;
118     address public gameAddress; 
119 
120     mapping(address => uint) public recharges; // deposit records 
121     mapping(address => uint) public withdraws; // withdraw records 
122 
123     modifier onlyCEO {
124         require(CEO == msg.sender, "Only CEO can operate.");
125         _;
126     }
127 
128     modifier onlyCOO {
129         require(COO == msg.sender, "Only COO can operate.");
130         _;
131     }
132     
133     modifier onlyEnable {
134         require(enable == true, "The service is closed.");
135         _;
136     }
137 
138     constructor (address _COO) public {
139         CEO = msg.sender;
140         COO = _COO;
141     }
142 
143     function recharge() public payable onlyEnable {
144         require(msg.value >= lowestRecharge, "The minimum recharge amount does not meet the requirements.");
145         recharges[msg.sender] = recharges[msg.sender].add(msg.value); // only records deposit amount. 
146         emit BalanceRecharge(msg.sender, msg.value, uint64(now));
147     }
148     
149     function() public payable onlyEnable {
150         require(msg.sender == gameAddress, "only receive eth from game address"); 
151     }
152     
153     function setGameAddress(address _gameAddress) public onlyCOO {
154         gameAddress = _gameAddress; 
155     }
156 
157     function withdrawBalanceFromServer(address _to, uint _amount, bytes _txHash) public onlyCOO onlyEnable {
158         require(address(this).balance >= _amount, "Insufficient balance.");
159         _to.transfer(_amount);
160         withdraws[_to] = withdraws[_to].add(_amount); // record withdraw amount 
161         emit BalanceWithdraw(_to, _amount, _txHash, uint64(now));
162     }
163 
164 
165     function withdrawBalanceFromAdmin(uint _amount) public onlyCOO {
166         require(address(this).balance >= _amount, "Insufficient balance.");
167         CEO.transfer(_amount);
168     }
169 
170     function setLowestClaim(uint _lowestRecharge, uint _lowestWithdraw) public onlyCOO {
171         lowestRecharge = _lowestRecharge;
172         lowestWithdraw = _lowestWithdraw;
173     }
174 
175     function setEnable(bool _enable) public onlyCOO {
176         enable = _enable;
177     }
178 
179     function transferCEO(address _CEOAddress) public onlyCEO {
180         CEO = _CEOAddress;
181     }
182 
183     function setCOO(address _COOAddress) public onlyCEO {
184         COO = _COOAddress;
185     }
186 }