1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract Ownable {
54     mapping(address => bool) owners;
55     mapping(address => bool) managers;
56 
57     event OwnerAdded(address indexed newOwner);
58     event OwnerDeleted(address indexed owner);
59     event ManagerAdded(address indexed newOwner);
60     event ManagerDeleted(address indexed owner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owners[msg.sender] = true;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(isOwner(msg.sender));
75         _;
76     }
77 
78     modifier onlyManager() {
79         require(isManager(msg.sender));
80         _;
81     }
82 
83     function addOwner(address _newOwner) external onlyOwner {
84         require(_newOwner != address(0));
85         owners[_newOwner] = true;
86         emit OwnerAdded(_newOwner);
87     }
88 
89     function delOwner(address _owner) external onlyOwner {
90         require(owners[_owner]);
91         owners[_owner] = false;
92         emit OwnerDeleted(_owner);
93     }
94 
95 
96     function addManager(address _manager) external onlyOwner {
97         require(_manager != address(0));
98         managers[_manager] = true;
99         emit ManagerAdded(_manager);
100     }
101 
102     function delManager(address _manager) external onlyOwner {
103         require(managers[_manager]);
104         managers[_manager] = false;
105         emit ManagerDeleted(_manager);
106     }
107 
108     function isOwner(address _owner) public view returns (bool) {
109         return owners[_owner];
110     }
111 
112     function isManager(address _manager) public view returns (bool) {
113         return managers[_manager];
114     }
115 }
116 
117 
118 
119 
120 
121 
122 /**
123  * @title TokenTimelock
124  * @dev TokenTimelock is a token holder contract that will allow a
125  * beneficiary to extract the tokens after a given release time
126  */
127 contract Escrow is Ownable {
128     using SafeMath for uint256;
129 
130     struct Stage {
131         uint releaseTime;
132         uint percent;
133         bool transferred;
134     }
135 
136     mapping (uint => Stage) public stages;
137     uint public stageCount;
138 
139     uint public stopDay;
140     uint public startBalance = 0;
141 
142 
143     constructor(uint _stopDay) public {
144         stopDay = _stopDay;
145     }
146 
147     function() payable public {
148 
149     }
150 
151     //1% - 100, 10% - 1000 50% - 5000
152     function addStage(uint _releaseTime, uint _percent) onlyOwner public {
153         require(_percent >= 100);
154         require(_releaseTime > stages[stageCount].releaseTime);
155         stageCount++;
156         stages[stageCount].releaseTime = _releaseTime;
157         stages[stageCount].percent = _percent;
158     }
159 
160 
161     function getETH(uint _stage, address _to) onlyManager external {
162         require(stages[_stage].releaseTime < now);
163         require(!stages[_stage].transferred);
164         require(_to != address(0));
165 
166         if (startBalance == 0) {
167             startBalance = address(this).balance;
168         }
169 
170         uint val = valueFromPercent(startBalance, stages[_stage].percent);
171         stages[_stage].transferred = true;
172         _to.transfer(val);
173     }
174 
175 
176     function getAllETH(address _to) onlyManager external {
177         require(stopDay < now);
178         require(address(this).balance > 0);
179         require(_to != address(0));
180 
181         _to.transfer(address(this).balance);
182     }
183 
184 
185     function transferETH(address _to) onlyOwner external {
186         require(address(this).balance > 0);
187         require(_to != address(0));
188         _to.transfer(address(this).balance);
189     }
190 
191 
192     //1% - 100, 10% - 1000 50% - 5000
193     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
194         uint _amount = _value.mul(_percent).div(10000);
195         return (_amount);
196     }
197 
198     function setStopDay(uint _stopDay) onlyOwner external {
199         stopDay = _stopDay;
200     }
201 }