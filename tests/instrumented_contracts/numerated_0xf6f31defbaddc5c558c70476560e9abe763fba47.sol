1 pragma solidity 0.4.23;
2 /**
3 * @notice IAD Wallet Token Contract
4 * @dev ERC-20 Standard Compliant Token handler
5 */
6 
7 /**
8 * @title Admin parameters
9 * @dev Define administration parameters for this contract
10 */
11 contract admined { //This token contract is administered
12     address public admin; //Admin address is public
13 
14     /**
15     * @dev Contract constructor
16     * define initial administrator
17     */
18     constructor() internal {
19         admin = msg.sender; //Set initial admin to contract creator
20         emit Admined(admin);
21     }
22 
23     modifier onlyAdmin() { //A modifier to define admin-only functions
24         require(msg.sender == admin);
25         _;
26     }
27 
28     /**
29     * @dev Function to set new admin address
30     * @param _newAdmin The address to transfer administration to
31     */
32     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
33         require(_newAdmin != 0);
34         admin = _newAdmin;
35         emit TransferAdminship(admin);
36     }
37 
38     //All admin actions have a log for public review
39     event TransferAdminship(address newAdminister);
40     event Admined(address administer);
41 
42 }
43 
44 /**
45 * @title ERC20 interface
46 * @dev see https://github.com/ethereum/EIPs/issues/20
47 */
48 contract ERC20 {
49     function name() public view returns (string);
50     function totalSupply() public view returns (uint256);
51     function balanceOf(address who) public view returns (uint256);
52     function transfer(address to, uint256 value) public;
53     function allowance(address owner, address spender) public view;
54     function transferFrom(address from, address to, uint256 value) public;
55     function approve(address spender, uint256 value) public;
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61 * @title Token wallet
62 * @dev ERC20 Token compliant
63 */
64 contract TokenWallet is admined {
65 
66     /**
67     * @notice token contructor.
68     */
69     constructor() public {    
70     }
71 
72     event LogTokenAddedToDirectory(uint256 _index, string _name);
73     event LogTokenTransfer(address _token, address _to, uint256 _amount);
74     event LogTokenAllowanceApprove(address _token, address _to, uint256 _value);
75 
76     ERC20[] public tokenDirectory;
77     string[] public tokenDirectoryName;
78 
79     /***************************
80     * Token Directory functions*
81     ****************************/
82 
83     function addTokenToDirectory(ERC20 _tokenContractAddress) onlyAdmin public returns (uint256){
84         require(_tokenContractAddress != address(0));
85         require(_tokenContractAddress.totalSupply() !=0 );
86         uint256 index = tokenDirectory.push(_tokenContractAddress) - 1;
87         tokenDirectoryName.push(_tokenContractAddress.name());
88         emit LogTokenAddedToDirectory(index,_tokenContractAddress.name());
89         return index;
90 
91     }
92     
93     function replaceDirectoryToken(ERC20 _tokenContractAddress, uint256 _directoryIndex) onlyAdmin public returns (uint256){
94         require(_tokenContractAddress != address(0));
95         require(_tokenContractAddress.totalSupply() !=0 );
96         tokenDirectory[_directoryIndex] = _tokenContractAddress;
97         tokenDirectoryName[_directoryIndex]= _tokenContractAddress.name();
98         emit LogTokenAddedToDirectory(_directoryIndex,_tokenContractAddress.name());
99     }
100 
101     function balanceOfDirectoryToken(uint256 _index) public view returns (uint256) {
102         ERC20 token = tokenDirectory[_index];
103         return token.balanceOf(address(this));
104     }
105 
106     function transferDirectoryToken(uint256 _index, address _to, uint256 _amount) public onlyAdmin{
107         ERC20 token = tokenDirectory[_index];
108         //require(token.transfer(_to,_amount));
109         token.transfer(_to,_amount);
110         emit LogTokenTransfer(token,_to,_amount);
111     }
112 
113     function batchTransferDirectoryToken(uint256 _index,address[] _target,uint256[] _amount) onlyAdmin public {
114         require(_target.length >= _amount.length);
115         uint256 length = _target.length;
116         ERC20 token = tokenDirectory[_index];
117 
118         for (uint i=0; i<length; i++) { //It moves over the array
119             token.transfer(_target[i],_amount[i]);
120             emit LogTokenTransfer(token,_target[i],_amount[i]);       
121         }
122     }
123 
124     function giveDirectoryTokenAllowance(uint256 _index, address _spender, uint256 _value) onlyAdmin public{
125         ERC20 token = tokenDirectory[_index];
126         token.approve(_spender, _value);
127         emit LogTokenAllowanceApprove(token,_spender, _value);
128     }
129 
130     /*************************
131     * General Token functions*
132     **************************/
133 
134     function balanceOfToken (ERC20 _tokenContractAddress) public view returns (uint256) {
135         ERC20 token = _tokenContractAddress;
136         return token.balanceOf(this);
137     }
138 
139     function transferToken(ERC20 _tokenContractAddress, address _to, uint256 _amount) public onlyAdmin{
140         ERC20 token = _tokenContractAddress;
141         //require(token.transfer(_to,_amount));
142         token.transfer(_to,_amount);
143         emit LogTokenTransfer(token,_to,_amount);
144     }
145 
146     function batchTransferToken(ERC20 _tokenContractAddress,address[] _target,uint256[] _amount) onlyAdmin public {
147         require(_target.length >= _amount.length);
148         uint256 length = _target.length;
149         ERC20 token = _tokenContractAddress;
150 
151         for (uint i=0; i<length; i++) { //It moves over the array
152             token.transfer(_target[i],_amount[i]);
153             emit LogTokenTransfer(token,_target[i],_amount[i]);       
154         }
155     }
156 
157     function giveTokenAllowance(ERC20 _tokenContractAddress, address _spender, uint256 _value) onlyAdmin public{
158         ERC20 token = _tokenContractAddress;
159         token.approve(_spender, _value);
160         emit LogTokenAllowanceApprove(token,_spender, _value);
161     }
162 
163 
164     /**
165     * @notice this contract will revert on direct non-function calls, also it's not payable
166     * @dev Function to handle callback calls to contract
167     */
168     function() public {
169         revert();
170     }
171 
172 }