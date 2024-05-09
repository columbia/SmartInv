1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function balanceOf(address who) public constant returns (uint256);
5     function transfer(address to, uint256 value) public returns (bool);
6     function allowance(address owner, address spender) public constant returns (uint256);
7     function transferFrom(address from, address to, uint256 value) public returns (bool);
8     function approve(address spender, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 contract Ownable {
14   address public owner;
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18   function Ownable() public{
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   function transferOwnership(address newOwner) onlyOwner public {
28     require(newOwner != address(0));
29     OwnershipTransferred(owner, newOwner);
30     owner = newOwner;
31   }
32 
33 }
34 
35 contract HasNoTokens is Ownable {
36     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
37 
38     function extractTokens(address _token, address _claimer) onlyOwner public {
39         if (_token == 0x0) {
40             _claimer.transfer(this.balance);
41             return;
42         }
43 
44         ERC20 token = ERC20(_token);
45         uint balance = token.balanceOf(this);
46         token.transfer(_claimer, balance);
47         ExtractedTokens(_token, _claimer, balance);
48     }
49 }
50 
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a / b;
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 contract Token {
76     function totalSupply () view public returns (uint256 supply);
77     function balanceOf (address _owner) view public returns (uint256 balance);
78     function transfer (address _to, uint256 _value) public returns (bool success);
79     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success);
80     function approve (address _spender, uint256 _value) public returns (bool success);
81     function allowance (address _owner, address _spender) view public returns (uint256 remaining);
82 
83     event Transfer (address indexed _from, address indexed _to, uint256 _value);
84     event Approval (address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 
87 contract AbstractToken is Token {
88     using SafeMath for uint;
89 
90     function AbstractToken () public payable{
91         
92     }
93 
94     function balanceOf (address _owner) view public returns (uint256 balance) {
95         return accounts[_owner];
96     }
97 
98     function transfer (address _to, uint256 _value) public returns (bool success) {
99         uint256 fromBalance = accounts[msg.sender];
100         if (fromBalance < _value) return false;
101         if (_value > 0 && msg.sender != _to) {
102             accounts[msg.sender] = fromBalance.sub(_value);
103             accounts[_to] = accounts[_to].add(_value);
104             Transfer(msg.sender, _to, _value);
105         }
106         return true;
107     }
108 
109     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
110         uint256 spenderAllowance = allowances[_from][msg.sender];
111         if (spenderAllowance < _value) return false;
112         uint256 fromBalance = accounts[_from];
113         if (fromBalance < _value) return false;
114 
115         allowances[_from][msg.sender] = spenderAllowance.sub(_value);
116 
117         if (_value > 0 && _from != _to) {
118             accounts[_from] = fromBalance.sub(_value);
119             accounts[_to] = accounts[_to].add(_value);
120             Transfer(_from, _to, _value);
121         }
122         return true;
123     }
124 
125     function approve (address _spender, uint256 _value) public returns (bool success) {
126         allowances[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128 
129         return true;
130     }
131 
132     function allowance (address _owner, address _spender) view public returns (uint256 remaining) {
133         return allowances[_owner][_spender];
134     }
135 
136     mapping (address => uint256) accounts;
137 
138     mapping (address => mapping (address => uint256)) private allowances;
139 }
140 
141 contract AbstractVirtualToken is AbstractToken {
142     using SafeMath for uint;
143 
144     uint256 constant MAXIMUM_TOKENS_COUNT = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
145 
146     uint256 constant BALANCE_MASK = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
147 
148     uint256 constant MATERIALIZED_FLAG_MASK = 0x8000000000000000000000000000000000000000000000000000000000000000;
149 
150     function AbstractVirtualToken () public{
151         
152     }
153 
154     function totalSupply () view public returns (uint256 supply) {
155         return tokensCount;
156     }
157 
158     function balanceOf (address _owner) constant public returns (uint256 balance) { 
159         return (accounts[_owner] & BALANCE_MASK).add(getVirtualBalance(_owner));
160     }
161 
162     function transfer (address _to, uint256 _value) public returns (bool success) {
163         if (_value > balanceOf(msg.sender)) return false;
164         else {
165             materializeBalanceIfNeeded(msg.sender, _value);
166             return AbstractToken.transfer(_to, _value);
167         }
168     }
169 
170     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
171         if (_value > allowance(_from, msg.sender)) return false;
172         if (_value > balanceOf(_from)) return false;
173         else {
174             materializeBalanceIfNeeded(_from, _value);
175             return AbstractToken.transferFrom(_from, _to, _value);
176         }
177     }
178 
179     function virtualBalanceOf (address _owner) internal view returns (uint256 _virtualBalance);
180 
181     function getVirtualBalance (address _owner) private view returns (uint256 _virtualBalance) {
182         if (accounts [_owner] & MATERIALIZED_FLAG_MASK != 0) return 0;
183         else {
184             _virtualBalance = virtualBalanceOf(_owner);
185             uint256 maxVirtualBalance = MAXIMUM_TOKENS_COUNT.sub(tokensCount);
186             if (_virtualBalance > maxVirtualBalance)
187                 _virtualBalance = maxVirtualBalance;
188         }
189     }
190 
191     function materializeBalanceIfNeeded (address _owner, uint256 _value) private {
192         uint256 storedBalance = accounts[_owner];
193         if (storedBalance & MATERIALIZED_FLAG_MASK == 0) {
194             if (_value > storedBalance) {
195                 uint256 virtualBalance = getVirtualBalance(_owner);
196                 require (_value.sub(storedBalance) <= virtualBalance);
197                 accounts[_owner] = MATERIALIZED_FLAG_MASK | storedBalance.add(virtualBalance);
198                 tokensCount = tokensCount.add(virtualBalance);
199             }
200         }
201     }
202 
203     uint256 tokensCount;
204 }
205 
206 contract PornLoversToken is HasNoTokens, AbstractVirtualToken {
207     
208     uint256 private constant VIRTUAL_THRESHOLD = 0.1 ether;
209     uint256 private constant VIRTUAL_COUNT = 91;
210 
211     event LogBonusSet(address indexed _address, uint256 _amount);
212 
213     function virtualBalanceOf(address _owner) internal view returns (uint256) {
214         return _owner.balance >= VIRTUAL_THRESHOLD ? VIRTUAL_COUNT : 0;
215     }
216 
217     function name() public pure returns (string result) {
218         return "91porn.com";
219     }
220 
221     function symbol() public pure returns (string result) {
222         return "91porn";
223     }
224 
225     function decimals() public pure returns (uint8 result) {
226         return 0;
227     }
228 
229     function transfer(address _to, uint256 _value) public returns (bool) {
230         bool success = super.transfer(_to, _value); 
231         return success;
232     }
233 
234     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235         bool success = super.transferFrom(_from, _to, _value);
236 
237         return success;
238     }
239 
240     function massNotify(address[] _owners) public onlyOwner {
241         for (uint256 i = 0; i < _owners.length; i++) {
242             Transfer(address(0), _owners[i], VIRTUAL_COUNT);
243         }
244     }
245 
246     function kill() public onlyOwner {
247         selfdestruct(owner);
248     }
249 }