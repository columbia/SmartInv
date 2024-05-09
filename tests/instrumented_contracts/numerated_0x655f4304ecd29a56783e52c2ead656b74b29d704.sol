1 pragma solidity^0.4.18;
2 
3 contract Owned {
4     address owner;
5     
6     modifier onlyowner(){
7         if (msg.sender == owner) {
8             _;
9         }
10     }
11 
12     function Owned() internal {
13         owner = msg.sender;
14     }
15 }
16 
17 
18 
19 contract ethKeepHand is Owned{
20 
21     struct DepositItem{
22         
23         uint depositDate;     //Date of deposit
24         uint256 depositValue; //The amount of deposit
25         uint depositTime;     //The terms of deposit
26         uint  valid;          //The address is in the state of deposit:
27                               //1 indicates that there is a deposit in the corresponding address, and 0 indicates no.
28     }
29 
30      mapping(address => DepositItem)  DepositItems;
31 
32      event DepositTime(uint time);
33      
34      //Judge whether you can withdraw money
35      modifier withdrawable(address adr){
36 
37          require(this.balance >= DepositItems[adr].depositValue);
38          _;
39      }
40     
41     //Determine whether you can deposit money
42     modifier isright()
43     {
44         require(DepositItems[msg.sender].valid !=1);
45         _;
46     }
47 
48 
49 
50     //deposit
51     function addDeposit(uint _time) external payable isright{
52          
53          DepositTime(_time);
54          DepositItems[msg.sender].depositDate = now;
55          DepositItems[msg.sender].depositValue = msg.value;
56          DepositItems[msg.sender].depositTime = _time;
57          DepositItems[msg.sender].valid =1;
58 
59      }
60 
61      //Note how many days are left until the date of withdrawal.
62      function withdrawtime() external view returns(uint){
63        
64        if(DepositItems[msg.sender].depositDate + DepositItems[msg.sender].depositTime > now){
65          return DepositItems[msg.sender].depositDate + DepositItems[msg.sender].depositTime - now;
66        }
67        
68         return 0;
69      }
70 
71      //withdrawals
72      function withdrawals() withdrawable(msg.sender) external{
73 
74         DepositItems[msg.sender].valid = 0;
75         uint256 backvalue = DepositItems[msg.sender].depositValue;
76         DepositItems[msg.sender].depositValue = 0;
77         msg.sender.transfer(backvalue);
78 
79 
80      }
81     
82      //Amount of deposit
83     function getdepositValue()  external view returns(uint)
84      {
85         
86         return DepositItems[msg.sender].depositValue;
87      }
88      //Contract balance
89      function getvalue() public view returns(uint)
90      {
91          
92          return this.balance;
93      }
94       //Decide whether to deposit money
95      function  isdeposit() external view returns(uint){
96 
97          return DepositItems[msg.sender].valid;
98        }
99 
100 
101       function() public payable{
102           
103           revert();
104       }
105 }