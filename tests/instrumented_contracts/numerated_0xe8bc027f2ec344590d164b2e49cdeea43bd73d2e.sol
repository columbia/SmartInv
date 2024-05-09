1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     // uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return a / b;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   uint256 totalSupply_;
46 
47   function totalSupply() public view returns (uint256) {
48     return totalSupply_;
49   }
50 
51   function transfer(address _to, uint256 _value) public returns (bool) {
52     require(_to != address(0));
53     require(_value <= balances[msg.sender]);
54 
55     balances[msg.sender] = balances[msg.sender].sub(_value);
56     balances[_to] = balances[_to].add(_value);
57     emit Transfer(msg.sender, _to, _value);
58     return true;
59   }
60 
61   function balanceOf(address _owner) public view returns (uint256) {
62     return balances[_owner];
63   }
64 
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract StandardToken is ERC20, BasicToken {
75 
76   mapping (address => mapping (address => uint256)) internal allowed;
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     emit Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) public view returns (uint256) {
97     return allowed[_owner][_spender];
98   }
99 
100   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
101     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
102     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
107     uint oldValue = allowed[msg.sender][_spender];
108     if (_subtractedValue > oldValue) {
109       allowed[msg.sender][_spender] = 0;
110     } else {
111       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
112     }
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 }
117 
118 contract WATT is StandardToken {
119 
120     string public constant name = "WorkChain App Token";
121     string public constant symbol = "WATT";
122     uint8 public constant decimals = 18;
123 
124     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
125 
126     constructor() public {
127         totalSupply_ = INITIAL_SUPPLY;
128         balances[msg.sender] = INITIAL_SUPPLY;
129         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
130     }
131 }
132 
133 contract WorkRecordsStorage {
134 
135     WATT public token;
136 
137     address owner = msg.sender;
138     event WorkRecord(address indexed _subject, uint256 indexed _record_id, bytes16 _hash);
139 
140     constructor(address _work_token_address) public {
141         require(_work_token_address != address(0));
142         token = WATT(_work_token_address);
143     }
144 
145     modifier onlyOwner {
146         require(msg.sender == owner);
147         _;
148     }
149 
150     modifier onlyMember(address _target) {
151         uint256 balance = token.balanceOf(_target);
152         require(balance >= (10 ** uint256(18)));
153         _;
154     } 
155 
156     function addWorkRecord(uint256 _record_id, bytes16 _hash) public onlyMember(msg.sender){
157         emit WorkRecord(msg.sender, _record_id, _hash);
158     }
159 
160     function ownerAddWorkRecord(address _subject, uint256 _record_id, bytes16 _hash) public onlyOwner onlyMember(_subject){
161         emit WorkRecord(_subject, _record_id, _hash);
162     }
163 }