1 pragma solidity 0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract ERC20Basic {
86   function totalSupply() public view returns (uint256);
87   function balanceOf(address who) public view returns (uint256);
88   function transfer(address to, uint256 value) public returns (bool);
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 }
91 
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 contract TokenERC20 is ERC20, Ownable {
100     using SafeMath for uint;
101 
102     string public name;
103     string public symbol;
104     uint8 public decimals;
105     uint256 public totalSupply_;
106     mapping(address => uint256) public balances;
107     mapping(address => mapping(address => uint256)) internal allowed;
108 
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110     event Burn(address indexed holder, uint256 tokens);
111 
112     function TokenERC20(
113         string _name,
114         string _symbol,
115         uint8 _decimals,
116         address _supplyReceiver,
117         uint256 _initialSupply
118     ) public {
119         name = _name;
120         symbol = _symbol;
121         decimals = _decimals;
122         totalSupply_ = _initialSupply;
123 
124         balances[_supplyReceiver] = totalSupply_;
125 
126         Transfer(0, _supplyReceiver, totalSupply_);
127     }
128 
129     function totalSupply() public view returns (uint256) {
130         return totalSupply_;
131     }
132 
133     function transfer(address _to, uint256 _value) public returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136 
137         // SafeMath.sub will throw if there is not enough balance.
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     function balanceOf(address _owner) public view returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149         require(_to != address(0));
150         require(_value <= balances[_from]);
151         require(_value <= allowed[_from][msg.sender]);
152 
153         balances[_from] = balances[_from].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     function approve(address _spender, uint256 _value) public returns (bool) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     function allowance(address _owner, address _spender) public view returns (uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170     function burn(uint256 _amount) public returns (bool) {
171         require(balances[msg.sender] >= _amount);
172 
173         balances[msg.sender] = balances[msg.sender].sub(_amount);
174         totalSupply_ = totalSupply_.sub(_amount);
175 
176         Burn(msg.sender, _amount);
177         Transfer(msg.sender, address(0), _amount);
178     }
179 }