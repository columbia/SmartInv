1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ERC20Basic {
30     function totalSupply() public view returns (uint256);
31 
32     function balanceOf(address who) public view returns (uint256);
33 
34     function transfer(address to, uint256 value) public returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40     using SafeMath for uint256;
41     mapping(address => uint256) balances;
42     mapping(address => bool) public frozenAccount;
43     uint256 totalSupply_;
44 
45     function totalSupply() public view returns (uint256) {
46         return totalSupply_;
47     }
48 
49     function transfer(address _to, uint256 _value) public returns (bool) {
50         require(_to != address(0));
51         require(_value <= balances[msg.sender]);
52         require(!frozenAccount[msg.sender]);
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         emit Transfer(msg.sender, _to, _value);
56         return true;
57     }
58 
59     function balanceOf(address _owner) public view returns (uint256) {
60         return balances[_owner];
61     }
62 }
63 
64 contract ERC20 is ERC20Basic {
65     function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68     function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71     function approve(address spender, uint256 value) public returns (bool);
72 
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract StandardToken is ERC20, BasicToken {
77     mapping(address => mapping(address => uint256)) internal allowed;
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);
83 
84         balances[_from] = balances[_from].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         allowed[msg.sender][_spender] = _value;
93         emit Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public view returns (uint256) {
98         return allowed[_owner][_spender];
99     }
100 
101     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
102         allowed[msg.sender][_spender] = (
103         allowed[msg.sender][_spender].add(_addedValue));
104         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107 
108     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109         uint oldValue = allowed[msg.sender][_spender];
110         if (_subtractedValue > oldValue) {
111             allowed[msg.sender][_spender] = 0;
112         } else {
113             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114         }
115         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 }
119 
120 contract Ownable {
121     address public owner;
122 
123     event OwnershipRenounced(address indexed previousOwner);
124     event OwnershipTransferred(
125         address indexed previousOwner,
126         address indexed newOwner
127     );
128 
129     constructor() public {
130         owner = msg.sender;
131     }
132 
133     modifier onlyOwner() {
134         require(msg.sender == owner);
135         _;
136     }
137 
138     function transferOwnership(address newOwner) public onlyOwner {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(owner, newOwner);
141         owner = newOwner;
142     }
143 
144     function renounceOwnership() public onlyOwner {
145         emit OwnershipRenounced(owner);
146         owner = address(0);
147     }
148 }
149 
150 contract NASTToken is StandardToken, Ownable {
151     string public constant name = "Node All-Star";
152     string public constant symbol = "NAST";
153     uint8 public constant decimals = 18;
154     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
155 
156     event Burn(address indexed burner, uint256 value);
157     event FrozenFunds(address target, bool frozen);
158 
159     constructor() public {
160         totalSupply_ = INITIAL_SUPPLY;
161         balances[msg.sender] = INITIAL_SUPPLY;
162         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
163     }
164 
165     function burnFrom(address _who, uint256 _value) public onlyOwner {
166         require(_value <= allowed[_who][msg.sender]);
167         allowed[_who][msg.sender] = allowed[_who][msg.sender].sub(_value);
168 
169         require(_value <= balances[_who]);
170         balances[_who] = balances[_who].sub(_value);
171         totalSupply_ = totalSupply_.sub(_value);
172         emit Burn(_who, _value);
173         emit Transfer(_who, address(0), _value);
174     }
175 
176     function freezeAccount(address _who, bool freeze) public onlyOwner {
177         frozenAccount[_who] = freeze;
178         emit FrozenFunds(_who, freeze);
179     }
180 }