1 pragma solidity ^0.4.24;
2 
3 contract FUTC {
4   function claimEth() public;
5   function claimToken(address _tokenAddr, address _payee) public;
6 }
7 contract ERC20 {
8   function balanceOf(address _who) public view returns (uint256);
9   function transfer(address _to, uint256 _value) public returns (bool);
10 }
11 
12 contract FUTCHelper {
13   address public constant FUTC1 = 0xf880d3C6DCDA42A7b2F6640703C5748557865B35;
14   FUTC futc = FUTC(address(0xdaa6CD28E6aA9d656930cE4BB4FA93eEC96ee791));
15   constructor() public {}
16   function () public payable {}
17   function transferEth() public {
18     futc.claimEth();
19     address(FUTC1).transfer(address(this).balance);
20   }
21   function transferToken(address _token) public {
22     futc.claimToken(_token, address(this));
23     uint amt = ERC20(_token).balanceOf(address(this));
24     if (amt > 0) {
25       ERC20(_token).transfer(FUTC1, amt);
26     }
27   }
28 }