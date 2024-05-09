1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract ERC20Interface{
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51 }
52 
53 /*
54  * Ownable
55  *
56  * Base contract with an owner.
57  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
58  */
59 contract Ownable {
60   address public owner;
61   
62   constructor() public { 
63     owner = msg.sender;
64   }
65 
66   modifier onlyOwner() {
67     if (msg.sender != owner) {
68       revert();
69     }
70     _;
71   }
72   //transfer owner to another address
73   function transferOwnership(address _newOwner) onlyOwner public {
74     if (_newOwner != address(0)) {
75       owner = _newOwner;
76     }
77   }
78 }
79 
80 contract Anaco_Airdrop is Ownable {
81     
82     // allows the use of the SafeMath library inside that contract, only for uint256 variables
83     using SafeMath for uint256;
84     
85     // Token exchange rate (taking into account the 8 decimals from ANACO tokens)
86     uint256 public tokensPerEth = 100000000 * 1e8;
87     uint256 public closeTime = 1538351999; // September 30th, at 11PM 59:59 GMT is the end of the airdrop
88     
89     // ANAC Token interface
90     ERC20Interface public anacoContract = ERC20Interface(0x356A50ECE1eD2782fE7031D81FD168f08e242a4E);
91     address public fundsWallet;
92     
93     // modifiers
94     modifier airdropOpen() {
95        // if(now > closeTime) revert();
96         _;
97     }
98     
99     modifier airdropClosed() {
100        // if(now < closeTime) revert(); 
101         _;
102     }
103     
104     constructor(address _fundsWallet) public {
105         fundsWallet = _fundsWallet;
106     }
107     
108     
109     function () public {
110         revert();           // do not accept fallback calls
111     }
112     
113     
114     function getTokens() payable public{
115         require(msg.value >= 2 finney);             // needs to contribute at least 0.002 Ether
116         
117         uint256 amount = msg.value.mul(tokensPerEth).div(1 ether);
118         
119         if(msg.value >= 500 finney) {               // +50% bonus if you contribute more than 0.5 Ether
120             amount = amount.add(amount.div(2));
121         }
122         
123         anacoContract.transferFrom(fundsWallet, msg.sender, amount); // reverts by itself if fundsWallet doesn't allow enough funds to the contract
124     }
125     
126     
127     function withdraw() public onlyOwner {
128         require(owner.send(address(this).balance));
129     }
130     
131     
132     function changeFundsWallet(address _newFundsWallet) public onlyOwner {
133         fundsWallet = _newFundsWallet;
134     }
135     
136 }