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
34         
35     constructor() public{
36         add = 5000000000000000;
37         fee = 2;
38         bonus = 10;
39         token = 0xCD8aAC9972dc4Ddc48d700bc0710C0f5223fBCfa;
40         owner = msg.sender;
41     }
42     
43     function addVideo(bytes32 _id) public returns (bool success){
44         require (videos[_id]==address(0x0) && balances[msg.sender]>=add);
45         videos[_id] = msg.sender;
46         balances[msg.sender] -= add;
47         if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
48         owner.transfer(add);
49         return true;
50     }
51     
52     function changeDonate(uint256 _donate) public returns (bool success){
53         require(_donate>0);
54         donates[msg.sender] = _donate;
55         return true;
56     }
57     
58     function donateVideo(bytes32 _id) public returns (bool success){
59         require(videos[_id]!=address(0x0) && balances[msg.sender]>=donates[videos[_id]]);
60         balances[videos[_id]] += donates[videos[_id]];
61         balances[msg.sender] -= donates[videos[_id]];
62         if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
63         emit Donate(msg.sender, donates[videos[_id]]);
64         return true;
65     }
66     
67     function changeAdd (uint256 _add) onlyOwner public returns (bool success){
68         require (_add>0);
69         add=_add;
70         return true;
71     }
72     
73     function changeFee (uint8 _fee) onlyOwner public returns (bool success){
74         require (_fee>0);
75         fee=_fee;
76         return true;
77     }
78     
79     function changeBonus (uint8 _bonus) onlyOwner public returns (bool success){
80         require (_bonus>0);
81         bonus=_bonus;
82         return true;
83     }
84     
85     function getBalance(address _owner) view public returns (uint256 balance){
86         return balances[_owner];
87     }
88     
89     function withdrawEth(uint256 _amount) public returns (bool success){
90         require(_amount>0 && balances[msg.sender]>=_amount);
91         uint256 deduct = _amount*fee/100;
92         owner.transfer(deduct);
93         msg.sender.transfer(_amount-deduct);
94         return true;
95     }
96     
97     function () payable external {
98         require(msg.value>0);
99         uint256 deduct = msg.value*fee/100;
100         owner.transfer(deduct);
101         balances[msg.sender]+=msg.value-deduct;
102     }
103 }