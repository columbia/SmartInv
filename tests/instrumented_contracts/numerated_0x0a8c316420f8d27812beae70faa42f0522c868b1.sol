1 pragma solidity ^0.4.18;
2 
3 /**
4 * @title Safemath library taken from openzeppline
5 *
6 **/
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38 * @title ERC20 interface
39 **/
40 interface ERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address _who) external view returns (uint256);
43     function transfer(address _to, uint256 _value) external returns(bool);
44     
45     function allowance(address _owner, address _spender) external view returns (uint256);
46     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
47     function approve(address _spender, uint256 _value) external returns (bool);
48 
49 
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 /**
55  * @title Contract Ownable
56  **/ 
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOWner);
61     
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 }
73 
74 /**
75  *  @title Contract Pauseable
76  **/ 
77 contract Pauseable is Ownable {
78     bool public paused = false;
79 
80     event Pause();
81     event Unpause();
82 
83     modifier whenNotPaused() {
84         require(!paused);
85         _;
86     }
87     modifier whenPaused() {
88         require(paused);
89         _;
90     }
91 
92     function pause() onlyOwner whenNotPaused public {
93         paused = true;
94         Pause();
95     }
96 
97     function unpause() onlyOwner whenPaused public {
98         paused = false;
99         Unpause();
100     }
101 }
102 
103 /**
104 * @title WAVElite Token
105 **/
106 contract WAVEliteToken is ERC20, Pauseable {
107 
108     using SafeMath for uint256;
109 
110     mapping(address => uint256) internal balances;
111     mapping(address => mapping(address => uint256)) internal allowed;
112     uint256 _totalSupply;    
113     
114 
115     string public constant name = "WAVElite";
116     string public constant symbol = "WAVELT";
117     uint8 public constant decimals = 18;
118     uint256 public constant INITIAL_SUPPLY =  45000000 * (10 ** uint256(decimals));
119     
120     function WAVEliteToken() public {
121         owner = msg.sender;
122         _totalSupply = INITIAL_SUPPLY;
123         balances[msg.sender] = INITIAL_SUPPLY;
124         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
125     }
126 
127     function totalSupply() external view returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address _who) external view returns (uint256) {
132         return balances[_who];
133     }
134 
135     function transfer(address _to, uint256 _value) external whenNotPaused returns (bool) {
136         require(_to != address(0));
137         require(_value <= balances[msg.sender]);
138 
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141 
142         Transfer(msg.sender, _to, _value);
143         return true;
144     }
145 
146     function allowance(address _owner, address _spender) external view returns (uint256) {
147         return allowed[_owner][_spender];
148     }    
149 
150     function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool) {
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154 
155         balances[_from] = balances[_from].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158         Transfer(_from, _to, _value);
159         return true;
160     }
161 
162     function approve(address _spender, uint256 _value) external whenNotPaused returns (bool) {
163         allowed[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     function increaseApproval(address _spender, uint _addValue) public whenNotPaused returns (bool) {
169         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addValue);
170         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 
174     function decreaseApproval(address _spender, uint _subValue) public whenNotPaused returns (bool) {
175         if (_subValue >= allowed[msg.sender][_spender]) {
176             allowed[msg.sender][_spender] = 0;
177         } else {
178             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_subValue);
179         }
180         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     /**
185     * Burnable
186     **/
187 
188     event Burn(address indexed burner, uint256 value);
189     function burn(uint256 _value) public whenNotPaused {
190         require(_value <= balances[msg.sender]);
191         address burner = msg.sender;
192         balances[burner] = balances[burner].sub(_value);
193         _totalSupply = _totalSupply.sub(_value);
194         Burn(burner, _value);
195         Transfer(burner, address(0), _value);      
196     }
197 }