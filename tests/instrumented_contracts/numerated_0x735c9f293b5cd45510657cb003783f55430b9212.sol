1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-28
3 */
4 
5 pragma solidity 0.4.18;
6 
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
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 contract ERC20TokenInterface {
56     function totalSupply() constant public returns (uint256 supply);
57     function balanceOf(address _owner) constant public returns (uint256 balance);
58     function transfer(address _to, uint256 _value) public returns (bool success);
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
60     function approve(address _spender, uint256 _value) public returns (bool success);
61     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 contract ERC20Faucet {
67     using SafeMath for uint256;
68 
69     uint256 public maxAllowanceInclusive;
70     mapping (address => uint256) public claimedTokens;
71     ERC20TokenInterface public erc20Contract;
72     
73     address private mOwner;
74     bool private mIsPaused = false;
75     bool private mReentrancyLock = false;
76     
77     event GetTokens(address requestor, uint256 amount);
78     event ReclaimTokens(address owner, uint256 tokenAmount);
79     event SetPause(address setter, bool newState, bool oldState);
80     event SetMaxAllowance(address setter, uint256 newState, uint256 oldState);
81     
82     modifier notPaused() {
83         require(!mIsPaused);
84         _;
85     }
86 
87     modifier onlyOwner() {
88         require(msg.sender == mOwner);
89         _;
90     }
91     
92     modifier nonReentrant() {
93         require(!mReentrancyLock);
94         mReentrancyLock = true;
95         _;
96         mReentrancyLock = false;
97     }
98     
99     function ERC20Faucet(ERC20TokenInterface _erc20ContractAddress, uint256 _maxAllowanceInclusive) public {
100         mOwner = msg.sender;
101         maxAllowanceInclusive = _maxAllowanceInclusive;
102         erc20Contract = _erc20ContractAddress;
103     }
104     
105     function getTokens(uint256 amount) notPaused nonReentrant public returns (bool) {
106         require(claimedTokens[msg.sender].add(amount) <= maxAllowanceInclusive);
107         require(erc20Contract.balanceOf(this) >= amount);
108         
109         claimedTokens[msg.sender] = claimedTokens[msg.sender].add(amount);
110 
111         if (!erc20Contract.transfer(msg.sender, amount)) {
112             claimedTokens[msg.sender] = claimedTokens[msg.sender].sub(amount);
113             return false;
114         }
115         
116         GetTokens(msg.sender, amount);
117         return true;
118     }
119     
120     function setMaxAllowance(uint256 _maxAllowanceInclusive) onlyOwner nonReentrant public {
121         SetMaxAllowance(msg.sender, _maxAllowanceInclusive, maxAllowanceInclusive);
122         maxAllowanceInclusive = _maxAllowanceInclusive;
123     }
124     
125     function reclaimTokens() onlyOwner nonReentrant public returns (bool) {
126         uint256 tokenBalance = erc20Contract.balanceOf(this);
127         if (!erc20Contract.transfer(msg.sender, tokenBalance)) {
128             return false;
129         }
130 
131         ReclaimTokens(msg.sender, tokenBalance);
132         return true;
133     }
134     
135     function setPause(bool isPaused) onlyOwner nonReentrant public {
136         SetPause(msg.sender, isPaused, mIsPaused);
137         mIsPaused = isPaused;
138     }
139 }