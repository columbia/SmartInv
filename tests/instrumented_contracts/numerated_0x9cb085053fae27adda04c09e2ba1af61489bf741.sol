1 pragma solidity 0.5.7;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     /**
20      * @dev Multiplies two numbers, throws on overflow.
21      */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30     /**
31      * @dev Integer division of two numbers, truncating the quotient.
32      */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39     /**
40      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46     /**
47      * @dev Adds two numbers, throws on overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * account.
63      */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      */
79     function transferOwnership(address _newOwner) public onlyOwner {
80         _transferOwnership(_newOwner);
81     }
82 
83     /**
84      * @dev Transfers control of the contract to a newOwner.
85      */
86     function _transferOwnership(address _newOwner) internal {
87         require(_newOwner != address(0));
88         emit OwnershipTransferred(owner, _newOwner);
89         owner = _newOwner;
90     }
91 }
92 /**
93  * @title Basic token
94  */
95 contract BasicToken is ERC20Basic, Ownable {
96     using SafeMath for uint256;
97     mapping(address => uint256) balances;
98     uint256 totalSupply_;
99 
100     /**
101      * @dev total number of tokens in existence
102      */
103     function totalSupply() public view returns (uint256) {
104         return totalSupply_;
105     }
106 
107     /**
108      */
109     function transfer(address _to, uint256 _value) public returns (bool) {
110         if (_to == address(0)) {
111             totalSupply_ = totalSupply_.sub(_value);
112         }
113 
114         require(_value <= balances[msg.sender]);
115         // SafeMath.sub will throw if there is not enough balance.
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         emit Transfer(msg.sender, _to, _value);
119         return true;
120     }
121     /**
122      */
123     function balanceOf(address _owner) public view returns (uint256) {
124         return balances[_owner];
125     }
126 }
127 /**
128  * @title ERC20 interface
129  */
130 contract ERC20 is ERC20Basic {
131     function allowance(address owner, address spender) public view returns (uint256);
132     function transferFrom(address from, address to, uint256 value) public returns (bool);
133     function approve(address spender, uint256 value) public returns (bool);
134     event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 /**
137  * @title Standard ERC20 token
138  *
139  */
140 contract StandardToken is ERC20, BasicToken {
141     uint public constant MAX_UINT = 2**256 - 1;
142 
143     mapping (address => mapping (address => uint256)) internal allowed;
144 
145     /**
146      */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148         if (_to == address(0)) {
149             totalSupply_ = totalSupply_.sub(_value);
150         }
151 
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154         balances[_from] = balances[_from].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156 
157         /// an allowance of MAX_UINT represents an unlimited allowance.
158         /// @dev see https://github.com/ethereum/EIPs/issues/717
159         if (allowed[_from][msg.sender] < MAX_UINT) {
160             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         }
162         emit Transfer(_from, _to, _value);
163         return true;
164     }
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      */
168     function approve(address _spender, uint256 _value) public returns (bool) {
169         allowed[msg.sender][_spender] = _value;
170         emit Approval(msg.sender, _spender, _value);
171         return true;
172     }
173     /**
174      */
175     function allowance(address _owner, address _spender) public view returns (uint256) {
176         return allowed[_owner][_spender];
177     }
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      */
181     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
182         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184         return true;
185     }
186     /**
187      * @dev Decrease the amount of tokens that an owner allowed to a spender.
188      */
189     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 }
200 
201 contract SatowalletShares is StandardToken {
202     using SafeMath for uint256;
203 
204     string     public name = "Satowallet Shares";
205     string     public symbol = "SATOS";
206     uint8      public decimals = 8;
207     uint256    private constant initialSupply = 10000000;
208 
209     constructor() public {
210         totalSupply_ = initialSupply * 10 ** uint256(decimals);
211         balances[0x1800D1901880cd5615C8c91A1DdEc4853b852adE] = totalSupply_;
212         emit Transfer(address(0), 0x1800D1901880cd5615C8c91A1DdEc4853b852adE, totalSupply_);
213     }
214 
215     function () payable external {
216         revert();
217     }
218 
219 }