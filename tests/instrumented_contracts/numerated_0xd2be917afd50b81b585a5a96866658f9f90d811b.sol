1 pragma solidity ^0.4.19;
2 
3 contract SimpleEthBank {
4     address public director;
5     mapping (address => uint) accountBalances;
6     mapping (address => bool) accountExists;
7 
8     event Deposit(address from, uint amount);
9     event Withdrawal(address from, uint amount);
10     event Transfer(address from, address to, uint amount);
11 
12     function SimpleEthBank() {
13         director = msg.sender;
14     }
15 
16     function() public payable {
17         deposit();
18     }
19 
20     function getBalanceOf(address addr) public constant returns(int) {
21         if (accountExists[addr])
22             return int(accountBalances[addr]);
23         return -1;
24     }
25 
26     function deposit() public payable {
27         require(msg.value >= 0.5 ether);
28         accountBalances[msg.sender] += msg.value;
29         accountExists[msg.sender] = true;
30         Deposit(msg.sender, msg.value);
31     }
32 
33     function withdraw(uint amount) public {
34         require(accountExists[msg.sender] && accountBalances[msg.sender] >= amount);
35         accountBalances[msg.sender] -= amount;
36         msg.sender.call.value(amount);
37         Withdrawal(msg.sender, amount);
38     }
39 
40     function transfer(address to, uint amount) public {
41         require(accountExists[msg.sender] && accountExists[to]);
42         require(msg.sender != to);
43         require(accountBalances[msg.sender] >= amount);
44         accountBalances[to] += amount;
45         Transfer(msg.sender, to, amount);
46     }
47 
48     function kill() public {
49         require(msg.sender == director);
50         selfdestruct(director);
51     }
52 }