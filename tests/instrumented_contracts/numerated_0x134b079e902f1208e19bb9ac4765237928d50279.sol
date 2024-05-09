1 pragma solidity 0.5.9;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract ERC20 {
33     function totalSupply() public view returns (uint256);
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     function allowance(address owner, address spender)
38     public view returns (uint256);
39 
40     function transferFrom(address from, address to, uint256 value)
41     public returns (bool);
42 
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49 }
50 
51 
52 /**
53  * @title SafeERC20
54  * @dev Wrappers around ERC20 operations that throw on failure.
55  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
56  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
57  */
58 library SafeERC20 {
59     function safeTransfer(ERC20 token, address to, uint256 value) internal {
60         require(token.transfer(to, value));
61     }
62 
63     function safeTransferFrom(
64         ERC20 token,
65         address from,
66         address to,
67         uint256 value
68     )
69     internal
70     {
71         require(token.transferFrom(from, to, value));
72     }
73 
74     function safeApprove(ERC20 token, address spender, uint256 value) internal {
75         require(token.approve(spender, value));
76     }
77 }
78 
79 
80 /**
81  * @title Ownable
82  * @dev The Ownable contract has an owner address, and provides basic authorization control
83  * functions, this simplifies the implementation of "user permissions".
84  */
85 contract Ownable {
86     address public owner;
87 
88 
89     event OwnershipRenounced(address indexed previousOwner);
90     event OwnershipTransferred(
91         address indexed previousOwner,
92         address indexed newOwner
93     );
94 
95 
96     /**
97      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
98      * account.
99      */
100     constructor() public {
101         owner = msg.sender;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param _newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address _newOwner) public onlyOwner {
118         _transferOwnership(_newOwner);
119     }
120 
121     /**
122      * @dev Transfers control of the contract to a newOwner.
123      * @param _newOwner The address to transfer ownership to.
124      */
125     function _transferOwnership(address _newOwner) internal {
126         require(_newOwner != address(0));
127         emit OwnershipTransferred(owner, _newOwner);
128         owner = _newOwner;
129     }
130 }
131 
132 
133 contract TokenTimelock is Ownable {
134     using SafeERC20 for ERC20;
135     using SafeMath for uint256;
136 
137     ERC20 public token;
138 
139     struct User {
140         uint deposit;
141         uint balance;
142         uint releaseTime;
143         uint step;
144     }
145 
146     mapping(address => User) public users;
147 
148     uint public releaseStep = 90 days;
149     uint public releaseStepCount = 8;
150     uint public releaseStepPercent = 12500;
151 
152     constructor(ERC20 _token) public {
153         token = _token;
154     }
155 
156     function addTokens(address _user, uint256 _value) onlyOwner external returns (bool) {
157         require(_user != address(0));
158         require(users[_user].deposit == 0);
159         require(_value > 0);
160 
161         token.safeTransferFrom(msg.sender, address(this), _value);
162 
163         users[_user].deposit = _value;
164         users[_user].balance = _value;
165         users[_user].releaseTime = now + 720 days;
166     }
167 
168 
169     function getTokens() external {
170         require(users[msg.sender].balance > 0);
171         uint currentStep = getCurrentStep(msg.sender);
172         require(currentStep > 0);
173         require(currentStep > users[msg.sender].step);
174 
175         if (currentStep == releaseStepCount) {
176             users[msg.sender].step = releaseStepCount;
177             token.safeTransfer(msg.sender, users[msg.sender].balance);
178             users[msg.sender].balance = 0;
179         } else {
180             uint p = releaseStepPercent * (currentStep - users[msg.sender].step);
181             uint val = _valueFromPercent(users[msg.sender].deposit, p);
182 
183             if (users[msg.sender].balance >= val) {
184                 users[msg.sender].balance = users[msg.sender].balance.sub(val);
185                 token.safeTransfer(msg.sender, val);
186             }
187 
188             users[msg.sender].step = currentStep;
189         }
190 
191     }
192 
193 
194     function getCurrentStep(address _user) public view returns (uint) {
195         require(users[_user].deposit != 0);
196         uint _id;
197         
198         if (users[_user].releaseTime >= now) {
199             uint _count = (users[_user].releaseTime - now) / releaseStep;
200             _count = _count == releaseStepCount ? _count : _count + 1;
201             _id = releaseStepCount - _count;
202         } else _id = releaseStepCount;
203 
204         return _id;
205     }
206     
207  
208      
209 
210     //1% - 1000, 10% - 10000 50% - 50000
211     function _valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
212         uint _amount = _value.mul(_percent).div(100000);
213         return (_amount);
214     }
215 
216     function getUser(address _user) public view returns(uint, uint, uint, uint){
217         return (users[_user].deposit, users[_user].balance, users[_user].step, users[_user].releaseTime);
218     }
219 }