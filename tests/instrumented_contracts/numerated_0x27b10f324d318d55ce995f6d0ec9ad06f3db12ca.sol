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
12     uint256 tokensPerEth;
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17     constructor() public {
18         owner = msg.sender;
19         tokensPerEth = 1000;
20     }
21 
22     function setTokensPerEth(uint256 _tokensPerEth) public onlyOwner {
23         tokensPerEth = _tokensPerEth;
24     }
25     function getTokensPerEth() public view returns(uint256) {
26         return tokensPerEth;
27     }
28     function setERC20Token(address tokenAddr) public onlyOwner  {
29         ExoToken = ERC20token(tokenAddr);
30     }
31     function getERC20Token() public view returns(address) {
32         return ExoToken;
33     }
34     function getERC20Balance() public view returns(uint256) {
35         return ExoToken.balanceOf(this);
36     }
37     function depositERC20Token(uint256 _exo_amount) public  {
38         require(ExoToken.allowance(msg.sender, this) >= _exo_amount);
39         require(ExoToken.transferFrom(msg.sender, this, _exo_amount));
40     }
41 
42     // EXO buying function
43     // All of the ETH included in the TX is converted to EXO
44     function BuyTokens() public payable{
45         require(msg.value > 0, "eth value must be non zero");
46         uint256 exo_balance = ExoToken.balanceOf(this);
47         uint256 tokensToXfer = msg.value * tokensPerEth;
48         require(exo_balance >= tokensToXfer, "Not enough tokens in contract");
49         require(ExoToken.transfer(msg.sender, tokensToXfer), "Couldn't send funds");
50     }
51 
52     // Withdraw erc20 tokens
53     function withdrawERC20Tokens(uint _val) public onlyOwner {
54         require(ExoToken.transfer(msg.sender, _val), "Couldn't send funds"); // send EXO tokens
55     }
56 
57     // Withdraw Ether
58     function withdrawEther() public onlyOwner {
59         msg.sender.transfer(address(this).balance);
60 
61     }
62  
63     // change the owner
64     function setOwner(address _owner) public onlyOwner {
65         owner = _owner;    
66     }
67     // fallback
68     function() external payable { }   
69 }