1 pragma solidity ^0.4.26;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     string public name ;
7     string public symbol;
8     uint8 public constant decimals = 18;  
9     uint256 public totalSupply;
10 
11     address public deployer;
12     mapping(address => bool) nofees;
13     address public dexPool;
14     address public fund;
15 
16     address public blackHole;
17 
18     uint256 public feeBuyBurn = 10; // 10%
19     uint256 public feeBuyPool = 10; // 10%
20     uint256 public feeBuyFund = 10; // 10%
21     uint256 public feeSellBurn = 10; // 10%
22     uint256 public feeSellPool = 10; // 10%
23     uint256 public feeSellFund = 10; // 10%
24 	
25 	uint256 private constant INITIAL_SUPPLY = 210700000 * (10 ** uint256(decimals));
26 
27     mapping (address => uint256) public balanceOf;  // 
28     mapping (address => mapping (address => uint256)) public allowance;
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Burn(address indexed from, uint256 value);
33 	
34 	event Approval(address indexed owner, address indexed spender, uint256 value);
35 
36 	modifier onlyDeployer() {
37         require(msg.sender == deployer, "Only Deployer");
38         _;
39     }
40 
41     function setDeployer(address _dep) public onlyDeployer {
42     	require(_dep != address(0), "deployer can't be zero");
43     	deployer = _dep;
44     }
45 
46     function setNofees(address _from, bool _flag) public onlyDeployer {
47     	require(_from != address(0), "from can't be zero");
48     	nofees[_from] = _flag;
49     }
50 
51     function setDexPool(address _pool) public onlyDeployer {
52     	require(_pool != address(0), "pool can't be zero");
53     	dexPool = _pool;
54     }
55 
56     function setFund(address _fund) public onlyDeployer {
57     	require(_fund != address(0), "fund can't be zero");
58     	fund = _fund;
59     }
60 
61     function setBlackHole(address _b) public onlyDeployer {
62     	require(_b != address(0), "blackHole can't be zero");
63     	blackHole = _b;
64     }
65 
66     function setFeeBuyBurn(uint256 _fee) public onlyDeployer {
67     	require(_fee > 0, "fee can't be zero");
68     	feeBuyBurn = _fee;
69     }
70 
71     function setFeeBuyPool(uint256 _fee) public onlyDeployer {
72     	require(_fee > 0, "fee can't be zero");
73     	feeBuyPool = _fee;
74     }
75 
76     function setFeeBuyFund(uint256 _fee) public onlyDeployer {
77     	require(_fee > 0, "fee can't be zero");
78     	feeBuyFund = _fee;
79     }
80 
81     function setFeeSellBurn(uint256 _fee) public onlyDeployer {
82     	require(_fee > 0, "fee can't be zero");
83     	feeSellBurn = _fee;
84     }
85 
86     function setFeeSellPool(uint256 _fee) public onlyDeployer {
87     	require(_fee > 0, "fee can't be zero");
88     	feeSellPool = _fee;
89     }
90 
91     function setFeeSellFund(uint256 _fee) public onlyDeployer {
92     	require(_fee > 0, "fee can't be zero");
93     	feeSellFund = _fee;
94     }
95 
96 	constructor(string tokenName, string tokenSymbol) public {
97 		totalSupply = INITIAL_SUPPLY;
98         balanceOf[msg.sender] = totalSupply;
99         name = tokenName;
100         symbol = tokenSymbol;
101 
102         deployer = msg.sender;
103     }
104 
105 
106     function _transfer(address _from, address _to, uint _value) internal returns (bool) {
107         require(_to != 0x0);
108         require(balanceOf[_from] >= _value);
109         require(balanceOf[_to] + _value > balanceOf[_to]);
110         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
111 
112         balanceOf[_from] -= _value;
113 
114         if(dexPool != address(0) && !nofees[_from] && !nofees[_to]) {
115         	if(_from == dexPool) {
116         		balanceOf[_to] += (_value * (1000 - feeBuyBurn - feeBuyPool - feeBuyFund) / 1000);
117         		balanceOf[blackHole] += (_value * feeBuyBurn / 1000);
118         		balanceOf[dexPool] += (_value * feeBuyPool / 1000);
119         		balanceOf[fund] += (_value * feeBuyFund / 1000);
120 
121         		emit Transfer(_from, _to, (_value * (1000 - feeBuyBurn - feeBuyPool - feeBuyFund) / 1000));
122         		emit Transfer(_from, blackHole, (_value * feeBuyBurn / 1000));
123         		emit Transfer(_from, dexPool, (_value * feeBuyPool / 1000));
124         		emit Transfer(_from, fund, (_value * feeBuyFund / 1000));
125 
126     		} else if(_to == dexPool) {
127     			balanceOf[_to] += (_value * (1000 - feeSellBurn - feeSellPool - feeSellFund) / 1000);
128         		balanceOf[blackHole] += (_value * feeSellBurn / 1000);
129         		balanceOf[dexPool] += (_value * feeSellPool / 1000);
130         		balanceOf[fund] += (_value * feeSellFund / 1000);
131 
132         		emit Transfer(_from, _to, (_value * (1000 - feeSellBurn - feeSellPool - feeSellFund) / 1000));
133         		emit Transfer(_from, blackHole, (_value * feeSellBurn / 1000));
134         		emit Transfer(_from, dexPool, (_value * feeSellPool / 1000));
135         		emit Transfer(_from, fund, (_value * feeSellFund / 1000));
136     		} else {
137 		        balanceOf[_to] += _value;
138 		        emit Transfer(_from, _to, _value);
139     		}
140         } else {
141 	        balanceOf[_to] += _value;
142 	        emit Transfer(_from, _to, _value);
143 	    }
144         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
145 		return true;
146     }
147 
148     function transfer(address _to, uint256 _value) public returns (bool) {
149         _transfer(msg.sender, _to, _value);
150 		return true;
151     }
152 
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154         require(_value <= allowance[_from][msg.sender]);     // Check allowance
155         allowance[_from][msg.sender] -= _value;
156         _transfer(_from, _to, _value);
157         return true;
158     }
159 
160     function approve(address _spender, uint256 _value) public
161         returns (bool success) {
162 		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
163         allowance[msg.sender][_spender] = _value;
164 		emit Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
169         tokenRecipient spender = tokenRecipient(_spender);
170         if (approve(_spender, _value)) {
171             spender.receiveApproval(msg.sender, _value, this, _extraData);
172             return true;
173         }
174     }
175 
176     function burn(uint256 _value) public returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);
178         balanceOf[msg.sender] -= _value;
179         totalSupply -= _value;
180         emit Burn(msg.sender, _value);
181         return true;
182     }
183 
184     function burnFrom(address _from, uint256 _value) public returns (bool success) {
185         require(balanceOf[_from] >= _value);
186         require(_value <= allowance[_from][msg.sender]);
187         balanceOf[_from] -= _value;
188         allowance[_from][msg.sender] -= _value;
189         totalSupply -= _value;
190         emit Burn(_from, _value);
191         return true;
192     }
193 }