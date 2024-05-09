1 pragma solidity ^0.4.19; 
2 /*
3 Author: Vox / 0xPool.io
4 Description: This smart contract is designed to store mining pool payouts for 
5   Ethereum Protocol tokens and allow pool miners to withdraw their earned tokens
6   whenever they please. There are several benefits to using a smart contract to
7   track mining pool payouts:
8     - Increased transparency on behalf of pool owners
9     - Allows users more control over the regularity of their mining payouts
10     - The pool admin does not need to pay the gas costs of hundreds of 
11       micro-transactions every time a block reward is found by the pool.
12 
13 This contract is the 0xBTC (0xBitcoin) payout account for: http://0xpool.io 
14 
15 Not heard of 0xBitcoin? Head over to http://0xbitcoin.org
16 */
17 
18 contract ERC20Interface {
19 
20     function totalSupply() public constant returns (uint);
21 
22     function balanceOf(address tokenOwner) public constant returns (uint balance);
23 
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25 
26     function transfer(address to, uint tokens) public returns (bool success);
27 
28     function approve(address spender, uint tokens) public returns (bool success);
29 
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34 
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 
37 }
38 
39 
40 contract _ERC20Pool {
41     
42   using SafeMath for uint32;
43 
44   // 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 is the 0xBitcoin Smart Contract
45   ERC20Interface public tokenContract = ERC20Interface(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);
46 
47   address public owner = msg.sender;
48   uint32 public totalTokenSupply;
49   mapping (address => uint32) public minerTokens;
50   mapping (address => uint32) public minerTokenPayouts;
51 
52   // Modifier for important owner only functions
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   // Require that the caller actually has tokens to withdraw.
59   modifier hasTokens(address sentFrom) {
60     require(minerTokens[sentFrom] > 0);
61     _;
62   }
63 
64   // Pool software updates the contract when it finds a reward
65   function addMinerTokens(uint32 totalTokensInBatch, address[] minerAddress, uint32[] minerRewardTokens) public onlyOwner {
66     totalTokenSupply += totalTokensInBatch;
67     for (uint i = 0; i < minerAddress.length; i ++) {
68       minerTokens[minerAddress[i]] = minerTokens[minerAddress[i]].add(minerRewardTokens[i]);
69     }
70   }
71   
72   // Allow miners to withdraw their earnings from the contract. Update internal accounting.
73   function withdraw() public
74     hasTokens(msg.sender) 
75   {
76     uint32 amount = minerTokens[msg.sender];
77     minerTokens[msg.sender] = 0;
78     totalTokenSupply = totalTokenSupply.sub(amount);
79     minerTokenPayouts[msg.sender] = minerTokenPayouts[msg.sender].add(amount);
80     tokenContract.transfer(msg.sender, amount);
81   }
82   
83   // Fallback function, It's kind of you to send Ether, but we prefer to handle the true currency of
84   // Ethereum here, 0xBitcoin!
85   function () public payable {
86     revert();
87   }
88   
89   // Allow the owner to retrieve accidentally sent Ethereum
90   function withdrawEther(uint32 amount) public onlyOwner {
91     owner.transfer(amount);
92   }
93   
94   // Allows the owner to transfer any accidentally sent ERC20 Tokens, excluding 0xBitcoin.
95   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
96     if(tokenAddress == 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 ){ 
97         revert(); 
98     }
99     return ERC20Interface(tokenAddress).transfer(owner, tokens);
100   }
101   
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109     /**
110      * @dev Multiplies two numbers, throws on overflow.
111      */
112      function mul(uint32 a, uint32 b) internal pure returns (uint32) {
113      if (a == 0) {
114      return 0;
115      }
116      uint32 c = a * b;
117      assert(c / a == b);
118      return c;
119      }
120     /**
121      * @dev Integer division of two numbers, truncating the quotient.
122      */
123      function div(uint32 a, uint32 b) internal pure returns (uint32) {
124      // assert(b > 0); // Solidity automatically throws when dividing by 0
125      uint32 c = a / b;
126      // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
127      return c;
128      }
129     /**
130      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131      */
132      function sub(uint32 a, uint32 b) internal pure returns (uint32) {
133      assert(b <= a);
134      uint32 c = a - b;
135      return c;
136      }
137     /**
138      * @dev Adds two numbers, throws on overflow.
139      */
140      function add(uint32 a, uint32 b) internal pure returns (uint32) {
141      uint32 c = a + b;
142      assert(c >= a);
143      return c;
144      }
145 }