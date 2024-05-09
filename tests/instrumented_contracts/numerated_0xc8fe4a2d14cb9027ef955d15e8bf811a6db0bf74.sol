1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Claimable is Ownable {
67   address public pendingOwner;
68 
69   /**
70    * @dev Modifier throws if called by any account other than the pendingOwner.
71    */
72   modifier onlyPendingOwner() {
73     require(msg.sender == pendingOwner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to set the pendingOwner address.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner public {
82     pendingOwner = newOwner;
83   }
84 
85   /**
86    * @dev Allows the pendingOwner address to finalize the transfer.
87    */
88   function claimOwnership() onlyPendingOwner public {
89     OwnershipTransferred(owner, pendingOwner);
90     owner = pendingOwner;
91     pendingOwner = 0x0;
92   }
93 }
94 
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public constant returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract PresaleOracles is Claimable {
103 /*
104  * PresaleOracles
105  * Simple Presale contract
106  * built by github.com/rstormsf Roman Storm
107  */
108     using SafeMath for uint256;
109     uint256 public startTime;
110     uint256 public endTime;
111     uint256 public cap;
112     uint256 public totalInvestedInWei;
113     uint256 public minimumContribution;
114     mapping(address => uint256) public investorBalances;
115     mapping(address => bool) public whitelist;
116     uint256 public investorsLength;
117     address public vault;
118     bool public isInitialized = false;
119     // TESTED by Roman Storm
120     function () public payable {
121         buy();
122     }
123     //TESTED by Roman Storm
124     function Presale() public {
125     }
126     //TESTED by Roman Storm
127     function initialize(uint256 _startTime, uint256 _endTime, uint256 _cap, uint256 _minimumContribution, address _vault) public onlyOwner {
128         require(!isInitialized);
129         require(_startTime != 0);
130         require(_endTime != 0);
131         require(_endTime > _startTime);
132         require(_cap != 0);
133         require(_minimumContribution != 0);
134         require(_vault != 0x0);
135         require(_cap > _minimumContribution);
136         startTime = _startTime;
137         endTime = _endTime;
138         cap = _cap;
139         isInitialized = true;
140         minimumContribution = _minimumContribution;
141         vault = _vault;
142     }
143     //TESTED by Roman Storm
144     event Contribution(address indexed investor, uint256 investorAmount, uint256 investorTotal, uint256 totalAmount);
145     function buy() public payable {
146         require(whitelist[msg.sender]);
147         require(isValidPurchase(msg.value));
148         require(isInitialized);
149         require(getTime() >= startTime && getTime() <= endTime);
150         address investor = msg.sender;
151         investorBalances[investor] += msg.value;
152         totalInvestedInWei += msg.value;
153         forwardFunds(msg.value);
154         Contribution(msg.sender, msg.value, investorBalances[investor], totalInvestedInWei);
155     }
156     
157     //TESTED by Roman Storm
158     function forwardFunds(uint256 _amount) internal {
159         vault.transfer(_amount);
160     }
161     //TESTED by Roman Storm
162     function claimTokens(address _token) public onlyOwner {
163         if (_token == 0x0) {
164             owner.transfer(this.balance);
165             return;
166         }
167     
168         ERC20Basic token = ERC20Basic(_token);
169         uint256 balance = token.balanceOf(this);
170         token.transfer(owner, balance);
171     }
172 
173     function getTime() internal view returns(uint256) {
174         return now;
175     }
176     //TESTED by Roman Storm
177     function isValidPurchase(uint256 _amount) public view returns(bool) {
178         bool nonZero = _amount > 0;
179         bool hasMinimumAmount = investorBalances[msg.sender].add(_amount) >= minimumContribution;
180         bool withinCap = totalInvestedInWei.add(_amount) <= cap;
181         return hasMinimumAmount && withinCap && nonZero;
182     }
183     //TESTED by Roman Storm
184     function whitelistInvestor(address _newInvestor) public onlyOwner {
185         if(!whitelist[_newInvestor]) {
186             whitelist[_newInvestor] = true;
187             investorsLength++;
188         }
189     }
190     //TESTED by Roman Storm
191     function whitelistInvestors(address[] _investors) external onlyOwner {
192         require(_investors.length <= 250);
193         for(uint8 i=0; i<_investors.length;i++) {
194             address newInvestor = _investors[i];
195             if(!whitelist[newInvestor]) {
196                 whitelist[newInvestor] = true;
197                 investorsLength++;
198             }
199         }
200     }
201     function blacklistInvestor(address _investor) public onlyOwner {
202         if(whitelist[_investor]) {
203             delete whitelist[_investor];
204             if(investorsLength != 0) {
205                 investorsLength--;
206             }
207         }
208     }
209 }