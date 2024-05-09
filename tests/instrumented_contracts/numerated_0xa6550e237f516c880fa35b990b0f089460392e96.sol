1 pragma solidity 0.4.25;
2 
3 // File: contracts\lib\SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts\lib\ERC20.sol
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 {
58     function allowance(address owner, address spender) public view returns (uint256);
59     function transferFrom(address from, address to, uint256 value) public returns (bool);
60     function approve(address spender, uint256 value) public returns (bool);
61     function totalSupply() public view returns (uint256);
62     function balanceOf(address who) public view returns (uint256);
63     function transfer(address to, uint256 value) public returns (bool);
64 
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: contracts\FundsSplitter.sol
70 
71 contract FundsSplitter {
72     using SafeMath for uint256;
73 
74     address public client;
75     address public starbase;
76     uint256 public starbasePercentage;
77 
78     ERC20 public star;
79     ERC20 public tokenOnSale;
80 
81     /**
82      * @dev initialization function
83      * @param _client Address where client's share goes
84      * @param _starbase Address where starbase's share goes
85      * @param _starbasePercentage Number that denotes client percentage share (between 1 and 100)
86      * @param _star Star ERC20 token address
87      * @param _tokenOnSale Token on sale's ERC20 token address
88      */
89     constructor(
90         address _client,
91         address _starbase,
92         uint256 _starbasePercentage,
93         ERC20 _star,
94         ERC20 _tokenOnSale
95     )
96         public
97     {
98         client = _client;
99         starbase = _starbase;
100         starbasePercentage = _starbasePercentage;
101         star = _star;
102         tokenOnSale = _tokenOnSale;
103     }
104 
105     /**
106      * @dev fallback function that accepts funds
107      */
108     function() public payable { }
109 
110     /**
111      * @dev splits star that are allocated to contract
112      */
113     function splitStarFunds() public {
114         uint256 starFunds = star.balanceOf(address(this));
115         uint256 starbaseShare = starFunds.mul(starbasePercentage).div(100);
116 
117         star.transfer(starbase, starbaseShare);
118         star.transfer(client, star.balanceOf(address(this))); // send remaining stars to client
119     }
120 
121     /**
122      * @dev core fund splitting functionality as part of the funds are sent to client and part to starbase
123      */
124     function splitFunds() public payable {
125         uint256 starbaseShare = address(this).balance.mul(starbasePercentage).div(100);
126 
127         starbase.transfer(starbaseShare);
128         client.transfer(address(this).balance); // remaining ether to client
129     }
130 
131     /**
132      * @dev withdraw any remaining tokens on sale
133      */
134     function withdrawRemainingTokens() public {
135         tokenOnSale.transfer(client, tokenOnSale.balanceOf(address(this)));
136     }
137 }