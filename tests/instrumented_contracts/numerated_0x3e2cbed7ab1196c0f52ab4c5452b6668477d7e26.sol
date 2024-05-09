1 pragma solidity ^0.4.0;
2 
3 contract ChessBank{
4     
5     mapping (address => uint) private balances;
6     
7     address public owner;
8     
9     event depositDone(string message, address accountAddress, uint amount);
10     event withdrawalDone(string message, address accountAddress, uint amount);
11     
12     function BankContract() public {
13         owner = msg.sender;
14     }
15     
16     function deposit() public payable {
17         balances[msg.sender] += msg.value;
18         depositDone("A deposit was done", msg.sender, msg.value);
19     }
20     
21     function withdraw(uint amount) public {
22         require(balances[msg.sender] >= amount);
23         balances[msg.sender] -= amount;
24         
25         if(!msg.sender.send(amount)){
26             balances[msg.sender] += amount;
27         }
28         else{
29             withdrawalDone("A withdrawal was done", msg.sender, amount);
30         }
31         
32     }
33     
34     function getBalance() public constant returns (uint){
35         return balances[msg.sender];
36     }
37 }