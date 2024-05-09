1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) revert();
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract Registration { 
22      mapping (address => bool) public isRegistered;  
23 }
24 
25 contract LibrariumSubmission is owned { 
26     struct Title { 
27       
28         address owner; 
29         uint256 price; 
30     }
31     
32     Registration registryInterface;
33     event CategoryAdded(uint256 id, string name); 
34     event CategoryDeleted(uint256 id);
35      
36     event TitleAdded(uint256 id,address owner,uint256 category, string name,string media_hash,string desc,uint256 price );
37     event TitleDelisted(uint256 id);
38     event TitleApproved(uint256 id); 
39     event TitleUpdated(uint256 id,uint256 category, string name, string media_hash, string desc, uint256 price);
40     event TitlePurchased(address buyer, uint256 title);
41     
42     uint256 public categoriesCount; 
43     uint256 public titleCount; 
44     
45     mapping (uint256 => Title) public titles;
46     mapping (address => uint256) public balances; //Ether on account for sellers 
47     mapping (address => uint256) public salesEth; //Total eth earned by seller
48     mapping (address => uint256) public titlesSold; //Total copies of books sold by seller
49     mapping (uint256 => uint256) public copiesSold;  //Copies sold of each title
50     mapping (address => string) public usernames; // Names of buyers and sellers registered 
51     
52     function AddCategory(string categoryName) public onlyOwner { 
53         CategoryAdded(categoriesCount,categoryName);
54         categoriesCount++;
55     }
56     
57     function RemoveCategory(uint256 id) public onlyOwner { 
58         CategoryDeleted(id);
59     }
60     
61     function SetRegistrationContract(address registryAddress) public onlyOwner { 
62         registryInterface = Registration(registryAddress);
63         
64     }
65     
66     function AddTitle(uint256 category,string name,string media_hash,string desc,uint256 price) public { 
67         require(registryInterface.isRegistered(msg.sender) == true); 
68         
69         Title memory t = Title(msg.sender,price); 
70         titles[titleCount] = t; 
71         
72         TitleAdded(titleCount,msg.sender,category,name,media_hash,desc,price);
73         
74         titleCount++;
75     }
76     
77     function RegisterUsername(string name) public {
78         require(registryInterface.isRegistered(msg.sender) == true); 
79         usernames[msg.sender] = name;
80     }
81     
82     function DelistTitle(uint256 titleId) public  { 
83         require (titleId < titleCount); 
84         require (msg.sender == owner || msg.sender == titles[titleId].owner);
85         
86         TitleDelisted(titleId);
87         
88     }
89     
90     function ApproveTitle(uint256 titleId) public onlyOwner { 
91         require (titleId < titleCount); 
92         
93         TitleApproved(titleId);
94     }
95     
96     function EditTile(uint256 id,uint256 category,string name,string media_hash,string desc,uint256 price) public { 
97         require (id < titleCount);
98         require(titles[id].owner == msg.sender);
99         
100         titles[id].price = price;
101         
102         TitleUpdated(id,category, name, media_hash, desc, price);
103 
104     }
105     
106     function VendTitle(uint256 titleId) public payable {
107         require (titleId < titleCount); 
108         Title storage t = titles[titleId]; 
109         require(msg.value == t.price); 
110         
111         uint256 temp = balances[t.owner];
112         balances[t.owner] += msg.value; 
113         require(balances[t.owner] > temp);
114         
115         copiesSold[titleId]++;
116         titlesSold[t.owner]++;
117         salesEth[t.owner] += msg.value;
118         
119         TitlePurchased(msg.sender, titleId);
120     }
121     
122     function WidthdrawEarnings(uint256 amount) public { 
123         require(balances[msg.sender] >= amount); 
124          balances[msg.sender] -= amount; 
125          msg.sender.transfer(amount);
126     }
127     
128     function () public payable {
129         revert();     // Prevents accidental sending of ether
130     }
131     
132 }