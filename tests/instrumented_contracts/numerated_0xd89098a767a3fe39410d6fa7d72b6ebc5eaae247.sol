1 pragma solidity ^0.4.21;
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
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 
93 
94 /**
95  * @title ERC20Basic
96  * @dev Simpler version of ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/179
98  */
99 contract ERC20Basic {
100   function totalSupply() public view returns (uint256);
101   function balanceOf(address who) public view returns (uint256);
102   function transfer(address to, uint256 value) public returns (bool);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 contract LockingContract is Ownable {
121     using SafeMath for uint256;
122 
123     event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
124     event ReleasedTokens(address indexed _beneficiary);
125     event ReducedLockingTime(uint256 _newUnlockTime);
126 
127     ERC20 public tokenContract;
128     mapping(address => uint256) public tokens;
129     uint256 public totalTokens;
130     uint256 public unlockTime;
131 
132     function isLocked() public view returns(bool) {
133         return now < unlockTime;
134     }
135 
136     modifier onlyWhenUnlocked() {
137         require(!isLocked());
138         _;
139     }
140 
141     modifier onlyWhenLocked() {
142         require(isLocked());
143         _;
144     }
145 
146     function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
147         require(_unlockTime > now);
148         require(address(_tokenContract) != 0x0);
149         unlockTime = _unlockTime;
150         tokenContract = _tokenContract;
151     }
152 
153     function balanceOf(address _owner) public view returns (uint256 balance) {
154         return tokens[_owner];
155     }
156 
157     // Should only be done from another contract.
158     // To ensure that the LockingContract can release all noted tokens later,
159     // one should mint/transfer tokens to the LockingContract's account prior to noting
160     function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
161         uint256 tokenBalance = tokenContract.balanceOf(this);
162         require(tokenBalance >= totalTokens.add(_tokenAmount));
163 
164         tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
165         totalTokens = totalTokens.add(_tokenAmount);
166         emit NotedTokens(_beneficiary, _tokenAmount);
167     }
168 
169     function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
170         require(msg.sender == owner || msg.sender == _beneficiary);
171         uint256 amount = tokens[_beneficiary];
172         tokens[_beneficiary] = 0;
173         require(tokenContract.transfer(_beneficiary, amount)); 
174         totalTokens = totalTokens.sub(amount);
175         emit ReleasedTokens(_beneficiary);
176     }
177 
178     function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
179         require(_newUnlockTime >= now);
180         require(_newUnlockTime < unlockTime);
181         unlockTime = _newUnlockTime;
182         emit ReducedLockingTime(_newUnlockTime);
183     }
184 }