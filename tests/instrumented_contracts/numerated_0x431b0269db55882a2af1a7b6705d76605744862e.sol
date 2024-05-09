1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   } 
15   function transferOwnership(address newOwner) public onlyOwner {
16     require(newOwner != address(0));
17     emit OwnershipTransferred(owner, newOwner);
18     owner = newOwner;
19   }
20 
21 }
22 
23 contract EthAirdrop is Ownable {
24   uint256 public amountToSend;
25 
26   function() payable public {}
27   
28   function destroyMe() onlyOwner public {
29     selfdestruct(owner);
30   }
31 
32   function sendEth(address[] addresses) onlyOwner public {
33     for (uint256 i = 0; i < addresses.length; i++) {
34       addresses[i].transfer(amountToSend);
35       emit TransferEth(addresses[i], amountToSend);
36     }
37   }
38 
39   function changeAmount(uint256 _amount) onlyOwner public {
40     amountToSend = _amount;
41   }
42 
43   function getEth() onlyOwner public {
44     owner.transfer(address(this).balance);
45   }
46   
47   event TransferEth(address _address, uint256 _amount);
48 }