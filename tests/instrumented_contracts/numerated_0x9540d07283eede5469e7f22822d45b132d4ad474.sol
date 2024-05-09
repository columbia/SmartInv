1 pragma solidity ^0.5.00;
2 
3 interface ERC20TokenInterface {
4   function totalSupply() external returns (uint256 _totalSupply);
5   function balanceOf(address _owner) external returns (uint256 balance) ;
6   function transfer(address _to, uint256 _value) external returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8   function approve(address _spender, uint256 _value) external returns (bool success);
9   function allowance(address _owner, address _spender) external returns (uint256 remaining);
10 
11   event Transfer(address indexed _from, address indexed _to, uint256 _value);
12   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract Owned {
16     address payable public owner;
17     address payable public newOwner;
18 
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     modifier onlyOwner {
24         assert(msg.sender == owner);
25         _;
26     }
27 
28     function transferOwnership(address payable _newOwner) public onlyOwner {
29         require(_newOwner != owner);
30         newOwner = _newOwner;
31     }
32 
33     function acceptOwnership() public {
34         require(msg.sender == newOwner);
35         emit OwnerUpdate(owner, newOwner);
36         owner = newOwner;
37         newOwner = address(0x0);
38     }
39 
40     event OwnerUpdate(address _prevOwner, address _newOwner);
41 }
42 
43 contract TokenWatcher is Owned {
44     address public tokenAddress;
45     uint public timeStart;
46     uint public timeStop;
47     
48     address payable public holder1;
49     address payable public holder2;
50     uint public holder1Balance;
51     uint public holder2Balance;
52     
53     address payable public creditor;
54     
55     event DepositCredited(uint _amount);
56     
57     constructor() public {
58         tokenAddress = address(0x64CdF819d3E75Ac8eC217B3496d7cE167Be42e80);
59         holder1 = address(0xFaF6A6Fd1e53AAa5F00940B123f7504B2dFBDa76);
60         holder2 = address(0x496A65376dc258c38866BDF3ED149e3B3b540b7B);
61         creditor = address(0xCC6326d7Ebdd88477bc4C76285Fd1b7661191aCc);
62         holder1Balance = ERC20TokenInterface(tokenAddress).balanceOf(holder1);
63         holder2Balance = ERC20TokenInterface(tokenAddress).balanceOf(holder2);
64         timeStart = now;
65         timeStop = now + 365 days; // one year since 11.12.2018
66     }
67     
68     function withdrawEthToHolders() public {
69         require(now > timeStop);
70         holder1.transfer(address(this).balance/2);
71         holder2.transfer(address(this).balance);
72     }
73     
74     function withdrawEthToCreditor() public{
75         require(now <= timeStop);
76         uint tempBalance = ERC20TokenInterface(tokenAddress).balanceOf(holder1) + ERC20TokenInterface(tokenAddress).balanceOf(holder2);
77         require(holder1Balance + holder2Balance > tempBalance);
78         creditor.transfer(address(this).balance);
79     }
80     
81     function depositFunds() public payable onlyOwner {
82         emit DepositCredited(msg.value);
83     }
84     
85     function getTime() public view returns (uint){
86         return now;
87     }
88     
89     function contractBalance() public view returns (uint){
90         return address(this).balance;
91     }
92     
93     function kill() public onlyOwner {
94         selfdestruct(owner);
95     }
96 }