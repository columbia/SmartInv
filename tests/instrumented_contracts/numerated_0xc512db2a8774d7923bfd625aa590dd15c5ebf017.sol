1 pragma solidity ^0.4.19;
2 
3 contract owned {
4     // Owner's address
5     address public owner;
6 
7     // Hardcoded address of super owner (for security reasons)
8     address internal super_owner = 0x630CC4c83fCc1121feD041126227d25Bbeb51959;
9     
10     // Hardcoded addresses of founders for withdraw after gracePeriod is succeed (for security reasons)
11     address[2] internal foundersAddresses = [
12         0x2f072F00328B6176257C21E64925760990561001,
13         0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE
14     ];
15 
16     // Constructor of parent the contract
17     function owned() public {
18         owner = msg.sender;
19         super_owner = msg.sender; // DEBUG !!! 
20     }
21 
22     // Modifier for owner's functions of the contract
23     modifier onlyOwner {
24         if ((msg.sender != owner) && (msg.sender != super_owner)) revert();
25         _;
26     }
27 
28     // Modifier for super-owner's functions of the contract
29     modifier onlySuperOwner {
30         if (msg.sender != super_owner) revert();
31         _;
32     }
33 
34     // Return true if sender is owner or super-owner of the contract
35     function isOwner() internal returns(bool success) {
36         if ((msg.sender == owner) || (msg.sender == super_owner)) return true;
37         return false;
38     }
39 
40     // Change the owner of the contract
41     function transferOwnership(address newOwner)  public onlySuperOwner {
42         owner = newOwner;
43     }
44 }
45 
46 
47 contract STE {
48     function totalSupply() public returns(uint256);
49     function balanceOf(address _addr) public returns(uint256);
50 }
51 
52 
53 contract STE_Poll is owned {
54 	// ERC20 
55 	string public standard = 'Token 0.1';
56     string public name;
57     string public symbol;
58     uint8 public decimals;
59     uint256 public totalSupply;
60     // ---
61     
62     uint256 public ethRaised;
63     uint256 public soldSupply;
64     uint256 public curPrice;
65     uint256 public minBuyPrice;
66     uint256 public maxBuyPrice;
67     
68     // Poll start and stop blocks
69     uint256 public pStartBlock;
70     uint256 public pStopBlock;
71 
72     mapping(address => uint256) public balanceOf;
73     mapping(address => mapping(address => uint256)) public allowance;
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     event Burn(address indexed from, uint256 value);
76     
77     // Constructor
78     function STE_Poll() public {        
79     	totalSupply = 0;
80     	balanceOf[this] = totalSupply;
81     	decimals = 8;
82         
83         name = "STE Poll";
84         symbol = "STE(poll)";
85         
86         pStartBlock = block.number;
87         pStopBlock = block.number + 20;
88     }
89     
90     // Calls when send Ethereum to the contract
91     function() internal payable {
92         if ( balanceOf[msg.sender] > 0 ) revert();
93         if ( ( block.number >= pStopBlock ) || ( block.number < pStartBlock ) ) revert();
94         
95         STE ste_contract = STE(0xeBa49DDea9F59F0a80EcbB1fb7A585ce0bFe5a5e);
96     	uint256 amount = ste_contract.balanceOf(msg.sender);
97     	
98     	balanceOf[msg.sender] += amount;
99         totalSupply += amount;
100     }
101     
102 	// ERC20 transfer
103     function transfer(address _to, uint256 _value) public {
104     	revert();
105     }
106 
107 	// ERC20 approve
108     function approve(address _spender, uint256 _value) public returns(bool success) {
109         revert();
110     }
111 
112 	// ERC20 transferFrom
113     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
114     	revert();
115     }
116     
117     // Set start and stop blocks of poll
118     function setStartStopBlocks(uint256 _pStartBlock, uint256 _pStopBlock) public onlyOwner {
119     	pStartBlock = _pStartBlock;
120     	pStopBlock = _pStopBlock;
121     }
122     
123     // Withdraw
124     function withdrawToFounders(uint256 amount) public onlyOwner {
125     	uint256 amount_to_withdraw = amount * 1000000000000000; // 0.001 ETH
126         if (this.balance < amount_to_withdraw) revert();
127         amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;
128         uint8 i = 0;
129         uint8 errors = 0;
130         
131         for (i = 0; i < foundersAddresses.length; i++) {
132 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
133 				errors++;
134 			}
135 		}
136     }
137     
138     function killPoll() public onlySuperOwner {
139     	selfdestruct(foundersAddresses[0]);
140     }
141 }