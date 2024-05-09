1 pragma solidity 0.4.18;
2 
3 contract TestSale {
4 
5   address public owner;
6   bool public active;
7   mapping (address => uint256) public participation;
8 
9   modifier ownerOnly() {
10     require(msg.sender == owner);
11     _;
12   }
13 
14   modifier isActive() {
15     require(active);
16     _;
17   }
18 
19   function TestSale() public {
20     owner = msg.sender;
21     active = false;
22   }
23 
24   function setActive(bool _active) public ownerOnly {
25     active = _active;
26   }
27 
28   function () external payable isActive {
29     participate(msg.sender);
30   }
31 
32   function participate(address _recipient) public payable isActive {
33     participation[_recipient] = participation[_recipient] + msg.value;
34     owner.transfer(msg.value);
35   }
36 
37 }