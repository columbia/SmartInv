1 pragma solidity ^0.4.24;
2 
3 
4 
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53   /**
54   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55   * account.
56   */
57   constructor() public {
58     owner = msg.sender;
59   }
60   /**
61   * @dev Throws if called by any account other than the owner.
62   */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 }
69 
70 contract iHOME is Ownable {
71   using SafeMath for uint256;
72 
73   event Transfer(address indexed from,address indexed to,uint256 _tokenId);
74   event Approval(address indexed owner,address indexed approved,uint256 _tokenId);
75 
76 
77 
78   string public constant symbol = "iHOME";
79   string public constant name = "iHOME Credits";
80   uint8 public decimals = 18;
81 
82   uint256 public totalSupply = 1000000000000 * 10 ** uint256(decimals);
83 
84 
85   mapping(address => uint256) balances;
86   mapping(address => mapping (address => uint256)) allowed;
87 
88 
89 
90 
91 
92   function balanceOf(address _owner) public constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 
97   constructor() public {
98     balances[msg.sender] = totalSupply;
99   }
100 
101 
102   function approve(address _spender, uint256 _amount) public returns (bool success) {
103     allowed[msg.sender][_spender] = _amount;
104     emit   Approval(msg.sender, _spender, _amount);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender ) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 
112 
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_value <= balances[msg.sender]);
115     require(_to != address(0));
116 
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
124   {
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127     require(_to != address(0));
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
137     allowed[msg.sender][_spender] = (
138       allowed[msg.sender][_spender].add(_addedValue));
139       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140       return true;
141     }
142 
143     function decreaseApproval(address _spender,uint256 _subtractedValue) public returns (bool)
144     {
145       uint256 oldValue = allowed[msg.sender][_spender];
146       if (_subtractedValue >= oldValue) {
147         allowed[msg.sender][_spender] = 0;
148         } else {
149           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
150         }
151         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153       }
154 
155     }