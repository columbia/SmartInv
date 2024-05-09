1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 }
21 
22 contract MultiEthSender {
23   using SafeMath for uint256;
24 
25   event Send(uint256 _amount, address indexed _receiver);
26   
27   function() public payable {
28   }
29 
30   function multiSendEth(
31     uint256 amount, 
32     address[] list
33   ) 
34   external 
35   returns (bool) 
36   {
37 
38     uint256 totalList = list.length;
39     uint256 totalAmount = amount.mul(totalList);
40     require(address(this).balance > totalAmount);
41 
42     for (uint256 i = 0; i < list.length; i++) {
43       require(list[i] != address(0));
44       require(list[i].send(amount));
45 
46       emit Send(amount, list[i]);
47     }
48 
49     return true;
50   }
51 
52 }