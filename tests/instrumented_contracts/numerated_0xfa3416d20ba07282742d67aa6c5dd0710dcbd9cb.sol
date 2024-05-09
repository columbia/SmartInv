1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
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
85 
86 contract ERC20 {
87     function totalSupply() public view returns (uint256);
88     function balanceOf(address who) public view returns (uint256);
89     function allowance(address owner, address spender) public view returns (uint256);
90     function transfer(address to, uint256 value) public returns (bool);
91     function transferFrom(address from, address to, uint256 value) public returns (bool);
92     function approve(address spender, uint256 value) public returns (bool);
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 contract FeneroToken is ERC20, Ownable {
99 
100     using SafeMath for uint256;
101 
102     string public name;
103     string public symbol;
104     uint8 public decimals;
105     uint256 initialSupply;
106     uint256 totalSupply_;
107 
108     mapping(address => uint256) balances;
109     mapping(address => mapping(address => uint256)) internal allowed;
110 
111     function FeneroToken() public {
112         name = "Fenero";
113         symbol = "FEN";
114         decimals = 18;        
115         initialSupply = 1000000000000;
116         totalSupply_ = initialSupply * 10 ** uint(decimals);
117         balances[owner] = totalSupply_;
118         Transfer(address(0), owner, totalSupply_);
119     }
120 
121     function totalSupply() public view returns (uint256) {
122         return totalSupply_;
123     }
124 
125     function transfer(address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[msg.sender]);
128 
129         // SafeMath.sub will throw if there is not enough balance.
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     function balanceOf(address _owner) public view returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144 
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         require(_value > 0);
154         allowed[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     function () public payable {
164         revert();
165     }
166 
167     function mint( uint256 _amount) onlyOwner public returns (bool) {
168         totalSupply_ = totalSupply_.add(_amount);
169         balances[owner] = balances[owner].add(_amount);
170 
171         Transfer(address(0), owner, _amount);
172         return true;
173     }
174 }