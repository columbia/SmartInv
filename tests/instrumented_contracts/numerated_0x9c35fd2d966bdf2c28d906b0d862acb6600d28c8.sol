1 pragma solidity ^0.4.19;
2 
3 contract Storage{
4     address public founder;
5     bool public changeable;
6     mapping( address => bool) public adminStatus;
7     mapping( address => uint256) public slot;
8     
9     event Update(address whichAdmin, address whichUser, uint256 data);
10     event Set(address whichAdmin, address whichUser, uint256 data);
11     event Admin(address addr, bool yesno);
12 
13     modifier onlyFounder() {
14         require(msg.sender==founder);
15         _;
16     }
17     
18     modifier onlyAdmin() {
19         assert (adminStatus[msg.sender]==true);
20         _;
21     }
22     
23     function Storage() public {
24         founder=msg.sender;
25         adminStatus[founder]=true;
26         changeable=true;
27     }
28     
29     function update(address userAddress,uint256 data) public onlyAdmin(){
30         assert(changeable==true);
31         assert(slot[userAddress]+data>slot[userAddress]);
32         slot[userAddress]+=data;
33         Update(msg.sender,userAddress,data);
34     }
35     
36     function set(address userAddress, uint256 data) public onlyAdmin() {
37         require(changeable==true || msg.sender==founder);
38         slot[userAddress]=data;
39         Set(msg.sender,userAddress,data);
40     }
41     
42     function admin(address addr) public onlyFounder(){
43         adminStatus[addr] = !adminStatus[addr];
44         Admin(addr, adminStatus[addr]);
45     }
46     
47     function halt() public onlyFounder(){
48         changeable=!changeable;
49     }
50     
51     function() public{
52         revert();
53     }
54     
55 }
56 
57 
58 
59 pragma solidity ^0.4.19;
60 
61 contract Payee{
62     
63     uint256 public price;
64     address public storageAddress;
65     address public founder;
66     bool public changeable;
67     mapping( address => bool) public adminStatus;
68 
69     
70     
71     Storage s;
72     event Buy(address addr, uint256 count);
73     event SetPrice(address addr, uint256 price);
74     event Admin(address addr, bool yesno);
75 
76     
77     modifier onlyAdmin() {
78         assert (adminStatus[msg.sender]==true);
79         _;
80     }
81     
82     modifier onlyFounder() {
83         require(msg.sender==founder);
84         _;
85     }
86     
87     function admin(address addr) public onlyFounder(){
88         adminStatus[addr] = !adminStatus[addr];
89         Admin(addr, adminStatus[addr]);
90     }
91     
92     function Payee(address addr) public {
93         founder=msg.sender;
94         price=3000000000000000; //default price will be 0.003 ether($2);
95         adminStatus[founder]=true;
96         storageAddress=addr;
97         s=Storage(storageAddress);
98         changeable=true;
99         
100     }
101     
102     function setPrice(uint256 _price) public onlyAdmin(){
103         price=_price;
104         SetPrice(msg.sender, price);
105     }
106     
107     function setStorageAddress(address _addr) public onlyAdmin(){
108         storageAddress=_addr;
109         s=Storage(storageAddress);
110 
111     }
112     
113     function halt() public onlyFounder(){
114         changeable=!changeable;
115     }
116     
117     function pay(address _addr, uint256 count) public payable {
118         assert(changeable==true);
119         assert(msg.value >= price*count);
120         if(!founder.call.value(price*count)() || !msg.sender.call.value(msg.value-price*count)()){
121             revert();
122         }
123         s.update(_addr,count);
124         Buy(msg.sender,count);
125     }
126     
127     function () public payable {
128         pay(msg.sender,1);
129     }
130 }