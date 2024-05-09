1 pragma solidity 0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract EIP20Interface {
46     function balanceOf(address _owner) public view returns (uint256);
47     function transfer(address _to, uint256 _value) public returns (bool);
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
49     function approve(address _spender, uint256 _value) public returns (bool);
50     function allowance(address _owner, address _spender) public view returns (uint256);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 contract BasicToken is EIP20Interface {
57   using SafeMath for uint256;
58   uint256 constant private MAX_UINT256 = 2**256 - 1;
59   mapping(address => uint256) balances;
60   mapping (address => mapping (address => uint256)) internal allowed;
61 
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value >= 0);
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     emit Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function balanceOf(address _owner) public view returns (uint256) {
75     return balances[_owner];
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     if (allowed[_from][msg.sender] < MAX_UINT256) {
86         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87     }
88     emit Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93     allowed[msg.sender][_spender] = _value;
94     emit Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) public view returns (uint256) {
99     return allowed[_owner][_spender];
100   }
101 }
102 
103 contract AICoinToken is BasicToken {
104   string public constant name = "AICoinToken";
105   string public constant symbol = "AI";
106   uint8 public constant decimals = 18;
107   uint256 public totalSupply = 100*10**26;
108 
109   function AICoinToken() public {
110     balances[msg.sender] = totalSupply;
111     emit Transfer(address(0), msg.sender, totalSupply);
112   }
113 }