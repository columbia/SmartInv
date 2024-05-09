1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public constant returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract ArbiPreIco is Ownable {
99     using SafeMath for uint256;
100     
101     //the token being sold
102     ERC20 arbiToken;
103     address public tokenAddress;
104 
105     /* owner of tokens to spend */ 
106     address public tokenOwner;
107     
108     uint public startTime;
109     uint public endTime;
110     uint public price;
111 
112     uint public hardCapAmount = 33333200;
113 
114     uint public tokensRemaining = hardCapAmount;
115 
116     /**
117     * event for token purchase logging
118     * @param beneficiary who got the tokens
119     * @param amount amount of tokens purchased
120     */ 
121     event TokenPurchase(address indexed beneficiary, uint256 amount);
122 
123     function ArbiPreIco(address token, address owner, uint start, uint end) public {
124         tokenAddress = token;
125         tokenOwner = owner;
126         arbiToken = ERC20(token);
127         startTime = start;
128         endTime = end;
129         price = 0.005 / 100 * 1 ether; //1.00 token = 0.005 ether
130     }
131 
132     /**
133     * fallback function to receive ether 
134     */
135     function () payable {
136         buyTokens(msg.sender);
137     }
138 
139     function buyTokens(address beneficiary) public payable {
140         require(beneficiary != 0x0);
141         require(isActive());
142         require(msg.value >= 0.01 ether);
143         uint amount = msg.value;
144         uint tokenAmount = amount.div(price);
145         makePurchase(beneficiary, tokenAmount);
146     }
147 
148     function sendEther(address _to, uint amount) onlyOwner {
149         _to.transfer(amount);
150     }
151     
152     function isActive() constant returns (bool active) {
153         return now >= startTime && now <= endTime && tokensRemaining > 0;
154     }
155     
156     /** 
157     * function for external token purchase 
158     * @param _to receiver of tokens
159     * @param amount of tokens to send
160     */
161     function sendToken(address _to, uint256 amount) onlyOwner {
162         makePurchase(_to, amount);
163     }
164 
165     function makePurchase(address beneficiary, uint256 amount) private {
166         require(amount <= tokensRemaining);
167         arbiToken.transferFrom(tokenOwner, beneficiary, amount);
168         tokensRemaining = tokensRemaining.sub(amount);
169         TokenPurchase(beneficiary, amount);
170     }
171     
172 }