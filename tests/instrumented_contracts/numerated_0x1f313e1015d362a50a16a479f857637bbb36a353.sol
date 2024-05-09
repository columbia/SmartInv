1 pragma solidity ^0.4.16;
2 
3 contract LineOfTransfers {
4 
5     address[] public accounts;
6     uint[] public values;
7     
8     uint public transferPointer = 0;
9 
10     address public owner;
11 
12     event Transfer(address to, uint amount);
13 
14     modifier hasBalance(uint index) {
15         require(this.balance >= values[index]);
16         _;
17     }
18     
19     modifier existingIndex(uint index) {
20         assert(index < accounts.length);
21         assert(index < values.length);
22         _;
23     }
24     
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     function () payable public {}
31 
32     function LineOfTransfers() public {
33         owner = msg.sender;
34     }
35 
36     function transferTo(uint index) existingIndex(index) hasBalance(index) internal returns (bool) {
37         uint amount = values[index];
38         accounts[index].transfer(amount);
39 
40         Transfer(accounts[index], amount);
41         return true;
42     }
43 
44     function makeTransfer(uint times) public {
45         while(times > 0) {
46             transferTo(transferPointer);
47             transferPointer++;
48             times--;
49         }
50     }
51     
52     function getBalance() constant returns (uint balance) {
53         return this.balance;
54     }
55     
56     function addData(address[] _accounts, uint[] _values) onlyOwner {
57         require(_accounts.length == _values.length);
58         
59         for (uint i = 0; i < _accounts.length; i++) {
60             accounts.push(_accounts[i]);
61             values.push(_values[i]);
62         }
63     }
64     
65     
66     function terminate() onlyOwner {
67         selfdestruct(owner);
68     }
69 }