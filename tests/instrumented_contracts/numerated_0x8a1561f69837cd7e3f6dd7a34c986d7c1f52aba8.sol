1 pragma solidity ^0.4.21;
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
42 contract SafeCoin is ERC20 {
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
53     function SafeCoin() public {
54         _symbol = "SFC";
55         _name = "SafeCoin";
56         _decimals = 18;
57         _totalSupply = 500000000;
58         balances[msg.sender] = _totalSupply;
59     }
60 
61     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
62       require(_to != address(0));
63       require(_value <= balances[_from]);
64       balances[_from] = SafeMath.sub(balances[_from], _value);
65       balances[_to] = SafeMath.add(balances[_to], _value);
66       emit Transfer(_from, _to, _value);
67       return true;
68     }
69 
70 
71     function transfer(address _to, uint256 _value) external returns (bool) {
72       require(_to != address(0));
73       require(_value <= balances[msg.sender]);
74       balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
75       balances[_to] = SafeMath.add(balances[_to], _value);
76       emit Transfer(msg.sender, _to, _value);
77       return true;
78     }
79 
80     function balanceOf(address _owner) external view returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[_from]);
87         require(_value <= allowed[_from][msg.sender]);
88 
89         balances[_from] = SafeMath.sub(balances[_from], _value);
90         balances[_to] = SafeMath.add(balances[_to], _value);
91         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
92         emit Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function approve(address _spender, uint256 _value) external returns (bool) {
97         allowed[msg.sender][_spender] = _value;
98         emit Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) external view returns (uint256) {
103         return allowed[_owner][_spender];
104     }
105 
106     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
107         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
108         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109         return true;
110     }
111 
112     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113         uint oldValue = allowed[msg.sender][_spender];
114         if (_subtractedValue > oldValue) {
115         allowed[msg.sender][_spender] = 0;
116         } else {
117         allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
118         }
119         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120         return true;
121     }
122 
123 }
124 
125 contract SafeBox is SafeCoin {
126     // ========================================================================================================
127     // ========================================================================================================
128     // FUNCTIONS RELATING TO THE MANAGEMENT OF THE CONTRACT ===================================================
129     mapping (address => user) private users;
130     user private user_object;
131     address private owner;
132     
133     struct Prices {
134         uint8 create;
135         uint8 edit;
136         uint8 active_contract;
137     }
138 
139     Prices public prices;
140 
141     function SafeBox() public {
142         owner = msg.sender;
143         prices.create = 10;
144         prices.edit = 10;
145         prices.active_contract = 10;
146     }
147 
148     modifier onlyOwner {
149         require(msg.sender == owner);
150         _;
151     }
152 
153     // Muda o dono do contrato
154     function set_prices(uint8 _create, uint8 _edit, uint8 _active_contract) public onlyOwner returns (bool success){
155         prices.create = _create;
156         prices.edit = _edit;
157         prices.active_contract = _active_contract;
158         return true;
159     }
160 
161     function _my_transfer(address _address, uint8 _price) private returns (bool) {
162         SafeCoin._transfer(_address, owner, _price);
163         return true;
164     }
165 
166 
167     // ========================================================================================================
168     // ========================================================================================================
169     // FUNCOES RELATIVAS AO GERENCIAMENTO DE USUARIOS =========================================================
170     function set_status_user(address _address, bool _live_user, bool _active_contract) public onlyOwner returns (bool success) {
171         users[_address].live_user = _live_user;
172         users[_address].active_contract = _active_contract;
173         return true;
174     }
175 
176     function set_active_contract() public returns (bool success) {
177         require(_my_transfer(msg.sender, prices.active_contract));
178         users[msg.sender].active_contract = true;
179         return true;
180     }
181 
182     // PUBLIC TEMPORARIAMENTE, DEPOIS PRIVATE
183     function get_status_user(address _address) public view returns (
184             bool _live_user, bool _active_contract, bool _user_exists){
185         _live_user = users[_address].live_user;
186         _active_contract = users[_address].active_contract;
187         _user_exists = users[_address].exists;
188         return (_live_user, _active_contract, _user_exists);
189     }
190 
191     // Criando objeto usuario
192     struct user {
193         bool exists;
194         address endereco;
195         bool live_user;
196         bool active_contract;
197     }
198 
199     function _create_user(address _address) private {
200         /*
201             Função privada cria user
202         */
203         user_object = user(true, _address, true, true);
204         users[_address] = user_object;
205     }
206     
207     // ========================================================================================================
208     // ========================================================================================================
209     // FUNÇÔES REFERENTES AOS COFRES ==========================================================================
210     struct Safe {
211         address safe_owner_address;
212         bool exists;
213         string safe_name;
214         address benefited_address;
215         string data;
216     }
217 
218     Safe safe_object;
219     // Endereco titular + safe_name = ObjetoDados 
220     mapping (address =>  mapping (string =>  Safe)) private map_data_safe_owner;
221     // Endereco benefited_address = ObjetoDados     
222     mapping (address =>  mapping (string =>  Safe)) private map_data_safe_benefited;
223 
224     function create_safe(address _benef, string _data, string _safe_name) public returns (bool success) {
225         require(map_data_safe_owner[msg.sender][_safe_name].exists == false);
226         require(_my_transfer(msg.sender, prices.create));
227         if(users[msg.sender].exists == false){
228             _create_user(msg.sender);
229         }
230         // Transfere os tokens para o owner
231         // Cria um struct Safe
232         safe_object = Safe(msg.sender, true, _safe_name, _benef, _data);
233         // Salva o cofre no dicionario do titular
234         map_data_safe_owner[msg.sender][_safe_name] = safe_object;
235         // Salva o cofre no dicionario do beneficiado
236         map_data_safe_benefited[_benef][_safe_name] = safe_object;
237         return true;
238     }
239 
240     function edit_safe(address _benef, string _new_data,
241                          string _safe_name) public returns (bool success) {
242         require(map_data_safe_owner[msg.sender][_safe_name].exists == true);
243         require(users[msg.sender].exists == true);
244         require(_my_transfer(msg.sender, prices.edit));
245         // _token.transferToOwner(msg.sender, owner, prices.edit, senha_owner);
246         // Salva o cofre no dicionario do titular
247         map_data_safe_owner[msg.sender][_safe_name].data = _new_data;
248         // Salva o cofre no dicionario do beneficiado
249         map_data_safe_benefited[_benef][_safe_name].data = _new_data;
250         return true;
251     }
252 
253     //  Get infor do cofre beneficiado
254     function get_data_benefited(address _benef,
255             string _safe_name) public view returns (string) {
256         require(map_data_safe_benefited[_benef][_safe_name].exists == true);
257         address _safe_owner_address = map_data_safe_benefited[_benef][_safe_name].safe_owner_address;
258         require(users[_safe_owner_address].live_user == false);
259         require(users[_safe_owner_address].active_contract == true);
260         return map_data_safe_benefited[_benef][_safe_name].data;
261     }
262 
263     //  Get infor do cofre beneficiado
264     function get_data_owner(address _address, string _safe_name)
265             public view returns (address _benefited_address, string _data) {
266         require(map_data_safe_owner[_address][_safe_name].exists == true);
267         require(users[_address].active_contract == true);
268         _benefited_address = map_data_safe_owner[_address][_safe_name].benefited_address;
269         _data = map_data_safe_owner[_address][_safe_name].data;
270         return (_benefited_address, _data);
271     }
272 
273 }