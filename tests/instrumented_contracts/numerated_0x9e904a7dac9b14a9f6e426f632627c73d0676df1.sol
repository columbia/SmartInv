1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 
24 }
25 
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) public view returns (uint256);
29   function transfer(address to, uint256 value) public returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 contract IntermediateWallet is Ownable {
34 
35   address public wallet;
36 
37   function IntermediateWallet() public {
38     wallet = 0x246a8bC2bC20826Ba19D8F7FC5799fF69A79388d;
39   }
40 
41   function setWallet(address newWallet) public onlyOwner {
42     wallet = newWallet;
43   }
44 
45   function retrieveTokens(address to, address anotherToken) public onlyOwner {
46     ERC20Basic alienToken = ERC20Basic(anotherToken);
47     alienToken.transfer(to, alienToken.balanceOf(this));
48   }
49 
50   function () payable public {
51     wallet.transfer(msg.value);
52   }
53 
54 }