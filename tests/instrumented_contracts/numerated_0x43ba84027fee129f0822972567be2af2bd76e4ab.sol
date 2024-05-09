1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * openzeppelin-solidity@1.11.0/contracts/math/SafeMath.sol
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 
59 /**
60  * openzeppelin-solidity@1.11.0/contracts/ownership/Ownable.sol
61  */
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   // event OwnershipRenounced(address indexed previousOwner);
73   event OwnershipTransferred(
74     address indexed previousOwner,
75     address indexed newOwner
76   );
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to relinquish control of the contract.
97    * @notice Renouncing to ownership will leave the contract without an owner.
98    * It will not be possible to call the functions with the `onlyOwner`
99    * modifier anymore.
100    */
101   // function renounceOwnership() public onlyOwner {
102   //   emit OwnershipRenounced(owner);
103   //   owner = address(0);
104   // }
105 
106   /**
107    * @dev Allows the current owner to transfer control of the contract to a newOwner.
108    * @param _newOwner The address to transfer ownership to.
109    */
110   function transferOwnership(address _newOwner) public onlyOwner {
111     _transferOwnership(_newOwner);
112   }
113 
114   /**
115    * @dev Transfers control of the contract to a newOwner.
116    * @param _newOwner The address to transfer ownership to.
117    */
118   function _transferOwnership(address _newOwner) internal {
119     require(_newOwner != address(0));
120     emit OwnershipTransferred(owner, _newOwner);
121     owner = _newOwner;
122   }
123 }
124 
125 
126 /**
127  * openzeppelin-solidity@1.11.0/contracts/token/ERC20/ERC20Basic.sol
128  */
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * See https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   function totalSupply() public view returns (uint256);
137   function balanceOf(address who) public view returns (uint256);
138   // function transfer(address to, uint256 value) public returns (bool);
139   function transfer(address to, uint256 value) public;
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 }
142 
143 
144 /**
145  * openzeppelin-solidity@1.11.0/contracts/token/ERC20/ERC20.sol
146  */
147 
148 /**
149  * @title ERC20 interface
150  * @dev see https://github.com/ethereum/EIPs/issues/20
151  */
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender)
154     public view returns (uint256);
155 
156   function transferFrom(address from, address to, uint256 value)
157     public returns (bool);
158 
159   function approve(address spender, uint256 value) public returns (bool);
160   event Approval(
161     address indexed owner,
162     address indexed spender,
163     uint256 value
164   );
165 }
166 
167 
168 /**
169  * AirDrop Contract
170  */
171 contract AirDrop is Ownable {
172   using SafeMath for uint256;
173 
174   function () external payable {}
175 
176   function batchTransferToken(address _token_address, address[] _receivers, uint256[] _amounts) public onlyOwner returns (bool) {
177     require(_token_address != address(0));
178     require(_receivers.length > 0 && _receivers.length <= 256);
179     require(_receivers.length == _amounts.length);
180 
181     ERC20 token = ERC20(_token_address);
182     require(_getTotalSendingAmount(_amounts) <= token.balanceOf(this));
183 
184     for (uint i = 0; i < _receivers.length; i++) {
185       require(_receivers[i] != address(0));
186       require(_amounts[i] > 0);
187       token.transfer(_receivers[i], _amounts[i]);
188     }
189 
190     return true;
191   }
192 
193   function batchTransferEther(address[] _receivers, uint256[] _amounts) public payable onlyOwner returns (bool) {
194     require(_receivers.length > 0 && _receivers.length <= 256);
195     require(_receivers.length == _amounts.length);
196     require(msg.value > 0 && _getTotalSendingAmount(_amounts) <= msg.value);
197 
198     for (uint i = 0; i < _receivers.length; i++) {
199       require(_receivers[i] != address(0));
200       require(_amounts[i] > 0);
201       _receivers[i].transfer(_amounts[i]);
202     }
203 
204     return true;
205   }
206 
207   function withdrawToken(address _token_address, address _receiver) public onlyOwner returns (bool) {
208     ERC20 token = ERC20(_token_address);
209     require(_receiver != address(0) && token.balanceOf(this) > 0);
210     token.transfer(_receiver, token.balanceOf(this));
211     return true;
212   }
213 
214   function withdrawEther(address _receiver) public onlyOwner returns (bool) {
215     require(_receiver != address(0));
216     _receiver.transfer(address(this).balance);
217     return true;
218   }
219   
220   function _getTotalSendingAmount(uint256[] _amounts) private pure returns (uint256 totalSendingAmount) {
221     for (uint i = 0; i < _amounts.length; i++) {
222       require(_amounts[i] > 0);
223       totalSendingAmount = totalSendingAmount.add(_amounts[i]);
224     }
225   }
226 }