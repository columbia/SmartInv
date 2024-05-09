1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57 
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64     * account.
65     */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71     * @dev Throws if called by any account other than the owner.
72     */
73     modifier onlyOwner() {
74         require(msg.sender == owner, "Not the owner");
75         _;
76     }
77 
78     /**
79     * @dev Allows the current owner to transfer control of the contract to a newOwner.
80     * @param newOwner The address to transfer ownership to.
81     */
82     function transferOwnership(address newOwner) public onlyOwner {
83         require(newOwner != address(0), "Zero address received");
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86     }
87 
88 }
89 
90 
91 interface IERC20 {
92     function transfer(address _to, uint _value) external returns (bool success);
93     function balanceOf(address _owner) external view returns (uint256 balance);
94 }
95 
96 
97 contract Airdrop is Ownable {
98     using SafeMath for uint256;
99 
100     IERC20 public token;
101 
102     event Airdropped(address to, uint256 token);
103     event TokenContractSet(IERC20 newToken);
104 
105     /**
106     * @dev The Airdrop constructor sets the address of the token contract
107     */
108     constructor (IERC20 _tokenAddr) public {
109         require(address(_tokenAddr) != address(0), "Zero address received");
110         token = _tokenAddr;
111         emit TokenContractSet(_tokenAddr);
112     }
113 
114     /**
115     * @dev Allows the tokens to be dropped to the respective beneficiaries
116     * @param beneficiaries An array of beneficiary addresses that are to receive tokens
117     * @param values An array of the amount of tokens to be dropped to respective beneficiaries
118     * @return Returns true if airdrop is successful
119     */
120     function drop(address[] beneficiaries, uint256[] values)
121         external
122         onlyOwner
123         returns (bool)
124     {
125         require(beneficiaries.length == values.length, "Array lengths of parameters unequal");
126 
127         for (uint i = 0; i < beneficiaries.length; i++) {
128             require(beneficiaries[i] != address(0), "Zero address received");
129             require(getBalance() >= values[i], "Insufficient token balance");
130 
131             token.transfer(beneficiaries[i], values[i]);
132 
133             emit Airdropped(beneficiaries[i], values[i]);
134         }
135 
136         return true;
137     }
138 
139     /**
140     * @dev Used to check contract's token balance
141     */
142     function getBalance() public view returns (uint256 balance) {
143         balance = token.balanceOf(address(this));
144     }
145 
146     /**
147     * @dev Sets the address of the token contract
148     * @param newToken The address of the token contract
149     */
150     function setTokenAddress(IERC20 newToken) public onlyOwner {
151         require(address(newToken) != address(0), "Zero address received");
152         token = newToken;
153         emit TokenContractSet(newToken);
154     }
155 
156 }