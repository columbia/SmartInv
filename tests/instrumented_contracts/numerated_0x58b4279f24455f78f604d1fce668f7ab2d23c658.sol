1 pragma solidity ^0.4.23;
2 
3 contract BatchTransfer {
4   address public owner;
5   uint256 public totalTransfer;
6   uint256 public totalAddresses;
7   uint256 public totalTransactions;
8 
9   event Transfers(address indexed from, uint256 indexed value, uint256 indexed count);
10   
11   constructor() public {
12     owner = msg.sender;
13   }
14 
15   modifier restricted() {
16     if (msg.sender == owner) _;
17   }
18 
19   function batchTransfer(address[] _addresses) public payable {
20     require (msg.value > 0 && _addresses.length > 0);
21     totalTransfer += msg.value;
22     totalAddresses += _addresses.length;
23     totalTransactions++;
24     uint256 value = msg.value / _addresses.length;
25     for (uint i = 0; i < _addresses.length; i++) {
26       _addresses[i].transfer(value);
27     }
28     emit Transfers(msg.sender,msg.value,_addresses.length);
29   }
30 
31   function withdraw() public restricted {
32     address contractAddress = this;
33     owner.transfer(contractAddress.balance);
34   }
35 
36   function () payable public {
37     msg.sender.transfer(msg.value);
38   }  
39 }