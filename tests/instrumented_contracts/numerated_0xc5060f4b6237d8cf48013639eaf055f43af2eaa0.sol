1 pragma solidity ^0.4.25;
2 // Interface to ERC20 functions used in this contract
3 interface ERC20token {
4     function balanceOf(address who) external view returns (uint256);
5     function transfer(address to, uint256 value) external returns (bool);
6     function allowance(address owner, address spender) external view returns (uint256);
7     function transferFrom(address from, address to, uint256 value) external returns (bool);
8 }
9 contract ExoTokensMarketSimple {
10     ERC20token ExoToken;
11     address owner;
12     uint256 pricePerToken;
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     function setPricePerToken(uint256 ethPrice) public onlyOwner {
22         pricePerToken = ethPrice;
23     }
24     function getPricePerToken() public view returns(uint256) {
25         return pricePerToken;
26     }
27     function setERC20Token(address tokenAddr) public onlyOwner  {
28         ExoToken = ERC20token(tokenAddr);
29     }
30     function getERC20Token() public view returns(address) {
31         return ExoToken;
32     }
33     function getERC20Balance() public view returns(uint256) {
34         return ExoToken.balanceOf(this);
35     }
36     function depositERC20Token(uint256 _exo_amount) public  {
37         require(ExoToken.allowance(msg.sender, this) >= _exo_amount);
38         require(ExoToken.transferFrom(msg.sender, this, _exo_amount));
39     }
40 
41     // EXO buying function
42     // All of the ETH included in the TX is converted to EXO and the remainder is sent back
43     function BuyTokens() public payable{
44         uint256 exo_balance = ExoToken.balanceOf(this);
45         uint256 tokensToXfer = msg.value / pricePerToken;
46         require(exo_balance >= tokensToXfer, "Not enough tokens in contract");
47         uint256 return_ETH_amount = msg.value - (tokensToXfer *pricePerToken);
48         require(return_ETH_amount < msg.value); // just in case
49 
50         if(return_ETH_amount > 0){
51             msg.sender.transfer(return_ETH_amount); // return extra ETH
52         }
53 
54         require(ExoToken.transfer(msg.sender, tokensToXfer), "Couldn't send funds"); // send EXO tokens
55     }
56 
57     // Withdraw erc20 tokens
58     function withdrawERC20Tokens(uint _val) public onlyOwner {
59         require(ExoToken.transfer(msg.sender, _val), "Couldn't send funds"); // send EXO tokens
60     }
61 
62     // Withdraw Ether
63     function withdrawEther() public onlyOwner {
64         msg.sender.transfer(address(this).balance);
65 
66     }
67  
68     // change the owner
69     function setOwner(address _owner) public onlyOwner {
70         owner = _owner;    
71     }
72     // fallback
73     function() external payable { }   
74 }