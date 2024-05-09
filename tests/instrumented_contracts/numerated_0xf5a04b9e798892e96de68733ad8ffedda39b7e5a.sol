1 pragma solidity >=0.4.22 <0.7.0;
2 
3 
4 contract Ownable {
5     address public owner;
6     
7     event OwnershipRenounced(address indexed previousOwner);
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9     
10     constructor() public {
11         owner = msg.sender;
12     }
13     
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18     
19     function renounceOwnership() public onlyOwner {
20         owner = address(0);
21     }
22     
23     function transferOwnership(address _newOwner) public onlyOwner {
24         _transferOwnership(_newOwner);
25     }
26     
27     function _transferOwnership(address _newOwner) internal {
28         require(_newOwner != address(0));
29         emit OwnershipTransferred(owner, _newOwner);
30         owner = _newOwner;
31     }
32 }
33 
34 
35 library SafeMath {
36   
37    function times(uint256 a, uint256 b) 
38      internal
39      pure
40      returns (uint256 c) 
41   {
42     c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function minus(uint256 a, uint256 b) 
48     internal 
49     pure 
50   returns (uint256 c) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function plus(uint256 a, uint256 b) 
56     internal 
57     pure 
58   returns (uint256 c) {
59     c = a + b;
60     assert(c>=a);
61     return c;
62   }
63 
64 }
65 
66 contract ERC20 {
67     function balanceOf(address who) public view returns (uint256);
68     function totalSupply() external view returns (uint256);    
69     function allowance (address owner, address spender) public view returns (uint256);
70     function approve(address spender, uint256 value) public returns (bool);
71     function transfer(address to, uint256 value) public returns (bool);
72     function transferFrom(address from, address to, uint256 value) public returns (bool);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 contract Topswap is ERC20, Ownable {
78     using SafeMath for uint256;
79     
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     uint256 internal totalSupply_;
84     
85     mapping(address => uint256) balances;
86     mapping (address => mapping (address => uint256)) internal allowed;
87     
88     
89     event Mint(address indexed to, uint256 amount);
90     event Burn(uint256 amount);
91     
92     constructor(uint256 initialSupply, string memory _name, string memory _symbol, uint8 _decimals) public {
93         name = _name;
94         symbol = _symbol;
95         decimals = _decimals;
96         totalSupply_ = initialSupply * 10 ** uint256(decimals);
97         balances[msg.sender] = totalSupply_;
98     }
99   
100     function mint(address _to, uint256 _amount)
101       onlyOwner
102       public
103     {
104       totalSupply_ = totalSupply_.plus(_amount);
105       balances[_to] = balances[_to].plus(_amount);
106       emit Mint(_to, _amount);
107       emit Transfer(address(0), _to, _amount);
108     }
109 
110     function burn(uint256 _amount)
111       onlyOwner
112       public
113     {
114       totalSupply_ = totalSupply_.minus(_amount);
115       balances[msg.sender] = balances[msg.sender].minus(_amount);
116       emit Burn(_amount);
117       emit Transfer(msg.sender, address(0), _amount);
118     }
119     
120     
121     function totalSupply() external view returns (uint256) {
122         return totalSupply_;
123     }
124     
125     function transfer(address _to, uint256 _value) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[msg.sender]);
128         
129         balances[msg.sender] = balances[msg.sender].minus(_value);
130         balances[_to] = balances[_to].plus(_value);
131         emit Transfer(msg.sender, _to, _value);
132         return true;
133     }
134     
135     function balanceOf(address _owner) public view returns (uint256) {
136         return balances[_owner];
137     }
138     
139     function transferFrom(address _from, address _to, uint256 _value)
140       public
141       returns(bool)
142     {
143         require(_to != address(0));
144         require(_value <= balances[_from]);
145         require(_value <= allowed[_from][msg.sender]);
146         
147         balances[_from] = balances[_from].minus(_value);
148         balances[_to] = balances[_to].plus(_value);
149         allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }
153     
154     function approve(address _spender, uint256 _value)
155       public 
156       returns (bool)
157     {
158         allowed[msg.sender][_spender] = _value;
159         emit Approval(msg.sender, _spender, _value);
160         return true;
161     }
162     
163     function allowance(address _owner, address _spender) 
164       public 
165       view 
166       returns (uint256)
167     {
168         return allowed[_owner][_spender];
169     }
170     
171     function increaseApproval(address _spender, uint256 _addedValue) 
172       public 
173       returns (bool)
174     {
175         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(_addedValue);
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179     
180     function decreaseApproval(address _spender, uint256 _subtractedValue) 
181       public 
182       returns(bool)
183     {
184         uint256 oldValue = allowed[msg.sender][_spender];
185         if(_subtractedValue > oldValue){
186             allowed[msg.sender][_spender] = 0;
187         }else {
188             allowed[msg.sender][_spender] = oldValue.minus(_subtractedValue);
189         }
190         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193     
194     function isToken() 
195         public 
196         view 
197         returns (bool)
198     {
199         return true;
200     }
201     
202 }