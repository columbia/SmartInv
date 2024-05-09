1 pragma solidity ^0.5.6;
2 
3 
4 // XNE: safe math for arithmetic operation
5 library SafeMath {
6  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8         return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13     }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
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
32 contract Ownable {
33   address public owner;
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40   constructor() public {
41     owner = msg.sender;
42   }
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47   function transferOwnership(address _newOwner) public onlyOwner {
48     require(_newOwner != address(0));
49     emit OwnershipTransferred(owner, _newOwner);
50     owner = _newOwner;
51   }
52 }
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56   bool public paused = false;
57 
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   modifier whenPaused() {
64     require(paused);
65     _;
66   }
67 
68   function pause() onlyOwner whenNotPaused public {
69     paused = true;
70     emit Pause();
71   }
72 
73   function unpause() onlyOwner whenPaused public {
74     paused = false;
75     emit Unpause();
76   }
77 }
78 
79 contract ERC20Basic {
80   function totalSupply() public view returns (uint256);
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87 
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89 
90   function approve(address spender, uint256 value) public returns (bool);
91   event Approval(
92     address indexed owner,
93     address indexed spender,
94     uint256 value
95   );
96 }
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99   mapping(address => uint256) balances;
100   uint256 totalSupply_;
101 
102   function totalSupply() public view returns (uint256) {
103     return totalSupply_;
104   }
105 
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 }
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123     function transfer(address _to, uint256 _value) public returns (bool success) {
124         require(msg.data.length >= (2 * 32) + 4);
125         require(_to != address(0));
126         require(_value <= balances[msg.sender]);
127 
128         balances[msg.sender] = balances[msg.sender].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         emit Transfer(msg.sender, _to, _value);
131         return true;
132 
133     }
134 
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         require(_to != address(0));
137         require(_value <= balances[_from]);
138         require(_value <= allowed[_from][msg.sender]);
139 
140         balances[_from] = balances[_from].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143         emit Transfer(_from, _to, _value);
144         return true;
145     }
146 
147     function balanceOf(address _owner) view public returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151     function approve(address _spender, uint256 _value) public returns (bool success) {
152         require(msg.data.length >= (2 * 32) + 4);
153         require(_value == 0 || allowed[msg.sender][_spender] == 0);
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
160       return allowed[_owner][_spender];
161     }
162 
163   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170     uint oldValue = allowed[msg.sender][_spender];
171     if (_subtractedValue > oldValue) {
172         allowed[msg.sender][_spender] = 0;
173     } else {
174         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175     }
176     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178    }
179 
180 
181     mapping (address => uint256) public balances;
182     mapping (address => mapping (address => uint256)) public allowed;
183 }
184 
185 contract PausableToken is StandardToken, Pausable {
186   function transfer(address _to,uint256 _value) public whenNotPaused returns (bool) {
187     return super.transfer(_to, _value);
188   }
189   function transferFrom(address _from,address _to,uint256 _value)public whenNotPaused returns (bool)  {
190     return super.transferFrom(_from, _to, _value);
191   }
192   function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){
193     return super.approve(_spender, _value);
194   }
195   function increaseApproval(address _spender,uint _addedValue) public whenNotPaused returns (bool success){
196     return super.increaseApproval(_spender, _addedValue);
197   }
198   function decreaseApproval(address _spender,uint _subtractedValue) public whenNotPaused returns (bool success) {
199     return super.decreaseApproval(_spender, _subtractedValue);
200   }
201 }
202 
203 contract HumanStandardToken is PausableToken {
204 
205     function () external {
206         revert();
207     }
208     string public name;
209     uint8 public decimals;
210     string public symbol; 
211     // XNE: token version 
212     string public version = '2.0';
213 
214     constructor (uint256 _initialAmount, string memory _tokenName,uint8 _decimalUnits, string memory _tokenSymbol) internal {
215         totalSupply_ = _initialAmount;
216         balances[msg.sender] = totalSupply_;
217         name = _tokenName;
218         decimals = _decimalUnits;
219         symbol = _tokenSymbol;
220     }
221 
222 }
223 
224 contract XNEToken is HumanStandardToken(8000000000*(10**18),"Xiuyi Distributed Network",18,"XNE") {}