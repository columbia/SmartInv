1 pragma solidity ^0.4.8;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16 
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     return a / b;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   uint256 totalSupply_;
44 
45   function totalSupply() public view returns (uint256) {
46     return totalSupply_;
47   }
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns (uint256) {
60     return balances[_owner];
61   }
62 
63 }
64 
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender)
67     public view returns (uint256);
68 
69   function transferFrom(address from, address to, uint256 value)
70     public returns (bool);
71 
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(
74     address indexed owner,
75     address indexed spender,
76     uint256 value
77   );
78 }
79 
80 contract StandardToken is ERC20, BasicToken {
81 
82   mapping (address => mapping (address => uint256)) internal allowed;
83 
84 
85   function transferFrom(
86     address _from,
87     address _to,
88     uint256 _value
89   )
90     public
91     returns (bool)
92   {
93     require(_to != address(0));
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96 
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100     emit Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   function approve(address _spender, uint256 _value) public returns (bool) {
105     allowed[msg.sender][_spender] = _value;
106     emit Approval(msg.sender, _spender, _value);
107     return true;
108   }
109 
110   function allowance(
111     address _owner,
112     address _spender
113    )
114     public
115     view
116     returns (uint256)
117   {
118     return allowed[_owner][_spender];
119   }
120 
121   function increaseApproval(
122     address _spender,
123     uint _addedValue
124   )
125     public
126     returns (bool)
127   {
128     allowed[msg.sender][_spender] = (
129       allowed[msg.sender][_spender].add(_addedValue));
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   function decreaseApproval(
135     address _spender,
136     uint _subtractedValue
137   )
138     public
139     returns (bool)
140   {
141     uint oldValue = allowed[msg.sender][_spender];
142     if (_subtractedValue > oldValue) {
143       allowed[msg.sender][_spender] = 0;
144     } else {
145       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146     }
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151 }
152 
153  contract BurnableToken is StandardToken {
154 
155    event Burn(address indexed burner, uint256 value);
156 
157    function burn(uint256 _value) public {
158      _burn(msg.sender, _value);
159    }
160 
161    function _burn(address _who, uint256 _value) internal {
162      require(_value <= balances[_who]);
163 
164      balances[_who] = balances[_who].sub(_value);
165      totalSupply_ = totalSupply_.sub(_value);
166      emit Burn(_who, _value);
167      emit Transfer(_who, address(0), _value);
168    }
169  }
170 
171  contract Ownable {
172    address public owner;
173 
174    event OwnershipRenounced(address indexed previousOwner);
175    event OwnershipTransferred(
176      address indexed previousOwner,
177      address indexed newOwner
178    );
179 
180    constructor() public {
181      owner = msg.sender;
182    }
183 
184    modifier onlyOwner() {
185      require(msg.sender == owner);
186      _;
187    }
188 
189    function renounceOwnership() public onlyOwner {
190      emit OwnershipRenounced(owner);
191      owner = address(0);
192    }
193 
194    function transferOwnership(address _newOwner) public onlyOwner {
195      _transferOwnership(_newOwner);
196    }
197 
198    function _transferOwnership(address _newOwner) internal {
199      require(_newOwner != address(0));
200      emit OwnershipTransferred(owner, _newOwner);
201      owner = _newOwner;
202    }
203  }
204 
205  contract MintableToken is StandardToken, Ownable {
206    event Mint(address indexed to, uint256 amount);
207    event MintFinished();
208 
209    bool public mintingFinished = false;
210 
211 
212    modifier canMint() {
213      require(!mintingFinished);
214      _;
215    }
216 
217    modifier hasMintPermission() {
218      require(msg.sender == owner);
219      _;
220    }
221 
222    function mint(
223      address _to,
224      uint256 _amount
225    )
226      hasMintPermission
227      canMint
228      public
229      returns (bool)
230    {
231      totalSupply_ = totalSupply_.add(_amount);
232      balances[_to] = balances[_to].add(_amount);
233      emit Mint(_to, _amount);
234      emit Transfer(address(0), _to, _amount);
235      return true;
236    }
237 
238    function finishMinting() onlyOwner canMint public returns (bool) {
239      mintingFinished = true;
240      emit MintFinished();
241      return true;
242    }
243  }
244 
245 
246 contract YINC is BurnableToken, MintableToken {
247   string public name = "YINC (盈链)";
248   string public symbol = "YINC";
249   uint public decimals = 6;
250   uint public INITIAL_SUPPLY = 300000000 * (10 ** decimals);
251 
252   constructor() public {
253     totalSupply_ = INITIAL_SUPPLY;
254     balances[msg.sender] = INITIAL_SUPPLY;
255   }
256 }