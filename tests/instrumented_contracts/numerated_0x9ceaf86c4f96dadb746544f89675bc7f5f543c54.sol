1 pragma solidity ^0.5.0;
2 
3 contract owned {
4     address owner;
5 
6     modifier onlyowner() {
7         require(msg.sender == owner);
8         _;
9 
10     }
11 
12      constructor() public {
13         owner = msg.sender;
14     }
15 }
16 
17 library SafeMath {
18   function safeMul(uint a, uint b) internal pure returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function safeSub(uint a, uint b) internal pure returns (uint) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function safeAdd(uint a, uint b) internal pure returns (uint) {
30     uint c = a + b;
31     assert(c>=a && c>=b);
32     return c;
33   }
34 
35 
36 }
37 
38 contract ERC20Interface {
39     // Get the total token supply
40     function totalSupply() view public returns (uint256);
41 
42     // Get the account balance of another account with address _owner
43     function balanceOf(address _owner) view public returns (uint256);
44 
45     // Send _value amount of tokens to address _to
46     function transfer(address _to, uint256 _value) public returns (bool success);
47 
48     // Send _value amount of tokens from address _from to address _to
49     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
50 
51     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
52     // If this function is called again it overwrites the current allowance with _value.
53     // this function is required for some DEX functionality
54     function approve(address _spender, uint256 _value) public returns (bool success);
55 
56     // Returns the amount which _spender is still allowed to withdraw from _owner
57     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
58 
59     // Triggered when tokens are transferred.
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62     // Triggered whenever approve(address _spender, uint256 _value) is called.
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 }
65 
66 contract BitSwap_5 is  owned{
67     ////////////////
68     ///// EVENTS /////
69     //////////////////
70     event DepositForEthReceived(address indexed _from, uint _amount, uint _timestamp);
71     event withdrawalSwappedAsset(address indexed _to, uint indexed _symbolIndex, uint _amount, uint _timestamp);
72     event DepositForTokenReceived(address indexed _from, uint indexed _symbolIndex, uint _amount, uint _timestamp);
73 
74     using SafeMath for uint256;
75     
76       //////////////
77     // BALANCES //
78     //////////////
79     mapping (address => mapping (uint256 => uint)) tokenBalanceForAddress;
80       struct Contracts {
81          address contractAddr;
82     }
83     mapping (uint => Contracts) public ContractAddresses;
84    
85 
86     mapping (address => uint) balanceEthForAddress;
87        function depositEther() public payable {
88         require(balanceEthForAddress[msg.sender] + msg.value >= balanceEthForAddress[msg.sender]);
89         balanceEthForAddress[msg.sender] += msg.value;
90         emit DepositForEthReceived(msg.sender, msg.value, now);
91     }
92     
93     
94      function addTokenContractAddress(string memory _symbol, address _contract) onlyowner() public{
95          
96          uint index = getSymbolContract(_symbol);
97           require(index > 0);
98          ContractAddresses[index] = Contracts(_contract);
99         
100     }
101     
102     
103     
104       function getSymbolContract(string memory _symbol) internal pure returns (uint) {
105           uint index = 0;
106          if(compareStringsbyBytes(_symbol,"BINS") || compareStringsbyBytes(_symbol,"BIB") || compareStringsbyBytes(_symbol,"DAIX")){
107              if(compareStringsbyBytes(_symbol,"BINS")){
108                index = 1;
109              }else if(compareStringsbyBytes(_symbol,"BIB")){
110                 index = 2; 
111              }else if(compareStringsbyBytes(_symbol,"DAIX")){
112                 index = 3; 
113              }
114              return index;
115          }else{
116             revert(); 
117          }
118          
119         return 0;
120     }
121 
122 
123  function compareStringsbyBytes(string memory s1, string memory s2) public pure returns(bool){
124     return keccak256(bytes(s1)) == keccak256(bytes(s2));
125 }
126 
127     
128       function getTokenContractAddress(string memory _a) view public returns(address){
129            uint index = getSymbolContract(_a);
130            require(index > 0);
131           return ContractAddresses[index].contractAddr;
132      }
133      
134         function getTokenSymbolByContractAddress(string memory _a) view public returns(uint256){
135           
136            uint index = getSymbolContract(_a);
137            require(index > 0);
138             ERC20Interface token = ERC20Interface(ContractAddresses[index].contractAddr);
139 
140             return token.totalSupply();
141      }
142      
143     
144       
145       
146       function swapAsset(string memory _symbol) public {
147            if(compareStringsbyBytes(_symbol,"DAIX")) revert(); 
148        uint amountDue = 0;
149        uint swapFromindex = getSymbolContract(_symbol);
150      
151       
152        require(swapFromindex > 0);
153        ERC20Interface swapFrom = ERC20Interface(ContractAddresses[swapFromindex].contractAddr);
154   
155       // require(swapFrom.approve(address(this), swapFrom.balanceOf(msg.sender)) == true);
156         require(ContractAddresses[swapFromindex].contractAddr != address(0));
157         
158 
159         require(tokenBalanceForAddress[msg.sender][swapFromindex] + swapFrom.balanceOf(msg.sender) >= tokenBalanceForAddress[msg.sender][swapFromindex]);
160        if(compareStringsbyBytes(_symbol,"BINS")){
161             amountDue = swapFrom.balanceOf(msg.sender);
162         }else if(compareStringsbyBytes(_symbol,"BIB")){
163              amountDue = swapFrom.balanceOf(msg.sender) / 200 * 3;
164         }
165         require(swapFrom.transferFrom(msg.sender, address(this), swapFrom.balanceOf(msg.sender)) == true);
166        uint total = amountDue * 0.00000001 ether;
167        
168       
169         tokenBalanceForAddress[msg.sender][swapFromindex] += total;
170         emit DepositForTokenReceived(msg.sender, swapFromindex, total, now);
171         
172       }
173       
174     function withdrawSwappedAsset(string memory _symbol) public {
175         string memory toAssetSymbol = "DAIX";
176         uint symbolIndex = getSymbolContract(toAssetSymbol);
177         uint withdrawSymbolIndex = getSymbolContract(_symbol);
178         uint256 amount = tokenBalanceForAddress[msg.sender][withdrawSymbolIndex];
179         require(ContractAddresses[symbolIndex].contractAddr != address(0));
180 
181         ERC20Interface token = ERC20Interface(ContractAddresses[symbolIndex].contractAddr);
182 
183         require(tokenBalanceForAddress[msg.sender][withdrawSymbolIndex] - amount >= 0);
184         require(tokenBalanceForAddress[msg.sender][withdrawSymbolIndex] - amount <= tokenBalanceForAddress[msg.sender][withdrawSymbolIndex]);
185 
186         tokenBalanceForAddress[msg.sender][withdrawSymbolIndex] -= amount;
187         
188         require(token.transfer(msg.sender, amount) == true);
189         emit withdrawalSwappedAsset(msg.sender, withdrawSymbolIndex, amount, now);
190     }
191     
192       function getBalance(string memory symbolName) view public returns (uint) {
193           uint withdrawSymbolIndex = getSymbolContract(symbolName);
194         return tokenBalanceForAddress[msg.sender][withdrawSymbolIndex];
195     }
196     
197     //   function calculate(uint symbolName) view public returns (uint) {
198     //     uint total = symbolName * 0.00000001 ether;
199     //     return total;
200     // }
201     
202 }