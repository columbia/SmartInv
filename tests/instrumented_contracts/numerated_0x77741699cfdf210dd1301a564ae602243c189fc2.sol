1 pragma solidity ^0.4.23; 
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
34     event Transfer(address indexed from, address indexed to, uint tokens);
35 
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 
38 }
39 
40 
41 contract _ERC20Pool {
42     
43   using SafeMath for uint64;
44 
45   // 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 is the 0xBitcoin Smart Contract
46   ERC20Interface public tokenContract = ERC20Interface(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);
47   
48   // 0x53CE57325C126145dE454719b4931600a0BD6Fc4 is the wallet for 0xpool.io
49   address public owner = 0x53CE57325C126145dE454719b4931600a0BD6Fc4;
50   
51   uint64 public totalTokenSupply;
52   mapping (address => uint64) public minerTokens;
53   mapping (address => uint64) public minerTokenPayouts;
54 
55   // Modifier for important owner only functions
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   // Require that the caller actually has tokens to withdraw.
62   modifier hasTokens() {
63     require(minerTokens[msg.sender] > 0);
64     _;
65   }
66 
67   // Pool software updates the contract when it finds a reward
68   function addMinerTokens(uint64 totalTokensInBatch, address[] minerAddress, uint64[] minerRewardTokens) public onlyOwner {
69     totalTokenSupply += totalTokensInBatch;
70     for (uint i = 0; i < minerAddress.length; i ++) {
71       minerTokens[minerAddress[i]] = minerTokens[minerAddress[i]].add(minerRewardTokens[i]);
72     }
73   }
74   
75   // Allow miners to withdraw their earnings from the contract. Update internal accounting.
76   function withdraw() public
77     hasTokens
78   {
79     uint64 amount = minerTokens[msg.sender];
80     minerTokens[msg.sender] = 0;
81     totalTokenSupply = totalTokenSupply.sub(amount);
82     minerTokenPayouts[msg.sender] = minerTokenPayouts[msg.sender].add(amount);
83     tokenContract.transfer(msg.sender, amount);
84   }
85   
86   // Fallback function, It's kind of you to send Ether, but we prefer to handle the true currency of
87   // Ethereum here, 0xBitcoin!
88   function () public payable {
89     revert();
90   }
91   
92   // Allow the owner to retrieve accidentally sent Ethereum
93   function withdrawEther(uint64 amount) public onlyOwner {
94     owner.transfer(amount);
95   }
96   
97   // Allows the owner to transfer any accidentally sent ERC20 Tokens, excluding 0xBitcoin.
98   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
99     if(tokenAddress == 0xB6eD7644C69416d67B522e20bC294A9a9B405B31 ){ 
100         revert(); 
101     }
102     return ERC20Interface(tokenAddress).transfer(owner, tokens);
103   }
104   
105 }
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112     /**
113      * @dev Multiplies two numbers, throws on overflow.
114      */
115      function mul(uint64 a, uint64 b) internal pure returns (uint64) {
116      if (a == 0) {
117      return 0;
118      }
119      uint64 c = a * b;
120      assert(c / a == b);
121      return c;
122      }
123     /**
124      * @dev Integer division of two numbers, truncating the quotient.
125      */
126      function div(uint64 a, uint64 b) internal pure returns (uint64) {
127      // assert(b > 0); // Solidity automatically throws when dividing by 0
128      uint64 c = a / b;
129      // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
130      return c;
131      }
132     /**
133      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134      */
135      function sub(uint64 a, uint64 b) internal pure returns (uint64) {
136      assert(b <= a);
137      uint64 c = a - b;
138      return c;
139      }
140     /**
141      * @dev Adds two numbers, throws on overflow.
142      */
143      function add(uint64 a, uint64 b) internal pure returns (uint64) {
144      uint64 c = a + b;
145      assert(c >= a);
146      return c;
147      }
148 }