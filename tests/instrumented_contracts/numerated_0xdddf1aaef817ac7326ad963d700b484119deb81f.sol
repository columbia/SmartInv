1 pragma solidity ^0.4.18;
2 
3 contract Distributor {
4 
5   address public owner;
6 
7   mapping (address => uint) public received;
8     
9   mapping (address => uint) public balances;
10 
11   address[] public receivers;
12   
13   uint public index;
14   
15   uint public total;
16 
17   modifier onlyOwner() {
18     require(owner == msg.sender);
19     _;
20   }
21   
22   function Distributor() public {
23       owner = msg.sender;
24   }
25   
26   function addReceivers(address[] _receivers, uint[] _balances) public onlyOwner {
27     for(uint i = 0; i < _receivers.length; i++) {
28       address receiver = _receivers[i];
29       require(balances[receiver] == 0);
30       balances[receiver] = _balances[i];
31       total += _balances[i];
32       receivers.push(receiver);
33     }
34   }
35 
36   function process(uint count) public onlyOwner {
37     for(uint i = 0; index < receivers.length && i < count; i++) {
38       address receiver = receivers[index];
39       require(received[receiver] == 0);
40       uint value = balances[receiver];
41       received[receiver] = balances[receiver];
42       receiver.transfer(value);
43       index++;
44     }
45   }
46 
47   function () public payable {
48   }
49   
50   function retreive() public onlyOwner {
51     owner.transfer(this.balance);
52   }
53     
54 }