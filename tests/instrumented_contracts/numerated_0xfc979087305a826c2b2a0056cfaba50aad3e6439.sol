1 pragma solidity ^0.5.16;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19 
20   
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43  
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   
59   constructor (address _owner) public {
60     owner = _owner;
61   }
62 
63   
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 contract BasicToken is ERC20Basic {
79     using SafeMath for uint256;
80     
81     mapping(address => uint256) balances;
82     
83     uint256 _totalSupply;
84     
85     event Transfer(address indexed from, address indexed to, uint256 value);
86      
87     function totalSupply() public view returns (uint256) {
88         return _totalSupply;
89     }
90     
91     /**
92     * @dev transfer token for a specified address
93     * @param _to The address to transfer to.
94     * @param _value The amount to be transferred.
95     */ 
96     function transfer(address _to, uint256 _value) public returns (bool) {
97         
98         require(_to != address(0));
99         require(_value <= balances[msg.sender]);
100     
101         // SafeMath.sub will throw if there is not enough balance.
102         balances[msg.sender] = balances[msg.sender].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107     
108     /**
109     * @dev Gets the balance of the specified address.
110     * @param _owner The address to query the the balance of.
111     * @return An uint256 representing the amount owned by the passed address.
112     */
113     function balanceOf(address _owner) public view returns (uint256 balance) {
114         
115         return balances[_owner];
116     
117     }
118 
119 }
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_from != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     
134     emit Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     
141     require(_spender != address(0));
142     allowed[msg.sender][_spender] = _value;
143     emit Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147 
148   function allowance(address _owner, address _spender) public view returns (uint256) {
149     return allowed[_owner][_spender];
150   }
151 
152   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
153     require(_spender != address(0));
154     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
155     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156     return true;
157   }
158 
159 
160   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
161     require(_spender != address(0));
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172 }
173 
174 contract DAFIToken is StandardToken, Ownable
175 {
176     
177     string constant _name = "DAFI Token";
178     string constant _symbol = "DAFI";
179     uint256 constant _decimals = 18;
180 
181     uint256 public maxSupply;
182     
183     event Transfer(address indexed from, address indexed to, uint256 value);
184     
185     constructor() public Ownable(msg.sender){ 
186         
187        maxSupply = 2250000000 * 10 ** _decimals;
188 
189     }
190     
191     function mint(uint256 _value, address _beneficiary)  external onlyOwner{
192 
193         require(_beneficiary != address(0));
194         require(_value > 0);
195         require(_value.add(_totalSupply) <= maxSupply,"Minting amount exceeding max limit");
196         balances[_beneficiary] = balances[_beneficiary].add(_value);
197         _totalSupply = _totalSupply.add(_value);
198         
199         emit Transfer(address(0), _beneficiary, _value);
200         
201     }
202     
203     function burn(uint256 _value, address _beneficiary)  external onlyOwner {
204 
205         require(_beneficiary != address(0));
206         require(balanceOf(_beneficiary) >= _value,"User does not have sufficient tokens to burn");
207         _totalSupply = _totalSupply.sub(_value);
208         balances[_beneficiary] = balances[_beneficiary].sub(_value);
209         
210         emit Transfer(_beneficiary, address(0), _value);
211     }
212     
213     function name() public pure returns (string memory) {
214         return _name;
215     }
216 
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
232      * called.
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public pure returns (uint256) {
239         return _decimals;
240     }
241 }