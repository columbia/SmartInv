1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf( address who ) public view returns (uint value);
6     function allowance( address owner, address spender ) public view returns (uint _allowance);
7     function transfer( address to, uint value) public returns (bool ok);
8     function transferFrom( address from, address to, uint value) public returns (bool ok);
9     function approve( address spender, uint value ) public returns (bool ok);
10 }
11 
12 contract WETH {
13     function deposit() public payable;
14     function withdraw(uint wad) public;
15 
16     function approve(address guy, uint wad) public returns (bool); 
17     function transfer(address dst, uint wad) public returns (bool);
18     function transferFrom(address src, address dst, uint wad) public returns (bool);
19 } 
20 
21 contract UNISWAP {
22     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) public payable returns (uint256);
23     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) public returns(uint256);
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     constructor ()
30         public
31     {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(
37             msg.sender == owner,
38             "ONLY_CONTRACT_OWNER"
39         );
40         _;
41     }
42 
43     function transferOwnership(address newOwner)
44         public
45         onlyOwner
46     {
47         if (newOwner != address(0)) {
48             owner = newOwner;
49         }
50     }
51 }
52 
53 contract UniswapWrapper is Ownable{
54 
55     address public uniswapExchangeAddress;
56     address public tradeTokenAddress;
57     address public wethAddress;
58 
59     constructor(address exchangeAddress, address tokenAddress, address wethAddress)
60       public
61     {
62         uniswapExchangeAddress = exchangeAddress;
63         tradeTokenAddress = tokenAddress;
64         wethAddress = wethAddress;
65     }
66 
67     function approve(address token, address proxy)
68       public
69       onlyOwner
70     {
71         uint256 MAX_UINT = 2 ** 256 - 1;
72         require(ERC20(token).approve(proxy, MAX_UINT), "Approve failed");
73     }
74 
75     function withdrawETH(uint256 amount)
76         public
77         onlyOwner
78     {
79         owner.transfer(amount);
80     }
81 
82     function withdrawToken(address token, uint256 amount)
83         public
84         onlyOwner
85     {
86       require(ERC20(token).transfer(owner, amount), "Withdraw token failed");
87     }
88 
89     function buyToken(uint256 minTokenAmount, uint256 ethPay, uint256 deadline)
90       public
91       onlyOwner
92     {
93       require(WETH(wethAddress).transferFrom(msg.sender, this, ethPay), "Transfer weth failed");
94       WETH(wethAddress).withdraw(ethPay);
95       uint256 tokenBought = UNISWAP(uniswapExchangeAddress).ethToTokenSwapInput.value(ethPay)(minTokenAmount, deadline);
96       ERC20(tradeTokenAddress).transfer(owner, tokenBought);
97     }
98 
99     function sellToken(uint256 minEthAmount, uint256 tokenAmount, uint256 deadline)
100       public
101       onlyOwner
102     {
103       require(ERC20(tradeTokenAddress).transferFrom(msg.sender, this, tokenAmount), "Transfer token failed");
104       uint256 ethBought = UNISWAP(uniswapExchangeAddress).tokenToEthSwapInput(tokenAmount, minEthAmount, deadline);
105       WETH(wethAddress).deposit.value(ethBought)();
106       WETH(wethAddress).transfer(msg.sender, ethBought);
107     }
108 }