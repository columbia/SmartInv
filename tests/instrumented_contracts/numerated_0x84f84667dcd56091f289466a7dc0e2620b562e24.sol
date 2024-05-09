1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a + b;
21     require(c >= a);
22     return c;
23   }
24 }
25 
26 contract Factory{
27 	function getExchange(address token_addr) public view returns(address);
28 }
29 
30 contract Exchange{
31 	function tokenToEthSwapInput(uint256 token_sold, uint256 min_eth,uint256 deadline) public returns(uint256);
32 }
33 
34 contract ERC20 {
35     function balanceOf(address _owner) view public returns(uint256);
36     function allowance(address _owner, address _spender) view public returns(uint256);
37     function transfer(address _to, uint256 _value) public returns(bool);
38     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
39     function approve(address _spender, uint256 _value) public returns(bool);
40     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool);
41 }
42 
43 contract CryptoCow is ERC20{
44 	function selltoken(uint256 _amount) public;
45 	function buyToken() public payable;
46 }
47 
48 contract CowSwap{
49 	Factory factory = Factory(0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95);
50 	CryptoCow cow = CryptoCow(0xFDb0065240753FEF4880a9CC7876be59E09D78BB);
51 
52 	function () public payable{}
53 
54 	function tokenToCow(address token, uint256 amount) public {
55 
56 		ERC20 erc20 = ERC20(token);
57 		address t = factory.getExchange(token);
58 		require(t != address(0));
59 		Exchange te = Exchange(t);
60 
61 		require(erc20.transferFrom(msg.sender, address(this), amount));
62 		erc20.approve(t, amount);
63 		te.tokenToEthSwapInput(amount, 1, now);
64 
65 		uint256 ethIn = address(this).balance;
66 		cow.buyToken.value(ethIn)();
67 
68 		uint256 cowBought = cow.balanceOf(address(this));
69 		cow.transfer(msg.sender, cowBought);
70 	}
71 }