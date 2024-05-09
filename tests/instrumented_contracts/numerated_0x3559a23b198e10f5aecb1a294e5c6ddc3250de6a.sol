1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  */
6 library SafeMath {
7 
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a / b;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 /**
33  * @title Ownable
34  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
35  */
36 contract Ownable {
37     address public owner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57     }
58 }
59 
60 /**
61  * @title ERC20Basic
62  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
63  */
64 contract ERC20Basic {
65     function totalSupply() public view returns (uint256);
66     function balanceOf(address who) public view returns (uint256);
67     function transfer(address to, uint256 value) public returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 /**
71  * @title Basic token
72  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
73  */
74 contract BasicToken is ERC20Basic {
75     using SafeMath for uint256;
76 
77     mapping(address => uint256) balances;
78 
79     uint256 totalSupply_;
80 
81     function totalSupply() public view returns (uint256) {
82         return totalSupply_;
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256) {
96         return balances[_owner];
97     }
98 }
99 /**
100  * @title ERC20 interface
101  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
102  */
103 contract ERC20 is ERC20Basic {
104     function allowance(address owner, address spender) public view returns (uint256);
105     function transferFrom(address from, address to, uint256 value) public returns (bool);
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 /**
111  * @title Standard ERC20 token
112  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
113  */
114 contract StandardToken is ERC20, BasicToken {
115 
116     mapping (address => mapping (address => uint256)) internal allowed;
117 
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         emit Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         allowed[msg.sender][_spender] = _value;
132         emit Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) public view returns (uint256) {
137         return allowed[_owner][_spender];
138     }
139 
140     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
141         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
142         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143         return true;
144     }
145 
146     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
147         uint oldValue = allowed[msg.sender][_spender];
148         if (_subtractedValue > oldValue) {
149             allowed[msg.sender][_spender] = 0;
150         } else {
151             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
152         }
153         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155     }
156 }
157 /**
158  * @title Burnable Token
159  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
160  */
161 contract BurnableToken is BasicToken {
162 
163     event Burn(address indexed burner, uint256 value);
164 
165     function burn(uint256 _value) public {
166         _burn(msg.sender, _value);
167     }
168 
169     function _burn(address _who, uint256 _value) internal {
170         require(_value <= balances[_who]);
171 
172         balances[_who] = balances[_who].sub(_value);
173         totalSupply_ = totalSupply_.sub(_value);
174         emit Burn(_who, _value);
175         emit Transfer(_who, address(0), _value);
176     }
177 }
178 
179 /**
180  * @title Mintable token
181  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/MintableToken.sol
182  */
183 contract MintableToken is StandardToken, Ownable {
184     event Mint(address indexed to, uint256 amount);
185     event MintFinished();
186 
187     bool public mintingFinished = false;
188 
189     modifier canMint() {
190         require(!mintingFinished);
191         _;
192     }
193 
194     modifier hasMintPermission() {
195         require(msg.sender == owner);
196         _;
197     }
198 
199     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
200         totalSupply_ = totalSupply_.add(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         emit Mint(_to, _amount);
203         emit Transfer(address(0), _to, _amount);
204         return true;
205     }
206 
207     function finishMinting() onlyOwner canMint public returns (bool) {
208         mintingFinished = true;
209         emit MintFinished();
210         return true;
211     }
212 }
213 
214 contract GloWToken is MintableToken, BurnableToken {
215 
216     using SafeMath for uint256;
217 
218     string  public name = "Global Wasp";
219     string  public symbol = "GloW";
220     uint256 constant public decimals = 6;
221     uint256 constant dec = 10**decimals;
222     uint256 public constant initialSupply = 36400000*dec; // 36 400 000 GLOW
223     address public crowdsaleAddress;
224 
225     modifier onlyICO() {
226         require(msg.sender == crowdsaleAddress);
227         _;
228     }
229 
230     constructor() public { }
231 
232     function setSaleAddress(address _saleaddress) public onlyOwner{
233         crowdsaleAddress = _saleaddress;
234     }
235 
236     function mintFromICO(address _to, uint256 _amount) onlyICO canMint public returns (bool) {
237         require(totalSupply_ <= initialSupply);
238         require(balances[_to].add(_amount) != 0); // проверка на переполнение
239         require(balances[_to].add(_amount) > balances[_to]); // проверка на переполнение
240         totalSupply_ = totalSupply_.add(_amount);
241         balances[_to] = balances[_to].add(_amount);
242         emit Mint(_to, _amount);
243         emit Transfer(address(0), _to, _amount);
244         return true;
245     }
246 }