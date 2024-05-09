1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/BountyClaims.sol
121 
122 contract BountyClaims is Ownable {
123   using SafeMath for uint256;
124 
125   ERC20 public token;
126 
127   address public wallet;
128 
129   mapping(address => uint256) bountyTokens;
130 
131   event Claim(
132     address indexed beneficiary,
133     uint256 amount
134   );
135 
136   function BountyClaims(
137     ERC20 _token,
138     address _wallet) public
139   {
140     require(_token != address(0));
141     require(_wallet != address(0));
142     token = _token;
143     wallet = _wallet;
144   }
145 
146   function() external payable {
147     claimToken(msg.sender);
148   }
149 
150   function setUsersBounty(address[] _beneficiaries, uint256[] _amounts) external onlyOwner {
151     for (uint i = 0; i < _beneficiaries.length; i++) {
152       bountyTokens[_beneficiaries[i]] = _amounts[i];
153     }
154   }
155 
156   function setGroupBounty(address[] _beneficiaries, uint256 _amount) external onlyOwner {
157     for (uint256 i = 0; i < _beneficiaries.length; i++) {
158       bountyTokens[_beneficiaries[i]] = _amount;
159     }
160   }
161 
162   function getUserBounty(address _beneficiary) public view returns (uint256) {
163     return  bountyTokens[_beneficiary];
164   }
165 
166   function claimToken(address _beneficiary) public payable {
167     uint256 amount = bountyTokens[_beneficiary];
168     require(amount > 0);
169     bountyTokens[_beneficiary] = 0;
170     require(token.transferFrom(wallet, _beneficiary, amount));
171     emit Claim(_beneficiary, amount);
172   }
173 }