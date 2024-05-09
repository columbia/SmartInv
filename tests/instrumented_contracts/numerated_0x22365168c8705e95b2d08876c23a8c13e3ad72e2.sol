1 pragma solidity 0.4.24;
2 
3 contract ERC20 {
4 
5     event Approval(address indexed owner, address indexed spender, uint256 value);
6     event Transfer(address indexed from, address indexed to, uint256 value);
7     
8     function allowance(address owner, address spender) public view returns (uint256);
9     
10     function transferFrom(address from, address to, uint256 value) public returns (bool);
11 
12     function approve(address spender, uint256 value) public returns (bool);
13 
14     function totalSupply() public view returns (uint256);
15 
16     function balanceOf(address who) public view returns (uint256);
17     
18     function transfer(address to, uint256 value) public returns (bool);
19     
20   
21 }
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (a == 0) {
38       return 0;
39     }
40 
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 contract Ownable {
75 
76     address public owner;
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     function setOwner(address _owner) public onlyOwner {
83         owner = _owner;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91 }
92 
93 contract Vault is Ownable { 
94 
95     function () public payable {
96 
97     }
98 
99     function getBalance() public view returns (uint) {
100         return address(this).balance;
101     }
102 
103     function withdraw(uint amount) public onlyOwner {
104         require(address(this).balance >= amount);
105         owner.transfer(amount);
106     }
107 
108     function withdrawAll() public onlyOwner {
109         withdraw(address(this).balance);
110     }
111 }
112 
113 contract TournamentPass is ERC20, Ownable {
114 
115     using SafeMath for uint256;
116 
117     Vault vault;
118 
119     constructor(Vault _vault) public {
120         vault = _vault;
121     }
122 
123     mapping(address => uint256) balances;
124     mapping (address => mapping (address => uint256)) internal allowed;
125     address[] public minters;
126     uint256 supply;
127     uint mintLimit = 20000;
128     
129     function name() public view returns (string){
130         return "GU Tournament Passes";
131     }
132 
133     function symbol() public view returns (string) {
134         return "PASS";
135     }
136 
137     function addMinter(address minter) public onlyOwner {
138         minters.push(minter);
139     }
140 
141     function totalSupply() public view returns (uint256) {
142         return supply;
143     }
144 
145     function transfer(address _to, uint256 _value) public returns (bool) {
146         require(_to != address(0));
147         require(_value <= balances[msg.sender]);
148 
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         emit Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     function balanceOf(address _owner) public view returns (uint256) {
156         return balances[_owner];
157     }
158 
159     function isMinter(address test) internal view returns (bool) {
160         for (uint i = 0; i < minters.length; i++) {
161             if (minters[i] == test) {
162                 return true;
163             }
164         }
165         return false;
166     }
167 
168     function mint(address to, uint amount) public returns (bool) {
169         require(isMinter(msg.sender));
170         if (amount.add(supply) > mintLimit) {
171             return false;
172         } 
173         supply = supply.add(amount);
174         balances[to] = balances[to].add(amount);
175         emit Transfer(address(0), to, amount);
176         return true;
177     }
178 
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186         require(_to != address(0));
187         require(_value <= balances[_from]);
188         require(_value <= allowed[_from][msg.sender]);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
198         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
199         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
200         return true;
201     }
202 
203     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
204         uint256 oldValue = allowed[msg.sender][spender];
205         if (subtractedValue > oldValue) {
206             allowed[msg.sender][spender] = 0;
207         } else {
208             allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
209         }
210         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
211         return true;
212     }
213 
214     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
215         return allowed[_owner][_spender];
216     }
217 
218     uint public price = 250 finney;
219 
220     function purchase(uint amount) public payable {
221         
222         require(msg.value >= price.mul(amount));
223         require(supply.add(amount) <= mintLimit);
224 
225         supply = supply.add(amount);
226         balances[msg.sender] = balances[msg.sender].add(amount);
227         emit Transfer(address(0), msg.sender, amount);
228 
229         address(vault).transfer(msg.value);
230     }
231 
232 }