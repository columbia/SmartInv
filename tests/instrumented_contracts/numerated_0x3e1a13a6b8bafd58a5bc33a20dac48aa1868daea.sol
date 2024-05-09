1 pragma solidity ^0.4.18;
2 
3 contract MoneyBox {
4 	address public owner;
5 	uint256 public mintarget = 100000000000000000;
6 	mapping(address=>uint256) public balances;
7 	mapping(address=>uint256) public targets;
8 	event Reserved(address indexed _user, uint256 _value);
9 	event Withdrawn(address indexed _user, uint256 _value);
10 	modifier onlyOwner() {
11       if (msg.sender!=owner) revert();
12       _;
13     }
14     
15     function MoneyBox() public {
16     	owner = msg.sender;
17     	targets[owner] = mintarget;
18     }
19     
20     function setMinTarget(uint256 minTarget) public onlyOwner returns (bool ok){
21         mintarget = minTarget;
22         return true;
23     }
24     function setTarget(uint256 target) public returns (bool ok){
25         if (target<mintarget || balances[msg.sender]<=0) revert();
26         targets[msg.sender] = target;
27         return true;
28     }
29     
30     function withdrawMoney(uint256 sum) public returns (bool ok){
31         if (sum<=0 || balances[msg.sender]<targets[msg.sender] || balances[msg.sender]<sum) revert();
32         balances[msg.sender] -= sum;
33         uint256 bonus = sum*2/100;
34         balances[owner] += bonus;
35         msg.sender.transfer(sum-bonus);
36         Withdrawn(msg.sender,sum);
37         return true;
38     }
39     
40     function reserveMoney() private{
41         balances[msg.sender] += msg.value;
42         targets[msg.sender] = mintarget;
43         Reserved(msg.sender,msg.value);
44     }
45     
46     function () payable public {
47         reserveMoney();
48     }
49 }