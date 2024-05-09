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
21 contract UNISWAPFactory {
22     function getExchange(address token) public returns (address);
23 }
24 
25 contract UNISWAP {
26     function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) public payable returns (uint256);
27     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) public returns(uint256);
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     constructor ()
34         public
35     {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40         require(
41             msg.sender == owner,
42             "ONLY_CONTRACT_OWNER"
43         );
44         _;
45     }
46 
47     function transferOwnership(address newOwner)
48         public
49         onlyOwner
50     {
51         if (newOwner != address(0)) {
52             owner = newOwner;
53         }
54     }
55 }
56 
57 contract UniswapWrapper is Ownable{
58 
59     address public factory = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
60     address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
61 
62     function() public payable{}
63 
64     function getExchangeAddress(address token)
65         public
66         returns (address)
67     {
68         address exchangeAddress = UNISWAPFactory(factory).getExchange(token);
69         require(exchangeAddress!=0x0, "exchange not exist");
70         return exchangeAddress;
71     }
72 
73     function approve(address token)
74       public
75       onlyOwner
76     {
77         address exchangeAddress = getExchangeAddress(token);
78         uint256 MAX_UINT = 2 ** 256 - 1;
79         require(ERC20(token).approve(exchangeAddress, MAX_UINT), "Approve failed");
80     }
81 
82     function withdrawETH(uint256 amount)
83         public
84         onlyOwner
85     {
86         owner.transfer(amount);
87     }
88 
89     function withdrawToken(address token, uint256 amount)
90         public
91         onlyOwner
92     {
93       require(ERC20(token).transfer(owner, amount), "Withdraw token failed");
94     }
95 
96     function buyToken(address tokenAddress, uint256 minTokenAmount, uint256 ethPay, uint256 deadline)
97       public
98     {
99       address exchangeAddress = getExchangeAddress(tokenAddress);
100       require(WETH(wethAddress).transferFrom(msg.sender, this, ethPay), "Transfer weth failed");
101       WETH(wethAddress).withdraw(ethPay);
102       uint256 tokenBought = UNISWAP(exchangeAddress).ethToTokenSwapInput.value(ethPay)(minTokenAmount, deadline);
103       ERC20(tokenAddress).transfer(msg.sender, tokenBought);
104     }
105 
106     function sellToken(address tokenAddress,uint256 minEthAmount, uint256 tokenPay, uint256 deadline)
107       public
108     {
109       address exchangeAddress = getExchangeAddress(tokenAddress);
110       require(ERC20(tokenAddress).transferFrom(msg.sender, this, tokenPay), "Transfer token failed");
111       uint256 ethBought = UNISWAP(exchangeAddress).tokenToEthSwapInput(tokenPay, minEthAmount, deadline);
112       WETH(wethAddress).deposit.value(ethBought)();
113       WETH(wethAddress).transfer(msg.sender, ethBought);
114     }
115 }