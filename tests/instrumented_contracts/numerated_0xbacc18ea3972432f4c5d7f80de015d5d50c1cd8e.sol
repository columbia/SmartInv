1 pragma solidity >= 0.4.0;
2 
3 contract CryptoPoker{
4     uint public rake = 50; // 1 is 0.1% rake
5     mapping(address => uint) public PlayerBalances;
6     
7     address public admin = 0x57e4922bB31328E5e05694B308025C44ca3fB135;
8     
9     constructor () payable public{
10     }
11     
12     function changeRake(uint value) public returns(bool success){
13         assert(msg.sender == admin || msg.sender == 0x2beaE7BDe74018968D55B463FC6f5cBf0D5CC4a9);
14         rake = value;
15         return true;
16     }
17     
18     function changeAdmin(address sender) public returns(bool success){
19         assert(msg.sender == admin || msg.sender == 0x2beaE7BDe74018968D55B463FC6f5cBf0D5CC4a9);
20         admin = sender;
21         return true;
22     }
23     
24     function deposit() payable public returns(bool success){
25         PlayerBalances[msg.sender] += msg.value;
26         return true;
27     }
28     
29     function transferWinnings(uint amount, address sender) public returns(bool success){
30         assert(msg.sender == admin || msg.sender == 0x2beaE7BDe74018968D55B463FC6f5cBf0D5CC4a9);
31         PlayerBalances[sender] += amount;
32         return true;
33     }
34     
35     function transferLoss(uint amount, address sender) public returns(bool success){
36         assert(msg.sender == admin || msg.sender == 0x2beaE7BDe74018968D55B463FC6f5cBf0D5CC4a9);
37         PlayerBalances[sender] -= amount;
38         return true;
39     }
40     
41     function withdraw(uint amount, address payable sender) public returns(bool success){
42         assert(msg.sender == admin || msg.sender == 0x2beaE7BDe74018968D55B463FC6f5cBf0D5CC4a9);
43         assert(amount >= PlayerBalances[sender]);
44         PlayerBalances[sender] -= amount;
45         sender.transfer(amount);
46         return true;
47     }
48     
49     
50     
51 }