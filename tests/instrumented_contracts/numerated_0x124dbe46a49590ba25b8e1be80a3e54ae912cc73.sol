1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9 
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract customIcoToken{
32     using SafeMath for uint256;
33 
34     /* Events */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37     event LogRefund(address indexed _to, uint256 _value);
38     event CreateToken(address indexed _to, uint256 _value);
39 
40     // metadata
41     string public name;
42     string public symbol;
43     uint256 public decimals;
44 
45     // contracts
46     address public ethFundDeposit;      // deposit address for ETH
47     address public tokenFundDeposit;
48 
49     // crowdsale parameters
50     bool public isFinalized;              // switched to true in operational state
51     uint256 public fundingStartBlock;
52     uint256 public fundingEndBlock;
53     uint256 public tokenFund;
54     uint256 public tokenExchangeRate;
55     uint256 public tokenCreationCap;
56     uint256 public tokenCreationMin;
57 
58     /* Storage */
59     mapping(address => uint256) balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61 
62     uint256 public totalSupply;
63 
64     /* Getters */
65     function totalSupply() public view returns (uint256) {
66         return totalSupply;
67     }
68 
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function allowance(address _owner, address _spender) public view returns (uint256) {
74         return allowed[_owner][_spender];
75     }
76 
77     /* Methods */
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool) {
91         allowed[msg.sender][_spender] = _value;
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
97         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99         return true;
100     }
101 
102     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
103         uint oldValue = allowed[msg.sender][_spender];
104         if (_subtractedValue > oldValue) {
105             allowed[msg.sender][_spender] = 0;
106         } else {
107             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108         }
109         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110         return true;
111   }
112 
113     function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122     }
123 
124     /* Crowdsale methods */
125 
126     /// @dev Accepts ether and creates new tokens.
127     function createTokens() payable external {
128       require (isFinalized == false);
129       require(block.number > fundingStartBlock);
130       require(block.number < fundingEndBlock);
131       require(msg.value > 0);
132 
133       uint256 tokens = msg.value.mul(tokenExchangeRate);
134       uint256 checkedSupply = totalSupply.add(tokens);
135 
136       // return money if something goes wrong
137       require(tokenCreationCap >= checkedSupply); // odd fractions won't be found
138 
139       totalSupply = checkedSupply;
140       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
141       emit CreateToken(msg.sender, tokens);  // logs token creation
142     }
143 
144     /// @dev Ends the funding period and sends the ETH home
145     function finalize() external {
146       require(isFinalized == false);
147       require(msg.sender == ethFundDeposit);
148       require(totalSupply > tokenCreationMin); // have to sell minimum to move to operational
149       require(block.number > fundingEndBlock || totalSupply == tokenCreationCap);
150       // move to operational
151       isFinalized = true;
152       assert(ethFundDeposit.send(address(this).balance)); // send the eth
153     }
154 
155     /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
156     function refund() external {
157       require(isFinalized == false);                       // prevents refund if operational
158       require(block.number > fundingEndBlock); // prevents refund until sale period is over
159       require(totalSupply < tokenCreationMin); // no refunds if we sold enough
160       require(msg.sender != tokenFundDeposit);    // team not entitled to a refund
161       uint256 tokenVal = balances[msg.sender];
162       require(tokenVal > 0);
163       balances[msg.sender] = 0;
164       totalSupply = totalSupply.sub(tokenVal); // extra safe
165       uint256 ethVal = tokenVal / tokenExchangeRate; // should be safe; previous throws covers edges
166       emit LogRefund(msg.sender, ethVal); // log it
167       assert(msg.sender.send(ethVal)); // if you're using a contract; make sure it works with .send gas limits
168     }
169 
170     constructor(
171         string _name,
172         string _symbol,
173         uint8 _decimals,
174         address _ethFundDeposit,
175         address _tokenFundDeposit,
176         uint256 _tokenFund,
177         uint256 _tokenExchangeRate,
178         uint256 _tokenCreationCap,
179         uint256 _tokenCreationMin,
180         uint256 _fundingStartBlock,
181         uint256 _fundingEndBlock) public
182     {
183       name = _name;
184       symbol = _symbol;
185       decimals = _decimals;
186       isFinalized = false;                   //controls pre through crowdsale state
187       ethFundDeposit = _ethFundDeposit;
188       tokenFundDeposit = _tokenFundDeposit;
189       tokenFund = _tokenFund*10**decimals;
190       tokenExchangeRate = _tokenExchangeRate;
191       tokenCreationCap = _tokenCreationCap*10**decimals;
192       tokenCreationMin = _tokenCreationMin*10**decimals;
193       fundingStartBlock = _fundingStartBlock;
194       fundingEndBlock = _fundingEndBlock;
195       totalSupply = tokenFund;
196       balances[tokenFundDeposit] = tokenFund;
197       emit CreateToken(tokenFundDeposit, tokenFund);
198     }
199 }