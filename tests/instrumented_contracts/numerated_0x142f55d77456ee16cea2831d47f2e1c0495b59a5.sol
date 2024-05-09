1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, reverts on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     uint256 c = a * b;
22     require(c / a == b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b > 0); // Solidity only automatically asserts when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     require(b <= a);
43     uint256 c = a - b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, reverts on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a);
54 
55     return c;
56   }
57 
58   /**
59   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
60   * reverts when dividing by zero.
61   */
62   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b != 0);
64     return a % b;
65   }
66 }
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75   address private _owner;
76 
77 
78   event OwnershipRenounced(address indexed previousOwner);
79   event OwnershipTransferred(
80     address indexed previousOwner,
81     address indexed newOwner
82   );
83 
84 
85   /**
86    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87    * account.
88    */
89   constructor() public {
90     _owner = msg.sender;
91   }
92 
93   /**
94    * @return the address of the owner.
95    */
96   function owner() public view returns(address) {
97     return _owner;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(isOwner());
105     _;
106   }
107 
108   /**
109    * @return true if `msg.sender` is the owner of the contract.
110    */
111   function isOwner() public view returns(bool) {
112     return msg.sender == _owner;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipRenounced(_owner);
123     _owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     _transferOwnership(newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address newOwner) internal {
139     require(newOwner != address(0));
140     emit OwnershipTransferred(_owner, newOwner);
141     _owner = newOwner;
142   }
143 }
144 
145 
146 contract AirDropStore is Ownable {
147     using SafeMath for uint256;
148     
149     address[] public arrayAirDrops;
150     mapping (address => uint256) public indexOfAirDropAddress;
151     
152     event addToAirDropList(address _address);
153     event removeFromAirDropList(address _address);
154     
155     function getArrayAirDropsLength() public view returns (uint256) {
156         return arrayAirDrops.length;
157     }
158     
159     function addAirDropAddress(address _address) public onlyOwner {
160         arrayAirDrops.push(_address);
161         indexOfAirDropAddress[_address] = arrayAirDrops.length.sub(1);
162     
163         emit addToAirDropList(_address);
164     }
165     
166     function addAirDropAddresses(address[] _addresses) public onlyOwner {
167         for (uint i = 0; i < _addresses.length; i++) {
168             arrayAirDrops.push(_addresses[i]);
169             indexOfAirDropAddress[_addresses[i]] = arrayAirDrops.length.sub(1);
170 
171             emit addToAirDropList(_addresses[i]);
172         }
173     }
174     
175     function removeAirDropAddress(address _address) public onlyOwner {
176         uint256 index =  indexOfAirDropAddress[_address];
177 
178         arrayAirDrops[index] = address(0);
179         emit removeFromAirDropList(_address);
180     }
181     
182     function removeAirDropAddresses(address[] _addresses) public onlyOwner {
183         uint256 index;
184         
185         for (uint i = 0; i < _addresses.length; i++) {
186         
187             index =  indexOfAirDropAddress[_addresses[i]];
188 
189             arrayAirDrops[index] = address(0);
190             emit removeFromAirDropList(_addresses[i]);
191         }
192     }
193 }