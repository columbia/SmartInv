1 pragma solidity ^0.4.15;
2 contract ERC20Basic {
3  uint256 public totalSupply;
4  function balanceOf(address who) constant returns (uint256);
5  function transfer(address to, uint256 value) returns (bool);
6  event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 contract ERC20 is ERC20Basic {
9  function allowance(address owner, address spender) constant returns (uint256);
10  function transferFrom(address from, address to, uint256 value) returns (bool);
11  function approve(address spender, uint256 value) returns (bool);
12  event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 library SafeMath {
15  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16    uint256 c = a * b;
17    assert(a == 0 || c / a == b);
18    return c;
19  }
20  function div(uint256 a, uint256 b) internal constant returns (uint256) {
21    uint256 c = a / b;
22    return c;
23  }
24  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25    assert(b <= a);
26    return a - b;
27  }
28  function add(uint256 a, uint256 b) internal constant returns (uint256) {
29    uint256 c = a + b;
30    assert(c >= a);
31    return c;
32  }
33 }
34 contract BasicToken is ERC20Basic {
35  using SafeMath for uint256;
36  mapping(address => uint256) balances;
37  function transfer(address _to, uint256 _value) returns (bool) {
38    balances[msg.sender] = balances[msg.sender].sub(_value);
39    balances[_to] = balances[_to].add(_value);
40    Transfer(msg.sender, _to, _value);
41    return true;
42  }
43  function balanceOf(address _owner) constant returns (uint256 balance) {
44    return balances[_owner];
45  }
46 }
47 contract StandardToken is ERC20, BasicToken {
48  mapping (address => mapping (address => uint256)) allowed;
49  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
50    var _allowance = allowed[_from][msg.sender];
51    balances[_to] = balances[_to].add(_value);
52    balances[_from] = balances[_from].sub(_value);
53    allowed[_from][msg.sender] = _allowance.sub(_value);
54    Transfer(_from, _to, _value);
55    return true;
56  }
57  function approve(address _spender, uint256 _value) returns (bool) {
58    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
59    allowed[msg.sender][_spender] = _value;
60    Approval(msg.sender, _spender, _value);
61    return true;
62  }
63  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64    return allowed[_owner][_spender];
65  }
66 }
67 contract Ownable {
68  address public owner;
69  function Ownable() {
70    owner = msg.sender;
71  }
72  modifier onlyOwner() {
73    require(msg.sender == owner);
74    _;
75  }
76  function transferOwnership(address newOwner) onlyOwner {
77    require(newOwner != address(0));
78    owner = newOwner;
79  }
80 }
81 contract MintableToken is StandardToken, Ownable {
82  event Mint(address indexed to, uint256 amount);
83  event MintFinished();
84  bool public mintingFinished = false;
85  modifier canMint() {
86    require(!mintingFinished);
87    _;
88  }
89  function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
90    totalSupply = totalSupply.add(_amount);
91    balances[_to] = balances[_to].add(_amount);
92    Mint(_to, _amount);
93    return true;
94  }
95  function finishMinting() onlyOwner returns (bool) {
96    mintingFinished = true;
97    MintFinished();
98    return true;
99  }
100 }
101 contract GlobalCryptoBank is MintableToken {
102    string public constant name = "Global Crypto Bank";
103    string public constant symbol = "BANK";
104    uint32 public constant decimals = 18;
105    uint public INITIAL_SUPPLY = 50000000 * 1 ether;
106    function GlobalCryptoBank() {
107        mint(owner, INITIAL_SUPPLY);
108        transfer(0x0e2Bec7F14F244c5D1b4Ce14f48dcDb88fB61690, 2000000 * 1 ether);
109        finishMinting();
110    }
111 }
112 contract Crowdsale is Ownable {
113    using SafeMath for uint;
114    address founderAddress;
115    address bountyAddress;
116    uint preIsoTokenLimit;
117    uint isoTokenLimit;
118    uint preIsoStartDate;
119    uint preIsoEndDate;
120    uint isoStartDate;
121    uint isoEndDate;
122    uint rate;
123    uint founderPercent;
124    uint bountyPercent;
125    uint public soldTokens = 0;
126    GlobalCryptoBank public token = new GlobalCryptoBank();
127    function Crowdsale () payable {
128        founderAddress = 0xF12B75857E56727c90fc473Fe18C790B364468eD;
129        bountyAddress = 0x0e2Bec7F14F244c5D1b4Ce14f48dcDb88fB61690;
130        founderPercent = 90;
131        bountyPercent = 10;
132        rate = 300 * 1 ether;
133        preIsoStartDate = 1509321600;
134        preIsoEndDate = 1511049600;
135        isoStartDate = 1511568000;
136        isoEndDate = 1514678399;
137        preIsoTokenLimit = 775000 * 1 ether;
138        isoTokenLimit = 47225000 * 1 ether;
139    }
140    modifier isUnderPreIsoLimit(uint value) {
141        require((soldTokens+rate.mul(value).div(1 ether)+rate.mul(value).div(1 ether).mul(getPreIsoBonusPercent(value).div(100))) <= preIsoTokenLimit);
142        _;
143    }
144    modifier isUnderIsoLimit(uint value) {
145        require((soldTokens+rate.mul(value).div(1 ether)+rate.mul(value).div(1 ether).mul(getIsoBonusPercent(value).div(100))) <= isoTokenLimit);
146        _;
147    }
148    function getPreIsoBonusPercent(uint value) private returns (uint) {
149        uint eth = value.div(1 ether);
150        uint bonusPercent = 0;
151        if (now >= preIsoStartDate && now <= preIsoStartDate + 2 days) {
152            bonusPercent += 35;
153        } else if (now >= preIsoStartDate + 2 days && now <= preIsoStartDate + 7 days) {
154            bonusPercent += 33;
155        } else if (now >= preIsoStartDate + 7 days && now <= preIsoStartDate + 14 days) {
156            bonusPercent += 31;
157        } else if (now >= preIsoStartDate + 14 days && now <= preIsoStartDate + 21 days) {
158            bonusPercent += 30;
159        }
160        
161        
162        if (eth >= 1 && eth < 10) {
163            bonusPercent += 2;
164        } else if (eth >= 10 && eth < 50) {
165            bonusPercent += 4;
166        } else if (eth >= 50 && eth < 100) {
167            bonusPercent += 8;
168        } else if (eth >= 100) {
169            bonusPercent += 10;
170        }
171        return bonusPercent;
172    }
173    function getIsoBonusPercent(uint value) private returns (uint) {
174        uint eth = value.div(1 ether);
175        uint bonusPercent = 0;
176        if (now >= isoStartDate && now <= isoStartDate + 2 days) {
177            bonusPercent += 20;
178        } else if (now >= isoStartDate + 2 days && now <= isoStartDate + 7 days) {
179            bonusPercent += 18;
180        } else if (now >= isoStartDate + 7 days && now <= isoStartDate + 14 days) {
181            bonusPercent += 15;
182        } else if (now >= isoStartDate + 14 days && now <= isoStartDate + 21 days) {
183            bonusPercent += 10;
184        }
185        if (eth >= 1 && eth < 10) {
186            bonusPercent += 2;
187        } else if (eth >= 10 && eth < 50) {
188            bonusPercent += 4;
189        } else if (eth >= 50 && eth < 100) {
190            bonusPercent += 8;
191        } else if (eth >= 100) {
192            bonusPercent += 10;
193        }
194        return bonusPercent;
195    }
196    function buyPreICOTokens(uint value, address sender) private isUnderPreIsoLimit(value) {
197        founderAddress.transfer(value.div(100).mul(founderPercent));
198        bountyAddress.transfer(value.div(100).mul(bountyPercent));
199        uint tokens = rate.mul(value).div(1 ether);
200        uint bonusTokens = 0;
201        uint bonusPercent = getPreIsoBonusPercent(value);
202        bonusTokens = tokens.mul(bonusPercent).div(100);
203        tokens += bonusTokens;
204        soldTokens += tokens;
205        token.transfer(sender, tokens);
206    }
207    function buyICOTokens(uint value, address sender) private isUnderIsoLimit(value) {
208        founderAddress.transfer(value.div(100).mul(founderPercent));
209        bountyAddress.transfer(value.div(100).mul(bountyPercent));
210        uint tokens = rate.mul(value).div(1 ether);
211        uint bonusTokens = 0;
212        uint bonusPercent = getIsoBonusPercent(value);
213        bonusTokens = tokens.mul(bonusPercent).div(100);
214        tokens += bonusTokens;
215        soldTokens += tokens;
216        token.transfer(sender, tokens);
217    }
218    function() external payable {
219        if (now >= preIsoStartDate && now < preIsoEndDate) {
220            buyPreICOTokens(msg.value, msg.sender);
221        } else if (now >= isoStartDate && now < isoEndDate) {
222            buyICOTokens(msg.value, msg.sender);
223        }
224    }
225 }