1 pragma solidity ^0.4.4;
2 
3 /*
4 Interface provides ERC20 Standard token methods
5 */
6 interface IERC20StandardToken{
7     //Total supply amount
8     function totalSupply() external constant returns (uint256 supply);
9    
10     //transfer tokens to _toAddress
11     function transfer(address _to, uint256 _value) external returns (bool success);
12     
13     //transfer tokens from _fromAddress to _toAddress
14     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
15 
16     //get _owner address balances
17     function balanceOf(address _owner) external constant returns (uint256 balance);
18 
19     //validate token transfering transaction
20     function approve(address _spender, uint256 _value) external returns (bool success);
21 
22     //??
23     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
24     
25     //Transfer tokens event
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     
28     //Approval tokens event
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 contract ERC20StandardToken is IERC20StandardToken{
33     uint256 public totalSupply;
34     
35     function totalSupply() external constant returns (uint256 supply){
36         return totalSupply;
37     }
38    
39     /*
40     Check transfering transaction valid
41         TRUE: Transfer tokens to customer and return true
42         FALSE: return false
43     */
44     function transfer(address _to, uint256 _value) external returns (bool success) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
47         //if (_value > 0 && balances[msg.sender] >= _value && (balances[_to] + _value) > balances[_to]) {
48         
49         //If transferAmount > 0 and balance >= transferAmount
50         if (_value > 0 && balances[msg.sender] >= _value) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             emit Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
59         //same as above. Replace this line with the following if you want to protect against wrapping uints.
60         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] += _value;
63             balances[_from] -= _value;
64             allowed[_from][msg.sender] -= _value;
65             emit Transfer(_from, _to, _value);
66             return true;
67         } else { return false; }
68     }
69 
70     function balanceOf(address _owner) external constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) external returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
81       return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86     
87     event Transfer(address indexed _from, address indexed _to, uint256 _value);
88     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
89 }
90 
91 /*
92     v1: When customer send 1ETH to contract address, 10 tokens sent to ISSUE_TOKEN_ADDRESS
93     v2: After issue token, send 4,900,000,000 tokens to issue token address
94 */
95 contract TKDToken is ERC20StandardToken {
96     uint256 private constant DECIMALS_AMOUNT = 1000000000000000000;
97     
98     //Supply in ICO: 7,500,000
99     uint256 private constant TOTAL_SUPPLY_AMOUNT = 7500000 * DECIMALS_AMOUNT;
100     
101     //Sell in ICO: 5,500,000
102     uint256 private constant TOTAL_ICO_AMOUNT = 5500000 * DECIMALS_AMOUNT;
103     
104     //Marketing: 2,000,000
105     uint256 private constant TOTAL_MARKETING_AMOUNT = 2000000 * DECIMALS_AMOUNT;
106  
107     //TOKEN INFORMATION
108     string public name = "TKDToken";                   
109     string public symbol ="TKD";
110  
111     uint8 public decimals =  18;
112     address public fundsWallet;
113     address public icoTokenAddress = 0x6ed1d3CF924E19C14EEFE5ea93b5a3b8E9b746bE;
114     address public marketingTokenAddress = 0xc5DE4874bA806611b66511d8eC66Ba99398B194f;
115   
116     //METHODS
117    
118     // This is a constructor function 
119     // which means the following function name has to match the contract name declared above
120     function TKDToken() public payable{
121         //Init properties
122         balances[msg.sender] = TOTAL_SUPPLY_AMOUNT;
123         totalSupply = TOTAL_SUPPLY_AMOUNT;
124         fundsWallet = msg.sender;
125     }
126     
127     function() public payable{
128         uint256 ethReceiveAmount = msg.value;
129         require(ethReceiveAmount > 0);
130         
131         address tokenReceiveAddress = msg.sender;
132         
133         //Only transfer to ICO Token Address and Marketing Token Address
134         require(tokenReceiveAddress == icoTokenAddress || tokenReceiveAddress == marketingTokenAddress);
135         
136         //Only transfer one time
137         require(balances[tokenReceiveAddress] == 0);
138         
139         uint256 tokenSendAmount = 0;
140         if(tokenReceiveAddress == icoTokenAddress){
141             tokenSendAmount = TOTAL_ICO_AMOUNT;    
142         }else{
143             tokenSendAmount = TOTAL_MARKETING_AMOUNT;
144         }
145         
146         require(tokenSendAmount > 0);
147         //Enough token to send
148         require(balances[fundsWallet] >= tokenSendAmount);
149         
150         //Transfer
151         balances[fundsWallet] -= tokenSendAmount;
152         balances[tokenReceiveAddress] += tokenSendAmount;
153         
154         // Broadcast a message to the blockchain
155         emit Transfer(fundsWallet, tokenReceiveAddress, tokenSendAmount); 
156         
157         //Send ETH to funds wallet
158         fundsWallet.transfer(msg.value);     
159     }
160 
161     /* Approves and then calls the receiving contract */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData) private returns (bool success) {
163         allowed[msg.sender][_spender] = _value;
164         emit Approval(msg.sender, _spender, _value);
165 
166         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
167         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
168         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
169         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { assert(false); }
170         return true;
171     }
172 }