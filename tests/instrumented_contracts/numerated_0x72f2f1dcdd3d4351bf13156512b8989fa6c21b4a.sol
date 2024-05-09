1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract owned {
33     address public owner;
34 
35     function owned () public {
36         owner = msg.sender; 
37     }
38 
39     modifier onlyOwner {
40         require (msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45         owner = newOwner;
46     }
47 }
48 
49 contract tokenRecipient { 
50     function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) public; 
51     
52 }
53 
54 contract RewardsCoin is owned {
55     using SafeMath for uint256;
56 
57     uint256 internal maxSupply;  
58     string public name; 
59     string public symbol; 
60     uint256 public decimals;  
61     uint256 public totalSupply; 
62     address public beneficiary;
63     address public dev1; 
64     address public dev2;
65     address public market1;
66     address public market2; 
67     address public bounty;
68     address public lockedTokens;
69     uint256 public burnt;
70     
71     mapping (address => uint256) public balanceOf;
72     mapping (address => mapping (address => uint256)) public allowance;
73     mapping (address => bool) public frozenAccount;
74 
75     /* This generates a public event on the blockchain that will notify clients */
76     event FrozenFunds(address target, bool frozen);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Burn(address indexed burner, uint256 value);
79     event Burnfrom(address indexed _from, uint256 value);
80 
81     function RewardsCoin() public {
82             
83         name = "Rewards Coin";    
84         symbol = "REW";    
85         decimals = 18;
86         burnt = 0;
87         maxSupply = 25000000 * (10 ** decimals);   
88         totalSupply = totalSupply.add(maxSupply);
89         beneficiary = 0x89F2843837Ba5363b3550560184AC181924aCE4E;
90 
91         //Dev 1 Account
92         dev1 = 0x4a194a5560a8DA2eaDAfc2F82B5793848685e1d3;
93 
94         //Dev 2 Account
95         dev2 = 0x94e77bd7C7a53C533014d53F1965bea2BbD89744;
96 
97         //Advertising & Exchanges account
98         market1 = 0xd08F5062378d4DC60127AF6c86AA5224678725DD;
99         market2 = 0xA6f5C8AaD4f88894E7eA844C29AcebF5A1110435;
100 
101         //Bounties Account
102         bounty = 0x6171a92418fFd0F7CD2687d83B323BaF6A2987A9;
103 
104         //Locked Tokens Account
105         lockedTokens = 0x0778DDC022A0ffaB843c6F3Cb49763Bdeb7C79C4;
106 
107         //Distribution of Tokens to wallets
108         balanceOf[beneficiary]  = balanceOf[beneficiary].add(maxSupply.sub(7500000 * (10 ** decimals))); //17,500,000 (ICO + Pre-sale)
109         balanceOf[dev1]         = balanceOf[dev1].add(maxSupply.sub(24812500 * (10 ** decimals))); //187,500
110         balanceOf[dev2]         = balanceOf[dev2].add(maxSupply.sub(24437500 * (10 ** decimals))); //562,500
111         balanceOf[market1]      = balanceOf[market1].add(maxSupply.sub(24625000 * (10 ** decimals))); //375,000
112         balanceOf[market2]      = balanceOf[market2].add(maxSupply.sub(24625000 * (10 ** decimals))); //375,000
113         balanceOf[bounty]       = balanceOf[bounty].add(maxSupply.sub(24000000 * (10 ** decimals))); //1,000,000
114         balanceOf[lockedTokens] = balanceOf[lockedTokens].add(maxSupply.sub(20000000 * (10 ** decimals))); //5,000,000
115 
116     }
117     
118     function nameChange(string _name, string _symbol) public onlyOwner {
119         name = _name;
120         symbol = _symbol;
121     }
122 
123     function transfer(address _to, uint256 _value) public {
124         if (frozenAccount[msg.sender]) revert(); 
125         if (balanceOf[msg.sender] < _value) revert() ;           
126         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); 
127         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
128         balanceOf[_to] = balanceOf[_to].add(_value);
129         emit Transfer(msg.sender, _to, _value);          
130     }
131     
132     /* Allow another contract to spend some tokens in your behalf */
133     function approve(address _spender, uint256 _value) public
134         returns (bool success) {
135         allowance[msg.sender][_spender] = _value;
136         return true;
137     }
138 
139     /* Approve and then communicate the approved contract in a single tx */
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
141         returns (bool success) {    
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
150         if (frozenAccount[_from]) revert();                        // Check if frozen  
151         if (balanceOf[_from] < _value) revert();                
152         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); 
153         if (_value > allowance[_from][msg.sender]) revert(); 
154         balanceOf[_to] = balanceOf[_to].sub(_value);                     
155         balanceOf[_to] = balanceOf[_to].add(_value);                          
156         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
157         emit Transfer(_from, _to, _value);
158         return true;
159     }
160     
161     function burn(uint256 _value) public {
162         require(_value <= balanceOf[msg.sender]);
163         address burner = msg.sender;
164         balanceOf[burner] = balanceOf[burner].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         burnt = burnt.add(_value);
167         emit Burn(burner, _value);
168         emit Transfer(burner, address(0), _value);
169     }
170   
171     function burnFrom(address _from, uint256 _value) public onlyOwner returns  (bool success) {
172         require (balanceOf[_from] >= _value);            
173         require (msg.sender == owner);   
174         totalSupply = totalSupply.sub(_value);
175         burnt = burnt.add(_value);
176         balanceOf[_from] = balanceOf[_from].sub(_value);                      
177         emit Burnfrom(_from, _value);
178         return true;
179     }
180     
181     function freezeAccount(address target) public onlyOwner {
182         require (msg.sender == owner);   // Check allowance
183         frozenAccount[target] = true;
184         emit FrozenFunds(target, true);
185     }
186     
187     function unFreezeAccount(address target) public onlyOwner {
188         require (msg.sender == owner);   // Check allowance
189         require(frozenAccount[target]);
190         frozenAccount[target] = false;
191         emit FrozenFunds(target, false);
192     }
193 
194     function () private {
195         revert();  
196     }
197 }