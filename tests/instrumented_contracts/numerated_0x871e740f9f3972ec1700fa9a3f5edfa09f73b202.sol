1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-04
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 library SafeMath {
8 
9     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10     
11     if (_a == 0) {
12     return 0;
13     }
14 
15     uint256 c = _a * _b;
16     require(c / _a == _b);
17     return c;
18     }
19 
20     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
21     require(_b > 0);
22     uint256 c = _a / _b;
23     return c;
24     }
25          
26     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     
28     require(_b <= _a);
29     return _a - _b;
30     }
31 
32     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     
34     uint256 c = _a + _b;
35     require(c >= _a);
36     return c;
37     
38     }
39     
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0);
42         return a % b;
43     }
44 }
45 
46     contract Ownable {
47         address public owner;
48         address public newOwner;
49         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50         
51         
52         constructor() public {
53         owner = msg.sender;
54         newOwner = address(0);
55     }
56         
57         
58         modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63         modifier onlyNewOwner() {
64         require(msg.sender != address(0));
65         require(msg.sender == newOwner);
66         _;
67     }
68     
69         function transferOwnership(address _newOwner) public onlyOwner {
70         require(_newOwner != address(0));
71         newOwner = _newOwner;
72     }
73 
74         function acceptOwnership() public onlyNewOwner returns(bool) {
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 }
79 
80     contract ERC20 {
81         
82         function totalSupply() public view returns (uint256);
83         function balanceOf(address who) public view returns (uint256);
84         function allowance(address owner, address spender) public view returns (uint256);
85         function transfer(address to, uint256 value) public returns (bool);
86         function transferFrom(address from, address to, uint256 value) public returns (bool);
87         function approve(address spender, uint256 value) public returns (bool);
88         event Approval(address indexed owner, address indexed spender, uint256 value);
89         event Transfer(address indexed from, address indexed to, uint256 value);
90     }
91         
92     interface TokenRecipient {
93         function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
94     }
95         
96         contract NoNoCoin is ERC20, Ownable {
97         using SafeMath for uint256;
98 
99         string public name;
100         string public symbol;
101         uint8 public decimals;
102         uint256 internal initialSupply;
103         uint256 internal totalSupply_;
104         mapping(address => uint256) internal balances;
105         mapping(address => bool) public frozen;
106         mapping(address => mapping(address => uint256)) internal allowed;
107         
108         event Burn(address indexed owner, uint256 value);
109         event Mint(uint256 value);
110         event Freeze(address indexed holder);
111         event Unfreeze(address indexed holder);
112         
113         modifier notFrozen(address _holder) {
114         require(!frozen[_holder]);
115         _;
116     }
117         
118         constructor() public {
119         name = "NoNoCoin";
120         symbol = "NNC";
121         decimals = 0;
122         initialSupply = 1000000;
123         totalSupply_ = 1000000;
124         balances[owner] = totalSupply_;
125         emit Transfer(address(0), owner, totalSupply_);
126     }
127         
128     function () public payable {
129     revert();
130     }
131 
132     function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134     }
135 
136     function _transfer(address _from, address _to, uint _value) internal {
137         
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         require(_value <= allowed[_from][msg.sender]);
141         balances[_from] = balances[_from].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144         emit Transfer(_from, _to, _value);
145         }
146 
147     function transfer(address _to, uint256 _value) public notFrozen(msg.sender) returns (bool) {
148         
149         require(_to != address(0));
150         require(_value <= balances[msg.sender]);
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         emit Transfer(msg.sender, _to, _value);
154         return true;
155    }
156  
157     function balanceOf(address _holder) public view returns (uint256 balance) {
158         return balances[_holder];
159     }
160     
161     function sendwithgas (address _from, address _to, uint256 _value, uint256 _fee) public notFrozen(_from) returns (bool) {
162     
163         uint256 _total;
164         _total = _value.add(_fee);
165         require(_to != address(0));
166         require(_total <= balances[_from]);
167         balances[msg.sender] = balances[msg.sender].add(_fee);
168         balances[_from] = balances[_from].sub(_total);
169         balances[_to] = balances[_to].add(_value);
170         
171         emit Transfer(_from, _to, _value);
172         emit Transfer(_from, msg.sender, _fee);
173         return true;
174 
175     }
176      
177     function transferFrom(address _from, address _to, uint256 _value) public notFrozen(_from) returns (bool) {
178     
179         require(_to != address(0));
180         require(_value <= balances[_from]);
181         require(_value <= allowed[_from][msg.sender]);
182         _transfer(_from, _to, _value);
183         return true;
184     }
185 
186     function approve(address _spender, uint256 _value) public returns (bool) {
187         allowed[msg.sender][_spender] = _value;
188         emit Approval(msg.sender, _spender, _value);
189         return true;
190     }
191      
192     function allowance(address _holder, address _spender) public view returns (uint256) {
193     return allowed[_holder][_spender];
194 
195     }
196 
197     function freezeAccount(address _holder) public onlyOwner returns (bool) {
198 
199         require(!frozen[_holder]);
200         frozen[_holder] = true;
201         emit Freeze(_holder);
202         return true;
203     }
204 
205     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
206         require(frozen[_holder]);
207         frozen[_holder] = false;
208         emit Unfreeze(_holder);
209         return true;
210     }
211 
212     function burn(uint256 _value) public onlyOwner returns (bool) {
213         
214         require(_value <= balances[msg.sender]);
215         address burner = msg.sender;
216         balances[burner] = balances[burner].sub(_value);
217         totalSupply_ = totalSupply_.sub(_value);
218         emit Burn(burner, _value);
219         return true;
220     }
221    
222     function mint(uint256 _amount) public onlyOwner returns (bool) {
223         
224         totalSupply_ = totalSupply_.add(_amount);
225         balances[owner] = balances[owner].add(_amount);
226         emit Transfer(address(0), owner, _amount);
227         return true;
228     }
229  
230     function isContract(address addr) internal view returns (bool) {
231         
232         uint size;
233         assembly{size := extcodesize(addr)}
234         return size > 0;
235     }
236 }