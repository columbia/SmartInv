1 pragma solidity 0.6.8;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two unsigned integers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12         return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Solidity only automatically asserts when dividing by 0
26     require(b > 0);
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two unsigned integers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 interface ERC20 {
64   function balanceOf(address who) external view returns (uint256);
65   function transfer(address to, uint value) external returns (bool success);
66   function transferFrom(address from, address to, uint value) external returns (bool success);
67 }
68 
69 interface CuraAnnonaes {
70   function getDailyReward() external view returns (uint256);
71   function getNumberOfVaults() external view returns (uint256);
72   function getUserBalanceInVault(string calldata vault, address user) external view returns (uint256);
73   function stake(string calldata, address receiver, uint256 amount, address _vault) external returns (bool);
74   function unstake(string calldata vault, address receiver, address _vault) external;
75   function updateVaultData(string calldata vault, address who, address user, uint value) external;
76 }
77 
78 // https://en.wikipedia.org/wiki/Cura_Annonae
79 contract YFMSVault {
80   using SafeMath for uint256;
81 
82   // variables.
83   address public owner;
84   address[] public stakers; // tracks all addresses in vault.
85   uint256 public burnTotal = 0;
86   CuraAnnonaes public CuraAnnonae;
87   ERC20 public YFMSToken;
88   
89   constructor(address _cura, address _token) public {
90     owner = msg.sender;
91     CuraAnnonae = CuraAnnonaes(_cura);
92     YFMSToken = ERC20(_token);
93   }
94 
95   // balance of a user in the vault.
96   function getUserBalance(address _from) public view returns (uint256) {
97     return CuraAnnonae.getUserBalanceInVault("YFMS", _from);
98   }
99 
100   // returns all users currently staking in this vault.
101   function getStakers() public view returns (address[] memory) {
102     return stakers; 
103   }
104 
105   function getUnstakingFee(address _user) public view returns (uint256) {
106     uint256 _balance = getUserBalance(_user);
107     return _balance / 10000 * 250;
108   }
109 
110   function cleanStakersArray(address user) internal {
111     uint256 index;
112     // search the array for the user.
113     for (uint i=0; i < stakers.length; i++) {
114       if (stakers[i] == user)
115         index = i;
116       break;
117     }
118     // swap the last user in the array for the current unstaked user.
119     stakers[index] = stakers[stakers.length - 1];
120     // remove the last element (empty)
121     stakers.pop();
122   }
123 
124   function stakeYFMS(uint256 _amount, address _from) public {
125     // add user to stakers array if not currently present.
126     require(msg.sender == _from);
127     require(_amount >= 500000000000000000);
128     require(_amount <= YFMSToken.balanceOf(_from));
129     if (getUserBalance(_from) == 0)
130       stakers.push(_from);
131     YFMSToken.transferFrom(_from, address(this), _amount);
132     require(CuraAnnonae.stake("YFMS", _from, _amount, address(this)));
133   }
134 
135   function unstakeYFMS(address _to) public {
136     uint256 _unstakingFee = getUnstakingFee(_to);
137     uint256 _amount = getUserBalance(_to).sub(_unstakingFee);
138     // ensure data integrity.
139     require(_amount > 0);
140     require(msg.sender == _to);
141     // first transfer funds back to the user then burn the unstaking fee.
142     YFMSToken.transfer(_to, _amount);
143     YFMSToken.transfer(address(0), _unstakingFee);
144     // add to burn total.
145     burnTotal = burnTotal.add(_unstakingFee); 
146     // unstake.
147     CuraAnnonae.unstake("YFMS", _to, address(this));
148     // remove user from array.
149     cleanStakersArray(_to);
150   }
151 
152   function ratioMath(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
153     uint256 numerator = _numerator * 10 ** 18; // precision to 18 decimals.
154     uint256 quotient = (numerator / _denominator).add(5).div(10);
155     return quotient;
156   }
157 
158   // daily call to distribute vault rewards to users who have staked.
159   function distributeVaultRewards () public {
160     require(msg.sender == owner);
161     uint256 _reward = CuraAnnonae.getDailyReward();
162     uint256 _vaults = CuraAnnonae.getNumberOfVaults();
163     uint256 _vaultReward = _reward.div(_vaults);
164     // remove daily reward from address(this) total.
165     uint256 _pool = YFMSToken.balanceOf(address(this)).sub(_vaultReward);
166     uint256 _userBalance;
167     uint256 _earned;
168     // iterate through stakers array and distribute rewards based on % staked.
169     for (uint i = 0; i < stakers.length; i++) {
170       _userBalance = getUserBalance(stakers[i]);
171       if (_userBalance > 0) {
172         _earned = ratioMath(_userBalance, _pool).mul(_vaultReward / 100000000000000000);
173         // update the vault data.
174         CuraAnnonae.updateVaultData("YFMS", address(this), stakers[i], _earned);
175       }
176     }
177   }
178 }