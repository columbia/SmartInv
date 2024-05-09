1 // CryptoRabbit Source code
2 
3 pragma solidity ^0.4.18;
4 
5 
6 
7 
8 
9 /// @title A base contract to control ownership
10 /// @author cuilichen
11 contract OwnerBase {
12 
13     // The addresses of the accounts that can execute actions within each roles.
14     address public ceoAddress;
15     address public cfoAddress;
16     address public cooAddress;
17 
18     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
19     bool public paused = false;
20     
21     /// constructor
22     function OwnerBase() public {
23        ceoAddress = msg.sender;
24        cfoAddress = msg.sender;
25        cooAddress = msg.sender;
26     }
27 
28     /// @dev Access modifier for CEO-only functionality
29     modifier onlyCEO() {
30         require(msg.sender == ceoAddress);
31         _;
32     }
33 
34     /// @dev Access modifier for CFO-only functionality
35     modifier onlyCFO() {
36         require(msg.sender == cfoAddress);
37         _;
38     }
39     
40     /// @dev Access modifier for COO-only functionality
41     modifier onlyCOO() {
42         require(msg.sender == cooAddress);
43         _;
44     }
45 
46     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
47     /// @param _newCEO The address of the new CEO
48     function setCEO(address _newCEO) external onlyCEO {
49         require(_newCEO != address(0));
50 
51         ceoAddress = _newCEO;
52     }
53 
54 
55     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
56     /// @param _newCFO The address of the new COO
57     function setCFO(address _newCFO) external onlyCEO {
58         require(_newCFO != address(0));
59 
60         cfoAddress = _newCFO;
61     }
62     
63     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
64     /// @param _newCOO The address of the new COO
65     function setCOO(address _newCOO) external onlyCEO {
66         require(_newCOO != address(0));
67 
68         cooAddress = _newCOO;
69     }
70 
71     /// @dev Modifier to allow actions only when the contract IS NOT paused
72     modifier whenNotPaused() {
73         require(!paused);
74         _;
75     }
76 
77     /// @dev Modifier to allow actions only when the contract IS paused
78     modifier whenPaused {
79         require(paused);
80         _;
81     }
82 
83     /// @dev Called by any "C-level" role to pause the contract. Used only when
84     ///  a bug or exploit is detected and we need to limit damage.
85     function pause() external onlyCOO whenNotPaused {
86         paused = true;
87     }
88 
89     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
90     ///  one reason we may pause the contract is when CFO or COO accounts are
91     ///  compromised.
92     /// @notice This is public rather than external so it can be called by
93     ///  derived contracts.
94     function unpause() public onlyCOO whenPaused {
95         // can't unpause if contract was upgraded
96         paused = false;
97     }
98 }
99 
100 
101 
102 
103 
104 /// @title all functions related to food
105 contract FoodStore is OwnerBase {
106 	/// event
107 	event Bought(address buyer, uint32 bundles);
108 	
109 	
110     event ContractUpgrade(address newContract);
111 
112 	
113     // Set in case the core contract is broken and an upgrade is required
114     address public newContractAddress;
115     
116     // Price (in wei) for food
117     uint public price = 10 finney;    
118     
119     
120     
121 
122     /// @notice 
123     function FoodStore() public {
124         // the creator of the contract is the initial CEO
125         ceoAddress = msg.sender;
126         cooAddress = msg.sender;
127         cfoAddress = msg.sender;
128     }
129     
130         
131     /// @notice customer buy food
132     /// @param _bundles The num of food
133     function buyFood(uint32 _bundles) external payable whenNotPaused returns (bool) {
134 		require(newContractAddress == address(0));
135 		
136         uint cost = _bundles * price;
137 		require(msg.value >= cost);
138 		
139         // Return the funds. 
140         uint fundsExcess = msg.value - cost;
141         if (fundsExcess > 1 finney) {
142             msg.sender.transfer(fundsExcess);
143         }
144 		emit Bought(msg.sender, _bundles);
145         return true;
146     }
147     
148     
149 
150     /// @dev Used to mark the smart contract as upgraded.
151     /// @param _v2Address new address
152     function upgradeContract(address _v2Address) external onlyCOO whenPaused {
153         newContractAddress = _v2Address;
154         emit ContractUpgrade(_v2Address);
155     }
156 
157     // @dev Allows the CEO to capture the balance available to the contract.
158     function withdrawBalance() external onlyCFO {
159         address tmp = address(this);
160         cfoAddress.transfer(tmp.balance);
161     }
162 }