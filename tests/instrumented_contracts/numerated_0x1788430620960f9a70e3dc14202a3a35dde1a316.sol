1 pragma solidity 0.5.14;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: Addition overflow");
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         require(b <= a, "SafeMath: Subtraction overflow");
14         uint256 c = a - b;
15         return c;
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         
23         uint256 c = a * b;
24         require(c / a == b, "SafeMath: Multiplication overflow");
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when divide by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35     
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, "SafeMath: Modulo by zero");
38         return a % b;
39     }
40 }
41 
42 
43 contract ERC20 {
44     function transferFrom(address from, address to, uint256 value) public returns (bool);
45     function approve(address spender, uint256 value) public returns (bool);
46     function transfer(address to, uint256 value) public returns(bool);
47     function allowance(address owner, address spender) public view returns (uint256);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 contract OpenAlexaProtocol is ERC20 {
54     
55     using SafeMath for uint256;
56     
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60     uint256 public totalSupply;
61     address public burnAddress;
62     address public owner;
63     address public sigAddress;
64     
65     mapping (address => uint256) public balances;
66     mapping (address => mapping (address => uint256)) public allowed;
67     mapping (bytes32 => bool) private hashConfirmation;
68 
69     constructor (address _burnAddress, address _sigAddress) public {
70         symbol = "OAP";
71         name = "Open Alexa Protocol";
72         decimals = 18;
73         burnAddress = _burnAddress;
74         owner = msg.sender;
75         sigAddress = _sigAddress;
76     }
77     
78     modifier onlyOwner() {
79         require(msg.sender == owner, "Only owner");
80         _;
81     }
82     
83     /**
84      * @dev Check balance of the holder
85      * @param _owner Token holder address
86      */ 
87     function balanceOf(address _owner) public view returns (uint256) {
88         return balances[_owner];
89     }
90 
91     /**
92      * @dev Transfer token to specified address
93      * @param _to Receiver address
94      * @param _value Amount of the tokens
95      */
96     function transfer(address _to, uint256 _value) public returns (bool) {
97         require(_to != address(0), "Invalid address");
98         require(_value <= balances[msg.sender], "Insufficient balance");
99         
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         uint256 burnFee = (_value.mul(0.1 ether)).div(10**20);
102         uint256 balanceFee = _value.sub(burnFee);
103         balances[burnAddress] = balances[burnAddress].add(burnFee);
104         balances[_to] = balances[_to].add(balanceFee);
105         
106         emit Transfer(msg.sender, _to, balanceFee);
107         emit Transfer(msg.sender, burnAddress, burnFee);
108         return true;
109     }
110 
111     /**
112      * @dev Transfer tokens from one address to another
113      * @param _from  The holder address
114      * @param _to  The Receiver address
115      * @param _value  the amount of tokens to be transferred
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118         require(_from != address(0), "Invalid from address");
119         require(_to != address(0), "Invalid to address");
120         require(_value <= balances[_from], "Invalid balance");
121         require(_value <= allowed[_from][msg.sender], "Invalid allowance");
122         
123         balances[_from] = balances[_from].sub(_value);
124         uint256 burnFee = (_value.mul(0.1 ether)).div(10**20);
125         uint256 balanceFee = _value.sub(burnFee);
126         balances[burnAddress] = balances[burnAddress].add(burnFee);
127         balances[msg.sender] = balances[msg.sender].add(balanceFee);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         
130         emit Transfer(_from, _to, balanceFee);
131         emit Transfer(_from, burnAddress, burnFee);
132         return true;
133     }
134     
135     /**
136      * @dev Approve respective tokens for spender
137      * @param _spender Spender address
138      * @param _value Amount of tokens to be allowed
139      */
140     function approve(address _spender, uint256 _value) public returns (bool) {
141         require(_spender != address(0), "Null address");
142         require(_value > 0, "Invalid value");
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     /**
149      * @dev To view approved balance
150      * @param _owner Holder address
151      * @param _spender Spender address
152      */ 
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }  
156     
157     /**
158      * @dev To change burnt Address
159      * @param _newOwner New owner address
160      */ 
161     function changeowner(address _newOwner) public onlyOwner returns(bool) {
162         require(_newOwner != address(0), "Invalid Address");
163         owner = _newOwner;
164         return true;
165     }
166    
167     
168     /**
169      * @dev To change burnt Address
170      * @param _burnAddress New burn address
171      */ 
172     function changeburnt(address _burnAddress) public onlyOwner returns(bool) {
173         require(_burnAddress != address(0), "Invalid Address");
174         burnAddress = _burnAddress;
175         return true;
176     }
177     
178     /**
179      * @dev To change signature Address
180      * @param _newSigAddress New sigOwner address
181      */ 
182     function changesigAddress(address _newSigAddress) public onlyOwner returns(bool) {
183         require(_newSigAddress != address(0), "Invalid Address");
184         sigAddress = _newSigAddress;
185         return true;
186     }
187     
188     /**
189      * @dev To mint OAP Tokens
190      * @param _receiver Reciever address
191      * @param _amount Amount to mint
192      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
193      * @param _v  v of signature
194      */ 
195     function mint(address _receiver, uint256 _amount,bytes32[3] memory _mrs, uint8 _v) public returns (bool) {
196         require(_receiver != address(0), "Invalid address");
197         require(_amount >= 0, "Invalid amount");
198         require(hashConfirmation[_mrs[0]] != true, "Hash exists");
199         require(ecrecover(_mrs[0], _v, _mrs[1], _mrs[2]) == sigAddress, "Invalid Signature");
200         totalSupply = totalSupply.add(_amount);
201         balances[_receiver] = balances[_receiver].add(_amount);
202         hashConfirmation[_mrs[0]] = true;
203         emit Transfer(address(0), _receiver, _amount);
204         return true;
205     }
206     
207     /**
208      * @dev To mint OAP Tokens
209      * @param _receiver Reciever address
210      * @param _amount Amount to mint
211      */ 
212     function ownerMint(address _receiver, uint256 _amount) public onlyOwner returns (bool) {
213         require(_receiver != address(0), "Invalid address");
214         require(_amount >= 0, "Invalid amount");
215         totalSupply = totalSupply.add(_amount);
216         balances[_receiver] = balances[_receiver].add(_amount);
217         emit Transfer(address(0), _receiver, _amount);
218         return true;
219     }
220 }