1 pragma solidity ^0.4.21;
2 
3 contract ERC20 {
4     
5     function totalSupply() public view returns (uint256);
6     function balanceOf(address _owner) public view returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
9     function approve(address _spender, uint256 _value) public returns (bool);
10     function allowance(address _owner, address _spender) public view returns (uint256);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract Ownable {
17 
18     address public owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     function Ownable() {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnership(address _newOwner) onlyOwner {
32         require(_newOwner != address(0));
33         OwnershipTransferred(owner, _newOwner);
34         owner = _newOwner;
35     }
36 }
37 
38 
39 contract Pausable is Ownable {
40     
41     event Pause();
42     event Unpause();
43 
44     bool public paused = false;
45 
46     modifier whenNotPaused() {
47         require(!paused);
48         _;
49     }
50 
51     modifier whenPaused() {
52         require(paused);
53         _;
54     }
55 
56     function pause() onlyOwner whenNotPaused public {
57         paused = true;
58         Pause();
59     }
60 
61     function unpause() onlyOwner whenPaused public {
62         paused = false;
63         Unpause();
64     }
65 }
66 
67 library SafeMath {
68     /**
69     * @dev Multiplies two numbers, throws on overflow.
70     */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         assert(c / a == b);
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two numbers, truncating the quotient.
82     */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // assert(b > 0); // Solidity automatically throws when dividing by 0
85         uint256 c = a / b;
86         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87         return c;
88     }
89 
90     /**
91     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
92     */
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         assert(b <= a);
95         return a - b;
96     }
97 
98     /**
99     * @dev Adds two numbers, throws on overflow.
100     */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 }
107 
108 contract PCM is ERC20, Ownable, Pausable {
109     using SafeMath for uint256;
110     
111     string public constant name     = "Precium Token";
112     uint8 public constant decimals  = 18;
113     string public constant symbol   = "PCM";
114 
115     mapping (address => uint256) public balances;
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118     uint256 totalSupply_;
119 
120     function PCM(uint256 _amount) public Ownable() {
121         totalSupply_ = _amount * 1 ether;
122         balances[owner] = totalSupply_;
123     }
124 
125     function totalSupply() public view returns (uint256) {
126         return totalSupply_;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256) {
130         return balances[_owner];
131     }
132 
133     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
134         require(_to != address(0));
135         require(_value <= balances[msg.sender]);
136         
137         balances[msg.sender] = balances[msg.sender].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         Transfer(msg.sender, _to, _value);
140 
141         return true;
142     }
143 
144     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
145         require(_to != address(0));
146         require(_value <= balances[_from]);
147         require(_value <= allowed[_from][msg.sender]);
148 
149         balances[_from] = balances[_from].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152         Transfer(_from, _to, _value);
153         
154         return true;
155     }
156 
157     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166 
167     function burn(uint256 _value) public onlyOwner {
168         
169         require(_value <= balances[msg.sender]);
170     
171         address burner = msg.sender;
172         balances[burner] = balances[burner].sub(_value);
173         totalSupply_ = totalSupply_.sub(_value);
174 
175         Transfer(burner, address(0), _value);
176     }
177 }