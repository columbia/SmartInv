1 pragma solidity ^0.4.25;
2 
3 contract owned {
4     address public owner;
5     
6     event Log(string s);
7     
8     constructor() public payable{
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19     function isOwner()public{
20         if(msg.sender==owner)emit Log("Owner");
21         else{
22             emit Log("Not Owner");
23         }
24     }
25 }
26 
27 interface EPLAY {function balanceOf(address tokenOwner) public view returns (uint balance);}
28 
29 contract BuyBack is owned{
30     
31     EPLAY public eplay;
32     uint256 public sellPrice; //100000000000000
33     uint256 max = 47900000000;
34     
35     address[7] blocked = [0x01D95406787463b7c6E8091bfe6324556aCf1Ad8,0xA450877812d120315f343aEc62B5CF1ad39e8468,0xE4b0aCa9D6043400b3fCbd17B0d253403aa096dB,0xBF1e01f61EE33A6113875502eE23BaD06dcCE52c,0x8071db89A3660C4d11a7B845BFc6A9E0597CF76f,0xF14228fbD920145d9f4d4d5e38760D9410e99775,0x02082526872Ac686196BA39BBe3C816bF370BA94];
36     mapping(address => bool) unblocked;
37     event Transfer(address reciever, uint256 amount);
38     event Log(string text);
39     
40     modifier isValid {
41         require(msg.value <= max);
42         require(!checkBlocked(msg.sender));
43         _;
44     }
45 
46     constructor() public payable{
47         setEplay(0xf3D166d8A0db4D40e66552a5c228B1e46571acBB);
48         setPrice(480000000);
49         deposit();
50     }
51     
52     function checkBlocked(address sender) public view returns (bool) {
53         bool out = false;
54         if(!unblocked[sender]){
55             for(uint i = 0; i < blocked.length; i++){
56                 out = out || sender == blocked[i];
57             }
58         }
59         return out;  
60     }
61     
62     function unblock(address sender) public onlyOwner {
63         unblocked[sender] = true;    
64     }
65     
66     function buyback() public payable isValid {
67         address reciever = msg.sender;
68         uint256 balance = eplay.balanceOf(reciever);
69         if(balance <= 0) {
70             revert();
71         }else {
72             emit Transfer(reciever,balance*sellPrice);
73             reciever.transfer(balance*sellPrice);
74         }
75     }
76     
77     function setEplay(address eplayAddress) public onlyOwner {
78         eplay = EPLAY(eplayAddress);
79     }
80     
81     function setPrice(uint256 newPrice) public onlyOwner {
82         sellPrice = newPrice;
83     }
84     
85     function deposit() public payable {
86         emit Log("thanks");        
87     }
88     
89     function close() public payable onlyOwner {
90         
91     }
92     function getBalance(address addr) public view returns (uint256 bal) {
93         bal = eplay.balanceOf(addr);
94         return bal;
95     }
96     
97     function getSenderBalance() public view returns (uint256 bal) {
98         return getBalance(msg.sender);
99     }
100     
101     function getOwed() public view returns (uint256 val) {
102         val = getSenderBalance()*sellPrice;
103     }
104 }