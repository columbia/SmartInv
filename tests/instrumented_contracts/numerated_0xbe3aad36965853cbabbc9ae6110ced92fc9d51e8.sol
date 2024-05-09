1 pragma solidity ^0.5.1;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender==owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         newOwner=_newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender==newOwner) {
15             owner=newOwner;
16         }
17     }
18 }
19 
20 contract ERC20 {
21     function balanceOf(address _owner) view public returns (uint256 balance);
22     function transfer(address _to, uint256 _value) public returns (bool success);
23 }
24 
25 contract UnlockVideo is Owned{
26     uint256 add;
27     uint8 fee;
28     uint8 bonus;
29     address token;
30     mapping (address=>uint256) donates;
31     mapping (bytes32=>address) videos;
32     mapping (address=>uint256) balances;
33     event Donate(address indexed _owner, uint256 _amount);
34     event Video(address indexed _sender, bytes32 _id);
35         
36     constructor() public{
37         add = 5000000000000000;
38         fee = 2;
39         bonus = 10;
40         token = 0xCD8aAC9972dc4Ddc48d700bc0710C0f5223fBCfa;
41         owner = msg.sender;
42     }
43     
44     function addVideo(bytes32 _id) public returns (bool success){
45         require (videos[_id]==address(0x0) && balances[msg.sender]>=add);
46         videos[_id] = msg.sender;
47         balances[msg.sender] -= add;
48         if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
49         owner.transfer(add);
50         return true;
51     }
52     
53     function changeDonate(uint256 _donate) public returns (bool success){
54         require(_donate>0);
55         donates[msg.sender] = _donate;
56         return true;
57     }
58     
59     function donateVideo(bytes32 _id) public returns (bool success){
60         require(videos[_id]!=address(0x0) && balances[msg.sender]>=donates[videos[_id]]);
61         balances[videos[_id]] += donates[videos[_id]];
62         balances[msg.sender] -= donates[videos[_id]];
63         if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
64         emit Donate(videos[_id], donates[videos[_id]]);
65         emit Video(msg.sender, _id);
66         return true;
67     }
68     
69     function changeAdd (uint256 _add) onlyOwner public returns (bool success){
70         require (_add>0);
71         add=_add;
72         return true;
73     }
74     
75     function changeFee (uint8 _fee) onlyOwner public returns (bool success){
76         require (_fee>0);
77         fee=_fee;
78         return true;
79     }
80     
81     function changeBonus (uint8 _bonus) onlyOwner public returns (bool success){
82         require (_bonus>0);
83         bonus=_bonus;
84         return true;
85     }
86     
87     function getBalance(address _owner) view public returns (uint256 balance){
88         return balances[_owner];
89     }
90     
91     function withdrawEth(uint256 _amount) public returns (bool success){
92         require(_amount>0 && balances[msg.sender]>=_amount);
93         uint256 deduct = _amount*fee/100;
94         owner.transfer(deduct);
95         msg.sender.transfer(_amount-deduct);
96         return true;
97     }
98     
99     function () payable external {
100         require(msg.value>0);
101         uint256 deduct = msg.value*fee/100;
102         owner.transfer(deduct);
103         balances[msg.sender]+=msg.value-deduct;
104     }
105 }