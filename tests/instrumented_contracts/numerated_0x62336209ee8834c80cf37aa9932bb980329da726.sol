1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 contract IDAP {
8   function transfer(address to, uint256 value) public returns (bool);
9 
10   function approve(address spender, uint256 value) public returns (bool);
11 
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14   function balanceOf(address who) public view returns (uint256);
15 
16   function allowance(address owner, address spender) public view returns (uint256);
17 
18   function burn(uint _amount) public;
19 
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract SwapIn {
26   IDAP public dapToken = IDAP(0x780ec47d3696Fe6fc8Cd273D2420721bCEf936c5);
27 
28   event SwapIn(address user, string receiver, uint amount);
29 
30   function swapIn(string receiver) public {
31     uint userBalance = dapToken.balanceOf(msg.sender);
32     require(dapToken.transferFrom(msg.sender, address(0x0), userBalance), 'Burn token failed');
33     emit SwapIn(msg.sender, receiver, userBalance);
34   }
35 }