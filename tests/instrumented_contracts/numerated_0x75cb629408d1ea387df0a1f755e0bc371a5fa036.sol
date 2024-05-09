1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76 
77   /**
78   * @dev Multiplies two numbers, throws on overflow.
79   */
80   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
81     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
82     // benefit is lost if 'b' is also tested.
83     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
84     if (_a == 0) {
85       return 0;
86     }
87 
88     c = _a * _b;
89     assert(c / _a == _b);
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers, truncating the quotient.
95   */
96   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
97     // assert(_b > 0); // Solidity automatically throws when dividing by 0
98     // uint256 c = _a / _b;
99     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
100     return _a / _b;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
107     assert(_b <= _a);
108     return _a - _b;
109   }
110 
111   /**
112   * @dev Adds two numbers, throws on overflow.
113   */
114   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
115     c = _a + _b;
116     assert(c >= _a);
117     return c;
118   }
119 }
120 
121 
122 contract GoodLuckCasino is Ownable{
123     using SafeMath for uint;
124 
125     event LOG_Deposit(bytes32 userID, address walletAddr, uint amount);
126     event LOG_Withdraw(address user, uint amount);
127 
128     event LOG_Bankroll(address sender, uint value);
129     event LOG_OwnerWithdraw(address _to, uint _val);
130 
131     event LOG_ContractStopped();
132     event LOG_ContractResumed();
133 
134     bool public isStopped;
135 
136     mapping (bytes32 => uint[]) depositList;
137 
138     modifier onlyIfNotStopped {
139         require(!isStopped);
140         _;
141     }
142 
143     modifier onlyIfStopped {
144         require(isStopped);
145         _;
146     }
147 
148     constructor() public {
149     }
150 
151     function () payable public {
152         revert();
153     }
154 
155     function bankroll() payable public onlyOwner {
156         emit LOG_Bankroll(msg.sender, msg.value);
157     }
158 
159     function userDeposit(bytes32 _userID) payable public onlyIfNotStopped {
160         depositList[_userID].push(msg.value);
161         emit LOG_Deposit(_userID, msg.sender, msg.value);
162     }
163 
164     function userWithdraw(address _to, uint _amount) public onlyOwner onlyIfNotStopped{
165         _to.transfer(_amount);
166         emit LOG_Withdraw(_to, _amount);
167     }
168 
169     function ownerWithdraw(address _to, uint _val) public onlyOwner{
170         require(address(this).balance > _val);
171         _to.transfer(_val);
172         emit LOG_OwnerWithdraw(_to, _val);
173     }
174 
175     function getUserDeposit(bytes32 _userID) view public returns (uint latestDepositValue, uint depositListLength) {
176         if(depositList[_userID].length == 0){
177             latestDepositValue = 0;
178             depositListLength = 0;
179         }else{
180             latestDepositValue = depositList[_userID][depositList[_userID].length.sub(1)];
181             depositListLength = depositList[_userID].length;
182         }
183     }
184 
185     function getUserDepositList(bytes32 _userID) view public returns (uint[]) {
186         return depositList[_userID];
187     }
188 
189     function stopContract() public onlyOwner onlyIfNotStopped {
190         isStopped = true;
191         emit LOG_ContractStopped();
192     }
193 
194     function resumeContract() public onlyOwner onlyIfStopped {
195         isStopped = false;
196         emit LOG_ContractResumed();
197     }
198 }