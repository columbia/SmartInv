1 // Solydity version
2 pragma solidity ^0.4.11;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52     address public owner;
53     address public icoOwner;
54     address public burnerOwner;
55 
56     function Ownable() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner() {
61         require(msg.sender == owner || msg.sender == icoOwner);
62         _;
63     }
64 
65     modifier onlyBurner() {
66       require(msg.sender == owner || msg.sender == burnerOwner);
67       _;
68     }
69 
70 }
71 
72 contract ERC20Interface {
73     function totalSupply() public view returns (uint256);
74     function balanceOf(address who) public view returns (uint256);
75     function transfer(address to, uint256 value) public;
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     
78     function allowance(address owner, address spender) public view returns (uint256);
79     function transferFrom(address from, address to, uint256 value) public;
80     function approve(address spender, uint256 value) public returns (bool);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // initialization contract
85 contract StepCoin is ERC20Interface, Ownable{
86 
87     using SafeMath for uint256;
88 
89     string public constant name = "StepCoin";
90 
91     string public constant symbol = "STEP";
92 
93     uint8 public constant decimals = 3;
94 
95     uint256 totalSupply_;
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping (address => uint256)) internal allowed;
99      
100     event Burn(address indexed burner, uint256 value);
101 
102     // Function initialization of contract
103     function StepCoin() {
104 
105         totalSupply_ = 100000000 * (10 ** uint256(decimals));
106 
107         balances[msg.sender] = totalSupply_;
108     }
109 
110     function totalSupply() public view returns (uint256) {
111         return totalSupply_;
112     }
113     
114     function balanceOf(address _owner) public view returns (uint256) {
115         return balances[_owner];
116     }
117     
118     function transfer(address _to, uint256 _value) public {
119         _transfer(msg.sender, _to, _value);
120     }
121     
122     function allowance(address _owner, address _spender) public view returns (uint256) {
123         return allowed[_owner][_spender];
124     }
125     
126     function transferFrom(address _from, address _to, uint256 _value) public {
127         require(_value <= allowed[_from][msg.sender]);
128         
129         allowed[_from][_to] = allowed[_from][msg.sender].sub(_value);
130         
131         _transfer(_from, _to, _value);
132     }
133     
134     function _transfer(address _from, address _to, uint256 _value) internal returns (bool){
135         require(_to != 0x0);
136         require(_value <= balances[_from]);
137         require(balances[_to].add(_value) >= balances[_to]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141 
142         Transfer(_from, _to, _value);
143         return true;
144     }
145     
146     function approve(address _spender, uint256 _value) public returns (bool) {
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151     
152     function transferOwner(address _from, address _to, uint256 _value) onlyOwner public {
153         _transfer(_from, _to, _value);
154     }
155 
156     function setIcoOwner(address _addressIcoOwner) onlyOwner external {
157         icoOwner = _addressIcoOwner;
158     }
159 
160     function burn(uint256 _value) onlyOwner onlyBurner public {
161       _burn(msg.sender, _value);
162     }
163 
164     function _burn(address _who, uint256 _value) onlyOwner onlyBurner internal {
165       require(_value <= balances[_who]);
166 
167       balances[_who] = balances[_who].sub(_value);
168       totalSupply_ = totalSupply_.sub(_value);
169       Burn(_who, _value);
170       Transfer(_who, address(0), _value);
171   }
172 
173     function setBurnerOwner(address _addressBurnerOwner) onlyOwner external {
174         burnerOwner = _addressBurnerOwner;
175     }
176 }