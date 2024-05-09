1 pragma solidity ^0.4.22;
2 
3 
4 contract ERC20Basic {
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address who) public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract Ownable {
12     address public owner;
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22 }
23 
24 contract DarkPool is Ownable {
25     ERC20Basic hodl;
26     uint public end;
27     uint public raised;
28     uint public cap;
29     mapping(address => uint) public balances;
30     event Deposit(address indexed beneficiary, uint value);
31     event Withdraw(address indexed beneficiary, uint value);
32 
33     function () external payable whenActive {
34         require(whitelisted(msg.sender), "for hodl owners only");
35         raised += msg.value;
36         balances[msg.sender] += msg.value;
37         require(raised <= cap, "raised too much ether");
38         emit Deposit(msg.sender, msg.value);
39     }
40     
41     function withdraw(address beneficiary) external onlyOwner whenEnded {
42         uint balance = address(this).balance;
43         beneficiary.transfer(balance);
44         emit Withdraw(beneficiary, balance);
45     }
46     
47     function reclaimToken(ERC20Basic token) external onlyOwner {
48         uint256 balance = token.balanceOf(this);
49         token.transfer(owner, balance);
50     }
51     
52     function whitelisted(address _address) public view returns (bool) {
53         return hodl.balanceOf(_address) > 0;
54     }
55     
56     function active() public view returns (bool) {
57         return now < end;
58     }
59     
60     modifier whenEnded() {
61         require(!active());
62         _;
63     }
64     
65     modifier whenActive() {
66         require(active());
67         _;
68     }
69 }
70 
71 contract DarkPool1 is DarkPool {
72     constructor() public {
73         hodl = ERC20Basic(0x433e077D4da9FFC4b353C1Bf1eD69DAAc8f78aA5);
74         end = 1524344400;
75         cap = 600 ether;
76     }
77 }