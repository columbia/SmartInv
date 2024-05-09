1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 interface ERC20 {
33     function balanceOf(address who) external view returns (uint256);
34     function transfer(address to, uint256 value) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function transferFrom(address from, address to, uint256 value) external returns (bool);
37     function approve(address spender, uint256 value) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 contract SafeBoxCoin is ERC20 {
43     using SafeMath for uint;
44        
45     string internal _name;
46     string internal _symbol;
47     uint8 internal _decimals;
48     uint256 internal _totalSupply;
49 
50     mapping (address => uint256) internal balances;
51     mapping (address => mapping (address => uint256)) internal allowed;
52 
53     function SafeBoxCoin() public {
54         _symbol = "SBC";
55         _name = "SafeBoxCoin";
56         _decimals = 18;
57         _totalSupply = 252000000;
58         balances[msg.sender] = _totalSupply;
59     }
60 
61     function transfer(address _to, uint256 _value) external returns (bool) {
62       require(_to != address(0));
63       require(_value <= balances[msg.sender]);
64       balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
65       balances[_to] = SafeMath.add(balances[_to], _value);
66       emit Transfer(msg.sender, _to, _value);
67       return true;
68     }
69 
70     function balanceOf(address _owner) external view returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
75         require(_to != address(0));
76         require(_value <= balances[_from]);
77         require(_value <= allowed[_from][msg.sender]);
78 
79         balances[_from] = SafeMath.sub(balances[_from], _value);
80         balances[_to] = SafeMath.add(balances[_to], _value);
81         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
82         emit Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) external returns (bool) {
87         allowed[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) external view returns (uint256) {
93         return allowed[_owner][_spender];
94     }
95 
96     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
98         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99         return true;
100     }
101 
102     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103         uint oldValue = allowed[msg.sender][_spender];
104         if (_subtractedValue > oldValue) {
105         allowed[msg.sender][_spender] = 0;
106         } else {
107         allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
108         }
109         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110         return true;
111     }
112 
113 }
114 
115 contract SafeBox is SafeBoxCoin {
116     
117     mapping (address => user) private users;
118     user private user_object;
119     address private owner;
120     address private account_1;
121     address private account_2;
122     uint256 private divided_value;
123     Safe safe_object;
124     mapping (address =>  mapping (string => Safe)) private map_data_safe_benefited;
125     Prices public prices;
126     
127     struct Prices {
128         uint256 create;
129         uint256 edit;
130         uint256 active_contract;
131     }
132 
133 
134     function SafeBox() public {
135         owner = msg.sender;
136         account_1 = 0x8Fc18dc65E432CaA9583F7024CC7B40ed99fd8e4;
137         account_2 = 0x51cbdb8CE8dE444D0cBC0a2a64066A852e14ff51;
138         prices.create = 1000;
139         prices.edit = 1000;
140         prices.active_contract = 7500;
141     }
142 
143     modifier onlyOwner {
144         require(msg.sender == owner);
145         _;
146     }
147 
148     function set_prices(uint256 _create, uint256 _edit, uint256 _active_contract) public onlyOwner returns (bool success){
149         prices.create = _create;
150         prices.edit = _edit;
151         prices.active_contract = _active_contract;
152         return true;
153     }
154 
155 
156     function _transfer(uint256 _value) private returns (bool) {
157       require(owner != address(0));
158       require(_value <= SafeBoxCoin.balances[msg.sender]);
159       SafeBoxCoin.balances[msg.sender] = SafeMath.sub(SafeBoxCoin.balances[msg.sender], _value);
160       divided_value = _value / 2;
161       SafeBoxCoin.balances[owner] = SafeMath.add(SafeBoxCoin.balances[owner], divided_value);
162       SafeBoxCoin.balances[account_1] = SafeMath.add(SafeBoxCoin.balances[account_1], divided_value / 2);
163       SafeBoxCoin.balances[account_2] = SafeMath.add(SafeBoxCoin.balances[account_2], divided_value / 2);
164       emit Transfer(msg.sender, owner, _value);
165       return true;
166     }
167 
168     function set_status_user(address _address, bool _active_contract) public onlyOwner returns (bool success) {
169         users[_address].active_contract = _active_contract;
170         return true;
171     }
172 
173     function set_active_contract() public returns (bool success) {
174         require(_transfer(prices.active_contract));
175         users[msg.sender].active_contract = true;
176         return true;
177     }
178 
179     function get_status_user(address _address) public view returns (
180             bool _user_exists, bool _active_contract){
181         _active_contract = users[_address].active_contract;
182         _user_exists = users[_address].exists;
183         return (_active_contract, _user_exists);
184     }
185 
186     struct user {
187         bool exists;
188         address endereco;
189         bool active_contract;
190     }
191 
192     function _create_user(address _address) private {
193         user_object = user(true, _address, true);
194         users[_address] = user_object;
195     }
196     
197     struct Safe {
198         address safe_owner_address;
199         bool exists;
200         string safe_name;
201         address benefited_address;
202         string data;
203     }
204 
205 
206     function create_safe(address _benef, string _data, string _safe_name) public returns (bool success) {
207         require(map_data_safe_benefited[_benef][_safe_name].exists == false);
208         require(_transfer(prices.create));
209         if(users[msg.sender].exists == false){
210             _create_user(msg.sender);
211         }
212         safe_object = Safe(msg.sender, true, _safe_name, _benef, _data);
213         map_data_safe_benefited[_benef][_safe_name] = safe_object;
214         return true;
215     }
216 
217     function edit_safe(address _benef, string _new_data,
218             string _safe_name) public returns (bool success) {
219         require(map_data_safe_benefited[_benef][_safe_name].exists == true);
220         require(users[msg.sender].exists == true);
221         require(_transfer(prices.edit));
222         map_data_safe_benefited[_benef][_safe_name].data = _new_data;
223         return true;
224     }
225 
226     function get_data_benefited(address _benef,
227             string _safe_name) public view returns (string) {
228         require(map_data_safe_benefited[_benef][_safe_name].exists == true);
229         address _safe_owner_address = map_data_safe_benefited[_benef][_safe_name].safe_owner_address;
230         require(users[_safe_owner_address].active_contract == true);
231         return map_data_safe_benefited[_benef][_safe_name].data;
232     }
233 }