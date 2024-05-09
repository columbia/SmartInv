1 pragma solidity ^0.4.19;
2 
3 //contract by Adam Skrodzki
4 //
5 contract BankAccount {
6     Bank parent;
7     function() payable public{
8         address mainAdr = parent.GetMainAddress();
9 
10         mainAdr.transfer(msg.value);
11     }
12 
13     function BankAccount (address _bankAddress) public {
14         parent = Bank(_bankAddress);
15     }
16     
17     function transferTokens(address _tokenAdr) public {
18         address mainAdr = parent.GetMainAddress();
19         Token t = Token(_tokenAdr);
20         t.transfer(mainAdr,t.balanceOf(this));
21     }
22 }
23 
24 contract Token {
25     function balanceOf(address a) constant returns(uint256);
26     function transfer(address to,uint256 value);
27 }
28 
29 contract Bank {
30 
31     address private _mainAddress;
32     address public owner ;
33     address private operator ;
34     BankAccount[] private availableAddresses;
35     Token[] private tokens;
36     mapping(uint256 => address) private assignments ;
37 
38     uint256 public firstFreeAddressIndex = 0;
39 
40 
41     function ChangeMainAccount(address mainAddress) public{
42         if(msg.sender==owner){
43             _mainAddress = mainAddress;
44         }
45     }
46     
47     function ChangeOperatorAccount(address addr) public{
48         if(msg.sender==owner){
49             operator = addr;
50         }
51     }
52     
53     function GetNextWithFunds(uint256 startAcc,uint256 startTok) constant returns(uint256,uint256,bool){
54             uint256 i = startAcc;
55             uint256 j = startTok;
56             if(j==0) j=1;
57             uint256 counter =0;
58             for(i;i<availableAddresses.length && counter<100;i++){
59                 for(j;j<tokens.length && counter<100;j++){
60                     counter++;
61                     if(tokens[j].balanceOf(availableAddresses[i])>0){
62                         return (i,j,true);
63                     }
64                 }
65                 j=1;
66             }
67             if(i==availableAddresses.length){
68                 return(0,0,false);
69             }
70             else{
71                 return(i,j,false);
72             }
73     }
74     function TransferFunds(uint256 addrIdx,uint256 tokIdx) public{
75         if(msg.sender==owner || msg.sender==operator){
76             availableAddresses[addrIdx].transferTokens.gas(250000)(tokens[tokIdx]);
77         }
78         else{
79           revert();   
80         
81         }
82     }
83     function GetMainAddress() public constant returns (address){
84         return(_mainAddress);
85     }
86     function ChangeOwner(address newOwner) public{
87         if(msg.sender==owner){
88             owner = newOwner;
89         }
90         else{
91           revert();   
92         
93         }
94     }
95     function AddToken(address _adr)public {
96         if(msg.sender==owner || msg.sender==operator){
97             tokens.push(Token(_adr));
98         }
99         else{
100           revert();   
101         
102         }
103     }
104     function Bank(address mainAddress) public{
105         tokens.push(Token(0));
106         owner = msg.sender;
107         _mainAddress = mainAddress;
108     }
109     function CreateNewAccount() public{
110         var a = new BankAccount(this);
111         availableAddresses.push(a);
112     }
113     function GetAvailableAddressesCount() private constant returns(uint256){
114         return availableAddresses.length-firstFreeAddressIndex;
115     }
116 
117     function AssignAddress(uint256 holderId) public{
118         if(msg.sender==owner || msg.sender==operator){
119             if(assignments[holderId]!=0){ // nie można stworzyć 2 adresów dla jednego klienta
120     
121             }
122             else{
123                 if(GetAvailableAddressesCount()==0){
124                         CreateNewAccount();
125                 }
126                 assignments[holderId] = availableAddresses[firstFreeAddressIndex];
127                 firstFreeAddressIndex = firstFreeAddressIndex+1;
128             }
129         }
130         else{
131           revert();   
132         
133         }
134 
135     }
136 
137     function GetAssignedAddress(uint256 holderId) public constant returns(address){
138          return assignments[holderId];
139     }
140 
141 
142 }