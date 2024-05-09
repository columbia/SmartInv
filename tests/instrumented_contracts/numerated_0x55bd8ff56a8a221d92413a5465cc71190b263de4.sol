1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5     address public newOwner;
6     
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8   
9     constructor() public {
10         owner = msg.sender;
11     }
12     
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17     
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26         newOwner = address(0);
27     }
28 }
29 
30 
31 
32 
33 
34 
35 
36 contract ReferContractInterface {
37     function decrement(address _who) public;
38     function mint(address _to, uint _value) public;
39     function getBalance(address _who) public view returns(uint);
40 }
41 
42 contract ReferConstants {
43     uint public constant FIRST_USER_CUT = 40;
44     uint public constant SECOND_USER_CUT = 25;
45     uint public constant THIRD_USER_CUT = 15;
46     uint public constant FOURTH_USER_CUT = 10;
47     uint public constant OWNER_CUT = 10;
48     event Bought(address user, address directParent, address indirectParent, uint money, uint tokens, uint level);
49     event LevelUpdated(address user, uint money, uint level);
50     
51     using SafeMath for uint;
52 }
53 
54 contract ReferContract is ReferConstants, Ownable {
55     ReferContractInterface referContractInterface;
56     uint public baseRate;
57     
58     mapping (address => uint) public etherBalance;
59     mapping (address => address) public userReferrer;
60     mapping (address => uint8) public userLevel;
61     mapping (address => uint) public tokensBought;
62     
63     constructor(address _tokenAddress) public {
64         referContractInterface = ReferContractInterface(_tokenAddress);
65         baseRate = 3000000000000000;
66         // to be consistent with game
67         userReferrer[owner] = owner;
68         userLevel[owner] = 4;
69     }
70     
71      // Update only if contract is not getting traction or got more
72      // traction that initially thought.
73      // increase the price if there is huge traffic to compensate more people
74      // decrease the price if there is less traffic to attract more users.
75     function updateRate(uint _newRate) onlyOwner public {
76         require(baseRate != 0);
77         // rate shouldn't be less than half or more than twice.
78         require(_newRate.mul(2) > baseRate && baseRate.mul(2) > _newRate);
79         baseRate = _newRate;
80     }
81     
82     function getRate(uint level) public view returns (uint) {
83         if (level == 4) {
84             return baseRate.mul(6);
85         } else if (level == 3) {
86             return baseRate.mul(5);
87         } else if (level == 2) {
88             return baseRate.mul(3);
89         } else if (level == 1) {
90             return baseRate.mul(2);
91         } else {
92             return baseRate.mul(6);
93         } 
94     }
95     
96     function fundAccount(address ref, uint eth, uint level) internal {
97         if (ref != address(0x0) && userLevel[ref] >= level) {
98             etherBalance[ref] += eth;
99         } else {
100             etherBalance[owner] += eth;
101         }
102     }
103     
104     function distributeMoney(address ref, address parent1, uint money) internal {
105         // since we are calculating percentage which will be 
106         // (money * x)/100
107         money = money.div(100);
108         
109         fundAccount(ref, money.mul(FIRST_USER_CUT), 1);
110         fundAccount(parent1, money.mul(SECOND_USER_CUT), 2);
111         fundAccount(userReferrer[parent1], money.mul(THIRD_USER_CUT), 3);
112         fundAccount(userReferrer[userReferrer[parent1]], money.mul(FOURTH_USER_CUT), 4);
113         fundAccount(owner, money.mul(OWNER_CUT), 0);
114     }
115     
116     function buyReferTokens(address ref, uint8 level) payable public {
117         require(level > 0 && level < 5);
118         
119         if (userLevel[msg.sender] == 0) { // new user
120             userLevel[msg.sender] = level;
121             if (getTokenBalance(ref) < 1) {  // The referee doesn't have a token 
122                 ref = owner; // change referee
123             }
124             userReferrer[msg.sender] = ref; // permanently set owner as the referrer
125             referContractInterface.decrement(userReferrer[msg.sender]);
126         } else { // old user
127             require(userLevel[msg.sender] == level);
128             if (getTokenBalance(userReferrer[msg.sender]) < 1) { // The referee doesn't have a token
129                 ref = owner; // only change the parent but don't change gradparents
130             } else {
131                 ref = userReferrer[msg.sender];
132             }
133             referContractInterface.decrement(ref);
134         }
135         
136         uint tokens = msg.value.div(getRate(level));
137         require(tokens >= 5);
138         referContractInterface.mint(msg.sender, tokens);
139         distributeMoney(ref, userReferrer[userReferrer[msg.sender]] , msg.value);
140         tokensBought[msg.sender] += tokens;
141         emit Bought(msg.sender, ref, userReferrer[userReferrer[msg.sender]], msg.value, tokens, level);
142     }
143     
144     function upgradeLevel(uint8 level) payable public {
145         require(level <= 4);
146         require(userLevel[msg.sender] != 0 && userLevel[msg.sender] < level);
147         uint rateDiff = getRate(level).sub(getRate(userLevel[msg.sender]));
148         uint toBePaid = rateDiff.mul(tokensBought[msg.sender]);
149         require(msg.value >= toBePaid);
150         userLevel[msg.sender] = level;
151         distributeMoney(userReferrer[msg.sender], userReferrer[userReferrer[msg.sender]] , msg.value);
152         emit LevelUpdated(msg.sender, msg.value, level);
153     }
154     
155     function getAmountToUpdate(uint8 level) view public returns (uint) {
156         uint rate = getRate(level).mul(tokensBought[msg.sender]);
157         uint ratePaid = getRate(userLevel[msg.sender]).mul(tokensBought[msg.sender]);
158         return rate.sub(ratePaid);
159     }
160     
161     function withdraw() public {
162         uint amount = etherBalance[msg.sender];
163         etherBalance[msg.sender] = 0;
164         msg.sender.transfer(amount);
165     }
166     
167     function getTokenBalance(address _who) public view returns(uint) {
168         return referContractInterface.getBalance(_who);
169     }
170 }
171 
172 library SafeMath {
173     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
174         if (a == 0) {
175             return 0;
176         }
177         
178         c = a * b;
179         assert(c / a == b);
180         return c;
181     }
182     
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a / b;
185     }
186     
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         assert(b <= a);
189         return a - b;
190     }
191     
192     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
193         c = a + b;
194         assert(c >= a);
195         return c;
196     }
197 }