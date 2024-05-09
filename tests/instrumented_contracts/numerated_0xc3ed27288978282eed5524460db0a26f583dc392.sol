1 pragma solidity ^0.4.22;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 contract DiscordPool is Ownable {
18     uint public raised;
19     bool public active = true;
20     mapping(address => uint) public balances;
21     event Deposit(address indexed beneficiary, uint value);
22     event Withdraw(address indexed beneficiary, uint value);
23 
24     function () external payable whenActive {
25         raised += msg.value;
26         balances[msg.sender] += msg.value;
27         emit Deposit(msg.sender, msg.value);
28     }
29     
30     function finalize() external onlyOwner {
31         active = false;
32     }
33     
34     function withdraw(address beneficiary) external onlyOwner whenEnded {
35         uint balance = address(this).balance;
36         beneficiary.transfer(balance);
37         emit Withdraw(beneficiary, balance);
38     }
39 
40     modifier whenEnded() {
41         require(!active);
42         _;
43     }
44     
45     modifier whenActive() {
46         require(active);
47         _;
48     }
49 }