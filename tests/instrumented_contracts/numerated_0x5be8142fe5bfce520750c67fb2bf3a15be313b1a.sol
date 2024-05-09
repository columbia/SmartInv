1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   constructor() public {
68     owner = msg.sender;
69   }
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     emit OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 interface IERC20 {
93     function transfer(address to, uint value) external returns (bool ok);
94     function balanceOf(address _owner) external view returns (uint256 balance);
95 }
96 
97 
98 contract Airdrop is Ownable {
99     using SafeMath for uint256;
100 
101     IERC20 public token;
102     uint256 public individualCap;
103     uint256 public totalAlloctedToken;
104     mapping (address => uint256) airdropContribution;
105     event Airdrop(address to, uint256 token);
106 
107     constructor (
108         IERC20 _tokenAddr,
109         uint256 _individualCap
110     )
111         public
112     {
113         token = _tokenAddr;
114         individualCap = _individualCap;
115     }
116 
117     function drop(address[] _recipients, uint256[] _amount) 
118         external 
119         onlyOwner returns (bool) 
120     {
121         require(_recipients.length == _amount.length);
122         
123         for (uint i = 0; i < _recipients.length; i++) {
124             require(_recipients[i] != address(0), "Address is zero address");
125             require(individualCap >= airdropContribution[_recipients[i]].add(_amount[i]), "Exceding individual cap");
126             require(token.balanceOf(address(this)) >= _amount[i], "No enoufgh tokens available");
127             airdropContribution[_recipients[i]] = airdropContribution[_recipients[i]].add(_amount[i]);
128             totalAlloctedToken = totalAlloctedToken.add(_amount[i]);
129             token.transfer(_recipients[i], _amount[i]);
130             emit Airdrop(_recipients[i], _amount[i]);
131         }
132         return true;
133     }
134 
135     function updateIndividualCap(uint256 _value) external onlyOwner {
136         require(individualCap > 0, "Individual Cap should be greater than zero");
137         individualCap = _value;
138     }
139 }