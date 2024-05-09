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
16 
17 May the Qat be with you. 
18 */
19 
20 contract ERC20Interface {
21 
22     function totalSupply() public constant returns (uint);
23 
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25 
26     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27 
28     function transfer(address to, uint tokens) public returns (bool success);
29 
30     function approve(address spender, uint tokens) public returns (bool success);
31 
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36 
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 
39 }
40 
41 
42 contract _ERC20Pool {
43     
44   using SafeMath for uint32;
45 
46   // 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 is the 0xBitcoin Smart Contract
47   ERC20Interface public tokenContract = ERC20Interface(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);
48 
49   address public owner = msg.sender;
50   uint32 public totalTokenSupply;
51   mapping (address => uint32) public minerTokens;
52   mapping (address => uint32) public minerTokenPayouts;
53 
54   // Modifier for important owner only functions
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   // Require that the caller actually has tokens to withdraw.
61   modifier hasTokens() {
62     require(minerTokens[msg.sender] > 0);
63     _;
64   }
65 
66   // Pool software updates the contract when it finds a reward
67   function addMinerTokens(uint32 totalTokensInBatch, address[] minerAddress, uint32[] minerRewardTokens) public onlyOwner {
68     totalTokenSupply += totalTokensInBatch;
69     for (uint i = 0; i < minerAddress.length; i ++) {
70       minerTokens[minerAddress[i]] = minerTokens[minerAddress[i]].add(minerRewardTokens[i]);
71     }
72   }
73   
74   // Allow miners to withdraw their earnings from the contract. Update internal accounting.
75   function withdraw() public
76     hasTokens
77   {
78     uint32 amount = minerTokens[msg.sender];
79     minerTokens[msg.sender] = 0;
80     totalTokenSupply = totalTokenSupply.sub(amount);
81     minerTokenPayouts[msg.sender] = minerTokenPayouts[msg.sender].add(amount);
82     tokenContract.transfer(msg.sender, amount);
83   }
84   
85   // Fallback function, It's kind of you to send Ether, but we prefer to handle the true currency of
86   // Ethereum here, 0xBitcoin!
87   function () public payable {
88     revert();
89   }
90   
91   // Allow the owner to retrieve accidentally sent Ethereum
92   function withdrawEther(uint32 amount) public onlyOwner {
93     owner.transfer(amount);
94   }
95   
96   // Allows the owner to transfer any accidentally sent ERC20 Tokens, excluding 0xBitcoin.
97   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
98     if(tokenAddress == 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 ){ 
99         revert(); 
100     }
101     return ERC20Interface(tokenAddress).transfer(owner, tokens);
102   }
103   
104 }
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111     /**
112      * @dev Multiplies two numbers, throws on overflow.
113      */
114      function mul(uint32 a, uint32 b) internal pure returns (uint32) {
115      if (a == 0) {
116      return 0;
117      }
118      uint32 c = a * b;
119      assert(c / a == b);
120      return c;
121      }
122     /**
123      * @dev Integer division of two numbers, truncating the quotient.
124      */
125      function div(uint32 a, uint32 b) internal pure returns (uint32) {
126      // assert(b > 0); // Solidity automatically throws when dividing by 0
127      uint32 c = a / b;
128      // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
129      return c;
130      }
131     /**
132      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133      */
134      function sub(uint32 a, uint32 b) internal pure returns (uint32) {
135      assert(b <= a);
136      uint32 c = a - b;
137      return c;
138      }
139     /**
140      * @dev Adds two numbers, throws on overflow.
141      */
142      function add(uint32 a, uint32 b) internal pure returns (uint32) {
143      uint32 c = a + b;
144      assert(c >= a);
145      return c;
146      }
147 }