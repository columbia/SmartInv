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
55     address public wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
56 
57     function() public payable{}
58 
59     function withdrawETH(uint256 amount)
60         public
61         onlyOwner
62     {
63         owner.transfer(amount);
64     }
65 
66     function withdrawToken(address token, uint256 amount)
67         public
68         onlyOwner
69     {
70       require(ERC20(token).transfer(owner, amount), "Withdraw token failed");
71     }
72 
73     function buyToken(address tokenAddress, address exchangeAddress, uint256 minTokenAmount, uint256 ethPay, uint256 deadline)
74       public
75       onlyOwner
76     {
77       require(WETH(wethAddress).transferFrom(msg.sender, this, ethPay), "Transfer weth failed");
78       WETH(wethAddress).withdraw(ethPay);
79       uint256 tokenBought = UNISWAP(exchangeAddress).ethToTokenSwapInput.value(ethPay)(minTokenAmount, deadline);
80       ERC20(tokenAddress).transfer(owner, tokenBought);
81     }
82 
83     function sellToken(address tokenAddress, address exchangeAddress,uint256 minEthAmount, uint256 tokenPay, uint256 deadline)
84       public
85       onlyOwner
86     {
87       uint256 tokenApprove = ERC20(tokenAddress).allowance( this, exchangeAddress );
88       if (tokenApprove<tokenPay) {
89           uint256 MAX_UINT = 2 ** 256 - 1;
90           require(ERC20(tokenAddress).approve(exchangeAddress, MAX_UINT), "Approve failed");
91       }
92       require(ERC20(tokenAddress).transferFrom(msg.sender, this, tokenPay), "Transfer token failed");
93       uint256 ethBought = UNISWAP(exchangeAddress).tokenToEthSwapInput(tokenPay, minEthAmount, deadline);
94       WETH(wethAddress).deposit.value(ethBought)();
95       WETH(wethAddress).transfer(msg.sender, ethBought);
96     }
97 }