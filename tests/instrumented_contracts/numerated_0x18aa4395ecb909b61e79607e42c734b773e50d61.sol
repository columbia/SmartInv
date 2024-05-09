1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4 
5     function totalSupply() public constant returns (uint);
6 
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8 
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10 
11     function transfer(address to, uint tokens) public returns (bool success);
12 
13     function approve(address spender, uint tokens) public returns (bool success);
14 
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16 
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19 
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 
22 }
23 
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, reverts on overflow.
28   */
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (a == 0) {
34       return 0;
35     }
36 
37     uint256 c = a * b;
38     require(c / a == b);
39 
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     require(b > 0); // Solidity only automatically asserts when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51     return c;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b <= a);
59     uint256 c = a - b;
60 
61     return c;
62   }
63 
64   /**
65   * @dev Adds two numbers, reverts on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     require(c >= a);
70 
71     return c;
72   }
73 
74   /**
75   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
76   * reverts when dividing by zero.
77   */
78   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b != 0);
80     return a % b;
81   }
82 }
83 
84 contract Ownable {
85   address private _owner;
86 
87   event OwnershipTransferred(
88     address indexed previousOwner,
89     address indexed newOwner
90   );
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   constructor() internal {
97     _owner = msg.sender;
98     emit OwnershipTransferred(address(0), _owner);
99   }
100 
101   /**
102    * @return the address of the owner.
103    */
104   function owner() public view returns(address) {
105     return _owner;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(isOwner());
113     _;
114   }
115 
116   /**
117    * @return true if `msg.sender` is the owner of the contract.
118    */
119   function isOwner() public view returns(bool) {
120     return msg.sender == _owner;
121   }
122 
123   /**
124    * @dev Allows the current owner to relinquish control of the contract.
125    * @notice Renouncing to ownership will leave the contract without an owner.
126    * It will not be possible to call the functions with the `onlyOwner`
127    * modifier anymore.
128    */
129   function renounceOwnership() public onlyOwner {
130     emit OwnershipTransferred(_owner, address(0));
131     _owner = address(0);
132   }
133 
134   /**
135    * @dev Allows the current owner to transfer control of the contract to a newOwner.
136    * @param newOwner The address to transfer ownership to.
137    */
138   function transferOwnership(address newOwner) public onlyOwner {
139     _transferOwnership(newOwner);
140   }
141 
142   /**
143    * @dev Transfers control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function _transferOwnership(address newOwner) internal {
147     require(newOwner != address(0));
148     emit OwnershipTransferred(_owner, newOwner);
149     _owner = newOwner;
150   }
151 }
152 
153 contract Bounty is Ownable{
154     
155     using SafeMath for uint256;
156     
157     ERC20Interface NBAI = ERC20Interface(0x17f8aFB63DfcDcC90ebE6e84F060Cc306A98257D);
158     
159     function transfer(address[] tos, uint256[] amounts) public onlyOwner {
160         require (tos.length == amounts.length);
161         for (uint256 i = 0; i<tos.length; i++){
162             require(NBAI.transferFrom(owner(), tos[i], amounts[i]));
163         }
164         
165     }
166     
167     
168 }