1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4   // events
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 
7   // public functions
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address addr) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11 }
12 
13 contract Ownable {
14 
15   // public variables
16   address public owner;
17 
18   // internal variables
19 
20   // events
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23   // public functions
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     emit OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39   // internal functions
40 }
41 
42 contract AccRegCenter  is Ownable {
43     
44     
45     struct User {
46         address useraddress;
47         uint useramount;
48         bool lastTransfer;
49     }
50     
51     ERC20Basic public token;
52   // events
53     event TransferTo(address indexed to, uint256 value);
54     event TransferToName(address indexed to,string name, uint256 value);
55     mapping(string => User) recievermap ;
56     
57     string[] public recieverList ;
58     
59     constructor( ERC20Basic _token ) public {
60         require(_token != address(0));
61         token = _token;
62     }
63     
64     function AddUser(string user,address add,uint amount) onlyOwner public {
65         require(recievermap[user].useraddress == address(0));
66         recieverList.push(user);
67         recievermap[user].useraddress = add;
68         recievermap[user].useramount = amount;
69     }
70     
71     function SetAddress(string user,address add) onlyOwner public {
72         require(recievermap[user].useraddress!= address(0));
73         recievermap[user].useraddress = add;
74     }
75     
76     function SetAmount(string user,uint amount) onlyOwner public {
77         require(recievermap[user].useraddress!= address(0));
78         recievermap[user].useramount = amount;
79         
80     }
81     
82     function GetUser(string key) public constant returns(address add,uint amount,bool lastTransfer)
83     {
84         add = recievermap[key].useraddress;
85         lastTransfer = recievermap[key].lastTransfer;
86         amount = recievermap[key].useramount;
87     }
88     
89     function TransferToAllAccounts() onlyOwner public {
90         for(uint i=0;i<recieverList.length;i++)
91         {
92             recievermap[recieverList[i]].lastTransfer = false;
93             address to = recievermap[recieverList[i]].useraddress;
94             uint256 val = recievermap[recieverList[i]].useramount;
95             if(val>0)
96             {
97                  require(ERC20Basic(token).transfer(to, val));
98                  emit TransferTo(to, val);
99                  recievermap[recieverList[i]].lastTransfer = true;
100             }
101         }
102     }
103     
104     function ResetAllAmount() onlyOwner public {
105         for(uint i=0;i<recieverList.length;i++)
106         {
107             recievermap[recieverList[i]].useramount = 0;
108         }
109     }
110     
111     function transfer(address to,uint val) onlyOwner public {
112         require(ERC20Basic(token).transfer(to, val));
113         emit TransferTo(to, val);
114         
115     }
116     
117     function transfertoacc(string key,uint val) onlyOwner public {
118         recievermap[key].lastTransfer = false;
119         address to = recievermap[key].useraddress;
120         require(ERC20Basic(token).transfer(to, val));
121         emit TransferToName(to,key, val);
122         recievermap[key].lastTransfer = true;
123     }
124 }