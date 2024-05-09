1 // File: contracts-raw/CryptoSpin.sol
2 
3 //   ____                  _          ____        _
4 //  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __
5 // | |   | '__| | | | '_ \| __/ _ \  \___ \| '_ \| | '_ \
6 // | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |
7 //  \____|_|   \__, | .__/ \__\___/  |____/| .__/|_|_| |_|
8 //             |___/|_|                    |_|
9 
10 // Crypto Spin - Ethereum Slot Machine with Uncompromised RTP
11 // Copyright 2018 www.cryptospin.co
12 // In association with www.budapestgame.com
13 
14 pragma solidity ^0.4.18;
15 
16 // File: contracts-raw/Ownable.sol
17 
18 contract Ownable {
19         address public        owner;
20 
21         event OwnershipTransferred (address indexed prevOwner, address indexed newOwner);
22 
23         constructor () public {
24                 owner       = msg.sender;
25         }
26 
27         modifier onlyOwner () {
28                 require (msg.sender == owner);
29                 _;
30         }
31 
32         function transferOwnership (address newOwner) public onlyOwner {
33               require (newOwner != address (0));
34 
35               emit OwnershipTransferred (owner, newOwner);
36               owner     = newOwner;
37         }
38 }
39 
40 // File: contracts-raw/Pausable.sol
41 
42 contract Pausable is Ownable {
43         event Pause ();
44         event Unpause ();
45 
46         bool public paused        = false;
47 
48         modifier whenNotPaused () {
49                 require(!paused);
50                 _;
51         }
52 
53         modifier whenPaused () {
54                 require (paused);
55                 _;
56         }
57 
58         function pause () onlyOwner whenNotPaused public {
59                 paused  = true;
60                 emit Pause ();
61         }
62 
63         function unpause () onlyOwner whenPaused public {
64                 paused = false;
65                 emit Unpause ();
66         }
67 }
68 
69 // File: contracts-raw/SafeMath.sol
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76         function add (uint256 a, uint256 b) internal pure returns (uint256) {
77               uint256   c = a + b;
78               assert (c >= a);
79               return c;
80         }
81 
82         function sub (uint256 a, uint256 b) internal pure returns (uint256) {
83               assert (b <= a);
84               return a - b;
85         }
86 
87         function mul (uint256 a, uint256 b) internal pure returns (uint256) {
88                 if (a == 0) {
89                         return 0;
90                 }
91                 uint256 c = a * b;
92                 assert (c/a == b);
93                 return c;
94         }
95 
96         // Solidty automatically throws
97         // function div (uint256 a, uint256 b) internal pure returns (uint256) {
98         //       // assert(b > 0); // Solidity automatically throws when dividing by 0
99         //       uint256   c = a/b;
100         //       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101         //       return c;
102         // }
103 }
104 
105 // File: contracts-raw/CryptoSpin.sol
106 
107 //   ____                  _          ____        _
108 //  / ___|_ __ _   _ _ __ | |_ ___   / ___| _ __ (_)_ __
109 // | |   | '__| | | | '_ \| __/ _ \  \___ \| '_ \| | '_ \
110 // | |___| |  | |_| | |_) | || (_) |  ___) | |_) | | | | |
111 //  \____|_|   \__, | .__/ \__\___/  |____/| .__/|_|_| |_|
112 //             |___/|_|                    |_|
113 
114 // Crypto Spin - Ethereum Slot Machine with Uncompromised RTP
115 // Copyright 2018 www.cryptospin.co
116 // In association with www.budapestgame.com
117 
118 pragma solidity ^0.4.18;
119 
120 
121 
122 contract RSPTokenInterface {
123         function version () public pure returns (uint8);
124 
125         function buyTokens (address referral) public payable;
126         function sellTokens (uint256 amount) public;
127 
128         function transfer (address to, uint256 amount) public returns (bool);
129 
130         // function approve (address spender, uint256 amount) public returns (bool);
131         // function transferFrom (address from, address to, uint256 amount) public returns (bool);
132 }
133 
134 
135 contract CryptoSpin is Pausable {
136         using SafeMath for uint256;
137 
138         uint8 public    version             = 2;
139 
140         RSPTokenInterface public        rspToken;
141 
142         function _setRspTokenAddress (address addr) internal {
143                 RSPTokenInterface     candidate     = RSPTokenInterface (addr);
144                 require (candidate.version () >= 7);
145                 rspToken        = candidate;
146         }
147 
148         function setRspTokenAddress (address addr) public onlyOwner {
149                 _setRspTokenAddress (addr);
150         }
151 
152         // Constructor is not called multiple times, fortunately
153         // function CryptoSpin (address addr) public {
154         constructor (address addr) public {
155                 // Onwer should be set up and become msg.sender
156                 // During test, mint owner some amount
157                 // During deployment, onwer himself has to buy tokens to be fair
158                 // _mint (msg.sender, initialAmount);
159 
160                 if (addr != address(0)) {
161                         _setRspTokenAddress (addr);
162                 }
163         }
164 
165         event SlotToppedUp (address indexed gamer, uint256 nTokens);
166         event SlotToppedDown (address indexed gamer, uint256 nTokens);
167 
168         // mapping (address => uint256) public         weisPaid;
169         mapping (address => uint256) public         nTokensCredited;
170         mapping (address => uint256) public         nTokensWithdrawn;
171 
172         // Convenience
173         function playerInfo (address player) public view returns (uint256, uint256) {
174 
175                 return (
176                     nTokensCredited[player],
177                     nTokensWithdrawn[player]
178                 );
179         }
180 
181         // Escrew and start game
182         function _markCredit (address player, uint256 nTokens) internal {
183                 // Overflow check (unnecessarily)
184                 nTokensCredited[player]     = nTokensCredited[player].add (nTokens);
185                 emit SlotToppedUp (player, nTokens);
186         }
187 
188         function _markWithdraw (address player, uint256 nTokens) internal {
189                 // Overflow check (unnecessarily)
190                 nTokensWithdrawn[player]    = nTokensWithdrawn[player].add (nTokens);
191                 emit SlotToppedDown (player, nTokens);
192         }
193 
194         function buyAndTopup (address referral) whenNotPaused public payable {
195                 // The contract holds the token until refunding
196                 rspToken.buyTokens.value (msg.value) (referral);
197                 uint256     nTokens     = msg.value.mul (8000);
198 
199                 _markCredit (msg.sender, nTokens);
200         }
201 
202         function topdownAndCashout (address player, uint256 nTokens) onlyOwner public {
203                 uint256     nWeis       = nTokens/8000;
204                 uint256     nRspTokens  = nWeis.mul (5000);
205 
206                 rspToken.sellTokens (nRspTokens);
207 
208                 _markWithdraw (player, nTokens);
209                 player.transfer (nWeis);
210         }
211 
212         // EndGame
213         // function transferTokensTo (address to, uint256 nTokens) onlyOwner public {
214         //         rspToken.transfer (to, nTokens);
215         // }
216 
217         function markCredit (address player, uint256 nTokens) onlyOwner public {
218                 _markCredit (player, nTokens);
219         }
220 
221         function () public payable {}
222 
223 
224 }