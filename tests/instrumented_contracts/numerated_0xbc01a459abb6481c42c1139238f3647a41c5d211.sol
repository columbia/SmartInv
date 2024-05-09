1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
38 /**
39  * @title ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/20
41  */
42 contract ERC20 {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);   
47     
48   function allowance(address owner, address spender)
49     public view returns (uint256);
50 
51   function transferFrom(address from, address to, uint256 value)
52     public returns (bool);
53 
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(
56     address indexed owner,
57     address indexed spender,
58     uint256 value
59   );
60 }
61 
62 contract BasicToken is ERC20 {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   uint256 totalSupply_;
68 
69   function totalSupply() public view returns (uint256) {
70     return totalSupply_;
71   }
72 
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   function balanceOf(address _owner) public view returns (uint256) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/issues/20
94  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) internal allowed;
99 
100   function transferFrom(
101     address _from,
102     address _to,
103     uint256 _value
104   )
105     public
106     returns (bool)
107   {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function approve(address _spender, uint256 _value) public returns (bool) {
120     allowed[msg.sender][_spender] = _value;
121     emit Approval(msg.sender, _spender, _value);
122     return true;
123   }
124 
125   function allowance(
126     address _owner,
127     address _spender
128    )
129     public
130     view
131     returns (uint256)
132   {
133     return allowed[_owner][_spender];
134   }
135 
136   function increaseApproval(
137     address _spender,
138     uint256 _addedValue
139   )
140     public
141     returns (bool)
142   {
143     allowed[msg.sender][_spender] = (
144       allowed[msg.sender][_spender].add(_addedValue));
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 
149   function decreaseApproval(
150     address _spender,
151     uint256 _subtractedValue
152   )
153     public
154     returns (bool)
155   {
156     uint256 oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166 }
167 
168 /**
169  * @title ShopCorn Token
170 */
171 contract ShopCornToken is StandardToken {
172 
173   string public constant name = "ShopCornToken";
174   string public constant symbol = "SHC";           
175   uint8 public constant decimals = 8;
176 
177   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
178 
179   /**
180    * @dev Constructor that gives msg.sender all of existing tokens.
181    */
182   constructor() public {
183     totalSupply_ = INITIAL_SUPPLY;
184     balances[msg.sender] = INITIAL_SUPPLY;
185     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
186   }
187 
188 }