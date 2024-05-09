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
57     address public officalWethAddress;
58 
59     function() public payable{}
60 
61     constructor(address exchangeAddress, address tokenAddress, address wethAddress)
62       public
63     {
64         uniswapExchangeAddress = exchangeAddress;
65         tradeTokenAddress = tokenAddress;
66         officalWethAddress = wethAddress;
67     }
68 
69     function approve(address token, address proxy)
70       public
71       onlyOwner
72     {
73         uint256 MAX_UINT = 2 ** 256 - 1;
74         require(ERC20(token).approve(proxy, MAX_UINT), "Approve failed");
75     }
76 
77     function withdrawETH(uint256 amount)
78         public
79         onlyOwner
80     {
81         owner.transfer(amount);
82     }
83 
84     function withdrawToken(address token, uint256 amount)
85         public
86         onlyOwner
87     {
88       require(ERC20(token).transfer(owner, amount), "Withdraw token failed");
89     }
90 
91     function buyToken(uint256 minTokenAmount, uint256 ethPay, uint256 deadline)
92       public
93       onlyOwner
94     {
95       require(WETH(officalWethAddress).transferFrom(msg.sender, this, ethPay), "Transfer weth failed");
96       WETH(officalWethAddress).withdraw(ethPay);
97       uint256 tokenBought = UNISWAP(uniswapExchangeAddress).ethToTokenSwapInput.value(ethPay)(minTokenAmount, deadline);
98       ERC20(tradeTokenAddress).transfer(owner, tokenBought);
99     }
100 
101     function sellToken(uint256 minEthAmount, uint256 tokenAmount, uint256 deadline)
102       public
103       onlyOwner
104     {
105       require(ERC20(tradeTokenAddress).transferFrom(msg.sender, this, tokenAmount), "Transfer token failed");
106       uint256 ethBought = UNISWAP(uniswapExchangeAddress).tokenToEthSwapInput(tokenAmount, minEthAmount, deadline);
107       WETH(officalWethAddress).deposit.value(ethBought)();
108       WETH(officalWethAddress).transfer(msg.sender, ethBought);
109     }
110 }