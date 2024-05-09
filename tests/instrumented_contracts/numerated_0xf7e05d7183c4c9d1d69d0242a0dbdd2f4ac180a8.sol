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
41   address constant public bitcoinContract = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;
42     
43   ERC20Interface public tokenContract = ERC20Interface(bitcoinContract);
44 
45   address public owner = msg.sender;
46   uint32 public totalTokenSupply;
47   mapping (address => uint32) public minerTokens;
48   mapping (address => uint32) public minerTokenPayouts;
49 
50   // Modifier for important owner only functions
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   // Require that the caller actually has tokens to withdraw.
57   modifier hasTokens(address sentFrom) {
58     require(minerTokens[sentFrom] > 0);
59     _;
60   }
61 
62   // Pool software updates the contract when it finds a reward
63   function addMinerTokens(uint32 totalTokensInBatch, address[] minerAddress, uint32[] minerRewardTokens) public onlyOwner {
64     totalTokenSupply += totalTokensInBatch;
65     for (uint i = 0; i < minerAddress.length; i ++) {
66       minerTokens[minerAddress[i]] += minerRewardTokens[i];
67     }
68   }
69   
70   // Allow miners to withdraw their earnings from the contract. Update internal accounting.
71   function withdraw() public
72     hasTokens(msg.sender) 
73   {
74     uint32 amount = minerTokens[msg.sender];
75     minerTokens[msg.sender] = 0;
76     totalTokenSupply -= amount;
77     minerTokenPayouts[msg.sender] += amount;
78     tokenContract.transfer(msg.sender, amount);
79   }
80 
81   // Getter function for token balance mapping.
82   function getBalance(address acc) public returns (uint32) {
83       return minerTokens[acc];
84     }
85   
86   
87   // Getter function for token payouts mapping.
88   function getPayouts(address acc) public returns (uint32) {
89       return minerTokenPayouts[acc];
90   }
91   
92   // Fallback function, It's kind of you to send Ether, but we prefer to handle the true currency of
93   // Ethereum here, 0xBitcoin!
94   function () public payable {
95     revert();
96   }
97   
98   // Allow the owner to retrieve accidentally sent Ethereum
99   function withdrawEther(uint32 amount) onlyOwner {
100     owner.transfer(amount);
101   }
102   
103   // Allows the owner to transfer any accidentally sent ERC20 Tokens, excluding 0xBitcoin.
104   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
105     if(tokenAddress == bitcoinContract ){ 
106         revert(); 
107     }
108     return ERC20Interface(tokenAddress).transfer(owner, tokens);
109   }
110 
111 }