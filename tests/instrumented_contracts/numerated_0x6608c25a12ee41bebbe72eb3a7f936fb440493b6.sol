1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15      * @dev Throws if called by any account other than the owner.
16      */
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     /**
23      * @dev Allows the current owner to transfer control of the contract to a newOwner.
24      * @param newOwner The address to transfer ownership to.
25      */
26     function transferOwnership(address newOwner) public onlyOwner {
27         require(newOwner != address(0));
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner;
30     }
31 
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40     /**
41     * @dev Multiplies two numbers, throws on overflow.
42     */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44         if (a == 0) {
45             return 0;
46         }
47         c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         // uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return a / b;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 contract IQUASaleMint {
80     function mintProxyWithoutCap(address _to, uint256 _amount) public;
81     function mintProxy(address _to, uint256 _amount) public;
82 }
83 
84 
85 
86 /**
87  * @title Crowdsale
88  * @dev Crowdsale is a base contract for managing a token crowdsale,
89  * allowing investors to purchase tokens with ether. This contract implements
90  * such functionality in its most fundamental form and can be extended to provide additional
91  * functionality and/or custom behavior.
92  * The external interface represents the basic interface for purchasing tokens, and conform
93  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
94  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
95  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
96  * behavior.
97  */
98 contract QuasaCoinExchanger is Ownable {
99     using SafeMath for uint256;
100 
101     // Address where funds are collected
102     address public wallet;
103 
104     // How many token units a buyer gets per wei
105     uint256 public rate;
106 
107     // Quasa token sale minter
108     IQUASaleMint public icoSmartcontract;
109 
110     function QuasaCoinExchanger() public {
111 
112         owner = msg.sender;
113 
114         // 1 ETH = 3000 QUA
115         rate = 3000;
116         wallet = 0x373ae730d8c4250b3d022a65ef998b8b7ab1aa53;
117         icoSmartcontract = IQUASaleMint(0x48299b98d25c700e8f8c4393b4ee49d525162513);
118     }
119 
120 
121     function setRate(uint256 _rate) onlyOwner public  {
122         rate = _rate;
123     }
124 
125 
126     // -----------------------------------------
127     // Crowdsale external interface
128     // -----------------------------------------
129 
130     /**
131      * @dev fallback function ***DO NOT OVERRIDE***
132      */
133     function () external payable {
134         buyTokens(msg.sender);
135     }
136 
137     /**
138      * @dev low level token purchase ***DO NOT OVERRIDE***
139      * @param _beneficiary Address performing the token purchase
140      */
141     function buyTokens(address _beneficiary) public payable {
142 
143         uint256 _weiAmount = msg.value;
144 
145         require(_beneficiary != address(0));
146         require(_weiAmount != 0);
147 
148         // calculate token amount to be created
149         uint256 _tokenAmount = _weiAmount.mul(rate);
150 
151         icoSmartcontract.mintProxyWithoutCap(_beneficiary, _tokenAmount);
152 
153         wallet.transfer(_weiAmount);
154     }
155 
156 }