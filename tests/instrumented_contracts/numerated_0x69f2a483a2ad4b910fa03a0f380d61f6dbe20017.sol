1 // Coinia Vy (c) 2016 Solarius Solutions (contact at solarius.fi), under GPLv2
2 
3 /// @title Coinia Vy - Virtual limited partnership (designed for Finnish legal environment)
4 /// @author Solarius Solutions / Ville Sundell, code (and only code) released under GPLv2, you can find the code at 0x69f2a483a2ad4b910fa03a0f380d61f6dbe20017 using Etherscan
5 
6 pragma solidity ^0.4.4; //This was originally written for 0.3.6 series, but in the last minute got updated to 0.4.2, and later 0.4.4
7 
8 contract CoiniaVy {
9     struct Shareholder {
10         string name; // Legal name of partner
11         string id; // Legal identification of the partner (birthday, registration number, business ID, etc.)
12         uint shares; //Amount of shares, 0 being not a member/ex-member
13         bool limited; // This is legal: If this is "true", the partner is limited, if false, the partner is general
14     }
15     
16     string public standard = 'Token 0.1';
17     address[] public projectManagers; //This is address to a contract managing projects and voting, will be commited later
18     address[] public treasuryManagers; //This is address to a contract managing the money, will be commited later
19     uint public totalSupply = 10000; // Total amount of shares
20     string public home = "PL 18, 30101 Forssa, FINLAND";
21     string public industry = "64190 Muu pankkitoiminta / Financial service nec";
22     mapping (address => Shareholder) public shareholders;
23     
24     //These "tokenizes" the contract:
25     string public name = "Coinia Vy";
26     string public symbol = "CIA";
27     uint8 public decimals = 0;
28     
29     //The events:
30     event Transfer (address indexed from, address indexed to, uint shares);
31     event ChangedName (address indexed who, string to);
32     event ChangedId (address indexed who, string to);
33     event Resigned (address indexed who);
34     event SetLimited (address indexed who, bool limited);
35     event SetIndustry (string indexed newIndustry);
36     event SetHome (string indexed newHome);
37     event SetName (string indexed newName);
38     event AddedManager (address indexed manager);
39     
40     /// @dev This modifier is used with all of the functions requiring authorisation. Previously used msg.value check is not needed anymore.
41     modifier ifAuthorised {
42         if (shareholders[msg.sender].shares == 0)
43             throw;
44 
45         _;
46     }
47     
48     /// @dev This modifier is used to check if the user is a general partner
49     modifier ifGeneralPartner {
50         if (shareholders[msg.sender].limited == true)
51             throw;
52 
53         _;
54     }
55     
56     /// @dev This is the constructor, this is quick and dirty because of Ethereum's current DDoS difficulties deploying stuff is hard atm. So that's why hardcoding everything, so this contract could be deployed using whatever tool (not all support arguments)
57     function CoiniaVy () {
58         shareholders[this] = Shareholder (name, "2755797-6", 0, false);
59         shareholders[msg.sender] = Shareholder ("Coinia OÜ", "14111022", totalSupply, false);
60     }
61     
62     /// @dev Here we "tokenize" our contract, so wallets can use this as a token.
63     /// @param target Address whose balance we want to query.
64     function balanceOf(address target) constant returns(uint256 balance) {
65         return shareholders[target].shares;
66     }
67     
68     /// @notice This transfers `amount` shares to `target.address()`. This is irreversible, are  you OK with this?
69     /// @dev This transfers shares from the current shareholder to a future shareholder, and will create one if it does not exists. This 
70     /// @param target Address of the account which will receive the shares.
71     /// @param amount Amount of shares, 0 being none, and 1 being one share, and so on.
72     function transfer (address target, uint256 amount) ifAuthorised {
73         if (amount == 0 || shareholders[msg.sender].shares < amount)
74             throw;
75         
76         shareholders[msg.sender].shares -= amount;
77         if (shareholders[target].shares > 0) {
78             shareholders[target].shares += amount;
79         } else {
80             shareholders[target].shares = amount;
81             shareholders[target].limited = true;
82         }
83         
84         Transfer (msg.sender, target, amount);
85     }
86     
87     /// @dev This function is used to change user's own name. Ethereum is anonymous by design, but there might be legal reasons for a user to do this.
88     /// @param newName User's new name.
89     function changeName (string newName) ifAuthorised {
90         shareholders[msg.sender].name = newName;
91         
92         ChangedName (msg.sender, newName);
93     }
94     
95     /// @dev This function is used to change user's own ID (Business ID, birthday, etc.) Ethereum is anonymous by design, but there might be legal reasons for a user to do this.
96     /// @param newId User's name ID, might be something like a business ID, birthday, or some other identification string.
97     function changeId (string newId) ifAuthorised {
98         shareholders[msg.sender].id = newId;
99         
100         ChangedId (msg.sender, newId);
101     }
102     
103     /// @notice WARNING! This will remove you'r existance from the company, this is irreversible and instant. This will not terminate the company. Are you really really sure?
104     /// @dev This is required by Finnish law, a person must be able to resign from a company. This will not terminate the company.
105     function resign () {
106         if (bytes(shareholders[msg.sender].name).length == 0 || shareholders[msg.sender].shares > 0)
107             throw;
108             
109         shareholders[msg.sender].name = "Resigned member";
110         shareholders[msg.sender].id = "Resigned member";
111         
112         Resigned (msg.sender);
113     }
114     
115     /// @notice This sets member's liability status, either to limited liability, or unlimited liability. Beware, that this has legal implications, and decission must be done with other general partners.
116     /// @dev This is another function added for legal reason, using this, you can define is a member limited partner, or a general partner.
117     /// @param target The user we want to define.
118     /// @param isLimited Will the target be a limited partner.
119     function setLimited (address target, bool isLimited) ifAuthorised ifGeneralPartner {
120         shareholders[target].limited = isLimited;
121         
122         SetLimited (target, isLimited);
123     }
124     
125     /// @dev This sets the industry of the company. This might have legal implications.
126     /// @param newIndustry New industry, where there company is going to operate.
127     function setIndustry (string newIndustry) ifAuthorised ifGeneralPartner {
128         industry = newIndustry;
129         
130         SetIndustry (newIndustry);
131     }
132     
133     /// @dev This sets the legal "home" of the company, most probably has legal implications, for example where possible court sessions are held.
134     /// @param newHome New home of the company.
135     function setHome (string newHome) ifAuthorised ifGeneralPartner {
136         home = newHome;
137         
138         SetHome (newHome);
139     }
140     
141     /// @dev This sets the legal name of the company, most probably has legal implications.
142     /// @param newName New name of the company.
143     function setName (string newName) ifAuthorised ifGeneralPartner {
144         shareholders[this].name = newName;
145         name = newName;
146         
147         SetName (newName);
148     }
149     
150     /// @dev This function adds a new treasuryManager to the end of the list
151     /// @param newManager Address of the new treasury manager
152     function addTreasuryManager (address newManager) ifAuthorised ifGeneralPartner {
153         treasuryManagers.push (newManager);
154         
155         AddedManager (newManager);
156     }
157     
158     /// @dev This function adds a new projectManager to the end of the list
159     /// @param newManager Address of the new project manager
160     function addProjectManager (address newManager) ifAuthorised ifGeneralPartner {
161         projectManagers.push (newManager);
162         
163         AddedManager (newManager);
164     }
165     
166     /// @dev This default fallback function is here just for clarification
167     function () {
168         throw;
169     }
170 }