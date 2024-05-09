1 pragma solidity ^0.4.18;
2 
3 contract Storage {
4   address public owner;
5   uint256 public storedAmount;
6 
7   function Storage() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner{
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function()
17   public
18   payable {
19     storeEth();
20   }
21 
22   function storeEth()
23   public
24   payable {
25     storedAmount += msg.value;
26   }
27 
28   function getEth()
29   public
30   onlyOwner{
31     storedAmount = 0;
32     owner.transfer(this.balance);
33   }
34 
35   function sendEthTo(address to)
36   public
37   onlyOwner{
38     storedAmount = 0;
39     to.transfer(this.balance);
40   }
41 }