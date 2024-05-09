1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4      function totalSupply() public constant returns (uint);
5      function balanceOf(address tokenOwner) public constant returns (uint balance);
6      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7      function transfer(address to, uint tokens) public returns (bool success);
8      function approve(address spender, uint tokens) public returns (bool success);
9      function transferFrom(address from, address to, uint tokens) public returns (bool success);
10      event Transfer(address indexed from, address indexed to, uint tokens);
11      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 contract BitFluxADContract {
14     
15   // The token being sold
16   ERC20Interface public token;
17 
18   
19   // address where funds are collected
20   // address where tokens are deposited and from where we send tokens to buyers
21   address public wallet;
22 
23   /**
24    * event for token purchase logging
25    * @param purchaser who paid for the tokens
26    * @param beneficiary who got the tokens
27    * @param value weis paid for purchase
28    * @param amount amount of tokens purchased
29    */
30   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
31 
32   function BitFluxADContract(address _wallet, address _tokenAddress) public 
33   {
34     require(_wallet != 0x0);
35     require (_tokenAddress != 0x0);
36     wallet = _wallet;
37     token = ERC20Interface(_tokenAddress);
38   }
39   
40   // fallback function can be used to buy tokens
41   function () public payable {
42     throw;
43   }
44 
45     /**
46      * airdrop to token holders
47      **/ 
48     function BulkTransfer(address[] tokenHolders, uint amount) public {
49         require(msg.sender==wallet);
50         for(uint i = 0; i<tokenHolders.length; i++)
51         {
52             token.transferFrom(wallet,tokenHolders[i],amount);
53         }
54     }
55 }