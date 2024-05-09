1 // Lottery Source code
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /// @title A base contract to control ownership
7 /// @author cuilichen
8 contract OwnerBase {
9 
10     // The addresses of the accounts that can execute actions within each roles.
11     address public ceoAddress;
12     address public cfoAddress;
13     address public cooAddress;
14 
15     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
16     bool public paused = false;
17     
18     /// constructor
19     function OwnerBase() public {
20        ceoAddress = msg.sender;
21        cfoAddress = msg.sender;
22        cooAddress = msg.sender;
23     }
24 
25     /// @dev Access modifier for CEO-only functionality
26     modifier onlyCEO() {
27         require(msg.sender == ceoAddress);
28         _;
29     }
30 
31     /// @dev Access modifier for CFO-only functionality
32     modifier onlyCFO() {
33         require(msg.sender == cfoAddress);
34         _;
35     }
36     
37     /// @dev Access modifier for COO-only functionality
38     modifier onlyCOO() {
39         require(msg.sender == cooAddress);
40         _;
41     }
42 
43     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
44     /// @param _newCEO The address of the new CEO
45     function setCEO(address _newCEO) external onlyCEO {
46         require(_newCEO != address(0));
47 
48         ceoAddress = _newCEO;
49     }
50 
51 
52     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
53     /// @param _newCFO The address of the new COO
54     function setCFO(address _newCFO) external onlyCEO {
55         require(_newCFO != address(0));
56 
57         cfoAddress = _newCFO;
58     }
59     
60     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
61     /// @param _newCOO The address of the new COO
62     function setCOO(address _newCOO) external onlyCEO {
63         require(_newCOO != address(0));
64 
65         cooAddress = _newCOO;
66     }
67 
68     /// @dev Modifier to allow actions only when the contract IS NOT paused
69     modifier whenNotPaused() {
70         require(!paused);
71         _;
72     }
73 
74     /// @dev Modifier to allow actions only when the contract IS paused
75     modifier whenPaused {
76         require(paused);
77         _;
78     }
79 
80     /// @dev Called by any "C-level" role to pause the contract. Used only when
81     ///  a bug or exploit is detected and we need to limit damage.
82     function pause() external onlyCOO whenNotPaused {
83         paused = true;
84     }
85 
86     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
87     ///  one reason we may pause the contract is when CFO or COO accounts are
88     ///  compromised.
89     /// @notice This is public rather than external so it can be called by
90     ///  derived contracts.
91     function unpause() public onlyCOO whenPaused {
92         // can't unpause if contract was upgraded
93         paused = false;
94     }
95     
96     
97     /// @dev check wether target address is a contract or not
98     function isNormalUser(address addr) internal view returns (bool) {
99         if (addr == address(0)) {
100             return false;
101         }
102         uint size = 0;
103         assembly { 
104             size := extcodesize(addr) 
105         } 
106         return size == 0;
107     }
108 }
109 
110 
111 contract Lottery is OwnerBase {
112 
113     event Winner( address indexed account,uint indexed id, uint indexed sn );
114     
115     uint public price = 1 finney;
116     
117     uint public reward = 10 finney;
118     
119     uint public sn = 1;
120     
121     uint private seed = 0;
122     
123     
124     /// @dev constructor of contract, create a seed
125     function Lottery() public {
126         ceoAddress = msg.sender;
127         cooAddress = msg.sender;
128         cfoAddress = msg.sender;
129         seed = now;
130     }
131     
132     /// @dev set seed by coo
133     function setSeed( uint val) public onlyCOO {
134         seed = val;
135     }
136     
137     
138     function() public payable {
139         // get ether, maybe from coo.
140     }
141         
142     
143     
144     /// @dev buy lottery
145     function buy(uint id) payable public {
146         require(isNormalUser(msg.sender));
147         require(msg.value >= price);
148         uint back = msg.value - price;  
149         
150         sn++;
151         uint sum = seed + sn + now + uint(msg.sender);
152         uint ran = uint16(keccak256(sum));
153         if (ran * 10000 < 880 * 0xffff) { // win the reward 
154             back = reward + back;
155             emit Winner(msg.sender, id, sn);
156         }else{
157             emit Winner(msg.sender, id, 0);
158         }
159         
160         if (back > 1 finney) {
161             msg.sender.transfer(back);
162         }
163     }
164     
165     
166 
167     // @dev Allows the cfo to capture the balance.
168     function cfoWithdraw( uint remain) external onlyCFO {
169         address myself = address(this);
170         require(myself.balance > remain);
171         cfoAddress.transfer(myself.balance - remain);
172     }
173     
174     
175     
176     
177 }