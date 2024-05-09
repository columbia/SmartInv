1 pragma solidity ^0.4.10;
2 
3 contract EtherGame 
4 {
5     address Owner;
6     uint public RegCost;
7     uint public FirstLevelCost;
8     uint public SecondLevelCost;
9     uint public ParentFee;
10     
11     struct user
12     {
13         address parent;
14         uint8 level;
15     }
16     
17     address[] ListOfUsers;
18     mapping(address=>user) public Users;
19     
20     event newuser(address User, address Parent);
21     event levelup(address User, uint Level);
22     
23     modifier OnlyOwner() 
24     {
25         if(msg.sender == Owner) 
26         _;
27     }
28     
29     function EtherGame()
30     {
31         Owner = msg.sender;
32         RegCost = 0 ether;
33         FirstLevelCost = 0 ether;
34         SecondLevelCost = 0 ether;
35         ParentFee = 250;
36         Users[address(this)].parent = address(this);
37         Users[address(this)].level = 200;
38         ListOfUsers.push(address(this));
39     }
40 
41     function() payable {}
42     
43     function NewUser() payable
44     {
45         if(msg.value < RegCost || Users[msg.sender].parent != 0) 
46             throw;
47         Users[msg.sender].parent = address(this);
48         ListOfUsers.push(msg.sender);
49         newuser(msg.sender, address(this));
50     }
51     
52     function NewUser(address addr) payable
53     {
54         if(msg.value < RegCost || Users[msg.sender].parent != 0 || Users[addr].parent == 0)
55             throw;
56         if(addr != address(this))
57             addr.transfer(RegCost);
58         Users[msg.sender].parent = addr;
59         ListOfUsers.push(msg.sender);
60         newuser(msg.sender, addr);
61     }
62     
63     function BuyLevel() payable
64     {
65         uint Price;
66         if(Users[msg.sender].level == 0)
67             Price = FirstLevelCost;
68         else
69             Price = uint(8)**Users[msg.sender].level*SecondLevelCost/uint(5)**Users[msg.sender].level*2;
70         if(msg.value < Price || Users[msg.sender].parent == 0)
71             throw;
72         address ToTransfer = Users[msg.sender].parent;
73         uint Level = Users[msg.sender].level + 1;
74         while(Users[ToTransfer].level < Level)
75             ToTransfer = Users[ToTransfer].parent;
76         if(ToTransfer != address(this))
77         {
78             ToTransfer.transfer(Price/1000*(1000-ParentFee));
79             ToTransfer = Users[ToTransfer].parent;
80             if(ToTransfer != address(this) && ParentFee != 0)
81                 ToTransfer.transfer(Price/1000*ParentFee);
82         }
83         Users[msg.sender].level++;
84         levelup(msg.sender, Level);
85     }
86     
87     function TakeMoney() OnlyOwner
88     {
89         Owner.transfer(this.balance);
90     }
91     
92     function ChangeOwner(address NewOwner) OnlyOwner
93     {
94         Owner = NewOwner;
95     }
96     
97     function ChangeRules(uint NewRegCost, uint NewFirsLevelCost, uint NewSecondLevelCost, uint NewParentFee) OnlyOwner
98     {
99         ParentFee = NewParentFee;
100         FirstLevelCost = NewFirsLevelCost;
101         SecondLevelCost = NewSecondLevelCost;
102         RegCost = NewRegCost;
103     }
104     
105     function Kill() OnlyOwner
106     {
107         selfdestruct(Owner);
108     }
109 
110     function UsersNumber() constant returns(uint)
111     {
112         return ListOfUsers.length;
113     }
114     
115     function UsersList() constant returns(address[])
116     {
117         return ListOfUsers;
118     }
119 
120     function MaxChildLevel(address addr) constant returns(uint)
121     {
122         uint MaxLevel = 0;
123         uint Level;
124         address child;
125         for(uint i=0;i<ListOfUsers.length;i++)
126         {
127             child = ListOfUsers[i];
128             Level = Users[child].level;
129             while(child != address(this) && Users[child].parent != addr)
130                 child = Users[child].parent;
131             if(child != address(this) && Level > MaxLevel)
132                 MaxLevel = Level;
133         }
134         return MaxLevel;
135     }
136     
137 }