1 pragma solidity 0.4.24;
2 library SafeMath {
3  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5         return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10     }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31   event OwnershipRenounced(address indexed previousOwner);
32   event OwnershipTransferred(
33     address indexed previousOwner,
34     address indexed newOwner
35   );
36 
37   constructor() public {
38     owner = msg.sender;
39   }
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44   function transferOwnership(address _newOwner) public onlyOwner {
45     require(_newOwner != address(0));
46     emit OwnershipTransferred(owner, _newOwner);
47     owner = _newOwner;
48   }
49 }
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53   bool public paused = false;
54 
55   modifier whenNotPaused() {
56     require(!paused);
57     _;
58   }
59 
60   modifier whenPaused() {
61     require(paused);
62     _;
63   }
64 
65   function pause() onlyOwner whenNotPaused public {
66     paused = true;
67     emit Pause();
68   }
69 
70   function unpause() onlyOwner whenPaused public {
71     paused = false;
72     emit Unpause();
73   }
74 }
75 
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address who) public view returns (uint256);
79   function transfer(address to, uint256 value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public view returns (uint256);
84 
85   function transferFrom(address from, address to, uint256 value) public returns (bool);
86 
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(
89     address indexed owner,
90     address indexed spender,
91     uint256 value
92   );
93 }
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96   mapping(address => uint256) balances;
97   uint256 totalSupply_;
98 
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   function balanceOf(address _owner) public view returns (uint256) {
114     return balances[_owner];
115   }
116 }
117 
118 contract StandardToken is ERC20, BasicToken {
119 
120     function transfer(address _to, uint256 _value) public returns (bool success) {
121         require(msg.data.length >= (2 * 32) + 4);
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124 
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         emit Transfer(msg.sender, _to, _value);
128         return true;
129 
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136 
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function balanceOf(address _owner) view public returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         require(msg.data.length >= (2 * 32) + 4);
150         require(_value == 0 || allowed[msg.sender][_spender] == 0);
151         allowed[msg.sender][_spender] = _value;
152         emit Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
157       return allowed[_owner][_spender];
158     }
159 
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169         allowed[msg.sender][_spender] = 0;
170     } else {
171         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175    }
176 
177 
178     mapping (address => uint256) public balances;
179     mapping (address => mapping (address => uint256)) public allowed;
180 }
181 
182 contract PausableToken is StandardToken, Pausable {
183   function transfer(address _to,uint256 _value) public whenNotPaused returns (bool) {
184     return super.transfer(_to, _value);
185   }
186   function transferFrom(address _from,address _to,uint256 _value)public whenNotPaused returns (bool)  {
187     return super.transferFrom(_from, _to, _value);
188   }
189   function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){
190     return super.approve(_spender, _value);
191   }
192   function increaseApproval(address _spender,uint _addedValue) public whenNotPaused returns (bool success){
193     return super.increaseApproval(_spender, _addedValue);
194   }
195   function decreaseApproval(address _spender,uint _subtractedValue) public whenNotPaused returns (bool success) {
196     return super.decreaseApproval(_spender, _subtractedValue);
197   }
198 }
199 
200 contract HumanStandardToken is PausableToken {
201 
202     function () public {
203         revert();
204     }
205     string public name;
206     uint8 public decimals;
207     string public symbol; 
208     string public version = '1.0';
209 
210     constructor (uint256 _initialAmount, string _tokenName,uint8 _decimalUnits, string _tokenSymbol) internal {
211         totalSupply_ = _initialAmount;
212         balances[msg.sender] = totalSupply_;
213         name = _tokenName;
214         decimals = _decimalUnits;
215         symbol = _tokenSymbol;
216     }
217 
218     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
219         allowed[msg.sender][_spender] = _value;
220         emit Approval(msg.sender, _spender, _value);
221         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
222         return true;
223     }
224 }
225 
226 contract DVPToken is HumanStandardToken(5000000000*(10**18),"Decentralized Vulnerability Platform",18,"DVP") {}