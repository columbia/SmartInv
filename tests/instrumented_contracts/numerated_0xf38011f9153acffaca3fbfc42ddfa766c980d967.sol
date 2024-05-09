1 pragma solidity ^0.4.26;
2 
3 contract Context {
4     function _msgSender() internal view returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 
15 contract ERC20Basic {
16     function totalSupply() public view returns (uint256);
17     function balanceOf(address who) public view returns (uint256);
18     function transfer(address to, uint256 value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 library SafeMath {
23 
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // assert(b > 0); // Solidity automatically throws when dividing by 0
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract BasicToken is ERC20Basic {
52 
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) balances;
56 
57     uint256 totalSupply_;
58 
59     function totalSupply() public view returns (uint256) {
60         return totalSupply_;
61     }
62 
63     function balanceOf(address _owner) public view returns (uint256 balance) {
64         return balances[_owner];
65     }
66 }
67 
68 contract ERC20 is ERC20Basic {
69     function allowance(address owner, address spender) public view returns (uint256);
70     function transferFrom(address from, address to, uint256 value) public returns (bool);
71     function approve(address spender, uint256 value) public returns (bool);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 contract Ownable is Context {
77     
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () internal {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102     function transferOwnership(address newOwner) public onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 contract StandardToken is ERC20, BasicToken, Ownable {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112     mapping (address => bool) internal locked;
113     
114     function getLockedStatus(address _account) public view returns (bool) {
115         return locked[_account];
116     } 
117 
118     function lockAccount(address _account) public onlyOwner returns (bool) {
119         locked[_account] = true;
120         return true;
121     }
122 
123     function unlockAccount(address _account) public onlyOwner returns (bool) {
124         locked[_account] = false;
125         return true;
126     }
127     
128     function transfer(address _to, uint256 _value) public returns (bool) {
129         require(!locked[msg.sender], "This account is locked. so, you can not transfer token to receiver...");
130         require(_to != address(0));
131         require(_value <= balances[msg.sender]);
132 
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(!locked[_from], "This account is locked. so, you can not transfer token to receiver...");
141         require(_to != address(0));
142         require(_value <= balances[_from]);
143         require(_value <= allowed[_from][msg.sender]);
144 
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169         uint oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 }
179 
180 
181 contract PlutoCoin is StandardToken {
182 
183     string public constant name = "PLUTO"; //
184     string public constant symbol = "PLUT"; // solium-disable-line uppercase
185     uint8 public constant decimals = 18; // solium-disable-line uppercase
186 
187     uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));
188 
189     /**
190      * @dev Constructor that gives msg.sender all of existing tokens.
191      */
192     constructor() public {
193         totalSupply_ = INITIAL_SUPPLY;
194         balances[msg.sender] = INITIAL_SUPPLY;
195         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
196     }
197 }