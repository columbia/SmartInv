1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4 
5   // public variables
6   address public owner;
7 
8   // internal variables
9 
10   // events
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   // public functions
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   function transferOwnership(address newOwner) public onlyOwner {
24     require(newOwner != address(0));
25     emit OwnershipTransferred(owner, newOwner);
26     owner = newOwner;
27   }
28 
29   // internal functions
30 }
31 
32 contract AccEthRegCenter  is Ownable {
33     
34     struct User {
35         address useraddress;
36         uint useramount;
37         bool lastTransfer;
38     }
39     
40   // events
41     event TransferTo(address indexed to, uint256 value);
42     event TransferToName(address indexed to,string name, uint256 value);
43     mapping(string => User) recievermap ;
44     
45     string[] public recieverList ;
46     
47     function() public payable
48     {
49         
50     }
51     
52     function AddUser(string user,address add,uint amount) onlyOwner public {
53         require(recievermap[user].useraddress == address(0));
54         recieverList.push(user);
55         recievermap[user].useraddress = add;
56         recievermap[user].useramount = amount;
57     }
58     
59     function SetAddress(string user,address add) onlyOwner public {
60         require(recievermap[user].useraddress!= address(0));
61         recievermap[user].useraddress = add;
62     }
63     
64     function SetAmount(string user,uint amount) onlyOwner public {
65         require(recievermap[user].useraddress!= address(0));
66         recievermap[user].useramount = amount;
67         
68     }
69     
70     function GetUser(string key) public constant returns(address add,uint amount,bool lastTransfer)
71     {
72         add = recievermap[key].useraddress;
73         lastTransfer = recievermap[key].lastTransfer;
74         amount = recievermap[key].useramount;
75     }
76     
77     function TransferToAllAccounts() onlyOwner public {
78         for(uint i=0;i<recieverList.length;i++)
79         {
80             recievermap[recieverList[i]].lastTransfer = false;
81             address to = recievermap[recieverList[i]].useraddress;
82             uint256 val = recievermap[recieverList[i]].useramount;
83             require(address(this).balance >= val);
84             if(val>0)
85             {
86                 
87                  to.transfer(val);
88                  emit TransferTo(to, val);
89                  recievermap[recieverList[i]].lastTransfer = true;
90             }
91         }
92     }
93     
94     function ResetAllAmount() onlyOwner public {
95         for(uint i=0;i<recieverList.length;i++)
96         {
97             recievermap[recieverList[i]].useramount = 0;
98         }
99     }
100     
101     function transfer(address to,uint val) onlyOwner public {
102         require(address(this).balance >= val);
103         to.transfer( val);
104         emit TransferTo(to, val);
105         
106     }
107     
108     function transfertoacc(string key,uint val) onlyOwner public {
109         recievermap[key].lastTransfer = false;
110         require(address(this).balance >= val);
111         address to = recievermap[key].useraddress;
112          to.transfer(val);
113         emit TransferToName(to,key, val);
114         recievermap[key].lastTransfer = true;
115     }
116 }