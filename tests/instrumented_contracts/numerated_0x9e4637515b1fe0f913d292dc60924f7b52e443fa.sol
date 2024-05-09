1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     // uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return a / b;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 // Abstract contract for the full ERC 20 Token standard
54 // https://github.com/ethereum/EIPs/issues/20
55 contract ERC20 {
56     uint256 public _totalSupply;
57     string public name;
58     string public symbol;
59     uint8 public decimals;
60 
61     function totalSupply() public returns (uint256 supply);
62     function balanceOf(address _owner) public view returns (uint256 balance);
63     function transfer(address _to, uint256 _value) public returns (bool success);
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65     function approve(address _spender, uint256 _value) public returns (bool success);
66     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 }
71 
72 //Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
73 
74 contract ERC20Token is ERC20 {
75     using SafeMath for uint256;
76 
77     function totalSupply() public returns (uint) {
78         return _totalSupply.sub(balances[address(0)]);
79     }
80 
81     function balanceOf(address _owner) view public returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         //require(balances[msg.sender] >= _value);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         emit Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         balances[_to] = balances[_to].add(_value);
95         balances[_from] = balances[_from].sub(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         emit Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 
111     mapping (address => uint256) balances;
112     mapping (address => mapping (address => uint256)) allowed;
113 }
114 
115 /**
116  * @title ERC677 transferAndCall token interface
117  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
118  *      discussion.
119  */
120 contract ERC677 {
121     event Transfer(address indexed _from, address indexed _to, uint256 _amount, bytes _data);
122 
123     function transferAndCall(address _receiver, uint _amount, bytes _data) public;
124 }
125 
126 
127 /**
128  * @title Receiver interface for ERC677 transferAndCall
129  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
130  *      discussion.
131  */
132 contract ERC677Receiver {
133     function tokenFallback(address _from, uint _amount, bytes _data) public;
134 }
135 
136 contract ERC677Token is ERC677, ERC20Token {
137     function transferAndCall(address _receiver, uint _amount, bytes _data) public {
138         require(super.transfer(_receiver, _amount));
139 
140         emit Transfer(msg.sender, _receiver, _amount, _data);
141 
142         // call receiver
143         if (isContract(_receiver)) {
144             ERC677Receiver to = ERC677Receiver(_receiver);
145             to.tokenFallback(msg.sender, _amount, _data);
146         }
147     }
148 
149     function isContract(address _addr) internal view returns (bool) {
150         uint len;
151         assembly {
152             len := extcodesize(_addr)
153         }
154         return len > 0;
155     }
156 }
157 
158 contract MintableToken is ERC20Token, Ownable {
159     event Mint(address indexed to, uint256 amount);
160     event MintFinished();
161 
162     bool public mintingFinished = false;
163 
164     modifier canMint() {
165         require(!mintingFinished);
166         _;
167     }
168 
169     /**
170     * @dev Function to mint tokens
171     * @param _to The address that will receive the minted tokens.
172     * @param _amount The amount of tokens to mint.
173     * @return A boolean that indicates if the operation was successful.
174     */
175     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
176         _totalSupply = _totalSupply.add(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         emit Mint(_to, _amount);
179         emit Transfer(address(0), _to, _amount);
180         return true;
181     }
182 
183     /**
184     * @dev Function to stop minting new tokens.
185     * @return True if the operation was successful.
186     */
187     function finishMinting() onlyOwner canMint public returns (bool) {
188         mintingFinished = true;
189         emit MintFinished();
190         return true;
191     }
192 }
193 
194 contract GLCCToken is ERC677Token, Ownable, MintableToken {
195     constructor() public {
196         symbol = "GLCC";
197         name = "GLOBALLOT CHARITY CHAIN";
198         decimals = 18;
199         _totalSupply = 500000000 * 10**uint(decimals);
200 
201         balances[owner] = _totalSupply;
202         emit Transfer(address(0), owner, _totalSupply);
203     }
204 }