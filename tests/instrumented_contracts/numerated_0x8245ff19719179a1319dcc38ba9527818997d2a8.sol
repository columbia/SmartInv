1 pragma solidity ^0.4.24;
2 
3 interface BadERC20 {
4     function transfer(address _to, uint256 _value) external;
5 }
6 
7 interface GoodERC20 {
8     function transfer(address _to, uint256 _value) external returns (bool);
9 }
10 
11 contract TokenTransferTest {
12 
13     uint public GOOD_ERC20 = 1;
14     uint public BAD_ERC20 = 2;
15 
16     function ()
17         payable
18         external
19     {
20         revert();
21     }
22 
23     function testBadWithGoodInterface(address token,
24                                       uint ercType,
25                                       address to,
26                                       uint value)
27         external
28     {
29         if (ercType == 1) {
30             GoodERC20 goodErc20 = GoodERC20(token);
31             require(goodErc20.transfer(to, value));
32         } else {
33             BadERC20 badErc20 = BadERC20(token);
34             badErc20.transfer(to, value);
35         }
36     }
37 
38 }