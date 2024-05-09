1 pragma solidity ^0.4.24;
2 
3 // File: contracts/zeppelin/ownership/Ownable.sol
4 contract Ownable {
5   address public owner;
6   constructor() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 }
15 
16 // File: contracts/zeppelin/lifecycle/Pausable.sol
17 contract Pausable is Ownable {
18   event PausePublic(bool newState);
19   event PauseOwnerAdmin(bool newState);
20 
21   bool public pausedPublic = true;
22   bool public pausedOwnerAdmin = false;
23 
24   address public admin;
25 
26   modifier whenNotPaused() {
27     if(pausedPublic) {
28       if(!pausedOwnerAdmin) {
29         require(msg.sender == admin || msg.sender == owner);
30       } else {
31         revert();
32       }
33     }
34     _;
35   }
36 
37   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
38     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
39 
40     pausedPublic = newPausedPublic;
41     pausedOwnerAdmin = newPausedOwnerAdmin;
42 
43     emit PausePublic(newPausedPublic);
44     emit PauseOwnerAdmin(newPausedOwnerAdmin);
45   }
46 }
47 
48 // File: contracts/zeppelin/math/SafeMath.sol
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a / b;
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal pure returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 // File: contracts/zeppelin/token/ERC20Basic.sol
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 // File: contracts/zeppelin/token/BasicToken.sol
85 
86 contract BasicToken is ERC20Basic  {
87   using SafeMath for uint256;
88   mapping(address => uint256) balances;
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     // SafeMath.sub will throw if there is not enough balance.
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 // File: contracts/zeppelin/token/PausableToken.sol
107 contract PausableToken is BasicToken, Pausable {
108 
109   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
110     return super.transfer(_to, _value);
111   }
112 }
113 
114 // File: contracts/DsionToken.sol
115 contract DsionToken is PausableToken {
116     string  public  constant name = "Dsion";
117     string  public  constant symbol = "DSN";
118     uint8   public  constant decimals = 8;
119     uint   public  totallockedtime;
120 
121      // new feature, Lee
122     mapping(address => uint) approvedInvestorListWithDate;
123 
124     constructor(uint _totallockedtime) public
125     {
126         admin = owner;
127         totalSupply = 100000000000000000;
128         balances[msg.sender] = totalSupply;
129         totallockedtime = _totallockedtime;
130         emit Transfer(address(0x0), msg.sender, totalSupply);
131     }
132 
133     function setTotalLockedTime(uint _value) onlyOwner public{
134         totallockedtime = _value;
135     }
136 
137     function getTime() public constant returns (uint) {
138         return now;
139     }
140 
141     function isUnlocked() internal view returns (bool) {
142         return getTime() >= getLockFundsReleaseTime(msg.sender);
143     }
144 
145     modifier validDestination(address to)
146     {
147         require(to != address(0x0));
148         require(to != address(this));
149         _;
150     }
151 
152     modifier onlyWhenUnlocked()
153     {
154       if (msg.sender != admin) {
155         require(getTime() >= totallockedtime);
156         require(isUnlocked());
157       }
158       _;
159     }
160 
161     function transfer(address _to, uint _value) onlyWhenUnlocked public validDestination(_to) returns (bool)
162     {
163       return super.transfer(_to, _value);
164     }
165 
166     function getLockFundsReleaseTime(address _addr) private view returns(uint)
167     {
168         return approvedInvestorListWithDate[_addr];
169     }
170 
171     function setLockFunds(address[] newInvestorList, uint releaseTime) onlyOwner public
172     {
173         require(releaseTime > getTime());
174         for (uint i = 0; i < newInvestorList.length; i++)
175         {
176             approvedInvestorListWithDate[newInvestorList[i]] = releaseTime;
177         }
178     }
179 
180     function removeLockFunds(address[] investorList) onlyOwner public
181     {
182         for (uint i = 0; i < investorList.length; i++)
183         {
184             approvedInvestorListWithDate[investorList[i]] = 0;
185             delete(approvedInvestorListWithDate[investorList[i]]);
186         }
187     }
188 
189     function setLockFund(address newInvestor, uint releaseTime) onlyOwner public
190     {
191         require(releaseTime > getTime());
192         approvedInvestorListWithDate[newInvestor] = releaseTime;
193     }
194 
195 
196     function removeLockFund(address investor) onlyOwner public
197     {
198         approvedInvestorListWithDate[investor] = 0;
199         delete(approvedInvestorListWithDate[investor]);
200     }
201 
202     event Burn(address indexed _burner, uint _value);
203     function burn(uint _value) onlyOwner public returns (bool)
204     {
205         balances[msg.sender] = balances[msg.sender].sub(_value);
206         totalSupply = totalSupply.sub(_value);
207         emit Burn(msg.sender, _value);
208         emit Transfer(msg.sender, address(0x0), _value);
209         return true;
210     }
211 
212     function burnFrom(address _account, uint256 _amount) onlyOwner public returns (bool)
213     {
214       require(_account != 0);
215       require(_amount <= balances[_account]);
216 
217       totalSupply = totalSupply.sub(_amount);
218       balances[_account] = balances[_account].sub(_amount);
219       emit Transfer(_account, address(0), _amount);
220       return true;
221     }
222 }