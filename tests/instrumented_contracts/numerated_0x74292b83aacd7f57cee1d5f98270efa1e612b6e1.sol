1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender)
58     public view returns (uint256);
59 
60   function transferFrom(address from, address to, uint256 value)
61     public returns (bool);
62 
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(
65     address indexed owner,
66     address indexed spender,
67     uint256 value
68   );
69 }
70 
71 contract Salary {
72   using SafeMath for uint256;
73   address public admin;
74   mapping(address => bool) public helperAddressTable;
75   address[] public addressList;
76   uint256 public deliveredId;
77   // deliveredId is global index indicates the number of months that the company deliver tokens.
78   // StaffAddress => ( deliveredId => monthlySalaryAmount )
79 
80   mapping(address => mapping(uint256 => uint256)) public staffSalaryData;
81   // status: 0 (null) status: 1 (normal) status: 2 (terminated)
82   mapping(address => uint256) public staffSalaryStatus;
83 
84   ERC20 token;
85 
86   event TerminatePackage(address indexed staff);
87   event ChangeTokenContractAddress(address indexed newAddress);
88   
89   modifier onlyAdmin() {
90     require(msg.sender == admin);
91     _;
92   }
93 
94   modifier onlyHelper() {
95     require(msg.sender == admin || helperAddressTable[msg.sender] == true);
96     _;
97   }
98 
99   function getFullAddressList() view public returns(address[]) {
100     return addressList;
101   }
102 
103   /**
104   * @dev This would distribute all salary of the month.
105   */
106   function distribute() public onlyAdmin {
107     uint256 i;
108     address receiverAddress;
109     uint256 transferAmount;
110     for(i = 0; i < addressList.length; i++) {
111       receiverAddress = addressList[i];
112       if (staffSalaryStatus[receiverAddress] == 1) {
113         transferAmount = staffSalaryData[receiverAddress][deliveredId];
114         if (transferAmount > 0) {
115           require(token.transfer(receiverAddress, transferAmount));
116         }
117       }
118     }
119     deliveredId = deliveredId + 1;
120   }
121 
122   /**
123   * @dev The function should only be called from Admin.  This would require users approve
124   * efficient amount of Token to the contract beforehead.
125   * @param _staffAddress address The staff's wallet address where they would receive their salary.
126   * @param _monthlySalary uint256[] every monthly salary start from next index
127   */
128 
129   function newPackage(address _staffAddress, uint256[] _monthlySalary) external onlyHelper{
130     uint256 i;
131     uint256 packageTotalAmount = 0;
132     require(staffSalaryStatus[_staffAddress] == 0);
133     for (i = 0; i < _monthlySalary.length; i++) {
134       staffSalaryData[_staffAddress][deliveredId + i] = _monthlySalary[i];
135       packageTotalAmount = packageTotalAmount + _monthlySalary[i];
136     }
137     addressList.push(_staffAddress);
138     staffSalaryStatus[_staffAddress] = 1;
139     require(token.transferFrom(msg.sender, address(this), packageTotalAmount));
140   }
141 
142   /**
143   * @dev When there's a staff resign and terminate the package, admin can withdraw tokens
144   * from the contract.  This would emit an event TerminatePackage which is the only event of this contract.
145   * all staff should watch this event on Ethereum in order to protect their rights.
146   * efficient amount of Token to the contract beforehead.
147   * @param _staffAddress address The staff's wallet address where they would receive their salary.
148   */
149   function terminatePackage(address _staffAddress) external onlyAdmin {
150     emit TerminatePackage(_staffAddress);
151     staffSalaryStatus[_staffAddress] = 2;
152   }
153 
154   function withdrawToken(uint256 amount) public onlyAdmin {
155     require(token.transfer(admin, amount));
156   }
157 
158   /**
159   * @dev To facilitate the process of constructing salary system, we need an address that could
160   * execute `newPacakge`.
161   * @param _helperAddress the address that is to be assigned as a helper
162   */
163   function setHelper(address _helperAddress) external onlyAdmin {
164     helperAddressTable[_helperAddress] = true;
165   }
166 
167   /**
168   * @dev A address controled by hotwallet that is
169   * able to call newPackage is a risk to the system. We should remove helper after
170   * the packages are properly set.
171   * @param _helperAddress the address to be removed from helper.
172   */
173   function removeHelper(address _helperAddress) external onlyAdmin {
174     require(helperAddressTable[_helperAddress] = true);
175     helperAddressTable[_helperAddress] = false;
176   }
177 
178   /**
179    * @dev Change token address from BCNP to BCNT
180    * @param _newAddress the new token contract address
181   */ 
182   function changeTokenContractAddress(address _newAddress) external onlyAdmin {
183     require(_newAddress != address(0));
184     token = ERC20(_newAddress);
185     emit ChangeTokenContractAddress(_newAddress);
186   }
187 
188   constructor (address _tokenAddress) public {
189     admin = msg.sender;
190     token = ERC20(_tokenAddress);
191   }
192 }