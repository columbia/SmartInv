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
32     function withdraw(uint amount) public {
33         require(accountExists[msg.sender] && accountBalances[msg.sender] >= amount);
34         accountBalances[msg.sender] -= amount;
35         msg.sender.call.value(amount);
36         Withdrawal(msg.sender, amount);
37     }
38 
39     function transfer(address to, uint amount) public {
40         require(accountExists[msg.sender] && accountExists[to] && accountBalances[msg.sender] >= amount);
41         accountBalances[to] += amount;
42         Transfer(msg.sender, to, amount);
43     }
44 
45     function kill() public {
46         require(msg.sender == director);
47         selfdestruct(director);
48     }
49 }