1 pragma solidity ^0.6.0;
2  
3 /**
4 ERC20 Token
5  
6 Symbol          : IOI
7 Name            : IOI Token
8 Total supply    : 100000000
9 Decimals        : 6
10  
11 */
12  
13 abstract contract ERC20Interface {
14   string public name;
15  string public symbol;
16   uint8 public decimals;
17   uint256 public totalSupply;
18  function balanceOf(address _owner) public view virtual returns (uint256 balance);
19   function transfer(address _to, uint256 _value) public virtual returns (bool success);
20   function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
21   function approve(address _spender, uint256 _value) public virtual returns (bool success);
22  function allowance(address _owner, address _spender) public view virtual returns (uint256 remaining);
23   event Transfer(address indexed _from, address indexed _to, uint256 _value);
24   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 }
26  
27  
28 contract Owned {
29  address public owner;
30  address public newOwner;
31  
32  event OwnershipTransferred(address indexed _from, address indexed _to);
33  
34  constructor () public {
35    owner = msg.sender;
36  }
37  
38  modifier onlyOwner {
39    require(msg.sender == owner);
40    _;
41  }
42  
43  function transferOwnership(address _newOwner) public onlyOwner {
44    newOwner = _newOwner;
45  }
46  
47  function acceptOwnership() public {
48    require(msg.sender == newOwner);
49    emit OwnershipTransferred(owner, newOwner);
50    owner = newOwner;
51    newOwner = address(0);
52  }
53 }
54  
55  
56 abstract contract TokenRecipient {
57  function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public virtual;
58 }
59  
60  
61 contract Token is ERC20Interface, Owned {
62  
63  mapping (address => uint256) _balances;
64  mapping (address => mapping (address => uint256)) _allowed;
65  
66  event Burn(address indexed from, uint256 value);
67   function balanceOf(address _owner) public view override returns (uint256 balance) {
68    return _balances[_owner];
69  }
70  
71  function transfer(address _to, uint256 _value) public override returns (bool success) {
72    _transfer(msg.sender, _to, _value);
73    return true;
74  }
75  
76  function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
77    require(_value <= _allowed[_from][msg.sender]);
78    _allowed[_from][msg.sender] -= _value;
79    _transfer(_from, _to, _value);
80    return true;
81  }
82  
83  function approve(address _spender, uint256 _value) public override returns (bool success) {
84    _allowed[msg.sender][_spender] = _value;
85    emit Approval(msg.sender, _spender, _value);
86    return true;
87  }
88  
89  function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
90    return _allowed[_owner][_spender];
91  }
92  
93   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
94    return ERC20Interface(tokenAddress).transfer(owner, tokens);
95  }
96  
97   function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
98    TokenRecipient spender = TokenRecipient(_spender);
99    approve(_spender, _value);
100    spender.receiveApproval(msg.sender, _value, address(this), _extraData);
101    return true;
102  }
103  
104  function burn(uint256 _value) public returns (bool success) {
105    require(_balances[msg.sender] >= _value);
106    _balances[msg.sender] -= _value;
107    totalSupply -= _value;
108    emit Burn(msg.sender, _value);
109    return true;
110  }
111  
112   function burnFrom(address _from, uint256 _value) public returns (bool success) {
113    require(_balances[_from] >= _value);
114    require(_value <= _allowed[_from][msg.sender]);
115    _balances[_from] -= _value;
116    _allowed[_from][msg.sender] -= _value;
117    totalSupply -= _value;
118    emit Burn(_from, _value);
119    return true;
120  }
121  
122   function _transfer(address _from, address _to, uint _value) internal {
123  
124    require(_to != address(0x0));
125   
126    require(_balances[_from] >= _value);
127   
128    require(_balances[_to] + _value > _balances[_to]);
129   
130    uint previousBalances = _balances[_from] + _balances[_to];
131   
132    _balances[_from] -= _value;
133   
134    _balances[_to] += _value;
135    emit Transfer(_from, _to, _value);
136  
137    assert(_balances[_from] + _balances[_to] == previousBalances);
138  }
139  
140 }
141  
142 contract IOIToken is Token {
143  
144  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) public {
145    name = _name;
146    symbol = _symbol;
147    decimals = _decimals;
148    totalSupply = _initialSupply * 10 ** uint256(decimals);
149    _balances[msg.sender] = totalSupply;
150  }
151  
152   fallback() external payable {
153    revert();
154  }
155  
156   receive() external payable{
157    revert();
158  }
159  
160 }
161  
162 contract IOI is IOIToken {
163  
164  constructor() IOIToken ("IOI Token ", "IOI", 6, 100000000) public {}
165  
166 }