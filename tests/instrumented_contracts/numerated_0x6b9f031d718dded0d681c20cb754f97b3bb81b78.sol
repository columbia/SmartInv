1 pragma solidity ^0.4.26;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6 	return (c);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11 	return (c);
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16 	return (c);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21 	return (c);
22     }
23 }
24 contract ERC20Interface {
25     function totalSupply() public constant returns (uint);
26     function balanceOf(address tokenOwner) public constant returns (uint balance);
27     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);   
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);      
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens); 
34 }
35 
36 contract ApproveAndCallFallBack {
37     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
38 }
39 
40 contract Owned {
41     address public owner;
42     address public newOwner;
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);      //sets temporary but public variable to zero after migration complete
57     }
58 }
59 
60 contract GEEQToken is ERC20Interface, Owned {
61     using SafeMath for uint;
62     string public symbol;
63     string public  name;
64     uint8 public decimals;
65     uint256 _totalSupply;
66     uint256 _totalMinted;
67     uint256 _maxMintable;
68     bool public pauseOn;
69     bool public migrationOn;
70     
71     mapping(address => uint) public balances;
72     mapping(address => mapping(address => uint)) allowed;   //Hate But Keep ERC20 compliance
73 
74     event PauseEvent(string pauseevent);
75     event ErrorEvent(address indexed addr, string errorstr);
76     event BurnEvent(address indexed addr, uint256 tokens);
77 
78     constructor() public {
79         symbol = "GEEQ";
80         name = "Geeq";
81         decimals = 18;
82         _totalMinted = 0;       //Total that has been minted. Burned tokens can not be replaced
83         _totalSupply = 0;       //Total in circulation, which is minted - burned
84         _maxMintable = 100000000 * 10**uint(decimals);  //Capped at 100 mil tokens
85         owner = msg.sender;
86     }
87     
88     mapping(address => bytes32) public geeqaddress;
89     event MigrateEvent(address indexed addr, bytes32 geeqaddress, uint256 balance);
90     function migrateGEEQ(bytes32 registeraddress) public {
91         if (migrationOn){
92             geeqaddress[msg.sender] = registeraddress;  //store the GEEQ wallet address in the Ethereum blockchain
93             emit MigrateEvent(msg.sender, registeraddress, balances[msg.sender]);    //Ideally log the tokens for easy indexing
94             burn(balances[msg.sender]);
95         } else {
96             emit ErrorEvent (msg.sender, "Attempted to migrate before GEEQ Migration has begun.");
97         }
98     }
99     
100     //In case someone accidentally or airdrop sends a token, the owner can retreive it.
101     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
102         return ERC20Interface(tokenAddress).transfer(owner, tokens);
103     }    
104     
105     
106     function pauseEnable() onlyOwner public {
107         pauseOn= true;
108     }
109     function pauseDisable() onlyOwner public {
110         pauseOn= false;
111     }
112     function migrationEnable() onlyOwner public {
113         migrationOn= true;
114     }
115     function migrationDisable() onlyOwner public {
116         migrationOn= false;
117     }
118 
119     
120     function totalSupply() public constant returns (uint) {
121         return _totalSupply;
122     }
123     function totalMinted() public constant returns (uint) {
124         return _totalMinted;
125     }
126     function burn(uint256 tokens) internal {      //works even if contract is paused
127         if(balances[msg.sender]>= tokens) {
128             _totalSupply=_totalSupply.sub(balances[msg.sender]);
129             balances[msg.sender] = balances[msg.sender].sub(tokens);
130             balances[address(0)] = balances[address(0)].add(tokens);
131             emit BurnEvent(msg.sender, tokens);
132         } else {
133             revert();       //necessary explicit - sender attempted to burn more tokens than owned.
134         }            
135     }
136 
137     //Mint function, can not create more than totalSupply
138     function mint(address receiver, uint256 token_amt) onlyOwner public {            
139         if( _totalMinted.add(token_amt) > _maxMintable) { 
140             revert();       //Can not mint more than _maxMintable
141         }
142         balances[receiver] = balances[receiver].add(token_amt);
143         _totalMinted =_totalMinted.add(token_amt);
144         _totalSupply =_totalSupply.add(token_amt);
145         emit Transfer(address(0), receiver, token_amt);      //This way the correct number of tokens will appear on Etherscan. That is the entire purpose of this event.
146     } 
147 
148 
149     //Below is the ERC20 logic, with Pause disabling transfer.
150     function balanceOf(address tokenOwner) public constant returns (uint balance) {
151         return balances[tokenOwner];
152     }
153 
154 
155     function transfer(address to, uint tokens) public returns (bool success) {
156         if(pauseOn){
157             emit ErrorEvent(msg.sender, "Contract is paused. Please migrate to the native chain with migrateGEEQ.");
158             revert();           //unnecessarily explicit
159         } else {
160             balances[msg.sender] = balances[msg.sender].sub(tokens);
161             balances[to] = balances[to].add(tokens);
162             emit Transfer(msg.sender, to, tokens);
163             return true;           //unnecessarily explicit
164         }
165     }
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     } 
171     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
172         if(pauseOn){
173             emit ErrorEvent(msg.sender, "Contract is paused. Please migrate to the native chain with migrateGEEQ.");
174             revert();           //unnecessarily explicit
175         } else {
176             balances[from] = balances[from].sub(tokens);
177             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
178             balances[to] = balances[to].add(tokens);
179             emit Transfer(from, to, tokens);
180             return true;           //unnecessarily explicit
181         }
182     }
183     
184     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
185         return allowed[tokenOwner][spender];
186     }  
187     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;           //unnecessarily explicit
192     }  
193     function() public { }
194     
195 
196 }