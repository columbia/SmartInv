1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     function setOwner(address _owner) public onlyOwner {
12         owner = _owner;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20 }
21 
22 contract Vault is Ownable { 
23 
24     function () public payable {
25 
26     }
27 
28     function getBalance() public view returns (uint) {
29         return address(this).balance;
30     }
31 
32     function withdraw(uint amount) public onlyOwner {
33         require(address(this).balance >= amount);
34         owner.transfer(amount);
35     }
36 
37     function withdrawAll() public onlyOwner {
38         withdraw(address(this).balance);
39     }
40 }