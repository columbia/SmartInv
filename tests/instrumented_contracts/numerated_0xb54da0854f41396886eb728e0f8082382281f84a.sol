1 pragma solidity ^0.4.15;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function div(uint256 a, uint256 b) internal constant returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a % b;
41     //uint256 z = a / b;
42     assert(a == (a / b) * b + c); // There is no case in which this doesn't hold
43     return c;
44   }
45 }
46 
47 contract BasicToken is ERC20Basic {
48     using SafeMath for uint256;
49     mapping(address => uint256) public balances;
50     mapping(address => bool) public holders;
51     address[] public token_holders_array;
52     
53     function transfer(address _to, uint256 _value) public returns (bool) {
54         require(_to != address(0));
55         require(_value <= balances[msg.sender]);
56 
57         if (!holders[_to]) {
58             holders[_to] = true;
59             token_holders_array.push(_to);
60         }
61 
62         balances[_to] = balances[_to].add(_value);
63         balances[msg.sender] = balances[msg.sender].sub(_value);
64 
65 
66         /*if (balances[msg.sender] == 0) {
67             uint id = get_index(msg.sender);
68             delete token_holders_array[id];
69             token_holders_array[id] = token_holders_array[token_holders_array.length - 1];
70             delete token_holders_array[token_holders_array.length-1];
71             token_holders_array.length--;
72         }*/
73 
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77     
78     function get_index (address _whom) constant internal returns (uint256) {
79         for (uint256 i = 0; i<token_holders_array.length; i++) {
80             if (token_holders_array[i] == _whom) {
81                 return i;
82             }
83             //require (token_holders_array[i] == _whom);
84         }
85     }
86     
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90     
91     function count_token_holders () public constant returns (uint256) {
92         return token_holders_array.length;
93     }
94     
95     function tokenHolder(uint256 _index) public constant returns (address) {
96         return token_holders_array[_index];
97     }
98       
99 }
100 
101 contract StandardToken is ERC20, BasicToken {
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[_from]);
107     require(_value <= allowed[_from][msg.sender]);
108     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
109     // require (_value <= _allowance);
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     if (!holders[_to]) {
113         holders[_to] = true;
114         token_holders_array.push(_to);
115     }
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120   
121   function approve(address _spender, uint256 _value) public returns (bool) {
122     // To change the approve amount you first have to reduce the addresses`
123     //  allowance to zero by calling `approve(_spender, 0)` if it is not
124     //  already 0 to mitigate the race condition described here:
125     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
127     allowed[msg.sender][_spender] = _value;
128     Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
133     return allowed[_owner][_spender];
134   }
135 
136   function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
137     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141   function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
142     uint256 oldValue = allowed[msg.sender][_spender];
143     if (_subtractedValue > oldValue) {
144       allowed[msg.sender][_spender] = 0;
145     } else {
146       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
147     }
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 }
152 
153 contract Ownable {
154   address public owner;
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157   function Ownable() public {
158     owner = msg.sender;
159   }
160  
161   modifier onlyOwner() {
162     require(msg.sender == owner);
163     _;
164   }
165 
166   function transferOwnership(address newOwner) onlyOwner public {
167     require(newOwner != address(0));
168     OwnershipTransferred(owner, newOwner);
169     owner = newOwner;
170   }
171 }
172 
173 contract MintableToken is StandardToken, Ownable {
174   event Mint(address indexed to, uint256 amount);
175   event MintFinished();
176   bool public mintingFinished = false;
177   modifier canMint() {
178     require(!mintingFinished);
179     _;
180   }
181 
182   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
183     totalSupply = totalSupply.add(_amount);
184     if (!holders[_to]) {
185         holders[_to] = true;
186         token_holders_array.push(_to);
187     } 
188     balances[_to] = balances[_to].add(_amount);
189     Mint(_to, _amount);
190     Transfer(0x0, _to, _amount);
191     return true;
192   }
193 
194   function finishMinting() onlyOwner public returns (bool) {
195     mintingFinished = true;
196     MintFinished();
197     return true;
198   }
199 }
200 
201 contract SingleTokenCoin is MintableToken {
202   string public constant name = "Symmetry Fund Token";
203   string public constant symbol = "SYMM";
204   uint256 public constant decimals = 6;
205  }