1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14 
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 
28 }
29 
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35   
36 }
37 
38 contract BasicToken is ERC20Basic, Ownable {
39 
40     using SafeMath for uint256;
41     mapping(address => uint256) balances;
42 
43     bool public transfersEnabledFlag;
44 
45 
46     modifier transfersEnabled() {
47         require(transfersEnabledFlag);
48         _;
49     }
50 
51     function enableTransfers() public onlyOwner {
52         transfersEnabledFlag = true;
53     }
54 
55 
56     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[msg.sender]);
59 
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66 
67     function balanceOf(address _owner) public view returns (uint256 balance) {
68         return balances[_owner];
69     }
70 }
71 
72 
73 
74 
75 
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0;
80     }
81     uint256 c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a / b;
88     return c;
89   }
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113     mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[_from]);
120         require(_value <= allowed[_from][msg.sender]);
121 
122         balances[_from] = balances[_from].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125         Transfer(_from, _to, _value);
126         return true;
127     }
128 
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136 
137     function allowance(address _owner, address _spender) public view returns (uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
142         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 
147     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         }
152         else {
153             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154         }
155         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156         return true;
157     }
158 
159 }
160 
161 contract MintableToken is StandardToken {
162     event Mint(address indexed to, uint256 amount);
163 
164     event MintFinished();
165 
166     bool public mintingFinished = false;
167 
168     mapping(address => bool) public minters;
169 
170     modifier canMint() {
171         require(!mintingFinished);
172         _;
173     }
174     modifier onlyMinters() {
175         require(minters[msg.sender] || msg.sender == owner);
176         _;
177     }
178     function addMinter(address _addr) public onlyOwner {
179         minters[_addr] = true;
180     }
181 
182     function deleteMinter(address _addr) public onlyOwner {
183         delete minters[_addr];
184     }
185 
186 
187     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
188         require(_to != address(0));
189         totalSupply = totalSupply.add(_amount);
190         balances[_to] = balances[_to].add(_amount);
191         Mint(_to, _amount);
192         Transfer(address(0), _to, _amount);
193         return true;
194     }
195 
196     function finishMinting() onlyOwner canMint public returns (bool) {
197         mintingFinished = true;
198         MintFinished();
199         return true;
200     }
201 }
202 
203 
204 
205 contract CappedToken is MintableToken {
206 
207     uint256 public cap;
208 
209     function CappedToken(uint256 _cap) public {
210         require(_cap > 0);
211         cap = _cap;
212     }
213 
214 
215     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
216         require(totalSupply.add(_amount) <= cap);
217 
218         return super.mint(_to, _amount);
219     }
220 
221 }
222 
223 
224 contract ParameterizedToken is CappedToken {
225     string public name;
226 
227     string public symbol;
228 
229     uint256 public decimals;
230 
231     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
232         name = _name;
233         symbol = _symbol;
234         decimals = _decimals;
235     }
236 
237 }
238 
239 contract KUYCToken is ParameterizedToken {
240 
241     function KUYCToken() public ParameterizedToken("KUYC", "KUYC", 18, 1000000000) {
242     }
243 
244 }