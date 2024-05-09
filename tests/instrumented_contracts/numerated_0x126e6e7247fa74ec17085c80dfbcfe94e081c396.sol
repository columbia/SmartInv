1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
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
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
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
41         require(b <= a, "SafeMath: subtraction overflow");
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
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 
68 interface INMR {
69 
70     /* ERC20 Interface */
71 
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
87 
88     /* NMR Special Interface */
89 
90     // used for user balance management
91     function withdraw(address _from, address _to, uint256 _value) external returns(bool ok);
92 
93     // used for migrating active stakes
94     function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) external returns (bool ok);
95 
96     // used for disabling token upgradability
97     function createRound(uint256, uint256, uint256, uint256) external returns (bool ok);
98 
99     // used for upgrading the token delegate logic
100     function createTournament(uint256 _newDelegate) external returns (bool ok);
101 
102     // used like burn(uint256)
103     function mint(uint256 _value) external returns (bool ok);
104 
105     // used like burnFrom(address, uint256)
106     function numeraiTransfer(address _to, uint256 _value) external returns (bool ok);
107 
108     // used to check if upgrade completed
109     function contractUpgradable() external view returns (bool);
110 
111     function getTournament(uint256 _tournamentID) external view returns (uint256, uint256[] memory);
112 
113     function getRound(uint256 _tournamentID, uint256 _roundID) external view returns (uint256, uint256, uint256);
114 
115     function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) external view returns (uint256, uint256, bool, bool);
116 
117 }
118 
119 
120 contract NMRUser {
121 
122     address internal constant _TOKEN = address(0x1776e1F26f98b1A5dF9cD347953a26dd3Cb46671);
123 
124     function _burn(uint256 _value) internal {
125         if (INMR(_TOKEN).contractUpgradable())
126             require(INMR(_TOKEN).transfer(address(0), _value));
127         else
128             require(INMR(_TOKEN).mint(_value), "burn not successful");
129     }
130 
131     function _burnFrom(address _from, uint256 _value) internal {
132         if (INMR(_TOKEN).contractUpgradable())
133             require(INMR(_TOKEN).transferFrom(_from, address(0), _value));
134         else
135             require(INMR(_TOKEN).numeraiTransfer(_from, _value), "burnFrom not successful");
136     }
137 
138 }
139 
140 
141 /**
142  * @title SpankJar
143  * @dev Contract that allows for spanking using NMR
144  */
145 contract SpankJar is NMRUser {
146     
147     using SafeMath for uint256;
148     
149     address public owner;
150     uint256 public ratio;
151     bool public isActive = true;
152     
153     constructor(uint256 _ratio) public {
154         ratio = _ratio;
155         owner = msg.sender;
156     }
157     
158     function() external payable {
159         require(isActive, 'already ended');
160     }
161     
162     event Ended(uint256 nmrBurned, uint256 ethBurned);
163     
164     function end() public {
165         require(msg.sender == owner, 'not sender');
166         require(isActive, 'already ended');
167         
168         uint256 punishment = getTotalPunishment();
169         uint256 balance = getRemainingBalance();
170         
171         _burn(punishment);
172         
173         require(INMR(_TOKEN).transfer(msg.sender, balance));
174         
175         isActive = false;
176         
177         emit Ended(punishment, address(this).balance);
178     }
179     
180     function getTotalPunishment() public view returns (uint256 punishment) {
181         return address(this).balance.mul(ratio);
182     }
183     
184     function getRemainingBalance() public view returns (uint256 balance) {
185         balance = INMR(_TOKEN).balanceOf(address(this));
186         uint256 punishment = getTotalPunishment();
187         balance = (punishment > balance) ? 0 : balance.sub(punishment);
188     }
189 }