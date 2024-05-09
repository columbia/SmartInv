1 pragma solidity ^0.4.21;
2 contract Admin {
3     address public admin;
4 
5     constructor() public {
6         admin = msg.sender;
7     }
8 
9     modifier onlyAdmin() {
10         require(msg.sender == admin);
11         _;
12     }
13 
14     function transferAdminship(address newAdmin) public onlyAdmin {
15         if (newAdmin != address(0)) {
16             admin = newAdmin;
17         }
18     }
19 }
20 contract Pausable is Admin {
21 
22     bool public paused = false;
23 
24 
25     /**
26      * @dev modifier to allow actions only when the contract IS paused
27      */
28     modifier whenNotPaused() {
29         require(!paused);
30         _;
31     }
32 
33     /**
34      * @dev modifier to allow actions only when the contract IS NOT paused
35      */
36     modifier whenPaused {
37         require(paused);
38         _;
39     }
40 
41     /**
42      * @dev called by the admin to pause, triggers stopped state
43      */
44     function pause() public onlyAdmin whenNotPaused returns(bool) {
45         paused = true;
46         return true;
47     }
48 
49     /**
50      * @dev called by the admin to unpause, returns to normal state
51      */
52     function unpause() public onlyAdmin whenPaused returns(bool) {
53         paused = false;
54         return true;
55     }
56 }
57 
58 contract Wallet is Pausable {
59     event DepositWallet(address _depositBy, uint256 _amount);
60     event Withdraw(uint256 _amount);
61     event Transfer(address _to,uint256 _amount);
62     
63     address public owner;
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68     modifier onlyAdminOrOwner() {
69         require(msg.sender == owner || msg.sender == admin);
70         _;
71     }
72     constructor(address _admin,address _who) public {
73         require(_admin != address(0));
74         admin = _admin;
75         owner = _who;
76     }
77     
78     // admin can set anyone as owner, even empty
79     function setOwner(address _who) external onlyAdmin {
80         owner = _who;
81     }
82     
83     function deposit() public payable{
84         emit DepositWallet(msg.sender,msg.value);
85     }
86     
87     function() public payable{
88         emit DepositWallet(msg.sender,msg.value);
89     }
90 
91     function getBalance() public view returns(uint256) {
92         return address(this).balance;
93     }
94     
95     function transfer(address _to,uint256 _amount) external onlyOwner whenNotPaused{
96         require(address(this).balance>=_amount);
97         require(_to!=address(0));
98         if (_amount>0){
99             _to.transfer(_amount);
100         }
101         emit Transfer(_to,_amount);
102     }
103     
104     function withdraw() public onlyOwner whenNotPaused{
105         require(owner!=address(0));
106         uint256 _val = address(this).balance;
107         if (_val>0){
108             owner.transfer(_val);
109         }
110         emit Withdraw(_val);
111     }
112 }
113 
114 contract WalletFactory {
115     event WalletCreated(address admin,address owner, address wallet);
116     mapping(address => address[]) public wallets;
117     address public factoryOwner;
118     
119     constructor() public{
120         factoryOwner = msg.sender;
121     }
122     // you can donate to me
123     function createWallet(address _admin,address _owner) public payable{
124         // you can create max 10 wallets for free
125         if (wallets[msg.sender].length>10){
126             require(msg.value>=0.01 ether);
127         }
128         Wallet w = new Wallet(_admin,_owner);
129         wallets[msg.sender].push(address(w));
130         emit WalletCreated(_admin,_owner, address(w));
131     }
132     
133     function myWallets() public view returns(address[]){
134         return wallets[msg.sender];
135     }
136 
137     function withdraw(address _to) public{
138         require(factoryOwner == msg.sender);
139         require(_to!=address(0));
140         _to.transfer(address(this).balance);
141     }
142     
143     function transferOwnership(address newAdmin) public {
144         require(factoryOwner == msg.sender);
145         if (newAdmin != address(0)) {
146             factoryOwner = newAdmin;
147         }
148     }
149 }