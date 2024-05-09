1 pragma solidity ^0.5.12;
2  
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */ 
7 library SafeMath{
8     function mul(uint a, uint b) internal pure returns (uint){
9         uint c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13  
14     function div(uint a, uint b) internal pure returns (uint){
15         uint c = a / b;
16         return c;
17     }
18  
19     function sub(uint a, uint b) internal pure returns (uint){
20         assert(b <= a); 
21         return a - b; 
22     } 
23   
24     function add(uint a, uint b) internal pure returns (uint){ 
25         uint c = a + b; assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title ITCM Token token
32  * @dev ERC20 Token implementation, with its own specific
33  */
34 contract ITCMToken{
35     using SafeMath for uint;
36     
37     string public constant name = "ITC Money";
38     string public constant symbol = "ITCM";
39     uint32 public constant decimals = 18;
40 
41     address public contractCreator = address(0);
42     address public mintingAllowedForAddr = address(0);
43     address public constant managementProfitAddr = 0xe0b70c54a1baa2847e210d019Bb8edc291AEA5c7;
44     
45     uint public totalSupply = 0;
46     // 5 billions is for minting with corporate programs and 240 millions will be transferred next.
47     uint public leftToMint = (5000000000 + 240000000) * 1 ether;
48     
49     mapping(address => uint) balances;
50     mapping (address => mapping (address => uint)) internal allowed;
51     
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 
55     /** 
56      * @dev Initial token transfers.
57      */
58     constructor() public{
59         contractCreator = msg.sender;
60     
61         // Initial tokens for company persons and seller address
62         _mint(contractCreator, 240000000 * 1 ether);
63         // Tokens that was sold till 8 of Nov 2019. On Nov 28 of 2019 another portion will be minted and transfer process will be started.
64         _mint(contractCreator, 178184757 * 1 ether);
65         // Bonus program tokens that was minted till 8 of Nov 2019. The same process for sold tokens on Nov 28.
66         _mint(contractCreator,   6144301 * 1 ether);
67 
68         // Transfer initial tokens to its owners. 100 millions ITCM rest is for sell with ITCM coop. program.
69         _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6, 70000000 * 1 ether);
70         _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6, 50000000 * 1 ether);
71         _transfer(0xB5D8849b5b81bB1003AA64eCFdA4938DBDc0C67b,  2000000 * 1 ether);
72         _transfer(0x51c082F197449b8dD5587eF85C30d611cf9b1B25,  2500000 * 1 ether);
73         _transfer(0x175d3Fe18bFDCdb7c6153e6C46C97Aa9441F02e1,   300000 * 1 ether);
74         _transfer(0x1C062078d1A2B9102A9d02e99af2B6973FBd22fe,   500000 * 1 ether);
75         _transfer(0xaF578731Ce9EeEf60B67adBE698084345DE9a549,  1000000 * 1 ether);
76         _transfer(0xc0fAD716D0E1B2693E1c632dA025FCE72827748f,   500000 * 1 ether);
77         _transfer(0x312b2504017216BF76Af55c0A060335D3812D793,   800000 * 1 ether);
78         _transfer(0xd3E798A8Fcc53b3e1c781A899A5fA17cD58044f6,   500000 * 1 ether);
79         _transfer(0xc161fb641DB022d2Bc88c4a9E9631f7D2a9ce686,   300000 * 1 ether);
80         _transfer(0x7276c6e706008ACFe5d6D8B7B5bCe0D577466071,   200000 * 1 ether);
81         _transfer(0x714e9c780f92b4460CA12b27c3f3293756245179,   100000 * 1 ether);
82         _transfer(0xa194A1e684C0328E1B2411E8B0327d18069B8Fe2,   100000 * 1 ether);
83         _transfer(0x596da5961C8940dD207C1C12232d0F06DbfB89b7,  2000000 * 1 ether);
84         _transfer(0x2bB71A30206C15F7A84c64C4905a40311cd1C995,  1000000 * 1 ether);
85         _transfer(0x32D2A09aD9736195F14eA14dfC243C81D32fE6Cc,  1000000 * 1 ether);
86         _transfer(0x176078eb89d501b40502869411667e6C04d6A9d4,  1000000 * 1 ether);
87         _transfer(0xc43253800992627c4cB426C2b7c5882962F075b5,  1000000 * 1 ether);
88         _transfer(0x2D9Aff7Fc7331225150aff90E4B0f1B90912081B,   500000 * 1 ether);
89         _transfer(0xfD568AEA9C86d21a01ea4f7a9bCEDAFddE1bC3F9,   200000 * 1 ether);
90         _transfer(0x87AB7A9f019659e6bC5508Cb83C4DBeDf5eeCf48,   200000 * 1 ether);
91         _transfer(0xaA23F54D2e1764C18de004085e24e8d05AD3b848,   200000 * 1 ether);
92         _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6,  4100000 * 1 ether);
93     }
94     
95     /** 
96      * @dev Gets the balance of the specified address.
97      * @param _owner The address to query the the balance of.
98      * @return An uint256 representing the amount owned by the passed address.
99      */
100     function balanceOf(address _owner) public view returns (uint){
101         return balances[_owner];
102     }
103  
104     /**
105      * @dev Transfer token for a specified address
106      * @param _to The address to transfer to.
107      * @param _value The amount to be transferred.
108      */ 
109     function _transfer(address _to, uint _value) private returns (bool){
110         require(msg.sender != address(0), "Sender address cannon be null");
111         require(_to != address(0), "Receiver address cannot be null");
112         require(_to != address(this), "Receiver address cannot be ITCM contract address");
113         require(_value > 0 && _value <= balances[msg.sender], "Unavailable amount requested");
114         balances[msg.sender] = balances[msg.sender].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         emit Transfer(msg.sender, _to, _value);
117         return true; 
118     }
119 
120     /**
121      * @dev Transfer token for a specified address
122      * @param _to The address to transfer to.
123      * @param _value The amount to be transferred.
124      */ 
125     function transfer(address _to, uint _value) public returns (bool){
126         return _transfer(_to, _value);
127     } 
128     
129     /**
130      * @dev Transfer several token for a specified addresses
131      * @param _to The array of addresses to transfer to.
132      * @param _value The array of amounts to be transferred.
133      */ 
134     function massTransfer(address[] memory _to, uint[] memory _value) public returns (bool){
135         require(_to.length == _value.length, "You have different amount of addresses and amounts");
136 
137         uint len = _to.length;
138         for(uint i = 0; i < len; i++){
139             if(!_transfer(_to[i], _value[i])){
140                 return false;
141             }
142         }
143         return true;
144     } 
145     
146     /**
147      * @dev Transfer tokens from one address to another
148      * @param _from address The address which you want to send tokens from
149      * @param _to address The address which you want to transfer to
150      * @param _value uint256 the amount of tokens to be transferred
151      */ 
152     function transferFrom(address _from, address _to, uint _value) public returns (bool){
153         require(msg.sender != address(0), "Sender address cannon be null");
154         require(_to != address(0), "Receiver address cannot be null");
155         require(_to != address(this), "Receiver address cannot be ITCM contract address");
156         require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender], "Unavailable amount requested");
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         emit Transfer(_from, _to, _value);
161         return true;
162     }
163  
164     /**
165      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166      * @param _spender The address which will spend the funds.
167      * @param _value The amount of tokens to be spent.
168      */
169     function approve(address _spender, uint _value) public returns (bool){
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174  
175     /** 
176      * @dev Function to check the amount of tokens that an owner allowed to a spender.
177      * @param _owner address The address which owns the funds.
178      * @param _spender address The address which will spend the funds.
179      * @return A uint256 specifying the amount of tokens still available for the spender.
180      */
181     function allowance(address _owner, address _spender) public view returns (uint){
182         return allowed[_owner][_spender]; 
183     } 
184  
185     /**
186      * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
187      * @param _spender The address which will spend the funds.
188      * @param _addedValue The amount of tokens to be spent.
189      */
190     function increaseApproval(address _spender, uint _addedValue) public returns (bool){
191         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
193         return true; 
194     }
195  
196     /**
197      * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
198      * @param _spender The address which will spend the funds.
199      * @param _subtractedValue The amount of tokens to be spent.
200      */
201     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
202         uint oldValue = allowed[msg.sender][_spender];
203         if(_subtractedValue > oldValue){
204             allowed[msg.sender][_spender] = 0;
205         }else{
206             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207         }
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211     
212     /**
213      * @dev Emit new tokens and transfer from 0 to client address. This function will generate 21.5% of tokens for management address as well.
214      * @param _to The address to transfer to.
215      * @param _value The amount to be transferred.
216      */ 
217     function _mint(address _to, uint _value) private returns (bool){
218         require(_to != address(0), "Receiver address cannot be null");
219         require(_to != address(this), "Receiver address cannot be ITCM contract address");
220         require(_value > 0 && _value <= leftToMint, "Looks like we are unable to mint such amount");
221 
222         // 21.5% of token amount to management address
223         uint managementAmount = _value.mul(215).div(1000);
224         
225         leftToMint = leftToMint.sub(_value);
226         totalSupply = totalSupply.add(_value);
227         totalSupply = totalSupply.add(managementAmount);
228         
229         balances[_to] = balances[_to].add(_value);
230         balances[managementProfitAddr] = balances[managementProfitAddr].add(managementAmount);
231 
232         emit Transfer(address(0), _to, _value);
233         emit Transfer(address(0), managementProfitAddr, managementAmount);
234 
235         return true;
236     }
237 
238     /**
239      * @dev This is wrapper for _mint.
240      * @param _to The address to transfer to.
241      * @param _value The amount to be transferred.
242      */ 
243     function mint(address _to, uint _value) public returns (bool){
244         require(msg.sender != address(0), "Sender address cannon be null");
245         require(msg.sender == mintingAllowedForAddr || mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "You are unavailable to mint tokens");
246 
247         return _mint(_to, _value);
248     }
249 
250     /**
251      * @dev Similar to mint function but take array of addresses and values.
252      * @param _to The addresses to transfer to.
253      * @param _value The amounts to be transferred.
254      */ 
255     function mint(address[] memory _to, uint[] memory _value) public returns (bool){
256         require(_to.length == _value.length, "You have different amount of addresses and amounts");
257         require(msg.sender != address(0), "Sender address cannon be null");
258         require(msg.sender == mintingAllowedForAddr || mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "You are unavailable to mint tokens");
259 
260         uint len = _to.length;
261         for(uint i = 0; i < len; i++){
262             if(!_mint(_to[i], _value[i])){
263                 return false;
264             }
265         }
266         return true;
267     }
268 
269     /**
270      * @dev Set a contract address that allowed to mint tokens.
271      * @param _address The address of another contract.
272      */ 
273     function setMintingContractAddress(address _address) public returns (bool){
274         require(mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "Only contract creator can set minting contract and only when it is not set");
275         mintingAllowedForAddr = _address;
276         return true;
277     }
278 }